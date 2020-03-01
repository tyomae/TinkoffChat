//
//  ConfigurationCellModel.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
    
    var stringDate: String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }
        return dateFormatter.string(from: date)
    }
}
