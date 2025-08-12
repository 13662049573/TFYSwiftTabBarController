//
//  UIPickerView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UIPickerView {
    /// 设置数据源
    @discardableResult
    func dataSource(_ dataSource: UIPickerViewDataSource?) -> Self {
        base.dataSource = dataSource
        return self
    }
    /// 设置代理
    @discardableResult
    func delegate(_ delegate: UIPickerViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
}
