//
//  UISegmentedControl+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UISegmentedControl {
    /// 设置指定段的标题
    @discardableResult
    func title(_ title: String?, forSegmentAt segment: Int) -> Self {
        guard segment >= 0, segment < base.numberOfSegments else { return self }
        base.setTitle(title, forSegmentAt: segment)
        return self
    }
    /// 设置指定段的图片
    @discardableResult
    func image(_ image: UIImage?, forSegmentAt segment: Int) -> Self {
        guard segment >= 0, segment < base.numberOfSegments else { return self }
        base.setImage(image, forSegmentAt: segment)
        return self
    }
    /// 设置指定段的宽度
    @discardableResult
    func width(_ width: CGFloat, forSegmentAt segment: Int) -> Self {
        guard segment >= 0, segment < base.numberOfSegments else { return self }
        base.setWidth(max(0, width), forSegmentAt: segment)
        return self
    }
    /// 设置指定段的内容偏移
    @discardableResult
    func contentOffset(_ offset: CGSize, forSegmentAt segment: Int) -> Self {
        guard segment >= 0, segment < base.numberOfSegments else { return self }
        base.setContentOffset(offset, forSegmentAt: segment)
        return self
    }
    /// 设置指定段是否启用
    @discardableResult
    func enabled(_ enabled: Bool, forSegmentAt segment: Int) -> Self {
        guard segment >= 0, segment < base.numberOfSegments else { return self }
        base.setEnabled(enabled, forSegmentAt: segment)
        return self
    }
    /// 设置选中的段索引
    @discardableResult
    func selectedSegmentIndex(_ selectedSegmentIndex: Int) -> Self {
        let index = max(-1, min(selectedSegmentIndex, base.numberOfSegments - 1))
        base.selectedSegmentIndex = index
        return self
    }
    /// 设置背景图片
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State..., barMetrics: UIBarMetrics) -> Self {
        state.forEach { base.setBackgroundImage(backgroundImage, for: $0, barMetrics: barMetrics) }
        return self
    }
    /// 设置分割线图片
    @discardableResult
    func dividerImage(_ dividerImage: UIImage?,
                      forLeftSegmentState leftState: UIControl.State,
                      rightSegmentState rightState: UIControl.State,
                      barMetrics: UIBarMetrics) -> Self {
        base.setDividerImage(dividerImage, forLeftSegmentState: leftState, rightSegmentState: rightState, barMetrics: barMetrics)
        return self
    }
    /// 设置标题文本属性
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State...) -> Self {
        state.forEach { base.setTitleTextAttributes(attributes, for: $0) }
        return self
    }
    /// 设置内容位置调整
    @discardableResult
    func contentPositionAdjustment(_ adjustment: UIOffset,
                                   forSegmentType leftCenterRightOrAlone: UISegmentedControl.Segment,
                                   barMetrics: UIBarMetrics) -> Self {
        base.setContentPositionAdjustment(adjustment, forSegmentType: leftCenterRightOrAlone, barMetrics: barMetrics)
        return self
    }
}
