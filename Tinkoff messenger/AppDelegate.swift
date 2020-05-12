//
//  AppDelegate.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 16.02.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let firestoreSettings = FirestoreSettings()
        firestoreSettings.isPersistenceEnabled = false
        Firestore.firestore().settings = firestoreSettings
        
        printForTask("not running", "inactive", #function)
        
        if #available(iOS 13.0, *) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(touch:)))
            window?.addGestureRecognizer(tapGesture)
        }
        
        return true
    }
    
    @objc func tapAction(touch: UITapGestureRecognizer) {
        let point = touch.location(in: touch.view?.window)
        let particle = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        particle.center = point
        particle.image = UIImage(named: "logo")
        UIView.animate(withDuration: 0.5, animations: {
            particle.alpha = 0.0
            particle.transform = CGAffineTransform(translationX: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
        }, completion: {_ in particle.removeFromSuperview()})
        window?.addSubview(particle)
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

