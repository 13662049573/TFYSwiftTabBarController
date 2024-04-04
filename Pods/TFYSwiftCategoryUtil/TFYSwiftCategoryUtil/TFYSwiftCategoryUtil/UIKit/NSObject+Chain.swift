//
//  NSObject+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit

// MARK: - 一、 NSObject 属性的扩展
#if os(iOS) || os(tvOS)
public extension NSObject {
    
    // MARK: 1.1、类名（对象方法）
    /// 类名
    var className: String {
        return type(of: self).className
    }
    
    // MARK: 1.2、类名（类方法）
    /// 类名
    static var className: String {
        return String(describing: self)
    }
}

#endif

// MARK: - 二、一些常用的方法
public extension NSObject {
    
    // MARK: 2.1、利用运行时获取类里面的成员变量
    /// 利用运行时获取类里面的成员变量
    @discardableResult
    static func printIvars() -> [String] {
        // 成员变量名字
        var propertyNames = [String]()
        // 成员变量数量
        var count: UInt32 = 0
        // ivars实际上是一个数组
        let ivars = class_copyIvarList(Self.self, &count)
        for i in 0 ..< count {
            // ivar是一个结构体的指针
            let ivar = ivars![Int(i)]
            // 获取 成员变量的名称,cName c语言的字符串,首元素地址
            let cName = ivar_getName(ivar)
            let name = String(cString: cName!, encoding: String.Encoding.utf8)
            propertyNames.append(name ?? "没有内容")
        }
        // 方法中有copy,create,的都需要释放
        free(ivars)
        return propertyNames
    }
    
    var ivars: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        if let ivars = class_copyIvarList(self.classForCoder, &count) {
            for i in 0..<Int(count) {
                let ivar = ivars[i]
                if let cString = ivar_getName(ivar) {
                    ret.append(String(cString: cString as UnsafePointer<CChar>))
                }
            }
            free(ivars)
        }
        
        return ret
    }

    var properties: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        if let properties = class_copyPropertyList(self.classForCoder, &count) {
            for i in 0..<Int(count) {
                let property = properties[i]
                let cString = property_getName(property)
                ret.append(String(cString: cString as UnsafePointer<CChar>))
            }
            free(properties)
        }
        
        return ret
    }
    
    var methods: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        if let methods = class_copyMethodList(self.classForCoder, &count) {
            for i in 0..<Int(count) {
                let method = methods[i]
                let selector = method_getName(method)
                let cString = sel_getName(selector)
                ret.append(String(cString: cString as UnsafePointer<CChar>))
            }
            free(methods)
        }
        
        return ret
    }
    
    var protocols: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        if let protocols = class_copyProtocolList(self.classForCoder, &count) {
            for i in 0..<Int(count) {
                let proto = protocols[i]
                let cString = protocol_getName(proto)
                ret.append(String(cString: cString as UnsafePointer<CChar>))
            }// No need to free protocols because it's AutoreleasingUnsafeMutablePointer<Protocol?>!
        }
        return ret
    }
}

// MARK: - 三、Hook
@objc public extension NSObject {
    /// 实例方法替换
    static func hookInstanceMethod(of origSel: Selector, with replSel: Selector) -> Bool {
        let clz: AnyClass = classForCoder()
        guard let oriMethod = class_getInstanceMethod(clz, origSel) as Method? else {
            TFYLog("原 实例方法：Swizzling Method(\(origSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }
        
        guard let repMethod = class_getInstanceMethod(clz, replSel) as Method? else {
            TFYLog("新 实例方法：Swizzling Method(\(replSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }
        
        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(clz, origSel, method_getImplementation(repMethod), method_getTypeEncoding(repMethod))
        // 如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(clz, replSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, repMethod)
        }
        return true
    }
    
    /// 类方法替换
    static func hookClassMethod(of origSel: Selector, with replSel: Selector) -> Bool {
        let clz: AnyClass = classForCoder()
        
        guard let oriMethod = class_getClassMethod(clz, origSel) as Method? else {
            TFYLog("原 类方法：Swizzling Method(\(origSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }
        
        guard let repMethod = class_getClassMethod(clz, replSel) as Method? else {
            TFYLog("新 类方法 replSel：Swizzling Method(\(replSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }
        
        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(clz, origSel, method_getImplementation(repMethod), method_getTypeEncoding(repMethod))
        // 如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(clz, replSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, repMethod)
        }
        return true
    }
    
    /// 方法替换
    static func hookMethod(of origSel: Selector, with replSel: Selector, isClassMethod: Bool) -> Bool {
        let clz: AnyClass = classForCoder()
        
        guard let oriMethod = (isClassMethod ? class_getClassMethod(clz, origSel) : class_getClassMethod(clz, origSel)) as Method?,
              let repMethod = (isClassMethod ? class_getClassMethod(clz, replSel) : class_getClassMethod(clz, replSel)) as Method?
        else {
            TFYLog("Swizzling Method(s) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }
        
        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(clz, origSel, method_getImplementation(repMethod), method_getTypeEncoding(repMethod))
        // 如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(clz, replSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, repMethod)
        }
        return true
    }
}

@objc public extension NSObject{
    class func initializeMethod() {
        if self != NSObject.self {
            return
        }
        
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
        DispatchQueue.tfy.once(token: onceToken) {
            
            let oriSel = #selector(self.setValue(_:forUndefinedKey:))
            let repSel = #selector(self.hook_setValue(_:forUndefinedKey:))
            _ = hookInstanceMethod(of: oriSel, with: repSel)
            
            let oriSel0 = #selector(self.value(forUndefinedKey:))
            let repSel0 = #selector(self.hook_value(forUndefinedKey:))
            _ = hookInstanceMethod(of: oriSel0, with: repSel0)
            
            let oriSel1 = #selector(self.setNilValueForKey(_:))
            let repSel1 = #selector(self.hook_setNilValueForKey(_:))
            _ = hookInstanceMethod(of: oriSel1, with: repSel1)
            
            let oriSel2 = #selector(self.setValuesForKeys(_:))
            let repSel2 = #selector(self.hook_setValuesForKeys(_:))
            _ = hookInstanceMethod(of: oriSel2, with: repSel2)
        }
    }
    
    private func hook_setValue(_ value: Any?, forUndefinedKey key: String) {
        TFYLog("setValue: forUndefinedKey:, 未知键Key: \(key)")
    }
    
    private func hook_value(forUndefinedKey key: String) -> Any? {
        TFYLog("valueForUndefinedKey:, 未知键: \(key)")
        return nil
    }
    
    private func hook_setNilValueForKey(_ key: String) {
        TFYLog("Invoke setNilValueForKey:, 不能给非指针对象(如NSInteger)赋值 nil")
        // 给一个非指针对象(如NSInteger)赋值 nil, 直接忽略
        return
    }
    
    private func hook_setValuesForKeys(_ keyedValues: [String : Any]) {
        for (key, value) in keyedValues {
            TFYLog(key, value)
            if value is Int || value is CGFloat || value is Double {
                self.setValue("\(value)", forKey: key)
            } else {
                self.setValue(value, forKey: key)
            }
        }
    }
}


public func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
    return value.assumingMemoryBound(to: T.self).pointee
}

public extension NSObject {
    /// Sets an associated value for a given object using a weak reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(assignObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_ASSIGN)
        didChangeValue(forKey: strKey)
    }

    /// Sets an associated value for a given object using a strong reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(retainObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// Sets an associated value for a given object using a copied reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(copyObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// Returns the value associated with a given object for a given key.
    /// **Note**: the `key` underlying type must be String.
    func associatedObject(forKey key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }
}

/// 封装 swizzed 方法
public let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}


