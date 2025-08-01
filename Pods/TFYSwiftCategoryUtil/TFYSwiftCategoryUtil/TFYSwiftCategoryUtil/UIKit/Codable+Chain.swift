//
//  Codable+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/19.
//

import Foundation
import UIKit

public protocol TFYCodable: Codable {
    /// 转换为字典
    func toDict() -> Dictionary<String, Any>?
    /// 转换为Data
    func toData() -> Data?
    /// 转换为JSON字符串
    func toString() -> String?
}

public extension TFYCodable {
    /// 转换为Data
    /// - Returns: 编码后的Data，失败返回nil
    func toData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            TFYUtils.Logger.log("TFYCodable: 编码为Data失败 - \(error.localizedDescription)")
            return nil
        }
    }
    /// 转换为字典
    /// - Returns: 字典，失败返回nil
    func toDict() -> Dictionary<String, Any>? {
        guard let data = toData() else {
            TFYUtils.Logger.log("TFYCodable: model to data error")
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } catch {
            TFYUtils.Logger.log("TFYCodable: Data转字典失败 - \(error.localizedDescription)")
            return nil
        }
    }
    /// 转换为JSON字符串
    /// - Returns: JSON字符串，失败返回nil
    func toString() -> String? {
        guard let data = toData() else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// 转换为格式化的JSON字符串
    /// - Returns: 格式化的JSON字符串，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toPrettyString() -> String? {
        guard let data = toData() else { return nil }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8)
        } catch {
            TFYUtils.Logger.log("TFYCodable: 格式化JSON失败 - \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 深拷贝对象
    /// - Returns: 深拷贝的对象，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func deepCopy() -> Self? {
        guard let data = toData() else { return nil }
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            TFYUtils.Logger.log("TFYCodable: 深拷贝失败 - \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 验证对象是否有效
    /// - Returns: 如果对象可以正确编码和解码则返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isValid: Bool {
        guard let data = toData() else { return false }
        do {
            _ = try JSONDecoder().decode(Self.self, from: data)
            return true
        } catch {
            return false
        }
    }
    
    /// 比较两个对象是否相等
    /// - Parameter other: 要比较的对象
    /// - Returns: 是否相等
    func isEqual(to other: Self) -> Bool {
        guard let data1 = toData(),
              let data2 = other.toData() else { return false }
        return data1 == data2
    }
    
    /// 获取对象的哈希值
    var hashValue: Int {
        return toData()?.hashValue ?? 0
    }
    
    /// 创建对象的浅拷贝
    /// - Returns: 浅拷贝的对象
    func shallowCopy() -> Self {
        return self
    }
    
    /// 获取对象的JSON Schema
    /// - Returns: 对象的Schema定义
    func getSchema() -> [String: Any] {
        // 这里可以实现动态Schema生成
        // 目前返回基础结构
        return [
            "type": "object",
            "properties": [:],
            "required": []
        ]
    }
    
    /// 验证对象是否符合指定Schema
    /// - Parameter schema: Schema定义
    /// - Returns: 是否符合Schema
    func validate(against schema: [String: Any]) -> Bool {
        guard let dict = toDict() else { return false }
        return TFYSwiftJsonKit.validateSchema(dict as Any, against: schema)
    }
    
    /// 获取对象的变更记录
    /// - Parameter original: 原始对象
    /// - Returns: 变更记录
    func getChanges(from original: Self) -> [String: Any] {
        guard let currentDict = toDict(),
              let originalDict = original.toDict() else { return [:] }
        
        var changes: [String: Any] = [:]
        
        for (key, currentValue) in currentDict {
            if let originalValue = originalDict[key] {
                if !isEqual(currentValue, originalValue) {
                    changes[key] = [
                        "old": originalValue,
                        "new": currentValue
                    ]
                }
            } else {
                changes[key] = [
                    "old": NSNull(),
                    "new": currentValue
                ]
            }
        }
        
        // 检查删除的字段
        for (key, originalValue) in originalDict {
            if currentDict[key] == nil {
                changes[key] = [
                    "old": originalValue,
                    "new": NSNull()
                ]
            }
        }
        
        return changes
    }
    
    /// 比较两个值是否相等
    private func isEqual(_ lhs: Any, _ rhs: Any) -> Bool {
        if let lhs = lhs as? NSNumber, let rhs = rhs as? NSNumber {
            return lhs.isEqual(rhs)
        }
        if let lhs = lhs as? String, let rhs = rhs as? String {
            return lhs == rhs
        }
        if let lhs = lhs as? Bool, let rhs = rhs as? Bool {
            return lhs == rhs
        }
        if let lhs = lhs as? [Any], let rhs = rhs as? [Any] {
            return lhs.count == rhs.count && zip(lhs, rhs).allSatisfy { isEqual($0, $1) }
        }
        if let lhs = lhs as? [String: Any], let rhs = rhs as? [String: Any] {
            return lhs.count == rhs.count && lhs.allSatisfy { key, value in
                rhs[key].map { isEqual(value, $0) } ?? false
            }
        }
        return false
    }
}

