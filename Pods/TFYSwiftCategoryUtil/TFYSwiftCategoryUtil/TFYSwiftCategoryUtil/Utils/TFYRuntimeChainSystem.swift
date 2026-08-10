//
//  TFYRuntimeChainSystem.swift
//  TFYRuntimeChainSystem
//
//  Created by AI Assistant on 2024/12/19.
//  用途：优化的通用链式系统，支持类型安全、高性能的链式调用
//
//  🎯 KeyPath自动补全正确用法：
//
//  ✅ 支持KeyPath自动补全的写法：
//  let label = UILabel()
//  label.labelChain
//      .set(\.text, to: "Hello")              // ✅ 输入 \.tex 会提示 text
//      .set(\.textColor, to: PlatformColor.red)     // ✅ 输入 \.tex 会提示 textColor
//      .set(\.backgroundColor, to: PlatformColor.blue) // ✅ 输入 \.bac 会提示 backgroundColor
//
//  📝 关键点：使用 `to:` 参数标签来区分KeyPath方法和字符串方法
//
//  ❌ 不支持KeyPath自动补全的写法：
//  label.tfy()
//      .set("text", "Hello")                  // ❌ 字符串方式，无自动补全
//
//  🎨 全面支持的跨平台组件（2024最新版）：
//      📱 iOS 组件：
//      • 基础视图：PlatformView(.chain), PlatformLabel(.labelChain), PlatformImageView(.imageChain)
//      • 输入控件：PlatformTextField(.textFieldChain), PlatformTextView(.textViewChain)
//      • 按钮控件：PlatformButton(.buttonChain), PlatformSegmentedControl(.segmentChain)
//      • 值控件：PlatformSlider(.sliderChain), PlatformProgressView(.progressChain)
//      • 容器控件：PlatformScrollView(.scrollChain), PlatformStackView(.stackChain)
//      • 手势识别：PlatformTapGestureRecognizer(.tapGestureChain), PlatformPanGestureRecognizer(.panGestureChain)
//      • 高级组件：PlatformViewController(.viewControllerChain), PlatformWindow(.windowChain), PlatformLayer(.layerChain)
//
//      🖥️ macOS 独有组件：
//      • 特有控件：NSPopUpButton(.popUpButtonChain), NSColorWell(.colorWellChain), NSLevelIndicator(.levelIndicatorChain)
//      • 表格视图：NSTableView(.nsTableViewChain), NSOutlineView(.outlineViewChain)
//      • 容器控件：NSBox(.boxChain), NSTabView(.tabViewChain), NSSplitView(.splitViewChain)
//      • 手势识别：NSMagnificationGestureRecognizer(.magnificationGestureChain), NSRotationGestureRecognizer(.nsRotationGestureChain)
//
//  🚀 跨平台便利创建方法：
//  let configuredLabel = TFYChainHelper.createLabel { chain in  // 自动适配 UILabel/NSTextField
//      return chain.set(\.text, to: "Hello").set(\.textColor, to: .red)
//  }
//
//  🔧 跨平台批量操作支持：
//  TFYChainHelper.batchSet(labels, \.textColor, to: PlatformColor.blue)  // 跨平台颜色
//  TFYChainHelper.batchChain(buttons) { $0.set(\.alpha, to: 0.8) }       // 通用透明度
//
//  💡 特殊功能：
//      • 性能监控：.tfyPerformance()
//      • 调试模式：.tfyDebug()
//      • 完整功能：.tfyFull()
//      • 错误处理：.onError { errors in ... }
//      • 异步执行：.async { ... }
//      • 延迟执行：.delay(1.0) { ... }
//

import Foundation
import ObjectiveC

#if os(iOS)
import UIKit
public typealias PlatformView = UIView
public typealias PlatformViewController = UIViewController
public typealias PlatformWindow = UIWindow
public typealias PlatformColor = UIColor
public typealias PlatformFont = UIFont
public typealias PlatformImage = UIImage
public typealias PlatformButton = UIButton
public typealias PlatformLabel = UILabel
public typealias PlatformImageView = UIImageView
public typealias PlatformTextField = UITextField
public typealias PlatformScrollView = UIScrollView
public typealias PlatformStackView = UIStackView
public typealias PlatformTextView = UITextView
public typealias PlatformSlider = UISlider
public typealias PlatformProgressView = UIProgressView
public typealias PlatformSwitch = UISwitch
public typealias PlatformSegmentedControl = UISegmentedControl
public typealias PlatformGestureRecognizer = UIGestureRecognizer
public typealias PlatformTapGestureRecognizer = UITapGestureRecognizer
public typealias PlatformPanGestureRecognizer = UIPanGestureRecognizer
public typealias PlatformAnimationOptions = UIView.AnimationOptions
public typealias PlatformKeyframeAnimationOptions = UIView.KeyframeAnimationOptions
public typealias PlatformEdgeInsets = UIEdgeInsets
public typealias PlatformContentMode = UIView.ContentMode
public typealias PlatformStackViewDistribution = UIStackView.Distribution
public typealias PlatformStackViewAlignment = UIStackView.Alignment
public typealias PlatformControlState = UIControl.State
public typealias PlatformControlEvent = UIControl.Event
public typealias PlatformControl = UIControl
public typealias PlatformTextFieldBorderStyle = UITextField.BorderStyle
public typealias PlatformLayoutAxis = NSLayoutConstraint.Axis
public typealias PlatformTextAlignment = NSTextAlignment
public typealias PlatformLayoutConstraint = NSLayoutConstraint
public typealias PlatformLayer = CALayer
public typealias PlatformTimingFunction = CAMediaTimingFunction
public typealias PlatformAttributedString = NSAttributedString
#endif
#if os(macOS)
import AppKit
public typealias PlatformView = NSView
public typealias PlatformViewController = NSViewController
public typealias PlatformWindow = NSWindow
public typealias PlatformColor = NSColor
public typealias PlatformFont = NSFont
public typealias PlatformImage = NSImage
public typealias PlatformButton = NSButton
public typealias PlatformLabel = NSTextField // macOS 使用 NSTextField 作为标签
public typealias PlatformImageView = NSImageView
public typealias PlatformTextField = NSTextField
public typealias PlatformScrollView = NSScrollView
public typealias PlatformStackView = NSStackView
public typealias PlatformTextView = NSTextView
public typealias PlatformSlider = NSSlider
public typealias PlatformProgressView = NSProgressIndicator
public typealias PlatformSwitch = NSButton // macOS 没有直接的开关控件，使用 NSButton
public typealias PlatformSegmentedControl = NSSegmentedControl
public typealias PlatformGestureRecognizer = NSGestureRecognizer
public typealias PlatformTapGestureRecognizer = NSClickGestureRecognizer
public typealias PlatformPanGestureRecognizer = NSPanGestureRecognizer
public typealias PlatformAnimationOptions = UInt // macOS 使用不同的动画选项系统
public typealias PlatformKeyframeAnimationOptions = UInt // macOS 关键帧动画选项
public typealias PlatformEdgeInsets = NSEdgeInsets
public typealias PlatformContentMode = NSImageScaling // macOS 使用 NSImageScaling 作为内容模式
public typealias PlatformStackViewDistribution = NSStackView.Distribution
public typealias PlatformStackViewAlignment = NSLayoutConstraint.Attribute // macOS 使用 NSLayoutConstraint.Attribute 代替已废弃的 NSLayoutAttribute
public typealias PlatformControlState = UInt // macOS 不需要控件状态，使用 UInt 占位
public typealias PlatformControlEvent = UInt // macOS 不需要控件事件，使用 UInt 占位
public typealias PlatformControl = NSControl
public typealias PlatformTextFieldBorderStyle = NSTextField.BezelStyle
public typealias PlatformLayoutAxis = NSUserInterfaceLayoutOrientation
public typealias PlatformTextAlignment = NSTextAlignment
public typealias PlatformLayoutConstraint = NSLayoutConstraint
public typealias PlatformLayer = CALayer
public typealias PlatformTimingFunction = CAMediaTimingFunction
public typealias PlatformAttributedString = NSAttributedString
// NSEdgeInsets.zero 兼容
extension NSEdgeInsets {
    public static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
#endif

// MARK: - 链式调用核心协议

/// 链式调用核心协议
public protocol TFYChainableProtocol {
    associatedtype ChainType
    associatedtype BaseType

    var base: BaseType { get }
    var build: BaseType { get }
}

/// 错误处理协议
public protocol TFYChainErrorHandling {
    associatedtype ChainType
    var errors: [TFYChainError] { get set }
    func onError(_ handler: @escaping ([TFYChainError]) -> Void) -> ChainType
}

/// 性能监控协议
public protocol TFYChainPerformanceMonitoring {
    associatedtype ChainType
    var performanceMetrics: [String: TimeInterval] { get set }
    func onPerformance(_ handler: @escaping ([String: TimeInterval]) -> Void) -> ChainType
}

/// 高级功能协议
public protocol TFYChainAdvancedFeatures {
    associatedtype BaseType
    associatedtype ChainType

    func delay(_ delay: TimeInterval, _ block: @escaping (BaseType) -> Void) -> ChainType
    func log(_ message: String) -> ChainType
    func configure(_ block: (BaseType) -> Void) -> ChainType
    func async(_ queue: DispatchQueue, _ block: @escaping (BaseType) -> Void) -> ChainType
    func `repeat`(_ count: Int, _ block: (BaseType) -> Void) -> ChainType
    func when(_ condition: Bool, _ block: (BaseType) -> Void) -> ChainType
}

// MARK: - 链式调用错误类型

/// 链式调用错误枚举
public enum TFYChainError: Error, CustomStringConvertible {
    case propertyNotFound(String)
    case methodNotFound(String)
    case typeConversionFailed(String)
    case invalidNestedProperty(String)
    case runtimeError(String)
    case performanceWarning(String, TimeInterval)
    case memoryWarning(String)
    case threadSafetyViolation(String)
    case cacheOverflow(String)
    case invalidConfiguration(String)
    case deprecatedUsage(String, alternative: String)

    public var description: String {
        switch self {
        case .propertyNotFound(let property):
            return "属性不存在: \(property)"
        case .methodNotFound(let method):
            return "方法不存在: \(method)"
        case .typeConversionFailed(let type):
            return "类型转换失败: \(type)"
        case .invalidNestedProperty(let property):
            return "无效的嵌套属性: \(property)"
        case .runtimeError(let error):
            return "运行时错误: \(error)"
        case .performanceWarning(let operation, let time):
            return "性能警告: \(operation) 耗时 \(time)ms"
        case .memoryWarning(let details):
            return "内存警告: \(details)"
        case .threadSafetyViolation(let details):
            return "线程安全违规: \(details)"
        case .cacheOverflow(let details):
            return "缓存溢出: \(details)"
        case .invalidConfiguration(let details):
            return "配置无效: \(details)"
        case .deprecatedUsage(let usage, let alternative):
            return "已弃用的用法: \(usage)，建议使用: \(alternative)"
        }
    }

    /// 错误级别
    public var severity: ErrorSeverity {
        switch self {
        case .performanceWarning, .memoryWarning, .deprecatedUsage:
            return .warning
        case .propertyNotFound, .methodNotFound, .typeConversionFailed:
            return .error
        case .runtimeError, .threadSafetyViolation, .cacheOverflow:
            return .critical
        case .invalidNestedProperty, .invalidConfiguration:
            return .error
        }
    }
}

/// 错误严重程度
public enum ErrorSeverity: Int, CaseIterable {
    case warning = 1
    case error = 2
    case critical = 3

    public var description: String {
        switch self {
        case .warning: return "⚠️ 警告"
        case .error: return "❌ 错误"
        case .critical: return "🚨 严重"
        }
    }
}

// MARK: - 运行时工具类（优化版）

/// 优化的运行时工具类
public class TFYRuntimeUtils {

    /// LRU缓存节点
    private class CacheNode {
        let key: String
        var value: Set<String>
        var timestamp: TimeInterval
        var next: CacheNode?
        var prev: CacheNode?

        init(key: String, value: Set<String>) {
            self.key = key
            self.value = value
            self.timestamp = Date().timeIntervalSince1970
        }
    }

    /// LRU缓存管理器
    private class LRUCache {
        private var capacity: Int
        private var cache: [String: CacheNode] = [:]
        private var head: CacheNode?
        private var tail: CacheNode?
        private var size: Int = 0

        init(capacity: Int) {
            self.capacity = max(0, capacity)
        }

        func get(_ key: String) -> Set<String>? {
            guard capacity > 0 else { return nil }
            guard let node = cache[key] else { return nil }

            // 更新访问时间
            node.timestamp = Date().timeIntervalSince1970
            moveToHead(node)
            return node.value
        }

        func put(_ key: String, _ value: Set<String>) {
            guard capacity > 0 else { return }

            if let existingNode = cache[key] {
                existingNode.value = value
                existingNode.timestamp = Date().timeIntervalSince1970
                moveToHead(existingNode)
                return
            }

            let newNode = CacheNode(key: key, value: value)

            if size >= capacity {
                removeLRU()
            }

            addToHead(newNode)
            cache[key] = newNode
            size += 1
        }

        private func addToHead(_ node: CacheNode) {
            node.next = head
            node.prev = nil

            if let h = head {
                h.prev = node
            }
            head = node

            if tail == nil {
                tail = head
            }
        }

        private func removeNode(_ node: CacheNode) {
            if let p = node.prev {
                p.next = node.next
            } else {
                head = node.next
            }

            if let n = node.next {
                n.prev = node.prev
            } else {
                tail = node.prev
            }
        }

        private func moveToHead(_ node: CacheNode) {
            removeNode(node)
            addToHead(node)
        }

        private func removeLRU() {
            if let t = tail {
                cache.removeValue(forKey: t.key)
                removeNode(t)
                size -= 1
            }
        }

        func clear() {
            cache.removeAll()
            head = nil
            tail = nil
            size = 0
        }

        var count: Int { return size }

        func updateCapacity(_ newCapacity: Int) {
            capacity = max(0, newCapacity)
            while size > capacity {
                removeLRU()
            }
            if capacity == 0 {
                clear()
            }
        }
    }

    /// 属性缓存，提高性能（线程安全 + LRU）
    private static let propertyLRUCache = LRUCache(capacity: TFYChainPerformanceConfig.maxCacheSize)
    private static let propertyCacheQueue = DispatchQueue(label: "com.tfychain.propertyCache", attributes: .concurrent)

    /// 方法缓存，提高性能（线程安全 + LRU）
    private static let methodLRUCache = LRUCache(capacity: TFYChainPerformanceConfig.maxCacheSize)
    private static let methodCacheQueue = DispatchQueue(label: "com.tfychain.methodCache", attributes: .concurrent)

    private static var effectiveCacheCapacity: Int {
        return max(0, TFYChainPerformanceConfig.maxCacheSize)
    }

    private static func classCacheKey(for classType: AnyClass) -> String {
        return NSStringFromClass(classType)
    }

    private static func cachedProperties(for className: String) -> Set<String>? {
        guard TFYChainPerformanceConfig.cacheEnabled else { return nil }
        return propertyCacheQueue.sync(flags: .barrier) {
            propertyLRUCache.updateCapacity(effectiveCacheCapacity)
            return propertyLRUCache.get(className)
        }
    }

    private static func cacheProperties(_ properties: Set<String>, for className: String) {
        guard TFYChainPerformanceConfig.cacheEnabled else { return }
        propertyCacheQueue.sync(flags: .barrier) {
            propertyLRUCache.updateCapacity(effectiveCacheCapacity)
            propertyLRUCache.put(className, properties)
        }
    }

    private static func cachedMethods(for className: String) -> Set<String>? {
        guard TFYChainPerformanceConfig.cacheEnabled else { return nil }
        return methodCacheQueue.sync(flags: .barrier) {
            methodLRUCache.updateCapacity(effectiveCacheCapacity)
            return methodLRUCache.get(className)
        }
    }

    private static func cacheMethods(_ methods: Set<String>, for className: String) {
        guard TFYChainPerformanceConfig.cacheEnabled else { return }
        methodCacheQueue.sync(flags: .barrier) {
            methodLRUCache.updateCapacity(effectiveCacheCapacity)
            methodLRUCache.put(className, methods)
        }
    }

    /// 检查属性是否存在（修复版本 - 线程安全 + LRU缓存）
    /// - Parameters:
    ///   - propertyName: 属性名
    ///   - object: 目标对象
    /// - Returns: 属性是否存在
    public static func hasProperty(_ propertyName: String, in object: NSObject) -> Bool {
        let className = classCacheKey(for: type(of: object))

        if let cachedProperties = cachedProperties(for: className) {
            return cachedProperties.contains(propertyName)
        }

        let properties = getProperties(for: type(of: object))
        let propertySet = Set(properties)
        cacheProperties(propertySet, for: className)
        return propertySet.contains(propertyName)
    }

    /// 检查属性是否存在且可写
    /// - Parameters:
    ///   - propertyName: 属性名
    ///   - object: 目标对象
    /// - Returns: 属性是否可写
    public static func hasWritableProperty(_ propertyName: String, in object: NSObject) -> Bool {
        guard let property = findProperty(named: propertyName, in: type(of: object)) else {
            return false
        }
        guard let attributes = property_getAttributes(property) else {
            return false
        }

        let attributeParts = String(cString: attributes).split(separator: ",")
        return !attributeParts.contains("R")
    }

    /// 检查方法是否存在（线程安全版本 + LRU缓存）
    /// - Parameters:
    ///   - methodName: 方法名
    ///   - object: 目标对象
    /// - Returns: 方法是否存在
    public static func hasMethod(_ methodName: String, in object: NSObject) -> Bool {
        let className = classCacheKey(for: type(of: object))

        if let cachedMethods = cachedMethods(for: className) {
            return cachedMethods.contains(methodName)
        }

        let methods = getMethods(for: type(of: object))
        let methodSet = Set(methods)
        cacheMethods(methodSet, for: className)
        return methodSet.contains(methodName)
    }

    /// 获取类的所有属性
    /// - Parameter classType: 类类型
    /// - Returns: 属性名数组
    public static func getProperties(for classType: AnyClass, includeSuperclasses: Bool = true) -> [String] {
        var propertyNames: [String] = []
        var visitedNames = Set<String>()
        var currentClass: AnyClass? = classType

        while let inspectedClass = currentClass {
            var count: UInt32 = 0
            if let properties = class_copyPropertyList(inspectedClass, &count) {
                defer { free(properties) }

                for i in 0..<Int(count) {
                    let property = properties[i]
                    let propertyName = String(cString: property_getName(property))
                    if visitedNames.insert(propertyName).inserted {
                        propertyNames.append(propertyName)
                    }
                }
            }

            guard includeSuperclasses else { break }
            currentClass = class_getSuperclass(inspectedClass)
        }

        return propertyNames
    }

    private static func findProperty(named propertyName: String, in classType: AnyClass, includeSuperclasses: Bool = true) -> objc_property_t? {
        var currentClass: AnyClass? = classType

        while let inspectedClass = currentClass {
            if let property = class_getProperty(inspectedClass, propertyName) {
                return property
            }

            guard includeSuperclasses else { break }
            currentClass = class_getSuperclass(inspectedClass)
        }

        return nil
    }

    /// 获取类的所有方法
    /// - Parameter classType: 类类型
    /// - Returns: 方法名数组
    public static func getMethods(for classType: AnyClass, includeSuperclasses: Bool = true) -> [String] {
        var methodNames: [String] = []
        var visitedNames = Set<String>()
        var currentClass: AnyClass? = classType

        while let inspectedClass = currentClass {
            var count: UInt32 = 0
            if let methods = class_copyMethodList(inspectedClass, &count) {
                defer { free(methods) }

                for i in 0..<Int(count) {
                    let method = methods[i]
                    let selector = method_getName(method)
                    let selectorString = NSStringFromSelector(selector)
                    if visitedNames.insert(selectorString).inserted {
                        methodNames.append(selectorString)
                    }
                }
            }

            guard includeSuperclasses else { break }
            currentClass = class_getSuperclass(inspectedClass)
        }

        return methodNames
    }

    /// 检查对象是否响应指定 Selector
    /// - Parameters:
    ///   - selectorName: Selector 名称
    ///   - object: 目标对象
    /// - Returns: 是否响应
    public static func responds(to selectorName: String, in object: NSObject) -> Bool {
        return object.responds(to: NSSelectorFromString(selectorName))
    }

    /// 安全的 KVC 设置（可靠修复版本 - 先检查后设置）
    /// - Parameters:
    ///   - object: 目标对象
    ///   - key: 键名
    ///   - value: 值
    /// - Returns: 设置是否成功
    @discardableResult
    public static func safeSetValue(_ value: Any?, forKey key: String, in object: NSObject) -> Bool {
        // 使用更安全的策略：先检查属性是否可用
        if canSetValueForKey(key, in: object) {
            object.setValue(value, forKey: key)
            return true
        } else {
#if DEBUG
            print("TFYRuntimeUtils: 属性 '\(key)' 不支持KVC，跳过设置。对象类型: \(type(of: object))")
#endif
            return false
        }
    }

    /// 检查是否可以安全地设置指定键的值
    /// - Parameters:
    ///   - key: 键名
    ///   - object: 目标对象
    /// - Returns: 是否可以安全设置
    private static func canSetValueForKey(_ key: String, in object: NSObject) -> Bool {
        // 检查是否有对应的setter方法
        let setterName = "set\(key.prefix(1).uppercased())\(key.dropFirst()):"
        if object.responds(to: NSSelectorFromString(setterName)) {
            return true
        }

        // 检查属性是否存在且不是 readonly
        if hasWritableProperty(key, in: object) {
            return true
        }

        // 特殊处理layer属性（跨平台）
        #if os(iOS)
        if key.hasPrefix("layer.") && object is UIView {
            return true
        }
        #elseif os(macOS)
        if key.hasPrefix("layer.") && object is NSView {
            return true
        }
        #endif

        // 检查是否在已知的安全属性列表中
        let safeProperties: Set<String> = [
            // 基础视图属性
            "text", "textColor", "backgroundColor", "alpha", "hidden", "frame", "bounds", "center",
            "transform", "clipsToBounds", "contentMode", "userInteractionEnabled", "multipleTouchEnabled",
            "isHidden", "tag", "autoresizingMask", "translatesAutoresizingMaskIntoConstraints",

            // 文本相关属性
            "placeholder", "borderStyle", "font", "textAlignment", "numberOfLines", "lineBreakMode",
            "adjustsFontSizeToFitWidth", "minimumFontSize", "attributedText", "textContainer",

            // 控件状态属性
            "enabled", "highlighted", "selected", "image", "backgroundImage", "tintColor",
            "isEnabled", "isHighlighted", "isSelected", "isUserInteractionEnabled",

            // 进度和值相关属性
            "progress", "progressTintColor", "trackTintColor", "isOn", "onTintColor", "thumbTintColor",
            "minimumValue", "maximumValue", "value", "minimumTrackTintColor", "maximumTrackTintColor",
            "selectedSegmentIndex", "currentPage", "numberOfPages", "hidesForSinglePage",

            // 滚动视图属性
            "contentOffset", "contentSize", "contentInset", "showsHorizontalScrollIndicator",
            "showsVerticalScrollIndicator", "alwaysBounceVertical", "alwaysBounceHorizontal",
            "pagingEnabled", "scrollEnabled", "bounces", "zoomScale", "minimumZoomScale", "maximumZoomScale",

            // 堆栈视图属性
            "axis", "distribution", "alignment", "spacing", "isLayoutMarginsRelativeArrangement",
            "arrangedSubviews", "layoutMargins", "directionalLayoutMargins",

            // 活动指示器属性
            "isAnimating", "hidesWhenStopped", "style", "color",

            // 搜索栏属性
            "searchText", "prompt", "barStyle", "searchBarStyle", "showsBookmarkButton",
            "showsCancelButton", "showsSearchResultsButton", "keyboardType", "returnKeyType",

            // 日期选择器属性
            "date", "minimumDate", "maximumDate", "datePickerMode", "locale", "calendar", "timeZone",

            // 步进器属性
            "stepValue", "wraps", "autorepeat", "continuous",

            // 工具栏和导航栏属性
            "barTintColor", "isTranslucent", "prefersLargeTitles", "largeTitleDisplayMode",
            "titleTextAttributes", "largeTitleTextAttributes", "shadowImage", "backgroundImage",

            // 手势识别器属性
            "numberOfTapsRequired", "numberOfTouchesRequired", "minimumPressDuration", "allowableMovement",
            "direction", "cancelsTouchesInView", "delaysTouchesBegan", "delaysTouchesEnded",

            // 层属性
            "cornerRadius", "borderWidth", "borderColor", "shadowColor", "shadowOffset",
            "shadowOpacity", "shadowRadius", "masksToBounds", "contents", "contentsScale",

            // 约束属性
            "constant", "multiplier", "priority", "isActive",

            // 视觉效果属性
            "effect", "contentView"
        ]

        return safeProperties.contains(key)
    }

    /// 暴露安全设置能力判断，便于业务在调用前做静态分支
    /// - Parameters:
    ///   - key: 键名
    ///   - object: 目标对象
    /// - Returns: 是否可以安全设置
    public static func canSetValue(_ key: String, in object: NSObject) -> Bool {
        return canSetValueForKey(key, in: object)
    }

    /// 判断是否可以通过 KVC 或 Selector 读取指定键
    /// - Parameters:
    ///   - key: 键名
    ///   - object: 目标对象
    /// - Returns: 是否可以读取
    public static func canGetValue(_ key: String, in object: NSObject) -> Bool {
        return hasProperty(key, in: object) || object.responds(to: NSSelectorFromString(key))
    }

    /// 安全的 KVC 获取
    /// - Parameters:
    ///   - object: 目标对象
    ///   - key: 键名
    /// - Returns: 获取的值
    public static func safeGetValue(forKey key: String, in object: NSObject) -> Any? {
        guard canGetValue(key, in: object) else {
#if DEBUG
            print("TFYRuntimeUtils: 属性 '\(key)' 不存在于对象 \(type(of: object))")
#endif
            return nil
        }

        // 直接调用，KVC 会处理异常情况
        return object.value(forKey: key)
    }

    /// 清空缓存（线程安全）
    public static func clearCache() {
        propertyCacheQueue.sync(flags: .barrier) {
            propertyLRUCache.clear()
        }
        methodCacheQueue.sync(flags: .barrier) {
            methodLRUCache.clear()
        }
    }

    /// 获取缓存统计信息
    public static func getCacheStats() -> (propertyCount: Int, methodCount: Int) {
        let propertyCount = propertyCacheQueue.sync(flags: .barrier) { propertyLRUCache.count }
        let methodCount = methodCacheQueue.sync(flags: .barrier) { methodLRUCache.count }
        return (propertyCount, methodCount)
    }

    /// 预热指定类型的属性和方法缓存
    /// - Parameter classTypes: 需要预热的类
    public static func warmupCache(for classTypes: [AnyClass]) {
        guard TFYChainPerformanceConfig.cacheEnabled else { return }

        for classType in classTypes {
            let className = classCacheKey(for: classType)
            cacheProperties(Set(getProperties(for: classType)), for: className)
            cacheMethods(Set(getMethods(for: classType)), for: className)
        }
    }

    /// 获取详细缓存统计信息
    public static func getDetailedCacheStats() -> [String: Any] {
        let propertyCount = propertyCacheQueue.sync(flags: .barrier) { propertyLRUCache.count }
        let methodCount = methodCacheQueue.sync(flags: .barrier) { methodLRUCache.count }
        let maxSize = effectiveCacheCapacity
        let propertyUtilization = maxSize > 0 ? Double(propertyCount) / Double(maxSize) : 0
        let methodUtilization = maxSize > 0 ? Double(methodCount) / Double(maxSize) : 0

        return [
            "propertyCount": propertyCount,
            "methodCount": methodCount,
            "maxCacheSize": maxSize,
            "cacheEnabled": TFYChainPerformanceConfig.cacheEnabled,
            "propertyUtilization": propertyUtilization,
            "methodUtilization": methodUtilization,
            "totalCacheEntries": propertyCount + methodCount,
            "cacheEfficiency": TFYChainPerformanceConfig.cacheEnabled ? (propertyCount > 0 && methodCount > 0 ? "optimal" : "underutilized") : "disabled",
            "platform": {
                #if os(iOS)
                return "iOS"
                #elseif os(macOS)
                return "macOS"
                #else
                return "unknown"
                #endif
            }()
        ]
    }
}

// MARK: - 通用链式容器

/// 通用链式容器，支持 NSObject 类型
public struct TFYChain<T: NSObject>: TFYChainableProtocol, TFYChainErrorHandling, TFYChainPerformanceMonitoring, TFYChainAdvancedFeatures {

    // MARK: - 协议实现

    public typealias ChainType = TFYChain<T>
    public typealias BaseType = T

    /// 原始对象
    public var base: T

    /// 错误收集器
    public var errors: [TFYChainError] = []

    /// 性能监控器
    public var performanceMetrics: [String: TimeInterval] = [:]

    /// 是否启用性能监控
    private var isPerformanceMonitoringEnabled: Bool = false

    /// 是否启用调试输出
    private var isDebugEnabled: Bool = false

    // MARK: - 初始化

    /// 初始化链式容器
    /// - Parameters:
    ///   - base: 原始对象
    ///   - enablePerformanceMonitoring: 是否启用性能监控
    ///   - enableDebug: 是否启用调试输出
    public init(_ base: T, enablePerformanceMonitoring: Bool = false, enableDebug: Bool = false) {
        self.base = base
        self.isPerformanceMonitoringEnabled = enablePerformanceMonitoring
        self.isDebugEnabled = enableDebug
    }

    /// 获取原始对象
    public var build: T { return base }

    /// 是否包含错误
    public var hasErrors: Bool { return !errors.isEmpty }

    /// 当前错误数量
    public var errorCount: Int { return errors.count }

    /// 是否有性能指标
    public var hasPerformanceMetrics: Bool { return !performanceMetrics.isEmpty }

    // MARK: - 配置方法

    /// 启用性能监控
    /// - Returns: 链式容器
    public func enablePerformanceMonitoring() -> TFYChain<T> {
        var newChain = self
        newChain.isPerformanceMonitoringEnabled = true
        return newChain
    }

    /// 启用调试输出
    /// - Returns: 链式容器
    public func enableDebug() -> TFYChain<T> {
        var newChain = self
        newChain.isDebugEnabled = true
        return newChain
    }

    /// 关闭性能监控
    /// - Returns: 链式容器
    public func disablePerformanceMonitoring() -> TFYChain<T> {
        var newChain = self
        newChain.isPerformanceMonitoringEnabled = false
        return newChain
    }

    /// 关闭调试输出
    /// - Returns: 链式容器
    public func disableDebug() -> TFYChain<T> {
        var newChain = self
        newChain.isDebugEnabled = false
        return newChain
    }

    // MARK: - 属性设置

    /// 使用字符串设置属性值
    /// - Parameters:
    ///   - propertyName: 属性名
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func set(_ propertyName: String, _ value: Any) -> TFYChain<T> {
        let startTime = isPerformanceMonitoringEnabled ? CFAbsoluteTimeGetCurrent() : 0
        var newChain = self

        let success = performPropertySetting(propertyName: propertyName, value: value, chain: &newChain)

        if isPerformanceMonitoringEnabled {
            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            newChain.performanceMetrics[propertyName] = elapsed

            // 性能警告：超过 1ms 的操作
            if elapsed > 0.001 {
                newChain.errors.append(.performanceWarning(propertyName, elapsed * 1000))
            }
        }

        if isDebugEnabled && success {
            print("TFYChain: 设置属性 \(propertyName) 值为: \(value)")
        }

        return newChain
    }

    /// 条件设置属性值
    /// - Parameters:
    ///   - condition: 条件
    ///   - propertyName: 属性名
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func setIf(_ condition: Bool, _ propertyName: String, _ value: Any) -> TFYChain<T> {
        return condition ? set(propertyName, value) : self
    }

    /// 可选值存在时设置属性值
    /// - Parameters:
    ///   - propertyName: 属性名
    ///   - value: 可选属性值
    /// - Returns: 链式容器
    @discardableResult
    public func setIfPresent(_ propertyName: String, _ value: Any?) -> TFYChain<T> {
        guard let value = value else { return self }
        return set(propertyName, value)
    }

    /// 批量设置属性
    /// - Parameter properties: 属性字典
    /// - Returns: 链式容器
    @discardableResult
    public func setMultiple(_ properties: [String: Any]) -> TFYChain<T> {
        var newChain = self
        for (propertyName, value) in properties {
            newChain = newChain.set(propertyName, value)
        }
        return newChain
    }

    // MARK: - KeyPath 支持（避免方法重载冲突）

    /// 使用 KeyPath 设置属性值（专用方法名避免重载冲突）
    /// - Parameters:
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func setKeyPath<Value>(_ keyPath: WritableKeyPath<T, Value>, _ value: Value) -> TFYChain<T> {
        let startTime = isPerformanceMonitoringEnabled ? CFAbsoluteTimeGetCurrent() : 0
        var newChain = self

        newChain.base[keyPath: keyPath] = value

        if isPerformanceMonitoringEnabled {
            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            let keyPathString = String(describing: keyPath)
            newChain.performanceMetrics[keyPathString] = elapsed
        }

        if isDebugEnabled {
            print("TFYChain: 通过KeyPath设置属性 \(keyPath) 值为: \(value)")
        }

        return newChain
    }

    /// 使用 KeyPath 设置属性值（重载版本，更简洁的方法名）
    /// - Parameters:
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func set<Value>(_ keyPath: WritableKeyPath<T, Value>, to value: Value) -> TFYChain<T> {
        return setKeyPath(keyPath, value)
    }

    /// 条件 KeyPath 设置
    /// - Parameters:
    ///   - condition: 条件
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func setKeyPathIf<Value>(_ condition: Bool, _ keyPath: WritableKeyPath<T, Value>, _ value: Value) -> TFYChain<T> {
        return condition ? setKeyPath(keyPath, value) : self
    }

    /// 条件 KeyPath 设置（带 to: 标签，便于保持调用风格一致）
    /// - Parameters:
    ///   - condition: 条件
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func setIf<Value>(_ condition: Bool, _ keyPath: WritableKeyPath<T, Value>, to value: Value) -> TFYChain<T> {
        return condition ? set(keyPath, to: value) : self
    }

    /// 可选值存在时通过 KeyPath 设置属性
    /// - Parameters:
    ///   - keyPath: 属性 KeyPath
    ///   - value: 可选属性值
    /// - Returns: 链式容器
    @discardableResult
    public func setIfPresent<Value>(_ keyPath: WritableKeyPath<T, Value>, to value: Value?) -> TFYChain<T> {
        guard let value = value else { return self }
        return set(keyPath, to: value)
    }

    // MARK: - 方法调用

    /// 调用无参数方法
    /// - Parameter methodName: 方法名
    /// - Returns: 链式容器
    @discardableResult
    public func call(_ methodName: String) -> TFYChain<T> {
        let startTime = isPerformanceMonitoringEnabled ? CFAbsoluteTimeGetCurrent() : 0
        var newChain = self

        if TFYRuntimeUtils.hasMethod(methodName, in: base) {
            let selector = NSSelectorFromString(methodName)
            _ = base.perform(selector)

            if isDebugEnabled {
                print("TFYChain: 调用方法 \(methodName)")
            }
        } else {
            newChain.errors.append(.methodNotFound(methodName))
        }

        if isPerformanceMonitoringEnabled {
            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            newChain.performanceMetrics[methodName] = elapsed
        }

        return newChain
    }

    /// 增强的方法调用（支持常用 UIKit 方法）
    /// - Parameters:
    ///   - methodName: 方法名
    ///   - args: 参数列表
    /// - Returns: 链式容器
    @discardableResult
    public func invoke(_ methodName: String, _ args: Any...) -> TFYChain<T> {
        let startTime = isPerformanceMonitoringEnabled ? CFAbsoluteTimeGetCurrent() : 0
            var newChain = self

        let success = performMethodInvocation(methodName: methodName, args: args, chain: &newChain)

        if isPerformanceMonitoringEnabled {
            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            newChain.performanceMetrics[methodName] = elapsed
        }

        if isDebugEnabled && success {
            print("TFYChain: 调用方法 \(methodName) 参数: \(args)")
        }

            return newChain
        }

    // MARK: - 错误处理和性能监控协议实现

    /// 错误处理回调
    /// - Parameter handler: 错误处理闭包
    /// - Returns: 链式容器
    @discardableResult
    public func onError(_ handler: @escaping ([TFYChainError]) -> Void) -> TFYChain<T> {
        if !errors.isEmpty {
            handler(errors)
        }
        return self
    }

    /// 无错误时执行成功回调
    /// - Parameter handler: 成功处理闭包
    /// - Returns: 链式容器
    @discardableResult
    public func onSuccess(_ handler: (T) -> Void) -> TFYChain<T> {
        if errors.isEmpty {
            handler(base)
        }
        return self
    }

    /// 清空当前链路错误
    /// - Returns: 链式容器
    @discardableResult
    public func clearErrors() -> TFYChain<T> {
        var newChain = self
        newChain.errors.removeAll()
        return newChain
    }

    /// 按严重级别移除错误
    /// - Parameter severity: 要移除的错误级别
    /// - Returns: 链式容器
    @discardableResult
    public func clearErrors(severity: ErrorSeverity) -> TFYChain<T> {
        var newChain = self
        newChain.errors.removeAll { $0.severity == severity }
        return newChain
    }

    /// 按严重级别获取错误
    /// - Parameter severity: 错误级别
    /// - Returns: 匹配的错误数组
    public func filteredErrors(severity: ErrorSeverity) -> [TFYChainError] {
        return errors.filter { $0.severity == severity }
    }

    /// 错误摘要，适合日志和埋点上报
    public var errorSummary: [String: Int] {
        let groupedErrors = Dictionary(grouping: errors) { $0.severity.description }
        return groupedErrors.mapValues { $0.count }
    }

    /// 智能错误恢复
    /// - Parameter recoveryHandler: 错误恢复处理闭包
    /// - Returns: 链式容器
    @discardableResult
    public func recover(_ recoveryHandler: @escaping ([TFYChainError], T) -> TFYChain<T>) -> TFYChain<T> {
        if !errors.isEmpty {
            return recoveryHandler(errors, base)
        }
        return self
    }

    /// 条件错误处理 - 只处理特定类型的错误
    /// - Parameters:
    ///   - errorType: 错误类型过滤器
    ///   - handler: 错误处理闭包
    /// - Returns: 链式容器
    @discardableResult
    public func onError<ErrorType>(_ errorType: ErrorType.Type, handler: @escaping ([TFYChainError]) -> Void) -> TFYChain<T> where ErrorType: Error {
        let filteredErrors = errors.filter { error in
            if case .runtimeError(_) = error, ErrorType.self == NSError.self {
                return true
            }
            return false
        }

        if !filteredErrors.isEmpty {
            handler(filteredErrors)
        }
        return self
    }

    /// 降级处理 - 当发生错误时执行备用方案
    /// - Parameter fallbackHandler: 降级处理闭包
    /// - Returns: 链式容器
    @discardableResult
    public func fallback(_ fallbackHandler: @escaping (T) -> TFYChain<T>) -> TFYChain<T> {
        if !errors.isEmpty {
            // 清空当前错误，执行降级方案
            var newChain = self
            newChain.errors.removeAll()
            return fallbackHandler(base)
        }
        return self
    }

    /// 重试机制
    /// - Parameters:
    ///   - maxAttempts: 最大重试次数
    ///   - delay: 重试间隔
    ///   - operation: 要重试的操作
    /// - Returns: 链式容器
    @discardableResult
    public func retry(_ maxAttempts: Int = 3, delay: TimeInterval = 0.1, operation: @escaping (T) -> Bool) -> TFYChain<T> {
        var chainResult = self
        var attempt = 0

        func attemptOperation() -> Bool {
            attempt += 1
            let success = operation(base)

            if !success && attempt < maxAttempts {
                if delay > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        _ = attemptOperation()
                    }
                    return false
                } else {
                    return attemptOperation()
                }
            } else if !success {
                chainResult.errors.append(.runtimeError("重试 \(maxAttempts) 次后仍然失败"))
                return false
            }
            return true
        }

        _ = attemptOperation()
        return chainResult
    }

    /// 性能监控回调
    /// - Parameter handler: 性能监控闭包
    /// - Returns: 链式容器
    @discardableResult
    public func onPerformance(_ handler: @escaping ([String: TimeInterval]) -> Void) -> TFYChain<T> {
        if !performanceMetrics.isEmpty {
            handler(performanceMetrics)
        }
        return self
    }

    /// 清空性能指标
    /// - Returns: 链式容器
    @discardableResult
    public func resetPerformanceMetrics() -> TFYChain<T> {
        var newChain = self
        newChain.performanceMetrics.removeAll()
        return newChain
    }

    /// 获取毫秒单位的性能指标
    public var performanceMetricsInMilliseconds: [String: Double] {
        return performanceMetrics.mapValues { $0 * 1000 }
    }

    // MARK: - 高级功能协议实现

    /// 批量应用多个链式操作
    /// - Parameter operations: 链式操作列表
    /// - Returns: 链式容器
    @discardableResult
    public func apply(_ operations: ((TFYChain<T>) -> TFYChain<T>)...) -> TFYChain<T> {
        return operations.reduce(self) { partialResult, operation in
            operation(partialResult)
        }
    }

    /// 批量应用多个链式操作（数组版本）
    /// - Parameter operations: 链式操作数组
    /// - Returns: 链式容器
    @discardableResult
    public func applyAll(_ operations: [(TFYChain<T>) -> TFYChain<T>]) -> TFYChain<T> {
        return operations.reduce(self) { partialResult, operation in
            operation(partialResult)
        }
    }

    /// 延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func delay(_ delay: TimeInterval, _ block: @escaping (T) -> Void) -> TFYChain<T> {
        // 对于NSObject，需要使用弱引用避免强引用循环
        let shouldLogDebug = isDebugEnabled
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak base] in
            guard let strongBase = base else {
                if shouldLogDebug {
                    print("TFYChain: 延迟执行时对象已被释放")
                }
                return
            }
            block(strongBase)
        }
        return self
    }

    /// 链式日志
    /// - Parameter message: 日志消息
    /// - Returns: 链式容器
    @discardableResult
    public func log(_ message: String) -> TFYChain<T> {
        print("TFYChain[\(String(describing: type(of: base)))]: \(message)")
        return self
    }

    /// 配置闭包
    /// - Parameter block: 配置闭包
    /// - Returns: 链式容器
    @discardableResult
    public func configure(_ block: (T) -> Void) -> TFYChain<T> {
        block(base)
        return self
    }

    /// 异步执行
    /// - Parameters:
    ///   - queue: 执行队列
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func async(_ queue: DispatchQueue = .main, _ block: @escaping (T) -> Void) -> TFYChain<T> {
        // 对于NSObject，需要使用弱引用避免强引用循环
        let shouldLogDebug = isDebugEnabled
        queue.async { [weak base] in
            guard let strongBase = base else {
                if shouldLogDebug {
                    print("TFYChain: 异步执行时对象已被释放")
                }
                return
            }
            block(strongBase)
        }
        return self
    }

    /// 重复执行
    /// - Parameters:
    ///   - count: 重复次数
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func `repeat`(_ count: Int, _ block: (T) -> Void) -> TFYChain<T> {
        for _ in 0..<count {
            block(base)
        }
        return self
    }

    /// 条件执行
    /// - Parameters:
    ///   - condition: 条件
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func when(_ condition: Bool, _ block: (T) -> Void) -> TFYChain<T> {
        if condition {
            block(base)
        }
        return self
    }

    // MARK: - 动画链式支持

    /// 跨平台动画执行
    @discardableResult
    public func animate(duration: TimeInterval, options: PlatformAnimationOptions = {
        #if os(iOS)
        return []
        #elseif os(macOS)
        return 0
        #endif
    }(), animations: @escaping (T) -> Void, completion: ((Bool) -> Void)? = nil) -> TFYChain<T> {
        #if os(iOS)
        // iOS: 使用UIView动画系统
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            animations(self.base)
        }, completion: completion)
        #elseif os(macOS)
        // macOS: 使用NSAnimationContext系统（options参数被忽略）
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            animations(self.base)
        }, completionHandler: {
            completion?(true)
        })
        #endif
        return self
    }

    /// 跨平台弹簧动画执行
    @discardableResult
    public func animateSpring(duration: TimeInterval, damping: CGFloat = 0.7, velocity: CGFloat = 0, options: PlatformAnimationOptions = {
        #if os(iOS)
        return []
        #elseif os(macOS)
        return 0
        #endif
    }(), animations: @escaping (T) -> Void, completion: ((Bool) -> Void)? = nil) -> TFYChain<T> {
        #if os(iOS)
        // iOS: 使用真正的弹簧动画系统
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            animations(self.base)
        }, completion: completion)
        #elseif os(macOS)
        // macOS: 使用缓动函数模拟弹簧效果（damping和velocity参数被忽略）
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.timingFunction = PlatformTimingFunction(name: .easeInEaseOut)
            context.allowsImplicitAnimation = true
            animations(self.base)
        }, completionHandler: {
            completion?(true)
        })
        #endif
        return self
    }

    /// 关键帧动画执行
    @discardableResult
    public func animateKeyframes(duration: TimeInterval, options: PlatformKeyframeAnimationOptions = {
        #if os(iOS)
        return []
        #elseif os(macOS)
        return 0
        #endif
    }(), animations: @escaping (T) -> Void, completion: ((Bool) -> Void)? = nil) -> TFYChain<T> {
        #if os(iOS)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: options, animations: {
            animations(self.base)
        }, completion: completion)
        #elseif os(macOS)
        // macOS 使用动画组来模拟关键帧动画
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            animations(self.base)
        }, completionHandler: {
            completion?(true)
        })
        #endif
        return self
    }

    // MARK: - 约束链式支持

    /// 添加约束到父视图
    /// - Parameter constraintBuilder: 约束构建闭包
    /// - Returns: 链式容器
    @discardableResult
    public func addConstraints(_ constraintBuilder: (T) -> [PlatformLayoutConstraint]) -> TFYChain<T> {
        guard let view = base as? PlatformView else {
            var newChain = self
            newChain.errors.append(.runtimeError("约束只能应用于PlatformView及其子类"))
            return newChain
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = constraintBuilder(base)
        PlatformLayoutConstraint.activate(constraints)

        if isDebugEnabled {
            print("TFYChain: 添加了 \(constraints.count) 个约束")
        }

        return self
    }

    /// 简化的约束添加 - 居中约束
    /// - Parameter superview: 父视图
    /// - Returns: 链式容器
    @discardableResult
    public func centerIn(_ superview: PlatformView) -> TFYChain<T> {
        guard let view = base as? PlatformView else {
            var newChain = self
            newChain.errors.append(.runtimeError("约束只能应用于PlatformView及其子类"))
            return newChain
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        PlatformLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])

        return self
    }

    /// 简化的约束添加 - 填充父视图
    /// - Parameters:
    ///   - superview: 父视图
    ///   - insets: 边距
    /// - Returns: 链式容器
    @discardableResult
    public func fillSuperview(_ superview: PlatformView, insets: PlatformEdgeInsets = .zero) -> TFYChain<T> {
        guard let view = base as? PlatformView else {
            var newChain = self
            newChain.errors.append(.runtimeError("约束只能应用于PlatformView及其子类"))
            return newChain
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        PlatformLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])

        return self
    }

    /// 设置固定尺寸约束
    /// - Parameters:
    ///   - width: 宽度（nil表示不设置）
    ///   - height: 高度（nil表示不设置）
    /// - Returns: 链式容器
    @discardableResult
    public func size(width: CGFloat? = nil, height: CGFloat? = nil) -> TFYChain<T> {
        guard let view = base as? PlatformView else {
            var newChain = self
            newChain.errors.append(.runtimeError("约束只能应用于PlatformView及其子类"))
            return newChain
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [PlatformLayoutConstraint] = []

        if let width = width {
            constraints.append(view.widthAnchor.constraint(equalToConstant: width))
        }

        if let height = height {
            constraints.append(view.heightAnchor.constraint(equalToConstant: height))
        }

        PlatformLayoutConstraint.activate(constraints)
        return self
    }

    // MARK: - 调试和分析

    /// 打印类信息
    /// - Returns: 链式容器
    @discardableResult
    public func printClassInfo() -> TFYChain<T> {
        let className = String(describing: type(of: base))
        print("=== \(className) 类信息 ===")

        let properties = TFYRuntimeUtils.getProperties(for: type(of: base))
        print("属性列表 (\(properties.count)个):")
        for property in properties.prefix(10) { // 只显示前10个，避免输出过多
            print("  - \(property)")
        }
        if properties.count > 10 {
            print("  ... 还有 \(properties.count - 10) 个属性")
        }

        let methods = TFYRuntimeUtils.getMethods(for: type(of: base))
        print("方法列表 (\(methods.count)个):")
        for method in methods.prefix(10) { // 只显示前10个，避免输出过多
            print("  - \(method)")
        }
        if methods.count > 10 {
            print("  ... 还有 \(methods.count - 10) 个方法")
        }

        return self
    }

    /// 验证链式容器状态
    /// - Returns: 链式容器
    @discardableResult
    public func validate() -> TFYChain<T> {
        // 错误统计分析
        if !errors.isEmpty {
            print("TFYChain 验证失败，发现 \(errors.count) 个错误:")
            let errorGroups = Dictionary(grouping: errors) { $0.severity }
            for severity in ErrorSeverity.allCases.sorted(by: { $0.rawValue > $1.rawValue }) {
                if let errorsOfSeverity = errorGroups[severity] {
                    print("  \(severity.description) (\(errorsOfSeverity.count)个):")
                    for error in errorsOfSeverity {
                        print("    - \(error)")
                    }
                }
            }
        } else {
            print("✅ TFYChain 验证通过，无错误")
        }

        // 性能分析报告
        if isPerformanceMonitoringEnabled && !performanceMetrics.isEmpty {
            generatePerformanceReport()
        }

        return self
    }

    /// 生成性能分析报告
    private func generatePerformanceReport() {
        let totalTime = performanceMetrics.values.reduce(0, +)
        let operationCount = performanceMetrics.count
        let averageTime = totalTime / Double(operationCount)

        print("\n📊 性能分析报告:")
        print("  总耗时: \(String(format: "%.3f", totalTime * 1000))ms")
        print("  操作数: \(operationCount)")
        print("  平均耗时: \(String(format: "%.3f", averageTime * 1000))ms")

        // 最慢的操作
        if let slowestOperation = performanceMetrics.max(by: { $0.value < $1.value }) {
            print("  最慢操作: \(slowestOperation.key) (\(String(format: "%.3f", slowestOperation.value * 1000))ms)")
        }

        // 最快的操作
        if let fastestOperation = performanceMetrics.min(by: { $0.value < $1.value }) {
            print("  最快操作: \(fastestOperation.key) (\(String(format: "%.3f", fastestOperation.value * 1000))ms)")
        }

        // 性能警告
        let slowOperations = performanceMetrics.filter { $0.value > TFYChainPerformanceConfig.performanceWarningThreshold / 1000 }
        if !slowOperations.isEmpty {
            print("  ⚠️ 性能警告 (\(slowOperations.count)个操作超过阈值):")
            for (operation, time) in slowOperations.sorted(by: { $0.value > $1.value }) {
                print("    - \(operation): \(String(format: "%.3f", time * 1000))ms")
            }
        }

        // 性能建议
        generatePerformanceSuggestions()

        // 缓存统计
        let cacheStats = TFYRuntimeUtils.getDetailedCacheStats()
        print("  📋 缓存详细状态:")
        print("    - 属性缓存: \(cacheStats["propertyCount"] ?? 0)")
        print("    - 方法缓存: \(cacheStats["methodCount"] ?? 0)")
        print("    - 缓存利用率: \(String(format: "%.1f%%", (cacheStats["propertyUtilization"] as? Double ?? 0) * 100))")
        print("    - 缓存效率: \(cacheStats["cacheEfficiency"] ?? "unknown")")
    }

    /// 生成性能建议
    private func generatePerformanceSuggestions() {
        let totalTime = performanceMetrics.values.reduce(0, +)
        let operationCount = performanceMetrics.count
        let averageTime = totalTime / Double(operationCount)

        print("  💡 性能建议:")

        // 基于平均时间的建议
        if averageTime > 0.005 {  // 5ms
            print("    - 考虑使用批量操作减少单个操作耗时")
        }

        // 基于操作数量的建议
        if operationCount > 100 {
            print("    - 操作数量较多，考虑使用异步执行或分批处理")
        }

        // 基于慢操作的建议
        let slowOperations = performanceMetrics.filter { $0.value > 0.001 }
        if slowOperations.count > operationCount / 2 {
            print("    - 建议优化频繁调用的属性设置方法")
        }

        // 基于错误的建议
        if !errors.isEmpty {
            print("    - 发现 \(errors.count) 个错误，建议使用错误恢复机制")
        }
    }

    /// 导出性能数据为JSON格式
    /// - Returns: JSON字符串
    public func exportPerformanceData() -> String? {
        let performanceData: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "objectType": String(describing: type(of: base)),
            "totalTime": performanceMetrics.values.reduce(0, +),
            "operationCount": performanceMetrics.count,
            "operations": performanceMetrics.mapValues { $0 * 1000 }, // 转换为毫秒
            "errors": errors.map { $0.description },
            "cacheStats": TFYRuntimeUtils.getDetailedCacheStats()
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: performanceData, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("TFYChain: 导出性能数据失败 - \(error)")
            return nil
        }
    }

    /// 比较两个链式操作的性能
    /// - Parameter other: 另一个链式容器
    /// - Returns: 比较结果
    public func comparePerformance(with other: TFYChain<T>) -> [String: Any] {
        let myTotalTime = performanceMetrics.values.reduce(0, +)
        let otherTotalTime = other.performanceMetrics.values.reduce(0, +)

        let myAverage = myTotalTime / Double(max(performanceMetrics.count, 1))
        let otherAverage = otherTotalTime / Double(max(other.performanceMetrics.count, 1))

        return [
            "thisChain": [
                "totalTime": myTotalTime * 1000,
                "averageTime": myAverage * 1000,
                "operationCount": performanceMetrics.count
            ],
            "otherChain": [
                "totalTime": otherTotalTime * 1000,
                "averageTime": otherAverage * 1000,
                "operationCount": other.performanceMetrics.count
            ],
            "comparison": [
                "fasterChain": myTotalTime < otherTotalTime ? "this" : "other",
                "timeDifference": abs(myTotalTime - otherTotalTime) * 1000,
                "performanceGain": myTotalTime > 0 ? ((otherTotalTime - myTotalTime) / myTotalTime) * 100 : 0
            ]
        ]
    }
}

// MARK: - 私有方法实现

extension TFYChain {

    /// 执行属性设置（修复版本 - 特殊处理UIKit组件）
    private func performPropertySetting(propertyName: String, value: Any, chain: inout TFYChain<T>) -> Bool {
        // 处理嵌套属性（如 titleLabel.text）
        if propertyName.contains(".") {
            return handleNestedProperty(propertyName: propertyName, value: value, chain: &chain)
        }

        // 特殊处理UIKit组件属性（避免KVC崩溃）

        // 平台按钮特殊属性（跨平台）
        if let button = base as? PlatformButton {
            switch propertyName {
            case "title":
                if let title = value as? String {
                    #if os(iOS)
                    button.setTitle(title, for: .normal)
                    #elseif os(macOS)
                    button.title = title
                    #endif
                    if chain.isDebugEnabled {
                        print("✅ PlatformButton title设置成功: \(title)")
                    }
                    return true
                }
                // 类型不匹配，继续尝试KVC
            case "titleColor":
                if let color = value as? PlatformColor {
                    #if os(iOS)
                    button.setTitleColor(color, for: .normal)
                    #elseif os(macOS)
                    button.contentTintColor = color
                    #endif
                    if chain.isDebugEnabled {
                        print("✅ PlatformButton titleColor设置成功")
                    }
                    return true
                }
                // 类型不匹配，继续尝试KVC
            case "image":
                if let image = value as? PlatformImage {
                    #if os(iOS)
                    button.setImage(image, for: .normal)
                    #elseif os(macOS)
                    button.image = image
                    #endif
                    if chain.isDebugEnabled {
                        print("✅ PlatformButton image设置成功")
                    }
                    return true
                }
                // 类型不匹配，继续尝试KVC
            case "backgroundImage":
                #if os(iOS)
                if let image = value as? PlatformImage {
                    button.setBackgroundImage(image, for: .normal)
                    if chain.isDebugEnabled {
                        print("✅ PlatformButton backgroundImage设置成功")
                    }
                    return true
                }
                #endif
                // macOS 不支持背景图片，继续尝试KVC
            default:
                break
            }
        }

        // 平台图片视图特殊属性（跨平台）
        if let imageView = base as? PlatformImageView {
            switch propertyName {
            case "image":
                if let image = value as? PlatformImage {
                    imageView.image = image
                    return true
                }
            default:
                break
            }
        }

        // 平台标签文本属性
        if propertyName == "text", let text = value as? String {
            if let label = base as? PlatformLabel {
                #if os(iOS)
                label.text = text
                #elseif os(macOS)
                label.stringValue = text
                #endif
                if chain.isDebugEnabled {
                    print("✅ PlatformLabel text设置成功: \(text)")
                }
                return true
            }
        }

        // 平台文本输入框文本属性
        if propertyName == "text", let text = value as? String {
            if let textField = base as? PlatformTextField {
                #if os(iOS)
                textField.text = text
                #elseif os(macOS)
                textField.stringValue = text
                #endif
                if chain.isDebugEnabled {
                    print("✅ PlatformTextField text设置成功: \(text)")
                }
                return true
            }
        }

        // 平台文本视图文本属性
        if propertyName == "text", let text = value as? String {
            if let textView = base as? PlatformTextView {
                #if os(iOS)
                textView.text = text
                #elseif os(macOS)
                textView.string = text
                #endif
                if chain.isDebugEnabled {
                    print("✅ PlatformTextView text设置成功: \(text)")
                }
                return true
            }
        }

        // 平台文本输入框 placeholder属性
        if propertyName == "placeholder", let placeholder = value as? String {
            if let textField = base as? PlatformTextField {
                #if os(iOS)
                textField.placeholder = placeholder
                #elseif os(macOS)
                textField.placeholderString = placeholder
                #endif
                if chain.isDebugEnabled {
                    print("✅ PlatformTextField placeholder设置成功: \(placeholder)")
                }
                return true
            }
        }

        // 平台堆栈视图特殊属性（跨平台）
        if let stackView = base as? PlatformStackView {
            switch propertyName {
            case "axis":
                if let axis = value as? PlatformLayoutAxis {
                    #if os(iOS)
                    stackView.axis = axis
                    #elseif os(macOS)
                    stackView.orientation = axis
                    #endif
                    return true
                } else if let rawValue = value as? Int, let axis = PlatformLayoutAxis(rawValue: rawValue) {
                    #if os(iOS)
                    stackView.axis = axis
                    #elseif os(macOS)
                    stackView.orientation = axis
                    #endif
                    return true
                }
            case "distribution":
                if let distribution = value as? PlatformStackViewDistribution {
                    stackView.distribution = distribution
                    return true
                } else if let rawValue = value as? Int, let distribution = PlatformStackViewDistribution(rawValue: rawValue) {
                    stackView.distribution = distribution
                    return true
                }
            case "alignment":
                if let alignment = value as? PlatformStackViewAlignment {
                    stackView.alignment = alignment
                    return true
                } else if let rawValue = value as? Int, let alignment = PlatformStackViewAlignment(rawValue: rawValue) {
                    stackView.alignment = alignment
                    return true
                }
            case "spacing":
                if let spacing = value as? CGFloat {
                    stackView.spacing = spacing
                    return true
                } else if let spacing = value as? Double {
                    stackView.spacing = CGFloat(spacing)
                    return true
                }
            default:
                break
            }
        }

        // 特殊处理某些属性类型
        let finalValue = preprocessValue(value: value, propertyName: propertyName)

        // 直接尝试设置属性，不预先检查存在性
        let success = TFYRuntimeUtils.safeSetValue(finalValue, forKey: propertyName, in: base)

        // 只有在真正失败时才添加错误
        if !success {
            chain.errors.append(.propertyNotFound(propertyName))
        }

        return success
    }

    /// 处理嵌套属性（修复版本 - 移除严格检查）
    private func handleNestedProperty(propertyName: String, value: Any, chain: inout TFYChain<T>) -> Bool {
        let components = propertyName.components(separatedBy: ".")
        guard components.count == 2 else {
            chain.errors.append(.invalidNestedProperty(propertyName))
            return false
        }

        let parentProperty = components[0]
        let childProperty = components[1]

        // 尝试获取父对象
        guard let parentObject = base.value(forKey: parentProperty) as? NSObject else {
            chain.errors.append(.runtimeError("无法获取父属性 \(parentProperty) 或父对象为nil"))
            return false
        }

        // 直接尝试设置子属性
        return TFYRuntimeUtils.safeSetValue(value, forKey: childProperty, in: parentObject)
    }

    /// 预处理值（类型转换等）- 跨平台版本
    private func preprocessValue(value: Any, propertyName: String) -> Any {
        switch propertyName {
        case "contentMode":
            if let contentMode = value as? PlatformContentMode {
                return contentMode.rawValue
            } else if let rawValue = value as? Int {
                return rawValue
            } else if let rawValue = value as? UInt {
                return rawValue
            }
        case "textAlignment":
            if let alignment = value as? PlatformTextAlignment {
                return alignment.rawValue
            } else if let rawValue = value as? Int {
                return rawValue
            }
        case "borderStyle":
            // 平台文本输入框边框样式处理
            if let style = value as? PlatformTextFieldBorderStyle {
                return style.rawValue
            } else if let rawValue = value as? Int {
                return rawValue
            } else if let rawValue = value as? UInt {
                return rawValue
            }
        case "selectedSegmentIndex":
            // 平台分段控制器的selectedSegmentIndex
            if let index = value as? Int {
                return index
            }
        case let name where name.hasSuffix("Color") || name.contains("color"):
            // 自动处理颜色类型（跨平台）
            if let colorString = value as? String {
                return PlatformColor(named: colorString) ?? value
            }
        default:
            break
        }
        return value
    }

    /// 执行方法调用
    private func performMethodInvocation(methodName: String, args: [Any], chain: inout TFYChain<T>) -> Bool {
        // 特殊处理常用 UIKit 方法
        switch methodName {
        case "addTarget":
            return handleAddTarget(args: args, chain: &chain)
        case "setTitle":
            return handleSetTitle(args: args, chain: &chain)
        case "setTitleColor":
            return handleSetTitleColor(args: args, chain: &chain)
        case "setImage", "setButtonImage":
            return handleSetImage(args: args, chain: &chain)
        case "setBackgroundImage":
            return handleSetBackgroundImage(args: args, chain: &chain)
        case "setText":
            return handleSetText(args: args, chain: &chain)
        case "setTextColor":
            return handleSetTextColor(args: args, chain: &chain)
        case "setFont":
            return handleSetFont(args: args, chain: &chain)
        case "setImageViewImage":
            return handleSetImageViewImage(args: args, chain: &chain)
        case "setContentMode":
            return handleSetContentMode(args: args, chain: &chain)
        default:
            // 尝试通过 KVC 设置属性
            if args.count == 1 {
                return TFYRuntimeUtils.safeSetValue(args[0], forKey: methodName, in: base)
            } else {
                chain.errors.append(.methodNotFound("\(methodName) with \(args.count) arguments"))
                return false
            }
        }
    }

    // MARK: - UIKit 方法处理

    private func handleAddTarget(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard let control = base as? PlatformControl,
              args.count >= 2,
              let action = args[1] as? Selector else {
            chain.errors.append(.runtimeError("addTarget 参数错误或对象不是 PlatformControl"))
            return false
        }

        #if os(iOS)
        // iOS 需要控件事件参数
        guard args.count >= 3,
              let controlEvents = args[2] as? PlatformControlEvent else {
            chain.errors.append(.runtimeError("iOS addTarget 需要提供控件事件参数"))
            return false
        }
        control.addTarget(args[0], action: action, for: controlEvents)
        #elseif os(macOS)
        // macOS 使用不同的目标-动作机制
        control.target = args[0] as AnyObject?
        control.action = action
        #endif

        return true
    }

    private func handleSetTitle(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1,
               let title = args[0] as? String,
              let button = base as? PlatformButton else {
            chain.errors.append(.runtimeError("setTitle 参数错误或对象不是 PlatformButton"))
            return false
        }

        #if os(iOS)
        let state = args.count >= 2 ? (args[1] as? PlatformControlState ?? .normal) : .normal
        button.setTitle(title, for: state)
        #elseif os(macOS)
        button.title = title
        #endif
        return true
    }

    private func handleSetTitleColor(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1,
               let color = args[0] as? PlatformColor,
              let button = base as? PlatformButton else {
            chain.errors.append(.runtimeError("setTitleColor 参数错误或对象不是 PlatformButton"))
            return false
        }

        #if os(iOS)
        let state = args.count >= 2 ? (args[1] as? PlatformControlState ?? .normal) : .normal
        button.setTitleColor(color, for: state)
        #elseif os(macOS)
        button.contentTintColor = color
        #endif
        return true
    }

    private func handleSetImage(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1,
               let image = args[0] as? PlatformImage,
              let button = base as? PlatformButton else {
            chain.errors.append(.runtimeError("setImage 参数错误或对象不是 PlatformButton"))
            return false
        }

        #if os(iOS)
        let state = args.count >= 2 ? (args[1] as? PlatformControlState ?? .normal) : .normal
        button.setImage(image, for: state)
        #elseif os(macOS)
        button.image = image
        #endif
        return true
    }

    private func handleSetBackgroundImage(args: [Any], chain: inout TFYChain<T>) -> Bool {
        #if os(iOS)
        guard args.count >= 1,
               let image = args[0] as? PlatformImage,
              let button = base as? PlatformButton else {
            chain.errors.append(.runtimeError("setBackgroundImage 参数错误或对象不是 PlatformButton"))
            return false
        }

        let state = args.count >= 2 ? (args[1] as? PlatformControlState ?? .normal) : .normal
        button.setBackgroundImage(image, for: state)
        return true
        #elseif os(macOS)
        chain.errors.append(.runtimeError("setBackgroundImage 在 macOS 上不受支持"))
        return false
        #endif
    }

    private func handleSetText(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1,
              let text = args[0] as? String else {
            chain.errors.append(.runtimeError("setText 参数错误"))
            return false
        }

        // 平台标签文本设置
        if let label = base as? PlatformLabel {
            #if os(iOS)
            label.text = text
            #elseif os(macOS)
            label.stringValue = text
            #endif
            return true
        }

        // 平台文本输入框文本设置
        if let textField = base as? PlatformTextField {
            #if os(iOS)
            textField.text = text
            #elseif os(macOS)
            textField.stringValue = text
            #endif
            return true
        }

        // 平台文本视图文本设置
        if let textView = base as? PlatformTextView {
            #if os(iOS)
            textView.text = text
            #elseif os(macOS)
            textView.string = text
            #endif
            return true
        }

        chain.errors.append(.runtimeError("setText 对象类型不支持"))
        return false
    }

    private func handleSetTextColor(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1,
              let color = args[0] as? PlatformColor else {
            chain.errors.append(.runtimeError("setTextColor 参数错误"))
            return false
        }

        // 平台标签文本颜色设置
        if let label = base as? PlatformLabel {
            #if os(iOS)
            label.textColor = color
            #elseif os(macOS)
            label.textColor = color
            #endif
            return true
        }

        // 平台文本输入框文本颜色设置
        if let textField = base as? PlatformTextField {
            textField.textColor = color
            return true
        }

        // 平台文本视图文本颜色设置
        if let textView = base as? PlatformTextView {
            textView.textColor = color
            return true
        }

        chain.errors.append(.runtimeError("setTextColor 对象类型不支持"))
        return false
    }

    private func handleSetFont(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1,
              let font = args[0] as? PlatformFont else {
            chain.errors.append(.runtimeError("setFont 参数错误"))
            return false
        }

        // 平台标签字体设置
        if let label = base as? PlatformLabel {
            label.font = font
            return true
        }

        // 平台文本输入框字体设置
        if let textField = base as? PlatformTextField {
            textField.font = font
            return true
        }

        // 平台文本视图字体设置
        if let textView = base as? PlatformTextView {
            textView.font = font
            return true
        }

        // 平台按钮字体设置
        if let button = base as? PlatformButton {
            #if os(iOS)
            button.titleLabel?.font = font
            #elseif os(macOS)
            // macOS 按钮字体设置需要通过 attributedTitle
            let title = button.title as String?
            if let title = title {
                let attributes: [PlatformAttributedString.Key: Any] = [.font: font]
                button.attributedTitle = PlatformAttributedString(string: title, attributes: attributes)
            }
            #endif
            return true
        }

        chain.errors.append(.runtimeError("setFont 对象类型不支持"))
        return false
    }

    private func handleSetImageViewImage(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1,
              let image = args[0] as? PlatformImage,
              let imageView = base as? PlatformImageView else {
            chain.errors.append(.runtimeError("setImageViewImage 参数错误或对象不是 PlatformImageView"))
            return false
        }

        imageView.image = image
        return true
    }

    private func handleSetContentMode(args: [Any], chain: inout TFYChain<T>) -> Bool {
        guard args.count >= 1 else {
            chain.errors.append(.runtimeError("setContentMode 参数错误"))
            return false
        }

        #if os(iOS)
        // iOS: 处理 UIView 的 contentMode
        guard let contentMode = args[0] as? PlatformContentMode,
              let view = base as? PlatformView else {
            chain.errors.append(.runtimeError("setContentMode 参数错误或对象不是 PlatformView"))
            return false
        }

        view.contentMode = contentMode
        return true

        #elseif os(macOS)
        // macOS: 处理 NSImageView 的 imageScaling
        guard let imageView = base as? PlatformImageView else {
            chain.errors.append(.runtimeError("setContentMode 参数错误或对象不是 PlatformImageView"))
            return false
        }

        if let scaling = args[0] as? PlatformContentMode {
            imageView.imageScaling = scaling
        } else if let rawValue = args[0] as? UInt, let scaling = PlatformContentMode(rawValue: rawValue) {
            imageView.imageScaling = scaling
        } else {
            chain.errors.append(.runtimeError("setContentMode 参数类型错误，需要 PlatformContentMode"))
            return false
        }
        return true
        #endif
    }
    }

// MARK: - Struct 链式容器

/// 为 struct 类型设计的链式容器
public struct TFYStructChain<T>: TFYChainableProtocol, TFYChainErrorHandling, TFYChainPerformanceMonitoring, TFYChainAdvancedFeatures {

    // MARK: - 协议实现

    public typealias ChainType = TFYStructChain<T>
    public typealias BaseType = T

    /// 原始对象
    public var base: T

    /// 错误收集器
    public var errors: [TFYChainError] = []

    /// 性能监控器
    public var performanceMetrics: [String: TimeInterval] = [:]

    /// 是否启用性能监控
    private var isPerformanceMonitoringEnabled: Bool = false

    /// 是否启用调试输出
    private var isDebugEnabled: Bool = false

    // MARK: - 初始化

    /// 初始化链式容器
    /// - Parameters:
    ///   - base: 原始对象
    ///   - enablePerformanceMonitoring: 是否启用性能监控
    ///   - enableDebug: 是否启用调试输出
    public init(_ base: T, enablePerformanceMonitoring: Bool = false, enableDebug: Bool = false) {
        self.base = base
        self.isPerformanceMonitoringEnabled = enablePerformanceMonitoring
        self.isDebugEnabled = enableDebug
    }

    /// 获取原始对象
    public var build: T { return base }

    /// 是否包含错误
    public var hasErrors: Bool { return !errors.isEmpty }

    /// 当前错误数量
    public var errorCount: Int { return errors.count }

    /// 是否有性能指标
    public var hasPerformanceMetrics: Bool { return !performanceMetrics.isEmpty }

    // MARK: - 配置方法

    /// 启用性能监控
    /// - Returns: 链式容器
    public func enablePerformanceMonitoring() -> TFYStructChain<T> {
        var newChain = self
        newChain.isPerformanceMonitoringEnabled = true
        return newChain
    }

    /// 启用调试输出
    /// - Returns: 链式容器
    public func enableDebug() -> TFYStructChain<T> {
        var newChain = self
        newChain.isDebugEnabled = true
        return newChain
    }

    /// 关闭性能监控
    /// - Returns: 链式容器
    public func disablePerformanceMonitoring() -> TFYStructChain<T> {
        var newChain = self
        newChain.isPerformanceMonitoringEnabled = false
        return newChain
    }

    /// 关闭调试输出
    /// - Returns: 链式容器
    public func disableDebug() -> TFYStructChain<T> {
        var newChain = self
        newChain.isDebugEnabled = false
        return newChain
    }

    // MARK: - KeyPath 支持

    /// 使用 KeyPath 设置属性值
    /// - Parameters:
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func set<Value>(_ keyPath: WritableKeyPath<T, Value>, _ value: Value) -> TFYStructChain<T> {
        let startTime = isPerformanceMonitoringEnabled ? CFAbsoluteTimeGetCurrent() : 0
            var newChain = self

        newChain.base[keyPath: keyPath] = value

        if isPerformanceMonitoringEnabled {
            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            let keyPathString = String(describing: keyPath)
            newChain.performanceMetrics[keyPathString] = elapsed
        }

        if isDebugEnabled {
        print("TFYStructChain: 通过KeyPath设置属性 \(keyPath) 值为: \(value)")
        }

            return newChain
    }

    /// 使用 KeyPath 设置属性值（带 to: 标签，保持引用类型链式 API 一致）
    /// - Parameters:
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func set<Value>(_ keyPath: WritableKeyPath<T, Value>, to value: Value) -> TFYStructChain<T> {
        return set(keyPath, value)
    }

    /// 条件 KeyPath 设置
    /// - Parameters:
    ///   - condition: 条件
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func setIf<Value>(_ condition: Bool, _ keyPath: WritableKeyPath<T, Value>, _ value: Value) -> TFYStructChain<T> {
        return condition ? set(keyPath, value) : self
    }

    /// 条件 KeyPath 设置（带 to: 标签）
    /// - Parameters:
    ///   - condition: 条件
    ///   - keyPath: 属性 KeyPath
    ///   - value: 要设置的值
    /// - Returns: 链式容器
    @discardableResult
    public func setIf<Value>(_ condition: Bool, _ keyPath: WritableKeyPath<T, Value>, to value: Value) -> TFYStructChain<T> {
        return condition ? set(keyPath, to: value) : self
    }

    /// 可选值存在时设置属性
    /// - Parameters:
    ///   - keyPath: 属性 KeyPath
    ///   - value: 可选属性值
    /// - Returns: 链式容器
    @discardableResult
    public func setIfPresent<Value>(_ keyPath: WritableKeyPath<T, Value>, to value: Value?) -> TFYStructChain<T> {
        guard let value = value else { return self }
        return set(keyPath, to: value)
    }

    /// 批量设置属性（使用链式调用）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 链式容器
    @discardableResult
    public func setMultiple(_ configurator: (inout T) -> Void) -> TFYStructChain<T> {
        var newChain = self
        configurator(&newChain.base)
        return newChain
    }

    // MARK: - 错误处理和性能监控协议实现

    /// 错误处理回调
    /// - Parameter handler: 错误处理闭包
    /// - Returns: 链式容器
    @discardableResult
    public func onError(_ handler: @escaping ([TFYChainError]) -> Void) -> TFYStructChain<T> {
        if !errors.isEmpty {
            handler(errors)
        }
        return self
    }

    /// 无错误时执行成功回调
    /// - Parameter handler: 成功处理闭包
    /// - Returns: 链式容器
    @discardableResult
    public func onSuccess(_ handler: (T) -> Void) -> TFYStructChain<T> {
        if errors.isEmpty {
            handler(base)
        }
        return self
    }

    /// 清空当前链路错误
    /// - Returns: 链式容器
    @discardableResult
    public func clearErrors() -> TFYStructChain<T> {
        var newChain = self
        newChain.errors.removeAll()
        return newChain
    }

    /// 按严重级别移除错误
    /// - Parameter severity: 要移除的错误级别
    /// - Returns: 链式容器
    @discardableResult
    public func clearErrors(severity: ErrorSeverity) -> TFYStructChain<T> {
        var newChain = self
        newChain.errors.removeAll { $0.severity == severity }
        return newChain
    }

    /// 按严重级别获取错误
    /// - Parameter severity: 错误级别
    /// - Returns: 匹配的错误数组
    public func filteredErrors(severity: ErrorSeverity) -> [TFYChainError] {
        return errors.filter { $0.severity == severity }
    }

    /// 错误摘要，适合日志和埋点上报
    public var errorSummary: [String: Int] {
        let groupedErrors = Dictionary(grouping: errors) { $0.severity.description }
        return groupedErrors.mapValues { $0.count }
    }

    /// 性能监控回调
    /// - Parameter handler: 性能监控闭包
    /// - Returns: 链式容器
    @discardableResult
    public func onPerformance(_ handler: @escaping ([String: TimeInterval]) -> Void) -> TFYStructChain<T> {
        if !performanceMetrics.isEmpty {
            handler(performanceMetrics)
        }
        return self
    }

    /// 清空性能指标
    /// - Returns: 链式容器
    @discardableResult
    public func resetPerformanceMetrics() -> TFYStructChain<T> {
        var newChain = self
        newChain.performanceMetrics.removeAll()
        return newChain
    }

    /// 获取毫秒单位的性能指标
    public var performanceMetricsInMilliseconds: [String: Double] {
        return performanceMetrics.mapValues { $0 * 1000 }
    }

    // MARK: - 高级功能协议实现

    /// 批量应用多个链式操作
    /// - Parameter operations: 链式操作列表
    /// - Returns: 链式容器
    @discardableResult
    public func apply(_ operations: ((TFYStructChain<T>) -> TFYStructChain<T>)...) -> TFYStructChain<T> {
        return operations.reduce(self) { partialResult, operation in
            operation(partialResult)
        }
    }

    /// 批量应用多个链式操作（数组版本）
    /// - Parameter operations: 链式操作数组
    /// - Returns: 链式容器
    @discardableResult
    public func applyAll(_ operations: [(TFYStructChain<T>) -> TFYStructChain<T>]) -> TFYStructChain<T> {
        return operations.reduce(self) { partialResult, operation in
            operation(partialResult)
        }
    }

    /// 延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func delay(_ delay: TimeInterval, _ block: @escaping (T) -> Void) -> TFYStructChain<T> {
        // 对于值类型，复制一份避免引用问题
        let baseCopy = base
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block(baseCopy)
        }
        return self
    }

    /// 链式日志
    /// - Parameter message: 日志消息
    /// - Returns: 链式容器
    @discardableResult
    public func log(_ message: String) -> TFYStructChain<T> {
        print("TFYStructChain[\(String(describing: type(of: base)))]: \(message)")
        return self
    }

    /// 配置闭包
    /// - Parameter block: 配置闭包
    /// - Returns: 链式容器
    @discardableResult
    public func configure(_ block: (T) -> Void) -> TFYStructChain<T> {
        block(base)
        return self
    }

    /// 异步执行
    /// - Parameters:
    ///   - queue: 执行队列
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func async(_ queue: DispatchQueue = .main, _ block: @escaping (T) -> Void) -> TFYStructChain<T> {
        // 对于值类型，复制一份避免引用问题
        let baseCopy = base
        queue.async {
            block(baseCopy)
        }
        return self
    }

    /// 重复执行
    /// - Parameters:
    ///   - count: 重复次数
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func `repeat`(_ count: Int, _ block: (T) -> Void) -> TFYStructChain<T> {
        for _ in 0..<count {
            block(base)
        }
        return self
    }

    /// 条件执行
    /// - Parameters:
    ///   - condition: 条件
    ///   - block: 执行闭包
    /// - Returns: 链式容器
    @discardableResult
    public func when(_ condition: Bool, _ block: (T) -> Void) -> TFYStructChain<T> {
        if condition {
            block(base)
        }
        return self
    }
}

// MARK: - 扩展支持

/// UIKit 组件链式调用扩展
public extension NSObject {
    /// 通用链式容器
    func tfy() -> TFYChain<NSObject> {return TFYChain(self)}

    /// 启用调试的链式容器
    func tfyDebug() -> TFYChain<NSObject> {return TFYChain(self, enableDebug: true)}

    /// 启用性能监控的链式容器
    func tfyPerformance() -> TFYChain<NSObject> {return TFYChain(self, enablePerformanceMonitoring: true)}

    /// 启用所有功能的链式容器
    func tfyFull() -> TFYChain<NSObject> {return TFYChain(self, enablePerformanceMonitoring: true, enableDebug: true)}
}
// MARK: - 便利方法

/// 链式调用便利方法
public class TFYChainHelper {

    // MARK: - 基础便利方法

    /// 创建链式容器的便利方法
    /// - Parameter object: 目标对象
    /// - Returns: 链式容器
    public static func chain<T: NSObject>(_ object: T) -> TFYChain<T> {
        return TFYChain(object)
    }

    /// 批量链式操作
    /// - Parameters:
    ///   - objects: 对象数组
    ///   - operation: 操作闭包
    public static func batchChain<T: NSObject>(_ objects: [T], operation: (TFYChain<T>) -> TFYChain<T>) {
        for object in objects {
            _ = operation(TFYChain(object))
        }
    }

    /// 批量链式操作并返回原对象数组，便于继续传递给布局或数据源
    /// - Parameters:
    ///   - objects: 对象数组
    ///   - operation: 操作闭包
    /// - Returns: 配置后的原对象数组
    @discardableResult
    public static func configuredObjects<T: NSObject>(_ objects: [T], operation: (TFYChain<T>) -> TFYChain<T>) -> [T] {
        for object in objects {
            _ = operation(TFYChain(object))
        }
        return objects
    }

    /// 批量生成链式容器
    /// - Parameter objects: 对象数组
    /// - Returns: 链式容器数组
    public static func chains<T: NSObject>(for objects: [T]) -> [TFYChain<T>] {
        return objects.map { TFYChain($0) }
    }

    /// 批量条件设置
    /// - Parameters:
    ///   - objects: 对象数组
    ///   - condition: 条件
    ///   - operation: 操作闭包
    public static func batchChainIf<T: NSObject>(_ objects: [T], condition: Bool, operation: (TFYChain<T>) -> TFYChain<T>) {
        guard condition else { return }
        batchChain(objects, operation: operation)
    }

    /// 条件批量链式操作并返回原对象数组
    /// - Parameters:
    ///   - objects: 对象数组
    ///   - condition: 条件
    ///   - operation: 操作闭包
    /// - Returns: 配置后的原对象数组
    @discardableResult
    public static func configuredObjectsIf<T: NSObject>(_ objects: [T], condition: Bool, operation: (TFYChain<T>) -> TFYChain<T>) -> [T] {
        guard condition else { return objects }
        return configuredObjects(objects, operation: operation)
    }

    // MARK: - 跨平台组件创建方法

    /// 创建并配置标签（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的标签
    public static func createLabel(_ configurator: (TFYChain<PlatformLabel>) -> TFYChain<PlatformLabel>) -> PlatformLabel {
        #if os(iOS)
        let label = UILabel()
        #elseif os(macOS)
        let label = NSTextField()
        label.isEditable = false
        label.isSelectable = false
        label.drawsBackground = true
        #endif

        _ = configurator(label.labelChain)
        return label
    }

    /// 创建并配置按钮（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的按钮
    public static func createButton(_ configurator: (TFYChain<PlatformButton>) -> TFYChain<PlatformButton>) -> PlatformButton {
        #if os(iOS)
        let button = UIButton(type: .system)
        #elseif os(macOS)
        let button = NSButton()
        button.bezelStyle = .rounded
        #endif

        _ = configurator(button.buttonChain)
        return button
    }

    /// 创建并配置图片视图（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的图片视图
    public static func createImageView(_ configurator: (TFYChain<PlatformImageView>) -> TFYChain<PlatformImageView>) -> PlatformImageView {
        #if os(iOS)
        let imageView = UIImageView()
        #elseif os(macOS)
        let imageView = NSImageView()
        #endif

        _ = configurator(imageView.imageChain)
        return imageView
    }

    /// 创建并配置文本输入框（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的文本输入框
    public static func createTextField(_ configurator: (TFYChain<PlatformTextField>) -> TFYChain<PlatformTextField>) -> PlatformTextField {
        #if os(iOS)
        let textField = UITextField()
        #elseif os(macOS)
        let textField = NSTextField()
        #endif

        _ = configurator(textField.textFieldChain)
        return textField
    }

    /// 创建并配置文本视图（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的文本视图
    public static func createTextView(_ configurator: (TFYChain<PlatformTextView>) -> TFYChain<PlatformTextView>) -> PlatformTextView {
        #if os(iOS)
        let textView = UITextView()
        #elseif os(macOS)
        let textView = NSTextView()
        #endif

        _ = configurator(textView.textViewChain)
        return textView
    }

    /// 创建并配置滚动视图（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的滚动视图
    public static func createScrollView(_ configurator: (TFYChain<PlatformScrollView>) -> TFYChain<PlatformScrollView>) -> PlatformScrollView {
        #if os(iOS)
        let scrollView = UIScrollView()
        #elseif os(macOS)
        let scrollView = NSScrollView()
        #endif

        _ = configurator(scrollView.scrollChain)
        return scrollView
    }

    /// 创建并配置堆栈视图（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的堆栈视图
    public static func createStackView(_ configurator: (TFYChain<PlatformStackView>) -> TFYChain<PlatformStackView>) -> PlatformStackView {
        #if os(iOS)
        let stackView = UIStackView()
        #elseif os(macOS)
        let stackView = NSStackView()
        #endif

        _ = configurator(stackView.stackChain)
        return stackView
    }

    // MARK: - 批量操作方法

    /// 批量设置相同属性
    /// - Parameters:
    ///   - objects: 对象数组
    ///   - keyPath: 属性路径
    ///   - value: 属性值
    public static func batchSet<T: NSObject, V>(_ objects: [T], _ keyPath: WritableKeyPath<T, V>, to value: V) {
        for object in objects {
            _ = TFYChain(object).set(keyPath, to: value)
        }
    }

    /// 批量设置相同属性（字符串方式）
    /// - Parameters:
    ///   - objects: 对象数组
    ///   - propertyName: 属性名
    ///   - value: 属性值
    public static func batchSet<T: NSObject>(_ objects: [T], _ propertyName: String, to value: Any) {
        for object in objects {
            _ = TFYRuntimeUtils.safeSetValue(value, forKey: propertyName, in: object)
        }
    }

    // MARK: - 结构体链式支持

    /// 结构体链式构建器
    public struct StructChainBuilder<T> {
        private var value: T

        public init(_ value: T) {
            self.value = value
        }

        /// 设置属性值
        /// - Parameters:
        ///   - keyPath: 属性路径
        ///   - newValue: 新值
        /// - Returns: 链式构建器
        @discardableResult
        public func set<V>(_ keyPath: WritableKeyPath<T, V>, _ newValue: V) -> StructChainBuilder<T> {
            var newBuilder = self
            newBuilder.value[keyPath: keyPath] = newValue
            return newBuilder
        }

        /// 设置属性值（带 to: 标签）
        /// - Parameters:
        ///   - keyPath: 属性路径
        ///   - newValue: 新值
        /// - Returns: 链式构建器
        @discardableResult
        public func set<V>(_ keyPath: WritableKeyPath<T, V>, to newValue: V) -> StructChainBuilder<T> {
            return set(keyPath, newValue)
        }

        /// 条件设置属性值
        /// - Parameters:
        ///   - condition: 条件
        ///   - keyPath: 属性路径
        ///   - newValue: 新值
        /// - Returns: 链式构建器
        @discardableResult
        public func setIf<V>(_ condition: Bool, _ keyPath: WritableKeyPath<T, V>, _ newValue: V) -> StructChainBuilder<T> {
            var newBuilder = self
            if condition {
                newBuilder.value[keyPath: keyPath] = newValue
            }
            return newBuilder
        }

        /// 条件设置属性值（带 to: 标签）
        /// - Parameters:
        ///   - condition: 条件
        ///   - keyPath: 属性路径
        ///   - newValue: 新值
        /// - Returns: 链式构建器
        @discardableResult
        public func setIf<V>(_ condition: Bool, _ keyPath: WritableKeyPath<T, V>, to newValue: V) -> StructChainBuilder<T> {
            return setIf(condition, keyPath, newValue)
        }

        /// 可选值存在时设置属性值
        /// - Parameters:
        ///   - keyPath: 属性路径
        ///   - newValue: 可选新值
        /// - Returns: 链式构建器
        @discardableResult
        public func setIfPresent<V>(_ keyPath: WritableKeyPath<T, V>, to newValue: V?) -> StructChainBuilder<T> {
            guard let newValue = newValue else { return self }
            return set(keyPath, newValue)
        }

        /// 使用闭包批量配置值
        /// - Parameter configurator: 配置闭包
        /// - Returns: 链式构建器
        @discardableResult
        public func configure(_ configurator: (inout T) -> Void) -> StructChainBuilder<T> {
            var newBuilder = self
            configurator(&newBuilder.value)
            return newBuilder
        }

        /// 构建最终结果
        public var build: T {
            return value
        }
    }

    /// 创建结构体链式构建器
    /// - Parameter value: 初始值
    /// - Returns: 链式构建器
    public static func structChain<T>(_ value: T) -> StructChainBuilder<T> {
        return StructChainBuilder(value)
    }

    // MARK: - 跨平台便利方法

    /// 创建视图（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的视图
    public static func createView(_ configurator: (TFYChain<PlatformView>) -> TFYChain<PlatformView>) -> PlatformView {
        #if os(iOS)
        let view = UIView()
        #elseif os(macOS)
        let view = NSView()
        #endif

        _ = configurator(view.chain)
        return view
    }

    /// 创建滑块（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的滑块
    public static func createSlider(_ configurator: (TFYChain<PlatformSlider>) -> TFYChain<PlatformSlider>) -> PlatformSlider {
        #if os(iOS)
        let slider = UISlider()
        #elseif os(macOS)
        let slider = NSSlider()
        #endif

        _ = configurator(slider.sliderChain)
        return slider
    }

    /// 创建进度指示器（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的进度指示器
    public static func createProgressView(_ configurator: (TFYChain<PlatformProgressView>) -> TFYChain<PlatformProgressView>) -> PlatformProgressView {
        #if os(iOS)
        let progressView = UIProgressView(progressViewStyle: .default)
        #elseif os(macOS)
        let progressView = NSProgressIndicator()
        progressView.style = .bar
        #endif

        _ = configurator(progressView.progressChain)
        return progressView
    }

    /// 创建分段控制器（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的分段控制器
    public static func createSegmentedControl(_ configurator: (TFYChain<PlatformSegmentedControl>) -> TFYChain<PlatformSegmentedControl>) -> PlatformSegmentedControl {
        #if os(iOS)
        let segmentedControl = UISegmentedControl()
        #elseif os(macOS)
        let segmentedControl = NSSegmentedControl()
        #endif

        _ = configurator(segmentedControl.segmentChain)
        return segmentedControl
    }

    /// 创建点击手势识别器（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的点击手势识别器
    public static func createTapGesture(_ configurator: (TFYChain<PlatformTapGestureRecognizer>) -> TFYChain<PlatformTapGestureRecognizer>) -> PlatformTapGestureRecognizer {
        #if os(iOS)
        let gesture = UITapGestureRecognizer()
        #elseif os(macOS)
        let gesture = NSClickGestureRecognizer()
        #endif

        _ = configurator(gesture.tapGestureChain)
        return gesture
    }

    /// 创建拖拽手势识别器（跨平台）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的拖拽手势识别器
    public static func createPanGesture(_ configurator: (TFYChain<PlatformPanGestureRecognizer>) -> TFYChain<PlatformPanGestureRecognizer>) -> PlatformPanGestureRecognizer {
        #if os(iOS)
        let gesture = UIPanGestureRecognizer()
        #elseif os(macOS)
        let gesture = NSPanGestureRecognizer()
        #endif

        _ = configurator(gesture.panGestureChain)
        return gesture
    }

    // MARK: - 平台特定创建方法

    #if os(iOS)
    /// 创建开关（iOS特有）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的开关
    public static func createSwitch(_ configurator: (TFYChain<UISwitch>) -> TFYChain<UISwitch>) -> UISwitch {
        let switchControl = UISwitch()
        _ = configurator(switchControl.switchChain)
        return switchControl
    }

    /// 创建活动指示器（iOS特有）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的活动指示器
    public static func createActivityIndicator(_ configurator: (TFYChain<UIActivityIndicatorView>) -> TFYChain<UIActivityIndicatorView>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        _ = configurator(activityIndicator.activityIndicatorChain)
        return activityIndicator
    }
    #endif

    #if os(macOS)
    /// 创建弹出按钮（macOS特有）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的弹出按钮
    public static func createPopUpButton(_ configurator: (TFYChain<NSPopUpButton>) -> TFYChain<NSPopUpButton>) -> NSPopUpButton {
        let popUpButton = NSPopUpButton()
        _ = configurator(popUpButton.popUpButtonChain)
        return popUpButton
    }

    /// 创建颜色选择器（macOS特有）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的颜色选择器
    public static func createColorWell(_ configurator: (TFYChain<NSColorWell>) -> TFYChain<NSColorWell>) -> NSColorWell {
        let colorWell = NSColorWell()
        _ = configurator(colorWell.colorWellChain)
        return colorWell
    }

    /// 创建等级指示器（macOS特有）
    /// - Parameter configurator: 配置闭包
    /// - Returns: 配置好的等级指示器
    public static func createLevelIndicator(_ configurator: (TFYChain<NSLevelIndicator>) -> TFYChain<NSLevelIndicator>) -> NSLevelIndicator {
        let levelIndicator = NSLevelIndicator()
        _ = configurator(levelIndicator.levelIndicatorChain)
        return levelIndicator
    }
    #endif
}

// MARK: - 性能优化
/// 性能优化配置
public struct TFYChainPerformanceConfig {
    /// 是否启用缓存
    public static var cacheEnabled: Bool = true

    /// 缓存最大大小
    public static var maxCacheSize: Int = 1000

    /// 性能警告阈值（毫秒）
    public static var performanceWarningThreshold: TimeInterval = 1.0

    /// 清理缓存
    public static func clearAllCaches() {
        TFYRuntimeUtils.clearCache()
    }
}

// MARK: - 跨平台组件扩展

/// 为跨平台组件提供统一的扩展
public extension PlatformView {
    /// 平台视图链式容器（跨平台通用）
    var chain: TFYChain<PlatformView> { TFYChain(self) }
}

/// 为跨平台组件提供类型安全的便利方法
public extension PlatformLabel {
    /// 平台标签类型安全链式容器（跨平台）
    var labelChain: TFYChain<PlatformLabel> { TFYChain(self) }
}

public extension PlatformButton {
    /// 平台按钮类型安全链式容器（跨平台）
    var buttonChain: TFYChain<PlatformButton> { TFYChain(self) }
}

public extension PlatformImageView {
    /// 平台图片视图类型安全链式容器（跨平台）
    var imageChain: TFYChain<PlatformImageView> { TFYChain(self) }
}

public extension PlatformTextField {
    /// 平台文本输入框类型安全链式容器（跨平台）
    var textFieldChain: TFYChain<PlatformTextField> { TFYChain(self) }
}

public extension PlatformTextView {
    /// 平台文本视图类型安全链式容器（跨平台）
    var textViewChain: TFYChain<PlatformTextView> { TFYChain(self) }
}

public extension PlatformScrollView {
    /// 平台滚动视图类型安全链式容器（跨平台）
    var scrollChain: TFYChain<PlatformScrollView> { TFYChain(self) }
}

public extension PlatformStackView {
    /// 平台堆栈视图类型安全链式容器（跨平台）
    var stackChain: TFYChain<PlatformStackView> { TFYChain(self) }
}

public extension PlatformSlider {
    /// 平台滑块类型安全链式容器（跨平台）
    var sliderChain: TFYChain<PlatformSlider> { TFYChain(self) }
}

public extension PlatformProgressView {
    /// 平台进度视图类型安全链式容器（跨平台）
    var progressChain: TFYChain<PlatformProgressView> { TFYChain(self) }
}

public extension PlatformSegmentedControl {
    /// 平台分段控制器类型安全链式容器（跨平台）
    var segmentChain: TFYChain<PlatformSegmentedControl> { TFYChain(self) }
}

public extension PlatformGestureRecognizer {
    /// 平台手势识别器通用链式容器（跨平台）
    var gestureChain: TFYChain<PlatformGestureRecognizer> { TFYChain(self) }
}

public extension PlatformTapGestureRecognizer {
    /// 平台点击手势识别器类型安全链式容器（跨平台）
    var tapGestureChain: TFYChain<PlatformTapGestureRecognizer> { TFYChain(self) }
}

public extension PlatformPanGestureRecognizer {
    /// 平台拖拽手势识别器类型安全链式容器（跨平台）
    var panGestureChain: TFYChain<PlatformPanGestureRecognizer> { TFYChain(self) }
}

// MARK: - iOS 特有组件扩展
#if os(iOS)

public extension UIControl {
    var controlChain: TFYChain<UIControl> { TFYChain(self) }
}

public extension UITableView {
    /// UITableView 类型安全链式容器
    var tableChain: TFYChain<UITableView> { TFYChain(self) }
}

public extension UICollectionView {
    /// UICollectionView 类型安全链式容器
    var collectionChain: TFYChain<UICollectionView> { TFYChain(self) }
}

public extension UISwitch {
    /// UISwitch 类型安全链式容器
    var switchChain: TFYChain<UISwitch> { TFYChain(self) }
}

public extension UIActivityIndicatorView {
    /// UIActivityIndicatorView 类型安全链式容器
    var activityIndicatorChain: TFYChain<UIActivityIndicatorView> { TFYChain(self) }
}

public extension UIDatePicker {
    /// UIDatePicker 类型安全链式容器
    var datePickerChain: TFYChain<UIDatePicker> { TFYChain(self) }
}

public extension UIPickerView {
    /// UIPickerView 类型安全链式容器
    var pickerChain: TFYChain<UIPickerView> { TFYChain(self) }
}

public extension UINavigationBar {
    /// UINavigationBar 类型安全链式容器
    var navigationBarChain: TFYChain<UINavigationBar> { TFYChain(self) }
}

public extension UITabBar {
    /// UITabBar 类型安全链式容器
    var tabBarChain: TFYChain<UITabBar> { TFYChain(self) }
}

public extension UIToolbar {
    /// UIToolbar 类型安全链式容器
    var toolbarChain: TFYChain<UIToolbar> { TFYChain(self) }
}

public extension UISearchBar {
    /// UISearchBar 类型安全链式容器
    var searchBarChain: TFYChain<UISearchBar> { TFYChain(self) }
}

public extension UIPageControl {
    /// UIPageControl 类型安全链式容器
    var pageControlChain: TFYChain<UIPageControl> { TFYChain(self) }
}

public extension UIStepper {
    /// UIStepper 类型安全链式容器
    var stepperChain: TFYChain<UIStepper> { TFYChain(self) }
}

public extension UIVisualEffectView {
    /// UIVisualEffectView 类型安全链式容器
    var visualEffectChain: TFYChain<UIVisualEffectView> { TFYChain(self) }
}

// iOS 特有手势识别器扩展
public extension UIPinchGestureRecognizer {
    /// UIPinchGestureRecognizer 类型安全链式容器
    var pinchGestureChain: TFYChain<UIPinchGestureRecognizer> { TFYChain(self) }
}

public extension UIRotationGestureRecognizer {
    /// UIRotationGestureRecognizer 类型安全链式容器
    var rotationGestureChain: TFYChain<UIRotationGestureRecognizer> { TFYChain(self) }
}

public extension UISwipeGestureRecognizer {
    /// UISwipeGestureRecognizer 类型安全链式容器
    var swipeGestureChain: TFYChain<UISwipeGestureRecognizer> { TFYChain(self) }
}

public extension UILongPressGestureRecognizer {
    /// UILongPressGestureRecognizer 类型安全链式容器
    var longPressGestureChain: TFYChain<UILongPressGestureRecognizer> { TFYChain(self) }
}

#endif

// MARK: - 跨平台高级组件扩展

public extension PlatformViewController {
    /// 平台视图控制器类型安全链式容器（跨平台）
    var viewControllerChain: TFYChain<PlatformViewController> { TFYChain(self) }
}

public extension PlatformWindow {
    /// 平台窗口类型安全链式容器（跨平台）
    var windowChain: TFYChain<PlatformWindow> { TFYChain(self) }
}

public extension PlatformLayer {
    /// 平台图层类型安全链式容器（跨平台）
    var layerChain: TFYChain<PlatformLayer> { TFYChain(self) }
}

// MARK: - macOS 平台特有组件扩展

#if os(macOS)

public extension NSPopUpButton {
    /// NSPopUpButton 类型安全链式容器
    var popUpButtonChain: TFYChain<NSPopUpButton> { TFYChain(self) }
}

public extension NSComboBox {
    /// NSComboBox 类型安全链式容器
    var comboBoxChain: TFYChain<NSComboBox> { TFYChain(self) }
}

public extension NSColorWell {
    /// NSColorWell 类型安全链式容器
    var colorWellChain: TFYChain<NSColorWell> { TFYChain(self) }
}

public extension NSDatePicker {
    /// NSDatePicker 类型安全链式容器
    var nsDatePickerChain: TFYChain<NSDatePicker> { TFYChain(self) }
}

public extension NSLevelIndicator {
    /// NSLevelIndicator 类型安全链式容器
    var levelIndicatorChain: TFYChain<NSLevelIndicator> { TFYChain(self) }
}

public extension NSPathControl {
    /// NSPathControl 类型安全链式容器
    var pathControlChain: TFYChain<NSPathControl> { TFYChain(self) }
}

public extension NSSearchField {
    /// NSSearchField 类型安全链式容器
    var searchFieldChain: TFYChain<NSSearchField> { TFYChain(self) }
}

public extension NSSecureTextField {
    /// NSSecureTextField 类型安全链式容器
    var secureTextFieldChain: TFYChain<NSSecureTextField> { TFYChain(self) }
}

public extension NSTableView {
    /// NSTableView 类型安全链式容器
    var nsTableViewChain: TFYChain<NSTableView> { TFYChain(self) }
}

public extension NSOutlineView {
    /// NSOutlineView 类型安全链式容器
    var outlineViewChain: TFYChain<NSOutlineView> { TFYChain(self) }
}

public extension NSCollectionView {
    /// NSCollectionView 类型安全链式容器
    var nsCollectionViewChain: TFYChain<NSCollectionView> { TFYChain(self) }
}

public extension NSBox {
    /// NSBox 类型安全链式容器
    var boxChain: TFYChain<NSBox> { TFYChain(self) }
}

public extension NSTabView {
    /// NSTabView 类型安全链式容器
    var tabViewChain: TFYChain<NSTabView> { TFYChain(self) }
}

public extension NSSplitView {
    /// NSSplitView 类型安全链式容器
    var splitViewChain: TFYChain<NSSplitView> { TFYChain(self) }
}

public extension NSVisualEffectView {
    /// NSVisualEffectView 类型安全链式容器
    var nsVisualEffectViewChain: TFYChain<NSVisualEffectView> { TFYChain(self) }
}

public extension NSWindowController {
    /// NSWindowController 类型安全链式容器
    var windowControllerChain: TFYChain<NSWindowController> { TFYChain(self) }
}

// macOS 手势识别器
public extension NSClickGestureRecognizer {
    /// NSClickGestureRecognizer 类型安全链式容器
    var clickGestureChain: TFYChain<NSClickGestureRecognizer> { TFYChain(self) }
}

public extension NSPanGestureRecognizer {
    /// NSPanGestureRecognizer 类型安全链式容器
    var nsPanGestureChain: TFYChain<NSPanGestureRecognizer> { TFYChain(self) }
}

public extension NSMagnificationGestureRecognizer {
    /// NSMagnificationGestureRecognizer 类型安全链式容器
    var magnificationGestureChain: TFYChain<NSMagnificationGestureRecognizer> { TFYChain(self) }
}

public extension NSRotationGestureRecognizer {
    /// NSRotationGestureRecognizer 类型安全链式容器
    var nsRotationGestureChain: TFYChain<NSRotationGestureRecognizer> { TFYChain(self) }
}

public extension NSPressGestureRecognizer {
    /// NSPressGestureRecognizer 类型安全链式容器
    var pressGestureChain: TFYChain<NSPressGestureRecognizer> { TFYChain(self) }
}

#endif
