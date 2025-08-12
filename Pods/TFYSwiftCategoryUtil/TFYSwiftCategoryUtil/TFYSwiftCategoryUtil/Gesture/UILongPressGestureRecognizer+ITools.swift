//
//  UILongPressGestureRecognizer+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit

public extension TFY where Base == UILongPressGestureRecognizer {
    /// 设置手势识别器的委托
    @discardableResult
    func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    
    /// 设置手势识别器是否可用
    @discardableResult
    func enabled(_ enabled: Bool) -> Self {
        base.isEnabled = enabled
        return self
    }
    
    /// 设置是否在识别手势前取消触摸事件
    @discardableResult
    func cancelsTouchesInView(_ cancels: Bool) -> Self {
        base.cancelsTouchesInView = cancels
        return self
    }

    /// 设置是否延迟触摸开始
    @discardableResult
    func delaysTouchesBegan(_ delayeBegan: Bool) -> Self {
        base.delaysTouchesBegan = delayeBegan
        return self
    }
    
    /// 设置是否延迟触摸结束
    @discardableResult
    func delaysTouchesEnded(_ delayeEnded: Bool) -> Self {
        base.delaysTouchesEnded = delayeEnded
        return self
    }

    /// 设置允许的触摸类型
    @discardableResult
    func allowedTouchTypes(_ types: [NSNumber]) -> Self {
        guard !types.isEmpty else { return self }
        base.allowedTouchTypes = types
        return self
    }
    
    /// 设置允许的按压类型
    @discardableResult
    func allowedPressTypes(_ types: [NSNumber]) -> Self {
        guard !types.isEmpty else { return self }
        base.allowedPressTypes = types
        return self
    }

    /// 设置是否需要独占触摸类型
    @discardableResult
    func requiresExclusiveTouchType(_ requirs: Bool) -> Self {
        base.requiresExclusiveTouchType = requirs
        return self
    }

    /// 设置调试名称
    @discardableResult
    func name(_ name: String?) -> Self {
        base.name = name
        return self
    }

    /// 设置需要失败的手势
    @discardableResult
    func require(_ fail: UIGestureRecognizer) -> Self {
        base.require(toFail: fail)
        return self
    }
    
    /// 添加目标/动作
    @discardableResult
    func addTarget(_ target: Any, action: Selector) -> Self {
        guard let _ = target as? NSObjectProtocol else { return self }
        base.addTarget(target, action: action)
        return self
    }

    /// 移除目标/动作
    @discardableResult
    func removeTarget(_ target: Any?, action: Selector?) -> Self {
        base.removeTarget(target, action: action)
        return self
    }
    
    /// 设置需要的点击次数（>=0）
    @discardableResult
    func numberOfTapsRequired(_ number: Int) -> Self {
        base.numberOfTapsRequired = max(0, number)
        return self
    }

    /// 设置最小按压时长（>=0）
    @discardableResult
    func minimumPressDuration(_ duration: TimeInterval) -> Self {
        base.minimumPressDuration = max(0, duration)
        return self
    }

    /// 设置允许的最大移动距离（>=0）
    @discardableResult
    func allowableMovement(_ movement: CGFloat) -> Self {
        base.allowableMovement = max(0, movement)
        return self
    }
}

