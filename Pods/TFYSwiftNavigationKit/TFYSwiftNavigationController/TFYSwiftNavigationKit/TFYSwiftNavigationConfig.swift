//
//  TFYSwiftNavigationConfig.swift
//  TFYSwiftNavigationController
//
//  Created by mi ni on 2025/2/13.
//

import Foundation
import UIKit

// MARK: - Navigation Configuration
@available(iOS 15.0, *)
public struct TFYSwiftNavigationConfig {
    
    // MARK: - Performance Settings
    /// 是否启用性能优化模式
    public static var enablePerformanceOptimization: Bool = true
    
    /// 是否启用缓存机制
    public static var enableCaching: Bool = true
    
    /// 是否启用异步布局
    public static var enableAsyncLayout: Bool = true
    
    /// 是否启用内存优化
    public static var enableMemoryOptimization: Bool = true
    
    // MARK: - Animation Settings
    /// 导航栏动画持续时间
    public static var animationDuration: TimeInterval = 0.25
    
    /// 是否启用流畅动画
    public static var enableSmoothAnimation: Bool = true
    
    // MARK: - Gesture Settings
    /// 手势识别器的最小距离
    public static var gestureMinimumDistance: CGFloat = 10.0
    
    /// 手势识别的最大速度
    public static var gestureMaximumVelocity: CGFloat = 1000.0
    
    // MARK: - Layout Settings
    /// 导航栏内容边距
    public static var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    /// 导航栏按钮间距
    public static var buttonSpacing: CGFloat = 8.0
    
    // MARK: - Visual Settings
    /// 导航栏透明度
    public static var navigationBarAlpha: CGFloat = 1.0
    
    /// 阴影透明度
    public static var shadowAlpha: CGFloat = 0.1
    
    /// 毛玻璃效果强度
    public static var blurIntensity: CGFloat = 0.8
}

// MARK: - Performance Monitor
@available(iOS 15.0, *)
public class TFYSwiftNavigationPerformanceMonitor {
    
    private static var performanceMetrics: [String: TimeInterval] = [:]
    
    /// 开始性能监控
    public static func startMonitoring(_ identifier: String) {
        performanceMetrics[identifier] = CACurrentMediaTime()
    }
    
    /// 结束性能监控
    public static func endMonitoring(_ identifier: String) -> TimeInterval? {
        guard let startTime = performanceMetrics[identifier] else { return nil }
        let duration = CACurrentMediaTime() - startTime
        performanceMetrics.removeValue(forKey: identifier)
        return duration
    }
    
    /// 记录性能指标
    public static func recordMetric(_ identifier: String, duration: TimeInterval) {
        print("TFYSwiftNavigation Performance - \(identifier): \(String(format: "%.3f", duration))s")
    }
}

// MARK: - Cache Manager
@available(iOS 15.0, *)
public class TFYSwiftNavigationCacheManager {
    
    private static var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
        return cache
    }()
    
    private static var colorCache: NSCache<NSString, UIColor> = {
        let cache = NSCache<NSString, UIColor>()
        cache.countLimit = 50
        return cache
    }()
    
    /// 缓存图片
    public static func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    /// 获取缓存的图片
    public static func getCachedImage(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    /// 缓存颜色
    public static func cacheColor(_ color: UIColor, forKey key: String) {
        colorCache.setObject(color, forKey: key as NSString)
    }
    
    /// 获取缓存的颜色
    public static func getCachedColor(forKey key: String) -> UIColor? {
        return colorCache.object(forKey: key as NSString)
    }
    
    /// 清除所有缓存
    public static func clearAllCaches() {
        imageCache.removeAllObjects()
        colorCache.removeAllObjects()
    }
}

// MARK: - Memory Manager
@available(iOS 15.0, *)
public class TFYSwiftNavigationMemoryManager {
    
    private static var weakReferences: [String: WeakReference] = [:]
    
    /// 弱引用包装器
    private class WeakReference {
        weak var object: AnyObject?
        
        init(_ object: AnyObject) {
            self.object = object
        }
    }
    
    /// 添加弱引用
    public static func addWeakReference(_ object: AnyObject, forKey key: String) {
        weakReferences[key] = WeakReference(object)
    }
    
    /// 获取弱引用对象
    public static func getWeakReference(forKey key: String) -> AnyObject? {
        return weakReferences[key]?.object
    }
    
    /// 清理无效的弱引用
    public static func cleanInvalidReferences() {
        weakReferences = weakReferences.filter { $0.value.object != nil }
    }
    
    /// 清理所有弱引用
    public static func clearAllWeakReferences() {
        weakReferences.removeAll()
    }
}

// MARK: - Async Layout Manager
@available(iOS 15.0, *)
public class TFYSwiftNavigationAsyncLayoutManager {
    
    private static let layoutQueue = DispatchQueue(label: "com.tfy.navigation.layout", qos: .userInteractive)
    
    /// 异步执行布局更新
    public static func performAsyncLayout(_ block: @escaping () -> Void, completion: @escaping () -> Void) {
        layoutQueue.async {
            block()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /// 异步执行UI更新
    public static func performAsyncUIUpdate(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}

// MARK: - Configuration Validator
@available(iOS 15.0, *)
public class TFYSwiftNavigationConfigValidator {
    
    /// 验证配置的有效性
    public static func validateConfiguration() -> Bool {
        // 验证动画持续时间
        guard TFYSwiftNavigationConfig.animationDuration > 0 && TFYSwiftNavigationConfig.animationDuration <= 1.0 else {
            print("TFYSwiftNavigation Warning: Invalid animation duration")
            return false
        }
        
        // 验证手势设置
        guard TFYSwiftNavigationConfig.gestureMinimumDistance >= 0 else {
            print("TFYSwiftNavigation Warning: Invalid gesture minimum distance")
            return false
        }
        
        // 验证透明度设置
        guard TFYSwiftNavigationConfig.navigationBarAlpha >= 0 && TFYSwiftNavigationConfig.navigationBarAlpha <= 1.0 else {
            print("TFYSwiftNavigation Warning: Invalid navigation bar alpha")
            return false
        }
        
        return true
    }
    
    /// 应用默认配置
    public static func applyDefaultConfiguration() {
        TFYSwiftNavigationConfig.enablePerformanceOptimization = true
        TFYSwiftNavigationConfig.enableCaching = true
        TFYSwiftNavigationConfig.enableAsyncLayout = true
        TFYSwiftNavigationConfig.enableMemoryOptimization = true
        TFYSwiftNavigationConfig.animationDuration = 0.25
        TFYSwiftNavigationConfig.enableSmoothAnimation = true
        TFYSwiftNavigationConfig.gestureMinimumDistance = 10.0
        TFYSwiftNavigationConfig.gestureMaximumVelocity = 1000.0
        TFYSwiftNavigationConfig.contentInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        TFYSwiftNavigationConfig.buttonSpacing = 8.0
        TFYSwiftNavigationConfig.navigationBarAlpha = 1.0
        TFYSwiftNavigationConfig.shadowAlpha = 0.1
        TFYSwiftNavigationConfig.blurIntensity = 0.8
    }
} 