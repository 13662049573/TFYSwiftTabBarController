//
//  TFYSwiftTabBarItemContentView.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarItemContentView实现
//  支持iOS 15+，适配iOS 26特性
//

import UIKit

// MARK: - 内容视图类
@available(iOS 15.0, *)
open class TFYSwiftTabBarItemContentView: UIView {
    
    // MARK: - 公开属性
    
    /// 图标视图
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// 标题标签
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// 徽章视图
    public let badgeView: TFYSwiftTabBarBadgeView = {
        let badgeView = TFYSwiftTabBarBadgeView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        return badgeView
    }()
    
    /// 是否选中
    public var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    /// 文字颜色
    public var textColor: UIColor = .label {
        didSet {
            updateAppearance()
        }
    }
    
    /// 选中文字颜色
    public var highlightTextColor: UIColor = .systemBlue {
        didSet {
            updateAppearance()
        }
    }
    
    /// 图标颜色
    public var iconColor: UIColor = .label {
        didSet {
            updateAppearance()
        }
    }
    
    /// 选中图标颜色
    public var highlightIconColor: UIColor = .systemBlue {
        didSet {
            updateAppearance()
        }
    }
    
    /// 高亮图标
    public var highlightImage: UIImage? {
        didSet {
            updateAppearance()
        }
    }
    
    /// 徽章偏移
    public var badgeOffset: UIOffset = UIOffset(horizontal: 6, vertical: -18) {
        didSet {
            updateBadgePosition()
        }
    }
    
    /// 是否启用iOS 26 Liquid Glass效果
    public var enableLiquidGlassEffect: Bool = true {  // 默认启用玻璃效果
        didSet {
            updateLiquidGlassEffect()
        }
    }
    
    /// 是否启用动态字体
    public var enableDynamicFont: Bool = true {
        didSet {
            updateDynamicFont()
        }
    }
    
    // MARK: - 私有属性
    
    private var liquidGlassView: UIVisualEffectView?
    
    // MARK: - 初始化
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - 设置方法
    
    private func setupView() {
        isUserInteractionEnabled = false
        
        // 添加子视图
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(badgeView)
        
        // 设置约束
        setupConstraints()
        
        // 设置初始外观
        updateAppearance()
        
        // 设置iOS 26特性
        if #available(iOS 26.0, *) {
            setupiOS26Features()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 图标约束
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4)
        ])
    }
    
    @available(iOS 26.0, *)
    private func setupiOS26Features() {
        if enableLiquidGlassEffect {
            setupLiquidGlassEffect()
        }
        
        if enableDynamicFont {
            setupDynamicFontSupport()
        }
    }
    
    @available(iOS 26.0, *)
    private func setupLiquidGlassEffect() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        liquidGlassView = blurView
        
        // 设置圆角
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    private func setupDynamicFontSupport() {
        // 监听动态字体变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
        
        updateDynamicFont()
    }
    
    @objc private func contentSizeCategoryDidChange() {
        updateDynamicFont()
    }
    
    private func updateDynamicFont() {
        guard enableDynamicFont else { return }
        let fontMetrics = UIFontMetrics.default
        titleLabel.font = fontMetrics.scaledFont(for: UIFont.systemFont(ofSize: 10))
    }
    
    // MARK: - 外观更新
    
    private func updateAppearance() {
        // 更新文字颜色
        titleLabel.textColor = isSelected ? highlightTextColor : textColor
        
        // 更新图标
        if isSelected, let highlightImage = highlightImage {
            imageView.image = highlightImage
        }
        
        // 更新图标颜色
        imageView.tintColor = isSelected ? highlightIconColor : iconColor
        
        // 更新徽章位置
        updateBadgePosition()
    }
    
    private func updateBadgePosition() {
        guard badgeView.superview != nil else { return }
        
        // 避免频繁更新，只在必要时更新
        guard !badgeView.isHidden else { return }
        
        let badgeSize = badgeView.sizeThatFits(bounds.size)
        
        // 如果徽章尺寸为0，说明没有内容，隐藏徽章
        guard badgeSize.width > 0 && badgeSize.height > 0 else {
            badgeView.isHidden = true
            return
        }
        
        // 徽章应该依附到图标的右上角
        let iconFrame = imageView.frame
        let badgeX = iconFrame.maxX + badgeOffset.horizontal - badgeSize.width * 0.5
        let badgeY = iconFrame.minY + badgeOffset.vertical
        
        // 确保徽章不超出边界
        let constrainedX = max(0, min(badgeX, bounds.width - badgeSize.width))
        let constrainedY = max(0, min(badgeY, bounds.height - badgeSize.height))
        
        badgeView.frame = CGRect(
            x: constrainedX,
            y: constrainedY,
            width: badgeSize.width,
            height: badgeSize.height
        )
        
        // 显示徽章
        badgeView.isHidden = false
        
        print("🔧 [TFYSwiftTabBarItemContentView] 徽章位置更新: x=\(constrainedX), y=\(constrainedY), size=\(badgeSize), iconFrame=\(iconFrame)")
    }
    
    private func updateLiquidGlassEffect() {
        if #available(iOS 26.0, *) {
            if enableLiquidGlassEffect {
                setupLiquidGlassEffect()
            } else {
                liquidGlassView?.removeFromSuperview()
                liquidGlassView = nil
                layer.cornerRadius = 0
                layer.masksToBounds = false
            }
        }
    }
    
    // MARK: - 动画方法
    
    open func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    self.transform = .identity
                }
                completion?()
            }
        } else {
        completion?()
        }
    }
    
    open func deselectAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            }) { _ in
        completion?()
    }
        } else {
        completion?()
        }
    }
    
    // MARK: - 布局更新
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateBadgePosition()
    }
    
    // MARK: - 清理
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
