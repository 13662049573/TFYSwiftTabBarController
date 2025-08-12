//
//  NotificationCenter+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit

public extension TFY where Base: NotificationCenter {
    
    // MARK: 1.1、添加观察者
    /// 添加观察者
    /// - Parameters:
    ///   - observer: 观察者
    ///   - aSelector: 选择器
    ///   - aName: 通知名称
    ///   - anObject: 对象
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any? = nil) -> Self {
        base.addObserver(observer, selector: aSelector, name: aName, object: anObject)
        return self
    }
    
    // MARK: 1.2、发送通知
    /// 发送通知
    /// - Parameter notification: 通知对象
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func post(_ notification: Notification) -> Self {
        base.post(notification)
        return self
    }
    
    // MARK: 1.3、发送指定名称的通知
    /// 发送指定名称的通知
    /// - Parameters:
    ///   - aName: 通知名称
    ///   - anObject: 对象
    ///   - aUserInfo: 用户信息
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func post(name aName: NSNotification.Name,
              object anObject: Any? = nil,
              userInfo aUserInfo: [AnyHashable : Any]? = nil) -> Self {
        base.post(name: aName, object: anObject, userInfo: aUserInfo)
        return self
    }
    
    // MARK: 1.4、移除观察者
    /// 移除观察者
    /// - Parameters:
    ///   - observer: 观察者
    ///   - aName: 通知名称
    ///   - anObject: 对象
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func removeObserver(_ observer: Any,
                        name aName: NSNotification.Name?,
                        object anObject: Any?) -> Self {
        base.removeObserver(observer, name: aName, object: anObject)
        return self
    }
    
    // MARK: 1.5、移除所有观察者
    /// 移除所有观察者
    /// - Parameter observer: 观察者
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func removeObserver(_ observer: Any) -> Self {
        base.removeObserver(observer)
        return self
    }
}

// MARK: - 二、NotificationCenter的便利方法
public extension NotificationCenter {
    
    // MARK: 2.5、在主线程发送通知
    /// 在主线程发送通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - object: 对象
    ///   - userInfo: 用户信息
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func postOnMainThread(name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        if Thread.isMainThread {
            self.post(name: name, object: object, userInfo: userInfo)
        } else {
            DispatchQueue.main.async {
                self.post(name: name, object: object, userInfo: userInfo)
            }
        }
    }
    
    // MARK: 2.6、异步发送通知
    /// 异步发送通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - object: 对象
    ///   - userInfo: 用户信息
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func postAsync(name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.global().async {
            self.post(name: name, object: object, userInfo: userInfo)
        }
    }
    
    // MARK: 2.7、延迟发送通知
    /// 延迟发送通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - delay: 延迟时间
    ///   - object: 对象
    ///   - userInfo: 用户信息
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func postDelayed(name: NSNotification.Name, delay: TimeInterval, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.post(name: name, object: object, userInfo: userInfo)
        }
    }
}
