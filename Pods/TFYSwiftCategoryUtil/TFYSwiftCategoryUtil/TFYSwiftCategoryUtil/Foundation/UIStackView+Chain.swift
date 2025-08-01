//
//  UIStackView+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit

public extension TFY where Base: UIStackView {
    /// 添加排列子视图
    @discardableResult
    func addArranged(subview view: UIView) -> Self {
        base.addArrangedSubview(view)
        return self
    }
    /// 移除排列子视图
    @discardableResult
    func removeArranged(subview view: UIView) -> Self {
        base.removeArrangedSubview(view)
        return self
    }
    /// 在指定位置插入排列子视图
    @discardableResult
    func insertArranged(subview view: UIView, at:Int) -> Self {
        let index = max(0, min(at, base.arrangedSubviews.count))
        base.insertArrangedSubview(view, at: index)
        return self
    }
    /// 设置排列轴方向
    @discardableResult
    func axis(_ a: NSLayoutConstraint.Axis) -> Self {
        base.axis = a
        return self
    }
    /// 设置分布方式
    @discardableResult
    func distribution(_ a: UIStackView.Distribution) -> Self {
        base.distribution = a
        return self
    }
    /// 设置对齐方式
    @discardableResult
    func alignment(_ a: UIStackView.Alignment) -> Self {
        base.alignment = a
        return self
    }
    /// 设置间距
    @discardableResult
    func spacing(_ a: CGFloat) -> Self {
        base.spacing = max(0, a)
        return self
    }
    /// 设置自定义间距（iOS 11.0+）
    @discardableResult
    @available(iOS 11.0, *)
    func custom(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
        base.setCustomSpacing(max(0, spacing), after: arrangedSubview)
        return self
    }
    /// 设置是否基于基线相对排列
    @discardableResult
    func isBaselineRelativeArrangement(_ a: Bool) -> Self {
        base.isBaselineRelativeArrangement = a
        return self
    }
    /// 设置是否基于布局边距相对排列
    @discardableResult
    func isLayoutMarginsRelativeArrangement(_ a: Bool) -> Self {
        base.isLayoutMarginsRelativeArrangement = a
        return self
    }
}
