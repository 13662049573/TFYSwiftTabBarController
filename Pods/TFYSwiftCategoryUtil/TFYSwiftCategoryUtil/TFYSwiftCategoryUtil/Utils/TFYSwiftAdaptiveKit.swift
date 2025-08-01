//
//  TFYSwiftAdaptiveKit.swift
//  TFYSwiftAdaptiveKit
//
//  Created by TFYSwift on 2024/12/12.
//  Perfect Screen Adaptive Kit for iOS 15+，支持 iPhone/iPad 适配，自动适配分屏、刘海屏等多场景，建议全局调用 setupAuto()。
//
//  用途：全局屏幕适配工具，支持链式调用和多端适配。
//

import UIKit
import Foundation

/// 适配配置验证结果
public struct TFYAdaptiveConfigValidation {
    public let isValid: Bool
    public let errors: [String]
    public let warnings: [String]
    
    public init(isValid: Bool, errors: [String] = [], warnings: [String] = []) {
        self.isValid = isValid
        self.errors = errors
        self.warnings = warnings
    }
}

// MARK: - TFYSwift Adaptive Kit
@objc public final class TFYSwiftAdaptiveKit: NSObject {
    
    // MARK: - Singleton
    public static let shared = TFYSwiftAdaptiveKit()
    private override init() {
        super.init()
        setupDefaultConfig()
    }
    
    // MARK: - Configuration
    public struct Config {
        /// 默认参照宽度 (iPhone 设计稿宽度)
        public static var referenceWidth: CGFloat = 375.0
        /// 默认参照高度 (iPhone 设计稿高度)
        public static var referenceHeight: CGFloat = 812.0
        /// 是否为iPhoneX系列的参照高度
        public static var isIPhoneXSeriesHeight: Bool = true
        /// iPad 适配放大倍数 (>=1.0，推荐1.2)
        public static var iPadFitMultiple: CGFloat = 1.2
        /// 计算结果类型
        public static var calcResultType: TFYCalcResultType = .round
        /// 是否启用缓存
        public static var enableCache: Bool = true
        /// 是否启用性能监控
        public static var enablePerformanceMonitor: Bool = false
        /// 是否已初始化
        public static var isInitialized: Bool = false
        /// 默认适配类型
        public static var defaultAdaptiveType: TFYAdaptiveType = .width
        /// 是否启用配置验证
        public static var enableConfigValidation: Bool = true
        
        /// 验证配置的有效性
        public static func validate() -> TFYAdaptiveConfigValidation {
            var errors: [String] = []
            var warnings: [String] = []
            
            if referenceWidth <= 0 {
                errors.append("参照宽度必须大于0")
            }
            
            if referenceHeight <= 0 {
                errors.append("参照高度必须大于0")
            }
            
            if iPadFitMultiple < 1.0 {
                errors.append("iPad适配倍数不能小于1.0")
            }
            
            if iPadFitMultiple > 3.0 {
                warnings.append("iPad适配倍数过大，可能影响显示效果")
            }
            
            if referenceWidth > 2000 {
                warnings.append("参照宽度过大，请确认是否正确")
            }
            
            if referenceHeight > 2000 {
                warnings.append("参照高度过大，请确认是否正确")
            }
            
            let isValid = errors.isEmpty
            return TFYAdaptiveConfigValidation(isValid: isValid, errors: errors, warnings: warnings)
        }
        
        /// 获取当前配置信息
        public static func getCurrentConfig() -> [String: Any] {
            return [
                "referenceWidth": referenceWidth,
                "referenceHeight": referenceHeight,
                "isIPhoneXSeriesHeight": isIPhoneXSeriesHeight,
                "iPadFitMultiple": iPadFitMultiple,
                "calcResultType": calcResultType.rawValue,
                "enableCache": enableCache,
                "enablePerformanceMonitor": enablePerformanceMonitor,
                "isInitialized": isInitialized,
                "defaultAdaptiveType": defaultAdaptiveType.rawValue,
                "enableConfigValidation": enableConfigValidation
            ]
        }
    }
    
    // MARK: - Device Info
    public struct Device {
        /// 当前设备是否为iPad
        public static var isIPad: Bool {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
        
        /// 当前设备是否为iPhone
        public static var isIPhone: Bool {
            return UIDevice.current.userInterfaceIdiom == .phone
        }
        
        /// 是否为刘海屏设备
        public static var isIPhoneXSeries: Bool {
            return getSafeAreaInsets().bottom > 0
        }
        
        /// 当前屏幕方向
        public static var orientation: UIInterfaceOrientation {
            if #available(iOS 13.0, *) {
                guard let windowScene = getCurrentWindow()?.windowScene else {
                    return .portrait
                }
                return windowScene.interfaceOrientation
            } else {
                return UIApplication.shared.statusBarOrientation
            }
        }
        
        /// 是否为竖屏
        public static var isPortrait: Bool {
            return orientation.isPortrait
        }
        
        /// 是否为横屏
        public static var isLandscape: Bool {
            return orientation.isLandscape
        }
        
        /// 获取当前窗口
        public static func getCurrentWindow() -> UIWindow? {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap(\.windows)
                    .first { $0.isKeyWindow }
            } else {
                return UIApplication.shared.keyWindow
            }
        }
        
        /// 获取安全区域
        public static func getSafeAreaInsets() -> UIEdgeInsets {
            guard let window = getCurrentWindow() else { return .zero }
            if #available(iOS 11.0, *) {
                return window.safeAreaInsets
            }
            return .zero
        }
        
        /// 获取顶部安全区域高度
        public static func getSafeAreaTopMargin() -> CGFloat {
            let insets = getSafeAreaInsets()
            switch orientation {
            case .portrait, .portraitUpsideDown:
                return insets.top
            case .landscapeLeft:
                return insets.right
            case .landscapeRight:
                return insets.left
            default:
                return 0
            }
        }
        
        /// 获取底部安全区域高度
        public static func getSafeAreaBottomMargin() -> CGFloat {
            let insets = getSafeAreaInsets()
            switch orientation {
            case .portrait, .portraitUpsideDown:
                return insets.bottom
            case .landscapeLeft:
                return insets.left
            case .landscapeRight:
                return insets.right
            default:
                return 0
            }
        }
        
        /// 当前设备是否处于分屏（iPad 多任务）模式
        public static var isSplitScreen: Bool {
            guard isIPad else { return false }
            
            // 检查是否支持分屏
            if #available(iOS 9.0, *) {
                let screen = UIScreen.main
                let bounds = screen.bounds
                let nativeBounds = screen.nativeBounds
                
                // 分屏时，bounds.width/height 会小于物理分辨率
                let widthRatio = bounds.size.width / (nativeBounds.size.width / screen.nativeScale)
                let heightRatio = bounds.size.height / (nativeBounds.size.height / screen.nativeScale)
                
                // 如果任一方向的比率小于0.9，认为是分屏模式
                return widthRatio < 0.9 || heightRatio < 0.9
            }
            
            return false
        }
        
        /// 获取分屏比例（1.0表示全屏，小于1.0表示分屏）
        public static var splitScreenRatio: CGFloat {
            guard isIPad else { return 1.0 }
            
            if #available(iOS 9.0, *) {
                let screen = UIScreen.main
                let bounds = screen.bounds
                let nativeBounds = screen.nativeBounds
                
                let widthRatio = bounds.size.width / (nativeBounds.size.width / screen.nativeScale)
                let heightRatio = bounds.size.height / (nativeBounds.size.height / screen.nativeScale)
                
                return min(widthRatio, heightRatio)
            }
            
            return 1.0
        }
    }
    
    // MARK: - Screen Info
    public struct Screen {
        /// 屏幕宽度
        public static var width: CGFloat {
            let bounds = UIScreen.main.bounds
            return bounds.width < bounds.height ? bounds.width : bounds.height
        }
        
        /// 屏幕高度
        public static var height: CGFloat {
            let bounds = UIScreen.main.bounds
            return bounds.width < bounds.height ? bounds.height : bounds.width
        }
        
        /// 安全区域中心高度
        public static var safeAreaCenterHeight: CGFloat {
            return height - Device.getSafeAreaTopMargin() - Device.getSafeAreaBottomMargin()
        }
        
        /// 安全区域除去顶部的高度
        public static var safeAreaWithoutTopHeight: CGFloat {
            return height - Device.getSafeAreaTopMargin()
        }
        
        /// 状态栏高度
        public static var statusBarHeight: CGFloat {
            if #available(iOS 13.0, *) {
                guard let windowScene = Device.getCurrentWindow()?.windowScene,
                      let statusBarManager = windowScene.statusBarManager else {
                    return 44
                }
                return statusBarManager.statusBarFrame.height
            } else {
                return UIApplication.shared.statusBarFrame.height
            }
        }
        
        /// 导航栏高度
        public static var navigationBarHeight: CGFloat {
            return statusBarHeight + 44
        }
        
        /// TabBar高度
        public static var tabBarHeight: CGFloat {
            return Device.isIPhoneXSeries ? 83 : 49
        }
    }
    
    // MARK: - Private Properties
    private var cache = NSCache<NSString, NSNumber>()
    private var performanceData: [String: TimeInterval] = [:]
    
    /// 缓存队列（确保线程安全）
    private let cacheQueue = DispatchQueue(label: "com.tfy.adaptive.cache", qos: .userInitiated)
    
    /// 配置队列（确保线程安全）
    private let configQueue = DispatchQueue(label: "com.tfy.adaptive.config", qos: .userInitiated)
    
    /// 性能数据队列（确保线程安全）
    private let performanceQueue = DispatchQueue(label: "com.tfy.adaptive.performance", qos: .utility)
    
    // MARK: - Setup
    private func setupDefaultConfig() {
        if !Config.isInitialized {
            if Device.isIPad {
                Config.referenceWidth = 768.0
                Config.referenceHeight = 1024.0
                Config.isIPhoneXSeriesHeight = false
                Config.iPadFitMultiple = 1.2 // iPad默认放大
            } else {
                Config.referenceWidth = 375.0
                Config.referenceHeight = 812.0
                Config.isIPhoneXSeriesHeight = true
                Config.iPadFitMultiple = 1.0
            }
            Config.calcResultType = .ceil
            Config.enableCache = true
            Config.enablePerformanceMonitor = false
            Config.defaultAdaptiveType = .width
            Config.isInitialized = true
            
            // 设置缓存
            setupCache()
            
            print("TFYSwiftAdaptiveKit: 自动初始化完成 - \(Device.isIPad ? "iPad" : "iPhone") 模式")
        }
    }
    
    private func setupCache() {
        cache.delegate = self
        cache.totalCostLimit = 1024 * 1024 // 1MB
        cache.countLimit = 1000
    }
    
    // MARK: - Public Methods
    
    /// 设置参照参数
    @objc public static func setup(
        width: CGFloat = 375.0,
        height: CGFloat = 812.0,
        isIPhoneXSeriesHeight: Bool = true,
        iPadFitMultiple: CGFloat = 1.2, // iPad默认放大
        calcResultType: TFYCalcResultType = .ceil
    ) -> Bool {
        // 临时设置配置进行验证
        let originalWidth = Config.referenceWidth
        let originalHeight = Config.referenceHeight
        let originalIPadFitMultiple = Config.iPadFitMultiple
        
        Config.referenceWidth = width
        Config.referenceHeight = height
        Config.isIPhoneXSeriesHeight = isIPhoneXSeriesHeight
        Config.iPadFitMultiple = max(1.0, iPadFitMultiple)
        Config.calcResultType = calcResultType
        
        // 验证配置
        let validation = Config.validate()
        if !validation.isValid {
            // 恢复原始配置
            Config.referenceWidth = originalWidth
            Config.referenceHeight = originalHeight
            Config.iPadFitMultiple = originalIPadFitMultiple
            
            print("TFYSwiftAdaptiveKit: 配置验证失败")
            for error in validation.errors {
                print("TFYSwiftAdaptiveKit: 错误 - \(error)")
            }
            return false
        }
        
        // 显示警告
        if !validation.warnings.isEmpty {
            print("TFYSwiftAdaptiveKit: 配置警告")
            for warning in validation.warnings {
                print("TFYSwiftAdaptiveKit: 警告 - \(warning)")
            }
        }
        
        Config.isInitialized = true
        if Config.enableCache {
            shared.cacheQueue.async {
                shared.cache.removeAllObjects()
            }
        }
        print("TFYSwiftAdaptiveKit: 手动配置完成 - 宽度:\(width), 高度:\(height), iPad倍数:\(Config.iPadFitMultiple)")
        return true
    }
    
    /// 自动设置最佳配置（推荐使用）
    @objc public static func setupAuto() {
        shared.setupDefaultConfig()
    }
    
    /// 适配数值
    @objc public static func adapt(
        _ value: CGFloat,
        type: TFYAdaptiveType = .width,
        reduceValue: CGFloat = 0
    ) -> CGFloat {
        // 确保已初始化
        if !Config.isInitialized {
            setupAuto()
        }
        
        // 如果使用默认类型，则使用配置中的默认类型
        let adaptiveType = type == .width && Config.defaultAdaptiveType != .width ? Config.defaultAdaptiveType : type
        
        let result = shared.adaptiveValue(value, type: adaptiveType, reduceValue: reduceValue)
        
        // 验证适配结果
        if Config.enableConfigValidation {
            validateAdaptationResult(originalValue: value, result: result, type: adaptiveType)
        }
        
        return result
    }
    
    /// 验证适配结果
    private static func validateAdaptationResult(originalValue: CGFloat, result: CGFloat, type: TFYAdaptiveType) {
        // 检查结果是否合理
        let scale = getCurrentScale(type: type)
        let expectedResult = originalValue * scale
        
        let difference = abs(result - expectedResult)
        let tolerance = originalValue * 0.01 // 1%的容差
        
        if difference > tolerance {
            print("TFYSwiftAdaptiveKit: 警告 - 适配结果可能异常")
            print("TFYSwiftAdaptiveKit: 原始值: \(originalValue), 结果: \(result), 期望: \(expectedResult)")
            print("TFYSwiftAdaptiveKit: 差异: \(difference), 容差: \(tolerance)")
        }
    }
    
    /// 使用默认适配类型进行适配
    @objc public static func adaptDefault(_ value: CGFloat, reduceValue: CGFloat = 0) -> CGFloat {
        return adapt(value, type: Config.defaultAdaptiveType, reduceValue: reduceValue)
    }
    
    /// 清除缓存
    @objc public static func clearCache() {
        shared.cacheQueue.async {
            shared.cache.removeAllObjects()
        }
    }
    
    /// 获取性能数据
    @objc public static func getPerformanceData() -> [String: TimeInterval] {
        var data: [String: TimeInterval] = [:]
        data = shared.performanceQueue.sync { shared.performanceData }
        return data
    }
    
    /// 保存配置到UserDefaults
    @objc public static func saveConfigToUserDefaults() -> Bool {
        let config = Config.getCurrentConfig()
        UserDefaults.standard.set(config, forKey: "TFYSwiftAdaptiveKit_Config")
        return UserDefaults.standard.synchronize()
    }
    
    /// 从UserDefaults加载配置
    @objc public static func loadConfigFromUserDefaults() -> Bool {
        guard let config = UserDefaults.standard.dictionary(forKey: "TFYSwiftAdaptiveKit_Config") else {
            return false
        }
        
        if let width = config["referenceWidth"] as? CGFloat {
            Config.referenceWidth = width
        }
        if let height = config["referenceHeight"] as? CGFloat {
            Config.referenceHeight = height
        }
        if let isIPhoneXSeriesHeight = config["isIPhoneXSeriesHeight"] as? Bool {
            Config.isIPhoneXSeriesHeight = isIPhoneXSeriesHeight
        }
        if let iPadFitMultiple = config["iPadFitMultiple"] as? CGFloat {
            Config.iPadFitMultiple = iPadFitMultiple
        }
        if let calcResultTypeRaw = config["calcResultType"] as? Int,
           let calcResultType = TFYCalcResultType(rawValue: calcResultTypeRaw) {
            Config.calcResultType = calcResultType
        }
        if let enableCache = config["enableCache"] as? Bool {
            Config.enableCache = enableCache
        }
        if let enablePerformanceMonitor = config["enablePerformanceMonitor"] as? Bool {
            Config.enablePerformanceMonitor = enablePerformanceMonitor
        }
        if let defaultAdaptiveTypeRaw = config["defaultAdaptiveType"] as? Int,
           let defaultAdaptiveType = TFYAdaptiveType(rawValue: defaultAdaptiveTypeRaw) {
            Config.defaultAdaptiveType = defaultAdaptiveType
        }
        
        Config.isInitialized = true
        return true
    }
    
    // MARK: - Private Methods
    private func adaptiveValue(
        _ value: CGFloat,
        type: TFYAdaptiveType,
        reduceValue: CGFloat = 0
    ) -> CGFloat {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // 输入验证
        guard value.isFinite && value >= 0 else {
            print("TFYSwiftAdaptiveKit: 警告 - 输入值无效: \(value)")
            return value
        }
        
        // 检查缓存
        let cacheKey = "\(value)_\(type.rawValue)_\(reduceValue)" as NSString
        // 直接返回缓存值（不再设置isCacheHit）
        if Config.enableCache {
            if let cachedValue = self.cacheQueue.sync(execute: { self.cache.object(forKey: cacheKey) }) {
                return cachedValue.doubleValue
            }
        }
        
        var result: CGFloat = 0
        
        switch type {
        case .none:
            result = value
            
        case .width:
            let currentWidth = Screen.width - reduceValue
            let referenceWidth = Config.referenceWidth - reduceValue
            guard referenceWidth > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 参照宽度减去reduceValue后小于等于0")
                return value
            }
            result = (currentWidth / referenceWidth) * value * getFitMultiple()
            
        case .forceWidth:
            let currentWidth = Screen.width - reduceValue
            let referenceWidth = Config.referenceWidth - reduceValue
            guard referenceWidth > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 参照宽度减去reduceValue后小于等于0")
                return value
            }
            result = (currentWidth / referenceWidth) * value
            
        case .height:
            let currentHeight = Screen.height - reduceValue
            let referenceHeight = Config.referenceHeight - reduceValue
            guard referenceHeight > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 参照高度减去reduceValue后小于等于0")
                return value
            }
            result = (currentHeight / referenceHeight) * value * getFitMultiple()
            
        case .forceHeight:
            let currentHeight = Screen.height - reduceValue
            let referenceHeight = Config.referenceHeight - reduceValue
            guard referenceHeight > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 参照高度减去reduceValue后小于等于0")
                return value
            }
            result = (currentHeight / referenceHeight) * value
            
        case .safeAreaCenterHeight:
            let referenceHeight = getReferenceSafeAreaCenterHeight()
            let currentHeight = Screen.safeAreaCenterHeight - reduceValue
            let finalReferenceHeight = referenceHeight - reduceValue
            guard finalReferenceHeight > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 安全区域中心高度减去reduceValue后小于等于0")
                return value
            }
            result = (currentHeight / finalReferenceHeight) * value * getFitMultiple()
            
        case .forceSafeAreaCenterHeight:
            let referenceHeight = getReferenceSafeAreaCenterHeight()
            let currentHeight = Screen.safeAreaCenterHeight - reduceValue
            let finalReferenceHeight = referenceHeight - reduceValue
            guard finalReferenceHeight > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 安全区域中心高度减去reduceValue后小于等于0")
                return value
            }
            result = (currentHeight / finalReferenceHeight) * value
            
        case .safeAreaWithoutTopHeight:
            let referenceHeight = getReferenceSafeAreaWithoutTopHeight()
            let currentHeight = Screen.safeAreaWithoutTopHeight - reduceValue
            let finalReferenceHeight = referenceHeight - reduceValue
            guard finalReferenceHeight > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 安全区域除去顶部高度减去reduceValue后小于等于0")
                return value
            }
            result = (currentHeight / finalReferenceHeight) * value * getFitMultiple()
            
        case .forceSafeAreaWithoutTopHeight:
            let referenceHeight = getReferenceSafeAreaWithoutTopHeight()
            let currentHeight = Screen.safeAreaWithoutTopHeight - reduceValue
            let finalReferenceHeight = referenceHeight - reduceValue
            guard finalReferenceHeight > 0 else {
                print("TFYSwiftAdaptiveKit: 错误 - 安全区域除去顶部高度减去reduceValue后小于等于0")
                return value
            }
            result = (currentHeight / finalReferenceHeight) * value
        }
        
        // 应用计算结果类型
        result = applyCalcResultType(result)
        
        // 健壮性保护：防止出现负数、NaN、无穷大
        if !result.isFinite || result < 0 {
            print("TFYSwiftAdaptiveKit: 警告 - 计算结果无效，使用原始值: \(result)")
            result = value
        }
        
        // 缓存结果
        if Config.enableCache {
            cacheQueue.async {
                self.cache.setObject(NSNumber(value: result), forKey: cacheKey)
            }
        }
        
        // 性能监控
        if Config.enablePerformanceMonitor {
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = (endTime - startTime) * 1000 // 转换为毫秒
            performanceQueue.async {
                self.performanceData[String(type.rawValue)] = duration
            }
        }
        
        return result
    }
    
    private func getFitMultiple() -> CGFloat {
        return Device.isIPad ? max(1.0, Config.iPadFitMultiple) : 1.0
    }
    
    private func getReferenceSafeAreaCenterHeight() -> CGFloat {
        if !Config.isIPhoneXSeriesHeight {
            return Config.referenceHeight
        }
        return Config.referenceHeight - Device.getSafeAreaTopMargin() - Device.getSafeAreaBottomMargin()
    }
    
    private func getReferenceSafeAreaWithoutTopHeight() -> CGFloat {
        if !Config.isIPhoneXSeriesHeight {
            return Config.referenceHeight
        }
        return Config.referenceHeight - Device.getSafeAreaTopMargin()
    }
    
    private func applyCalcResultType(_ value: CGFloat) -> CGFloat {
        switch Config.calcResultType {
        case .raw:
            return value
        case .round:
            return round(value)
        case .ceil:
            return ceil(value)
        case .floor:
            return floor(value)
        case .oneDecimalPlace:
            return round(value * 10) / 10
        case .twoDecimalPlaces:
            return round(value * 100) / 100
        }
    }
}

// MARK: - NSCacheDelegate
extension TFYSwiftAdaptiveKit: NSCacheDelegate {
    public func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        print("TFYSwiftAdaptiveKit: 缓存项被清理")
    }
}

// MARK: - Enums
@objc public enum TFYAdaptiveType: Int, CaseIterable {
    case none = 0
    case width = 1
    case forceWidth = 2
    case height = 3
    case forceHeight = 4
    case safeAreaCenterHeight = 5
    case forceSafeAreaCenterHeight = 6
    case safeAreaWithoutTopHeight = 7
    case forceSafeAreaWithoutTopHeight = 8
    
    public var description: String {
        switch self {
        case .none: return "原始值"
        case .width: return "宽度适配(含iPad倍数)"
        case .forceWidth: return "宽度适配(强制)"
        case .height: return "高度适配(含iPad倍数)"
        case .forceHeight: return "高度适配(强制)"
        case .safeAreaCenterHeight: return "安全区域中心高度适配(含iPad倍数)"
        case .forceSafeAreaCenterHeight: return "安全区域中心高度适配(强制)"
        case .safeAreaWithoutTopHeight: return "安全区域除去顶部高度适配(含iPad倍数)"
        case .forceSafeAreaWithoutTopHeight: return "安全区域除去顶部高度适配(强制)"
        }
    }
}

@objc public enum TFYCalcResultType: Int, CaseIterable {
    case raw = 0
    case round = 1
    case ceil = 2
    case floor = 3
    case oneDecimalPlace = 4
    case twoDecimalPlaces = 5
    
    public var description: String {
        switch self {
        case .raw: return "原始值"
        case .round: return "四舍五入"
        case .ceil: return "向上取整"
        case .floor: return "向下取整"
        case .oneDecimalPlace: return "保留一位小数"
        case .twoDecimalPlaces: return "保留两位小数"
        }
    }
}

// MARK: - Property Wrappers
@propertyWrapper
public struct TFYAdaptive {
    private var value: CGFloat = 0
    private let adaptiveType: TFYAdaptiveType
    private let reduceValue: CGFloat
    
    public var wrappedValue: CGFloat {
        get { return value }
        set { value = TFYSwiftAdaptiveKit.adapt(newValue, type: adaptiveType, reduceValue: reduceValue) }
    }
    
    public var projectedValue: TFYAdaptiveType {
        return adaptiveType
    }
    
    public init(
        wrappedValue: CGFloat = 0,
        type: TFYAdaptiveType = .width,
        reduceValue: CGFloat = 0
    ) {
        self.adaptiveType = type
        self.reduceValue = reduceValue
        self.value = TFYSwiftAdaptiveKit.adapt(wrappedValue, type: type, reduceValue: reduceValue)
    }
}

@propertyWrapper
public struct TFYAdaptiveInt {
    private var value: Int = 0
    private let adaptiveType: TFYAdaptiveType
    private let reduceValue: CGFloat
    
    public var wrappedValue: Int {
        get { return value }
        set { value = Int(TFYSwiftAdaptiveKit.adapt(CGFloat(newValue), type: adaptiveType, reduceValue: reduceValue)) }
    }
    
    public var projectedValue: TFYAdaptiveType {
        return adaptiveType
    }
    
    public init(
        wrappedValue: Int = 0,
        type: TFYAdaptiveType = .width,
        reduceValue: CGFloat = 0
    ) {
        self.adaptiveType = type
        self.reduceValue = reduceValue
        self.value = Int(TFYSwiftAdaptiveKit.adapt(CGFloat(wrappedValue), type: type, reduceValue: reduceValue))
    }
}

@propertyWrapper
public struct TFYAdaptiveFloat {
    private var value: Float = 0
    private let adaptiveType: TFYAdaptiveType
    private let reduceValue: CGFloat
    
    public var wrappedValue: Float {
        get { return value }
        set { value = Float(TFYSwiftAdaptiveKit.adapt(CGFloat(newValue), type: adaptiveType, reduceValue: reduceValue)) }
    }
    
    public var projectedValue: TFYAdaptiveType {
        return adaptiveType
    }
    
    public init(
        wrappedValue: Float = 0,
        type: TFYAdaptiveType = .width,
        reduceValue: CGFloat = 0
    ) {
        self.adaptiveType = type
        self.reduceValue = reduceValue
        self.value = Float(TFYSwiftAdaptiveKit.adapt(CGFloat(wrappedValue), type: type, reduceValue: reduceValue))
    }
}

@propertyWrapper
public struct TFYAdaptiveDouble {
    private var value: Double = 0
    private let adaptiveType: TFYAdaptiveType
    private let reduceValue: CGFloat
    
    public var wrappedValue: Double {
        get { return value }
        set { value = Double(TFYSwiftAdaptiveKit.adapt(CGFloat(newValue), type: adaptiveType, reduceValue: reduceValue)) }
    }
    
    public var projectedValue: TFYAdaptiveType {
        return adaptiveType
    }
    
    public init(
        wrappedValue: Double = 0,
        type: TFYAdaptiveType = .width,
        reduceValue: CGFloat = 0
    ) {
        self.adaptiveType = type
        self.reduceValue = reduceValue
        self.value = Double(TFYSwiftAdaptiveKit.adapt(CGFloat(wrappedValue), type: type, reduceValue: reduceValue))
    }
}

// MARK: - Extensions for Basic Types
public extension CGFloat {
    /// 默认适配（使用配置中的默认类型）
    var adap: CGFloat {
        return TFYSwiftAdaptiveKit.adaptDefault(self)
    }
    
    /// 宽度适配(含iPad倍数)
    var adap_width: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .width)
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .forceWidth)
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .height)
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .forceHeight)
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .safeAreaCenterHeight)
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .forceSafeAreaCenterHeight)
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .safeAreaWithoutTopHeight)
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(self, type: .forceSafeAreaWithoutTopHeight)
    }
}

public extension Int {
    /// 默认适配（使用配置中的默认类型）
    var adap: CGFloat {
        return TFYSwiftAdaptiveKit.adaptDefault(CGFloat(self))
    }
    
    /// 宽度适配(含iPad倍数)
    var adap_width: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .width)
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceWidth)
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .height)
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceHeight)
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .safeAreaCenterHeight)
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceSafeAreaCenterHeight)
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .safeAreaWithoutTopHeight)
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceSafeAreaWithoutTopHeight)
    }
}

public extension Float {
    /// 默认适配（使用配置中的默认类型）
    var adap: CGFloat {
        return TFYSwiftAdaptiveKit.adaptDefault(CGFloat(self))
    }
    
    /// 宽度适配(含iPad倍数)
    var adap_width: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .width)
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceWidth)
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .height)
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceHeight)
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .safeAreaCenterHeight)
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceSafeAreaCenterHeight)
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .safeAreaWithoutTopHeight)
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceSafeAreaWithoutTopHeight)
    }
}

public extension Double {
    /// 默认适配（使用配置中的默认类型）
    var adap: CGFloat {
        return TFYSwiftAdaptiveKit.adaptDefault(CGFloat(self))
    }
    
    /// 宽度适配(含iPad倍数)
    var adap_width: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .width)
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceWidth)
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .height)
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceHeight)
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .safeAreaCenterHeight)
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceSafeAreaCenterHeight)
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .safeAreaWithoutTopHeight)
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(self), type: .forceSafeAreaWithoutTopHeight)
    }
}

// MARK: - UIKit Extensions
public extension CGPoint {
    /// 宽度适配(含iPad倍数)
    var adap_width: CGPoint {
        return CGPoint(x: x.adap_width, y: y.adap_width)
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: CGPoint {
        return CGPoint(x: x.adap_forceWidth, y: y.adap_forceWidth)
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: CGPoint {
        return CGPoint(x: x.adap_height, y: y.adap_height)
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: CGPoint {
        return CGPoint(x: x.adap_forceHeight, y: y.adap_forceHeight)
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: CGPoint {
        return CGPoint(x: x.adap_safeAreaCenter, y: y.adap_safeAreaCenter)
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: CGPoint {
        return CGPoint(x: x.adap_forceSafeAreaCenter, y: y.adap_forceSafeAreaCenter)
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: CGPoint {
        return CGPoint(x: x.adap_safeAreaWithoutTop, y: y.adap_safeAreaWithoutTop)
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: CGPoint {
        return CGPoint(x: x.adap_forceSafeAreaWithoutTop, y: y.adap_forceSafeAreaWithoutTop)
    }
}

public extension CGSize {
    /// 宽度适配(含iPad倍数)
    var adap_width: CGSize {
        return CGSize(width: width.adap_width, height: height.adap_width)
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: CGSize {
        return CGSize(width: width.adap_forceWidth, height: height.adap_forceWidth)
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: CGSize {
        return CGSize(width: width.adap_height, height: height.adap_height)
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: CGSize {
        return CGSize(width: width.adap_forceHeight, height: height.adap_forceHeight)
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: CGSize {
        return CGSize(width: width.adap_safeAreaCenter, height: height.adap_safeAreaCenter)
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: CGSize {
        return CGSize(width: width.adap_forceSafeAreaCenter, height: height.adap_forceSafeAreaCenter)
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: CGSize {
        return CGSize(width: width.adap_safeAreaWithoutTop, height: height.adap_safeAreaWithoutTop)
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: CGSize {
        return CGSize(width: width.adap_forceSafeAreaWithoutTop, height: height.adap_forceSafeAreaWithoutTop)
    }
}

public extension CGRect {
    /// 宽度适配(含iPad倍数)
    var adap_width: CGRect {
        return CGRect(
            x: origin.x.adap_width,
            y: origin.y.adap_width,
            width: size.width.adap_width,
            height: size.height.adap_width
        )
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: CGRect {
        return CGRect(
            x: origin.x.adap_forceWidth,
            y: origin.y.adap_forceWidth,
            width: size.width.adap_forceWidth,
            height: size.height.adap_forceWidth
        )
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: CGRect {
        return CGRect(
            x: origin.x.adap_height,
            y: origin.y.adap_height,
            width: size.width.adap_height,
            height: size.height.adap_height
        )
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: CGRect {
        return CGRect(
            x: origin.x.adap_forceHeight,
            y: origin.y.adap_forceHeight,
            width: size.width.adap_forceHeight,
            height: size.height.adap_forceHeight
        )
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: CGRect {
        return CGRect(
            x: origin.x.adap_safeAreaCenter,
            y: origin.y.adap_safeAreaCenter,
            width: size.width.adap_safeAreaCenter,
            height: size.height.adap_safeAreaCenter
        )
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: CGRect {
        return CGRect(
            x: origin.x.adap_forceSafeAreaCenter,
            y: origin.y.adap_forceSafeAreaCenter,
            width: size.width.adap_forceSafeAreaCenter,
            height: size.height.adap_forceSafeAreaCenter
        )
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: CGRect {
        return CGRect(
            x: origin.x.adap_safeAreaWithoutTop,
            y: origin.y.adap_safeAreaWithoutTop,
            width: size.width.adap_safeAreaWithoutTop,
            height: size.height.adap_safeAreaWithoutTop
        )
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: CGRect {
        return CGRect(
            x: origin.x.adap_forceSafeAreaWithoutTop,
            y: origin.y.adap_forceSafeAreaWithoutTop,
            width: size.width.adap_forceSafeAreaWithoutTop,
            height: size.height.adap_forceSafeAreaWithoutTop
        )
    }
}

public extension UIEdgeInsets {
    /// 宽度适配(含iPad倍数)
    var adap_width: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_width,
            left: left.adap_width,
            bottom: bottom.adap_width,
            right: right.adap_width
        )
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_forceWidth,
            left: left.adap_forceWidth,
            bottom: bottom.adap_forceWidth,
            right: right.adap_forceWidth
        )
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_height,
            left: left.adap_height,
            bottom: bottom.adap_height,
            right: right.adap_height
        )
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_forceHeight,
            left: left.adap_forceHeight,
            bottom: bottom.adap_forceHeight,
            right: right.adap_forceHeight
        )
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_safeAreaCenter,
            left: left.adap_safeAreaCenter,
            bottom: bottom.adap_safeAreaCenter,
            right: right.adap_safeAreaCenter
        )
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_forceSafeAreaCenter,
            left: left.adap_forceSafeAreaCenter,
            bottom: bottom.adap_forceSafeAreaCenter,
            right: right.adap_forceSafeAreaCenter
        )
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_safeAreaWithoutTop,
            left: left.adap_safeAreaWithoutTop,
            bottom: bottom.adap_safeAreaWithoutTop,
            right: right.adap_safeAreaWithoutTop
        )
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adap_forceSafeAreaWithoutTop,
            left: left.adap_forceSafeAreaWithoutTop,
            bottom: bottom.adap_forceSafeAreaWithoutTop,
            right: right.adap_forceSafeAreaWithoutTop
        )
    }
}

public extension UIFont {
    /// 宽度适配(含iPad倍数)
    var adap_width: UIFont {
        return withSize(pointSize.adap_width)
    }
    
    /// 宽度适配(强制)
    var adap_forceWidth: UIFont {
        return withSize(pointSize.adap_forceWidth)
    }
    
    /// 高度适配(含iPad倍数)
    var adap_height: UIFont {
        return withSize(pointSize.adap_height)
    }
    
    /// 高度适配(强制)
    var adap_forceHeight: UIFont {
        return withSize(pointSize.adap_forceHeight)
    }
    
    /// 安全区域中心高度适配(含iPad倍数)
    var adap_safeAreaCenter: UIFont {
        return withSize(pointSize.adap_safeAreaCenter)
    }
    
    /// 安全区域中心高度适配(强制)
    var adap_forceSafeAreaCenter: UIFont {
        return withSize(pointSize.adap_forceSafeAreaCenter)
    }
    
    /// 安全区域除去顶部高度适配(含iPad倍数)
    var adap_safeAreaWithoutTop: UIFont {
        return withSize(pointSize.adap_safeAreaWithoutTop)
    }
    
    /// 安全区域除去顶部高度适配(强制)
    var adap_forceSafeAreaWithoutTop: UIFont {
        return withSize(pointSize.adap_forceSafeAreaWithoutTop)
    }
}

// MARK: - Interface Builder Support
public extension NSLayoutConstraint {
    @IBInspectable var adapAdaptiveType: Int {
        get { return TFYAdaptiveType.none.rawValue }
        set {
            guard let type = TFYAdaptiveType(rawValue: newValue) else { return }
            constant = TFYSwiftAdaptiveKit.adapt(constant, type: type)
        }
    }
}

public extension UILabel {
    @IBInspectable var adapFontAdaptiveType: Int {
        get { return TFYAdaptiveType.none.rawValue }
        set {
            guard let type = TFYAdaptiveType(rawValue: newValue),
                  let font = font else { return }
            self.font = font.withSize(TFYSwiftAdaptiveKit.adapt(font.pointSize, type: type))
        }
    }
}

public extension UITextView {
    @IBInspectable var adapFontAdaptiveType: Int {
        get { return TFYAdaptiveType.none.rawValue }
        set {
            guard let type = TFYAdaptiveType(rawValue: newValue),
                  let font = font else { return }
            self.font = font.withSize(TFYSwiftAdaptiveKit.adapt(font.pointSize, type: type))
        }
    }
}

public extension UITextField {
    @IBInspectable var adapFontAdaptiveType: Int {
        get { return TFYAdaptiveType.none.rawValue }
        set {
            guard let type = TFYAdaptiveType(rawValue: newValue),
                  let font = font else { return }
            self.font = font.withSize(TFYSwiftAdaptiveKit.adapt(font.pointSize, type: type))
        }
    }
}

public extension UIButton {
    @IBInspectable var adapFontAdaptiveType: Int {
        get { return TFYAdaptiveType.none.rawValue }
        set {
            guard let type = TFYAdaptiveType(rawValue: newValue),
                  let font = titleLabel?.font else { return }
            self.titleLabel?.font = font.withSize(TFYSwiftAdaptiveKit.adapt(font.pointSize, type: type))
        }
    }
}

// MARK: - Objective-C Support
@objc public extension TFYSwiftAdaptiveKit {
    @objc func adap_adaptInt(_ value: Int, type: TFYAdaptiveType) -> CGFloat {
        return TFYSwiftAdaptiveKit.adapt(CGFloat(value), type: type)
    }
    
    @objc func adap_adaptFloat(_ value: CGFloat, type: TFYAdaptiveType) -> CGFloat {
        return TFYSwiftAdaptiveKit.adapt(value, type: type)
    }
    
    @objc func adap_adaptPoint(_ point: CGPoint, type: TFYAdaptiveType) -> CGPoint {
        switch type {
        case .width: return point.adap_width
        case .forceWidth: return point.adap_forceWidth
        case .height: return point.adap_height
        case .forceHeight: return point.adap_forceHeight
        case .safeAreaCenterHeight: return point.adap_safeAreaCenter
        case .forceSafeAreaCenterHeight: return point.adap_forceSafeAreaCenter
        case .safeAreaWithoutTopHeight: return point.adap_safeAreaWithoutTop
        case .forceSafeAreaWithoutTopHeight: return point.adap_forceSafeAreaWithoutTop
        case .none: return point
        }
    }
    
    @objc func adap_adaptSize(_ size: CGSize, type: TFYAdaptiveType) -> CGSize {
        switch type {
        case .width: return size.adap_width
        case .forceWidth: return size.adap_forceWidth
        case .height: return size.adap_height
        case .forceHeight: return size.adap_forceHeight
        case .safeAreaCenterHeight: return size.adap_safeAreaCenter
        case .forceSafeAreaCenterHeight: return size.adap_forceSafeAreaCenter
        case .safeAreaWithoutTopHeight: return size.adap_safeAreaWithoutTop
        case .forceSafeAreaWithoutTopHeight: return size.adap_forceSafeAreaWithoutTop
        case .none: return size
        }
    }
    
    @objc func adap_adaptRect(_ rect: CGRect, type: TFYAdaptiveType) -> CGRect {
        switch type {
        case .width: return rect.adap_width
        case .forceWidth: return rect.adap_forceWidth
        case .height: return rect.adap_height
        case .forceHeight: return rect.adap_forceHeight
        case .safeAreaCenterHeight: return rect.adap_safeAreaCenter
        case .forceSafeAreaCenterHeight: return rect.adap_forceSafeAreaCenter
        case .safeAreaWithoutTopHeight: return rect.adap_safeAreaWithoutTop
        case .forceSafeAreaWithoutTopHeight: return rect.adap_forceSafeAreaWithoutTop
        case .none: return rect
        }
    }
    
    @objc func adap_adaptEdgeInsets(_ insets: UIEdgeInsets, type: TFYAdaptiveType) -> UIEdgeInsets {
        switch type {
        case .width: return insets.adap_width
        case .forceWidth: return insets.adap_forceWidth
        case .height: return insets.adap_height
        case .forceHeight: return insets.adap_forceHeight
        case .safeAreaCenterHeight: return insets.adap_safeAreaCenter
        case .forceSafeAreaCenterHeight: return insets.adap_forceSafeAreaCenter
        case .safeAreaWithoutTopHeight: return insets.adap_safeAreaWithoutTop
        case .forceSafeAreaWithoutTopHeight: return insets.adap_forceSafeAreaWithoutTop
        case .none: return insets
        }
    }
    
    @objc func adap_adaptFont(_ font: UIFont, type: TFYAdaptiveType) -> UIFont {
        switch type {
        case .width: return font.adap_width
        case .forceWidth: return font.adap_forceWidth
        case .height: return font.adap_height
        case .forceHeight: return font.adap_forceHeight
        case .safeAreaCenterHeight: return font.adap_safeAreaCenter
        case .forceSafeAreaCenterHeight: return font.adap_forceSafeAreaCenter
        case .safeAreaWithoutTopHeight: return font.adap_safeAreaWithoutTop
        case .forceSafeAreaWithoutTopHeight: return font.adap_forceSafeAreaWithoutTop
        case .none: return font
        }
    }
}

// MARK: - Convenience Methods
public extension TFYSwiftAdaptiveKit {
    /// 快速设置iPhone设计稿尺寸
    static func setupForIPhone() {
        _ = setup(width: 375, height: 812, isIPhoneXSeriesHeight: true, iPadFitMultiple: 1.2)
    }
    
    /// 快速设置iPad设计稿尺寸
    static func setupForIPad() {
        _ = setup(width: 768, height: 1024, isIPhoneXSeriesHeight: false, iPadFitMultiple: 1.2)
    }
    
    /// 快速设置通用设计稿尺寸
    static func setupForUniversal() {
        _ = setup(width: 375, height: 812, isIPhoneXSeriesHeight: true, iPadFitMultiple: 1.2)
    }
    
    /// 设置默认适配类型
    static func setDefaultAdaptiveType(_ type: TFYAdaptiveType) {
        Config.defaultAdaptiveType = type
        print("TFYSwiftAdaptiveKit: 默认适配类型设置为 \(type.description)")
    }
    
    /// 获取当前默认适配类型
    static func getDefaultAdaptiveType() -> TFYAdaptiveType {
        return Config.defaultAdaptiveType
    }
    
    /// 检查是否已初始化
    static func isInitialized() -> Bool {
        return Config.isInitialized
    }
    
    /// 重置为默认配置
    static func resetToDefault() {
        Config.isInitialized = false
        shared.setupDefaultConfig()
        print("TFYSwiftAdaptiveKit: 已重置为默认配置")
    }
    
    /// 获取当前适配比例
    static func getCurrentScale(type: TFYAdaptiveType = .width) -> CGFloat {
        switch type {
        case .width, .forceWidth:
            return Screen.width / Config.referenceWidth
        case .height, .forceHeight:
            return Screen.height / Config.referenceHeight
        case .safeAreaCenterHeight, .forceSafeAreaCenterHeight:
            return Screen.safeAreaCenterHeight / getReferenceSafeAreaCenterHeight()
        case .safeAreaWithoutTopHeight, .forceSafeAreaWithoutTopHeight:
            return Screen.safeAreaWithoutTopHeight / getReferenceSafeAreaWithoutTopHeight()
        case .none:
            return 1.0
        }
    }
    
    /// 获取当前设备信息
    static func getDeviceInfo() -> [String: Any] {
        return [
            "isIPad": Device.isIPad,
            "isIPhone": Device.isIPhone,
            "isIPhoneXSeries": Device.isIPhoneXSeries,
            "orientation": Device.orientation.rawValue,
            "isPortrait": Device.isPortrait,
            "isLandscape": Device.isLandscape,
            "screenWidth": Screen.width,
            "screenHeight": Screen.height,
            "safeAreaCenterHeight": Screen.safeAreaCenterHeight,
            "safeAreaWithoutTopHeight": Screen.safeAreaWithoutTopHeight,
            "statusBarHeight": Screen.statusBarHeight,
            "navigationBarHeight": Screen.navigationBarHeight,
            "tabBarHeight": Screen.tabBarHeight,
            "safeAreaInsets": Device.getSafeAreaInsets()
        ]
    }
    
    private static func getReferenceSafeAreaCenterHeight() -> CGFloat {
        if !Config.isIPhoneXSeriesHeight {
            return Config.referenceHeight
        }
        return Config.referenceHeight - Device.getSafeAreaTopMargin() - Device.getSafeAreaBottomMargin()
    }
    
    private static func getReferenceSafeAreaWithoutTopHeight() -> CGFloat {
        if !Config.isIPhoneXSeriesHeight {
            return Config.referenceHeight
        }
        return Config.referenceHeight - Device.getSafeAreaTopMargin()
    }
}

// MARK: - Performance Monitoring
public extension TFYSwiftAdaptiveKit {
    /// 启用性能监控
    static func enablePerformanceMonitoring() {
        Config.enablePerformanceMonitor = true
    }
    
    /// 禁用性能监控
    static func disablePerformanceMonitoring() {
        Config.enablePerformanceMonitor = false
    }
    
    /// 获取性能统计
    static func getPerformanceStatistics() -> [String: Any] {
        let data = shared.performanceData
        let totalCalls = data.values.count
        let averageTime = data.values.isEmpty ? 0 : data.values.reduce(0, +) / Double(totalCalls)
        let maxTime = data.values.max() ?? 0
        let minTime = data.values.min() ?? 0
        
        return [
            "totalCalls": totalCalls,
            "averageTime": averageTime,
            "maxTime": maxTime,
            "minTime": minTime,
            "detailedData": data
        ]
    }
    
    /// 清除性能数据
    static func clearPerformanceData() {
        shared.performanceData.removeAll()
    }
}

// MARK: - Cache Management
public extension TFYSwiftAdaptiveKit {
    /// 启用缓存
    static func enableCache() {
        Config.enableCache = true
    }
    
    /// 禁用缓存
    static func disableCache() {
        Config.enableCache = false
    }
    
    /// 获取缓存信息
    static func getCacheInfo() -> [String: Any] {
        let cache = shared.cache
        return [
            "totalCostLimit": cache.totalCostLimit,
            "countLimit": cache.countLimit,
            "name": cache.name
        ]
    }
    
    /// 设置缓存限制
    static func setCacheLimits(totalCostLimit: Int = 0, countLimit: Int = 0) {
        shared.cache.totalCostLimit = totalCostLimit
        shared.cache.countLimit = countLimit
    }
}

/**
 * 适配说明：
 * - iPhone 适配倍数始终为1.0，等比例缩放。
 * - iPad 适配倍数推荐1.2，所有含iPad倍数的类型都放大。
 * - force类型（forceWidth/forceHeight等）不乘iPad倍数，严格等比例。
 * - 其它类型如safeArea等同理。
 * - 若需自定义iPad放大倍数，可通过setup/Config.iPadFitMultiple设置。
 * 
 * 使用示例：
 * 
 * // 1. 基础适配
 * let width = 100.adap_width
 * let height = 200.adap_height
 * 
 * // 2. 配置验证
 * let validation = TFYSwiftAdaptiveKit.validateCurrentConfig()
 * if !validation.isValid {
 *     print("配置无效: \(validation.errors)")
 * }
 * 
 * // 3. 适配统计
 * print(TFYSwiftAdaptiveKit.getAdaptiveReport())
 * 
 * // 4. 配置持久化
 * TFYSwiftAdaptiveKit.saveConfigToUserDefaults()
 * TFYSwiftAdaptiveKit.loadConfigFromUserDefaults()
 * 
 * // 5. 性能监控
 * TFYSwiftAdaptiveKit.enablePerformanceMonitoring()
 * let performanceData = TFYSwiftAdaptiveKit.getPerformanceData()
 * 
 * // 6. 设备信息
 * let deviceInfo = TFYSwiftAdaptiveKit.getDeviceInfo()
 * let isSplitScreen = TFYSwiftAdaptiveKit.Device.isSplitScreen
 * let splitRatio = TFYSwiftAdaptiveKit.Device.splitScreenRatio
 */ 
