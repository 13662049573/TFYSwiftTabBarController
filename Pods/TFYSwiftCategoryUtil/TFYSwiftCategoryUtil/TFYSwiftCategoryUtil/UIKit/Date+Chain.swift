//
//  Date+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//  用途：Date 链式编程扩展，支持时间戳转换、日期格式化、时间计算等功能。
//

import Foundation

extension Date: TFYCompatible {}

/// 时间戳的类型
public enum TFYTimestampType: Int, CaseIterable {
    /// 秒
    case second
    /// 毫秒
    case millisecond
}

// MARK: - 一、Date 基本的扩展
public extension TFY where Base == Date {
    // MARK: 1.1、获取当前 秒级 时间戳 - 10 位
    /// 获取当前 秒级 时间戳 - 10 位
    static var secondStamp: String {
        let timeInterval: TimeInterval = Base().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }
    
    // MARK: 1.2、获取当前 毫秒级 时间戳 - 13 位
    /// 获取当前 毫秒级 时间戳 - 13 位
    static var milliStamp: String {
        let timeInterval: TimeInterval = Base().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }
    
    // MARK: 1.3、获取当前的时间 Date
    /// 获取当前的时间 Date
    static var currentDate: Date {
        return Base()
    }
    
    // MARK: 1.4、从 Date 获取年份
    /// 从 Date 获取年份
    var year: Int {
        return Calendar.current.component(.year, from: base)
    }
    
    // MARK: 1.5、从 Date 获取月份
    /// 从 Date 获取月份
    var month: Int {
        return Calendar.current.component(.month, from: base)
    }
    
    // MARK: 1.6、从 Date 获取 日
    /// 从 Date 获取 日
    var day: Int {
        return Calendar.current.component(.day, from: base)
    }
    
    // MARK: 1.7、从 Date 获取 小时
    /// 从 Date 获取 小时
    var hour: Int {
        return Calendar.current.component(.hour, from: base)
    }
    
    // MARK: 1.8、从 Date 获取 分钟
    /// 从 Date 获取 分钟
    var minute: Int {
        return Calendar.current.component(.minute, from: base)
    }
    
    // MARK: 1.9、从 Date 获取 秒
    /// 从 Date 获取 秒
    var second: Int {
        return Calendar.current.component(.second, from: base)
    }
    
    // MARK: 1.10、从 Date 获取 纳秒
    /// 从 Date 获取 纳秒
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: base)
    }
    
    // MARK: 1.11、从日期获取 星期(英文)
    /// 从日期获取 星期(英文)
    var weekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: base)
    }
    
    // MARK: 1.12、从日期获取 星期(中文)
    /// 从日期获取 星期(中文)
    var weekdayStringFromDate: String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? TimeZone.current
        let theComponents = calendar.dateComponents([.weekday], from: base)
        guard let weekday = theComponents.weekday, weekday >= 1, weekday <= 7 else {
            return "未知"
        }
        return weekdays[weekday - 1]
    }
    
    // MARK: 1.13、从日期获取 月(英文)
    /// 从日期获取 月(英文)
    var monthAsString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: base)
    }
    
    // MARK: 1.14、从日期获取 月(中文)
    /// 从日期获取 月(中文)
    var monthAsChineseString: String {
        let months = ["一月", "二月", "三月", "四月", "五月", "六月", 
                     "七月", "八月", "九月", "十月", "十一月", "十二月"]
        let monthIndex = self.month - 1
        guard monthIndex >= 0, monthIndex < months.count else {
            return "未知"
        }
        return months[monthIndex]
    }
    
    // MARK: 1.15、获取季度
    /// 获取季度
    var quarter: Int {
        return (month - 1) / 3 + 1
    }
    
    // MARK: 1.16、获取星期几的数字(1-7)
    /// 获取星期几的数字(1-7)
    var weekdayNumber: Int {
        return Calendar.current.component(.weekday, from: base)
    }
    
    // MARK: 1.17、获取一年中的第几天
    /// 获取一年中的第几天
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: base) ?? 0
    }
    
    // MARK: 1.18、获取一年中的第几周
    /// 获取一年中的第几周
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: base)
    }
}

//MARK: - 二、时间格式的转换
// MARK: 时间条的显示格式
public enum TFYTimeBarType: Int, CaseIterable {
    // 默认格式，如 9秒：09，66秒：01：06，
    case normal
    case second
    case minute
    case hour
}

public extension TFY where Base == Date {
    
    // MARK: 2.1、时间戳(支持10位和13位)按照对应的格式 转化为 对应时间的字符串
    /// 时间戳(支持10位和13位)按照对应的格式 转化为 对应时间的字符串 如：1603849053 按照 "yyyy-MM-dd HH:mm:ss" 转化后为：2020-10-28 09:37:33
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - format: 格式
    /// - Returns: 对应时间的字符串
    static func timestampToFormatterTimeString(timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        // 时间戳转为Date
        let date = timestampToFormatterDate(timestamp: timestamp)
        // 设置 dateFormat
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        // 按照dateFormat把Date转化为String
        return formatter.string(from: date)
    }
    
    // MARK: 2.2、时间戳(支持 10 位 和 13 位) 转 Date
    /// 时间戳(支持 10 位 和 13 位) 转 Date
    /// - Parameter timestamp: 时间戳
    /// - Returns: 返回 Date
    static func timestampToFormatterDate(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            TFYUtils.Logger.log("时间戳位数不是 10 也不是 13: \(timestamp)")
            return Date()
        }
        
        guard let timestampInt = timestamp.tfy.toInt(), timestampInt > 0 else {
            TFYUtils.Logger.log("时间戳格式有问题: \(timestamp)")
            return Date()
        }
        
        let timestampValue = timestamp.count == 10 ? timestampInt : timestampInt / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }
    
    /// 根据本地时区转换
    /// - Parameter anyDate: 任意日期
    /// - Returns: 转换后的日期
    private static func getNowDateFromatAnDate(_ anyDate: Date?) -> Date? {
        guard let anyDate = anyDate else { return nil }
        
        // 设置源日期时区
        let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
        // 设置转换后的目标日期时区
        let destinationTimeZone = NSTimeZone.local as NSTimeZone
        
        // 得到源日期与世界标准时间的偏移量
        let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: anyDate) ?? 0
        // 目标日期与本地时区的偏移量
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: anyDate)
        // 得到时间偏移量的差值
        let interval = TimeInterval(destinationGMTOffset - sourceGMTOffset)
        // 转为现在时间
        return Date(timeInterval: interval, since: anyDate)
    }
    
    // MARK: 2.3、Date 转换为相应格式的时间字符串，如 Date 转为 2020-10-28
    /// Date 转换为相应格式的字符串，如 Date 转为 2020-10-28
    /// - Parameter formatter: 转换的格式
    /// - Returns: 返回具体的字符串
    func toformatterTimeString(formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let forma = DateFormatter()
        forma.timeZone = TimeZone.current
        forma.dateFormat = formatter
        return forma.string(from: base)
    }
    
    // MARK: 2.4、带格式的时间转 时间戳，支持返回 13位 和 10位的时间戳，时间字符串和时间格式必须保持一致
    /// 带格式的时间转 时间戳，支持返回 13位 和 10位的时间戳，时间字符串和时间格式必须保持一致
    /// - Parameters:
    ///   - timeString: 时间字符串，如：2020-10-26 16:52:41
    ///   - formatter: 时间格式，如：yyyy-MM-dd HH:mm:ss
    ///   - timestampType: 返回的时间戳类型，默认是秒 10 为的时间戳字符串
    /// - Returns: 返回转化后的时间戳
    static func formatterTimeStringToTimestamp(timesString: String, formatter: String, timestampType: TFYTimestampType = .second) -> String {
        let forma = DateFormatter()
        forma.dateFormat = formatter
        forma.timeZone = TimeZone.current
        
        guard let date = forma.date(from: timesString) else {
            TFYUtils.Logger.log("时间格式转换失败: \(timesString)")
            return ""
        }
        
        if timestampType == .second {
            return "\(Int(date.timeIntervalSince1970))"
        }
        return "\(Int((date.timeIntervalSince1970) * 1000))"
    }
    
    // MARK: 2.5、带格式的时间转 Date
    /// 带格式的时间转 Date
    /// - Parameters:
    ///   - timesString: 时间字符串
    ///   - formatter: 格式
    /// - Returns: 返回 Date
    static func formatterTimeStringToDate(timesString: String, formatter: String) -> Date {
        let forma = DateFormatter()
        forma.dateFormat = formatter
        forma.timeZone = TimeZone.current
        
        guard let date = forma.date(from: timesString) else {
            TFYUtils.Logger.log("时间格式转换失败: \(timesString)")
            return Date()
        }
        return date
    }
    
    // MARK: 2.6、秒转换成播放时间条的格式
    /// 秒转换成播放时间条的格式
    /// - Parameters:
    ///   - seconds: 秒数
    ///   - type: 格式类型
    /// - Returns: 返回时间条
    static func getFormatPlayTime(seconds: Int, type: TFYTimeBarType = .normal) -> String {
        guard seconds >= 0 else {
            return "00:00"
        }
        
        // 秒
        let second = seconds % 60
        if type == .second {
            return String(format: "%02d", seconds)
        }
        
        // 分钟
        var minute = Int(seconds / 60)
        if type == .minute {
            return String(format: "%02d:%02d", minute, second)
        }
        
        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }
        
        if type == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        
        // normal 类型
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }
    
    // MARK: 2.7、Date 转 时间戳
    /// Date 转 时间戳
    /// - Parameter timestampType: 返回的时间戳类型，默认是秒 10 为的时间戳字符串
    /// - Returns: 时间戳
    func dateToTimeStamp(timestampType: TFYTimestampType = .second) -> String {
        // 10位数时间戳 和 13位数时间戳
        let interval = timestampType == .second ? CLongLong(Int(base.timeIntervalSince1970)) : CLongLong(round(base.timeIntervalSince1970 * 1000))
        return "\(interval)"
    }
    
    // 转成当前时区的日期
    /// 转成当前时区的日期
    /// - Returns: 当前时区的日期
    func dateFromGMT() -> Date {
        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: base))
        return base.addingTimeInterval(secondFromGMT)
    }
    
    /// 获取日期的开始时间（00:00:00）
    /// - Returns: 开始时间
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: base)
    }
    
    /// 获取日期的结束时间（23:59:59）
    /// - Returns: 结束时间
    func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay()) ?? base
    }
    
    /// 获取月份的开始时间
    /// - Returns: 月份开始时间
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: base)
        return Calendar.current.date(from: components) ?? base
    }
    
    /// 获取年份的开始时间
    /// - Returns: 年份开始时间
    func startOfYear() -> Date {
        let components = Calendar.current.dateComponents([.year], from: base)
        return Calendar.current.date(from: components) ?? base
    }
}

// MARK: - 三、前天、昨天、今天、明天、后天、是否同一年同一月同一天 的判断
public extension TFY where Base == Date {
    
    // MARK: 3.1、今天的日期
    /// 今天的日期
    static let todayDate: Date = Date()
    
    // MARK: 3.2、昨天的日期（相对于date的昨天日期）
    /// 昨天的日期
    static var yesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }
    
    // MARK: 3.3、明天的日期
    /// 明天的日期
    static var tomorrowDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    }
    
    // MARK: 3.4、前天的日期
    /// 前天的日期
    static var theDayBeforYesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
    }
    
    // MARK: 3.5、后天的日期
    /// 后天的日期
    static var theDayAfterYesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 2), to: Date())
    }
    
    // MARK: 3.6、是否为今天（只比较日期，不比较时分秒）
    /// 是否为今天（只比较日期，不比较时分秒）
    /// - Returns: bool
    var isToday: Bool {
        return Calendar.current.isDate(base, inSameDayAs: Date())
    }
    
    // MARK: 3.7、是否为昨天
    /// 是否为昨天
    var isYesterday: Bool {
        // 1.先拿到昨天的 date
        guard let date = Base.tfy.yesterDayDate else {
            return false
        }
        // 2.比较当前的日期和昨天的日期
        return Calendar.current.isDate(base, inSameDayAs: date)
    }
    
    // MARK: 3.8、是否为前天
    /// 是否为前天
    var isTheDayBeforeYesterday: Bool {
        // 1.先拿到前天的 date
        guard let date = Base.tfy.theDayBeforYesterDayDate else {
            return false
        }
        // 2.比较当前的日期和前天的日期
        return Calendar.current.isDate(base, inSameDayAs: date)
    }
    
    // MARK: 3.9、是否为今年
    /// 是否为今年
    var isThisYear: Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: base)
        return nowCmps.year == selfCmps.year
    }
    
    // MARK: 3.10、两个date是否为同一天
    /// 是否为  同一年  同一月 同一天
    /// - Parameter date: 比较的日期
    /// - Returns: bool
    func isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(base, inSameDayAs: date)
    }
    
    // MARK: 3.11、当前日期是不是润年
    /// 当前日期是不是润年
    var isLeapYear: Bool {
        let year = base.tfy.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    /// 日期的加减操作
    /// - Parameter day: 天数变化
    /// - Returns: date
    private func adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: day), to: base)
    }
    
    /// 是否为  同一年  同一月 同一天
    /// - Parameter date: date
    /// - Returns: 返回bool
    private func isSameYeaerMountDay(_ date: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year, .month, .day], from: base)
        let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return (com.day == comToday.day &&
                com.month == comToday.month &&
                com.year == comToday.year)
    }
    
    // MARK: 3.12、是否为本周
    /// 是否为本周
    /// - Returns: 是否为本周
    var isThisWeek: Bool {
        let calendar = Calendar.current
        // 当前时间
        let nowComponents = calendar.dateComponents([.weekOfYear, .year], from: Date())
        // self
        let selfComponents = calendar.dateComponents([.weekOfYear, .year], from: base)
        return (selfComponents.year == nowComponents.year) && (selfComponents.weekOfYear == nowComponents.weekOfYear)
    }
    
    // MARK: 3.13、是否为本月
    /// 是否为本月
    /// - Returns: 是否为本月
    var isThisMonth: Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.month, .year], from: Date())
        let selfComponents = calendar.dateComponents([.month, .year], from: base)
        return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month)
    }
    
    // MARK: 3.14、是否为工作日
    /// 是否为工作日
    /// - Returns: 是否为工作日
    var isWorkday: Bool {
        let weekday = Calendar.current.component(.weekday, from: base)
        return weekday >= 2 && weekday <= 6 // 周一到周五
    }
    
    // MARK: 3.15、是否为周末
    /// 是否为周末
    /// - Returns: 是否为周末
    var isWeekend: Bool {
        let weekday = Calendar.current.component(.weekday, from: base)
        return weekday == 1 || weekday == 7 // 周日或周六
    }
}

// MARK: - 四、相对的时间变化
public extension TFY where Base == Date {
    
    // MARK: 4.1、取得与当前时间的间隔差
    /// 取得与当前时间的间隔差
    /// - Returns: 时间差
    func callTimeAfterNow() -> String {
        let timeInterval = Date().timeIntervalSince(base)
        if timeInterval < 0 {
            return "刚刚"
        }
        
        let interval = abs(timeInterval)
        let i60 = interval / 60
        let i3600 = interval / 3600
        let i86400 = interval / 86400
        let i2592000 = interval / 2592000
        let i31104000 = interval / 31104000
        
        var time: String!
        if i3600 < 1 {
            let s = Int(i60)
            if s == 0 {
                time = "刚刚"
            } else {
                time = "\(s)分钟前"
            }
        } else if i86400 < 1 {
            let s = Int(i3600)
            time = "\(s)小时前"
        } else if i2592000 < 1 {
            let s = Int(i86400)
            time = "\(s)天前"
        } else if i31104000 < 1 {
            let s = Int(i2592000)
            time = "\(s)个月前"
        } else {
            let s = Int(i31104000)
            time = "\(s)年前"
        }
        return time
    }
    
    // MARK: 4.2、获取两个日期之间的数据
    /// 获取两个日期之间的数据
    /// - Parameters:
    ///   - date: 对比的日期
    ///   - unit: 对比的类型
    /// - Returns: 两个日期之间的数据
    func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        let calendar = Calendar.current
        let component = calendar.dateComponents(unit, from: date, to: base)
        return component
    }
    
    // MARK: 4.3、获取两个日期之间的天数
    /// 获取两个日期之间的天数
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的天数
    func numberOfDays(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.day]).day
    }
    
    // MARK: 4.4、获取两个日期之间的小时
    /// 获取两个日期之间的小时
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的小时
    func numberOfHours(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.hour]).hour
    }
    
    // MARK: 4.5、获取两个日期之间的分钟
    /// 获取两个日期之间的分钟
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的分钟
    func numberOfMinutes(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.minute]).minute
    }
    
    // MARK: 4.6、获取两个日期之间的秒数
    /// 获取两个日期之间的秒数
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的秒数
    func numberOfSeconds(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.second]).second
    }
    
    // MARK: 4.7、获取两个日期之间的月数
    /// 获取两个日期之间的月数
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的月数
    func numberOfMonths(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.month]).month
    }
    
    // MARK: 4.8、获取两个日期之间的年数
    /// 获取两个日期之间的年数
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的年数
    func numberOfYears(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.year]).year
    }
    
    // MARK: 4.9、获取两个日期之间的周数
    /// 获取两个日期之间的周数
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的周数
    func numberOfWeekdays(from date: Date) -> Int? {
        guard let weekday = componentCompare(from: date, unit: [.weekday]).weekday else {
            return nil
        }
        return weekday / 7
    }
    
    /// 添加天数
    /// - Parameter days: 天数
    /// - Returns: 新的日期
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: base) ?? base
    }
    
    /// 添加月数
    /// - Parameter months: 月数
    /// - Returns: 新的日期
    func addingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: base) ?? base
    }
    
    /// 添加年数
    /// - Parameter years: 年数
    /// - Returns: 新的日期
    func addingYears(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: base) ?? base
    }
    
    /// 添加小时
    /// - Parameter hours: 小时数
    /// - Returns: 新的日期
    func addingHours(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: base) ?? base
    }
    
    /// 添加分钟
    /// - Parameter minutes: 分钟数
    /// - Returns: 新的日期
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: base) ?? base
    }
    
    /// 添加秒数
    /// - Parameter seconds: 秒数
    /// - Returns: 新的日期
    func addingSeconds(_ seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: base) ?? base
    }
}

// MARK: - 五、某年月份的天数获取
public extension TFY where Base == Date {
    
    // MARK: 5.1、获取某一年某一月的天数
    /// 获取某一年某一月的天数
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份
    /// - Returns: 返回天数
    static func daysCount(year: Int, month: Int) -> Int {
        guard month >= 1 && month <= 12 else {
            TFYUtils.Logger.log("非法的月份: \(month)")
            return 0
        }
        
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            return 0
        }
    }
    
    // MARK: 5.2、获取当前月的天数
    /// 获取当前月的天数
    /// - Returns: 返回天数
    static func currentMonthDays() -> Int {
        return daysCount(year: Date.tfy.currentDate.tfy.year, month: Date.tfy.currentDate.tfy.month)
    }
    
    // MARK: 5.3、获取指定月份的天数
    /// 获取指定月份的天数
    /// - Returns: 返回天数
    var daysInMonth: Int {
        return Self.daysCount(year: year, month: month)
    }
    
    // MARK: 5.4、获取指定年份的天数
    /// 获取指定年份的天数
    /// - Returns: 返回天数
    var daysInYear: Int {
        return isLeapYear ? 366 : 365
    }
}

extension Date {
    /// 增加几周
    /// - Parameter n: 周数
    mutating func addWeek(n: Int = 1) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .day, value: n * 7, to: self) {
            self = newDate
        }
    }
    
    /// 增加几个月
    /// - Parameter n: 月数
    mutating func addMonth(n: Int = 1) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .month, value: n, to: self) {
            self = newDate
        }
    }
    
    /// 增加几年
    /// - Parameter n: 年数
    mutating func addYear(n: Int = 1) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .year, value: n, to: self) {
            self = newDate
        }
    }
    
    /// 增加几天
    /// - Parameter n: 天数
    mutating func addDay(n: Int = 1) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .day, value: n, to: self) {
            self = newDate
        }
    }
    
    /// 增加几小时
    /// - Parameter n: 小时数
    mutating func addHour(n: Int = 1) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .hour, value: n, to: self) {
            self = newDate
        }
    }
    
    /// 增加几分钟
    /// - Parameter n: 分钟数
    mutating func addMinute(n: Int = 1) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .minute, value: n, to: self) {
            self = newDate
        }
    }
    
    /// 增加几秒
    /// - Parameter n: 秒数
    mutating func addSecond(n: Int = 1) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .second, value: n, to: self) {
            self = newDate
        }
    }
}
