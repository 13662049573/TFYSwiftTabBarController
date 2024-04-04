//
//  UIResponder+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit
import ObjectiveC.runtime

private weak var tfy_currentFirstResponder: UIResponder?
private let kGetFirstResponder:NSNumber = -159287123

private var isSwizzleFirstResponder = false

public extension TFY where Base: UIResponder {
    
    @discardableResult
    func becomeFirstResponder() -> TFY {
        base.becomeFirstResponder()
        return self
    }
    
    @discardableResult
    func resignFirstResponder() -> TFY {
        base.resignFirstResponder()
        return self
    }
    
    var currentViewController: UIViewController? {
        var responder = base.next
        while responder != nil {
            if responder!.isKind(of: UIViewController.self) {
                return (responder as! UIViewController)
            }
            responder = responder?.next
        }
        return nil
    }
}

public final class FirstResponderListener {
    
    public var value:UIResponder? {
        didSet {
            guard let val = value, val !== oldValue else { return }
            observers = observers.filter {
                if $0.target == nil { return false }
                $0.notice(val)
                return true
            }
        }
    }
    
    private var observers:[Observer] = []
    
    init() {
        if !isSwizzleFirstResponder {
            isSwizzleFirstResponder = true
            replaceBecomeFirstResponder()
            replaceResignFirstResponder()
        }
        value = UIResponder.firstResponder()
    }
    
    private func replaceBecomeFirstResponder() {
        
        let method1 = class_getInstanceMethod(UIResponder.self, #selector(UIResponder.becomeFirstResponder))!
        let method2 = class_getInstanceMethod(UIResponder.self, #selector(UIResponder.swizzle_becomeFirstResponder))!
        
        method_exchangeImplementations(method1, method2)
    }
    
    private func replaceResignFirstResponder() {
        
        let method1 = class_getInstanceMethod(UIResponder.self, #selector(UIResponder.resignFirstResponder))!
        let method2 = class_getInstanceMethod(UIResponder.self, #selector(UIResponder.swizzle_resignFirstResponder))!
        
        method_exchangeImplementations(method1, method2)
    }
    
    public func addNotice(target: AnyObject, change: @escaping (UIResponder?) -> Void) {
        observers.append(Observer(target, change))
    }
    
    public func addNotice(target: AnyObject, action: Selector, needRelease:Bool = false) {
        observers.append(Observer(target, action, needRelease))
    }
    
    public func removeNotice(target: AnyObject) {
        observers = observers.filter { $0.target != nil && $0.target !== target }
    }
}

extension FirstResponderListener {
    
    fileprivate struct Observer {
        
        weak var target:AnyObject?
        
        var notice : Notice
        
        typealias Notice = (_ new:UIResponder) -> Void
        
        init(_ target: AnyObject, _ notice: @escaping Notice) {
            self.target = target
            self.notice = notice
        }
        
        init(_ target: AnyObject, _ action: Selector, _ needRelease:Bool = false) {
            self.target = target
            self.notice = { [weak target] in
                let r = target?.perform(action, with: $0)
                if needRelease {
                    r?.release()
                }
            }
        }
    }
    
}

extension UIResponder {
    
    
    @objc fileprivate func swizzle_becomeFirstResponder() -> Bool {
        let result = swizzle_becomeFirstResponder()
        
        if  result {
            UIApplication.firstResponderListener.value = self
        }
        return result
    }
    
    @objc fileprivate func swizzle_resignFirstResponder() -> Bool {
        let result = swizzle_resignFirstResponder()
        
        if  result, UIApplication.firstResponderListener.value === self {
            UIApplication.firstResponderListener.value = nil
        }
        return result
    }
    
}

extension UIApplication {
    
    public static let firstResponderListener = FirstResponderListener()
 
    public final func firstResponder() -> UIResponder? {
        return UIResponder.firstResponder()
    }
    
}

extension UIResponder {
    
    public static func firstResponder() -> UIResponder? {
        tfy_currentFirstResponder = nil
        // 通过将target设置为nil，让系统自动遍历响应链
        // 从而响应链当前第一响应者响应我们自定义的方法
        UIApplication.shared.sendAction(#selector(tfy_findFirstResponder(_:)), to: nil, from: kGetFirstResponder, for: nil)
        return tfy_currentFirstResponder
    }
    
    @objc private func tfy_findFirstResponder(_ sender: Any?) {
        // 第一响应者会响应这个方法，并且将静态变量wty_currentFirstResponder设置为自己
        switch sender {
        case let num as NSNumber where num.intValue == kGetFirstResponder.intValue:
            tfy_currentFirstResponder = self
        default: break
        }
        
    }
}

