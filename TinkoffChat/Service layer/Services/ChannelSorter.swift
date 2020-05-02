//
//  ChannelSorter.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 01.05.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import UIKit

protocol IChannelSorter {
    func sortByDate(_ channels: [Channel], ascending: Bool) -> [Channel]
    func sortByOnlineStatus(_ channels: [Channel], ascending: Bool) -> [Channel]
}

class ChannelSorter: IChannelSorter {
    
    func sortByDate(_ channels: [Channel], ascending: Bool) -> [Channel] {
        let sortedChannels = channels.sorted(by: { (channel1, channel2) -> Bool in
            guard let lastActivity1 = channel1.lastActivity,
                let lastActivity2 = channel2.lastActivity else { return true }
            if ascending {
                return lastActivity1 > lastActivity2
            } else {
                return lastActivity1 < lastActivity2
            }
        })
        if ascending {
            return sortedChannels
        } else {
            return sortedChannels.sorted(by: { (channel1, channel2) -> Bool in
                return channel1.lastActivity != nil || channel2.lastActivity != nil
            })
        }
    }
    
    func sortByOnlineStatus(_ channels: [Channel], ascending: Bool) -> [Channel] {
        let date: Date = Date(timeIntervalSinceNow: -600)
        return channels.filter({ channel -> Bool in
            if let lastActivity = channel.lastActivity {
                if ascending {
                    return lastActivity > date
                } else {
                    return lastActivity < date
                }
            }
            return !ascending
        })
    }
}


