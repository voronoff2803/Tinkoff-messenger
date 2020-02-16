//
//  AppDelegate.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 16.02.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        printForTask("not running", "inactive", #function)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        printForTask("active", "inactive", #function)
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printForTask("inactive", "active", #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        printForTask("inactive", "background", #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        printForTask("background", "inactive", #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        printForTask("background", "suspended", #function)
    }
    
    func printForTask(_ from: String, _ to: String, _ method: String) {
        #if DEBUG
        print("Application moved from \(from) to \(to): \(method)")
        #endif
    }
}

