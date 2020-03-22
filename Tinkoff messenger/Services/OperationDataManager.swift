//
//  OperationDataManager.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 15.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

class OperationDataManager: DataSavable {
    func saveData(name: String?, description: String?, image: UIImage?, completion: @escaping (String?) -> ()) {
        
        let saveQueue = OperationQueue()
        saveQueue.maxConcurrentOperationCount = 1
        
        let saveOperation = SaveData()
        
        saveOperation.saveName = name
        saveOperation.saveDescription = description
        saveOperation.image = image
        
        saveQueue.addOperation(saveOperation)
        saveQueue.addOperation {
            completion(saveOperation.error)
        }
    }
    
    func loadData(completion: @escaping (String?, String?, UIImage?) -> ()) {
        let loadQueue = OperationQueue()
        loadQueue.maxConcurrentOperationCount = 1
        
        let loadOperation = LoadData()
        
        loadQueue.addOperation(loadOperation)
        loadQueue.addOperation {
            guard let error = loadOperation.error else { completion(loadOperation.saveName, loadOperation.saveDescription, loadOperation.image); return }
            print(error)
        }
    }
}

class SaveData: Operation {
    var saveName: String?
    var saveDescription: String?
    var image: UIImage?
    var error: String?
    
    override func main() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            //sleep(1) // Искусственная задержка
            let nameFile = "name.txt"
            let descriptionFile = "description.txt"
            let imageFile = "image.png"
            
            let nameFileURL = dir.appendingPathComponent(nameFile)
            do {
                try saveName?.write(to: nameFileURL, atomically: false, encoding: .utf8)
            }
            catch { self.error = error.localizedDescription; return}
            
            let descriptionFileURL = dir.appendingPathComponent(descriptionFile)
            do {
                try saveDescription?.write(to: descriptionFileURL, atomically: false, encoding: .utf8)
            }
            catch { self.error = error.localizedDescription; return}
            
            let imageFileURL = dir.appendingPathComponent(imageFile)
            do {
                try image?.pngData()?.write(to: imageFileURL)
            }
            catch { self.error = error.localizedDescription; return}
        } else {
            self.error = "document folder error"
        }
    }
}


class LoadData: Operation {
    var saveName: String?
    var saveDescription: String?
    var image: UIImage?
    var error: String?
    
    override func main() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let nameFile = "name.txt"
            let descriptionFile = "description.txt"
            let imageFile = "image.png"
            
            let nameFileURL = dir.appendingPathComponent(nameFile)
            saveName = try? String(contentsOf: nameFileURL, encoding: .utf8)
            
            let descriptionFileURL = dir.appendingPathComponent(descriptionFile)
            saveDescription = try? String(contentsOf: descriptionFileURL, encoding: .utf8)
            
            let imageFileURL = dir.appendingPathComponent(imageFile)
            image = UIImage(contentsOfFile: imageFileURL.path)
            
        } else {
            error = "document folder error"
        }
    }
}
