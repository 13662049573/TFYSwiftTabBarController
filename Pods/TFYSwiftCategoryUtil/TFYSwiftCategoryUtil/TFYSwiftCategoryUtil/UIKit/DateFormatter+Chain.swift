//
//  DateFormatter+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//


import UIKit

public extension TFY where Base: DateFormatter {
    
    @discardableResult
    func dateFormat(_ dateFormat: String) -> TFY {
        base.dateFormat = dateFormat
        return self
    }
    
    @discardableResult
    func dateStyle(_ dateStyle: DateFormatter.Style) -> TFY {
        base.dateStyle = dateStyle
        return self
    }
    
    @discardableResult
    func timeStyle(_ timeStyle: DateFormatter.Style) -> TFY {
        base.timeStyle = timeStyle
        return self
    }
    
    @discardableResult
    func locale(_ locale: Locale) -> TFY {
        base.locale = locale
        return self
    }
    
    @discardableResult
    func generatesCalendarDates(_ generatesCalendarDates: Bool) -> TFY {
        base.generatesCalendarDates = generatesCalendarDates
        return self
    }
    
    @discardableResult
    func formatterBehavior(_ formatterBehavior: DateFormatter.Behavior) -> TFY {
        base.formatterBehavior = formatterBehavior
        return self
    }
    
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> TFY {
        base.timeZone = timeZone
        return self
    }
    
    @discardableResult
    func calendar(_ calendar: Calendar) -> TFY {
        base.calendar = calendar
        return self
    }
}
