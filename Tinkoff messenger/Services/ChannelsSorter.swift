//
//  ChannelsSorter.swift
//  Tinkoff messenger
//
//  Created by Alexey on 12.05.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation

class ChannelsSorter: IChannelsSorter {
    func sortByDate(_ channels: [ChannelSimple]) -> [ChannelSimple] {
        return channels.sorted(by: {$0.lastActivity! > $1.lastActivity!})
    }
    
    func sortByStatus(_ channels: [ChannelSimple]) -> [ChannelSimple] {
        return channels.filter({$0.isActive()}) + channels.filter({!$0.isActive()})
    }
}
