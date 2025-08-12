//
//  UISlider+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UISlider {
    /// 设置当前值
    @discardableResult
    func value(_ value: Float) -> Self {
        base.value = max(base.minimumValue, min(base.maximumValue, value))
        return self
    }
    /// 设置最小值
    @discardableResult
    func minimumValue(_ minimumValue: Float) -> Self {
        base.minimumValue = minimumValue
        // 确保当前值不小于最小值
        if base.value < minimumValue {
            base.value = minimumValue
        }
        return self
    }
    /// 设置最大值
    @discardableResult
    func maximumValue(_ maximumValue: Float) -> Self {
        base.maximumValue = maximumValue
        // 确保当前值不大于最大值
        if base.value > maximumValue {
            base.value = maximumValue
        }
        return self
    }
    /// 设置最小值图片
    @discardableResult
    func minimumValueImage(_ minimumValueImage: UIImage?) -> Self {
        base.minimumValueImage = minimumValueImage
        return self
    }
    /// 设置最大值图片
    @discardableResult
    func maximumValueImage(_ maximumValueImage: UIImage?) -> Self {
        base.maximumValueImage = maximumValueImage
        return self
    }
    /// 设置是否连续触发
    @discardableResult
    func isContinuous(_ isContinuous: Bool) -> Self {
        base.isContinuous = isContinuous
        return self
    }
    /// 设置最小轨道色调颜色
    @discardableResult
    func minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> Self {
        base.minimumTrackTintColor = minimumTrackTintColor
        return self
    }
    /// 设置最大轨道色调颜色
    @discardableResult
    func maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> Self {
        base.maximumTrackTintColor = maximumTrackTintColor
        return self
    }
    /// 设置拇指色调颜色
    @discardableResult
    func thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        base.thumbTintColor = thumbTintColor
        return self
    }
}
