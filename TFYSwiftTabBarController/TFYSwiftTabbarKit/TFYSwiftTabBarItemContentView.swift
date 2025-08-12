//
//  TFYSwiftTabBarItemContentView.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2022/5/4.
//

import UIKit

// MARK: - Enums
public enum TFYSwiftTabBarItemContentMode: Int {
    case alwaysOriginal // 始终设置原始图像的大小
    case alwaysTemplate // 始终将图像设置为模板图像大小
}

// MARK: - TFYSwiftTabBarItemContentView
/// TabBarItem的内容视图，支持高度自定义
open class TFYSwiftTabBarItemContentView: UIView {
    
    // MARK: - Properties
    
    /// 项目上显示的标题，默认为' nil '
    open var tabbarTitle: String? {
        didSet {
            self.titleLabel.text = tabbarTitle
            self.updateLayout()
        }
    }
    
    /// 用于表示项目的图像，默认为' nil '
    open var image: UIImage? {
        didSet {
            if !selected { self.updateDisplay() }
        }
    }
    
    /// 当选项卡栏项被选中时显示的图像，默认为' nil '
    open var selectedImage: UIImage? {
        didSet {
            if selected { self.updateDisplay() }
        }
    }
    
    /// 一个布尔值，指示该项是否启用，默认为"YES"
    open var enabled = true
    
    /// 一个布尔值，指示项目是否被选中，默认为"NO"
    open var selected = false
    
    /// 一个布尔值，指示项目是否高亮显示，默认为"NO"
    open var highlighted = false
    
    /// 文本颜色，默认为' UIColor(白色:0.57254902,alpha: 1.0) '
    open var textColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected { titleLabel.textColor = textColor }
        }
    }
    
    /// 文本颜色高亮显示时，默认为' UIColor(红色:0.0，绿色:0.47843137，蓝色:1.0,alpha: 1.0) '
    open var highlightTextColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected { titleLabel.textColor = highlightTextColor }
        }
    }
    
    /// 图标颜色，默认为"UIColor(白色:0.57254902,alpha: 1.0)"
    open var iconColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected { imageView.tintColor = iconColor }
        }
    }
    
    /// 图标颜色高亮显示时，默认为"UIColor(红色:0.0，绿色:0.47843137，蓝色:1.0,alpha: 1.0)"
    open var highlightIconColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected { imageView.tintColor = highlightIconColor }
        }
    }
    
    /// 背景颜色，默认为' uiccolor .clear '
    open var backdropColor = UIColor.clear {
        didSet {
            if !selected { backgroundColor = backdropColor }
        }
    }
    
    /// 背景颜色被突出显示时，默认为' UIColor.clear '
    open var highlightBackdropColor = UIColor.clear {
        didSet {
            if selected { backgroundColor = highlightBackdropColor }
        }
    }
    
    /// 图标imageView renderingMode，默认为' . alwaystemplate '
    open var renderingMode: UIImage.RenderingMode = .alwaysTemplate {
        didSet {
            self.updateDisplay()
        }
    }
    
    /// 项目内容模式，默认为' .alwaysTemplate '
    open var itemContentMode: TFYSwiftTabBarItemContentMode = .alwaysTemplate {
        didSet {
            self.updateDisplay()
        }
    }
    
    /// 用于调整标题位置的偏移量，默认为' UIOffset.zero '
    open var titlePositionAdjustment: UIOffset = UIOffset.zero {
        didSet {
            self.updateLayout()
        }
    }
    
    /// 你用来确定内容的insets边缘的insets，默认为' uiedgeinsets。zero '
    open var insets = UIEdgeInsets.zero {
        didSet {
            self.updateLayout()
        }
    }
    
    /// 图像视图
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    /// 标题标签
    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .clear
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    /// 徽章值，默认为' nil '
    open var badgeValue: String? {
        didSet {
            if let _ = badgeValue {
                self.badgeView.badgeValue = badgeValue
                self.addSubview(badgeView)
                self.updateLayout()
            } else {
                // Remove when nil.
                self.badgeView.removeFromSuperview()
            }
            badgeChanged(animated: true, completion: nil)
        }
    }
    
    /// 徽章颜色，默认为' nil '
    open var badgeColor: UIColor? {
        didSet {
            if let _ = badgeColor {
                self.badgeView.badgeColor = badgeColor
            } else {
                self.badgeView.badgeColor = TFYSwiftTabBarBadgeView.defaultBadgeColor
            }
        }
    }
    
    /// Badge视图，默认为' TFYSwiftTabBarBadgeView() '
    open var badgeView: TFYSwiftTabBarBadgeView = TFYSwiftTabBarBadgeView() {
        willSet {
            if let _ = badgeView.superview {
                badgeView.removeFromSuperview()
            }
        }
        didSet {
            if let _ = badgeView.superview {
                self.updateLayout()
            }
        }
    }
    
    /// Badge offset, default is `UIOffset(horizontal: 6.0, vertical: -22.0)`
    open var badgeOffset: UIOffset = UIOffset(horizontal: 6.0, vertical: -22.0) {
        didSet {
            if badgeOffset != oldValue {
                self.updateLayout()
            }
        }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        self.isUserInteractionEnabled = false
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        titleLabel.textColor = textColor
        imageView.tintColor = iconColor
        backgroundColor = backdropColor
    }
    
    // MARK: - Public Methods
    
    open func updateDisplay() {
        imageView.image = (selected ? (selectedImage ?? image) : image)?.withRenderingMode(renderingMode)
        imageView.tintColor = selected ? highlightIconColor : iconColor
        titleLabel.textColor = selected ? highlightTextColor : textColor
        backgroundColor = selected ? highlightBackdropColor : backdropColor
    }
    
    open func updateLayout() {
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        
        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)
        
        if self.itemContentMode == .alwaysTemplate {
            layoutWithTemplateMode(width: w, height: h)
        } else {
            layoutWithOriginalMode(width: w, height: h)
        }
    }
    
    private func layoutWithTemplateMode(width: CGFloat, height: CGFloat) {
        let (imageSize, fontSize) = getImageAndFontSize()
        let isWide = isLandscapeOrRegular()
        
        if !imageView.isHidden && !titleLabel.isHidden {
            layoutImageAndTitle(width: width, height: height, imageSize: imageSize, fontSize: fontSize, isWide: isWide)
        } else if !imageView.isHidden {
            layoutImageOnly(width: width, height: height, imageSize: imageSize)
        } else if !titleLabel.isHidden {
            layoutTitleOnly(width: width, height: height, fontSize: fontSize)
        }
        
        layoutBadgeView(width: width, height: height, isWide: isWide)
    }
    
    private func layoutWithOriginalMode(width: CGFloat, height: CGFloat) {
        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.sizeToFit()
            imageView.sizeToFit()
            titleLabel.frame = CGRect(x: (width - titleLabel.bounds.size.width) / 2.0 + titlePositionAdjustment.horizontal,
                                     y: height - titleLabel.bounds.size.height - 1.0 + titlePositionAdjustment.vertical,
                                     width: titleLabel.bounds.size.width,
                                     height: titleLabel.bounds.size.height)
            imageView.frame = CGRect(x: (width - imageView.bounds.size.width) / 2.0,
                                    y: (height - imageView.bounds.size.height) / 2.0 - 6.0,
                                    width: imageView.bounds.size.width,
                                    height: imageView.bounds.size.height)
        } else if !imageView.isHidden {
            imageView.sizeToFit()
            imageView.center = CGPoint(x: width / 2.0, y: height / 2.0)
        } else if !titleLabel.isHidden {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0)
        }
        
        layoutBadgeView(width: width, height: height, isWide: false)
    }
    
    private func getImageAndFontSize() -> (CGFloat, CGFloat) {
        let isWide = isLandscapeOrRegular()
        let imageSize: CGFloat
        let fontSize: CGFloat
        
        if #available(iOS 11.0, *), isWide {
            imageSize = UIScreen.main.scale == 3.0 ? 23.0 : 20.0
            fontSize = UIScreen.main.scale == 3.0 ? 13.0 : 12.0
        } else {
            imageSize = 23.0
            fontSize = 10.0
        }
        
        return (imageSize, fontSize)
    }
    
    private func isLandscapeOrRegular() -> Bool {
        var keyWindow: UIWindow?
        keyWindow = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first
        
        let isLandscape = keyWindow?.bounds.width ?? 0 > keyWindow?.bounds.height ?? 0
        return isLandscape || traitCollection.horizontalSizeClass == .regular
    }
    
    private func layoutImageAndTitle(width: CGFloat, height: CGFloat, imageSize: CGFloat, fontSize: CGFloat, isWide: Bool) {
        titleLabel.font = UIFont.systemFont(ofSize: fontSize)
        titleLabel.sizeToFit()
        
        if #available(iOS 11.0, *), isWide {
            let horizontalOffset = UIScreen.main.scale == 3.0 ? 14.25 : 12.25
            let imageOffset = UIScreen.main.scale == 3.0 ? 6.0 : 5.0
            
            titleLabel.frame = CGRect(x: (width - titleLabel.bounds.size.width) / 2.0 + horizontalOffset + titlePositionAdjustment.horizontal,
                                     y: (height - titleLabel.bounds.size.height) / 2.0 + titlePositionAdjustment.vertical,
                                     width: titleLabel.bounds.size.width,
                                     height: titleLabel.bounds.size.height)
            imageView.frame = CGRect(x: titleLabel.frame.origin.x - imageSize - imageOffset,
                                    y: (height - imageSize) / 2.0,
                                    width: imageSize,
                                    height: imageSize)
        } else {
            titleLabel.frame = CGRect(x: (width - titleLabel.bounds.size.width) / 2.0 + titlePositionAdjustment.horizontal,
                                     y: height - titleLabel.bounds.size.height - 1.0 + titlePositionAdjustment.vertical,
                                     width: titleLabel.bounds.size.width,
                                     height: titleLabel.bounds.size.height)
            imageView.frame = CGRect(x: (width - imageSize) / 2.0,
                                    y: (height - imageSize) / 2.0 - 6.0,
                                    width: imageSize,
                                    height: imageSize)
        }
    }
    
    private func layoutImageOnly(width: CGFloat, height: CGFloat, imageSize: CGFloat) {
        imageView.frame = CGRect(x: (width - imageSize) / 2.0,
                                y: (height - imageSize) / 2.0,
                                width: imageSize,
                                height: imageSize)
    }
    
    private func layoutTitleOnly(width: CGFloat, height: CGFloat, fontSize: CGFloat) {
        titleLabel.font = UIFont.systemFont(ofSize: fontSize)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: (width - titleLabel.bounds.size.width) / 2.0 + titlePositionAdjustment.horizontal,
                                 y: (height - titleLabel.bounds.size.height) / 2.0 + titlePositionAdjustment.vertical,
                                 width: titleLabel.bounds.size.width,
                                 height: titleLabel.bounds.size.height)
    }
    
    private func layoutBadgeView(width: CGFloat, height: CGFloat, isWide: Bool) {
        guard let _ = badgeView.superview else { return }
        
        let size = badgeView.sizeThatFits(self.frame.size)
        if #available(iOS 11.0, *), isWide {
            badgeView.frame = CGRect(origin: CGPoint(x: imageView.frame.midX - 3 + badgeOffset.horizontal,
                                                     y: imageView.frame.midY + 3 + badgeOffset.vertical),
                                    size: size)
        } else {
            badgeView.frame = CGRect(origin: CGPoint(x: width / 2.0 + badgeOffset.horizontal,
                                                     y: height / 2.0 + badgeOffset.vertical),
                                    size: size)
        }
        badgeView.setNeedsLayout()
    }
    
    // MARK: - Internal Methods
    
    internal final func select(animated: Bool, completion: (() -> Void)?) {
        selected = true
        if enabled && highlighted {
            highlighted = false
            dehighlightAnimation(animated: animated, completion: { [weak self] in
                self?.updateDisplay()
                self?.selectAnimation(animated: animated, completion: completion)
            })
        } else {
            updateDisplay()
            selectAnimation(animated: animated, completion: completion)
        }
    }
    
    internal final func deselect(animated: Bool, completion: (() -> Void)?) {
        selected = false
        updateDisplay()
        self.deselectAnimation(animated: animated, completion: completion)
    }
    
    internal final func reselect(animated: Bool, completion: (() -> Void)?) {
        if selected == false {
            select(animated: animated, completion: completion)
        } else {
            if enabled && highlighted {
                highlighted = false
                dehighlightAnimation(animated: animated, completion: { [weak self] in
                    self?.reselectAnimation(animated: animated, completion: completion)
                })
            } else {
                reselectAnimation(animated: animated, completion: completion)
            }
        }
    }
    
    internal final func highlight(animated: Bool, completion: (() -> Void)?) {
        if !enabled || highlighted == true { return }
        highlighted = true
        self.highlightAnimation(animated: animated, completion: completion)
    }
    
    internal final func dehighlight(animated: Bool, completion: (() -> Void)?) {
        if !enabled || !highlighted { return }
        highlighted = false
        self.dehighlightAnimation(animated: animated, completion: completion)
    }
    
    internal func badgeChanged(animated: Bool, completion: (() -> Void)?) {
        self.badgeChangedAnimation(animated: animated, completion: completion)
    }
    
    // MARK: - Animation Methods
    
    open func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func deselectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func reselectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func highlightAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func dehighlightAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func badgeChangedAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
}
