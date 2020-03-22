//
//  ViewController.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 16.02.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        printForTask("disappeared", "appearing", #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        printForTask("appearing", "appeared", #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        printForTask("layouted", "layouting", #function)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        printForTask("layouting", "layouted", #function)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        printForTask("appeared", "disappearing", #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        printForTask("disappearing", "disappeared", #function)
    }
    
    func printForTask(_ from: String, _ to: String, _ method: String) {
        
        #if DEBUG
        print("ViewController moved from \(from) to \(to): \(method)")
        #endif
    }


}
