//
//  StorageManager.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 05.04.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class StorageManager: DataSavable {
    
    lazy var objectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else { return nil }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
        return model
    }()
    
    lazy var persistanceStoreURL: URL? = {
        let storeName = "main.sqlite"
        let fileManager = FileManager.default
        guard let docDirURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        print(docDirURL.absoluteString)
        return docDirURL.appendingPathComponent(storeName)
    }()
    
    lazy var persistanceStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = self.objectModel else { return nil }
        guard let presistanceStoreURL = self.persistanceStoreURL else { return nil }
        
        let presistanceStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try presistanceStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: presistanceStoreURL, options: options)
        } catch {
           print(error)
        }
        
        return presistanceStoreCoordinator
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistanceStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateManagedObjectContext
        return managedObjectContext
    }()
    
    
    func saveData(name: String?, description: String?, image: UIImage?, completion: @escaping (String?) -> ()) {
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "Profile")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try privateManagedObjectContext.execute(deleteRequest)
            try privateManagedObjectContext.save()
        } catch {
            print(error.localizedDescription)
            completion(error.localizedDescription)
        }
        
        privateManagedObjectContext.perform {
            let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: self.privateManagedObjectContext) as! Profile
            if let name = name { profile.name = name }
            if let description = description { profile.bio = description }
            if let image = image { profile.image = image.jpegData(compressionQuality: 0.5) }
            
            
            do {
                try self.privateManagedObjectContext.save()
                completion(nil)
            } catch {
                print(error.localizedDescription)
                completion(error.localizedDescription)
            }
        }
    }
    
    func loadData(completion: @escaping (String?, String?, UIImage?) -> ()) {
        mainManagedObjectContext.perform {
            let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
            let profile = try? self.mainManagedObjectContext.fetch(fetchRequest).first
            var image: UIImage?
            if let imageData = profile?.image { image = UIImage(data: imageData)}
            completion(profile?.name, profile?.bio, image)
        }
    }
}
