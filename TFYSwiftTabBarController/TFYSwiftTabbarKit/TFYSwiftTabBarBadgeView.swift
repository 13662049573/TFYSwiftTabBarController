//
//  TFYSwiftTabBarBadgeView.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarBadgeView实现
//  支持iOS 15+，适配iOS 26特性
//

import UIKit

// MARK: - 徽章视图类
@available(iOS 15.0, *)
open class TFYSwiftTabBarBadgeView: UIView {
    
    // MARK: - 公开属性
    
    /// 徽章文字
    public var text: String? {
        didSet {
            updateBadgeDisplay()
        }
    }
    
    /// 徽章背景颜色
    public var badgeColor: UIColor = .systemRed {
        didSet {
            updateAppearance()
        }
    }
    
    /// 徽章文字颜色
    public var textColor: UIColor = .white {
        didSet {
            updateAppearance()
        }
    }
    
    /// 徽章字体
    public var font: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium) {
        didSet {
            updateAppearance()
        }
    }
    
    /// 徽章内边距
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6) {
        didSet {
            updateBadgeDisplay()
        }
    }
    
    /// 最小宽度
    public var minimumWidth: CGFloat = 16 {
        didSet {
            updateBadgeDisplay()
        }
    }
    
    /// 是否启用iOS 26 Liquid Glass效果
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
    
    // MARK: - 私有属性
    
    private let backgroundView = UIView()
    private let textLabel = UILabel()
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
        // 设置背景视图
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 8
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
        backgroundView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
        
        liquidGlassView = blurView
        
        // 设置圆角
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.masksToBounds = true
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
    
    private func updateBadgeDisplay() {
        textLabel.text = text
        
        // 设置可见性
        let shouldShow = !(text?.isEmpty ?? true)
        isHidden = !shouldShow
        
        if shouldShow {
            // 强制更新布局
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
        
        print("🔧 [TFYSwiftTabBarBadgeView] 更新徽章显示: text=\(text ?? "nil"), hidden=\(isHidden)")
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
            return CGSize.zero
        }
        
        let textSize = text.size(withAttributes: [.font: font])
        let width = textSize.width + contentInsets.left + contentInsets.right
        let height = textSize.height + contentInsets.top + contentInsets.bottom
        
        // 确保最小尺寸
        let minSize: CGFloat = 16
        return CGSize(
            width: max(width, minSize),
            height: max(height, minSize)
        )
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
        if animated {
            transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            isHidden = false
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        } else {
            showBadge()
        }
    }
    
    /// 动画隐藏徽章
    public func hideBadge(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { _ in
                self.isHidden = true
                self.transform = .identity
            }
        } else {
            hideBadge()
        }
    }
    
    // MARK: - 清理
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
