//
//  HasFont.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public protocol HasFont {
    
    func set(font: UIFont)
}

extension UILabel: HasFont {
    
    public func set(font: UIFont) {
        self.font = font
    }
}

extension UIButton: HasFont {
    
    public func set(font: UIFont) {
        self.titleLabel?.font = font
    }
}

extension UITextField: HasFont {
    
    public func set(font: UIFont) {
        self.font = font
    }
}

extension UITextView: HasFont {
    
    public func set(font: UIFont) {
        self.font = font
    }
}
