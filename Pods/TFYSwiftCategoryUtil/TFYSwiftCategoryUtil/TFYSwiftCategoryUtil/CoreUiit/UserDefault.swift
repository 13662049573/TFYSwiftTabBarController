import UIKit
import Foundation

// MARK: - UserDefault Property Wrapper
/// UserDefault 属性包装器，提供便捷的 UserDefaults 访问
/// 支持 iOS 15.0 及以上版本
/// 支持 iPhone 和 iPad 适配

@propertyWrapper
public struct UserDefault<T> {
    
    /// UserDefaults 键名
    public let key: String
    
    /// UserDefaults 实例，默认为 standard
    private let userDefaults: UserDefaults
    
    /// 获取或设置值
    /// 如果值不存在则返回 nil
    public var wrappedValue: T? {
        get { 
            return userDefaults.object(forKey: key) as? T 
        }
        set { 
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
    
    /// 获取值，如果不存在则返回默认值
    /// - Parameter defaultValue: 默认值
    /// - Returns: 存储的值或默认值
    public func value(default defaultValue: T) -> T {
        return userDefaults.object(forKey: key) as? T ?? defaultValue
    }
    
    /// 检查键是否存在
    /// - Returns: 是否存在
    public var exists: Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    /// 删除存储的值
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }
    
    /// 创建 UserDefault 属性包装器
    /// - Parameters:
    ///   - key: UserDefaults 键名
    ///   - userDefaults: UserDefaults 实例，默认为 standard
    public init(_ key: String, userDefaults: UserDefaults = .standard) { 
        self.key = key
        self.userDefaults = userDefaults
    }
}

// MARK: - UserDefault Extensions for Common Types
/// 常见类型的 UserDefault 扩展

public extension UserDefault where T == String {
    
    /// 获取字符串值，如果不存在则返回空字符串
    var stringValue: String {
        return value(default: "")
    }
}

public extension UserDefault where T == Int {
    
    /// 获取整数值，如果不存在则返回 0
    var intValue: Int {
        return value(default: 0)
    }
}

public extension UserDefault where T == Double {
    
    /// 获取双精度值，如果不存在则返回 0.0
    var doubleValue: Double {
        return value(default: 0.0)
    }
}

public extension UserDefault where T == Bool {
    
    /// 获取布尔值，如果不存在则返回 false
    var boolValue: Bool {
        return value(default: false)
    }
}

public extension UserDefault where T == Data {
    
    /// 获取数据值，如果不存在则返回空数据
    var dataValue: Data {
        return value(default: Data())
    }
}

public extension UserDefault where T == [String] {
    
    /// 获取字符串数组，如果不存在则返回空数组
    var stringArrayValue: [String] {
        return value(default: [])
    }
}

// MARK: - UserDefault Extensions for Codable Types
/// 支持 Codable 类型的 UserDefault 扩展

public extension UserDefault where T: Codable {
    
    /// 获取 Codable 值
    /// - Parameter defaultValue: 默认值
    /// - Returns: 解码后的值或默认值
    func codableValue(default defaultValue: T) -> T {
        guard let data = userDefaults.data(forKey: key) else {
            return defaultValue
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to decode \(T.self) from UserDefaults: \(error)")
            return defaultValue
        }
    }
    
    /// 设置 Codable 值
    /// - Parameter value: 要存储的值
    func setCodableValue(_ value: T) {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to encode \(T.self) to UserDefaults: \(error)")
        }
    }
}

// MARK: - UserDefault Extensions for CGSize
/// CGSize 类型的 UserDefault 扩展

public extension UserDefault where T == CGSize {
    
    /// 获取 CGSize 值，如果不存在则返回零大小
    var sizeValue: CGSize {
        guard let data = userDefaults.data(forKey: key),
              let size = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSValue.self, from: data) else {
            return .zero
        }
        return size.cgSizeValue
    }
    
    /// 设置 CGSize 值
    /// - Parameter size: 要存储的大小
    func setSizeValue(_ size: CGSize) {
        let value = NSValue(cgSize: size)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) {
            userDefaults.set(data, forKey: key)
        }
    }
}

// MARK: - UserDefault Extensions for CGRect
/// CGRect 类型的 UserDefault 扩展

public extension UserDefault where T == CGRect {
    
    /// 获取 CGRect 值，如果不存在则返回零矩形
    var rectValue: CGRect {
        guard let data = userDefaults.data(forKey: key),
              let rect = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSValue.self, from: data) else {
            return .zero
        }
        return rect.cgRectValue
    }
    
    /// 设置 CGRect 值
    /// - Parameter rect: 要存储的矩形
    func setRectValue(_ rect: CGRect) {
        let value = NSValue(cgRect: rect)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) {
            userDefaults.set(data, forKey: key)
        }
    }
}

// MARK: - UserDefault Extensions for UIColor
/// UIColor 类型的 UserDefault 扩展

public extension UserDefault where T == UIColor {
    
    /// 获取 UIColor 值，如果不存在则返回黑色
    var colorValue: UIColor {
        guard let data = userDefaults.data(forKey: key),
              let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            return .black
        }
        return color
    }
    
    /// 设置 UIColor 值
    /// - Parameter color: 要存储的颜色
    func setColorValue(_ color: UIColor) {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            userDefaults.set(data, forKey: key)
        }
    }
}

// MARK: - UserDefault Extensions for Date
/// Date 类型的 UserDefault 扩展

public extension UserDefault where T == Date {
    
    /// 获取 Date 值，如果不存在则返回当前时间
    var dateValue: Date {
        return value(default: Date())
    }
}

// MARK: - UserDefault Extensions for URL
/// URL 类型的 UserDefault 扩展

public extension UserDefault where T == URL {
    
    /// 获取 URL 值，如果不存在则返回 nil
    var urlValue: URL? {
        return userDefaults.url(forKey: key)
    }
    
    /// 设置 URL 值
    /// - Parameter url: 要存储的 URL
    func setURLValue(_ url: URL?) {
        userDefaults.set(url, forKey: key)
    }
}
