//
//  NSObject+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//  用途：NSObject 链式编程扩展，支持运行时操作、方法交换等功能。
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

    /// 获取类的完整名称（包含模块名）
    static var fullClassName: String {
        return NSStringFromClass(self)
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
        guard let ivars = class_copyIvarList(Self.self, &count) else {
            return propertyNames
        }
        
        defer { free(ivars) }
        
        for i in 0 ..< count {
            // ivar是一个结构体的指针
            let ivar = ivars[Int(i)]
            // 获取 成员变量的名称,cName c语言的字符串,首元素地址
            guard let cName = ivar_getName(ivar) else { continue }
            let name = String(cString: cName, encoding: String.Encoding.utf8)
            propertyNames.append(name ?? "没有内容")
        }
        
        return propertyNames
    }
    
    /// 获取实例变量列表
    var ivars: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
            return ret
        }
        
        defer { free(ivars) }
        
        for i in 0..<Int(count) {
            let ivar = ivars[i]
            guard let cString = ivar_getName(ivar) else { continue }
            ret.append(String(cString: cString))
        }
        
        return ret
    }

    /// 获取属性列表
    var properties: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        guard let properties = class_copyPropertyList(self.classForCoder, &count) else {
            return ret
        }
        
        defer { free(properties) }
        
        for i in 0..<Int(count) {
            let property = properties[i]
            let cString = property_getName(property)
            ret.append(String(cString: cString))
        }
        
        return ret
    }
    
    /// 获取方法列表
    var methods: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        guard let methods = class_copyMethodList(self.classForCoder, &count) else {
            return ret
        }
        
        defer { free(methods) }
        
        for i in 0..<Int(count) {
            let method = methods[i]
            let selector = method_getName(method)
            let cString = sel_getName(selector)
            ret.append(String(cString: cString))
        }
        
        return ret
    }
    
    /// 获取协议列表
    var protocols: [String] {
        var ret = [String]()
        
        var count: u_int = 0
        guard let protocols = class_copyProtocolList(self.classForCoder, &count) else {
            return ret
        }
        
        for i in 0..<Int(count) {
            let proto = protocols[i]
            let cString = protocol_getName(proto)
            ret.append(String(cString: cString))
        }
        
        return ret
    }
    
    /// 安全地执行方法
    /// - Parameters:
    ///   - selector: 方法选择器
    ///   - arguments: 参数数组
    /// - Returns: 执行结果
    @discardableResult
    func perform(_ selector: Selector, with arguments: [Any] = []) -> Any? {
        guard responds(to: selector) else {
            TFYUtils.Logger.log("方法 \(selector) 不存在于类 \(className) 中")
            return nil
        }
        
        return perform(selector, with: arguments)
    }
}

// MARK: - 三、Hook
@objc public extension NSObject {
    /// 实例方法替换
    /// - Parameters:
    ///   - origSel: 原始方法选择器
    ///   - replSel: 替换方法选择器
    /// - Returns: 是否成功
    static func hookInstanceMethod(of origSel: Selector, with replSel: Selector) -> Bool {
        let clz: AnyClass = classForCoder()
        
        guard let oriMethod = class_getInstanceMethod(clz, origSel) else {
            TFYUtils.Logger.log("原实例方法：Swizzling Method(\(origSel)) not found while swizzling class \(NSStringFromClass(clz)).")
            return false
        }
        
        guard let repMethod = class_getInstanceMethod(clz, replSel) else {
            TFYUtils.Logger.log("新实例方法：Swizzling Method(\(replSel)) not found while swizzling class \(NSStringFromClass(clz)).")
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
        
        TFYUtils.Logger.log("成功替换实例方法: \(origSel) -> \(replSel)")
        return true
    }
    
    /// 类方法替换
    /// - Parameters:
    ///   - origSel: 原始方法选择器
    ///   - replSel: 替换方法选择器
    /// - Returns: 是否成功
    static func hookClassMethod(of origSel: Selector, with replSel: Selector) -> Bool {
        let clz: AnyClass = classForCoder()
        
        guard let oriMethod = class_getClassMethod(clz, origSel) else {
            TFYUtils.Logger.log("原类方法：Swizzling Method(\(origSel)) not found while swizzling class \(NSStringFromClass(clz)).")
            return false
        }
        
        guard let repMethod = class_getClassMethod(clz, replSel) else {
            TFYUtils.Logger.log("新类方法：Swizzling Method(\(replSel)) not found while swizzling class \(NSStringFromClass(clz)).")
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
        
        TFYUtils.Logger.log("成功替换类方法: \(origSel) -> \(replSel)")
        return true
    }
    
    /// 方法替换
    /// - Parameters:
    ///   - origSel: 原始方法选择器
    ///   - replSel: 替换方法选择器
    ///   - isClassMethod: 是否为类方法
    /// - Returns: 是否成功
    static func hookMethod(of origSel: Selector, with replSel: Selector, isClassMethod: Bool) -> Bool {
        let clz: AnyClass = classForCoder()
        
        guard let oriMethod = (isClassMethod ? class_getClassMethod(clz, origSel) : class_getInstanceMethod(clz, origSel)),
              let repMethod = (isClassMethod ? class_getClassMethod(clz, replSel) : class_getInstanceMethod(clz, replSel))
        else {
            TFYUtils.Logger.log("Swizzling Method(s) not found while swizzling class \(NSStringFromClass(clz)).")
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
        
        TFYUtils.Logger.log("成功替换\(isClassMethod ? "类" : "实例")方法: \(origSel) -> \(replSel)")
        return true
    }
    
    /// 安全的方法替换（带错误处理）
    /// - Parameters:
    ///   - origSel: 原始方法选择器
    ///   - replSel: 替换方法选择器
    ///   - isClassMethod: 是否为类方法
    /// - Returns: 是否成功
    static func safeHookMethod(of origSel: Selector, with replSel: Selector, isClassMethod: Bool = false) -> Bool {
        // 检查方法是否存在
        let clz: AnyClass = classForCoder()
        
        let origMethod = isClassMethod ? class_getClassMethod(clz, origSel) : class_getInstanceMethod(clz, origSel)
        let replMethod = isClassMethod ? class_getClassMethod(clz, replSel) : class_getInstanceMethod(clz, replSel)
        
        guard origMethod != nil, replMethod != nil else {
            TFYUtils.Logger.log("方法替换失败：方法不存在")
            return false
        }
        
        // 检查是否已经替换过
        let key = "\(NSStringFromClass(clz))_\(origSel)_\(replSel)"
        if UserDefaults.standard.bool(forKey: key) {
            TFYUtils.Logger.log("方法已经替换过，跳过：\(origSel)")
            return true
        }
        
        let success = hookMethod(of: origSel, with: replSel, isClassMethod: isClassMethod)
        if success {
            UserDefaults.standard.set(true, forKey: key)
        }
        
        return success
    }
}

/// 安全的指针转换函数
public func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
    return value.assumingMemoryBound(to: T.self).pointee
}

public extension NSObject {
    /// 设置关联对象（弱引用）
    /// - Parameters:
    ///   - object: 关联对象
    ///   - key: 关联键
    func associate(assignObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_ASSIGN)
        didChangeValue(forKey: strKey)
    }

    /// 设置关联对象（强引用）
    /// - Parameters:
    ///   - object: 关联对象
    ///   - key: 关联键
    func associate(retainObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// 设置关联对象（拷贝引用）
    /// - Parameters:
    ///   - object: 关联对象
    ///   - key: 关联键
    func associate(copyObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// 获取关联对象
    /// - Parameter key: 关联键
    /// - Returns: 关联对象
    func associatedObject(forKey key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }
    
    /// 移除关联对象
    /// - Parameter key: 关联键
    func removeAssociatedObject(forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: strKey)
    }
    
    /// 移除所有关联对象
    func removeAllAssociatedObjects() {
        objc_removeAssociatedObjects(self)
    }
}

/// 封装 swizzled 方法
public let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    else {
        TFYUtils.Logger.log("Swizzling failed: methods not found")
        return
    }
    
    // 检查是否已经添加了方法
    let didAddMethod = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
        class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    TFYUtils.Logger.log("Swizzling successful: \(originalSelector) <-> \(swizzledSelector)")
}


