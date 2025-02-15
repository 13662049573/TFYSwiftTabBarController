//
//  UIBarButtonItem+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UIBarButtonItem {
    
    @discardableResult
    func width(_ width: CGFloat) -> TFY {
        base.width = width
        return self
    }
    
    @discardableResult
    func tintColor(_ tintColor: UIColor?) -> TFY {
        base.tintColor = tintColor
        return self
    }
}
