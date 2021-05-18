//
//  UIDatePicker+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit

// MACK ----- 链式编程 ------------
public extension TFY where Base == UIDatePicker {
    /// 背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        base.backgroundColor = color
        return self
    }
    
    /// tintColor
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        base.tintColor = color
        return self
    }
    
    /// 透明度
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
    
    /// 是否隐藏
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        base.isHidden = hidden
        return self
    }
    
    /// clipsToBounds
    @discardableResult
    func clipsToBounds(_ clips: Bool) -> Self {
        base.clipsToBounds = clips
        return self
    }
    
    /// isOpaque
    @discardableResult
    func opaque(_ opaque: Bool) -> Self {
        base.isOpaque = opaque
        return self
    }
    
    /// isUserInteractionEnabled
    @discardableResult
    func userInteractionEnabled(_ enabled: Bool) -> Self {
        base.isUserInteractionEnabled = enabled
        return self
    }
    
    /// contentMode
    @discardableResult
    func multipleTouchEnabled(_ enabled: Bool) -> Self {
        base.isMultipleTouchEnabled = enabled
        return self
    }
    
    ///
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        base.contentMode = mode
        return self
    }
    
    /// transform
    @discardableResult
    func transform(_ transform: CGAffineTransform) -> Self {
        base.transform = transform
        return self
    }
    
    /// autoresizingMask
    @discardableResult
    func autoresizingMask(_ mask: UIView.AutoresizingMask) -> Self {
        base.autoresizingMask = mask
        return self
    }
    
    /// autoresizesSubviews
    @discardableResult
    func autoresizesSubviews(_ sizes: Bool) -> Self {
        base.autoresizesSubviews = sizes
        return self
    }
    
    /// 添加容器
    @discardableResult
    func addSubview(_ subView: UIView) -> Self {
        subView.addSubview(base)
        return self
    }
    
    /// 默认为没有。可以做成动画。
    @discardableResult
    func shouldRasterize(_ rasterize: Bool) -> Self {
        base.layer.shouldRasterize = rasterize
        return self
    }
    
    ///
    @discardableResult
    func opacity(_ opacity: Float) -> Self {
        base.layer.opacity = opacity
        return self
    }
    
    /// 图层的背景色。默认值为nil。颜色支持从平铺模式创建。可以做成动画。
    @discardableResult
    func backGroundColor(_ color: UIColor?) -> Self {
        base.layer.backgroundColor = color?.cgColor
        return self
    }
    
    /// 一个提示标记- drawcontext提供的图层内容:完全不透明。默认为没有。注意，这并不影响直接解释' contents'属性。
    @discardableResult
    func opaqueLayer(_ opaque: Bool) -> Self {
        base.layer.isOpaque = opaque
        return self
    }
    
    /// 图层将被栅格化的比例(当shouldRasterize属性已设置为YES)相对于图层的坐标空间。默认为1。可以做成动画。
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        base.layer.rasterizationScale = scale
        return self
    }
    
    /// 当为true时，将应用与图层边界匹配的隐式蒙版 图层(包括' cornerRadius'属性的效果)。如果' mask'和' masksToBounds'两个掩码都是非nil的 乘以得到实际的掩码值。默认为没有。可以做成动画。
    @discardableResult
    func masksToBounds(_ maske: Bool) -> Self {
        base.layer.masksToBounds = maske
        return self
    }
    
    /// 图层边界的宽度，从图层边界中插入。的边框是合成在层的内容和子层和 包含了' cornerRadius'属性的效果。默认为0。可以做成动画。
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        base.layer.borderWidth = width
        return self
    }
    
    /// 图层边界的颜色。默认为不透明的黑色。颜色 支持从平铺模式创建。可以做成动画。
    @discardableResult
    func borderColor(_ color: UIColor?) -> Self {
        base.layer.borderColor = color?.cgColor
        return self
    }
    
    /// 在超层中，该层的锚点的位置 bounds rect对齐到。默认值为0。可以做成动画。
    @discardableResult
    func zPosition(_ point: CGPoint) -> Self {
        base.layer.position = point
        return self
    }
    
    /// 影子的颜色。默认为不透明的黑色。颜色创建 from模式目前不支持。可以做成动画。
    @discardableResult
    func shadowColor(_ color: UIColor?) -> Self {
        base.layer.shadowColor = color?.cgColor
        return self
    }
    
    /// 阴影的不透明。默认值为0。属性之外指定一个值 [0,1]范围将给出未定义的结果。可以做成动画。
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        base.layer.shadowOpacity = opacity
        return self
    }
    
    /// 影子偏移量。默认为(0，-3)。可以做成动画。
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        base.layer.shadowOffset = offset
        return self
    }
    
    /// 相对于该层的锚点应用到该层的转换默认为标识转换。可以做成动画。
    @discardableResult
    func transform(_ transform: CATransform3D) -> Self {
        base.layer.transform = transform
        return self
    }
    
    /// shadowPath
    @discardableResult
    func shadowPath(_ path: CGPath?) -> Self {
        base.layer.shadowPath = path
        return self
    }
    
    /// 默认是肯定的。如果否，忽略触摸事件和子类可能绘制不同
    @discardableResult
    func enabled(_ enabled: Bool) -> Self {
        base.isEnabled = enabled
        return self
    }
    
    /// NO可以被一些子类或应用程序使用
    @discardableResult
    func selected(_ selected: Bool) -> Self {
        base.isSelected = selected
        return self
    }
    
    /// 默认是否定的。当触摸在跟踪过程中进入/退出时自动设置/清除并清除
    @discardableResult
    func highlighted(_ highlighted: Bool) -> Self {
        base.isHighlighted = highlighted
        return self
    }
    
    /// 如何在控件内垂直定位内容。默认是中心
    @discardableResult
    func contentVerticalAlignment(_ alignment: UIControl.ContentVerticalAlignment) -> Self {
        base.contentVerticalAlignment = alignment
        return self
    }
    
    /// 如何在控件内水平位置内容。默认是中心
    @discardableResult
    func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        base.contentHorizontalAlignment = alignment
        return self
    }
    
    /// 添加点击事件
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, controlEvents: UIControl.Event) -> Self {
        base.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    /// 移除一组事件的目标/操作。为操作传入NULL，以删除该目标的所有操作
    @discardableResult
    func removeTarget(_ target: Any?, action: Selector, controlEvents: UIControl.Event) -> Self {
        base.removeTarget(target, action: action, for: controlEvents)
        return self
    }
    
    /// 从传递的控制事件集中删除具有提供标识符的操作。
    @available(iOS 14.0, *)
    @discardableResult
    func removeAllTarget(_ identifiedBy: UIAction.Identifier,controlEvents: UIControl.Event) -> Self {
        base.removeAction(identifiedBy: identifiedBy, for: controlEvents)
        return self
    }
    
    /// 默认是UIDatePickerModeDateAndTime
    @discardableResult
    func datePickerMode(_ mode: UIDatePicker.Mode) -> Self {
        base.datePickerMode = mode
        return self
    }
    
    /// default是[NSLocale currentLocale]。设置nil将返回默认值
    @discardableResult
    func locale(_ locale: Locale?) -> Self {
        base.locale = locale
        return self
    }

    /// default是[NSCalendar currentCalendar]。设置nil将返回默认值
    @discardableResult
    func calendar(_ calendar: Calendar!) -> Self {
        base.calendar = calendar
        return self
    }

    /// 默认是零。从日历中使用当前时区或时区
    @discardableResult
    func timeZone(_ zone: TimeZone?) -> Self {
        base.timeZone = zone
        return self
    }
    
    /// 默认值是创建选择器时的当前日期。在倒计时模式中被忽略。对于该模式，picker从0:00开始
    @discardableResult
    func date(_ date: Date) -> Self {
        base.date = date
        return self
    }

    /// 指定最小/最大日期范围。默认是零。当min > max时，这些值将被忽略。在倒计时模式中被忽略
    @discardableResult
    func minimumDate(_ min: Date?) -> Self {
        base.minimumDate = min
        return self
    }

    /// 默认为零
    @discardableResult
    func maximumDate(_ max: Date?) -> Self {
        base.maximumDate = max
        return self
    }

    /// UIDatePickerModeCountDownTimer，否则忽略。默认是0.0。限制是23:59(86,399秒)。正在设置的值是div 60(剩下的秒)。
    @discardableResult
    func countDownDuration(_ duration: TimeInterval) -> Self {
        base.countDownDuration = duration
        return self
    }
    
    /// 显示分钟轮与间隔。间隔必须均匀分成60。默认值为1。最小值是1，最大值是30
    @discardableResult
    func minuteInterval(_ interval: Int) -> Self {
        base.minuteInterval = interval
        return self
    }

    /// 如果“动画”是“YES”，则动画时间轮以显示新的日期
    @discardableResult
    func setDateWithAnimated(_ date: Date,animated: Bool) -> Self {
        base.setDate(date, animated: animated)
        return self
    }
    
    /// 手势添加
    @discardableResult
    func addGubview(_ gesture: UIGestureRecognizer) -> Self {
        base.addGestureRecognizer(gesture)
        return self
    }

}

