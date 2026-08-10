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

    // MARK: - Block 事件回调

    /// 添加 Block 事件回调（⚠️ 注意闭包循环引用，建议使用 `[weak self]`）
    /// - Parameters:
    ///   - handler: 事件回调，参数为当前控件实例
    ///   - event: `UIControl.Event`
    @discardableResult
    func handler(_ handler: @escaping (Base) -> Void, for event: UIControl.Event) -> Self {
        if let key = UIControlEventAssociatedKeys.key(for: event) {
            privateAddBlockHandler(event: event, handler: handler, key: key)
        }
        return self
    }

    /// 移除指定事件的 Block 回调
    @discardableResult
    func removeBlockHandler(for event: UIControl.Event) -> Self {
        if let key = UIControlEventAssociatedKeys.key(for: event) {
            privateRemoveBlockHandler(for: event, key: key)
        }
        return self
    }

    /// 移除所有 Block 事件回调
    @discardableResult
    func removeAllEventBlockHandler() -> Self {
        UIControlEventAssociatedKeys.allKeys.forEach { event, key in
            privateRemoveBlockHandler(for: event, key: key)
        }
        return self
    }

    private func privateAddBlockHandler(
        event: UIControl.Event,
        handler: @escaping (Base) -> Void,
        key: UnsafeRawPointer
    ) {
        let eventHandler: TFYControlEventHandler
        if let existing = objc_getAssociatedObject(base, key) as? TFYControlEventHandler {
            base.removeTarget(existing, action: #selector(TFYControlEventHandler.invoke), for: event)
            eventHandler = existing
        } else {
            eventHandler = TFYControlEventHandler(target: base, event: event)
            objc_setAssociatedObject(base, key, eventHandler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        eventHandler.handler = { control in
            guard let typedControl = control as? Base else { return }
            handler(typedControl)
        }
        base.addTarget(eventHandler, action: #selector(TFYControlEventHandler.invoke), for: event)
    }

    private func privateRemoveBlockHandler(for event: UIControl.Event, key: UnsafeRawPointer) {
        guard let eventHandler = objc_getAssociatedObject(base, key) as? TFYControlEventHandler else { return }
        base.removeTarget(eventHandler, action: #selector(TFYControlEventHandler.invoke), for: event)
        objc_setAssociatedObject(base, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - UIControl 事件关联键

private enum UIControlEventAssociatedKeys {
    static let touchDown = UnsafeRawPointer(bitPattern: "tfy.control.touchDown".hashValue)!
    static let touchDownRepeat = UnsafeRawPointer(bitPattern: "tfy.control.touchDownRepeat".hashValue)!
    static let touchDragInside = UnsafeRawPointer(bitPattern: "tfy.control.touchDragInside".hashValue)!
    static let touchDragOutside = UnsafeRawPointer(bitPattern: "tfy.control.touchDragOutside".hashValue)!
    static let touchDragEnter = UnsafeRawPointer(bitPattern: "tfy.control.touchDragEnter".hashValue)!
    static let touchDragExit = UnsafeRawPointer(bitPattern: "tfy.control.touchDragExit".hashValue)!
    static let touchUpInside = UnsafeRawPointer(bitPattern: "tfy.control.touchUpInside".hashValue)!
    static let touchUpOutside = UnsafeRawPointer(bitPattern: "tfy.control.touchUpOutside".hashValue)!
    static let touchCancel = UnsafeRawPointer(bitPattern: "tfy.control.touchCancel".hashValue)!
    static let valueChanged = UnsafeRawPointer(bitPattern: "tfy.control.valueChanged".hashValue)!
    static let primaryActionTriggered = UnsafeRawPointer(bitPattern: "tfy.control.primaryActionTriggered".hashValue)!
    static let editingDidBegin = UnsafeRawPointer(bitPattern: "tfy.control.editingDidBegin".hashValue)!
    static let editingChanged = UnsafeRawPointer(bitPattern: "tfy.control.editingChanged".hashValue)!
    static let editingDidEnd = UnsafeRawPointer(bitPattern: "tfy.control.editingDidEnd".hashValue)!
    static let editingDidEndOnExit = UnsafeRawPointer(bitPattern: "tfy.control.editingDidEndOnExit".hashValue)!
    static let allTouchEvents = UnsafeRawPointer(bitPattern: "tfy.control.allTouchEvents".hashValue)!
    static let allEditingEvents = UnsafeRawPointer(bitPattern: "tfy.control.allEditingEvents".hashValue)!
    static let applicationReserved = UnsafeRawPointer(bitPattern: "tfy.control.applicationReserved".hashValue)!
    static let systemReserved = UnsafeRawPointer(bitPattern: "tfy.control.systemReserved".hashValue)!
    static let menuActionTriggered = UnsafeRawPointer(bitPattern: "tfy.control.menuActionTriggered".hashValue)!
    static let allEvents = UnsafeRawPointer(bitPattern: "tfy.control.allEvents".hashValue)!

    static let allKeys: [(UIControl.Event, UnsafeRawPointer)] = [
        (.touchDown, touchDown),
        (.touchDownRepeat, touchDownRepeat),
        (.touchDragInside, touchDragInside),
        (.touchDragOutside, touchDragOutside),
        (.touchDragEnter, touchDragEnter),
        (.touchDragExit, touchDragExit),
        (.touchUpInside, touchUpInside),
        (.touchUpOutside, touchUpOutside),
        (.touchCancel, touchCancel),
        (.valueChanged, valueChanged),
        (.primaryActionTriggered, primaryActionTriggered),
        (.editingDidBegin, editingDidBegin),
        (.editingChanged, editingChanged),
        (.editingDidEnd, editingDidEnd),
        (.editingDidEndOnExit, editingDidEndOnExit),
        (.allTouchEvents, allTouchEvents),
        (.allEditingEvents, allEditingEvents),
        (.applicationReserved, applicationReserved),
        (.systemReserved, systemReserved),
        (.menuActionTriggered, menuActionTriggered),
        (.allEvents, allEvents)
    ]

    static func key(for event: UIControl.Event) -> UnsafeRawPointer? {
        switch event {
        case .touchDown: return touchDown
        case .touchDownRepeat: return touchDownRepeat
        case .touchDragInside: return touchDragInside
        case .touchDragOutside: return touchDragOutside
        case .touchDragEnter: return touchDragEnter
        case .touchDragExit: return touchDragExit
        case .touchUpInside: return touchUpInside
        case .touchUpOutside: return touchUpOutside
        case .touchCancel: return touchCancel
        case .valueChanged: return valueChanged
        case .primaryActionTriggered: return primaryActionTriggered
        case .editingDidBegin: return editingDidBegin
        case .editingChanged: return editingChanged
        case .editingDidEnd: return editingDidEnd
        case .editingDidEndOnExit: return editingDidEndOnExit
        case .allTouchEvents: return allTouchEvents
        case .allEditingEvents: return allEditingEvents
        case .applicationReserved: return applicationReserved
        case .systemReserved: return systemReserved
        case .menuActionTriggered: return menuActionTriggered
        case .allEvents: return allEvents
        default: return nil
        }
    }
}

// MARK: - UIControl 事件 Block 桥接

private final class TFYControlEventHandler: NSObject {
    weak var target: UIControl?
    let event: UIControl.Event
    var handler: ((UIControl) -> Void)?

    init(target: UIControl, event: UIControl.Event) {
        self.target = target
        self.event = event
    }

    @objc func invoke() {
        guard let target else { return }
        handler?(target)
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
