//
//  UIDatePicker+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UIDatePicker {
    
    @discardableResult
    func datePickerMode(_ datePickerMode: UIDatePicker.Mode) -> TFY {
        base.datePickerMode = datePickerMode
        return self
    }
    
    @discardableResult
    func locale(_ locale: Locale?) -> TFY {
        base.locale = locale
        return self
    }
    
    @discardableResult
    func calendar(_ calendar: Calendar) -> TFY {
        base.calendar = calendar
        return self
    }
    
    @discardableResult
    func timeZone(_ timeZone: TimeZone?) -> TFY {
        base.timeZone = timeZone
        return self
    }
    
    @discardableResult
    func date(_ date: Date) -> TFY {
        base.date = date
        return self
    }
    
    @discardableResult
    func minimumDate(_ minimumDate: Date?) -> TFY {
        base.minimumDate = minimumDate
        return self
    }
    
    @discardableResult
    func maximumDate(_ maximumDate: Date?) -> TFY {
        base.maximumDate = maximumDate
        return self
    }
    
    @discardableResult
    func countDownDuration(_ countDownDuration: TimeInterval) -> TFY {
        base.countDownDuration = countDownDuration
        return self
    }
    
    @discardableResult
    func minuteInterval(_ minuteInterval: Int) -> TFY {
        base.minuteInterval = minuteInterval
        return self
    }
}
