//
//  TFYSwiftJsonKit.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/19.
//  用途：JSON 编解码工具，支持对象、字典、数组与 JSON 的互转。
//

import Foundation
import UIKit

/// JSON解析错误类型
public enum TFYJsonError: Error, LocalizedError {
    /// 无效数据
    case invalidData
    /// 编码失败
    case encodingFailed(Error)
    /// 解码失败
    case decodingFailed(Error)
    /// 无效类型
    case invalidType
    /// 自定义错误
    case customError(String)
    /// 深度超限
    case depthExceeded(Int)
    /// 循环引用
    case circularReference
    /// 内存不足
    case outOfMemory
    
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "无效的数据"
        case .encodingFailed(let error):
            return "编码失败: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "解码失败: \(error.localizedDescription)"
        case .invalidType:
            return "类型无效"
        case .customError(let message):
            return message
        case .depthExceeded(let depth):
            return "JSON深度超限: \(depth)"
        case .circularReference:
            return "检测到循环引用"
        case .outOfMemory:
            return "内存不足"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidData:
            return "输入的数据格式不正确或为空"
        case .encodingFailed:
            return "对象无法序列化为JSON格式"
        case .decodingFailed:
            return "JSON数据无法反序列化为目标类型"
        case .invalidType:
            return "目标类型与JSON数据类型不匹配"
        case .customError:
            return "用户自定义错误"
        case .depthExceeded:
            return "JSON嵌套层级过深，可能导致栈溢出"
        case .circularReference:
            return "对象之间存在循环引用关系"
        case .outOfMemory:
            return "处理大型JSON时内存不足"
        }
    }
}

/// JSON编解码配置
public struct TFYJsonConfig {
    /// 日期编码策略
    public var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
    /// 日期解码策略
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    /// 键编码策略
    public var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
    /// 键解码策略
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    /// 数据格式化选项
    public var outputFormatting: JSONEncoder.OutputFormatting = []
    /// 浮点数编码策略
    public var nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .throw
    /// 浮点数解码策略
    public var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw
    /// 最大深度限制
    public var maxDepth: Int = 100
    /// 是否允许循环引用
    public var allowCircularReference: Bool = false
    /// 是否启用缓存
    public var enableCache: Bool = true
    /// 缓存大小限制
    public var cacheSizeLimit: Int = 1000
    
    public init() {}
    
    /// 创建JSON编码器
    func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = dateEncodingStrategy
        encoder.keyEncodingStrategy = keyEncodingStrategy
        encoder.outputFormatting = outputFormatting
        encoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
        return encoder
    }
    
    /// 创建JSON解码器
    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        return decoder
    }
}

/// JSON工具类
public class TFYSwiftJsonKit: NSObject {
    
    /// 默认配置
    public static var defaultConfig = TFYJsonConfig()
    
    /// 缓存管理器
    private static let cache: NSCache<NSString, AnyObject> = {
        let c = NSCache<NSString, AnyObject>()
        c.countLimit = 1000
        c.totalCostLimit = 50 * 1024 * 1024 // 50MB
        return c
    }()
    private static let cacheQueue = DispatchQueue(label: "com.tfy.jsonkit.cache", attributes: .concurrent)
    
    // MARK: - 编码方法 (对象 -> JSON)
    
    /// 将对象编码为JSON数据
    /// - Parameters:
    ///   - value: 要编码的对象
    ///   - config: JSON配置
    /// - Returns: 编码结果
    public static func encode<T: Encodable>(_ value: T, 
                                          config: TFYJsonConfig = defaultConfig) -> Result<Data, TFYJsonError> {
        do {
            let encoder = config.makeEncoder()
            let data = try encoder.encode(value)
            return .success(data)
        } catch {
            return .failure(.encodingFailed(error))
        }
    }
    
    /// 将对象编码为JSON字符串
    /// - Parameters:
    ///   - value: 要编码的对象
    ///   - config: JSON配置
    /// - Returns: 编码结果
    public static func encodeToString<T: Encodable>(_ value: T, 
                                                   config: TFYJsonConfig = defaultConfig) -> Result<String, TFYJsonError> {
        switch encode(value, config: config) {
        case .success(let data):
            if let string = String(data: data, encoding: .utf8) {
                return .success(string)
            }
            return .failure(.invalidData)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK: - 解码方法 (JSON -> 对象)
    
    /// 将JSON数据解码为对象
    /// - Parameters:
    ///   - type: 目标类型
    ///   - data: JSON数据
    ///   - config: JSON配置
    /// - Returns: 解码结果
    public static func decode<T: Decodable>(_ type: T.Type, 
                                          from data: Data, 
                                          config: TFYJsonConfig = defaultConfig) -> Result<T, TFYJsonError> {
        guard !data.isEmpty else {
            print("TFYSwiftJsonKit: decode 传入数据为空")
            return .failure(.invalidData)
        }
        do {
            let decoder = config.makeDecoder()
            let value = try decoder.decode(type, from: data)
            return .success(value)
        } catch {
            return .failure(.decodingFailed(error))
        }
    }
    
    /// 将JSON字符串解码为对象
    /// - Parameters:
    ///   - type: 目标类型
    ///   - string: JSON字符串
    ///   - config: JSON配置
    /// - Returns: 解码结果
    public static func decode<T: Decodable>(_ type: T.Type, 
                                          from string: String, 
                                          config: TFYJsonConfig = defaultConfig) -> Result<T, TFYJsonError> {
        guard let data = string.data(using: .utf8) else {
            return .failure(.invalidData)
        }
        return decode(type, from: data, config: config)
    }
    
    // MARK: - 字典/数组转换
    
    /// 将字典转换为JSON数据
    /// - Parameter dictionary: 字典
    /// - Returns: 转换结果
    public static func dataFrom(dictionary: [String: Any]) -> Result<Data, TFYJsonError> {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return .success(data)
        } catch {
            return .failure(.encodingFailed(error))
        }
    }
    
    /// 将数组转换为JSON数据
    /// - Parameter array: 数组
    /// - Returns: 转换结果
    public static func dataFrom(array: [Any]) -> Result<Data, TFYJsonError> {
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            return .success(data)
        } catch {
            return .failure(.encodingFailed(error))
        }
    }
    
    /// 将JSON数据转换为字典
    /// - Parameter data: JSON数据
    /// - Returns: 转换结果
    public static func dictionary(from data: Data) -> Result<[String: Any], TFYJsonError> {
        do {
            if let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return .success(dict)
            }
            return .failure(.invalidType)
        } catch {
            return .failure(.decodingFailed(error))
        }
    }
    
    /// 将JSON数据转换为数组
    /// - Parameter data: JSON数据
    /// - Returns: 转换结果
    public static func array(from data: Data) -> Result<[Any], TFYJsonError> {
        do {
            if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
                return .success(array)
            }
            return .failure(.invalidType)
        } catch {
            return .failure(.decodingFailed(error))
        }
    }
    
    // MARK: - 模型转换
    
    /// 字典转模型
    /// - Parameters:
    ///   - type: 模型类型
    ///   - dict: 字典
    ///   - config: JSON配置
    /// - Returns: 转换结果
    public static func model<T: Decodable>(_ type: T.Type, 
                                         from dict: [String: Any], 
                                         config: TFYJsonConfig = defaultConfig) -> Result<T, TFYJsonError> {
        switch dataFrom(dictionary: dict) {
        case .success(let data):
            return decode(type, from: data, config: config)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 数组转模型数组
    /// - Parameters:
    ///   - type: 模型类型
    ///   - array: 数组
    ///   - config: JSON配置
    /// - Returns: 转换结果
    public static func models<T: Decodable>(_ type: T.Type, 
                                          from array: [[String: Any]], 
                                          config: TFYJsonConfig = defaultConfig) -> Result<[T], TFYJsonError> {
        switch dataFrom(array: array) {
        case .success(let data):
            return decode([T].self, from: data, config: config)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 模型转字典
    /// - Parameters:
    ///   - model: 模型对象
    ///   - config: JSON配置
    /// - Returns: 转换结果
    public static func dictionary<T: Encodable>(from model: T, 
                                              config: TFYJsonConfig = defaultConfig) -> Result<[String: Any], TFYJsonError> {
        switch encode(model, config: config) {
        case .success(let data):
            return dictionary(from: data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 模型数组转字典数组
    /// - Parameters:
    ///   - models: 模型数组
    ///   - config: JSON配置
    /// - Returns: 转换结果
    public static func dictionaries<T: Encodable>(from models: [T], 
                                                config: TFYJsonConfig = defaultConfig) -> Result<[[String: Any]], TFYJsonError> {
        switch encode(models, config: config) {
        case .success(let data):
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                    return .success(array)
                }
                return .failure(.invalidType)
            } catch {
                return .failure(.decodingFailed(error))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK: - 工具方法
    
    /// 格式化JSON字符串
    /// - Parameter jsonString: JSON字符串
    /// - Returns: 格式化结果
    public static func prettyPrint(_ jsonString: String) -> Result<String, TFYJsonError> {
        guard let data = jsonString.data(using: .utf8) else {
            return .failure(.invalidData)
        }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                return .success(prettyString)
            }
            return .failure(.invalidData)
        } catch {
            return .failure(.decodingFailed(error))
        }
    }
    
    /// 验证JSON字符串是否有效
    /// - Parameter jsonString: JSON字符串
    /// - Returns: 验证结果
    public static func validate(_ jsonString: String) -> Bool {
        guard let data = jsonString.data(using: .utf8) else {
            return false
        }
        
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            return true
        } catch {
            return false
        }
    }
    
    /// 合并多个JSON对象
    /// - Parameter objects: JSON对象数组
    /// - Returns: 合并结果
    public static func merge(_ objects: [[String: Any]]) -> [String: Any] {
        var result: [String: Any] = [:]
        objects.forEach { dict in
            dict.forEach { key, value in
                result[key] = value
            }
        }
        return result
    }
    
    /// 快速创建配置
    /// - Parameters:
    ///   - dateFormat: 日期格式
    ///   - keyStrategy: 键编码策略
    ///   - outputFormatting: 输出格式化选项
    /// - Returns: JSON配置
    public static func config(
        dateFormat: String? = nil,
        keyStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
        outputFormatting: JSONEncoder.OutputFormatting = []
    ) -> TFYJsonConfig {
        var config = TFYJsonConfig()
        
        if let dateFormat = dateFormat {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            config.dateEncodingStrategy = .formatted(formatter)
            config.dateDecodingStrategy = .formatted(formatter)
        }
        
        config.keyEncodingStrategy = keyStrategy
        config.outputFormatting = outputFormatting
        return config
    }
    
    // MARK: - 高级功能
    
    /// 深度合并两个JSON对象
    /// - Parameters:
    ///   - target: 目标对象
    ///   - source: 源对象
    /// - Returns: 合并后的对象
    public static func deepMerge(_ target: [String: Any], with source: [String: Any]) -> [String: Any] {
        var result = target
        
        for (key, value) in source {
            if let dictValue = value as? [String: Any],
               let existingValue = result[key] as? [String: Any] {
                result[key] = deepMerge(existingValue, with: dictValue)
            } else if let arrayValue = value as? [Any],
                      let existingValue = result[key] as? [Any] {
                result[key] = existingValue + arrayValue
            } else {
                result[key] = value
            }
        }
        
        return result
    }
    
    /// 提取JSON路径的值
    /// - Parameters:
    ///   - json: JSON对象
    ///   - path: 路径，如 "user.profile.name"
    /// - Returns: 路径对应的值
    public static func extractValue(from json: [String: Any], at path: String) -> Any? {
        let keys = path.components(separatedBy: ".")
        var current: Any = json
        
        for key in keys {
            if let dict = current as? [String: Any] {
                current = dict[key] ?? NSNull()
            } else if let array = current as? [Any],
                      let index = Int(key),
                      index >= 0 && index < array.count {
                current = array[index]
            } else {
                return nil
            }
            
            if current is NSNull {
                return nil
            }
        }
        
        return current
    }
    
    /// 验证JSON Schema
    /// - Parameters:
    ///   - json: 要验证的JSON
    ///   - schema: Schema定义
    /// - Returns: 验证结果
    public static func validateSchema(_ json: Any, against schema: [String: Any]) -> Bool {
        // 基础Schema验证实现
        guard let type = schema["type"] as? String else { return true }
        
        switch type {
        case "object":
            guard let jsonObject = json as? [String: Any] else { return false }
            
            // 检查必需字段
            if let required = schema["required"] as? [String] {
                for field in required {
                    if jsonObject[field] == nil { return false }
                }
            }
            
            // 检查属性类型
            if let properties = schema["properties"] as? [String: [String: Any]] {
                for (key, value) in jsonObject {
                    if let propertySchema = properties[key] {
                        if !validateSchema(value, against: propertySchema) {
                            return false
                        }
                    }
                }
            }
            
        case "array":
            guard let jsonArray = json as? [Any] else { return false }
            
            // 检查数组元素类型
            if let items = schema["items"] as? [String: Any] {
                for item in jsonArray {
                    if !validateSchema(item, against: items) {
                        return false
                    }
                }
            }
            
            // 检查数组长度限制
            if let minItems = schema["minItems"] as? Int {
                if jsonArray.count < minItems { return false }
            }
            if let maxItems = schema["maxItems"] as? Int {
                if jsonArray.count > maxItems { return false }
            }
            
        case "string":
            guard json is String else { return false }
            
            // 检查字符串长度限制
            if let minLength = schema["minLength"] as? Int {
                if let str = json as? String, str.count < minLength { return false }
            }
            if let maxLength = schema["maxLength"] as? Int {
                if let str = json as? String, str.count > maxLength { return false }
            }
            
            // 检查正则表达式
            if let pattern = schema["pattern"] as? String {
                if let str = json as? String {
                    let regex = try? NSRegularExpression(pattern: pattern, options: [])
                    let range = NSRange(location: 0, length: str.count)
                    if regex?.firstMatch(in: str, options: [], range: range) == nil {
                        return false
                    }
                }
            }
            
        case "number":
            guard json is NSNumber else { return false }
            
            // 检查数值范围
            if let minimum = schema["minimum"] as? Double {
                if let num = json as? NSNumber, num.doubleValue < minimum { return false }
            }
            if let maximum = schema["maximum"] as? Double {
                if let num = json as? NSNumber, num.doubleValue > maximum { return false }
            }
            
        case "integer":
            guard json is NSNumber else { return false }
            if let num = json as? NSNumber {
                // 检查是否为整数
                if num.doubleValue.truncatingRemainder(dividingBy: 1) != 0 { return false }
            }
            
        case "boolean":
            guard json is Bool else { return false }
            
        case "null":
            guard json is NSNull else { return false }
            
        default:
            return true
        }
        
        return true
    }
    
    // MARK: - Schema构建器
    
    /// 创建对象Schema
    /// - Parameters:
    ///   - properties: 属性定义
    ///   - required: 必需字段
    /// - Returns: Schema定义
    public static func objectSchema(properties: [String: [String: Any]], required: [String] = []) -> [String: Any] {
        return [
            "type": "object",
            "properties": properties,
            "required": required
        ]
    }
    
    /// 创建数组Schema
    /// - Parameters:
    ///   - items: 数组元素Schema
    ///   - minItems: 最小元素数量
    ///   - maxItems: 最大元素数量
    /// - Returns: Schema定义
    public static func arraySchema(items: [String: Any], minItems: Int? = nil, maxItems: Int? = nil) -> [String: Any] {
        var schema: [String: Any] = [
            "type": "array",
            "items": items
        ]
        
        if let minItems = minItems {
            schema["minItems"] = minItems
        }
        if let maxItems = maxItems {
            schema["maxItems"] = maxItems
        }
        
        return schema
    }
    
    /// 创建字符串Schema
    /// - Parameters:
    ///   - minLength: 最小长度
    ///   - maxLength: 最大长度
    ///   - pattern: 正则表达式
    /// - Returns: Schema定义
    public static func stringSchema(minLength: Int? = nil, maxLength: Int? = nil, pattern: String? = nil) -> [String: Any] {
        var schema: [String: Any] = ["type": "string"]
        
        if let minLength = minLength {
            schema["minLength"] = minLength
        }
        if let maxLength = maxLength {
            schema["maxLength"] = maxLength
        }
        if let pattern = pattern {
            schema["pattern"] = pattern
        }
        
        return schema
    }
    
    /// 创建数字Schema
    /// - Parameters:
    ///   - minimum: 最小值
    ///   - maximum: 最大值
    /// - Returns: Schema定义
    public static func numberSchema(minimum: Double? = nil, maximum: Double? = nil) -> [String: Any] {
        var schema: [String: Any] = ["type": "number"]
        
        if let minimum = minimum {
            schema["minimum"] = minimum
        }
        if let maximum = maximum {
            schema["maximum"] = maximum
        }
        
        return schema
    }
    
    /// 创建整数Schema
    /// - Parameters:
    ///   - minimum: 最小值
    ///   - maximum: 最大值
    /// - Returns: Schema定义
    public static func integerSchema(minimum: Int? = nil, maximum: Int? = nil) -> [String: Any] {
        var schema: [String: Any] = ["type": "integer"]
        
        if let minimum = minimum {
            schema["minimum"] = minimum
        }
        if let maximum = maximum {
            schema["maximum"] = maximum
        }
        
        return schema
    }
    
    // MARK: - 高级功能
    
    /// 压缩JSON字符串（移除空格和换行）
    /// - Parameter jsonString: JSON字符串
    /// - Returns: 压缩结果
    public static func compress(_ jsonString: String) -> Result<String, TFYJsonError> {
        guard let data = jsonString.data(using: .utf8) else {
            return .failure(.invalidData)
        }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let compressedData = try JSONSerialization.data(withJSONObject: object, options: [])
            if let compressedString = String(data: compressedData, encoding: .utf8) {
                return .success(compressedString)
            }
            return .failure(.invalidData)
        } catch {
            return .failure(.decodingFailed(error))
        }
    }
    
    /// 比较两个JSON对象是否相等
    /// - Parameters:
    ///   - json1: 第一个JSON对象
    ///   - json2: 第二个JSON对象
    /// - Returns: 是否相等
    public static func isEqual(_ json1: [String: Any], _ json2: [String: Any]) -> Bool {
        return NSDictionary(dictionary: json1).isEqual(to: json2)
    }
    
    /// 获取JSON差异
    /// - Parameters:
    ///   - json1: 第一个JSON对象
    ///   - json2: 第二个JSON对象
    /// - Returns: 差异信息
    public static func getDifferences(between json1: [String: Any], and json2: [String: Any]) -> [String: Any] {
        var differences: [String: Any] = [:]
        
        // 获取所有键
        let allKeys = Set(json1.keys).union(Set(json2.keys))
        
        for key in allKeys {
            let value1 = json1[key]
            let value2 = json2[key]
            
            if value1 == nil && value2 != nil {
                differences[key] = ["type": "added", "value": value2!]
            } else if value1 != nil && value2 == nil {
                differences[key] = ["type": "removed", "value": value1!]
            } else if let val1 = value1, let val2 = value2, (val1 as? NSObject)?.isEqual(val2) == true {
                differences[key] = [
                    "type": "changed",
                    "oldValue": val1,
                    "newValue": val2
                ]
            }
        }
        
        return differences
    }
    
    /// 设置JSON路径的值
    /// - Parameters:
    ///   - json: JSON对象
    ///   - path: 路径，如 "user.profile.name"
    ///   - value: 要设置的值
    /// - Returns: 设置后的JSON对象
    public static func setValue(_ value: Any, at path: String, in json: [String: Any]) -> [String: Any] {
        let keys = path.components(separatedBy: ".")
        var result = json
        
        if keys.count == 1 {
            result[keys[0]] = value
        } else {
            let firstKey = keys[0]
            let remainingPath = keys.dropFirst().joined(separator: ".")
            
            var nestedDict = result[firstKey] as? [String: Any] ?? [:]
            nestedDict = setValue(value, at: remainingPath, in: nestedDict)
            result[firstKey] = nestedDict
        }
        
        return result
    }
    
    /// 异步编码
    /// - Parameters:
    ///   - value: 要编码的对象
    ///   - config: JSON配置
    ///   - queue: 执行队列
    ///   - completion: 完成回调
    public static func encodeAsync<T: Encodable>(
        _ value: T,
        config: TFYJsonConfig = defaultConfig,
        queue: DispatchQueue = .global(qos: .userInitiated),
        completion: @escaping (Result<Data, TFYJsonError>) -> Void
    ) {
        queue.async {
            let result = encode(value, config: config)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    /// 异步解码
    /// - Parameters:
    ///   - type: 目标类型
    ///   - data: JSON数据
    ///   - config: JSON配置
    ///   - queue: 执行队列
    ///   - completion: 完成回调
    public static func decodeAsync<T: Decodable>(
        _ type: T.Type,
        from data: Data,
        config: TFYJsonConfig = defaultConfig,
        queue: DispatchQueue = .global(qos: .userInitiated),
        completion: @escaping (Result<T, TFYJsonError>) -> Void
    ) {
        queue.async {
            let result = decode(type, from: data, config: config)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    /// 验证JSON深度
    /// - Parameters:
    ///   - json: JSON对象
    ///   - maxDepth: 最大深度
    /// - Returns: 验证结果
    public static func validateDepth(_ json: Any, maxDepth: Int = 100) -> Result<Void, TFYJsonError> {
        func checkDepth(_ obj: Any, currentDepth: Int) -> Result<Void, TFYJsonError> {
            if currentDepth > maxDepth {
                return .failure(.depthExceeded(currentDepth))
            }
            
            if let dict = obj as? [String: Any] {
                for value in dict.values {
                    let result = checkDepth(value, currentDepth: currentDepth + 1)
                    if case .failure = result {
                        return result
                    }
                }
            } else if let array = obj as? [Any] {
                for item in array {
                    let result = checkDepth(item, currentDepth: currentDepth + 1)
                    if case .failure = result {
                        return result
                    }
                }
            }
            
            return .success(())
        }
        
        return checkDepth(json, currentDepth: 1)
    }
    
    /// 清理缓存
    public static func clearCache() {
        cacheQueue.async(flags: .barrier) {
            cache.removeAllObjects()
        }
    }
    
    /// 获取缓存统计信息
    public static func getCacheStats() -> [String: Any] {
        return [
            "count": cache.totalCostLimit,
            "memoryUsage": cache.totalCostLimit,
            "objectCount": cache.countLimit
        ]
    }
    
    /// 重置默认配置
    public static func resetDefaultConfig() {
        defaultConfig = TFYJsonConfig()
    }
    
    /// 更新默认配置
    /// - Parameter config: 新配置
    public static func updateDefaultConfig(_ config: TFYJsonConfig) {
        defaultConfig = config
    }
    
    // MARK: - JSON转换器
    
    /// JSON转换器协议
    public protocol TFYJsonConverter {
        associatedtype Input
        associatedtype Output
        
        func convert(_ input: Input) -> Result<Output, TFYJsonError>
    }
    
    /// 字符串到字典转换器
    public struct StringToDictionaryConverter: TFYJsonConverter {
        public typealias Input = String
        public typealias Output = [String: Any]
        
        public init() {}
        
        public func convert(_ input: String) -> Result<[String: Any], TFYJsonError> {
            return input.toDictionary()
        }
    }
    
    /// 字典到字符串转换器
    public struct DictionaryToStringConverter: TFYJsonConverter {
        public typealias Input = [String: Any]
        public typealias Output = String
        
        public init() {}
        
        public func convert(_ input: [String: Any]) -> Result<String, TFYJsonError> {
            return input.toJsonString()
        }
    }
    
    // MARK: - JSON补丁操作
    
    /// JSON补丁操作类型
    public enum TFYJsonPatchOperation: String, Codable {
        case add = "add"
        case remove = "remove"
        case replace = "replace"
        case move = "move"
        case copy = "copy"
        case test = "test"
    }
    
    /// JSON补丁
    public struct TFYJsonPatch: Codable {
        public let op: TFYJsonPatchOperation
        public let path: String
        public let value: Any?
        public let from: String?
        
        public init(op: TFYJsonPatchOperation, path: String, value: Any? = nil, from: String? = nil) {
            self.op = op
            self.path = path
            self.value = value
            self.from = from
        }
        
        private enum CodingKeys: String, CodingKey {
            case op, path, value, from
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            op = try container.decode(TFYJsonPatchOperation.self, forKey: .op)
            path = try container.decode(String.self, forKey: .path)
            value = try container.decodeIfPresent(AnyCodable.self, forKey: .value)?.value
            from = try container.decodeIfPresent(String.self, forKey: .from)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(op, forKey: .op)
            try container.encode(path, forKey: .path)
            if let value = value {
                let anyCodable = AnyCodable(value)
                let valueEncoder = container.superEncoder(forKey: .value)
                try anyCodable.encode(to: valueEncoder)
            } else {
                try container.encodeNil(forKey: .value)
            }
            try container.encodeIfPresent(from, forKey: .from)
        }
    }
    
    /// 应用JSON补丁
    /// - Parameters:
    ///   - patches: 补丁数组
    ///   - json: 目标JSON
    /// - Returns: 应用结果
    public static func applyPatches(_ patches: [TFYJsonPatch], to json: [String: Any]) -> Result<[String: Any], TFYJsonError> {
        var result = json
        
        for patch in patches {
            switch patch.op {
            case .add:
                result = setValue(patch.value ?? NSNull(), at: patch.path, in: result)
            case .remove:
                // 实现移除逻辑
                break
            case .replace:
                result = setValue(patch.value ?? NSNull(), at: patch.path, in: result)
            case .move:
                if let from = patch.from {
                    if let value = extractValue(from: result, at: from) {
                        result = setValue(value, at: patch.path, in: result)
                        // 移除原值
                        result = setValue(NSNull(), at: from, in: result)
                    }
                }
            case .copy:
                if let from = patch.from {
                    if let value = extractValue(from: result, at: from) {
                        result = setValue(value, at: patch.path, in: result)
                    }
                }
            case .test:
                if let expectedValue = patch.value {
                    if let actualValue = extractValue(from: result, at: patch.path) {
                        if (expectedValue as? NSObject)?.isEqual(actualValue) != true {
                            return .failure(.customError("Test failed: expected \(expectedValue), got \(actualValue)"))
                        }
                    } else {
                        return .failure(.customError("Test failed: path not found"))
                    }
                }
            }
        }
        
        return .success(result)
    }
    
    // MARK: - 性能监控
    
    /// 性能统计
    public struct TFYJsonPerformanceStats {
        public let encodingTime: TimeInterval
        public let decodingTime: TimeInterval
        public let dataSize: Int
        public let memoryUsage: Int
        
        public init(encodingTime: TimeInterval, decodingTime: TimeInterval, dataSize: Int, memoryUsage: Int) {
            self.encodingTime = encodingTime
            self.decodingTime = decodingTime
            self.dataSize = dataSize
            self.memoryUsage = memoryUsage
        }
    }
    
    /// 带性能监控的编码
    /// - Parameters:
    ///   - value: 要编码的对象
    ///   - config: JSON配置
    /// - Returns: 编码结果和性能统计
    public static func encodeWithPerformance<T: Encodable>(_ value: T, config: TFYJsonConfig = defaultConfig) -> (Result<Data, TFYJsonError>, TFYJsonPerformanceStats) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = encode(value, config: config)
        let encodingTime = CFAbsoluteTimeGetCurrent() - startTime
        let dataSize: Int
        switch result {
        case .success(let data):
            dataSize = data.count
        default:
            dataSize = 0
        }
        let memoryUsage = MemoryLayout<T>.size
        
        let stats = TFYJsonPerformanceStats(
            encodingTime: encodingTime,
            decodingTime: 0,
            dataSize: dataSize,
            memoryUsage: memoryUsage
        )
        
        return (result, stats)
    }
    
    /// 带性能监控的解码
    /// - Parameters:
    ///   - type: 目标类型
    ///   - data: JSON数据
    ///   - config: JSON配置
    /// - Returns: 解码结果和性能统计
    public static func decodeWithPerformance<T: Decodable>(_ type: T.Type, from data: Data, config: TFYJsonConfig = defaultConfig) -> (Result<T, TFYJsonError>, TFYJsonPerformanceStats) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = decode(type, from: data, config: config)
        let decodingTime = CFAbsoluteTimeGetCurrent() - startTime
        let dataSize = data.count
        let memoryUsage = MemoryLayout<T>.size
        
        let stats = TFYJsonPerformanceStats(
            encodingTime: 0,
            decodingTime: decodingTime,
            dataSize: dataSize,
            memoryUsage: memoryUsage
        )
        
        return (result, stats)
    }
    
    // MARK: - 实用工具方法
    
    /// 生成随机JSON
    /// - Parameters:
    ///   - depth: 最大深度
    ///   - maxKeys: 最大键数
    /// - Returns: 随机JSON
    public static func generateRandomJson(depth: Int = 3, maxKeys: Int = 5) -> [String: Any] {
        func generateValue(currentDepth: Int) -> Any {
            if currentDepth >= depth {
                return Int.random(in: 1...100)
            }
            
            let type = Int.random(in: 0...3)
            switch type {
            case 0:
                return Int.random(in: 1...100)
            case 1:
                return "value_\(Int.random(in: 1...1000))"
            case 2:
                return Bool.random()
            case 3:
                var dict: [String: Any] = [:]
                let keyCount = Int.random(in: 1...maxKeys)
                for i in 0..<keyCount {
                    dict["key_\(i)"] = generateValue(currentDepth: currentDepth + 1)
                }
                return dict
            default:
                return "default"
            }
        }
        
        return generateValue(currentDepth: 0) as? [String: Any] ?? [:]
    }
    
    /// 验证JSON结构
    /// - Parameters:
    ///   - json: JSON对象
    ///   - structure: 期望的结构
    /// - Returns: 验证结果
    public static func validateStructure(_ json: [String: Any], against structure: [String: String]) -> Bool {
        for (key, expectedType) in structure {
            guard let value = json[key] else { return false }
            
            switch expectedType {
            case "string":
                if !(value is String) { return false }
            case "number":
                if !(value is NSNumber) { return false }
            case "boolean":
                if !(value is Bool) { return false }
            case "array":
                if !(value is [Any]) { return false }
            case "object":
                if !(value is [String: Any]) { return false }
            default:
                return false
            }
        }
        
        return true
    }
    
    /// 获取JSON大小（字节）
    /// - Parameter json: JSON对象
    /// - Returns: 大小
    public static func getJsonSize(_ json: [String: Any]) -> Int {
        switch dataFrom(dictionary: json) {
        case .success(let data):
            return data.count
        case .failure:
            return 0
        }
    }
    
    /// 检查JSON是否为空
    /// - Parameter json: JSON对象
    /// - Returns: 是否为空
    public static func isEmpty(_ json: [String: Any]) -> Bool {
        return json.isEmpty
    }
    
    /// 检查JSON是否为null
    /// - Parameter json: JSON对象
    /// - Returns: 是否为null
    public static func isNull(_ json: Any) -> Bool {
        return json is NSNull
    }
    
    /// 检查JSON是否为数字
    /// - Parameter json: JSON对象
    /// - Returns: 是否为数字
    public static func isNumber(_ json: Any) -> Bool {
        return json is NSNumber
    }
    
    /// 检查JSON是否为字符串
    /// - Parameter json: JSON对象
    /// - Returns: 是否为字符串
    public static func isString(_ json: Any) -> Bool {
        return json is String
    }
    
    /// 检查JSON是否为布尔值
    /// - Parameter json: JSON对象
    /// - Returns: 是否为布尔值
    public static func isBoolean(_ json: Any) -> Bool {
        return json is Bool
    }
    
    /// 检查JSON是否为数组
    /// - Parameter json: JSON对象
    /// - Returns: 是否为数组
    public static func isArray(_ json: Any) -> Bool {
        return json is [Any]
    }
    
    /// 检查JSON是否为对象
    /// - Parameter json: JSON对象
    /// - Returns: 是否为对象
    public static func isObject(_ json: Any) -> Bool {
        return json is [String: Any]
    }
    
    /// 获取JSON的所有键
    /// - Parameter json: JSON对象
    /// - Returns: 键数组
    public static func getAllKeys(_ json: [String: Any]) -> [String] {
        var keys: Set<String> = []
        
        func extractKeys(_ obj: Any) {
            if let dict = obj as? [String: Any] {
                keys.formUnion(dict.keys)
                for value in dict.values {
                    extractKeys(value)
                }
            } else if let array = obj as? [Any] {
                for item in array {
                    extractKeys(item)
                }
            }
        }
        
        extractKeys(json)
        return Array(keys)
    }
    
    /// 获取JSON的所有值
    /// - Parameter json: JSON对象
    /// - Returns: 值数组
    public static func getAllValues(_ json: [String: Any]) -> [Any] {
        var values: [Any] = []
        
        func extractValues(_ obj: Any) {
            if let dict = obj as? [String: Any] {
                for value in dict.values {
                    values.append(value)
                    extractValues(value)
                }
            } else if let array = obj as? [Any] {
                for item in array {
                    values.append(item)
                    extractValues(item)
                }
            }
        }
        
        extractValues(json)
        return values
    }
    
    /// 检查JSON是否包含指定键
    /// - Parameters:
    ///   - json: JSON对象
    ///   - key: 要检查的键
    /// - Returns: 是否包含
    public static func containsKey(_ key: String, in json: [String: Any]) -> Bool {
        return getAllKeys(json).contains(key)
    }
    
    /// 获取JSON的深度
    /// - Parameter json: JSON对象
    /// - Returns: 深度
    public static func getDepth(_ json: [String: Any]) -> Int {
        func calculateDepth(_ obj: Any, currentDepth: Int) -> Int {
            var maxDepth = currentDepth
            
            if let dict = obj as? [String: Any] {
                for value in dict.values {
                    maxDepth = max(maxDepth, calculateDepth(value, currentDepth: currentDepth + 1))
                }
            } else if let array = obj as? [Any] {
                for item in array {
                    maxDepth = max(maxDepth, calculateDepth(item, currentDepth: currentDepth + 1))
                }
            }
            
            return maxDepth
        }
        
        return calculateDepth(json, currentDepth: 1)
    }
}

// MARK: - 辅助类型

/// 支持编码任意类型的包装器
public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable cannot decode value")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch value {
        case is NSNull:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case let bool as Bool:
            var container = encoder.singleValueContainer()
            try container.encode(bool)
        case let int as Int:
            var container = encoder.singleValueContainer()
            try container.encode(int)
        case let double as Double:
            var container = encoder.singleValueContainer()
            try container.encode(double)
        case let string as String:
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case let array as [Any]:
            var container = encoder.unkeyedContainer()
            for element in array {
                let anyCodable = AnyCodable(element)
                try container.encode(anyCodable)
            }
        case let dictionary as [String: Any]:
            var container = encoder.container(keyedBy: AnyCodingKey.self)
            for (key, value) in dictionary {
                let anyCodable = AnyCodable(value)
                try container.encode(anyCodable, forKey: AnyCodingKey(stringValue: key)!)
            }
        default:
            let container = encoder.singleValueContainer()
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable cannot encode value"))
        }
    }
}

// MARK: - AnyCodingKey for dynamic dictionary keys
public struct AnyCodingKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    public init?(stringValue: String) { self.stringValue = stringValue; self.intValue = nil }
    public init?(intValue: Int) { self.stringValue = "\(intValue)"; self.intValue = intValue }
}

// MARK: - Codable扩展
public extension Encodable {
    /// 转换为字典
    func toDictionary(config: TFYJsonConfig = .init()) -> Result<[String: Any], TFYJsonError> {
        return TFYSwiftJsonKit.dictionary(from: self, config: config)
    }
    
    /// 转换为JSON字符串
    func toJsonString(config: TFYJsonConfig = .init()) -> Result<String, TFYJsonError> {
        return TFYSwiftJsonKit.encodeToString(self, config: config)
    }
}

// MARK: - 数组扩展
public extension Array where Element: Encodable {
    /// 模型数组转字典数组
    func toDictionaries(config: TFYJsonConfig = .init()) -> Result<[[String: Any]], TFYJsonError> {
        return TFYSwiftJsonKit.dictionaries(from: self, config: config)
    }
    
    /// 模型数组转JSON字符串
    func toJsonString(config: TFYJsonConfig = .init()) -> Result<String, TFYJsonError> {
        return TFYSwiftJsonKit.encodeToString(self, config: config)
    }
}

// MARK: - Decodable扩展
public extension Decodable {
    /// 从字典创建模型
    static func from(dict: [String: Any], config: TFYJsonConfig = .init()) -> Result<Self, TFYJsonError> {
        return TFYSwiftJsonKit.model(Self.self, from: dict, config: config)
    }
    
    /// 从字典数组创建模型数组
    static func from(array: [[String: Any]], config: TFYJsonConfig = .init()) -> Result<[Self], TFYJsonError> {
        return TFYSwiftJsonKit.models(Self.self, from: array, config: config)
    }
}

// MARK: - Dictionary扩展
public extension Dictionary where Key == String {
    /// 获取JSON路径的值
    func getValue(at path: String) -> Any? {
        return TFYSwiftJsonKit.extractValue(from: self, at: path)
    }
    
    /// 设置JSON路径的值
    func setValue(_ value: Any, at path: String) -> [String: Any] {
        return TFYSwiftJsonKit.setValue(value, at: path, in: self)
    }
    
    /// 转换为JSON字符串
    func toJsonString() -> Result<String, TFYJsonError> {
        return TFYSwiftJsonKit.dataFrom(dictionary: self).flatMap { data in
            if let string = String(data: data, encoding: .utf8) {
                return .success(string)
            }
            return .failure(.invalidData)
        }
    }
    
    /// 深度合并
    func deepMerge(with other: [String: Any]) -> [String: Any] {
        return TFYSwiftJsonKit.deepMerge(self, with: other)
    }
    
    /// 获取差异
    func differences(from other: [String: Any]) -> [String: Any] {
        return TFYSwiftJsonKit.getDifferences(between: self, and: other)
    }
}

// MARK: - String扩展
public extension String {
    /// 验证是否为有效JSON
    var isValidJson: Bool {
        return TFYSwiftJsonKit.validate(self)
    }
    
    /// 格式化JSON
    func prettyPrint() -> Result<String, TFYJsonError> {
        return TFYSwiftJsonKit.prettyPrint(self)
    }
    
    /// 压缩JSON
    func compress() -> Result<String, TFYJsonError> {
        return TFYSwiftJsonKit.compress(self)
    }
    
    /// 解析为字典
    func toDictionary() -> Result<[String: Any], TFYJsonError> {
        guard let data = self.data(using: .utf8) else {
            return .failure(.invalidData)
        }
        return TFYSwiftJsonKit.dictionary(from: data)
    }
    
    /// 解析为数组
    func toArray() -> Result<[Any], TFYJsonError> {
        guard let data = self.data(using: .utf8) else {
            return .failure(.invalidData)
        }
        return TFYSwiftJsonKit.array(from: data)
    }
    
    /// 解析为指定类型的模型
    func toModel<T: Decodable>(_ type: T.Type) -> Result<T, TFYJsonError> {
        return TFYSwiftJsonKit.decode(type, from: self)
    }
    
    /// 获取JSON大小（字节）
    var jsonSize: Int {
        return self.utf8.count
    }
    
    /// 检查JSON是否为空
    var isJsonEmpty: Bool {
        guard let data = self.data(using: .utf8) else { return true }
        return data.isEmpty
    }
}

// MARK: - TFYSwiftJsonKit 用法示例
/*
// 1. 基本模型与JSON互转
struct Address: Codable {
    let city: String
    let street: String
}
struct User: Codable {
    let id: Int
    let name: String
    let address: Address
    let tags: [String]
}
let address = Address(city: "北京", street: "中关村")
let user = User(id: 1, name: "张三", address: address, tags: ["VIP", "Swift"])

// 模型转JSON字符串
let jsonStringResult = user.toJsonString()
switch jsonStringResult {
case .success(let jsonString):
    print("模型转JSON字符串: \(jsonString)")
case .failure(let error):
    print("编码失败: \(error.localizedDescription)")
}

// JSON字符串转模型
let jsonString = "{"id":1,"name":"张三","address":{"city":"北京","street":"中关村"},"tags":["VIP","Swift"]}"
let userResult = User.from(dict: TFYSwiftJsonKit.dictionary(from: jsonString.data(using: .utf8)!).value ?? [:])
switch userResult {
case .success(let user):
    print("JSON转模型: \(user)")
case .failure(let error):
    print("解码失败: \(error.localizedDescription)")
}

// 2. 嵌套模型数组转JSON
let users = [user, User(id: 2, name: "李四", address: address, tags: ["同事"])]
let usersJsonString = users.toJsonString().value ?? ""
print("模型数组转JSON字符串: \(usersJsonString)")

// 3. 字典/数组与模型互转
let dict: [String: Any] = ["id": 3, "name": "王五", "address": ["city": "上海", "street": "浦东"], "tags": ["新用户"]]
let userFromDict = User.from(dict: dict)
print("字典转模型: \(userFromDict)")

let userDict = user.toDictionary().value ?? [:]
print("模型转字典: \(userDict)")

// 4. JSON格式化、美化
let uglyJson = "{\"id\":1,\"name\":\"张三\",\"address\":{\"city\":\"北京\",\"street\":\"中关村\"},\"tags\":[\"VIP\",\"Swift\"]}"
let pretty = TFYSwiftJsonKit.prettyPrint(uglyJson)
print("格式化后的JSON:\n\(pretty.value ?? "")")

// 5. JSON Schema 验证
let schema = TFYSwiftJsonKit.objectSchema(properties: [
    "id": TFYSwiftJsonKit.integerSchema(minimum: 1),
    "name": TFYSwiftJsonKit.stringSchema(minLength: 1),
    "address": TFYSwiftJsonKit.objectSchema(properties: [
        "city": TFYSwiftJsonKit.stringSchema(),
        "street": TFYSwiftJsonKit.stringSchema()
    ], required: ["city", "street"]),
    "tags": TFYSwiftJsonKit.arraySchema(items: TFYSwiftJsonKit.stringSchema())
], required: ["id", "name", "address", "tags"])

let userDictForSchema = user.toDictionary().value ?? [:]
let isValid = TFYSwiftJsonKit.validateSchema(userDictForSchema, against: schema)
print("模型是否符合Schema: \(isValid)")

// 6. 新增功能示例

// JSON压缩
let compressed = uglyJson.compress()
print("压缩后的JSON: \(compressed.value ?? "")")

// JSON路径操作
let jsonDict: [String: Any] = [
    "user": [
        "profile": [
            "name": "张三",
            "age": 25
        ]
    ]
]
let name = jsonDict.getValue(at: "user.profile.name")
print("获取路径值: \(name ?? "nil")")

let updatedDict = jsonDict.setValue("李四", at: "user.profile.name")
print("设置路径值: \(updatedDict)")

// JSON比较和差异
let json1: [String: Any] = ["name": "张三", "age": 25, "city": "北京"]
let json2: [String: Any] = ["name": "李四", "age": 25, "country": "中国"]
let differences = json1.differences(from: json2)
print("JSON差异: \(differences)")

// 异步处理
TFYSwiftJsonKit.encodeAsync(user) { result in
    switch result {
    case .success(let data):
        print("异步编码成功: \(data.count) bytes")
    case .failure(let error):
        print("异步编码失败: \(error.localizedDescription)")
    }
}

// 深度验证
let deepJson: [String: Any] = [
    "level1": [
        "level2": [
            "level3": [
                "level4": [
                    "level5": "deep value"
                ]
            ]
        ]
    ]
]
let depthValidation = TFYSwiftJsonKit.validateDepth(deepJson, maxDepth: 3)
switch depthValidation {
case .success:
    print("深度验证通过")
case .failure(let error):
    print("深度验证失败: \(error.localizedDescription)")
}

// 缓存管理
let cacheStats = TFYSwiftJsonKit.getCacheStats()
print("缓存统计: \(cacheStats)")

// 字符串扩展使用
let jsonString2 = "{\"name\":\"张三\",\"age\":25}"
if jsonString2.isValidJson {
    let dict = jsonString2.toDictionary()
    print("字符串转字典: \(dict)")
}

// 7. 新增高级功能示例

// JSON转换器
let converter = TFYSwiftJsonKit.StringToDictionaryConverter()
let conversionResult = converter.convert(jsonString2)
print("转换器结果: \(conversionResult)")

// JSON补丁操作
let patches = [
    TFYSwiftJsonKit.TFYJsonPatch(op: .add, path: "email", value: "zhangsan@example.com"),
    TFYSwiftJsonKit.TFYJsonPatch(op: .replace, path: "age", value: 26)
]
let patchedJson = TFYSwiftJsonKit.applyPatches(patches, to: userDict)
print("补丁后的JSON: \(patchedJson)")

// 性能监控
let (encodeResult, encodeStats) = TFYSwiftJsonKit.encodeWithPerformance(user)
print("编码性能: \(encodeStats.encodingTime)s, 大小: \(encodeStats.dataSize) bytes")

let (decodeResult, decodeStats) = TFYSwiftJsonKit.decodeWithPerformance(User.self, from: encodeResult.success ?? Data())
print("解码性能: \(decodeStats.decodingTime)s")

// 实用工具方法
let randomJson = TFYSwiftJsonKit.generateRandomJson(depth: 2, maxKeys: 3)
print("随机JSON: \(randomJson)")

let structure = ["name": "string", "age": "number", "isActive": "boolean"]
let isValidStructure = TFYSwiftJsonKit.validateStructure(userDict, against: structure)
print("结构验证: \(isValidStructure)")

let jsonSize = TFYSwiftJsonKit.getJsonSize(userDict)
print("JSON大小: \(jsonSize) bytes")

let allKeys = TFYSwiftJsonKit.getAllKeys(userDict)
print("所有键: \(allKeys)")

// 8. 线程安全测试
DispatchQueue.concurrentPerform(iterations: 10) { index in
    let testJson = ["id": index, "name": "user_\(index)"]
    let result = testJson.toJsonString()
    print("并发测试 \(index): \(result.isSuccess)")
}

// 9. 新增工具方法示例
let allValues = TFYSwiftJsonKit.getAllValues(userDict)
print("所有值: \(allValues)")

let containsName = TFYSwiftJsonKit.containsKey("name", in: userDict)
print("包含name键: \(containsName)")

let jsonDepth = TFYSwiftJsonKit.getDepth(userDict)
print("JSON深度: \(jsonDepth)")

// 字符串扩展新功能
let jsonString3 = "{\"name\":\"张三\",\"age\":25}"
let modelResult = jsonString3.toModel(User.self)
print("字符串转模型: \(modelResult)")

print("JSON大小: \(jsonString3.jsonSize) bytes")
print("JSON是否为空: \(jsonString3.isJsonEmpty)")

// 配置管理
let customConfig = TFYJsonConfig()
customConfig.maxDepth = 50
customConfig.enableCache = false
TFYSwiftJsonKit.updateDefaultConfig(customConfig)
print("配置已更新")

// 重置配置
TFYSwiftJsonKit.resetDefaultConfig()
print("配置已重置")
*/
