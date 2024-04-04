//
//  NotificationCenter+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: NotificationCenter {
    
    @discardableResult
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any? = nil) -> TFY {
        base.addObserver(observer, selector: aSelector, name: aName, object: anObject)
        return self
    }
    
    @discardableResult
    func post(_ notification: Notification) -> TFY {
        base.post(notification)
        return self
    }
    
    @discardableResult
    func post(name aName: NSNotification.Name,
              object anObject: Any? = nil,
              userInfo aUserInfo: [AnyHashable : Any]? = nil) -> TFY {
        base.post(name: aName, object: anObject, userInfo: aUserInfo)
        return self
    }
    
    @discardableResult
    func removeObserver(_ observer: Any,
                        name aName: NSNotification.Name?,
                        object anObject: Any?) -> TFY {
        base.removeObserver(observer, name: aName, object: anObject)
        return self
    }
}
