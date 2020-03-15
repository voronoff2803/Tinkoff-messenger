//
//  GCDDataManager.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 15.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

class GCDDataManager: DataSavable {
    func saveData(name: String?, description: String?, image: UIImage?, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                sleep(1) // Искусственная задержка
                let nameFile = "name.txt"
                let descriptionFile = "description.txt"
                let imageFile = "image.png"
                
                let nameFileURL = dir.appendingPathComponent(nameFile)
                do {
                    try name?.write(to: nameFileURL, atomically: false, encoding: .utf8)
                }
                catch { completion(error.localizedDescription); return}
                
                let descriptionFileURL = dir.appendingPathComponent(descriptionFile)
                do {
                    try description?.write(to: descriptionFileURL, atomically: false, encoding: .utf8)
                }
                catch { completion(error.localizedDescription); return}
                
                let imageFileURL = dir.appendingPathComponent(imageFile)
                do {
                    try image?.pngData()?.write(to: imageFileURL)
                }
                catch { completion(error.localizedDescription); return}
                completion(nil)
            } else {
                completion("document folder error")
            }
        }
    }

    func loadData(completion: @escaping (String?, String?, UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let nameFile = "name.txt"
                let descriptionFile = "description.txt"
                let imageFile = "image.png"
                
                var name: String?
                var description: String?
                var image: UIImage?
                
                let nameFileURL = dir.appendingPathComponent(nameFile)
                name = try? String(contentsOf: nameFileURL, encoding: .utf8)
                
                let descriptionFileURL = dir.appendingPathComponent(descriptionFile)
                description = try? String(contentsOf: descriptionFileURL, encoding: .utf8)
                
                let imageFileURL = dir.appendingPathComponent(imageFile)
                image = UIImage(contentsOfFile: imageFileURL.path)
                
                completion(name, description, image)
            } else {
                completion(nil, nil, nil)
            }
        }
    }
}
