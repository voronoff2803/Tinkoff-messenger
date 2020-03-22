//
//  FirebaseWorker.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 22.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
 
class FirebaseWorker: WorkerProtocol {
    lazy var db = Firestore.firestore()
    
    func getChannels(channelListener: @escaping (_ channels: [Channel])->()) {
        let reference = db.collection("channels")
        
        reference.addSnapshotListener {snapshot, error in
            guard let ar = snapshot?.documents else { return }
            
            var channels: [Channel] = []
            
            for i in ar {
                let dict = i.data()
                
                guard let name = dict["name"] as? String else { continue }
                guard let identifier = dict["identifier"] as? String else { continue }
                let lastMessage = dict["lastMessage"] as? String
                let lastActivity = (dict["lastActivity"] as? Timestamp)?.dateValue()
                let id = i.documentID
                
                let channel = Channel(id: id, name: name, identifier: identifier, lastMessage: lastMessage, lastActivity: lastActivity)
                
                channels.append(channel)
            }
            print(channels)
            channelListener(channels)
        }
    }
    
    func getMessages(channelIdentifier: String, messageListener: @escaping (_ messages: [Message])->()) {
        let reference = db.collection("channels").document(channelIdentifier).collection("messages")
        
        reference.addSnapshotListener {snapshot, error in
            guard let ar = snapshot?.documents else { return }
            
            var messages: [Message] = []
            
            for i in ar {                
                let dict = i.data()
                
                guard let content = dict["content"] as? String else { continue }
                guard let created = (dict["created"] as? Timestamp)?.dateValue() else { continue }
                guard let senderID = dict["senderID"] as? String else { continue }
                guard let senderName = dict["senderName"] as? String else { continue }
                let id = i.documentID
                
                let message = Message(content: content, created: created, senderID: senderID, senderName: senderName, id: id)
                
                messages.append(message)
            }
            
            messageListener(messages)
        }
    }
    
    func addChannel(name: String) {
        print("создаю \(name)")
        let channel = Channel(name: name)
        
        let reference = db.collection("channels")
        
        print(channel.toDict)
        
        reference.addDocument(data: channel.toDict)
    }
    
    func addMessage(channelIdentifier: String, content: String) {
        let reference: CollectionReference = {
            return db.collection("channels").document(channelIdentifier).collection("messages")
         }()
        let id = GlobalConfig.shared.myID
        let name = GlobalConfig.shared.myName
        
        let newMessage = Message(content: content, created: Date(), senderID: id, senderName: name)
        
        reference.addDocument(data: newMessage.toDict)
    }
}

