//
//  NSNumber+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation

public extension TFY where Base: NSNumber {
    
    enum TFYSwiftOperators:Int {
        case TFYSwiftAdd = 0
        case TFYSwiftMul = 1
        case TFYSwiftSub = 2
        case TFYSwiftDiv = 3
    }
    
    // MARK: 1.1、转换为显示计数字符串
    /// 转换为显示计数字符串
    /// - Returns: 格式化后的字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func displayCount() -> String {
        if base.doubleValue <= 0 {
            return "0"
        }
        if base.doubleValue < 1000 {
            return base.description
        }
        if base.doubleValue >= 999_999 {
            return "999.9K+"
        }
        let result = base.doubleValue / 1000.0
        let num1 = NSNumber(value: result)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.roundingMode = .down
        numberFormatter.positiveFormat = "#0.0"
        return numberFormatter.string(from: num1)! + "K"
    }
    
    // MARK: 1.2、数值运算
    /// 数值运算
    /// - Parameters:
    ///   - oneNumber: 第一个数
    ///   - type: 运算类型
    ///   - twoNumber: 第二个数
    /// - Returns: 运算结果
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func getResult(oneNumber: NSNumber, type: TFYSwiftOperators, twoNumber: NSNumber) -> Base {
        var resultNum: NSDecimalNumber = NSDecimalNumber()
        let one: NSDecimalNumber = NSDecimalNumber(decimal: oneNumber.decimalValue)
        let two: NSDecimalNumber = NSDecimalNumber(decimal: twoNumber.decimalValue)
        let roundingBehavior: NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)

        switch type {
        case .TFYSwiftAdd:
            resultNum = one.adding(two, withBehavior: roundingBehavior)
        case .TFYSwiftMul:
            resultNum = one.multiplying(by: two, withBehavior: roundingBehavior)
        case .TFYSwiftSub:
            resultNum = one.subtracting(two, withBehavior: roundingBehavior)
        case .TFYSwiftDiv:
            resultNum = one.dividing(by: two, withBehavior: roundingBehavior)
        }
        return Base(nonretainedObject: resultNum)
    }
    
    ///  无格式,四舍五入
    func changeToumberFormatterNoStyle() -> String {
        return changeStyle(style: .none)
    }
    
    ///小数型,
    func changeToNumberFormatterDecimalStyle() -> String {
        return changeStyle(style: .decimal)
    }
    
    ///货币型,
    func changeToNumberFormatterCurrencyStyle() -> String {
        return changeStyle(style: .currency)
    }
    
    ///百分比型
    func changeToNumberFormatterPercentStyle() -> String {
        return changeStyle(style: .percent)
    }
    
    ///科学计数型,
    func changeToNumberFormatterScientificStyle() -> String {
        return changeStyle(style: .scientific)
    }
    
    ///全拼
    func changeToNumberFormatterSpellOutStyle() -> String {
        return changeStyle(style: .spellOut)
    }
    
    /// 序数
    func changeToNumberFormatterOrdinalStyle() -> String {
        return changeStyle(style: .ordinal)
    }
    
    /// 代码
    func changeToNumberFormatterCurrencyISOCodeStyle() -> String {
        return changeStyle(style: .currencyISOCode)
    }
    
    /// 复数
    func changeToNumberFormatterCurrencyPluralStyle() -> String {
        return changeStyle(style: .currencyPlural)
    }
    
    /// 会计
    func changeToNumberFormatterCurrencyAccountingStyle() -> String {
        return changeStyle(style: .currencyAccounting)
    }
    
    func changeStyle(style:NumberFormatter.Style) -> String {
        let formatter:NumberFormatter = NumberFormatter()
        formatter.numberStyle = style
        return formatter.string(from: base) ?? ""
    }
    
}

extension DispatchQueue {
    private static var _onceTracker = [String]()
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}

/// ¥###,##0.00
public let kNumFormat = "¥###,##0.00";

//MARK: -NumberFormatter
@objc public extension NumberFormatter{
    
    static func number(_ style: NumberFormatter.Style = .currency) -> NumberFormatter {
        let dic = Thread.current.threadDictionary
        
        let key = "NumberFormatter.Style.RawValue.\(style.rawValue)"
        if let formatter = dic.object(forKey: key) as? NumberFormatter {
            return formatter
        }
        
        let fmt = NumberFormatter()
        fmt.numberStyle = style
        dic.setObject(fmt, forKey: (key as NSString))
        return fmt
    }
    
    /// 数值格式化
    /// - Parameters:
    ///   - style: NumberFormatter.Style
    ///   - minFractionDigits: minimumFractionDigits = 2
    ///   - maxFractionDigits: maximumFractionDigits = 2
    /// - Returns: NumberFormatter
    static func format(_ style: NumberFormatter.Style = .none,
                       minFractionDigits: Int = 2,
                       maxFractionDigits: Int = 2,
                       positivePrefix: String = "¥",
                       groupingSeparator: String = ",",
                       groupingSize: Int = 3) -> NumberFormatter {
        let fmt = NumberFormatter.number(style)
        fmt.minimumIntegerDigits = 1
        fmt.minimumFractionDigits = minFractionDigits
        fmt.maximumFractionDigits = maxFractionDigits

        fmt.positivePrefix = positivePrefix
//        fmt.positiveSuffix = ""

        fmt.usesGroupingSeparator = true //分隔设true
        fmt.groupingSeparator = groupingSeparator //分隔符
        fmt.groupingSize = groupingSize  //分隔位数
        return fmt
    }

    /// format 格式金钱显示
    /// - Parameters:
    ///   - obj: number
    ///   - format: @",###.##"...
    /// - Returns: String?
    static func positiveFormat(_ style: NumberFormatter.Style = .none,
                               obj: CGFloat,
                               format: String = kNumFormat,
                               defalut: String = "-") -> String? {
        let fmt = NumberFormatter.number(style)
        fmt.positiveFormat = format
        return fmt.string(for: obj)
    }
}

public extension String.StringInterpolation {
    /// 插值 NumberFormatter
    mutating func appendInterpolation(_ obj: Any?, fmt: NumberFormatter) {
        guard let value = fmt.string(for: obj) else { return }
        appendLiteral(value)
    }
}


//MARK: -Number
@objc public extension NSNumber {
    
    var decNumer: NSDecimalNumber {
        return NSDecimalNumber(decimal: self.decimalValue)
    }
     
    // MARK: 2.1、获取对应的字符串
    /// 获取对应的字符串
    /// - Parameter max: 最大小数位数
    /// - Returns: 格式化后的字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toString(_ max: Int = 2) -> String? {
        let fmt = NumberFormatter.format(.none, minFractionDigits: 1, maxFractionDigits: max, positivePrefix: "", groupingSeparator: "", groupingSize: 3)
        return fmt.string(for: self)
    }
    
    // MARK: 2.2、转换为货币字符串
    /// 转换为货币字符串
    /// - Parameter currencyCode: 货币代码
    /// - Returns: 货币格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toCurrencyString(currencyCode: String = "CNY") -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: self)
    }
    
    // MARK: 2.3、转换为百分比字符串
    /// 转换为百分比字符串
    /// - Parameter decimalPlaces: 小数位数
    /// - Returns: 百分比格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toPercentString(decimalPlaces: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = decimalPlaces
        return formatter.string(from: self)
    }
    
    // MARK: 2.4、转换为科学计数法字符串
    /// 转换为科学计数法字符串
    /// - Returns: 科学计数法格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toScientificString() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        return formatter.string(from: self)
    }
    
    // MARK: 2.5、转换为中文数字字符串
    /// 转换为中文数字字符串
    /// - Returns: 中文数字字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toChineseString() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: self)
    }
    
    // MARK: 2.6、转换为序数字符串
    /// 转换为序数字符串
    /// - Returns: 序数格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toOrdinalString() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: self)
    }
    
    // MARK: 2.7、检查是否为整数
    /// 检查是否为整数
    /// - Returns: 是否为整数
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isInteger: Bool {
        return self.doubleValue.truncatingRemainder(dividingBy: 1) == 0
    }
    
    // MARK: 2.8、检查是否为正数
    /// 检查是否为正数
    /// - Returns: 是否为正数
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isPositive: Bool {
        return self.doubleValue > 0
    }
    
    // MARK: 2.9、检查是否为负数
    /// 检查是否为负数
    /// - Returns: 是否为负数
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isNegative: Bool {
        return self.doubleValue < 0
    }
    
    // MARK: 2.10、检查是否为零
    /// 检查是否为零
    /// - Returns: 是否为零
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isZero: Bool {
        return self.doubleValue == 0
    }
    
    // MARK: 2.11、获取绝对值
    /// 获取绝对值
    /// - Returns: 绝对值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var absoluteValue: NSNumber {
        return NSNumber(value: abs(self.doubleValue))
    }
    
    // MARK: 2.12、四舍五入到指定小数位
    /// 四舍五入到指定小数位
    /// - Parameter decimalPlaces: 小数位数
    /// - Returns: 四舍五入后的数值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func rounded(to decimalPlaces: Int) -> NSNumber {
        let multiplier = pow(10.0, Double(decimalPlaces))
        let roundedValue = round(self.doubleValue * multiplier) / multiplier
        return NSNumber(value: roundedValue)
    }
    
    // MARK: 2.13、向上取整
    /// 向上取整
    /// - Returns: 向上取整后的数值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var ceiling: NSNumber {
        return NSNumber(value: ceil(self.doubleValue))
    }
    
    // MARK: 2.14、向下取整
    /// 向下取整
    /// - Returns: 向下取整后的数值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var floorValue: NSNumber {
        return NSNumber(value: Foundation.floor(self.doubleValue))
    }
    
    // MARK: 2.15、转换为文件大小字符串
    /// 转换为文件大小字符串
    /// - Returns: 文件大小格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toFileSizeString() -> String {
        let byteCount = self.int64Value
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB, .useTB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: byteCount)
    }
    
    // MARK: 2.16、转换为时间间隔字符串
    /// 转换为时间间隔字符串
    /// - Returns: 时间间隔格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toTimeIntervalString() -> String {
        let seconds = self.doubleValue
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) % 3600 / 60
        let secs = Int(seconds) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%02d:%02d", minutes, secs)
        }
    }
    
    // MARK: 2.17、转换为距离字符串
    /// 转换为距离字符串
    /// - Returns: 距离格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toDistanceString() -> String {
        let meters = self.doubleValue
        if meters < 1000 {
            return String(format: "%.0fm", meters)
        } else {
            return String(format: "%.1fkm", meters / 1000)
        }
    }
    
    // MARK: 2.18、转换为温度字符串
    /// 转换为温度字符串
    /// - Parameter unit: 温度单位
    /// - Returns: 温度格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toTemperatureString(unit: String = "°C") -> String {
        return String(format: "%.1f%@", self.doubleValue, unit)
    }
    
    // MARK: 2.19、转换为重量字符串
    /// 转换为重量字符串
    /// - Returns: 重量格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toWeightString() -> String {
        let grams = self.doubleValue
        if grams < 1000 {
            return String(format: "%.0fg", grams)
        } else {
            return String(format: "%.1fkg", grams / 1000)
        }
    }
    
    // MARK: 2.20、转换为角度字符串
    /// 转换为角度字符串
    /// - Returns: 角度格式字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toAngleString() -> String {
        return String(format: "%.1f°", self.doubleValue)
    }
}


