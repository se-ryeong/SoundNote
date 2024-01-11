//
//  UIFont+.swift
//  RecordApp
//
//  Created by se-ryeong on 2023/12/28.
//

import UIKit

extension UIFont {
    
    class var title: UIFont {
        return pretendard(size: 18, weight: .regular)
    }
    
    class var body1: UIFont {
        return pretendard(size: 13, weight: .regular)
    }
    
    class var body2: UIFont {
        return pretendard(size: 16, weight: .medium)
    }
    
    class var title2: UIFont {
        return Prata(size: 24, weight: .regular)
    }
    
    class var title3: UIFont {
        return PTMono(size: 18, weight: .bold)
    }
}

// MARK: - Pretendard
extension UIFont {
    enum PretendardWeight: String {
        case regular = "Regular"
        case medium = "Medium"
    }

    static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        return UIFont(name: "Pretendard-\(weight.rawValue)", size: size)!
    }
}

// MARK: - Prata
extension UIFont {
    enum PrataWeight: String {
        case regular = "Regular"
    }
    
    static func Prata(size: CGFloat, weight: PrataWeight) -> UIFont {
        return UIFont(name: "Prata-\(weight.rawValue)", size: size)!
    }
}

// MARK: - PT Mono
extension UIFont {
    enum PTMonoWeight: String {
        case bold = "Bold"
    }
    
    static func PTMono(size: CGFloat, weight: PTMonoWeight) -> UIFont {
        return UIFont(name: "PT Mono-\(weight.rawValue)", size: size)!
    }
}
