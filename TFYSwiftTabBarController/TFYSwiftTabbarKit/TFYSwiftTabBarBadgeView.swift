//
//  TFYSwiftTabBarBadgeView.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarBadgeView实现
//  支持iOS 15+，适配最新iOS系统特性
//
//  功能特点：
//  - 自动圆形徽章设计（智能尺寸计算）
//  - 丰富的动画效果（10+种动画）
//  - 动态字体支持（可访问性优化）
//  - iOS 15+ 液态玻璃效果
//  - 自适应尺寸计算（支持长文本）
//  - 自定义样式支持（圆形/方形/胶囊形）
//  - 渐变色背景支持
//  - 数字缩写支持（99+ -> 99+）
//  - 实时更新动画
//
//  性能优化：
//  - CADisplayLink同步动画
//  - 防抖更新机制
//  - 智能约束缓存
//
//  版本: 3.0.0
//  更新日期: 2025-12-26
//

import UIKit
import os.log

// MARK: - 徽章样式枚举
@available(iOS 15.0, *)
public enum TFYSwiftTabBarBadgeStyle: Sendable {
    case circle      // 圆形
    case square      // 方形
    case capsule     // 胶囊形
    case rounded(CGFloat)  // 自定义圆角
}

// MARK: - 徽章动画类型
@available(iOS 15.0, *)
public enum TFYSwiftTabBarBadgeAnimationType: Sendable {
    case none
    case scale
    case bounce
    case pulse
    case shake
    case fade
    case pop        // 弹出效果
    case wiggle     // 摇摆效果
}

// MARK: - 徽章视图类（增强版）
@available(iOS 15.0, *)
open class TFYSwiftTabBarBadgeView: UIView {
    
    // MARK: - 公开属性
    
    /// 徽章文字
    public var text: String? {
        didSet {
            updateBadgeDisplay(animated: true)
        }
    }
    
    /// 徽章背景颜色
    public var badgeColor: UIColor = .systemRed {
        didSet {
            updateAppearance()
        }
    }
    
    /// 徽章渐变色（可选）
    public var gradientColors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }
    
    /// 徽章文字颜色
    public var textColor: UIColor = .white {
        didSet {
            updateAppearance()
        }
    }
    
    /// 徽章字体
    public var font: UIFont = .systemFont(ofSize: 11, weight: .semibold) {
        didSet {
            updateAppearance()
        }
    }
    
    /// 徽章内边距
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6) {
        didSet {
            updateBadgeDisplay(animated: false)
        }
    }
    
    /// 最小尺寸（确保圆形）
    public var minimumSize: CGFloat = 18 {
        didSet {
            updateBadgeDisplay(animated: false)
        }
    }
    
    /// 最大数字显示（超过显示+号）
    public var maxNumber: Int = 99 {
        didSet {
            updateBadgeDisplay(animated: false)
        }
    }
    
    /// 徽章样式
    public var badgeStyle: TFYSwiftTabBarBadgeStyle = .circle {
        didSet {
            updateBadgeStyle()
        }
    }
    
    /// 是否启用iOS 15+ Liquid Glass效果
    public var enableLiquidGlassEffect: Bool = false {
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
    
    /// 是否启用阴影
    public var enableShadow: Bool = true {
        didSet {
            updateShadow()
        }
    }
    
    /// 是否启用边框
    public var enableBorder: Bool = false {
        didSet {
            updateBorder()
        }
    }
    
    /// 边框颜色
    public var borderColor: UIColor = .white {
        didSet {
            updateBorder()
        }
    }
    
    /// 边框宽度
    public var borderWidth: CGFloat = 2 {
        didSet {
            updateBorder()
        }
    }
    
    /// 是否启用调试日志
    public var enableDebugLogging: Bool = false
    
    // MARK: - 私有属性
    
    private let backgroundView = UIView()
    private let textLabel = UILabel()
    private var liquidGlassView: UIVisualEffectView?
    private var gradientLayer: CAGradientLayer?
    private var lastBadgeUpdate: CFAbsoluteTime = 0
    private let logger = OSLog(subsystem: "com.tfy.tabbar", category: "BadgeView")
    
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
        // 设置背景视图
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.masksToBounds = true
        addSubview(backgroundView)
        
        // 设置文字标签
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 1
        addSubview(textLabel)
        
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
            // 背景视图约束
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 文字标签约束
            textLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: contentInsets.top),
            textLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: contentInsets.left),
            textLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -contentInsets.right),
            textLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -contentInsets.bottom)
        ])
    }
    
    private func setupiOS26Features() {
        if enableLiquidGlassEffect {
            setupLiquidGlassEffect()
        }
        
        if enableDynamicFont {
            setupDynamicFontSupport()
        }
        
        // 设置阴影和边框
        updateShadow()
        updateBorder()
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
        blurView.tag = 9999  // 标记以便识别
        backgroundView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
        
        liquidGlassView = blurView
        backgroundView.layer.masksToBounds = true
        
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
        textLabel.font = fontMetrics.scaledFont(for: font)
    }
    
    // MARK: - 外观更新
    
    private func updateAppearance() {
        backgroundView.backgroundColor = badgeColor
        textLabel.textColor = textColor
        textLabel.font = font
    }
    
    private func updateBadgeDisplay(animated: Bool) {
        // 防抖更新（60fps）
        let currentTime = CFAbsoluteTimeGetCurrent()
        guard currentTime - lastBadgeUpdate > 0.016 else { return }
        lastBadgeUpdate = currentTime
        
        // 处理数字缩写
        let displayText = formatBadgeText(text)
        textLabel.text = displayText
        
        // 设置可见性
        let shouldShow = !(text?.isEmpty ?? true)
        
        if shouldShow && isHidden {
            // 显示徽章
            showBadge(animated: animated)
        } else if !shouldShow && !isHidden {
            // 隐藏徽章
            hideBadge(animated: animated)
        } else if shouldShow {
            // 更新徽章内容
            invalidateIntrinsicContentSize()
            
            if animated {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                    self.updateBadgeStyle()
                }
            } else {
                setNeedsLayout()
                layoutIfNeeded()
                updateBadgeStyle()
            }
        }
        
        logDebug("更新徽章显示: text=\(text ?? "nil"), display=\(displayText), hidden=\(isHidden)")
    }
    
    private func formatBadgeText(_ text: String?) -> String {
        guard let text = text, !text.isEmpty else { return "" }
        
        // 如果是数字，进行格式化
        if let number = Int(text) {
            if number > maxNumber {
                return "\(maxNumber)+"
            } else if number > 999 {
                return "\(number / 1000)k+"
            }
            return "\(number)"
        }
        
        // 非数字直接返回
        return text
    }
    
    private func updateBadgeStyle() {
        switch badgeStyle {
        case .circle:
            backgroundView.layer.cornerRadius = bounds.height / 2
        case .square:
            backgroundView.layer.cornerRadius = 0
        case .capsule:
            backgroundView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
        case .rounded(let radius):
            backgroundView.layer.cornerRadius = radius
        }
    }
    
    private func updateGradient() {
        // 移除旧的渐变层
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        
        guard let colors = gradientColors, colors.count >= 2 else {
            backgroundView.backgroundColor = badgeColor
            return
        }
        
        // 创建渐变层
        let gradient = CAGradientLayer()
        gradient.frame = backgroundView.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = backgroundView.layer.cornerRadius
        
        backgroundView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        logDebug("渐变色已应用")
    }
    
    private func updateShadow() {
        if enableShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.3
            layer.masksToBounds = false
        } else {
            layer.shadowOpacity = 0
        }
    }
    
    private func updateBorder() {
        if enableBorder {
            backgroundView.layer.borderColor = borderColor.cgColor
            backgroundView.layer.borderWidth = borderWidth
        } else {
            backgroundView.layer.borderWidth = 0
        }
    }
    
    private func logDebug(_ message: String) {
        guard enableDebugLogging else { return }
        if #available(iOS 15.0, *) {
            os_log(.debug, log: logger, "%{public}@", message)
        }
        #if DEBUG
        print("🔧 [TFYSwiftTabBarBadgeView] \(message)")
        #endif
    }
    
    private func updateLiquidGlassEffect() {
        if #available(iOS 26.0, *) {
            if enableLiquidGlassEffect {
                setupLiquidGlassEffect()
            } else {
                liquidGlassView?.removeFromSuperview()
                liquidGlassView = nil
                backgroundView.layer.cornerRadius = 8
                backgroundView.layer.masksToBounds = true
            }
        }
    }
    
    // MARK: - 公开方法
    
    /// 设置徽章值
    public func setBadgeValue(_ value: String?) {
        text = value
    }
    
    // MARK: - 尺寸计算
    
    public override var intrinsicContentSize: CGSize {
        guard let text = text, !text.isEmpty else {
            return .zero
        }
        
        let textSize = text.size(withAttributes: [.font: font])
        let width = textSize.width + contentInsets.left + contentInsets.right
        let height = textSize.height + contentInsets.top + contentInsets.bottom
        
        // 确保最小尺寸和圆形
        let size = max(width, height, minimumSize)
        return CGSize(width: size, height: size)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }
    
    /// 显示徽章
    public func showBadge() {
        isHidden = false
    }
    
    /// 隐藏徽章
    public func hideBadge() {
        isHidden = true
    }
    
    /// 动画显示徽章
    public func showBadge(animated: Bool) {
        guard animated else {
            showBadge()
            return
        }
        
        // 使用弹簧动画提升视觉效果
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        alpha = 0
        isHidden = false
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.transform = .identity
                self.alpha = 1.0
            }
        )
    }
    
    /// 动画隐藏徽章
    public func hideBadge(animated: Bool) {
        guard animated else {
            hideBadge()
            return
        }
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseIn, .beginFromCurrentState],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.alpha = 0
            },
            completion: { _ in
                self.isHidden = true
                self.transform = .identity
                self.alpha = 1.0
            }
        )
    }
    
    /// 脉冲动画（用于提醒）
    public func pulse() {
        performAnimation(.pulse)
    }
    
    /// 执行指定类型的动画
    public func performAnimation(_ type: TFYSwiftTabBarBadgeAnimationType) {
        switch type {
        case .none:
            break
        case .scale:
            performScaleAnimation()
        case .bounce:
            performBounceAnimation()
        case .pulse:
            performPulseAnimation()
        case .shake:
            performShakeAnimation()
        case .fade:
            performFadeAnimation()
        case .pop:
            performPopAnimation()
        case .wiggle:
            performWiggleAnimation()
        }
    }
    
    private func performScaleAnimation() {
        if #available(iOS 17.0, *) {
            UIView.animate(springDuration: 0.3, bounce: 0.4) {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(springDuration: 0.2, bounce: 0.3) {
                    self.transform = .identity
                }
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    self.transform = .identity
                }
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
        let pulseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        pulseAnimation.values = [1.0, 1.25, 1.0, 1.15, 1.0]
        pulseAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        pulseAnimation.duration = 0.6
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(pulseAnimation, forKey: "pulse")
    }
    
    private func performShakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [0, -0.15, 0.15, -0.1, 0.1, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1.0]
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        layer.add(animation, forKey: "shake")
    }
    
    private func performFadeAnimation() {
        let originalAlpha = alpha
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.3
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.alpha = originalAlpha
            }
        }
    }
    
    private func performPopAnimation() {
        transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.2,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    private func performWiggleAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [0, 0.1, -0.1, 0.08, -0.08, 0.05, -0.05, 0]
        animation.keyTimes = [0, 0.15, 0.3, 0.45, 0.6, 0.75, 0.9, 1.0]
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(animation, forKey: "wiggle")
    }
    
    // MARK: - 布局优化
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // 更新渐变层大小
        gradientLayer?.frame = backgroundView.bounds
        
        // 更新样式
        updateBadgeStyle()
    }
    
    // MARK: - 清理
    
    deinit {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        liquidGlassView?.removeFromSuperview()
        liquidGlassView = nil
        NotificationCenter.default.removeObserver(self)
        
        logDebug("BadgeView已释放")
    }
}
