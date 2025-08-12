//
//  UserDefaults+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UserDefaults {
    
    @discardableResult
    func removeObject(forKey defaultName: String) -> Self {
        base.removeObject(forKey: defaultName)
        return self
    }
    
    @discardableResult
    func set(_ value: Any?, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    @discardableResult
    func set(_ value: Bool, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    @discardableResult
    func set(_ value: Int, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    @discardableResult
    func set(_ value: Double, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    @discardableResult
    func set(_ value: Float, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    @discardableResult
    func set(_ url: URL?, forKey defaultName: String) -> Self {
        base.set(url, forKey: defaultName)
        return self
    }
    
    @discardableResult
    func synchronize() -> Bool {
        return base.synchronize()
    }
    
    /// 设置字符串值
    /// - Parameters:
    ///   - value: 字符串值
    ///   - defaultName: 键名
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func set(_ value: String, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    /// 设置数据值
    /// - Parameters:
    ///   - value: 数据值
    ///   - defaultName: 键名
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func set(_ value: Data, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    /// 设置数组值
    /// - Parameters:
    ///   - value: 数组值
    ///   - defaultName: 键名
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func set(_ value: [Any], forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    /// 设置字典值
    /// - Parameters:
    ///   - value: 字典值
    ///   - defaultName: 键名
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func set(_ value: [String: Any], forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    /// 设置日期值
    /// - Parameters:
    ///   - value: 日期值
    ///   - defaultName: 键名
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func set(_ value: Date, forKey defaultName: String) -> Self {
        base.set(value, forKey: defaultName)
        return self
    }
    
    /// 批量设置值
    /// - Parameter dictionary: 键值对字典
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setValues(_ dictionary: [String: Any]) -> Self {
        for (key, value) in dictionary {
            base.set(value, forKey: key)
        }
        return self
    }
    
    /// 检查键是否存在
    /// - Parameter defaultName: 键名
    /// - Returns: 如果键存在返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func hasKey(_ defaultName: String) -> Bool {
        return base.object(forKey: defaultName) != nil
    }
    
    /// 获取所有键
    /// - Returns: 所有键的数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func allKeys() -> [String] {
        return Array(base.dictionaryRepresentation().keys)
    }
    
    /// 获取所有值
    /// - Returns: 所有值的字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func allValues() -> [String: Any] {
        return base.dictionaryRepresentation()
    }
    
    /// 清空所有数据
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func clearAll() -> Self {
        let dictionary = base.dictionaryRepresentation()
        for key in dictionary.keys {
            base.removeObject(forKey: key)
        }
        return self
    }
    
    /// 重置为默认值
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func resetToDefaults() -> Self {
        base.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
        return self
    }
    
    /// 获取字符串值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 字符串值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func string(forKey defaultName: String, defaultValue: String = "") -> String {
        return base.string(forKey: defaultName) ?? defaultValue
    }
    
    /// 获取整数值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 整数值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func integer(forKey defaultName: String, defaultValue: Int = 0) -> Int {
        return base.integer(forKey: defaultName)
    }
    
    /// 获取浮点数值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 浮点数值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func float(forKey defaultName: String, defaultValue: Float = 0.0) -> Float {
        return base.float(forKey: defaultName)
    }
    
    /// 获取双精度值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 双精度值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func double(forKey defaultName: String, defaultValue: Double = 0.0) -> Double {
        return base.double(forKey: defaultName)
    }
    
    /// 获取布尔值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 布尔值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func bool(forKey defaultName: String, defaultValue: Bool = false) -> Bool {
        return base.bool(forKey: defaultName)
    }
    
    /// 获取数组值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 数组值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func array(forKey defaultName: String, defaultValue: [Any] = []) -> [Any] {
        return base.array(forKey: defaultName) ?? defaultValue
    }
    
    /// 获取字典值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 字典值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func dictionary(forKey defaultName: String, defaultValue: [String: Any] = [:]) -> [String: Any] {
        return base.dictionary(forKey: defaultName) ?? defaultValue
    }
    
    /// 获取数据值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 数据值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func data(forKey defaultName: String, defaultValue: Data = Data()) -> Data {
        return base.data(forKey: defaultName) ?? defaultValue
    }
    
    /// 获取URL值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: URL值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func url(forKey defaultName: String, defaultValue: URL? = nil) -> URL? {
        return base.url(forKey: defaultName) ?? defaultValue
    }
    
    /// 获取日期值（带默认值）
    /// - Parameters:
    ///   - defaultName: 键名
    ///   - defaultValue: 默认值
    /// - Returns: 日期值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func date(forKey defaultName: String, defaultValue: Date? = nil) -> Date? {
        return base.object(forKey: defaultName) as? Date ?? defaultValue
    }
    
    /// 安全地设置值（如果值不为nil）
    /// - Parameters:
    ///   - value: 值
    ///   - defaultName: 键名
    /// - Returns: 自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setIfNotNil(_ value: Any?, forKey defaultName: String) -> Self {
        if let value = value {
            base.set(value, forKey: defaultName)
        }
        return self
    }
    
    /// 获取存储大小
    /// - Returns: 存储大小（字节）
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func storageSize() -> Int64 {
        let dictionary = base.dictionaryRepresentation()
        var totalSize: Int64 = 0
        
        for (key, value) in dictionary {
            // 估算每个键值对的大小
            let keySize = key.utf8.count
            var valueSize = 0
            
            if let stringValue = value as? String {
                valueSize = stringValue.utf8.count
            } else if let dataValue = value as? Data {
                valueSize = dataValue.count
            } else if let arrayValue = value as? [Any] {
                valueSize = arrayValue.count * 8 // 估算
            } else if let dictValue = value as? [String: Any] {
                valueSize = dictValue.count * 16 // 估算
            } else {
                valueSize = 8 // 基本类型估算
            }
            
            totalSize += Int64(keySize + valueSize)
        }
        
        return totalSize
    }
    
    /// 获取格式化的存储大小
    /// - Returns: 格式化的存储大小字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func formattedStorageSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: storageSize())
    }
}
