//
//  IChannelsSorter.swift
//  Tinkoff messenger
//
//  Created by Alexey on 12.05.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation

protocol IChannelsSorter {
    func sortByStatus(_ channels: [ChannelSimple]) -> [ChannelSimple]
    func sortByDate(_ channels: [ChannelSimple]) -> [ChannelSimple]
}
