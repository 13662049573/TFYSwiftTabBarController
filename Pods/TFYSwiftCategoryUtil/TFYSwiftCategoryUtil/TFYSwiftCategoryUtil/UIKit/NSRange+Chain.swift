//
//  NSRange+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation

extension NSRange: TFYCompatible {}

// MARK: - 一、基本的扩展
public extension TFY where Base == NSRange {
    
    // MARK: 1.1、NSRange转换成Range的方法
    /// NSRange转换成Range的方法
    /// - Parameter string: 父字符串
    /// - Returns: Range<String.Index>，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toRange(string: String) -> Range<String.Index>? {
        guard
            let from16 = string.utf16.index(string.utf16.startIndex, offsetBy: self.base.location, limitedBy: string.utf16.endIndex),
            let to16 = string.utf16.index(from16, offsetBy: self.base.length, limitedBy: string.utf16.endIndex),
            let from = String.Index(from16, within: string),
            let to = String.Index(to16, within: string)
            else { return nil }
          return from ..< to
    }
    
    // MARK: 1.2、检查范围是否有效
    /// 检查范围是否有效
    /// - Parameter stringLength: 字符串长度
    /// - Returns: 是否有效
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func isValid(in stringLength: Int) -> Bool {
        guard stringLength >= 0,
              self.base.location >= 0,
              self.base.length >= 0 else {
            return false
        }
        guard self.base.location <= stringLength - self.base.length else {
            return false
        }
        return true
    }
    
    // MARK: 1.3、获取范围的结束位置
    /// 获取范围的结束位置
    /// - Returns: 结束位置
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var endLocation: Int {
        guard self.base.location >= 0, self.base.length >= 0 else { return self.base.location }
        return self.base.location.addingReportingOverflow(self.base.length).overflow ? Int.max : self.base.location + self.base.length
    }
    
    // MARK: 1.4、检查范围是否为空
    /// 检查范围是否为空
    /// - Returns: 是否为空
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isEmpty: Bool {
        return self.base.length == 0
    }
    
    // MARK: 1.5、检查两个范围是否重叠
    /// 检查两个范围是否重叠
    /// - Parameter other: 另一个范围
    /// - Returns: 是否重叠
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func overlaps(with other: NSRange) -> Bool {
        guard self.base.location >= 0, self.base.length >= 0, other.location >= 0, other.length >= 0 else {
            return false
        }
        let selfEnd = self.endLocation
        let otherEnd = other.tfy.endLocation
        return self.base.location < otherEnd && other.location < selfEnd
    }
    
    // MARK: 1.6、获取两个范围的交集
    /// 获取两个范围的交集
    /// - Parameter other: 另一个范围
    /// - Returns: 交集范围，如果没有交集返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func intersection(with other: NSRange) -> NSRange? {
        guard self.overlaps(with: other) else { return nil }
        
        let startLocation = max(self.base.location, other.location)
        let selfEnd = self.base.location + self.base.length
        let otherEnd = other.location + other.length
        let endLocation = min(selfEnd, otherEnd)
        return NSRange(location: startLocation, length: endLocation - startLocation)
    }
    
    // MARK: 1.7、获取两个范围的并集
    /// 获取两个范围的并集
    /// - Parameter other: 另一个范围
    /// - Returns: 并集范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func union(with other: NSRange) -> NSRange {
        let startLocation = min(self.base.location, other.location)
        let selfEnd = self.endLocation
        let otherEnd = other.tfy.endLocation
        let endLocation = max(selfEnd, otherEnd)
        return NSRange(location: startLocation, length: endLocation - startLocation)
    }
    
    // MARK: 1.8、检查范围是否包含指定位置
    /// 检查范围是否包含指定位置
    /// - Parameter location: 位置
    /// - Returns: 是否包含
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func contains(_ location: Int) -> Bool {
        guard self.base.location >= 0, self.base.length >= 0 else { return false }
        let selfEnd = self.endLocation
        return location >= self.base.location && location < selfEnd
    }
    
    // MARK: 1.9、检查范围是否完全包含另一个范围
    /// 检查范围是否完全包含另一个范围
    /// - Parameter other: 另一个范围
    /// - Returns: 是否完全包含
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func contains(_ other: NSRange) -> Bool {
        guard self.base.location >= 0, self.base.length >= 0, other.location >= 0, other.length >= 0 else {
            return false
        }
        let selfEnd = self.endLocation
        let otherEnd = other.tfy.endLocation
        return self.base.location <= other.location && selfEnd >= otherEnd
    }
    
    // MARK: 1.10、扩展范围
    /// 扩展范围
    /// - Parameters:
    ///   - by: 扩展的长度
    ///   - stringLength: 字符串长度
    /// - Returns: 扩展后的范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func expanded(by length: Int, in stringLength: Int) -> NSRange {
        let expansion = max(0, length)
        let safeStringLength = max(0, stringLength)
        let clampedRange = clamped(to: safeStringLength)
        let newLocation = max(0, clampedRange.location - expansion)
        let desiredEnd = min(safeStringLength, clampedRange.tfy.endLocation + expansion)
        let newLength = max(0, desiredEnd - newLocation)
        return NSRange(location: newLocation, length: newLength)
    }
    
    // MARK: 1.11、缩小范围
    /// 缩小范围
    /// - Parameter by: 缩小的长度
    /// - Returns: 缩小后的范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func contracted(by length: Int) -> NSRange {
        let contraction = max(0, length)
        let appliedContraction = min(contraction, self.base.length / 2)
        let newLocation = self.base.location + appliedContraction
        let newLength = max(0, self.base.length - 2 * appliedContraction)
        return NSRange(location: newLocation, length: newLength)
    }
    
    // MARK: 1.12、移动范围
    /// 移动范围
    /// - Parameter by: 移动的距离
    /// - Returns: 移动后的范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func moved(by offset: Int) -> NSRange {
        return NSRange(location: self.base.location + offset, length: self.base.length)
    }

    // MARK: 1.12.1、安全移动范围
    /// 安全移动范围，移动后会被限制在指定长度内
    /// - Parameters:
    ///   - offset: 移动距离
    ///   - stringLength: 最大长度
    /// - Returns: 移动后的范围
    func safelyMoved(by offset: Int, in stringLength: Int) -> NSRange {
        let clampedRange = clamped(to: stringLength)
        let maxLocation = max(0, max(0, stringLength) - clampedRange.length)
        let newLocation = min(max(0, clampedRange.location + offset), maxLocation)
        return NSRange(location: newLocation, length: clampedRange.length)
    }
    
    // MARK: 1.13、调整范围长度
    /// 调整范围长度
    /// - Parameter to: 新的长度
    /// - Returns: 调整后的范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func resized(to length: Int) -> NSRange {
        return NSRange(location: self.base.location, length: max(0, length))
    }

    // MARK: 1.13.1、限制范围到指定长度内
    /// 限制范围到指定长度内
    /// - Parameter stringLength: 最大长度
    /// - Returns: 限制后的范围
    func clamped(to stringLength: Int) -> NSRange {
        let safeStringLength = max(0, stringLength)
        let safeLocation = min(max(0, self.base.location), safeStringLength)
        let safeLength = min(max(0, self.base.length), safeStringLength - safeLocation)
        return NSRange(location: safeLocation, length: safeLength)
    }
    
    // MARK: 1.14、获取范围的描述
    /// 获取范围的描述
    /// - Returns: 范围描述字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var description: String {
        return "NSRange(location: \(self.base.location), length: \(self.base.length))"
    }
}

// MARK: - 二、NSRange的便利方法
public extension NSRange {
    
    // MARK: 2.1、创建空范围
    /// 创建空范围
    /// - Parameter location: 位置
    /// - Returns: 空范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func empty(at location: Int = 0) -> NSRange {
        return NSRange(location: max(0, location), length: 0)
    }
    
    // MARK: 2.2、创建全范围
    /// 创建全范围
    /// - Parameter length: 总长度
    /// - Returns: 全范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func full(length: Int) -> NSRange {
        return NSRange(location: 0, length: max(0, length))
    }
    
    // MARK: 2.3、从Range创建NSRange
    /// 从Range创建NSRange
    /// - Parameters:
    ///   - range: Range对象
    ///   - string: 字符串
    /// - Returns: NSRange对象，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func from(_ range: Range<String.Index>, in string: String) -> NSRange? {
        guard let lowerBound = range.lowerBound.samePosition(in: string.utf16),
              let upperBound = range.upperBound.samePosition(in: string.utf16) else {
            return nil
        }
        
        let location = string.utf16.distance(from: string.utf16.startIndex, to: lowerBound)
        let length = string.utf16.distance(from: lowerBound, to: upperBound)
        return NSRange(location: location, length: length)
    }
    
    // MARK: 2.4、检查范围是否在有效范围内
    /// 检查范围是否在有效范围内
    /// - Parameters:
    ///   - minLocation: 最小位置
    ///   - maxLocation: 最大位置
    /// - Returns: 是否在有效范围内
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func isWithin(minLocation: Int, maxLocation: Int) -> Bool {
        let selfEnd = self.location + self.length
        return self.location >= minLocation && selfEnd <= maxLocation
    }
    
    // MARK: 2.5、获取范围的中间位置
    /// 获取范围的中间位置
    /// - Returns: 中间位置
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var middleLocation: Int {
        return self.location + self.length / 2
    }
    
    // MARK: 2.6、分割范围
    /// 分割范围
    /// - Parameter at: 分割位置
    /// - Returns: 分割后的两个范围，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func split(at location: Int) -> (NSRange, NSRange)? {
        guard self.contains(location) else { return nil }
        
        let firstRange = NSRange(location: self.location, length: location - self.location)
        let selfEnd = self.location + self.length
        let secondRange = NSRange(location: location, length: selfEnd - location)
        return (firstRange, secondRange)
    }
    
    // MARK: 2.7、获取范围的子范围
    /// 获取范围的子范围
    /// - Parameters:
    ///   - offset: 偏移量
    ///   - length: 长度
    /// - Returns: 子范围，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func subrange(offset: Int, length: Int) -> NSRange? {
        guard offset >= 0, length >= 0 else { return nil }
        let newLocation = self.location + offset
        let selfEnd = self.location + self.length
        guard newLocation >= self.location && newLocation + length <= selfEnd else {
            return nil
        }
        return NSRange(location: newLocation, length: length)
    }
    
    // MARK: 2.8、比较两个范围
    /// 比较两个范围
    /// - Parameter other: 另一个范围
    /// - Returns: 比较结果
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func compare(with other: NSRange) -> ComparisonResult {
        if self.location < other.location {
            return .orderedAscending
        } else if self.location > other.location {
            return .orderedDescending
        } else {
            if self.length < other.length {
                return .orderedAscending
            } else if self.length > other.length {
                return .orderedDescending
            } else {
                return .orderedSame
            }
        }
    }
    
    // MARK: 2.9、获取范围的边界
    /// 获取范围的边界
    /// - Returns: 边界元组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var bounds: (start: Int, end: Int) {
        let selfEnd = self.location + self.length
        return (start: self.location, end: selfEnd)
    }
    
    // MARK: 2.10、检查范围是否相邻
    /// 检查范围是否相邻
    /// - Parameter other: 另一个范围
    /// - Returns: 是否相邻
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func isAdjacent(to other: NSRange) -> Bool {
        let selfEnd = self.location + self.length
        let otherEnd = other.location + other.length
        return selfEnd == other.location || otherEnd == self.location
    }
}
