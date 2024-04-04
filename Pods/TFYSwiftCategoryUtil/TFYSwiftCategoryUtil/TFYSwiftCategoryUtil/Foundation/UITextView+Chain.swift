//
//  UITextView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UITextView {
    
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate?) -> TFY {
        base.delegate = delegate
        return self
    }
    
    @discardableResult
    func isEditable(_ isEditable: Bool) -> TFY {
        base.isEditable = isEditable
        return self
    }
    
    @discardableResult
    func isSelectable(_ isSelectable: Bool) -> TFY {
        base.isSelectable = isSelectable
        return self
    }
    
    @discardableResult
    func textContainerInset(_ textContainerInset: UIEdgeInsets) -> TFY {
        base.textContainerInset = textContainerInset
        return self
    }
    
    @discardableResult
    func dataDetectorTypes(_ dataDetectorTypes: UIDataDetectorTypes) -> TFY {
        base.dataDetectorTypes = dataDetectorTypes
        return self
    }
    
    @discardableResult
    func allowsEditingTextAttributes(_ allowsEditingTextAttributes: Bool) -> TFY {
        base.allowsEditingTextAttributes = allowsEditingTextAttributes
        return self
    }
    
    @discardableResult
    func keyboardType(_ keyboardType: UIKeyboardType) -> TFY {
        base.keyboardType = keyboardType
        return self
    }
    
    @discardableResult
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> TFY {
        base.returnKeyType = returnKeyType
        return self
    }
    
    @discardableResult
    func typingAttributes(attributes b:[NSAttributedString.Key : Any]) -> TFY {
        base.typingAttributes = b
        return self
    }
    
    @discardableResult
    func textContainerInset(containerInset c: UIEdgeInsets) -> TFY {
        base.textContainerInset = c
        return self
    }
    
    @discardableResult
    func dataDetectorTypes(detectorTypes d: UIDataDetectorTypes) -> TFY {
        base.dataDetectorTypes = d
        return self
    }
}

