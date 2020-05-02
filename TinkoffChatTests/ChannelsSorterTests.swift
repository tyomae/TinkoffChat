//
//  ChannelsSorterTests.swift
//  TinkoffChatTests
//
//  Created by Артем  Емельянов  on 01.05.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//
import Foundation
import XCTest


class ChannelsSorterTests: XCTestCase {
    
    private var channelSorter: IChannelSorter!
    
    // Given
    private let channel1 = Channel(identifier: "1",
                           name: "channel1",
                           lastMessage: "lastMessage",
                           lastActivity: nil)
    private let channel2 = Channel(identifier: "2",
                           name: "channel2",
                           lastMessage: "lastMessage",
                           lastActivity: Date(timeIntervalSinceNow: -1200)) //1200 сек/ 60 сек = 20 минут
    private let channel3 = Channel(identifier: "3",
                           name: "channel3",
                           lastMessage: "lastMessage",
                           lastActivity: Date(timeIntervalSinceNow: -300)) //300 сек/60сек = 5 минут
    private let channel4 = Channel(identifier: "4",
                           name: "channel4",
                           lastMessage: "lastMessage",
                           lastActivity: Date(timeIntervalSinceNow: +600)) //600 сек/60сек = 10 минут
    
    override func setUp() {
        channelSorter = ChannelSorter()
    }
    
    func testSortingByDate() {
        
        let expectedResult = [channel4, channel3, channel2, channel1]
        let unsorted = [channel1, channel3, channel4, channel2]
        
        // When
        let result = channelSorter.sortByDate(unsorted, ascending: true)
        
        // Then
        XCTAssertEqual(expectedResult, result)
    }
    
    func testSortingByOnlineStatus() {
        
        let onlineChannel = [channel3, channel4]
        let unsorted = [channel1, channel2, channel3, channel4]
               
               // When
        let resultOnline = channelSorter.sortByOnlineStatus(unsorted, ascending: true)
               // Then
        XCTAssertEqual(onlineChannel, resultOnline)
    }
    
    func testSortingByHistoryStatus() {
        
        let historyChannel = [channel1, channel2]
        let unsorted = [channel1, channel2, channel3, channel4]
               
               // When
        let resultHistory = channelSorter.sortByOnlineStatus(unsorted, ascending: false)
               // Then
        XCTAssertEqual(historyChannel, resultHistory)
    }
    
}
