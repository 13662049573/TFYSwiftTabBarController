//
//  UIProgressView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UIProgressView {
    /// 设置进度值
    @discardableResult
    func progress(_ progress: Float) -> Self {
        base.progress = max(0.0, min(1.0, progress))
        return self
    }
    /// 设置进度视图样式
    @discardableResult
    func progressViewStyle(_ progressViewStyle: UIProgressView.Style) -> Self {
        base.progressViewStyle = progressViewStyle
        return self
    }
    /// 设置进度色调颜色
    @discardableResult
    func progressTintColor(_ progressTintColor: UIColor?) -> Self {
        base.progressTintColor = progressTintColor
        return self
    }
    /// 设置轨道色调颜色
    @discardableResult
    func trackTintColor(_ trackTintColor: UIColor?) -> Self {
        base.trackTintColor = trackTintColor
        return self
    }
    /// 设置进度图片
    @discardableResult
    func progressImage(_ progressImage: UIImage?) -> Self {
        base.progressImage = progressImage
        return self
    }
    /// 设置轨道图片
    @discardableResult
    func trackImage(_ trackImage: UIImage?) -> Self {
        base.trackImage = trackImage
        return self
    }
}
