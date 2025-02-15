//
//  HasFont+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: HasFont {
    
    @discardableResult
    func font(_ font: UIFont) -> TFY {
        base.set(font: font)
        return self
    }
    
    @discardableResult
    func systemFont(ofSize fontSize: CGFloat) -> TFY {
        base.set(font: UIFont.systemFont(ofSize: fontSize))
        return self
    }
    
    @discardableResult
    func boldSystemFont(ofSize fontSize: CGFloat) -> TFY {
        base.set(font: UIFont.boldSystemFont(ofSize: fontSize))
        return self
    }
    
    @discardableResult
    func systemFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> TFY {
        base.set(font: UIFont.systemFont(ofSize: fontSize, weight: weight))
        return self
    }
}
