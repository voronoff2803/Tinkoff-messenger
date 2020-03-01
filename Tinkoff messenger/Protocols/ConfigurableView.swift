//
//  ConfigurableView.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 01.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
