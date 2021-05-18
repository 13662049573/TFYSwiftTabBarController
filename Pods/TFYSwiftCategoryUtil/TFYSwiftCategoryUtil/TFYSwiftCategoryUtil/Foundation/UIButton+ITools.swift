//
//  UIButton+ITools.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/5/5.
//

import Foundation
import UIKit

public extension TFY where Base == UIButton {
    
    /// text: 文字内容
    @discardableResult
    func text(_ title: String?, state: UIControl.State) -> Self {
        base.setTitle(title, for: state)
        return self
    }
    
    /// 文字颜色
    @discardableResult
    func textColor(_ color: UIColor?, state: UIControl.State) -> Self {
        base.setTitleColor(color, for: state)
        return self
    }
    
    /// 背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        base.backgroundColor = color
        return self
    }
    
    /// 圆角
    @discardableResult
    func cornerRadius(_ radius:CGFloat) -> Self {
        base.layer.cornerRadius = radius
        return self
    }
    
    /// 文字大小
    @discardableResult
    func font(_ font: UIFont!) -> Self {
        base.titleLabel?.font = font
        return self
    }
    
    /// 切园是否开启
    @discardableResult
    func clipsToBounds(_ isbool: Bool) -> Self {
        base.clipsToBounds = isbool
        return self
    }
    
    /// 透明度
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
    
    /// 文字样式对齐
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        base.titleLabel?.textAlignment = alignment
        return self
    }
    
    /// 图片
    @discardableResult
    func image(_ image: UIImage?, state: UIControl.State) -> Self {
        base.setImage(image, for: state)
        return self
    }
    
    
    /// 背景图片
    @discardableResult
    func backgroundImage(_ image: UIImage?, state: UIControl.State) -> Self {
        base.setBackgroundImage(image, for: state)
        return self
    }
    
    /// 设置富文本文字 默认为零
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString,state: UIControl.State) -> Self {
        base.setAttributedTitle(attributedText, for: state)
        return self
    }
    
    /// 允许标签自动调整大小，以适应一定的宽度，缩放因子>=最小缩放因子的字体大小,并指定当需要缩小字体时文本基线如何移动。
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjustsFontSize: Bool) -> Self {
        base.titleLabel!.adjustsFontSizeToFitWidth = adjustsFontSize
        return self
    }
    
    /// system 文字大小
    @discardableResult
    func systemFont(_ ofSize: CGFloat) -> Self {
        base.titleLabel!.font = UIFont.systemFont(ofSize: ofSize)
        return self
    }
    
    /// boldSystem 加粗文字大小
    @discardableResult
    func boldFont(_ ofSize: CGFloat) -> Self {
        base.titleLabel!.font = UIFont.boldSystemFont(ofSize: ofSize)
        return self
    }
    
    /// 默认是NSLineBreakByTruncatingTail。用于单行和多行文本
    @discardableResult
    func lineBreakMode(_ breadMode: NSLineBreakMode) -> Self {
        base.titleLabel!.lineBreakMode = breadMode
        return self
    }
    
    /// layer 默认为nil(没有阴影)
    @discardableResult
    func shadowColor(_ color: UIColor?) -> Self {
        base.layer.shadowColor = color?.cgColor
        return self
    }
    
    /// layer 默认是CGSizeMake(0， -1)——一个顶部阴影
    @discardableResult
    func shadowOffset(_ size: CGSize) -> Self {
        base.layer.shadowOffset = size
        return self
    }
    
    /// layer 用于创建阴影的模糊半径。默认为3。可以做成动画。
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        base.layer.shadowRadius = radius
        return self
    }
    
    /// 设置文字行数
    @discardableResult
    func numberOfLines(_ number: Int) -> Self {
        base.titleLabel!.numberOfLines = number
        return self
    }
    
    /// 点击事件
    @discardableResult
    func addTarget(_ target: Any?, action: Selector,controlEvents: UIControl.Event) -> Self {
        base.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    /// Vertical 文本格式对齐
    @discardableResult
    func contentVerticalAlignment(_ alignment: UIControl.ContentVerticalAlignment) -> Self {
        base.contentVerticalAlignment = alignment
        return self
    }
    
    /// Horizon 文本格式对齐
    @discardableResult
    func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        base.contentHorizontalAlignment = alignment
        return self
    }
    
    /// 添加容器
    @discardableResult
    func addSubview(_ subView: UIView) -> Self {
        subView.addSubview(base)
        return self
    }
    
    /// 更改文字内边际
    @discardableResult
    func titleEdgeInsets(_ titleEdgeInsets: UIEdgeInsets) -> Self {
        base.titleEdgeInsets = titleEdgeInsets
        return self
    }
    
    /// 更改图片内边际
    @discardableResult
    func imageEdgeInsets(_ imageEdgeInsets: UIEdgeInsets) -> Self {
        base.imageEdgeInsets = imageEdgeInsets
        return self
    }
    
    /// 边际更改
    @discardableResult
    func contentEdgeInsets(_ contentEdgeInsets: UIEdgeInsets) -> Self {
        base.contentEdgeInsets = contentEdgeInsets
        return self
    }
    
    /// 默认是肯定的。如果是，图像在高亮(按下)时会画得更暗
    @discardableResult
    func adjustsImageWhenHighlighted(_ adjustsImageWhenHighlighted: Bool) -> Self {
        base.adjustsImageWhenHighlighted = adjustsImageWhenHighlighted
        return self
    }
    
    /// 默认是肯定的。如果是，图像绘制较浅时，禁用
    @discardableResult
    func adjustsImageWhenDisabled(_ adjustsImageWhenDisabled: Bool) -> Self {
        base.adjustsImageWhenDisabled = adjustsImageWhenDisabled
        return self
    }
    
    /// 默认是否定的。如果是，在突出显示时显示一个简单的反馈(当前是一个辉光)
    @discardableResult
    func showsTouchWhenHighlighted(_ showsTouchWhenHighlighted: Bool) -> Self {
        base.showsTouchWhenHighlighted = showsTouchWhenHighlighted
        return self
    }
    
    /// 阴影颜色
    @discardableResult
    func titleShadowColor(_ state: UIControl.State) -> Self {
        base.titleShadowColor(for: state)
        return self
    }
    
    /// 是否隐藏
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        base.isHidden = hidden
        return self
    }
    
    /// tintColor
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        base.tintColor = color
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
    
    /// 阴影的不透明。默认值为0。属性之外指定一个值 [0,1]范围将给出未定义的结果。可以做成动画。
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        base.layer.shadowOpacity = opacity
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

// MARK:- 三、UIButton 图片 与 title 位置关系
public extension TFY where Base: UIButton {
    /// 图片 和 title 的布局样式
    enum ImageTitleLayout {
        case imgTop
        case imgBottom
        case imgLeft
        case imgRight
    }
    
    // MARK: 3.1、设置图片和 title 的位置关系(提示：title和image要在设置布局关系之前设置)
    /// 设置图片和 title 的位置关系(提示：title和image要在设置布局关系之前设置)
    /// - Parameters:
    ///   - layout: 布局
    ///   - spacing: 间距
    /// - Returns: 返回自身
    @discardableResult
    func setImageTitleLayout(_ layout: ImageTitleLayout, spacing: CGFloat = 0) -> UIButton {
        switch layout {
        case .imgLeft:
            alignHorizontal(spacing: spacing, imageFirst: true)
        case .imgRight:
            alignHorizontal(spacing: spacing, imageFirst: false)
        case .imgTop:
            alignVertical(spacing: spacing, imageTop: true)
        case .imgBottom:
            alignVertical(spacing: spacing, imageTop: false)
        }
        return self.base
    }
    
    /// 水平方向
    /// - Parameters:
    ///   - spacing: 间距
    ///   - imageFirst: 图片是否优先
    private func alignHorizontal(spacing: CGFloat, imageFirst: Bool) {
        let edgeOffset = spacing / 2
        base.imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -edgeOffset,
                                       bottom: 0,
                                       right: edgeOffset)
        base.titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: edgeOffset,
                                       bottom: 0,
                                       right: -edgeOffset)
        if !imageFirst {
            base.transform = CGAffineTransform(scaleX: -1, y: 1)
            base.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            base.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset, bottom: 0, right: edgeOffset)
    }
    
    /// 垂直方向
    /// - Parameters:
    ///   - spacing: 间距
    ///   - imageTop: 图片是不是在顶部
    private func alignVertical(spacing: CGFloat, imageTop: Bool) {
        guard let imageSize = self.base.imageView?.image?.size,
              let text = self.base.titleLabel?.text,
              let font = self.base.titleLabel?.font
            else {
                return
        }
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let imageVerticalOffset = (titleSize.height + spacing) / 2
        let titleVerticalOffset = (imageSize.height + spacing) / 2
        let imageHorizontalOffset = (titleSize.width) / 2
        let titleHorizontalOffset = (imageSize.width) / 2
        let sign: CGFloat = imageTop ? 1 : -1
        
        base.imageEdgeInsets = UIEdgeInsets(top: -imageVerticalOffset * sign,
                                       left: imageHorizontalOffset,
                                       bottom: imageVerticalOffset * sign,
                                       right: -imageHorizontalOffset)
        base.titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * sign,
                                       left: -titleHorizontalOffset,
                                       bottom: -titleVerticalOffset * sign,
                                       right: titleHorizontalOffset)
        // increase content height to avoid clipping
        let edgeOffset = (min(imageSize.height, titleSize.height) + spacing) / 2
        base.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0, bottom: edgeOffset, right: 0)
    }
}


// MARK:- 六、Button扩大点击事件
private var ButtonExpandSizeKey = "ButtonExpandSizeKey"
public extension UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = self.tfy.expandRect()
        if (buttonRect.equalTo(bounds)) {
            return super.point(inside: point, with: event)
        }else{
            return buttonRect.contains(point)
        }
    }
    
}
public extension TFY where Base: UIButton {

    // MARK: 6.1、扩大UIButton的点击区域，向四周扩展10像素的点击范围
    /// 扩大UIButton的点击区域，向四周扩展10像素的点击范围
    /// - Parameter size: 向四周扩展像素的点击范围
    func expandSize(size: CGFloat) {
        objc_setAssociatedObject(self.base, &ButtonExpandSizeKey, size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    fileprivate func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self.base, &ButtonExpandSizeKey)
        if (expandSize != nil) {
            return CGRect(x: self.base.bounds.origin.x - (expandSize as! CGFloat), y: self.base.bounds.origin.y - (expandSize as! CGFloat), width: self.base.bounds.size.width + 2 * (expandSize as! CGFloat), height: self.base.bounds.size.height + 2 * (expandSize as! CGFloat))
        } else {
            return self.base.bounds
        }
    }
}
