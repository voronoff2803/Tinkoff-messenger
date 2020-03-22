//
//  DataSavable.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 15.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit


protocol DataSavable {
    func saveData(name: String?, description: String?, image: UIImage?, completion: @escaping (String?) -> ())
    func loadData(completion: @escaping (String?, String?, UIImage?) -> ())
}
