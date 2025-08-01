//
//  UIControl+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit
import Foundation

public extension TFY where Base: UIControl {
    /// 设置是否启用
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }
    /// 设置是否选中
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        base.isSelected = isSelected
        return self
    }
    /// 设置是否高亮
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> Self {
        base.isHighlighted = isHighlighted
        return self
    }
    /// 添加目标动作
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        base.addTarget(target, action: action, for: controlEvents)
        return self
    }
}

public extension UIControl {
    fileprivate struct AssociatedKeys {
        static var topKey:UInt8 = 103
        static var bottomKey:UInt8 = 104
        static var leftKey:UInt8 = 105
        static var rightKey:UInt8 = 106
    }

    @IBInspectable var largeTop: NSNumber {
        get {
            if let value = associatedObject(forKey:&AssociatedKeys.topKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey:&AssociatedKeys.topKey)
        }
    }

    @IBInspectable var largeBottom: NSNumber {
        get {
            if let value = associatedObject(forKey:&AssociatedKeys.bottomKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey:&AssociatedKeys.bottomKey)
        }
    }

    @IBInspectable var largeLeft: NSNumber {
        get {
            if let value = associatedObject(forKey:&AssociatedKeys.leftKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey:&AssociatedKeys.leftKey)
        }
    }

    @IBInspectable var largeRight: NSNumber {
        get {
            if let value = associatedObject(forKey:&AssociatedKeys.rightKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey:&AssociatedKeys.rightKey)
        }
    }

    /// 增加 UIControl 的点击范围
    ///
    /// - Parameters:
    ///   - top: 上
    ///   - bottom: 下
    ///   - left: 左
    ///   - right: 右
    func setEnlargeEdge(top: Float, bottom: Float, left: Float, right: Float) {
        self.largeTop = NSNumber(value: top)
        self.largeBottom = NSNumber(value: bottom)
        self.largeLeft = NSNumber(value: left)
        self.largeRight = NSNumber(value: right)
    }
}

open class EnlargeButton: UIButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.enlargedRect()
        if rect.equalTo(self.bounds) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point) ? true : false
    }

    private func enlargedRect() -> CGRect {
        let top = self.largeTop
        let bottom = self.largeBottom
        let left = self.largeLeft
        let right = self.largeRight
        if top.floatValue >= 0, bottom.floatValue >= 0, left.floatValue >= 0, right.floatValue >= 0 {
            return CGRect(x: self.bounds.origin.x - CGFloat(left.floatValue),
                          y: self.bounds.origin.y - CGFloat(top.floatValue),
                          width: self.bounds.size.width + CGFloat(left.floatValue) + CGFloat(right.floatValue),
                          height: self.bounds.size.height + CGFloat(top.floatValue) + CGFloat(bottom.floatValue))
        } else {
            return self.bounds
        }
    }
}
