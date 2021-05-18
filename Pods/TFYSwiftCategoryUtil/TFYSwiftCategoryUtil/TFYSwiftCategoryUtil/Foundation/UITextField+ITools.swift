//
//  UITextField+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/9.
//

import Foundation
import UIKit

public extension TFY where Base == UITextField {
    /// 是否隐藏
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        base.isHidden = hidden
        return self
    }
    
    /// 背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        base.backgroundColor = color
        return self
    }
    
    /// 添加容器
    @discardableResult
    func addSubview(_ subView: UIView) -> Self {
        subView.addSubview(base)
        return self
    }
    
    /// 圆角
    @discardableResult
    func cornerRadius(_ radius:CGFloat) -> Self {
        base.layer.cornerRadius = radius
        return self
    }
    
    ///  影子的颜色。默认为不透明的黑色。颜色创建from模式目前不支持。可以做成动画。
    @discardableResult
    func layershadowColor(_ color: UIColor?) -> Self {
        base.layer.shadowColor = color?.cgColor
        return self
    }
    
    /// layer 影子偏移量。默认为(0，-3)。可以做成动画。
    @discardableResult
    func layershadowOffset(_ size: CGSize) -> Self {
        base.layer.shadowOffset = size
        return self
    }
    
    /// layer 用于创建阴影的模糊半径。默认为3。可以做成动画。
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        base.layer.shadowRadius = radius
        return self
    }
    
    /// 透明度
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
    
    /// tintColor
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        base.tintColor = color
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
    
    /// 文本
    @discardableResult
    func text(_ text: String) -> Self {
        base.text = text
        return self
    }
    
    /// 默认为零
    @discardableResult
    func attributedText(_ attribut: NSAttributedString) -> Self {
        base.attributedText = attribut
        return self
    }
    
    /// 默认是零。使用系统字体12 pt
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.font = font
        return self
    }
    
    /// 默认是零。使用不透明的黑色
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        base.textColor = color
        return self
    }

    /// 默认是NSLeftTextAlignment
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        base.textAlignment = alignment
        return self
    }
    
    /// 默认是UITextBorderStyleNone。如果设置为UITextBorderStyleRoundedRect，自定义背景图像将被忽略。
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        base.borderStyle = style
        return self
    }

    /// 将属性应用到全部文本范围。未设置属性类似于默认值。
    @discardableResult
    func defaultTextAttributes(_ attributes: [NSAttributedString.Key : Any]) -> Self {
        base.defaultTextAttributes = attributes
        return self
    }

    /// 默认是零。绳子是灰色的70%
    @discardableResult
    func placeholder(_ placeholder: String?) -> Self {
        base.placeholder = placeholder
        return self
    }
    
    /// 默认为零
    @discardableResult
    func attributedPlaceholder(_ attribute: NSAttributedString?) -> Self {
        base.attributedPlaceholder = attribute
        return self
    }

    /// 默认为NO，将光标移动到单击的位置。如果是，则清除所有文本
    @discardableResult
    func clearsOnBeginEditing(_ onediting: Bool) -> Self {
        base.clearsOnBeginEditing = onediting
        return self
    }
    
    /// 默认是否定的。如果是，文本将缩小到minFontSize沿基线
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = adjusts
        return self
    }
    
    /// 默认是0.0。实际最小值可能被固定在可读的东西上。当adjustsFontSizeToFitWidth为YES时使用
    @discardableResult
    func minimumFontSize(_ minFontSize: CGFloat) -> Self {
        base.minimumFontSize = minFontSize
        return self
    }

    /// 默认是零。弱引用
    @discardableResult
    func delegate(_ delegate: UITextFieldDelegate) -> Self {
        base.delegate = delegate
        return self
    }
    
    /// 默认是零。画在边界矩形。图像应该是可伸缩的
    @discardableResult
    func background(_ background: UIImage?) -> Self {
        base.background = background
        return self
    }

    /// 默认是零。如果背景没有设置，则忽略。图像应该是可伸缩的
    @discardableResult
    func disabledBackground(_ background: UIImage?) -> Self {
        base.disabledBackground = background
        return self
    }
    
    /// 默认是否定的。允许编辑文本属性与样式操作和粘贴富文本
    @discardableResult
    func allowsEditingTextAttributes(_ allowsEditing: Bool) -> Self {
        base.allowsEditingTextAttributes = allowsEditing
        return self
    }
    
    /// 选择更改时自动重置
    @discardableResult
    func typingAttributes(_ attributes: [NSAttributedString.Key : Any]?) -> Self {
        base.typingAttributes = attributes
        return self
    }
    
    /// 设置清除按钮显示的时间。默认是UITextFieldViewModeNever
    @discardableResult
    func clearButtonMode(_ clearMode: UITextField.ViewMode) -> Self {
        base.clearButtonMode = clearMode
        return self
    }
    
    /// 如放大镜
    @discardableResult
    func leftView(_ view: UIView?) -> Self {
        base.leftView = view
        return self
    }

    /// 设置左边视图显示的时间。默认是UITextFieldViewModeNever
    @discardableResult
    func leftViewMode(_ leftMode: UITextField.ViewMode) -> Self {
        base.leftViewMode = leftMode
        return self
    }
    
    /// 例如书签按钮
    @discardableResult
    func rightView(_ view: UIView?) -> Self {
        base.rightView = view
        return self
    }

    /// 设置何时显示正确的视图。默认是UITextFieldViewModeNever
    @discardableResult
    func rightViewMode(_ rightMode: UITextField.ViewMode) -> Self {
        base.rightViewMode = rightMode
        return self
    }
    
    /// set while first responder，在reloadInputViews被调用之前不会生效。
    @discardableResult
    func inputView(_ input: UIView?) -> Self {
        base.inputView = input
        return self
    }
    
    /// inputAccessoryView
    @discardableResult
    func inputAccessoryView(_ inputView: UIView?) -> Self {
        base.inputAccessoryView = inputView
        return self
    }

    /// 默认是UITextAutocapitalizationTypeSentences
    @discardableResult
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
        base.autocapitalizationType = type
        return self
    }
    
    /// 默认是UITextAutocorrectionTypeDefault
    @discardableResult
    func autocorrectionType(_ type: UITextAutocorrectionType) -> Self {
        base.autocorrectionType = type
        return self
    }

    /// 默认是UITextSpellCheckingTypeDefault;
    @discardableResult
    func spellCheckingType(_ type: UITextSpellCheckingType) -> Self {
        base.spellCheckingType = type
        return self
    }

    /// 默认是UIKeyboardTypeDefault
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        base.keyboardType = type
        return self
    }

    /// 默认是UIKeyboardAppearanceDefault
    @discardableResult
    func keyboardAppearance(_ keyboard: UIKeyboardAppearance) -> Self {
        base.keyboardAppearance = keyboard
        return self
    }

    /// default是UIReturnKeyDefault(参见UIReturnKeyType enum下面的注释)
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        base.returnKeyType = type
        return self
    }

    /// default是NO(当YES时，当文本小部件有零长度的内容时将自动禁用返回键，当文本小部件有非零长度的内容时将自动启用)
    @discardableResult
    func enablesReturnKeyAutomatically(_ enables: Bool) -> Self {
        base.enablesReturnKeyAutomatically = enables
        return self
    }
    
    /// 默认是没有
    @discardableResult
    func secureTextEntry(_ secure: Bool) -> Self {
        base.isSecureTextEntry = secure
        return self
    }

    /// 默认为零
    @discardableResult
    func textContentType(_ type: UITextContentType!) -> Self {
        base.textContentType = type
        return self
    }
    
    /// 手势添加
    @discardableResult
    func addGubview(_ gesture: UIGestureRecognizer) -> Self {
        base.addGestureRecognizer(gesture)
        return self
    }
    
}
