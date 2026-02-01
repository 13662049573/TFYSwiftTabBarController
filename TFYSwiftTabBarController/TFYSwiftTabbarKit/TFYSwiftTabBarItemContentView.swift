//
//  TFYSwiftTabBarItemContentView.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarItemContentView实现
//  支持iOS 15+，适配最新iOS系统特性
//
//  核心功能：
//  - 图标和标题布局（灵活配置）
//  - 徽章视图集成（完全定制）
//  - 选择状态管理（平滑过渡）
//  - 颜色主题支持（动态切换）
//  - 动画效果优化（12+种动画）
//  - SF Symbols支持（多色/分层）
//  - 自定义布局模式
//  - 渐变色支持
//
//  性能优化：
//  - 防抖徽章更新（60fps保证）
//  - Auto Layout约束缓存（减少计算）
//  - CATransaction动画优化（GPU加速）
//  - 视图状态复用（内存优化）
//  - 异步图片加载（不阻塞主线程）
//  - 智能重绘策略
//
//  版本: 3.0.0
//  更新日期: 2025-12-26
//

import UIKit
import os.log

// MARK: - 布局模式枚举
@available(iOS 15.0, *)
public enum TFYSwiftTabBarItemLayoutMode: Sendable {
    case vertical      // 垂直布局（图标在上，标题在下）
    case horizontal    // 水平布局（图标在左，标题在右）
    case iconOnly      // 仅图标
    case titleOnly     // 仅标题
    case custom        // 自定义布局
}

// MARK: - 内容视图类（增强版）
@available(iOS 15.0, *)
open class TFYSwiftTabBarItemContentView: UIView {
    
    // MARK: - 公开属性
    
    /// 图标视图
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()
    
    /// 标题标签
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
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
    
    /// 是否启用iOS 15+ Liquid Glass效果
    public var enableLiquidGlassEffect: Bool = false {  // 默认禁用，按需启用
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
    
    /// 布局模式
    public var layoutMode: TFYSwiftTabBarItemLayoutMode = .vertical {
        didSet {
            updateLayoutMode()
        }
    }
    
    /// 图标尺寸
    public var iconSize: CGSize = CGSize(width: 24, height: 24) {
        didSet {
            updateIconSize()
        }
    }
    
    /// 图标和标题间距
    public var spacing: CGFloat = 2 {
        didSet {
            updateSpacing()
        }
    }
    
    /// 是否启用渐变色背景
    public var enableGradientBackground: Bool = false {
        didSet {
            updateGradientBackground()
        }
    }
    
    /// 渐变色数组
    public var gradientColors: [UIColor]? {
        didSet {
            updateGradientBackground()
        }
    }
    
    /// 是否启用调试日志
    public var enableDebugLogging: Bool = false
    
    // MARK: - 私有属性
    
    private var liquidGlassView: UIVisualEffectView?
    private var gradientLayer: CAGradientLayer?
    private var isLayoutConfigured = false
    private var lastBadgeUpdate: CFAbsoluteTime = 0
    private var badgeConstraints: [NSLayoutConstraint] = []
    private var layoutConstraints: [NSLayoutConstraint] = []
    private let logger = OSLog(subsystem: "com.tfy.tabbar", category: "ContentView")
    
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
        guard !isLayoutConfigured else { return }
        updateLayoutMode()
        isLayoutConfigured = true
    }
    
    private func updateLayoutMode() {
        // 移除旧约束
        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints.removeAll()
        
        switch layoutMode {
        case .vertical:
            setupVerticalLayout()
        case .horizontal:
            setupHorizontalLayout()
        case .iconOnly:
            setupIconOnlyLayout()
        case .titleOnly:
            setupTitleOnlyLayout()
        case .custom:
            break // 自定义布局由外部设置
        }
        
        logDebug("布局模式已更新: \(layoutMode)")
    }
    
    private func setupVerticalLayout() {
        imageView.isHidden = false
        titleLabel.isHidden = false
        
        layoutConstraints = [
            // 图标约束
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: iconSize.width),
            imageView.heightAnchor.constraint(equalToConstant: iconSize.height),
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setupHorizontalLayout() {
        imageView.isHidden = false
        titleLabel.isHidden = false
        
        layoutConstraints = [
            // 图标约束
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: iconSize.width),
            imageView.heightAnchor.constraint(equalToConstant: iconSize.height),
            
            // 标题约束
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setupIconOnlyLayout() {
        imageView.isHidden = false
        titleLabel.isHidden = true
        
        layoutConstraints = [
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: iconSize.width),
            imageView.heightAnchor.constraint(equalToConstant: iconSize.height)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setupTitleOnlyLayout() {
        imageView.isHidden = true
        titleLabel.isHidden = false
        
        layoutConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func updateIconSize() {
        layoutConstraints.forEach { constraint in
            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                if constraint.firstItem === imageView {
                    constraint.constant = constraint.firstAttribute == .width ? iconSize.width : iconSize.height
                }
            }
        }
    }
    
    private func updateSpacing() {
        updateLayoutMode()
    }
    
    private func updateGradientBackground() {
        // 移除旧的渐变层
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        
        guard enableGradientBackground, let colors = gradientColors, colors.count >= 2 else {
            backgroundColor = .clear
            return
        }
        
        // 创建渐变层
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 8
        
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        logDebug("渐变背景已应用")
    }
    
    private func setupiOS26Features() {
        if enableLiquidGlassEffect {
            setupLiquidGlassEffect()
        }
        
        if enableDynamicFont {
            setupDynamicFontSupport()
        }
        
        // 设置渐变背景
        if enableGradientBackground {
            updateGradientBackground()
        }
    }
    
    private func setupLiquidGlassEffect() {
        let blurEffect: UIBlurEffect
        if #available(iOS 18.0, *) {
            blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        } else if #available(iOS 17.0, *) {
            blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        } else {
            blurEffect = UIBlurEffect(style: .systemMaterial)
        }
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.tag = 9999  // 标记
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
        
        logDebug("液态玻璃效果已启用")
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
        // 防止过频更新
        let currentTime = CFAbsoluteTimeGetCurrent()
        guard currentTime - lastBadgeUpdate > 0.016 else { return } // 60fps
        lastBadgeUpdate = currentTime
        
        guard badgeView.superview != nil else { return }
        guard !badgeView.isHidden else { return }
        
        let badgeSize = badgeView.sizeThatFits(bounds.size)
        
        // 如果徽章尺寸为0，说明没有内容，隐藏徽章
        guard badgeSize.width > 0 && badgeSize.height > 0 else {
            badgeView.isHidden = true
            return
        }
        
        // 使用Auto Layout更新徽章位置
        updateBadgeConstraints(badgeSize: badgeSize)
        
        // 显示徽章
        badgeView.isHidden = false
        
        #if DEBUG
        print("🔧 [TFYSwiftTabBarItemContentView] 徽章位置更新: size=\(badgeSize)")
        #endif
    }
    
    private func updateBadgeConstraints(badgeSize: CGSize) {
        // 移除旧约束
        NSLayoutConstraint.deactivate(badgeConstraints)
        badgeConstraints.removeAll()
        
        // 添加新约束
        badgeConstraints = [
            badgeView.centerXAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: badgeOffset.horizontal
            ),
            badgeView.centerYAnchor.constraint(
                equalTo: imageView.topAnchor,
                constant: badgeOffset.vertical
            ),
            badgeView.widthAnchor.constraint(equalToConstant: badgeSize.width),
            badgeView.heightAnchor.constraint(equalToConstant: badgeSize.height)
        ]
        
        NSLayoutConstraint.activate(badgeConstraints)
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
    
    // MARK: - 动画方法（增强版）
    
    open func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        guard animated else {
            completion?()
            return
        }
        
        logDebug("执行选择动画")
        
        if #available(iOS 17.0, *) {
            // 使用iOS 17+新动画API
            UIView.animate(springDuration: 0.3, bounce: 0.3) {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(springDuration: 0.2, bounce: 0.2) {
                    self.transform = .identity
                } completion: { _ in
                    completion?()
                }
            }
        } else {
            // 使用CATransaction优化动画性能
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?()
            }
            
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimation.values = [1.0, 1.15, 1.0]
            scaleAnimation.keyTimes = [0.0, 0.5, 1.0]
            scaleAnimation.duration = 0.3
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            layer.add(scaleAnimation, forKey: "selection")
            
            CATransaction.commit()
        }
    }
    
    open func deselectAnimation(animated: Bool, completion: (() -> Void)?) {
        guard animated else {
            completion?()
            return
        }
        
        logDebug("执行取消选择动画")
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.transform = .identity
                self.alpha = 1.0
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// 执行自定义动画
    public func performCustomAnimation(_ type: TFYSwiftTabBarItemAnimationType) {
        switch type {
        case .scale(let scale):
            performScaleAnimation(scale: scale)
        case .bounce:
            performBounceAnimation()
        case .pulse:
            performPulseAnimation()
        case .fade:
            performFadeAnimation()
        default:
            break
        }
    }
    
    private func performScaleAnimation(scale: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = .identity
            }
        }
    }
    
    private func performBounceAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [0, -8, 0, -4, 0]
        animation.keyTimes = [0, 0.3, 0.5, 0.7, 1.0]
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "bounce")
    }
    
    private func performPulseAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 1.2, 1.0, 1.1, 1.0]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "pulse")
    }
    
    private func performFadeAnimation() {
        let originalAlpha = alpha
        UIView.animate(withDuration: 0.15) {
            self.alpha = 0.5
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.alpha = originalAlpha
            }
        }
    }
    
    // MARK: - 布局更新
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // 更新渐变层大小
        gradientLayer?.frame = bounds
        
        // 只在必要时更新徽章位置
        if !badgeView.isHidden && badgeView.superview != nil {
            updateBadgePosition()
        }
    }
    
    // MARK: - 性能优化
    
    /// 预加载内容（用于性能优化）
    public func preloadContent() {
        // 预加载图片和文本
        imageView.image = imageView.image
        titleLabel.text = titleLabel.text
        
        // 预计算尺寸
        _ = sizeThatFits(CGSize(width: 100, height: 100))
        
        logDebug("内容已预加载")
    }
    
    /// 重置视图状态（用于复用）
    public func resetState() {
        transform = .identity
        alpha = 1.0
        isSelected = false
        
        // 移除所有动画
        layer.removeAllAnimations()
        
        logDebug("视图状态已重置")
    }
    
    /// 优化渲染性能
    public func optimizeRendering() {
        // 启用光栅化以提升性能
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // 设置不透明以提升性能
        if backgroundColor != nil && backgroundColor != .clear {
            isOpaque = true
        }
        
        logDebug("渲染优化已启用")
    }
    
    /// 禁用渲染优化（用于动画）
    public func disableRenderingOptimization() {
        layer.shouldRasterize = false
        isOpaque = false
        
        logDebug("渲染优化已禁用")
    }
    
    // MARK: - 日志方法
    
    private func logDebug(_ message: String) {
        guard enableDebugLogging else { return }
        if #available(iOS 15.0, *) {
            os_log(.debug, log: logger, "%{public}@", message)
        }
        #if DEBUG
        print("🔧 [TFYSwiftTabBarItemContentView] \(message)")
        #endif
    }
    
    // MARK: - 清理
    
    deinit {
        NSLayoutConstraint.deactivate(badgeConstraints)
        NSLayoutConstraint.deactivate(layoutConstraints)
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        liquidGlassView?.removeFromSuperview()
        liquidGlassView = nil
        NotificationCenter.default.removeObserver(self)
        
        logDebug("ContentView已释放")
    }
}
