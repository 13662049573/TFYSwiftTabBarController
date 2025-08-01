//
//  UISwitch+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UISwitch {
    /// 设置开启状态的色调颜色
    @discardableResult
    func onTintColor(_ onTintColor: UIColor?) -> Self {
        base.onTintColor = onTintColor
        return self
    }
    /// 设置拇指色调颜色
    @discardableResult
    func thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        base.thumbTintColor = thumbTintColor
        return self
    }
    /// 设置开启状态图片
    @discardableResult
    func onImage(_ onImage: UIImage?) -> Self {
        base.onImage = onImage
        return self
    }
    /// 设置关闭状态图片
    @discardableResult
    func offImage(_ offImage: UIImage?) -> Self {
        base.offImage = offImage
        return self
    }
    /// 设置开关状态
    @discardableResult
    func isOn(_ isOn: Bool) -> Self {
        base.isOn = isOn
        return self
    }
    /// 设置色调颜色
    @discardableResult
    func tintColor(_ color:UIColor) -> Self {
        base.tintColor = color
        return self
    }
}
