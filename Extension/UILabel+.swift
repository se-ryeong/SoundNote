//
//  UILabel+.swift
//  RecordApp
//
//  Created by se-ryeong on 2023/12/28.
//

import UIKit.UILabel

extension UILabel {
    func setLineHeight(_ lineHeight: CGFloat) {
        guard let text = text else {
            return
        }
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : style,
            .font : self.font as Any,
            .foregroundColor : self.textColor as Any,
            .baselineOffset : (lineHeight - self.font.lineHeight) / 4
        ]
        
        let attributeString = NSAttributedString(string: text,
                                                 attributes: attributes)
        
        self.attributedText = attributeString
    }
}
