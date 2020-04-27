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
    
    var objectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else { return nil }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
        return model
    }()
    
    var persistanceStoreURL: URL? = {
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
    
    func saveChannels(simpleChannels: [ChannelSimple]) {
        
        let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
        
        let channels = try? self.privateManagedObjectContext.fetch(fetchRequest)
        
        
        privateManagedObjectContext.perform {
            // Удаляем каналы которых больше нет
            for channel in channels ?? [] {
                if !simpleChannels.contains(where: {$0.id == channel.id}) {
                    self.privateManagedObjectContext.delete(channel)
                }
            }
            
            // Добавляем новые каналы и Обновляем старые каналы
            for simpleChannel in simpleChannels {
                if !(channels?.contains(where: {$0.id == simpleChannel.id}) ??  true) {
                    self.simpleChannelAddToContext(simpleChannel: simpleChannel)
                } else {
                    if let channel = channels?.first(where: {$0.id == simpleChannel.id}) {
                        channel.identifier = simpleChannel.identifier
                        channel.lastActivity = simpleChannel.lastActivity
                        channel.lastMessage = simpleChannel.lastMessage
                        channel.name = simpleChannel.name
                    }
                }
            }
            do {
                try self.privateManagedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadChannels(completion: @escaping ([ChannelSimple]) -> ()) {
        mainManagedObjectContext.perform {
            let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
            let channels = try? self.mainManagedObjectContext.fetch(fetchRequest)
            var simpleChannels: [ChannelSimple] = []
            for channel in channels ?? [] {
                let simpleChannel = self.channelToSimpleChannel(channel: channel)
                simpleChannels.append(simpleChannel)
            }
            completion(simpleChannels)
        }
    }
    
    func saveMessages(simpleMessages: [MessageSimple], channelId: String) {
        let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
        let channels = try? self.privateManagedObjectContext.fetch(fetchRequest)
        
        privateManagedObjectContext.perform {
            if let channel = channels?.first(where: {$0.id == channelId}) {
                if let messages = channel.messages as? Set<Message> {
                    for simpleMessage in simpleMessages {
                        if !messages.contains(where: {$0.id == simpleMessage.id}) {
                            channel.addToMessages(self.simpleMessageToMessage(simpleMessage: simpleMessage))
                        }
                    }
                }
            }
            do {
                try self.privateManagedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMessages(channelId: String, completion: @escaping ([MessageSimple]) -> ()) {
        mainManagedObjectContext.perform {
            let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
            let channels = try? self.mainManagedObjectContext.fetch(fetchRequest)
            if let channel = channels?.first(where: {$0.id == channelId}) {
                if let messages = channel.messages as? Set<Message> {
                    var simpleMessages: [MessageSimple] = []
                    messages.forEach({simpleMessages.append(self.messageToSimpleMessage(message: $0))})
                    completion(simpleMessages)
                }
            }
        }
    }
    
    func simpleChannelAddToContext(simpleChannel: ChannelSimple) {
        let channel = NSEntityDescription.insertNewObject(forEntityName: "Channel", into: self.privateManagedObjectContext) as! Channel
        channel.id = simpleChannel.id
        channel.identifier = simpleChannel.identifier
        channel.lastActivity = simpleChannel.lastActivity
        channel.lastMessage = simpleChannel.lastMessage
        channel.name = simpleChannel.name
    }
    
    func channelToSimpleChannel(channel: Channel) -> ChannelSimple {
        let simpleChannel = ChannelSimple(id: channel.id, name: channel.name, identifier: channel.identifier, lastMessage: channel.lastMessage, lastActivity: channel.lastActivity)
        return simpleChannel
    }
    
    func simpleMessageToMessage(simpleMessage: MessageSimple) -> Message {
        let message = Message(context: self.privateManagedObjectContext)
        message.id = simpleMessage.id
        message.content = simpleMessage.content
        message.created = simpleMessage.created
        message.senderID = simpleMessage.senderID
        message.senderName = simpleMessage.senderName
        return message
    }
    
    func messageToSimpleMessage(message: Message) -> MessageSimple {
        let simpleMessage = MessageSimple(content: message.content ?? "", created: message.created ?? Date(), senderID: message.senderID ?? "", senderName: message.senderName ?? "", id: message.id)
        return simpleMessage
    }
}
