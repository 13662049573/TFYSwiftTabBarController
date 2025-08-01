//
//  UIGestureRecognizer+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UIGestureRecognizer {
    /// 添加目标动作
    @discardableResult
    func addTarget(_ target: Any, action: Selector) -> Self {
        base.addTarget(target, action: action)
        return self
    }
    /// 设置代理
    @discardableResult
    func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    /// 设置是否启用
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }
}

public extension TFY where Base: UITapGestureRecognizer {
    /// 设置点击次数要求
    @discardableResult
    func numberOfTapsRequired(_ numberOfTapsRequired: Int) -> Self {
        base.numberOfTapsRequired = max(1, numberOfTapsRequired)
        return self
    }
    /// 设置触摸次数要求
    @discardableResult
    func numberOfTouchesRequired(_ numberOfTouchesRequired: Int) -> Self {
        base.numberOfTouchesRequired = max(1, numberOfTouchesRequired)
        return self
    }
}

public extension TFY where Base: UIPanGestureRecognizer {
    /// 设置最小触摸次数
    @discardableResult
    func minimumNumberOfTouches(_ minimumNumberOfTouches: Int) -> Self {
        base.minimumNumberOfTouches = max(1, minimumNumberOfTouches)
        return self
    }
    /// 设置最大触摸次数
    @discardableResult
    func maximumNumberOfTouches(_ maximumNumberOfTouches: Int) -> Self {
        base.maximumNumberOfTouches = max(1, maximumNumberOfTouches)
        return self
    }
}

public extension TFY where Base: UISwipeGestureRecognizer {
    /// 设置触摸次数要求
    @discardableResult
    func numberOfTouchesRequired(_ numberOfTouchesRequired: Int) -> Self {
        base.numberOfTouchesRequired = max(1, numberOfTouchesRequired)
        return self
    }
    /// 设置滑动方向
    @discardableResult
    func direction(_ direction: UISwipeGestureRecognizer.Direction) -> Self {
        base.direction = direction
        return self
    }
}

public extension TFY where Base: UIPinchGestureRecognizer {
    /// 设置缩放比例
    @discardableResult
    func scale(_ scale: CGFloat) -> Self {
        base.scale = max(0, scale)
        return self
    }
}

public extension TFY where Base: UILongPressGestureRecognizer {
    /// 设置点击次数要求
    @discardableResult
    func numberOfTapsRequired(_ numberOfTapsRequired: Int) -> Self {
        base.numberOfTapsRequired = max(0, numberOfTapsRequired)
        return self
    }
    /// 设置触摸次数要求
    @discardableResult
    func numberOfTouchesRequired(_ numberOfTouchesRequired: Int) -> Self {
        base.numberOfTouchesRequired = max(1, numberOfTouchesRequired)
        return self
    }
    /// 设置最小按压时长
    @discardableResult
    func minimumPressDuration(_ minimumPressDuration: CFTimeInterval) -> Self {
        base.minimumPressDuration = max(0, minimumPressDuration)
        return self
    }
    /// 设置允许的移动距离
    @discardableResult
    func allowableMovement(_ allowableMovement: CGFloat) -> Self {
        base.allowableMovement = max(0, allowableMovement)
        return self
    }
}

public extension TFY where Base: UIRotationGestureRecognizer {
    /// 设置旋转角度
    @discardableResult
    func rotation(_ rotation: CGFloat) -> Self {
        base.rotation = rotation
        return self
    }
}
