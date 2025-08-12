//
//  Array+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit

public extension Array {
    
    // MARK: 1.1、安全的取某个索引的值
    /// 安全的取某个索引的值
    /// - Parameter index: 索引
    /// - Returns: 对应元素或nil（越界安全）
    func indexValue(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    // MARK: 1.2、数组添加数组
    /// 数组新增元素(可转入一个数组)
    /// - Parameter elements: 要添加的元素数组
    mutating func appends(_ elements: [Element]) {
        guard !elements.isEmpty else { return }
        self.append(contentsOf: elements)
    }
    
    // MARK: 1.3、数组 -> JSON字符串
    /// 数组转换为JSONString
    /// - Returns: JSON字符串，失败返回nil
    func toJSON() -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            TFYUtils.Logger.log("⚠️ Array: 不是有效的JSON对象")
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            TFYUtils.Logger.log("⚠️ Array: JSON序列化失败 \(error)")
            return nil
        }
    }
    
    // MARK: 1.4、分隔数组
    /// 分隔数组
    /// - Parameter condition: 分隔条件
    /// - Returns: 分隔后的二维数组
    func split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        guard !self.isEmpty else { return [] }
        var result: [[Element]] = [[self[0]]]
        for (previous, current) in zip(self, self.dropFirst()) {
            if condition(previous, current) {
                result.append([current])
            } else {
                result[result.endIndex - 1].append(current)
            }
        }
        return result
    }
}

// MARK: - 二、数组 有关索引 的扩展方法
public extension Array where Element : Equatable {
    
    // MARK: 2.1、获取数组中的指定元素的索引值
    /// 获取数组中的指定元素的索引值
    /// - Parameter item: 元素
    /// - Returns: 索引值数组
    func indexes(_ item: Element) -> [Int] {
        guard self.count > 0 else { return [] }
        var indexes = [Int]()
        for index in 0..<count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }
    
    // MARK: 2.2、获取元素首次出现的位置
    /// 获取元素首次出现的位置
    /// - Parameter item: 元素
    /// - Returns: 索引值
    func firstIndex(_ item: Element) -> Int? {
        for (index, value) in self.enumerated() where value == item {
            return index
        }
        return nil
    }
    
    // MARK: 2.3、获取元素最后出现的位置
    /// 获取元素最后出现的位置
    /// - Parameter item: 元素
    /// - Returns: 索引值
    func lastIndex(_ item: Element) -> Int? {
        let indexs = indexes(item)
        return indexs.last
    }
}

// MARK: - 三、遵守 Equatable 协议的数组 (增删改查) 扩展
public extension Array where Element : Equatable {
    
    // MARK: 3.1、删除数组的中的元素(可删除第一个出现的或者删除全部出现的)
    /// 删除数组的中的元素(可删除第一个出现的或者删除全部出现的)
    /// - Parameters:
    ///   - element: 要删除的元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func remove(_ element: Element, isRepeat: Bool = true) -> Array {
        guard self.count > 0 else { return self }
        var removeIndexs: [Int] = []
        for i in 0 ..< count {
            if self[i] == element {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        // 倒序删除
        for index in removeIndexs.reversed() {
            if index < self.count {
                self.remove(at: index)
            }
        }
        return self
    }
    
    // MARK: 3.2、从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素
    /// 从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素
    /// - Parameters:
    ///   - elements: 被删除的数组元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func removeArray(_ elements: [Element], isRepeat: Bool = true) -> Array {
        guard !elements.isEmpty else { return self }
        for element in elements {
            if self.contains(element) {
                self.remove(element, isRepeat: isRepeat)
            }
        }
        return self
    }
}

// MARK: - 四、遵守 NSObjectProtocol 协议对应数组的扩展方法
public extension Array where Element : NSObjectProtocol {
    
    // MARK: 4.1、删除数组中遵守NSObjectProtocol协议的元素，是否删除重复的元素
    /// 删除数组中遵守NSObjectProtocol协议的元素
    /// - Parameters:
    ///   - object: 元素
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func remove(object: NSObjectProtocol, isRepeat: Bool = true) -> Array {
        guard self.count > 0 else { return self }
        var removeIndexs: [Int] = []
        for i in 0..<count {
            if self[i].isEqual(object) {
                removeIndexs.append(i)
                if !isRepeat {
                    break
                }
            }
        }
        for index in removeIndexs.reversed() {
            if index < self.count {
                self.remove(at: index)
            }
        }
        return self
    }
    
    // MARK: 4.2、删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除
    /// 删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除
    /// - Parameters:
    ///   - objects: 遵守NSObjectProtocol的数组
    ///   - isRepeat: 是否删除重复的元素
    @discardableResult
    mutating func removeArray(objects: [NSObjectProtocol], isRepeat: Bool = true) -> Array {
        guard !objects.isEmpty else { return self }
        for object in objects {
            if self.contains(where: {$0.isEqual(object)} ){
                self.remove(object: object, isRepeat: isRepeat)
            }
        }
        return self
    }
}

// MARK: - 五、针对数组元素是 String 的扩展
public extension Array where Self.Element == String {
    
    // MARK: 5.1、数组转字符转（数组的元素是 字符串），如：["1", "2", "3"] 连接器为 - ，那么转化后为 "1-2-3"
    /// 数组转字符转（数组的元素是 字符串），如：["1", "2", "3"] 连接器为 - ，那么转化后为 "1-2-3"
    /// - Parameter separator: 连接器
    /// - Returns: 转化后的字符串
    func toStrinig(separator: String = "") -> String {
        return self.joined(separator: separator)
    }
}

// MARK: - 六、数组的通用扩展方法
public extension Array {
    
    // MARK: 6.8、数组是否包含重复元素
    /// 数组是否包含重复元素
    /// - Returns: 如果包含重复元素返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var hasDuplicates: Bool {
        // 对于非Hashable元素，使用简单的循环比较
        for i in 0..<count {
            for j in (i+1)..<count {
                if self[i] as AnyObject === self[j] as AnyObject {
                    return true
                }
            }
        }
        return false
    }
}

// MARK: - 七、数组的Hashable元素扩展
public extension Array where Element: Hashable {
    
    // MARK: 6.1、数组去重
    /// 数组去重
    /// - Returns: 去重后的数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func unique() -> [Element] where Element: Hashable {
        return Array(Set(self))
    }
    
    // MARK: 6.2、数组去重（保持顺序）
    /// 数组去重（保持顺序）
    /// - Returns: 去重后的数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func uniqueOrdered() -> [Element] where Element: Equatable {
        return reduce([]) { result, element in
            result.contains(element) ? result : result + [element]
        }
    }
    
    // MARK: 6.3、数组分组
    /// 数组分组
    /// - Parameter keyPath: 分组键路径
    /// - Returns: 分组后的字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func group<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        return Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
    }
    

    
    // MARK: 6.5、数组过滤并转换
    /// 数组过滤并转换
    /// - Parameters:
    ///   - isIncluded: 过滤条件
    ///   - transform: 转换函数
    /// - Returns: 过滤并转换后的数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func filterMap<T>(_ isIncluded: (Element) throws -> Bool, transform: (Element) throws -> T) rethrows -> [T] {
        return try self.filter(isIncluded).map(transform)
    }
    
    // MARK: 6.9、数组是否为空或nil
    /// 数组是否为空或nil
    /// - Returns: 如果数组为空返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isEmptyOrNil: Bool {
        return self.isEmpty
    }
    
    // MARK: 6.10、数组的第一个元素
    /// 数组的第一个元素
    /// - Returns: 第一个元素，数组为空返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var tfy_first: Element? {
        return self.first
    }
    
    // MARK: 6.11、数组的最后一个元素
    /// 数组的最后一个元素
    /// - Returns: 最后一个元素，数组为空返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var tfy_last: Element? {
        return self.last
    }
    
    // MARK: 6.12、数组的中间元素
    /// 数组的中间元素
    /// - Returns: 中间元素，数组为空返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var tfy_middle: Element? {
        guard !isEmpty else { return nil }
        let middleIndex = count / 2
        return self[middleIndex]
    }
    
    // MARK: 6.13、数组的前N个元素
    /// 数组的前N个元素
    /// - Parameter n: 元素数量
    /// - Returns: 前N个元素的数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func tfy_prefix(_ n: Int) -> [Element] {
        return Array((self as [Element]).prefix(n))
    }
    
    // MARK: 6.14、数组的后N个元素
    /// 数组的后N个元素
    /// - Parameter n: 元素数量
    /// - Returns: 后N个元素的数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func tfy_suffix(_ n: Int) -> [Element] {
        return Array((self as [Element]).suffix(n))
    }
    
    // MARK: 6.15、数组的统计信息
    /// 数组的统计信息
    /// - Returns: 包含统计信息的字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var statistics: [String: Any] {
        var result: [String: Any] = [
            "count": count,
            "isEmpty": isEmpty,
            "hasDuplicates": hasDuplicates
        ]
        
        if tfy_first != nil {
            result["firstIndex"] = 0
        }
        
        if tfy_last != nil {
            result["lastIndex"] = count - 1
        }
        
        return result
    }
}
