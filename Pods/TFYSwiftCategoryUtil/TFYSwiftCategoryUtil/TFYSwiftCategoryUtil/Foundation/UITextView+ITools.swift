//
//  UITextView+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/9.
//

import Foundation
import UIKit

public extension TFY where Base == UITextView {
    /// 添加容器
    @discardableResult
    func addSubview(_ subView: UIView) -> Self {
        subView.addSubview(base)
        return self
    }
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
    
    /// 默认 CGSizeZero
    @discardableResult
    func contentSize(_ size: CGSize) -> Self {
        base.contentSize = size
        return self
    }
    
    /// 默认 CGPointZero
    @discardableResult
    func contentOffset(_ offset: CGPoint) -> Self {
        base.contentOffset = offset
        return self
    }
    
    /// 默认UIEdgeInsetsZero。在内容周围添加额外的滚动区域
    @discardableResult
    func contentInset(_ inset: UIEdgeInsets) -> Self {
        base.contentInset = inset
        return self
    }
    
    /// 默认的是的。如果是，则跳过内容的边缘并返回
    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        base.bounces = bounces
        return self
    }
    
    /// 没有违约。如果是并且bounce是YES，即使内容小于边界，也允许垂直拖动
    @discardableResult
    func alwaysBounceVertical(_ vertical: Bool) -> Self {
        base.alwaysBounceVertical = vertical
        return self
    }
    
    /// 没有违约。如果是并且bounce是YES，即使内容小于边界，也允许水平拖动
    @discardableResult
    func alwaysBounceHorizontal(_ horizontal: Bool) -> Self {
        base.alwaysBounceHorizontal = horizontal
        return self
    }
    
    /// 没有违约。如果是，在多个视图边界上停止
    @discardableResult
    func pagingEnabled(_ endbled: Bool) -> Self {
        base.isPagingEnabled = endbled
        return self
    }
    
    /// 默认的是的。暂时关闭任何拖拽
    @discardableResult
    func scrollEnabled(_ enabled: Bool) -> Self {
        base.isScrollEnabled = enabled
        return self
    }
    
    /// 默认的是的。当我们跟踪时，显示指示器。跟踪后淡出
    @discardableResult
    func showsHorizontalScrollIndicator(_ horizontal: Bool) -> Self {
        base.showsHorizontalScrollIndicator = horizontal
        return self
    }
    
    /// 默认的是的。当我们跟踪时，显示指示器。跟踪后淡出
    @discardableResult
    func showsVerticalScrollIndicator(_ vertical: Bool) -> Self {
        base.showsVerticalScrollIndicator = vertical
        return self
    }
    
    /// 默认是肯定的。
    @discardableResult
    func scrollsToTop(_ totop: Bool) -> Self {
        base.scrollsToTop = totop
        return self
    }
    
    /// 默认是UIScrollViewIndicatorStyleDefault
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        base.indicatorStyle = style
        return self
    }
    
    /// 只使用setter，方便将verticalScrollIndicatorInsets和horizontalScrollIndicatorInsets设置为相同的值。如果这些属性被设置为不同的值，则该getter(已弃用)的返回值是未定义的。
    @discardableResult
    func scrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        base.scrollIndicatorInsets = insets
        return self
    }
    
    /// 没有违约。如果是，请在拖动时锁定垂直或水平滚动
    @discardableResult
    func directionalLockEnabled(_ enabled: Bool) -> Self {
        base.isDirectionalLockEnabled = enabled
        return self
    }
    
    /// 默认 1.0
    @discardableResult
    func minimumZoomScale(_ min: CGFloat) -> Self {
        base.minimumZoomScale = min
        return self
    }
    
    /// 默认是1.0。必须是>最小缩放比例，使缩放
    @discardableResult
    func maximumZoomScale(_ max: CGFloat) -> Self {
        base.maximumZoomScale = max
        return self
    }
    
    /// 默认 1.0
    @discardableResult
    func zoomScale(_ zoom: CGFloat) -> Self {
        base.zoomScale = zoom
        return self
    }
    
    /// 以恒定速度动画到新的偏移量
    @discardableResult
    func contentOffsetAnimated(_ point: CGPoint, animated: Bool) -> Self {
        base.setContentOffset(point, animated: animated)
        return self
    }
    
    /// 以恒定速度动画到新的偏移量
    @discardableResult
    func contentOffsetToVisible(_ point: CGPoint, animated: Bool) -> Self {
        base.setContentOffset(point, animated: animated)
        return self
    }
    
    /// 默认为零。弱引用
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    
    /// 设置滚动指示灯是否由系统自动调整。默认是肯定的。
    @discardableResult
    func automaticallyAdjustsScrollIndicatorInsets(_ insets: Bool) -> Self {
        base.automaticallyAdjustsScrollIndicatorInsets = insets
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
    
    /// selectedRange
    @discardableResult
    func selectedRange(_ range: NSRange) -> Self {
        base.selectedRange = range
        return self
    }

    /// isEditable
    @discardableResult
    func editable(_ editable: Bool) -> Self {
        base.isEditable = editable
        return self
    }
    
    /// 切换可选择性，它控制用户选择内容和与url和附件交互的能力。在tvOS上，这也使文本视图可聚焦。
    @discardableResult
    func selectable(_ selectable: Bool) -> Self {
        base.isSelectable = selectable
        return self
    }

    /// dataDetectorTypes
    @discardableResult
    func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        base.dataDetectorTypes = types
        return self
    }

    /// 默认为不
    @discardableResult
    func allowsEditingTextAttributes(_ attributes: Bool) -> Self {
        base.allowsEditingTextAttributes = attributes
        return self
    }

    /// 选择更改时自动重置
    @discardableResult
    func typingAttributes(_ attributes: [NSAttributedString.Key : Any] ) -> Self {
        base.typingAttributes = attributes
        return self
    }

    /// 默认为没有。如果是，则隐藏选择UI，插入文本将替换字段的内容。更改选择将自动将此设置为NO。
    @discardableResult
    func clearsOnInsertion(_ clears: Bool) -> Self {
        base.clearsOnInsertion = clears
        return self
    }

    /// 在文本视图的内容区域内插入文本容器的布局区域
    @discardableResult
    func textContainerInset(_ inset: UIEdgeInsets) -> Self {
        base.textContainerInset = inset
        return self
    }

    /// 风格的链接
    @discardableResult
    func linkTextAttributes(_ link:[NSAttributedString.Key : Any]!) -> Self {
        base.linkTextAttributes = link
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
    func keyboardAppearance(_ appearance: UIKeyboardAppearance) -> Self {
        base.keyboardAppearance = appearance
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
    func secureTextEntry(_ entry: Bool) -> Self {
        base.isSecureTextEntry = entry
        return self
    }

    /// 默认为零
    @discardableResult
    func textContentType(_ type: UITextContentType) -> Self {
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
