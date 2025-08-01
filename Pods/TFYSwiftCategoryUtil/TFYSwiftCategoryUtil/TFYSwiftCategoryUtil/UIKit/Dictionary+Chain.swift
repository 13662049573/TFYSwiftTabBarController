//
//  Dictionary+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import AVFoundation

extension Dictionary: TFYCompatible {}

public extension Dictionary {
    
    // MARK: 1.1、检查字典里面是否有某个 key
    /// 检查字典里面是否有某个 key
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    // MARK: 1.2、字典的key或者value组成的数组
    /// 字典的key或者value组成的数组
    /// - Parameter map: map
    /// - Returns: 数组
    func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        return self.map(map)
    }
    
    // MARK: 1.3、JSON字符串 -> 字典
    /// 本地JSON 转 字典
    /// - Parameters:
    ///   - name: 文件名
    ///   - ofType: 文件类型
    /// - Returns: 字典
    static func pathForResource(name: String, ofType: String) -> Dictionary<String, Any>? {
        // 安全获取Bundle路径，避免强制解包
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else {
            TFYUtils.Logger.log("未找到文件: \(name).\(ofType)", level: .warning)
            return nil
        }
        
        var encoding: String.Encoding = .utf8
        
        do {
            let jsonString = try String(contentsOfFile: path, usedEncoding: &encoding)
            let dict = Dictionary.jsonToDictionary(json: jsonString)
            return dict
        } catch {
            TFYUtils.Logger.log("读取文件失败: \(error.localizedDescription)", level: .error)
            return nil
        }
    }
    // MARK: 1.3、JSON字符串 -> 字典
    /// JsonString转为字典
    /// - Parameter json: JSON字符串
    /// - Returns: 字典
    static func jsonToDictionary(json: String) -> Dictionary<String, Any>? {
        guard let data = json.data(using: .utf8) else {
            TFYUtils.Logger.log("JSON字符串转Data失败")
            return nil
        }
        
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any>
            return result
        } catch {
            TFYUtils.Logger.log("JSON解析失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 1.4、字典 -> JSON字符串
    /// 字典转换为JSONString
    /// - Returns: JSON字符串，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toJSON() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            TFYUtils.Logger.log("字典转JSON失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 1.5、字典里面所有的 key
    /// 字典里面所有的key
    /// - Returns: key 数组
    func allKeys() -> [Key] {
        /*
         shuffled：不会改变原数组，返回一个新的随机化的数组。  可以用于let 数组
         */
        return self.keys.shuffled()
    }
    
    // MARK: 1.6、字典里面所有的 value
    /// 字典里面所有的value
    /// - Returns: value 数组
    func allValues() -> [Value] {
        return self.values.shuffled()
    }
    
    // MARK: 1.7、设置value
    subscript<Result>(key: Key, as type: Result.Type) -> Result? {
        get {
            return self[key] as? Result
        }
        set {
            // 如果传⼊ nil, 就删除现存的值。
            guard let value = newValue else {
                self[key] = nil
                return
            }
            // 如果类型不匹配，就忽略掉。
            guard let value2 = value as? Value else {
                return
            }
            self[key] = value2
        }
    }
    
    // MARK: 1.8、设置value
    /// 设置value
    /// - Parameters:
    ///   - keys: key链
    ///   - newValue: 新的value
    @discardableResult
    mutating func setValue(keys: [String], newValue: Any) -> Bool {
        guard keys.count > 1 else {
            guard keys.count == 1, let key = keys[0] as? Dictionary<Key, Value>.Keys.Element else {
                return false
            }
            self[key] = (newValue as! Value)
            return true
        }
        guard let key = keys[0] as? Dictionary<Key, Value>.Keys.Element, self.keys.contains(key), var value1 = self[key] as? [String: Any] else {
            return false
        }
        let result = Dictionary<String, Any>.value(keys: Array(keys[1..<keys.count]), oldValue: &value1, newValue: newValue)
        self[key] = (value1 as! Value)
        return result
    }
    
    /// 字典深层次设置value
    /// - Parameters:
    ///   - keys: key链
    ///   - oldValue: 字典
    ///   - newValue: 新的值
    @discardableResult
    private static func value(keys: [String], oldValue: inout [String: Any], newValue: Any) -> Bool {
        guard keys.count > 1 else {
            oldValue[keys[0]] = newValue
            return true
        }
        guard var value1 = oldValue[keys[0]] as? [String : Any] else { return false}
        let key = Array(keys[1..<keys.count])
        let result = value(keys: key, oldValue: &value1, newValue: newValue)
        oldValue[keys[0]] = value1
        return result
    }
    
    /// key是否存在在字典中
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    /// 移除key对应的value
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }
    
    /// 字典转Data
    func toData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    /// 字典转json
    func toJson(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    func toModel<T>(_ type: T.Type) -> T? where T: Decodable {
        return self.toData()?.toModel(T.self)
    }
    
    // MARK: 1.19、安全获取值
    /// 安全获取值
    /// - Parameters:
    ///   - key: 键
    ///   - defaultValue: 默认值
    /// - Returns: 值或默认值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func safeValue<T>(for key: Key, defaultValue: T) -> T {
        return self[key] as? T ?? defaultValue
    }
    
    // MARK: 1.20、深度合并字典
    /// 深度合并字典
    /// - Parameter other: 要合并的字典
    /// - Returns: 合并后的字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func tfy_deepMerge(with other: [Key: Value]) -> [Key: Value] {
        var result = self
        
        for (key, value) in other {
            if let existingValue = result[key] as? [String: Any],
               let newValue = value as? [String: Any] {
                result[key] = (existingValue.tfy_deepMerge(with: newValue) as! Value)
            } else {
                result[key] = value
            }
        }
        
        return result
    }
    
    // MARK: 1.21、过滤字典
    /// 过滤字典
    /// - Parameter predicate: 过滤条件
    /// - Returns: 过滤后的字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func filter(_ predicate: (Key, Value) -> Bool) -> [Key: Value] {
        return self.filter { predicate($0.key, $0.value) }
    }
    
    // MARK: 1.22、转换字典值
    /// 转换字典值
    /// - Parameter transform: 转换函数
    /// - Returns: 转换后的字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func tfy_mapValues<T>(_ transform: (Value) -> T) -> [Key: T] {
        var result = [Key: T]()
        for (k, v) in self {
            result[k] = transform(v)
        }
        return result
    }
    
    // MARK: 1.23、检查字典是否为空
    /// 检查字典是否为空
    /// - Returns: 是否为空
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isEmpty: Bool {
        return self.count == 0
    }
    
    // MARK: 1.24、获取字典大小
    /// 获取字典大小
    /// - Returns: 字典大小
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var size: Int {
        return self.count
    }
    
    // MARK: 1.25、创建空字典
    /// 创建空字典
    /// - Returns: 空字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func empty() -> [Key: Value] {
        return [:]
    }
    
    // MARK: 1.26、从数组创建字典
    /// 从数组创建字典
    /// - Parameters:
    ///   - array: 数组
    ///   - keyPath: 键路径
    /// - Returns: 字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func fromArray<T>(_ array: [T], keyPath: (T) -> Key, valuePath: (T) -> Value) -> [Key: Value] {
        var result: [Key: Value] = [:]
        for item in array {
            result[keyPath(item)] = valuePath(item)
        }
        return result
    }
}

// MARK: - 二、其他基本扩展
public extension TFY where Base == Dictionary<String, Any> {
    
    // MARK: 2.1、字典转JSON
    /// 字典转JSON
    @discardableResult
    func dictionaryToJson() -> String? {
        if (!JSONSerialization.isValidJSONObject(base)) {
            TFYUtils.Logger.log("无法解析出JSONString")
            return nil
        }
        if let data = try? JSONSerialization.data(withJSONObject: base) {
            let JSONString = NSString(data:data,encoding: String.Encoding.utf8.rawValue)
            return JSONString! as String
        } else {
            TFYUtils.Logger.log("无法解析出JSONString")
            return nil
        }
    }
}


