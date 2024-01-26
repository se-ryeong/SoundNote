//
//  Date+.swift
//  RecordApp
//
//  Created by se-ryeong on 1/26/24.
//

import Foundation

extension Date {
    
    /// date타입을 String으로 변환해주는 함수
    /// - Returns: /// YYYY-MM-dd 형식 String
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        return formatter.string(from: self)
    }
    
    /// YYYY-MM 형식 formatted
    func formattedWithMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM"
        
        return formatter.string(from: self)
    }
}
