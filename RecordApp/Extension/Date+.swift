//
//  Date+.swift
//  RecordApp
//
//  Created by se-ryeong on 1/26/24.
//

import Foundation

enum DateStyle {
    /// "YYYY. MM. dd"
    case fullDateWithDot
    /// "YYYY-MM-dd"
    case fullDateWithHipen
    /// "YYYY-MM"
    case yearMonthWithHipen
    /// "MM. dd"
    case monthDayWithDot
    /// MMM
    case month
    /// MM월 dd일
    case monthDay
    
    var formatted: String {
        switch self {
        case .fullDateWithDot:
            return "YYYY. MM. dd"
        case .fullDateWithHipen:
            return "YYYY-MM-dd"
        case .yearMonthWithHipen:
            return "YYYY-MM"
        case .monthDayWithDot:
            return "MM. dd"
        case .month:
            return "MMM"
        case .monthDay:
            return "MM월 dd일"
        }
    }
}

extension Date {
    // MARK: - 방법2
//    func formatted(format: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        
//        return formatter.string(from: self)
//    }
//    
    func formatted(style: DateStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style.formatted
        
        return formatter.string(from: self)
    }
}


