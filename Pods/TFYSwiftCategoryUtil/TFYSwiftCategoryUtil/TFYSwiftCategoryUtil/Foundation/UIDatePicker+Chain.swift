//
//  UIDatePicker+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UIDatePicker {
    /// 设置日期选择器模式
    @discardableResult
    func datePickerMode(_ datePickerMode: UIDatePicker.Mode) -> Self {
        base.datePickerMode = datePickerMode
        return self
    }
    /// 设置地区
    @discardableResult
    func locale(_ locale: Locale?) -> Self {
        base.locale = locale
        return self
    }
    /// 设置日历
    @discardableResult
    func calendar(_ calendar: Calendar) -> Self {
        base.calendar = calendar
        return self
    }
    /// 设置时区
    @discardableResult
    func timeZone(_ timeZone: TimeZone?) -> Self {
        base.timeZone = timeZone
        return self
    }
    /// 设置当前日期
    @discardableResult
    func date(_ date: Date) -> Self {
        base.date = date
        return self
    }
    /// 设置最小日期
    @discardableResult
    func minimumDate(_ minimumDate: Date?) -> Self {
        base.minimumDate = minimumDate
        return self
    }
    /// 设置最大日期
    @discardableResult
    func maximumDate(_ maximumDate: Date?) -> Self {
        base.maximumDate = maximumDate
        return self
    }
    /// 设置倒计时持续时间（秒）
    @discardableResult
    func countDownDuration(_ countDownDuration: TimeInterval) -> Self {
        base.countDownDuration = max(0, countDownDuration)
        return self
    }
    /// 设置分钟间隔（1-30之间）
    @discardableResult
    func minuteInterval(_ minuteInterval: Int) -> Self {
        base.minuteInterval = max(1, min(30, minuteInterval))
        return self
    }
}
