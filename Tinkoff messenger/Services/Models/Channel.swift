//
//  Channel.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 22.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation


import Firebase

struct Channel {
    var id: String?
    var name: String
    var identifier: String?
    var lastMessage: String?
    var lastActivity: Date?
    
    var toDict: [String: Any] {
        return ["name": name,
                "lastActivity": Timestamp(date: Date()),
                "lastMessage": "Канал создан",
                "identifier": UUID().uuidString]
    }
    
    func isActive() -> Bool {
        let last1 = Date()
        guard let last2 = lastActivity?.addingTimeInterval(600) else { return false }
        return last1 < last2
    }
}
