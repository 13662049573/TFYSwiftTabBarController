//
//  DateFormatter+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit

public extension TFY where Base: DateFormatter {
    
    // MARK: 1.1、设置日期格式
    /// 设置日期格式
    /// - Parameter dateFormat: 日期格式字符串
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func dateFormat(_ dateFormat: String) -> Self {
        base.dateFormat = dateFormat
        return self
    }
    
    // MARK: 1.2、设置日期样式
    /// 设置日期样式
    /// - Parameter dateStyle: 日期样式
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func dateStyle(_ dateStyle: DateFormatter.Style) -> Self {
        base.dateStyle = dateStyle
        return self
    }
    
    // MARK: 1.3、设置时间样式
    /// 设置时间样式
    /// - Parameter timeStyle: 时间样式
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func timeStyle(_ timeStyle: DateFormatter.Style) -> Self {
        base.timeStyle = timeStyle
        return self
    }
    
    // MARK: 1.4、设置地区
    /// 设置地区
    /// - Parameter locale: 地区设置
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func locale(_ locale: Locale) -> Self {
        base.locale = locale
        return self
    }
    
    // MARK: 1.5、设置是否生成日历日期
    /// 设置是否生成日历日期
    /// - Parameter generatesCalendarDates: 是否生成
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func generatesCalendarDates(_ generatesCalendarDates: Bool) -> Self {
        base.generatesCalendarDates = generatesCalendarDates
        return self
    }
    
    // MARK: 1.6、设置格式化行为
    /// 设置格式化行为
    /// - Parameter formatterBehavior: 格式化行为
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func formatterBehavior(_ formatterBehavior: DateFormatter.Behavior) -> Self {
        base.formatterBehavior = formatterBehavior
        return self
    }
    
    // MARK: 1.7、设置时区
    /// 设置时区
    /// - Parameter timeZone: 时区
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> Self {
        base.timeZone = timeZone
        return self
    }
    
    // MARK: 1.8、设置日历
    /// 设置日历
    /// - Parameter calendar: 日历对象
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func calendar(_ calendar: Calendar) -> Self {
        base.calendar = calendar
        return self
    }
    
    // MARK: 1.9、设置AM/PM符号
    /// 设置AM/PM符号
    /// - Parameters:
    ///   - amSymbol: AM符号
    ///   - pmSymbol: PM符号
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func amPmSymbols(am: String, pm: String) -> Self {
        base.amSymbol = am
        base.pmSymbol = pm
        return self
    }
    
    // MARK: 1.10、设置月份名称
    /// 设置月份名称
    /// - Parameter monthSymbols: 月份名称数组
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func monthSymbols(_ monthSymbols: [String]) -> Self {
        base.monthSymbols = monthSymbols
        return self
    }
    
    // MARK: 1.11、设置短月份名称
    /// 设置短月份名称
    /// - Parameter shortMonthSymbols: 短月份名称数组
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func shortMonthSymbols(_ shortMonthSymbols: [String]) -> Self {
        base.shortMonthSymbols = shortMonthSymbols
        return self
    }
    
    // MARK: 1.12、设置星期名称
    /// 设置星期名称
    /// - Parameter weekdaySymbols: 星期名称数组
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func weekdaySymbols(_ weekdaySymbols: [String]) -> Self {
        base.weekdaySymbols = weekdaySymbols
        return self
    }
    
    // MARK: 1.13、设置短星期名称
    /// 设置短星期名称
    /// - Parameter shortWeekdaySymbols: 短星期名称数组
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func shortWeekdaySymbols(_ shortWeekdaySymbols: [String]) -> Self {
        base.shortWeekdaySymbols = shortWeekdaySymbols
        return self
    }
    
    // MARK: 1.14、设置是否使用相对日期格式
    /// 设置是否使用相对日期格式
    /// - Parameter doesRelativeDateFormatting: 是否使用相对格式
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func doesRelativeDateFormatting(_ doesRelativeDateFormatting: Bool) -> Self {
        base.doesRelativeDateFormatting = doesRelativeDateFormatting
        return self
    }
}

// MARK: - 二、DateFormatter的便利方法
public extension DateFormatter {
    
    // MARK: 2.1、创建标准日期格式器
    /// 创建标准日期格式器
    /// - Parameter format: 日期格式
    /// - Returns: 配置好的DateFormatter
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func standard(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // MARK: 2.2、创建ISO8601格式器
    /// 创建ISO8601格式器
    /// - Returns: ISO8601格式的DateFormatter
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func iso8601() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    // MARK: 2.3、创建中文日期格式器
    /// 创建中文日期格式器
    /// - Parameter format: 日期格式
    /// - Returns: 中文格式的DateFormatter
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func chinese(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // MARK: 2.4、创建相对日期格式器
    /// 创建相对日期格式器
    /// - Returns: 相对日期格式的DateFormatter
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func relative() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    // MARK: 2.5、安全格式化日期
    /// 安全格式化日期
    /// - Parameter date: 要格式化的日期
    /// - Returns: 格式化后的字符串，失败返回空字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func safeString(from date: Date?) -> String {
        guard let date = date else { return "" }
        return self.string(from: date)
    }
    
    // MARK: 2.6、安全解析日期字符串
    /// 安全解析日期字符串
    /// - Parameter string: 日期字符串
    /// - Returns: 解析后的日期，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func safeDate(from string: String?) -> Date? {
        guard let string = string, !string.isEmpty else { return nil }
        return self.date(from: string)
    }
    
    // MARK: 2.7、获取当前时间的格式化字符串
    /// 获取当前时间的格式化字符串
    /// - Returns: 当前时间的格式化字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func currentDateString() -> String {
        return self.string(from: Date())
    }
    
    // MARK: 2.8、格式化时间间隔
    /// 格式化时间间隔
    /// - Parameter timeInterval: 时间间隔（秒）
    /// - Returns: 格式化后的时间字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func string(fromTimeInterval timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return self.string(from: date)
    }
    
    // MARK: 2.9、格式化时间戳
    /// 格式化时间戳
    /// - Parameter timestamp: 时间戳（毫秒）
    /// - Returns: 格式化后的时间字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func string(fromTimestamp timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000.0)
        return self.string(from: date)
    }
    
    // MARK: 2.10、获取日期组件
    /// 获取日期组件
    /// - Parameter date: 日期
    /// - Returns: 日期组件字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func dateComponents(from date: Date) -> [String: Int] {
        let calendar = self.calendar ?? Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: date)
        
        return [
            "year": components.year ?? 0,
            "month": components.month ?? 0,
            "day": components.day ?? 0,
            "hour": components.hour ?? 0,
            "minute": components.minute ?? 0,
            "second": components.second ?? 0,
            "weekday": components.weekday ?? 0
        ]
    }
}

// MARK: - 三、预设的日期格式
public extension DateFormatter {
    
    // MARK: 3.1、常用日期格式
    /// 常用日期格式枚举
    enum CommonFormat {
        case fullDateTime
        case dateOnly
        case timeOnly
        case shortDate
        case shortTime
        case monthDay
        case yearMonth
        case iso8601
        case chinese
        case relative
    }
    
    // MARK: 3.2、创建预设格式的DateFormatter
    /// 创建预设格式的DateFormatter
    /// - Parameter format: 预设格式
    /// - Returns: 配置好的DateFormatter
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func preset(_ format: CommonFormat) -> DateFormatter {
        switch format {
        case .fullDateTime:
            return DateFormatter.standard(format: "yyyy-MM-dd HH:mm:ss")
        case .dateOnly:
            return DateFormatter.standard(format: "yyyy-MM-dd")
        case .timeOnly:
            return DateFormatter.standard(format: "HH:mm:ss")
        case .shortDate:
            return DateFormatter.standard(format: "MM-dd")
        case .shortTime:
            return DateFormatter.standard(format: "HH:mm")
        case .monthDay:
            return DateFormatter.standard(format: "MM月dd日")
        case .yearMonth:
            return DateFormatter.standard(format: "yyyy年MM月")
        case .iso8601:
            return DateFormatter.iso8601()
        case .chinese:
            return DateFormatter.chinese(format: "yyyy年MM月dd日 HH:mm:ss")
        case .relative:
            return DateFormatter.relative()
        }
    }
}
