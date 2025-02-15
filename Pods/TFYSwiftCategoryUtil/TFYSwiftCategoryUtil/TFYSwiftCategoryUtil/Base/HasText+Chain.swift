//
//  HasText.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: HasText {
    
    @discardableResult
    func text(_ text: String?) -> TFY {
        base.set(text: text)
        return self
    }
    
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> TFY {
        base.set(attributedText: attributedText)
        return self
    }
    
    @discardableResult
    func textColor(_ textColor: UIColor) -> TFY {
        base.set(color: textColor)
        return self
    }
    
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> TFY {
        base.set(alignment: textAlignment)
        return self
    }
}
