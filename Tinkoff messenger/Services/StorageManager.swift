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
    
    func saveChannels(simpleChannels: [ChannelSimple],completion: @escaping (String?) -> ()) {
        
        let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
        
        let channels = try? self.mainManagedObjectContext.fetch(fetchRequest)
        
        
        privateManagedObjectContext.perform {
            for simpleChannel in simpleChannels {
                if let existChannel = channels?.first(where: {$0.identifier == simpleChannel.identifier}) {
                    existChannel.id = simpleChannel.id
                    existChannel.lastActivity = simpleChannel.lastActivity
                    existChannel.lastMessage = simpleChannel.lastMessage
                    existChannel.name = simpleChannel.name
                } else if simpleChannel {
                    
                } else {
                    let channel = Channel(context: self.privateManagedObjectContext)
                    channel.id = simpleChannel.id
                    channel.identifier = simpleChannel.identifier
                    channel.lastActivity = simpleChannel.lastActivity
                    channel.lastMessage = simpleChannel.lastMessage
                    channel.name = simpleChannel.name
                    self.privateManagedObjectContext.insert(channel)
                }
            }
            
            for channel in channels ?? [] {
                if let simpleChannel = simpleChannels.first(where: {$0.identifier == channel.identifier}) {
                    channel.id = simpleChannel.id
                    channel.lastActivity = simpleChannel.lastActivity
                    channel.lastMessage = simpleChannel.lastMessage
                    channel.name = simpleChannel.name
                } else if 
            }
            do {
                try self.privateManagedObjectContext.save()
                completion(nil)
            } catch {
                print(error.localizedDescription)
                completion(error.localizedDescription)
            }
        }
    }
    
    func loadChannels(completion: @escaping ([ChannelSimple]) -> ()) {
        mainManagedObjectContext.perform {
            let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
            let channels = try? self.mainManagedObjectContext.fetch(fetchRequest)
            var simpleChannels: [ChannelSimple] = []
            for channel in channels ?? [] {
                let simpleChannel = ChannelSimple(id: channel.id, name: channel.name, identifier: channel.identifier, lastMessage: channel.lastMessage, lastActivity: channel.lastActivity)
                simpleChannels.append(simpleChannel)
            }
            completion(simpleChannels)
        }
    }
}
