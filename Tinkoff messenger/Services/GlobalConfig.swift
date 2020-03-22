//
//  GlobalConfig.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 22.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation


class GlobalConfig {
    static let shared = GlobalConfig()
    private init() {}
    
    var myID: String {
        get {
            if let id = UserDefaults.standard.string(forKey: "myID") {
                return id
            } else {
                let id = UUID().uuidString
                print("unic id: \(id)")
                UserDefaults.standard.set(id, forKey: "myID")
                return id
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "myID")
        }
    }
    
    var myName: String {
        get {
            return UserDefaults.standard.string(forKey: "myName") ?? "No name"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "myName")
        }
    }
}
