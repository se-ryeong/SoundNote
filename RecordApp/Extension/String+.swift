//
//  String+.swift
//  RecordApp
//
//  Created by se-ryeong on 1/11/24.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
