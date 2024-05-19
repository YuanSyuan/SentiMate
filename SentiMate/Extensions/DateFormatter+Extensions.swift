//
//  DateFormatter+Extensions.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/16.
//

import Foundation
extension DateFormatter {
    static let diaryEntryFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
