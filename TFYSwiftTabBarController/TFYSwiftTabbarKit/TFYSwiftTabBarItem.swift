//
//  TFYSwiftTabBarItem.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarItem实现
//  支持iOS 15+，适配最新iOS系统特性
//
//  功能特点：
//  - 自定义内容视图（完全可定制）
//  - 灵活的动画配置（12+种动画）
//  - 弹簧动画参数调节（精确控制）
//  - 完整的选择/取消选择动画
//  - SF Symbols 5.0支持
//  - 自定义徽章样式
//  - 状态回调机制
//  - 可访问性优化
//
//  版本: 3.0.0
//  更新日期: 2025-12-26
//

import UIKit
import os.log

// MARK: - 自定义TabBarItem（增强版）
@available(iOS 15.0, *)
open class TFYSwiftTabBarItem: UITabBarItem {
    
    // MARK: - 公开属性
    
    /// 自定义内容视图
    public let contentView: TFYSwiftTabBarItemContentView
    
    /// 是否启用动画
    public var enableAnimation: Bool = true
    
    /// 动画持续时间
    public var animationDuration: TimeInterval = 0.25
    
    /// 动画类型
    public var animationType: TFYSwiftTabBarItemAnimationType = .scale()
    
    /// 动画弹簧阻尼
    public var springDamping: CGFloat = 0.7
    
    /// 动画初始速度
    public var springVelocity: CGFloat = 0.5
    
    /// 是否启用触觉反馈
    public var enableHapticFeedback: Bool = true
    
    /// 触觉反馈样式
    public var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
    
    /// 选择状态回调
    public var onSelect: ((TFYSwiftTabBarItem) -> Void)?
    
    /// 取消选择状态回调
    public var onDeselect: ((TFYSwiftTabBarItem) -> Void)?
    
    /// 是否启用调试日志
    public var enableDebugLogging: Bool = false
    
    // MARK: - 私有属性
    
    private let logger = OSLog(subsystem: "com.tfy.tabbar", category: "TabBarItem")
    private var impactGenerator: UIImpactFeedbackGenerator?
    
    // MARK: - 初始化
    
    public init(contentView: TFYSwiftTabBarItemContentView, title: String?, image: UIImage?, selectedImage: UIImage? = nil) {
        self.contentView = contentView
        super.init()
        
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        
        setupContentView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置方法
    
    private func setupContentView() {
        contentView.titleLabel.text = title
        contentView.imageView.image = image
        contentView.highlightImage = selectedImage
        
        // 设置可访问性
        setupAccessibility()
        
        // 初始化触觉反馈生成器
        if enableHapticFeedback {
            setupHapticGenerator()
        }
        
        logDebug("内容视图已设置")
    }
    
    private func setupAccessibility() {
        accessibilityLabel = title
        accessibilityHint = "点击选择\(title ?? "")选项卡"
        accessibilityTraits = .button
    }
    
    private func setupHapticGenerator() {
        impactGenerator = UIImpactFeedbackGenerator(style: hapticStyle)
        impactGenerator?.prepare()
    }
    
    // MARK: - 动画方法（增强版）
    
    public func select(animated: Bool, completion: (() -> Void)? = nil) {
        logDebug("选择项目: \(title ?? "未知")")
        
        // 触觉反馈
        if enableHapticFeedback {
            impactGenerator?.impactOccurred()
        }
        
        // 执行动画
        if animated && enableAnimation {
            contentView.selectAnimation(animated: true) { [weak self] in
                self?.onSelect?(self!)
                completion?()
            }
        } else {
            contentView.selectAnimation(animated: false) { [weak self] in
                self?.onSelect?(self!)
                completion?()
            }
        }
    }
    
    public func deselect(animated: Bool, completion: (() -> Void)? = nil) {
        logDebug("取消选择项目: \(title ?? "未知")")
        
        // 执行动画
        if animated && enableAnimation {
            contentView.deselectAnimation(animated: true) { [weak self] in
                self?.onDeselect?(self!)
                completion?()
            }
        } else {
            contentView.deselectAnimation(animated: false) { [weak self] in
                self?.onDeselect?(self!)
                completion?()
            }
        }
    }
    
    // MARK: - 便捷方法
    
    /// 更新标题
    public func updateTitle(_ newTitle: String, animated: Bool = true) {
        title = newTitle
        
        if animated {
            UIView.transition(
                with: contentView.titleLabel,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: {
                    self.contentView.titleLabel.text = newTitle
                }
            )
        } else {
            contentView.titleLabel.text = newTitle
        }
        
        setupAccessibility()
        logDebug("标题已更新: \(newTitle)")
    }
    
    /// 更新图标
    public func updateImage(_ newImage: UIImage?, animated: Bool = true) {
        image = newImage
        
        if animated {
            UIView.transition(
                with: contentView.imageView,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: {
                    self.contentView.imageView.image = newImage
                }
            )
        } else {
            contentView.imageView.image = newImage
        }
        
        logDebug("图标已更新")
    }
    
    /// 更新徽章
    public func updateBadge(_ value: String?, animated: Bool = true) {
        badgeValue = value
        contentView.badgeView.setBadgeValue(value)
        
        if animated, value != nil, !value!.isEmpty {
            contentView.badgeView.performAnimation(.pop)
        }
        
        logDebug("徽章已更新: \(value ?? "nil")")
    }
    
    // MARK: - 日志方法
    
    private func logDebug(_ message: String) {
        guard enableDebugLogging else { return }
        if #available(iOS 15.0, *) {
            os_log(.debug, log: logger, "%{public}@", message)
        }
        #if DEBUG
        print("🔧 [TFYSwiftTabBarItem] \(message)")
        #endif
    }
    
    // MARK: - 清理
    
    deinit {
        impactGenerator = nil
        logDebug("TabBarItem已释放")
    }
}
