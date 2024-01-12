//
//  UIView+AddSubViews.swift
//  RecordApp
//
//  Created by se-ryeong on 12/30/23.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
