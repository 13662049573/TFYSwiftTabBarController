//
//  TFYSwiftTabBarItem.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit

// MARK: - TFYSwiftTabBarItem
/// 自定义TabBarItem，支持高度自定义
open class TFYSwiftTabBarItem: UITabBarItem {
    
    // MARK: - Properties
    
    /// 自定义内容视图，默认是' TFYSwiftTabBarItemContentView '
    open var contentView: TFYSwiftTabBarItemContentView = TFYSwiftTabBarItemContentView() {
        didSet {
            self.contentView.updateLayout()
            self.contentView.updateDisplay()
        }
    }
    
    // MARK: - Override Properties
    
    /// 接收者的标记，一个应用程序提供的整数，您可以使用它来标识应用程序中的栏项对象。默认是"0"
    open override var tag: Int {
        didSet { self.contentView.tag = tag }
    }
    
    /// 一个布尔值，指示该项是否启用，默认为"YES"
    open override var isEnabled: Bool {
        didSet { self.contentView.enabled = isEnabled }
    }
    
    /// 用于表示项目的图像，默认为' nil '
    open override var image: UIImage? {
        didSet { self.contentView.image = image }
    }
    
    /// 当选项卡栏项被选中时显示的图像，默认为' nil '
    open override var selectedImage: UIImage? {
        get { return contentView.selectedImage }
        set(newValue) { contentView.selectedImage = newValue }
    }
    
    /// 文本显示在项目的右上角，周围有一个红色椭圆，默认为"nil"
    open override var badgeValue: String? {
        get { return contentView.badgeValue }
        set(newValue) { contentView.badgeValue = newValue }
    }
    
    /// 用于调整标题位置的偏移量，默认为' UIOffset.zero '
    open override var titlePositionAdjustment: UIOffset {
        get { return contentView.titlePositionAdjustment }
        set(newValue) { contentView.titlePositionAdjustment = newValue }
    }
    
    /// 应用到徽章的背景颜色，使其适用于iOS8.0和更高版本
    open override var badgeColor: UIColor? {
        get { return contentView.badgeColor }
        set(newValue) { contentView.badgeColor = newValue }
    }
    
    // MARK: - Initialization
    
    /// 未选中的图像是由image参数自动生成的。如果提供了，则从selectedImage自动生成所选图像，否则从image参数自动生成。为了防止系统着色，使用uiimagerenderingmodealwayoriginal提供图像(参见UIImage.h)
    public init(_ contentView: TFYSwiftTabBarItemContentView = TFYSwiftTabBarItemContentView(), title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, tag: Int = 0) {
        super.init()
        self.contentView = contentView
        self.contentView.tabbarTitle = title
        self.contentView.image = image
        self.contentView.selectedImage = selectedImage
        self.contentView.tag = tag
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
