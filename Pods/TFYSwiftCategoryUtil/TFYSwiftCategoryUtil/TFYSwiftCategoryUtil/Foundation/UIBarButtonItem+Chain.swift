//
//  UIBarButtonItem+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit
import Foundation

public extension TFY where Base: UIBarButtonItem {
    /// 设置宽度（>=0）
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        base.width = max(0, width)
        return self
    }
    /// 设置tintColor
    @discardableResult
    func tintColor(_ tintColor: UIColor?) -> Self {
        base.tintColor = tintColor
        return self
    }
}
