//
//  UIScrollView+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/9.
//

import Foundation
import UIKit

public extension TFY where Base == UIScrollView {
    
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
    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        base.delegate = delegate
        return self
    }
    
    /// 设置滚动指示灯是否由系统自动调整。默认是肯定的。
    @discardableResult
    func automaticallyAdjustsScrollIndicatorInsets(_ insets: Bool) -> Self {
        base.automaticallyAdjustsScrollIndicatorInsets = insets
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
    
    /// 当为正数时，该层的背景将被绘制圆角。也影响掩码生成“masksToBounds”属性。默认值为零。可以做成动画。
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        base.layer.cornerRadius = radius
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
    
    /// 用于创建阴影的模糊半径。默认为3。可以做成动画。
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        base.layer.shadowRadius = radius
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
    
    /// 手势添加
    @discardableResult
    func addGubview(_ gesture: UIGestureRecognizer) -> Self {
        base.addGestureRecognizer(gesture)
        return self
    }
}
