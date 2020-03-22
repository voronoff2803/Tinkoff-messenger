//
//  Message.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 22.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    var content: String
    var created: Date
    var senderID: String
    var senderName: String
    var id: String?
    
    var toDict: [String: Any] {
         return ["content": content,
                 "created": Timestamp(date: created),
                 "senderID": senderID,
                 "senderName": senderName]
    }
    
    func isIncoming() -> Bool {
        return GlobalConfig.shared.myID != senderID
    }
}
