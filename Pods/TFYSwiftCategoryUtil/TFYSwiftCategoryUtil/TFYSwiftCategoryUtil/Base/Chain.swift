//
//  Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

// MARK: - 链式编程核心结构
/// TFY 链式编程包装器，支持动态成员查找和链式调用
@dynamicMemberLookup
public struct TFY<Base> {
    /// 被包装的基础对象
    public let base: Base
    /// 获取最终构建的对象
    public var build: Base { return base }
    /// 初始化
    public init(_ base: Base) { self.base = base }
    /// 支持链式动态成员赋值
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Base, T>) -> ((T) -> TFY<Base>) {
        return { value in
            var base = self.base
            base[keyPath: keyPath] = value
            return TFY(base)
        }
    }
    /// 配置基础对象
    @discardableResult
    public func configure(_ closure: (Base) -> Void) -> TFY<Base> {
        closure(base)
        return self
    }
    /// 条件执行
    @discardableResult
    public func `if`(_ condition: Bool, _ closure: (Base) -> Void) -> TFY<Base> {
        if condition { closure(base) }
        return self
    }
}

// MARK: - 链式编程协议
/// 支持 TFY 链式语法的协议
public protocol TFYCompatible {}

public extension TFYCompatible {
    /// 类型级链式入口
    static var tfy: TFY<Self>.Type { get { TFY<Self>.self } set {} }
    /// 实例级链式入口
    var tfy: TFY<Self> { get { TFY(self) } set {} }
}

// MARK: - 属性回调协议
/// 支持属性回调的协议
public protocol TFYPropertyCompatible {
    associatedtype Value
    var value: Value { get set }
    var valueChanged: ((Value) -> Void)? { get set }
}

// MARK: - 属性包装器
/// 支持回调的属性包装器
@propertyWrapper
public struct TFYProperty<T>: TFYPropertyCompatible {
    public var value: T
    public var valueChanged: ((T) -> Void)?
    public var wrappedValue: T {
        get { value }
        set {
            value = newValue
            valueChanged?(newValue)
        }
    }
    public init(wrappedValue: T) { self.value = wrappedValue }
}

// MARK: - NSObject扩展
extension NSObject: TFYCompatible {
    /// 获取完整类名（包含模块名）
    public var fullClassName: String { NSStringFromClass(type(of: self)) }
    /// 获取短类名（不包含模块名）
    public var shortClassName: String { String(describing: type(of: self)) }
    /// 检查是否为指定类型
    public func isKind<T>(of type: T.Type) -> Bool { self is T }
    /// 尝试转换指定类型
    public func asKind<T>(of type: T.Type) -> T? { self as? T }
    /// 检查是否为指定类的实例
    public func isMember(of aClass: AnyClass) -> Bool { isKind(of: aClass) }
    /// 获取所有属性名
    public var propertyNames: [String] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(type(of: self), &count)
        defer { if let properties = properties { free(properties) } }
        guard let propertyList = properties else { return [] }
        return (0..<Int(count)).compactMap { index in
            let property = propertyList[index]
            let name = property_getName(property)
            return String(cString: name)
        }
    }
    /// 获取所有方法名
    public var methodNames: [String] {
        var count: UInt32 = 0
        let methods = class_copyMethodList(type(of: self), &count)
        defer { if let methods = methods { free(methods) } }
        guard let methodList = methods else { return [] }
        return (0..<Int(count)).compactMap { index in
            let method = methodList[index]
            let selector = method_getName(method)
            return String(cString: sel_getName(selector))
        }
    }
    /// 获取所有变量名
    public var ivarNames: [String] {
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type(of: self), &count)
        defer { if let ivars = ivars { free(ivars) } }
        guard let ivarList = ivars else { return [] }
        return (0..<Int(count)).compactMap { index in
            let ivar = ivarList[index]
            let name = ivar_getName(ivar)
            return name.map { String(cString: $0) }
        }
    }
    /// 获取所有协议名
    public var protocolNames: [String] {
        var count: UInt32 = 0
        let protocols = class_copyProtocolList(type(of: self), &count)
        defer { if let protocols = protocols { free(UnsafeMutableRawPointer(protocols)) } }
        guard let protocolList = protocols else { return [] }
        return (0..<Int(count)).compactMap { index in
            let proto = protocolList[index]
            let name = protocol_getName(proto)
            return String(cString: name)
        }
    }
}

// MARK: - 类型检查和转换扩展
public extension TFY where Base: NSObject {
    /// 检查是否为指定类型
    func isKind<T>(of type: T.Type) -> Bool { base is T }
    /// 尝试转换为指定类型
    func asKind<T>(of type: T.Type) -> T? { base as? T }
    /// 获取完整类名
    var fullClassName: String { base.fullClassName }
    /// 获取短类名
    var shortClassName: String { base.shortClassName }
    /// 获取所有属性名
    var propertyNames: [String] { base.propertyNames }
    /// 获取所有方法名
    var methodNames: [String] { base.methodNames }
    /// 获取所有变量名
    var ivarNames: [String] { base.ivarNames }
    /// 获取所有协议名
    var protocolNames: [String] { base.protocolNames }
}

// MARK: - 运行时工具扩展
public extension TFY where Base: NSObject {
    /// 设置关联对象
    @discardableResult
    func setAssociatedObject(_ value: Any?, key: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> TFY {
        objc_setAssociatedObject(base, key, value, policy)
        return self
    }
    /// 获取关联对象
    func getAssociatedObject(_ key: UnsafeRawPointer) -> Any? {
        objc_getAssociatedObject(base, key)
    }
    /// 移除所有关联对象
    @discardableResult
    func removeAssociatedObjects() -> TFY {
        objc_removeAssociatedObjects(base)
        return self
    }
    /// 交换实例方法
    @discardableResult
    static func swizzleInstanceMethod(_ originalSelector: Selector, with swizzledSelector: Selector) -> Bool {
        guard let originalMethod = class_getInstanceMethod(Base.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(Base.self, swizzledSelector) else { return false }
        let didAddMethod = class_addMethod(
            Base.self,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        if didAddMethod {
            class_replaceMethod(
                Base.self,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        return true
    }
}

// MARK: - Nib相关协议
/// Nib/Storyboard 创建协议，支持字符串和枚举
public protocol UINibCreater {
    /// 获取 Nib 对象
    func nib(in bundle: Bundle?) -> UINib
    /// 获取 Storyboard 对象
    func storyboard(in bundle: Bundle?) -> UIStoryboard
}

extension String: UINibCreater {
    public func nib(in bundle: Bundle? = nil) -> UINib {
        UINib(nibName: self, bundle: bundle)
    }
    public func storyboard(in bundle: Bundle? = nil) -> UIStoryboard {
        UIStoryboard(name: self, bundle: bundle)
    }
}

// MARK: - Nib实例化协议
/// 支持 Nib 实例化的协议
public protocol UINibInstantiable: AnyObject {
    /// 通过 Nib 实例化（指定索引）
    static func instantiate(atNib index: Int, withOwner owner: Any?) -> Self
    /// 通过 Nib 实例化（默认第一个）
    static func instantiateFromNib(withOwner owner: Any?) -> Self
}

extension UINibInstantiable where Self: UIView {
    public static func instantiate(atNib index: Int, withOwner owner: Any? = nil) -> Self {
        let identifier = String(describing: self)
        return identifier.nib().instantiate(withOwner: owner, options: nil)[index] as! Self
    }
    public static func instantiateFromNib(withOwner owner: Any? = nil) -> Self {
        instantiate(atNib: 0, withOwner: owner)
    }
}

extension UINibInstantiable where Self: NSObject {
    public static func instantiate(atNib index: Int, withOwner owner: Any? = nil) -> Self {
        let identifier = String(describing: self)
        return identifier.nib().instantiate(withOwner: owner, options: nil)[index] as! Self
    }
    public static func instantiateFromNib(withOwner owner: Any? = nil) -> Self {
        instantiate(atNib: 0, withOwner: owner)
    }
}

// MARK: - 原始值为String的枚举扩展
extension RawRepresentable where RawValue == String {
    public func nib(in bundle: Bundle? = nil) -> UINib {
        UINib(nibName: rawValue, bundle: bundle)
    }
    public func storyboard(in bundle: Bundle? = nil) -> UIStoryboard {
        UIStoryboard(name: rawValue, bundle: bundle)
    }
}

// MARK: - 手势闭包支持
private var gestureKey: Void?

extension UIGestureRecognizer {
    fileprivate var gestureClosureWrapper: GestureClosureWrapper? {
        get { objc_getAssociatedObject(self, &gestureKey) as? GestureClosureWrapper }
        set { objc_setAssociatedObject(self, &gestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private class GestureClosureWrapper {
    let closure: (UIGestureRecognizer) -> Void
    init(_ closure: @escaping (UIGestureRecognizer) -> Void) { self.closure = closure }
    @objc func invoke(_ gesture: UIGestureRecognizer) { closure(gesture) }
}

// MARK: - 控件事件闭包支持
private var controlKey: Void?

extension UIControl {
    fileprivate var controlClosureWrapper: ControlClosureWrapper? {
        get { objc_getAssociatedObject(self, &controlKey) as? ControlClosureWrapper }
        set { objc_setAssociatedObject(self, &controlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private class ControlClosureWrapper {
    let closure: () -> Void
    init(_ closure: @escaping () -> Void) { self.closure = closure }
    @objc func invoke() { closure() }
}

// MARK: - 链式UI扩展示例
public extension TFY where Base: UIView {
    /// 为 UIView 添加手势并支持闭包回调
    @discardableResult
    func addGesture(_ gesture: UIGestureRecognizer, action: @escaping (UIGestureRecognizer) -> Void) -> TFY {
        let wrapper = GestureClosureWrapper(action)
        gesture.gestureClosureWrapper = wrapper
        gesture.addTarget(wrapper, action: #selector(GestureClosureWrapper.invoke(_:)))
        base.addGestureRecognizer(gesture)
        return self
    }
}

public extension TFY where Base: UIControl {
    /// 为 UIControl 添加点击事件并支持闭包回调
    @discardableResult
    func onTap(_ action: @escaping () -> Void) -> TFY {
        let wrapper = ControlClosureWrapper(action)
        base.controlClosureWrapper = wrapper
        base.addTarget(wrapper, action: #selector(ControlClosureWrapper.invoke), for: .touchUpInside)
        return self
    }
}

// MARK: - Array扩展
public extension Array {
    /// 将数组分割成指定大小的块
    /// - Parameter size: 每块的大小
    /// - Returns: 分块后的二维数组
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
