//
//  Tinkoff_messengerTests.swift
//  Tinkoff messengerTests
//
//  Created by Alexey on 12.05.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import XCTest
import Foundation

final class ChannelSorterTests: XCTestCase {
    let sorter = ChannelsSorter()
    
    func testChannelsSorterDate() {
        var expectedResult: [ChannelSimple] = []
        for i in 1...20 {
            expectedResult.append(ChannelSimple(id: "", name: "", identifier: "", lastMessage: "", lastActivity: Date(timeIntervalSinceNow: -10.0 * Double(i))))
        }
        let unsorted = expectedResult.shuffled()
        
        let result = sorter.sortByDate(unsorted)
        
        XCTAssertEqual(expectedResult.map({$0.lastActivity}), result.map({$0.lastActivity}))
    }
    
    
    func testChannelsSorterStatus() {
        var expectedResult: [ChannelSimple] = []
        for _ in 1...50 {
            expectedResult.append(ChannelSimple(id: "", name: "", identifier: "", lastMessage: "", lastActivity: Date(timeIntervalSinceNow: 0.0 - Double.random(in: 1...600))))
        }
        for _ in 1...50 {
            expectedResult.append(ChannelSimple(id: "", name: "", identifier: "", lastMessage: "", lastActivity: Date(timeIntervalSinceNow: -600.0 - Double.random(in: 1...10000))))
        }
        let unsorted = expectedResult.shuffled()
        let result = sorter.sortByStatus(unsorted)
        
        XCTAssertEqual(expectedResult.map({$0.isActive()}), result.map({$0.isActive()}))
    }
}
