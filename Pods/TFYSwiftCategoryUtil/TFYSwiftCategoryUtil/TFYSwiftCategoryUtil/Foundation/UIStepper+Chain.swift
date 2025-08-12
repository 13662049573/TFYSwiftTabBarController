//
//  UIStepper+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UIStepper {
    /// 设置是否连续触发
    @discardableResult
    func isContinuous(_ isContinuous: Bool) -> Self {
        base.isContinuous = isContinuous
        return self
    }
    /// 设置是否自动重复
    @discardableResult
    func autorepeat(_ autorepeat: Bool) -> Self {
        base.autorepeat = autorepeat
        return self
    }
    /// 设置是否循环
    @discardableResult
    func wraps(_ wraps: Bool) -> Self {
        base.wraps = wraps
        return self
    }
    /// 设置当前值
    @discardableResult
    func value(_ value: Double) -> Self {
        base.value = max(base.minimumValue, min(base.maximumValue, value))
        return self
    }
    /// 设置最小值
    @discardableResult
    func minimumValue(_ minimumValue: Double) -> Self {
        base.minimumValue = minimumValue
        // 确保当前值不小于最小值
        if base.value < minimumValue {
            base.value = minimumValue
        }
        return self
    }
    /// 设置最大值
    @discardableResult
    func maximumValue(_ maximumValue: Double) -> Self {
        base.maximumValue = maximumValue
        // 确保当前值不大于最大值
        if base.value > maximumValue {
            base.value = maximumValue
        }
        return self
    }
    /// 设置步进值
    @discardableResult
    func stepValue(_ stepValue: Double) -> Self {
        base.stepValue = max(0, stepValue)
        return self
    }
    /// 设置背景图片
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State...) -> Self {
        state.forEach { base.setBackgroundImage(image, for: $0) }
        return self
    }
    /// 设置分割线图片
    @discardableResult
    func dividerImage(_ image: UIImage?,
                      forLeftSegmentState leftState: UIControl.State,
                      rightSegmentState rightState: UIControl.State) -> Self {
        base.setDividerImage(image, forLeftSegmentState: leftState, rightSegmentState: rightState)
        return self
    }
    /// 设置增加按钮图片
    @discardableResult
    func incrementImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        base.setIncrementImage(image, for: state)
        return self
    }
    /// 设置减少按钮图片
    @discardableResult
    func decrementImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        base.setDecrementImage(image, for: state)
        return self
    }
}
