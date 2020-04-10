//
//  MessageCellModel.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

struct MessageeCellModel {
    let name: String
    let text: String
    let date: Date?
    let isIncoming: Bool
    
    var stringDate: String? {
        guard let date = date else { return nil }
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
