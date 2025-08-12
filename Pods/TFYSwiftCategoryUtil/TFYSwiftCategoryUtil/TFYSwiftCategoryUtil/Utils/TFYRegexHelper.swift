//
//  TFYRegexHelper.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//  用途：正则表达式工具，支持常用字符串、数字、手机号等校验。
//

import Foundation

/// 字符校验类型
public enum TFYRegexCharacterType: String, CaseIterable {
    /// 汉字校验
    case chinese = "^[\\u4e00-\\u9fa5]{0,}$"
    /// 英文和数字，长度4-40
    case alphaNumeric = "^[A-Za-z0-9]{4,40}$"
    /// 任意字符，长度3-20
    case anyCharacter = "^.{3,20}$"
    /// 纯英文字母
    case alpha = "^[A-Za-z]+$"
    /// 大写英文字母
    case upperAlpha = "^[A-Z]+$"
    /// 小写英文字母
    case lowerAlpha = "^[a-z]+$"
    /// 英文和数字组合
    case alphaNum = "^[A-Za-z0-9]+$"
    /// 英文、数字和下划线
    case alphaNumUnderscore = "^\\w+$"
    /// 中文、英文、数字和下划线
    case chineseAlphaNumUnderscore = "^[\\u4E00-\\u9FA5A-Za-z0-9_]+$"
    /// 中文、英文和数字（不含符号）
    case chineseAlphaNum = "^[\\u4E00-\\u9FA5A-Za-z0-9]+$"
    /// 允许特殊字符（除^%&',;=?$\"外）
    case allowSpecial = "[^%&',;=?$\\x22]+"
    /// 禁止波浪号
    case noTilde = "[^~\\x22]+"
}

/// 数字校验类型
public enum TFYRegexDigitalType: String, CaseIterable {
    /// 纯数字
    case number = "^[0-9]*$"
    /// 零或非零开头的数字
    case validNumber = "^(0|[1-9][0-9]*)$"
    /// 非零开头的最多两位小数
    case decimal = "^([1-9][0-9]*)+(\\.[0-9]{1,2})?$"
    /// 正整数
    case positiveInteger = "^[1-9]\\d*$"
    /// 负整数
    case negativeInteger = "^-[1-9]\\d*$"
    /// 非负整数（正整数和0）
    case nonNegativeInteger = "^\\d+$"
    /// 非正整数（负整数和0）
    case nonPositiveInteger = "^((-\\d+)|(0+))$"
    /// 非负浮点数
    case nonNegativeFloat = "^\\d+(\\.\\d+)?$"
    /// 非正浮点数
    case nonPositiveFloat = "^((-\\d+(\\.\\d+)?)|(0+(\\.0+)?))$"
    /// 正浮点数
    case positiveFloat = "^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$"
    /// 负浮点数
    case negativeFloat = "^-([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*)$"
    /// 浮点数
    case float = "^(-?\\d+)(\\.\\d+)?$"
    /// 手机号码（支持166、198、199等）
    case phone = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199)\\d{8}$"
}

/// 正则表达式工具类
public struct TFYRegexHelper {
    
    // MARK: - 基础匹配方法
    
    /// 通用正则匹配
    /// - Parameters:
    ///   - input: 需要匹配的字符串
    ///   - pattern: 正则表达式
    ///   - options: 匹配选项，默认为空数组
    /// - Returns: 是否匹配成功
    public static func match(
        _ input: String,
        pattern: String,
        options: NSRegularExpression.Options = []
    ) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: options)
            let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
            return !matches.isEmpty
        } catch {
            print("TFYRegexHelper: 正则表达式错误 pattern=\(pattern), error=\(error)")
            return false
        }
    }
    
    /// 获取匹配的范围
    /// - Parameters:
    ///   - input: 需要匹配的字符串
    ///   - pattern: 正则表达式
    ///   - options: 匹配选项，默认为空数组
    /// - Returns: 匹配到的范围数组
    public static func matchRanges(
        _ input: String,
        pattern: String,
        options: NSRegularExpression.Options = []
    ) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return []
        }
        return regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
            .map { $0.range }
    }
    
    // MARK: - 常用验证方法
    
    /// 验证邮箱格式
    /// - Parameter email: 邮箱地址
    /// - Returns: 是否合法
    public static func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return match(email, pattern: pattern)
    }
    
    /// 验证手机号码
    /// - Parameter phone: 手机号码
    /// - Returns: 是否合法
    public static func isValidPhone(_ phone: String) -> Bool {
        return match(phone, pattern: TFYRegexDigitalType.phone.rawValue)
    }
    
    /// 验证中文姓名
    /// - Parameter name: 姓名
    /// - Returns: 是否合法
    public static func isValidChineseName(_ name: String) -> Bool {
        let pattern = "^[\u{4e00}-\u{9fa5}]{2,8}$"
        return match(name, pattern: pattern)
    }
    
    /// 验证身份证号码
    /// - Parameter idCard: 身份证号码
    /// - Returns: 是否合法
    public static func isValidIDCard(_ idCard: String) -> Bool {
        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return match(idCard, pattern: pattern)
    }
    
    /// 验证密码强度（至少包含数字和字母，长度8-20位）
    /// - Parameter password: 密码
    /// - Returns: 是否合法
    public static func isValidPassword(_ password: String) -> Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$"
        return match(password, pattern: pattern)
    }
}

// MARK: - 便利扩展
public extension String {
    /// 是否匹配指定的正则表达式
    func matches(_ pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        return TFYRegexHelper.match(self, pattern: pattern, options: options)
    }
    
    /// 是否是有效的邮箱
    var isValidEmail: Bool {
        return TFYRegexHelper.isValidEmail(self)
    }
    
    /// 是否是有效的手机号
    var isValidPhone: Bool {
        return TFYRegexHelper.isValidPhone(self)
    }
    
    /// 是否是有效的中文姓名
    var isValidChineseName: Bool {
        return TFYRegexHelper.isValidChineseName(self)
    }
    
    /// 是否是有效的身份证号
    var isValidIDCard: Bool {
        return TFYRegexHelper.isValidIDCard(self)
    }
    
    /// 是否是有效的密码
    var isValidPassword: Bool {
        return TFYRegexHelper.isValidPassword(self)
    }
}
