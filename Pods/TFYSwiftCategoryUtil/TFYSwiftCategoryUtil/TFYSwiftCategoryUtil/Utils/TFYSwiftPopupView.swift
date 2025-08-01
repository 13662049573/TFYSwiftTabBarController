//
//  TFYSwiftPopupView.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/6/6.
//  用途：通用弹窗视图，支持多种动画、手势、键盘适配、配置灵活。
//

import UIKit

// MARK: - Configuration Types
public struct KeyboardConfiguration {
    public var isEnabled: Bool = false
    public var avoidingMode: KeyboardAvoidingMode = .transform
    public var additionalOffset: CGFloat = 10
    public var animationDuration: TimeInterval = 0.25
    public var respectSafeArea: Bool = true
    
    public enum KeyboardAvoidingMode {
        case transform  // 使用变换来避开键盘
        case constraint // 使用约束来避开键盘
        case resize    // 调整大小来避开键盘
    }
    
    public init() {}
    
    /// 验证配置是否有效
    public func validate() -> Bool {
        return additionalOffset >= 0 && animationDuration >= 0
    }
}

public struct ContainerConfiguration {
    public var width: ContainerDimension = .fixed(280)
    public var height: ContainerDimension = .automatic
    public var maxWidth: CGFloat?
    public var maxHeight: CGFloat?
    public var minWidth: CGFloat?
    public var minHeight: CGFloat?
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    public var cornerRadius: CGFloat = 0
    public var shadowEnabled: Bool = false
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.3
    public var shadowRadius: CGFloat = 5
    public var shadowOffset: CGSize = .zero
    
    public enum ContainerDimension {
        case fixed(CGFloat)
        case automatic
        case ratio(CGFloat) // 相对于屏幕宽度/高度的比例
        case custom((UIView) -> CGFloat)
    }
    
    public init() {}
    
    /// 验证配置是否有效
    public func validate() -> Bool {
        if let maxWidth = maxWidth, let minWidth = minWidth {
            return maxWidth >= minWidth
        }
        if let maxHeight = maxHeight, let minHeight = minHeight {
            return maxHeight >= minHeight
        }
        return true
    }
}

// MARK: - Configuration
public struct TFYSwiftPopupViewConfiguration {
    public var isDismissible: Bool = false
    public var isInteractive: Bool = true
    public var isPenetrable: Bool = false
    public var backgroundStyle: TFYSwiftPopupView.BackgroundView.BackgroundStyle = .solidColor
    public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    public var blurStyle: UIBlurEffect.Style = .dark
    public var animationDuration: TimeInterval = 0.25
    public var respectsSafeArea: Bool = true
    public var safeAreaInsets: UIEdgeInsets = .zero
    public var enableDragToDismiss: Bool = false
    public var dragDismissThreshold: CGFloat = 0.3
    
    public var keyboardConfiguration: KeyboardConfiguration = KeyboardConfiguration()
    public var cornerRadius: CGFloat = 0
    public var shadowConfiguration = ShadowConfiguration()
    public var tapOutsideToDismiss = true
    public var swipeToDismiss = true
    public var dismissOnBackgroundTap = true
    public var dismissWhenAppGoesToBackground = true
    
    public var containerConfiguration = ContainerConfiguration()
    
    // 新增配置选项
    public var maxPopupCount: Int = 10 // 最大弹窗数量限制
    public var autoDismissDelay: TimeInterval = 0 // 自动消失延迟，0表示不自动消失
    public var enableHapticFeedback: Bool = true // 启用触觉反馈
    public var enableAccessibility: Bool = true // 启用无障碍支持
    public var theme: PopupTheme = .default // 主题支持
    
    public init() {}
    
    /// 验证配置是否有效
    public func validate() -> Bool {
        guard maxPopupCount > 0 else { return false }
        guard autoDismissDelay >= 0 else { return false }
        guard dragDismissThreshold >= 0 && dragDismissThreshold <= 1 else { return false }
        guard animationDuration >= 0 else { return false }
        
        return keyboardConfiguration.validate() && containerConfiguration.validate()
    }
    
    public struct ShadowConfiguration {
        public var isEnabled: Bool = false
        public var color: UIColor = .black
        public var opacity: Float = 0.3
        public var radius: CGFloat = 5
        public var offset: CGSize = .zero
        
        public init() {}
    }
    
    /// 弹窗主题
    public enum PopupTheme {
        case `default`
        case light
        case dark
        case custom(backgroundColor: UIColor, textColor: UIColor, cornerRadius: CGFloat)
        
        public static var current: PopupTheme {
            if #available(iOS 13.0, *) {
                return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
            }
            return .default
        }
    }
}

// MARK: - Protocols
public protocol TFYSwiftPopupViewAnimator {
    /// 初始化配置动画驱动器
    ///
    /// - Parameters:
    ///   - popupView: TFYSwiftPopupView
    ///   - contentView: 自定义的弹框视图
    ///   - backgroundView: 背景视图
    /// - Returns: void
    func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView)


    /// 横竖屏切换的时候，刷新布局
    /// - Parameters:
    ///   - popupView: TFYSwiftPopupView
    ///   - contentView: 自定义的弹框视图
    func refreshLayout(popupView: TFYSwiftPopupView, contentView: UIView)

    /// 处理展示动画
    ///
    /// - Parameters:
    ///   - contentView: 自定义的弹框视图
    ///   - backgroundView: 背景视图
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成后的回调
    /// - Returns: void
    func display(contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView, animated: Bool, completion: @escaping ()->())

    /// 处理消失动画
    ///
    /// - Parameters:
    ///   - contentView: 自定义的弹框视图
    ///   - backgroundView: 背景视图
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成后的回调
    func dismiss(contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView, animated: Bool, completion: @escaping ()->())
}

public protocol TFYSwiftPopupViewDelegate: AnyObject {
    func popupViewWillAppear(_ popupView: TFYSwiftPopupView)
    func popupViewDidAppear(_ popupView: TFYSwiftPopupView)
    func popupViewWillDisappear(_ popupView: TFYSwiftPopupView)
    func popupViewDidDisappear(_ popupView: TFYSwiftPopupView)
    func popupViewDidReceiveMemoryWarning(_ popupView: TFYSwiftPopupView)
    
    // 新增可选方法
    func popupViewShouldDismiss(_ popupView: TFYSwiftPopupView) -> Bool
    func popupViewDidTapBackground(_ popupView: TFYSwiftPopupView)
    func popupViewDidSwipeToDismiss(_ popupView: TFYSwiftPopupView)
    func popupViewDidDragToDismiss(_ popupView: TFYSwiftPopupView)
}

// 默认实现
public extension TFYSwiftPopupViewDelegate {
    func popupViewShouldDismiss(_ popupView: TFYSwiftPopupView) -> Bool {
        return true
    }
    
    func popupViewDidTapBackground(_ popupView: TFYSwiftPopupView) {
        // 默认实现为空
    }
    
    func popupViewDidSwipeToDismiss(_ popupView: TFYSwiftPopupView) {
        // 默认实现为空
    }
    
    func popupViewDidDragToDismiss(_ popupView: TFYSwiftPopupView) {
        // 默认实现为空
    }
}

// MARK: - Main PopupView Class
public class TFYSwiftPopupView: UIView {

    // MARK: - Public Properties
    public var isDismissible: Bool {
        didSet { backgroundView.isUserInteractionEnabled = isDismissible }
    }
    public var isInteractive: Bool
    public var isPenetrable: Bool
    public private(set) var isPresenting: Bool
    public let backgroundView: BackgroundView
    public weak var delegate: TFYSwiftPopupViewDelegate?
    
    // MARK: - Callbacks
    public var willDisplayCallback: (()->())?
    public var didDisplayCallback: (()->())?
    public var willDismissCallback: (()->())?
    public var didDismissCallback: (()->())?

    // MARK: - Private Properties
    private unowned let containerView: UIView
    private let contentView: UIView
    private let animator: TFYSwiftPopupViewAnimator
    private var isAnimating = false
    private var isBeingCleanedUp = false
    private var configuration: TFYSwiftPopupViewConfiguration
    
    private var keyboardAdjustmentConstraint: NSLayoutConstraint?
    
    private var containerConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Static Properties
    private static var currentPopupViews: [TFYSwiftPopupView] = []
    private static let popupQueue = DispatchQueue(label: "com.tfy.popup.queue", attributes: .concurrent)
    private static let maxPopupCount = 10
    
    // MARK: - Initialization
    public init(containerView: UIView, 
               contentView: UIView, 
               animator: TFYSwiftPopupViewAnimator = TFYSwiftFadeInOutAnimator(),
               configuration: TFYSwiftPopupViewConfiguration = TFYSwiftPopupViewConfiguration()) {
        
        print("TFYSwiftPopupView.init: 开始初始化弹窗")
        print("TFYSwiftPopupView.init: 背景样式 - \(configuration.backgroundStyle)")
        
        // 验证配置
        guard configuration.validate() else {
            fatalError("TFYSwiftPopupView: 配置验证失败，请检查配置参数")
        }
        
        // 检查contentView是否已被添加
        assert(contentView.superview == nil, "TFYSwiftPopupView: contentView 已经被添加到其他视图")
        if contentView.superview != nil {
            TFYUtils.Logger.log("TFYSwiftPopupView: contentView 已经被添加到其他视图，可能导致布局异常", level: .warning)
        }
        
        // 检查弹窗数量限制
        if Self.currentPopupViews.count >= configuration.maxPopupCount {
            TFYUtils.Logger.log("TFYSwiftPopupView: 弹窗数量已达上限，将自动清理最旧的弹窗", level: .warning)
            Self.cleanupOldestPopup()
        }
        
        self.containerView = containerView
        self.contentView = contentView
        self.animator = animator
        self.backgroundView = BackgroundView(frame: containerView.bounds)
        self.configuration = configuration
        self.isDismissible = configuration.isDismissible
        self.isInteractive = configuration.isInteractive
        self.isPenetrable = configuration.isPenetrable
        self.isPresenting = false
        
        super.init(frame: containerView.bounds)

        setupView()
        setupGestures()
        setupAccessibility()
        setupKeyboardHandling()
        setupContainerConstraints()
        applyTheme()
        
        // 应用背景配置
        configureBackground(
            style: configuration.backgroundStyle,
            color: configuration.backgroundColor,
            blurStyle: configuration.blurStyle
        )
        
        print("TFYSwiftPopupView.init: 弹窗初始化完成")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundView.isUserInteractionEnabled = isDismissible
        backgroundView.addTarget(self, action: #selector(backgroundViewClicked), for: .touchUpInside)
        addSubview(backgroundView)
        addSubview(contentView)

        animator.setup(popupView: self, contentView: contentView, backgroundView: backgroundView)
    }

    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        animator.refreshLayout(popupView: self, contentView: contentView)
    }

    // MARK: - Hit Testing
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointInContent = convert(point, to: contentView)
        let isPointInContent = contentView.bounds.contains(pointInContent)
        
        if isPointInContent {
            return isInteractive ? super.hitTest(point, with: event) : nil
        } else {
            return isPenetrable ? nil : super.hitTest(point, with: event)
        }
    }
    
    // MARK: - Public Methods
    @discardableResult
    public func configure(with configuration: TFYSwiftPopupViewConfiguration) -> Self {
        self.configuration = configuration
        isDismissible = configuration.isDismissible
        isInteractive = configuration.isInteractive
        isPenetrable = configuration.isPenetrable
        configureBackground(
            style: configuration.backgroundStyle,
            color: configuration.backgroundColor,
            blurStyle: configuration.blurStyle
        )
        setupContainerConstraints()
        return self
    }
    
    @discardableResult
    public func configureBackground(style: BackgroundView.BackgroundStyle = .solidColor,
                                  color: UIColor = UIColor.black.withAlphaComponent(0.3),
                                  blurStyle: UIBlurEffect.Style = .dark) -> Self {
        print("TFYSwiftPopupView: 配置背景 - style: \(style), color: \(color), blurStyle: \(blurStyle)")
        backgroundView.style = style
        backgroundView.color = color
        backgroundView.blurEffectStyle = blurStyle
        return self
    }
    
    public func display(animated: Bool, completion: (() -> Void)? = nil) {
        // 检查代理是否允许显示
        if let delegate = delegate, !delegate.popupViewShouldDismiss(self) {
            TFYUtils.Logger.log("TFYSwiftPopupView: 代理不允许显示弹窗", level: .warning)
            return
        }
        
        performDisplay(animated: animated, completion: completion)
    }
    
    public func dismiss(animated: Bool, completion: (()->())? = nil) {
        guard !isAnimating else { 
            TFYUtils.Logger.log("TFYSwiftPopupView: 弹窗正在动画中，忽略消失请求", level: .debug)
            return 
        }
        
        // 检查代理是否允许消失
        if let delegate = delegate, !delegate.popupViewShouldDismiss(self) {
            TFYUtils.Logger.log("TFYSwiftPopupView: 代理不允许消失弹窗", level: .warning)
            return
        }
        
        isAnimating = true
        willDismissCallback?()
        
        // 从当前显示的弹窗数组中移除（仅在非cleanupOldestPopup调用时）
        if !isBeingCleanedUp {
            Self.popupQueue.async(flags: .barrier) {
                Self.currentPopupViews.removeAll { $0 === self }
            }
        }
        
        animator.dismiss(contentView: contentView, 
                        backgroundView: backgroundView, 
                        animated: animated) { [weak self] in
            guard let self = self else { return }
            self.isPresenting = false
            self.cleanup()
            completion?()
            self.isAnimating = false
            self.didDismissCallback?()
        }
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        containerView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerView.topAnchor),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func cleanup() {
        contentView.removeFromSuperview()
        removeFromSuperview()
        
        // 清理通知观察者
        NotificationCenter.default.removeObserver(self)
        
        // 清理手势识别器
        contentView.gestureRecognizers?.forEach { contentView.removeGestureRecognizer($0) }
        backgroundView.gestureRecognizers?.forEach { backgroundView.removeGestureRecognizer($0) }
    }
    
    // MARK: - 内存管理
    private static func cleanupOldestPopup() {
        popupQueue.async(flags: .barrier) {
            if let oldestPopup = currentPopupViews.first {
                // 先从数组中移除，避免重复移除
                currentPopupViews.removeFirst()
                // 设置清理标志
                oldestPopup.isBeingCleanedUp = true
                // 然后调用dismiss方法
                oldestPopup.dismiss(animated: false)
            }
        }
    }
    
    private static func cleanupAllPopups() {
        popupQueue.async(flags: .barrier) {
            let popups = currentPopupViews
            currentPopupViews.removeAll()
            
            // 设置清理标志并调用dismiss
            for popup in popups {
                popup.isBeingCleanedUp = true
                popup.dismiss(animated: false)
            }
        }
    }
    
    // MARK: - 主题应用
    private func applyTheme() {
        guard configuration.enableAccessibility else { return }
        
        switch configuration.theme {
        case .light:
            backgroundColor = UIColor.white.withAlphaComponent(0.95)
            contentView.backgroundColor = .white
        case .dark:
            backgroundColor = UIColor.black.withAlphaComponent(0.95)
            contentView.backgroundColor = .black
        case .custom(let backgroundColor, _, let cornerRadius):
            self.backgroundColor = backgroundColor
            contentView.backgroundColor = backgroundColor
            contentView.layer.cornerRadius = cornerRadius
        default:
            break
        }
    }
    
    @objc private func backgroundViewClicked() {
        guard configuration.dismissOnBackgroundTap else { return }
        
        // 检查代理是否允许消失
        if let delegate = delegate, !delegate.popupViewShouldDismiss(self) {
            return
        }
        
        delegate?.popupViewDidTapBackground(self)
        dismiss(animated: true)
    }
    
    private func setupKeyboardHandling() {
        guard configuration.keyboardConfiguration.isEnabled else { return }
        
        // 创建键盘调整约束
        keyboardAdjustmentConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        keyboardAdjustmentConstraint?.isActive = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard configuration.keyboardConfiguration.isEnabled else { return }
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            TFYUtils.Logger.log("TFYSwiftPopupView: 键盘通知信息不完整", level: .warning)
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let contentFrame = contentView.convert(contentView.bounds, to: nil)
        let overlap = contentFrame.maxY - (bounds.height - keyboardHeight)
        
        if overlap > 0 {
            let offset = overlap + configuration.keyboardConfiguration.additionalOffset
            
            // 添加触觉反馈
            if configuration.enableHapticFeedback {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve)) {
                switch self.configuration.keyboardConfiguration.avoidingMode {
                case .transform:
                    self.contentView.transform = CGAffineTransform(translationX: 0, y: -offset)
                case .constraint:
                    // 更新约束
                    self.keyboardAdjustmentConstraint?.constant = -offset
                    self.layoutIfNeeded()
                case .resize:
                    self.frame.size.height = self.bounds.height - keyboardHeight
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve)) {
            switch self.configuration.keyboardConfiguration.avoidingMode {
            case .transform:
                self.contentView.transform = .identity
            case .constraint:
                self.keyboardAdjustmentConstraint?.constant = 0
                self.layoutIfNeeded()
            case .resize:
                self.frame.size = self.bounds.size
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupContainerConstraints() {
        // 检查是否为底部弹出框动画器，如果是则跳过容器约束设置
        if animator is TFYSwiftBottomSheetAnimator {
            return // 底部弹出框使用自己的约束系统
        }
        
        // 移除旧的约束
        NSLayoutConstraint.deactivate(containerConstraints)
        containerConstraints.removeAll()
        
        let config = configuration.containerConfiguration
        
        // 确保 contentView 已经添加到视图层级中
        guard contentView.superview != nil else { return }
        
        // 设置宽度约束
        switch config.width {
        case .fixed(let width):
            containerConstraints.append(
                contentView.widthAnchor.constraint(equalToConstant: width)
            )
        case .automatic:
            if let maxWidth = config.maxWidth {
                containerConstraints.append(
                    contentView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
                )
            }
        case .ratio(let ratio):
            containerConstraints.append(
                contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: ratio)
            )
        case .custom(let handler):
            containerConstraints.append(
                contentView.widthAnchor.constraint(equalToConstant: handler(contentView))
            )
        }
        
        // 设置高度约束
        switch config.height {
        case .fixed(let height):
            containerConstraints.append(
                contentView.heightAnchor.constraint(equalToConstant: height)
            )
        case .automatic:
            if let maxHeight = config.maxHeight {
                containerConstraints.append(
                    contentView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight)
                )
            }
        case .ratio(let ratio):
            containerConstraints.append(
                contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio)
            )
        case .custom(let handler):
            containerConstraints.append(
                contentView.heightAnchor.constraint(equalToConstant: handler(contentView))
            )
        }
        
        // 设置最小尺寸约束
        if let minWidth = config.minWidth {
            containerConstraints.append(
                contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
            )
        }
        if let minHeight = config.minHeight {
            containerConstraints.append(
                contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
            )
        }
        
        // 激活所有约束
        NSLayoutConstraint.activate(containerConstraints)
    }
}

// MARK: - Convenience Methods
public extension TFYSwiftPopupView {
    static func show(contentView: UIView,
                    configuration: TFYSwiftPopupViewConfiguration = TFYSwiftPopupViewConfiguration(),
                    animator: TFYSwiftPopupViewAnimator = TFYSwiftFadeInOutAnimator(),
                    animated: Bool = true,
                    completion: (() -> Void)? = nil) -> TFYSwiftPopupView {
        
        print("TFYSwiftPopupView.show: 开始显示弹窗")
        print("TFYSwiftPopupView.show: 背景样式 - \(configuration.backgroundStyle)")
        
        // 验证配置
        guard configuration.validate() else {
            TFYUtils.Logger.log("TFYSwiftPopupView: 配置验证失败", level: .error)
            fatalError("TFYSwiftPopupView: 配置验证失败，请检查配置参数")
        }
        
        // 获取当前窗口（兼容 iOS 15 及以上版本）
        let window: UIWindow? = {
            if #available(iOS 15.0, *) {
                return UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
            } else {
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            }
        }()
        
        guard let window = window else {
            TFYUtils.Logger.log("TFYSwiftPopupView: 无法获取当前窗口", level: .error)
            fatalError("TFYSwiftPopupView: 无法获取当前窗口")
        }
        
        // 检查弹窗数量限制
        if currentPopupViews.count >= configuration.maxPopupCount {
            TFYUtils.Logger.log("TFYSwiftPopupView: 弹窗数量已达上限，将自动清理最旧的弹窗", level: .warning)
            cleanupOldestPopup()
        }
        
        // 创建弹窗
        let popupView = TFYSwiftPopupView(
            containerView: window,
            contentView: contentView,
            animator: animator,
            configuration: configuration
        )
        
        // 确保背景配置被正确应用
        popupView.configureBackground(
            style: configuration.backgroundStyle,
            color: configuration.backgroundColor,
            blurStyle: configuration.blurStyle
        )
        
        // 设置frame和autoresizing
        popupView.frame = window.bounds
        popupView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 添加到窗口
        window.addSubview(popupView)
        
        // 添加到当前显示的弹窗数组
        popupQueue.async(flags: .barrier) {
            currentPopupViews.append(popupView)
        }
        
        // 显示弹窗
        popupView.display(animated: animated) {
            completion?()
        }
        
        // 设置自动消失
        if configuration.autoDismissDelay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + configuration.autoDismissDelay) {
                popupView.dismiss(animated: true)
            }
        }
        
        return popupView
    }
    
    static func dismissAll(animated: Bool = true, completion: (() -> Void)? = nil) {
        popupQueue.async(flags: .barrier) {
            let popups = currentPopupViews
            currentPopupViews.removeAll()
            
            guard !popups.isEmpty else {
                DispatchQueue.main.async {
                    completion?()
                }
                return
            }
            
            let group = DispatchGroup()
            
            for popup in popups {
                group.enter()
                // 设置清理标志，避免重复移除
                popup.isBeingCleanedUp = true
                popup.dismiss(animated: animated) {
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion?()
            }
        }
    }
    
    /// 获取当前显示的弹窗数量
    static var currentPopupCount: Int {
        var count = 0
        popupQueue.sync {
            count = currentPopupViews.count
        }
        return count
    }
    
    /// 获取当前显示的所有弹窗
    static var allCurrentPopups: [TFYSwiftPopupView] {
        var popups: [TFYSwiftPopupView] = []
        popupQueue.sync {
            popups = currentPopupViews
        }
        return popups
    }
}

// MARK: - Private Methods
private extension TFYSwiftPopupView {
    func setupInitialLayout() {
        // 检查是否为底部弹出框动画器，如果是则跳过center约束设置
        if animator is TFYSwiftBottomSheetAnimator {
            return // 底部弹出框使用自己的约束系统
        }
        
        // 设置内容视图的中心约束（仅用于非底部弹出框）
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func performDisplay(animated: Bool, completion: (() -> Void)? = nil) {
        guard !isAnimating else { return }
        
        isPresenting = true
        isAnimating = true
        
        // 确保视图已添加到容器中（仅在未添加时）
        if superview == nil {
            containerView.addSubview(self)
            frame = containerView.bounds
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        // 设置约束（仅在首次显示时）
        if containerConstraints.isEmpty {
            setupInitialLayout()
            setupContainerConstraints()
        }
        
        // 调用显示回调
        willDisplayCallback?()
        
        // 执行动画
        animator.display(contentView: contentView,
                        backgroundView: backgroundView,
                        animated: animated) { [weak self] in
            guard let self = self else { return }
            completion?()
            self.isAnimating = false
            self.didDisplayCallback?()
        }
    }
}

// MARK: - BackgroundView
extension TFYSwiftPopupView {
    public class BackgroundView: UIControl {
        public enum BackgroundStyle {
            case solidColor
            case blur
            case gradient
            case custom((BackgroundView) -> Void)
        }
        
        public enum BackgroundEffect {
            case none
            case blur(style: UIBlurEffect.Style)
            case gradient(colors: [UIColor], locations: [NSNumber]?)
            case dimmed(color: UIColor, alpha: CGFloat)
            case custom((BackgroundView) -> Void)
        }
        
        // MARK: - Properties
        public var style: BackgroundStyle = .solidColor {
            didSet { refreshBackgroundStyle() }
        }
        
        public var color: UIColor = UIColor.black.withAlphaComponent(0.3) {
            didSet { backgroundColor = color }
        }
        
        public var blurEffectStyle: UIBlurEffect.Style = .dark {
            didSet { refreshBackgroundStyle() }
        }
        
        public var gradientColors: [UIColor] = [
            UIColor.black.withAlphaComponent(0.5),
            UIColor.black.withAlphaComponent(0.3)
        ] {
            didSet { refreshBackgroundStyle() }
        }
        
        public var gradientLocations: [NSNumber]? = [0.0, 1.0] {
            didSet { refreshBackgroundStyle() }
        }
        
        public var gradientStartPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
            didSet { refreshBackgroundStyle() }
        }
        
        public var gradientEndPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
            didSet { refreshBackgroundStyle() }
        }
        
        // MARK: - Private Properties
        private var effectView: UIVisualEffectView?
        private var gradientLayer: CAGradientLayer?
        
        // MARK: - Initialization
        public override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Private Methods
        private func setupView() {
            backgroundColor = color
            layer.allowsGroupOpacity = false
            refreshBackgroundStyle()
        }
        
        private func refreshBackgroundStyle() {
            print("TFYSwiftPopupView: 刷新背景样式 - \(style)")
            
            // 清除现有效果
            effectView?.removeFromSuperview()
            effectView = nil
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
            
            switch style {
            case .solidColor:
                print("TFYSwiftPopupView: 设置纯色背景")
                backgroundColor = color
                
            case .blur:
                print("TFYSwiftPopupView: 设置模糊背景")
                effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
                effectView?.frame = bounds
                insertSubview(effectView!, at: 0)
                
            case .gradient:
                print("TFYSwiftPopupView: 设置渐变背景")
                gradientLayer = CAGradientLayer()
                gradientLayer?.frame = bounds
                gradientLayer?.colors = gradientColors.map { $0.cgColor }
                gradientLayer?.locations = gradientLocations
                gradientLayer?.startPoint = gradientStartPoint
                gradientLayer?.endPoint = gradientEndPoint
                layer.insertSublayer(gradientLayer!, at: 0)
                
            case .custom(let customization):
                print("TFYSwiftPopupView: 设置自定义背景")
                customization(self)
            }
        }
        
        // MARK: - Layout
        public override func layoutSubviews() {
            super.layoutSubviews()
            effectView?.frame = bounds
            gradientLayer?.frame = bounds
        }
        
        public func applyEffect(_ effect: BackgroundEffect) {
            switch effect {
            case .none:
                backgroundColor = .clear
                
            case .blur(let style):
                let blurEffect = UIBlurEffect(style: style)
                let blurView = UIVisualEffectView(effect: blurEffect)
                blurView.frame = bounds
                addSubview(blurView)
                
            case .gradient(let colors, let locations):
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = bounds
                gradientLayer.colors = colors.map { $0.cgColor }
                gradientLayer.locations = locations
                layer.addSublayer(gradientLayer)
                
            case .dimmed(let color, let alpha):
                backgroundColor = color.withAlphaComponent(alpha)
                
            case .custom(let customization):
                customization(self)
            }
        }
    }
}

public extension UIView {
    func popupView() -> TFYSwiftPopupView? {
        if self.superview?.isKind(of: TFYSwiftPopupView.self) == true {
            return self.superview as? TFYSwiftPopupView
        }
        return nil
    }
}

// MARK: - Base Animator
open class TFYSwiftBaseAnimator: TFYSwiftPopupViewAnimator {
    // MARK: - Public Properties
    open var layout: Layout
    open var displayDuration: TimeInterval = 0.25
    open var displayAnimationOptions: UIView.AnimationOptions = .curveEaseInOut
    open var displaySpringDampingRatio: CGFloat?
    open var displaySpringVelocity: CGFloat?
    open var displayAnimationBlock: (()->())?

    open var dismissDuration: TimeInterval = 0.25
    open var dismissAnimationOptions: UIView.AnimationOptions = .curveEaseInOut
    open var dismissSpringDampingRatio: CGFloat?
    open var dismissSpringVelocity: CGFloat?
    open var dismissAnimationBlock: (()->())?

    // MARK: - Initialization
    public init(layout: Layout = .center(.init())) {
        self.layout = layout
    }
    
    // MARK: - TFYSwiftPopupViewAnimator
    open func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        setupLayout(popupView: popupView, contentView: contentView)
    }
    
    open func refreshLayout(popupView: TFYSwiftPopupView, contentView: UIView) {
        if case .frame(let frame) = layout {
            contentView.frame = frame
        }
    }
    
    open func display(contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView, animated: Bool, completion: @escaping () -> ()) {
        print("TFYSwiftBaseAnimator: 开始执行显示动画 - animated: \(animated)")
        
        if animated {
            if let dampingRatio = displaySpringDampingRatio,
               let velocity = displaySpringVelocity {
                print("TFYSwiftBaseAnimator: 使用弹簧动画 - damping: \(dampingRatio), velocity: \(velocity)")
                UIView.animate(
                    withDuration: displayDuration,
                    delay: 0,
                    usingSpringWithDamping: dampingRatio,
                    initialSpringVelocity: velocity,
                    options: displayAnimationOptions,
                    animations: { 
                        print("TFYSwiftBaseAnimator: 执行显示动画块")
                        self.displayAnimationBlock?() 
                    },
                    completion: { _ in 
                        print("TFYSwiftBaseAnimator: 显示动画完成")
                        completion() 
                    }
                )
            } else {
                print("TFYSwiftBaseAnimator: 使用普通动画 - duration: \(displayDuration)")
                UIView.animate(
                    withDuration: displayDuration,
                    delay: 0,
                    options: displayAnimationOptions,
                    animations: { 
                        print("TFYSwiftBaseAnimator: 执行显示动画块")
                        self.displayAnimationBlock?() 
                    },
                    completion: { _ in 
                        print("TFYSwiftBaseAnimator: 显示动画完成")
                        completion() 
                    }
                )
            }
        } else {
            print("TFYSwiftBaseAnimator: 无动画模式")
            displayAnimationBlock?()
            completion()
        }
    }
    
    open func dismiss(contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView, animated: Bool, completion: @escaping () -> ()) {
        if animated {
            if let dampingRatio = dismissSpringDampingRatio,
               let velocity = dismissSpringVelocity {
                UIView.animate(
                    withDuration: dismissDuration,
                    delay: 0,
                    usingSpringWithDamping: dampingRatio,
                    initialSpringVelocity: velocity,
                    options: dismissAnimationOptions,
                    animations: { self.dismissAnimationBlock?() },
                    completion: { _ in completion() }
                )
            } else {
                UIView.animate(
                    withDuration: dismissDuration,
                    delay: 0,
                    options: dismissAnimationOptions,
                    animations: { self.dismissAnimationBlock?() },
                    completion: { _ in completion() }
                )
            }
        } else {
            dismissAnimationBlock?()
            completion()
        }
    }
    
    // MARK: - Private Methods
    private func setupLayout(popupView: TFYSwiftPopupView, contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        switch layout {
        case .center(let center):
            setupCenterLayout(popupView: popupView, contentView: contentView, center: center)
        case .top(let top):
            setupTopLayout(popupView: popupView, contentView: contentView, top: top)
        case .bottom(let bottom):
            setupBottomLayout(popupView: popupView, contentView: contentView, bottom: bottom)
        case .leading(let leading):
            setupLeadingLayout(popupView: popupView, contentView: contentView, leading: leading)
        case .trailing(let trailing):
            setupTrailingLayout(popupView: popupView, contentView: contentView, trailing: trailing)
        case .frame(let frame):
            contentView.frame = frame
            contentView.translatesAutoresizingMaskIntoConstraints = true
        }
    }
    
    private func setupCenterLayout(popupView: TFYSwiftPopupView, contentView: UIView, center: Layout.Center) {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: center.offsetX),
            contentView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor, constant: center.offsetY)
        ])
        
        if let width = center.width {
            contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = center.height {
            contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    private func setupTopLayout(popupView: TFYSwiftPopupView, contentView: UIView, top: Layout.Top) {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: top.topMargin),
            contentView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: top.offsetX)
        ])
        
        if let width = top.width {
            contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = top.height {
            contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    private func setupBottomLayout(popupView: TFYSwiftPopupView, contentView: UIView, bottom: Layout.Bottom) {
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -bottom.bottomMargin),
            contentView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: bottom.offsetX)
        ])
        
        if let width = bottom.width {
            contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = bottom.height {
            contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    private func setupLeadingLayout(popupView: TFYSwiftPopupView, contentView: UIView, leading: Layout.Leading) {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: leading.leadingMargin),
            contentView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor, constant: leading.offsetY)
        ])
        
        if let width = leading.width {
            contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = leading.height {
            contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    private func setupTrailingLayout(popupView: TFYSwiftPopupView, contentView: UIView, trailing: Layout.Trailing) {
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -trailing.trailingMargin),
            contentView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor, constant: trailing.offsetY)
        ])
        
        if let width = trailing.width {
            contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = trailing.height {
            contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    private func getSafeAreaInsets(for popupView: TFYSwiftPopupView) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return popupView.safeAreaInsets
        }
        return .zero
    }
    
    private func adjustForSafeArea(_ constant: CGFloat, edge: UIRectEdge, popupView: TFYSwiftPopupView) -> CGFloat {
        let safeAreaInsets = getSafeAreaInsets(for: popupView)
        switch edge {
        case .top: return constant + safeAreaInsets.top
        case .bottom: return constant + safeAreaInsets.bottom
        case .left: return constant + safeAreaInsets.left
        case .right: return constant + safeAreaInsets.right
        default: return constant
        }
    }
}

// MARK: - Layout Types
extension TFYSwiftBaseAnimator {
    public enum Layout {
        case center(Center)
        case top(Top)
        case bottom(Bottom)
        case leading(Leading)
        case trailing(Trailing)
        case frame(CGRect)

        func offsetX() -> CGFloat {
            switch self {
            case .center(let center): return center.offsetX
            case .top(let top): return top.offsetX
            case .bottom(let bottom): return bottom.offsetX
            case .leading(_), .trailing(_), .frame(_): return 0
            }
        }

        func offsetY() -> CGFloat {
            switch self {
            case .center(let center): return center.offsetY
            case .leading(let leading): return leading.offsetY
            case .trailing(let trailing): return trailing.offsetY
            case .top(_), .bottom(_), .frame(_): return 0
            }
        }
        
        // Layout structs...
        public struct Center {
            public var offsetY: CGFloat
            public var offsetX: CGFloat
            public var width: CGFloat?
            public var height: CGFloat?

            public init(offsetY: CGFloat = 0, offsetX: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
                self.offsetY = offsetY
                self.offsetX = offsetX
                self.width = width
                self.height = height
            }
        }

        public struct Top {
            public var topMargin: CGFloat
            public var offsetX: CGFloat
            public var width: CGFloat?
            public var height: CGFloat?

            public init(topMargin: CGFloat = 0, offsetX: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
                self.topMargin = topMargin
                self.offsetX = offsetX
                self.width = width
                self.height = height
            }
        }

        public struct Bottom {
            public var bottomMargin: CGFloat
            public var offsetX: CGFloat
            public var width: CGFloat?
            public var height: CGFloat?

            public init(bottomMargin: CGFloat = 0, offsetX: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
                self.bottomMargin = bottomMargin
                self.offsetX = offsetX
                self.width = width
                self.height = height
            }
        }

        public struct Leading {
            public var leadingMargin: CGFloat
            public var offsetY: CGFloat
            public var width: CGFloat?
            public var height: CGFloat?

            public init(leadingMargin: CGFloat = 0, offsetY: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
                self.leadingMargin = leadingMargin
                self.offsetY = offsetY
                self.width = width
                self.height = height
            }
        }

        public struct Trailing {
            public var trailingMargin: CGFloat
            public var offsetY: CGFloat
            public var width: CGFloat?
            public var height: CGFloat?

            public init(trailingMargin: CGFloat = 0, offsetY: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
                self.trailingMargin = trailingMargin
                self.offsetY = offsetY
                self.width = width
                self.height = height
            }
        }
    }
}

// MARK: - Specific Animators
open class TFYSwiftFadeInOutAnimator: TFYSwiftBaseAnimator {
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        contentView.alpha = 0
        backgroundView.alpha = 0
        
        displayAnimationBlock = {
            contentView.alpha = 1
            backgroundView.alpha = 1
        }
        
        dismissAnimationBlock = {
            contentView.alpha = 0
            backgroundView.alpha = 0
        }
    }
}

open class TFYSwiftZoomInOutAnimator: TFYSwiftBaseAnimator {
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        contentView.alpha = 0
        backgroundView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        displayAnimationBlock = {
            contentView.alpha = 1
            contentView.transform = .identity
            backgroundView.alpha = 1
        }
        
        dismissAnimationBlock = {
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            backgroundView.alpha = 0
        }
    }
}

open class TFYSwift3DFlipAnimator: TFYSwiftBaseAnimator {
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        contentView.alpha = 0
        backgroundView.alpha = 0
        contentView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        
        displayAnimationBlock = {
            contentView.alpha = 1
            contentView.layer.transform = CATransform3DIdentity
            backgroundView.alpha = 1
        }
        
        dismissAnimationBlock = {
            contentView.alpha = 0
            contentView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            backgroundView.alpha = 0
        }
    }
}

// MARK: - Directional Animators
open class TFYSwiftDirectionalAnimator: TFYSwiftBaseAnimator {
    func getInitialTransform(for popupView: TFYSwiftPopupView, contentView: UIView) -> CGAffineTransform {
        .identity
    }
    
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        let initialTransform = getInitialTransform(for: popupView, contentView: contentView)
        contentView.transform = initialTransform
        contentView.alpha = 0
        backgroundView.alpha = 0
        
        displayAnimationBlock = {
            contentView.transform = .identity
            contentView.alpha = 1
            backgroundView.alpha = 1
        }
        
        dismissAnimationBlock = {
            contentView.transform = initialTransform
            contentView.alpha = 0
            backgroundView.alpha = 0
        }
    }
}

open class TFYSwiftUpwardAnimator: TFYSwiftDirectionalAnimator {
    override func getInitialTransform(for popupView: TFYSwiftPopupView, contentView: UIView) -> CGAffineTransform {
        return CGAffineTransform(translationX: 0, y: popupView.bounds.height)
    }
}

open class TFYSwiftDownwardAnimator: TFYSwiftDirectionalAnimator {
    override func getInitialTransform(for popupView: TFYSwiftPopupView, contentView: UIView) -> CGAffineTransform {
        return CGAffineTransform(translationX: 0, y: -popupView.bounds.height)
    }
}

open class TFYSwiftLeftwardAnimator: TFYSwiftDirectionalAnimator {
    override func getInitialTransform(for popupView: TFYSwiftPopupView, contentView: UIView) -> CGAffineTransform {
        return CGAffineTransform(translationX: popupView.bounds.width, y: 0)
    }
}

open class TFYSwiftRightwardAnimator: TFYSwiftDirectionalAnimator {
    override func getInitialTransform(for popupView: TFYSwiftPopupView, contentView: UIView) -> CGAffineTransform {
        return CGAffineTransform(translationX: -popupView.bounds.width, y: 0)
    }
}

// MARK: - Bottom Sheet Animator

public class TFYSwiftBottomSheetAnimator: TFYSwiftPopupViewAnimator {
    public struct Configuration {
        public var defaultHeight: CGFloat = 300
        public var minimumHeight: CGFloat = 100
        public var maximumHeight: CGFloat = UIScreen.main.bounds.height
        public var allowsFullScreen: Bool = true
        public var snapToDefaultThreshold: CGFloat = 80
        public var springDamping: CGFloat = 0.8
        public var springVelocity: CGFloat = 0.4
        public var animationDuration: TimeInterval = 0.35
        public var dismissThreshold: CGFloat = 60
        public init() {}
    }
    
    public let configuration: Configuration
    private weak var popupView: TFYSwiftPopupView?
    private weak var contentView: UIView?
    private weak var backgroundView: TFYSwiftPopupView.BackgroundView?
    private var panGesture: UIPanGestureRecognizer?
    private var currentHeight: CGFloat = 0
    private var isDragging = false
    private var initialTouchPoint: CGPoint = .zero
    private var initialFrame: CGRect = .zero
    
    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }
    
    public func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        self.popupView = popupView
        self.contentView = contentView
        self.backgroundView = backgroundView
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupLayout(popupView: popupView, contentView: contentView)
        addPanGesture(to: contentView)
    }
    
    public func refreshLayout(popupView: TFYSwiftPopupView, contentView: UIView) {
        // 可根据需要刷新布局
    }
    
    public func display(contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView, animated: Bool, completion: @escaping () -> ()) {
        guard let popupView = popupView else { completion(); return }
        let height = configuration.defaultHeight
        let y = popupView.bounds.height
        contentView.frame = CGRect(x: 0, y: y, width: popupView.bounds.width, height: height)
        backgroundView.alpha = 0
        UIView.animate(withDuration: configuration.animationDuration, delay: 0, usingSpringWithDamping: configuration.springDamping, initialSpringVelocity: configuration.springVelocity, options: .curveEaseOut) {
            contentView.frame = CGRect(x: 0, y: popupView.bounds.height - height, width: popupView.bounds.width, height: height)
            backgroundView.alpha = 1
        } completion: { _ in
            completion()
        }
    }
    
    public func dismiss(contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView, animated: Bool, completion: @escaping () -> ()) {
        guard let popupView = popupView else { completion(); return }
        let y = popupView.bounds.height
        UIView.animate(withDuration: configuration.animationDuration, delay: 0, options: .curveEaseIn) {
            contentView.frame.origin.y = y
            backgroundView.alpha = 0
        } completion: { _ in
            completion()
        }
    }
    
    private func setupLayout(popupView: TFYSwiftPopupView, contentView: UIView) {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: configuration.minimumHeight),
            contentView.heightAnchor.constraint(lessThanOrEqualToConstant: configuration.maximumHeight)
        ])
    }
    
    private func addPanGesture(to view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(pan)
        self.panGesture = pan
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let popupView = popupView, let contentView = contentView else { return }
        let translation = gesture.translation(in: popupView)
        let velocity = gesture.velocity(in: popupView)
        switch gesture.state {
        case .began:
            isDragging = true
            initialTouchPoint = gesture.location(in: popupView)
            initialFrame = contentView.frame
        case .changed:
            let newY = max(initialFrame.origin.y + translation.y, popupView.bounds.height - configuration.maximumHeight)
            let maxY = popupView.bounds.height - configuration.minimumHeight
            if newY <= maxY {
                contentView.frame.origin.y = newY
            }
        case .ended, .cancelled:
            isDragging = false
            let moved = contentView.frame.origin.y - (popupView.bounds.height - configuration.defaultHeight)
            if moved > configuration.dismissThreshold || velocity.y > 1000 {
                // 关闭
                popupView.dismiss(animated: true)
            } else if abs(moved) > configuration.snapToDefaultThreshold && configuration.allowsFullScreen && velocity.y < 0 {
                // 全屏展开
                UIView.animate(withDuration: configuration.animationDuration, delay: 0, usingSpringWithDamping: configuration.springDamping, initialSpringVelocity: configuration.springVelocity, options: .curveEaseOut) {
                    contentView.frame.origin.y = popupView.bounds.height - self.configuration.maximumHeight
                    contentView.frame.size.height = self.configuration.maximumHeight
                }
            } else {
                // 回弹到默认高度
                UIView.animate(withDuration: configuration.animationDuration, delay: 0, usingSpringWithDamping: configuration.springDamping, initialSpringVelocity: configuration.springVelocity, options: .curveEaseOut) {
                    contentView.frame.origin.y = popupView.bounds.height - self.configuration.defaultHeight
                    contentView.frame.size.height = self.configuration.defaultHeight
                }
            }
        default:
            break
        }
    }
}

// MARK: - Constraint Helpers
// 删除UIView的widthConstraint、heightConstraint等约束查找扩展

// MARK: - Gesture Support
extension TFYSwiftPopupView {
    private func setupGestures() {
        guard configuration.enableDragToDismiss else { return }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        contentView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            handlePanBegan()
        case .changed:
            handlePanChanged(translation: translation)
        case .ended, .cancelled:
            handlePanEnded(translation: translation, velocity: velocity)
        default:
            break
        }
    }
    
    private func handlePanBegan() {
        // 停止任何正在进行的动画
        layer.removeAllAnimations()
        contentView.layer.removeAllAnimations()
        backgroundView.layer.removeAllAnimations()
    }
    
    private func handlePanChanged(translation: CGPoint) {
        let dragDistance = translation.y
        let progress = abs(dragDistance / bounds.height)
        
        // 应用拖动变换
        contentView.transform = CGAffineTransform(translationX: 0, y: dragDistance)
        
        // 更新背景透明度
        backgroundView.alpha = 1 - (progress * 0.8) // 保留一些最小透明度
    }
    
    private func handlePanEnded(translation: CGPoint, velocity: CGPoint) {
        let dragDistance = translation.y
        let progress = abs(dragDistance / bounds.height)
        
        if progress > configuration.dragDismissThreshold || abs(velocity.y) > 1000 {
            // 完成消失动画
            let remainingDistance = bounds.height - abs(dragDistance)
            let duration = TimeInterval(remainingDistance / abs(velocity.y))
            
            UIView.animate(withDuration: min(duration, 0.3), delay: 0, options: .curveEaseOut) {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: dragDistance > 0 ? self.bounds.height : -self.bounds.height)
                self.backgroundView.alpha = 0
            } completion: { _ in
                self.dismiss(animated: false)
            }
        } else {
            // 恢复原位
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseOut) {
                self.contentView.transform = .identity
                self.backgroundView.alpha = 1
            }
        }
    }
}

// MARK: - Accessibility
extension TFYSwiftPopupView {
    private func setupAccessibility() {
        isAccessibilityElement = false
        contentView.isAccessibilityElement = true
        contentView.accessibilityTraits = .allowsDirectInteraction
        
        if #available(iOS 13.0, *) {
            contentView.accessibilityRespondsToUserInteraction = true
        }
    }
}

// MARK: - Spring Animator
open class TFYSwiftSpringAnimator: TFYSwiftBaseAnimator {
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        print("TFYSwiftSpringAnimator: 设置弹簧动画")
        
        contentView.alpha = 0
        backgroundView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        print("TFYSwiftSpringAnimator: 初始缩放设置为 0.7")
        
        displayAnimationBlock = {
            print("TFYSwiftSpringAnimator: 执行显示动画")
            contentView.alpha = 1
            contentView.transform = .identity
            backgroundView.alpha = 1
        }
        dismissAnimationBlock = {
            print("TFYSwiftSpringAnimator: 执行消失动画")
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            backgroundView.alpha = 0
        }
        
        // 设置弹簧动画参数
        displaySpringDampingRatio = 0.7
        displaySpringVelocity = 0.5
        dismissSpringDampingRatio = 0.8
        dismissSpringVelocity = 0.3
        displayDuration = 0.5
        dismissDuration = 0.5
        
        print("TFYSwiftSpringAnimator: 弹簧动画参数设置完成")
    }
}

// MARK: - 新增动画器类型
open class TFYSwiftBounceAnimator: TFYSwiftBaseAnimator {
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        print("TFYSwiftBounceAnimator: 设置弹性动画")
        
        contentView.alpha = 0
        backgroundView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        print("TFYSwiftBounceAnimator: 初始缩放设置为 0.1")
        
        displayAnimationBlock = {
            print("TFYSwiftBounceAnimator: 执行显示动画")
            contentView.alpha = 1
            contentView.transform = .identity
            backgroundView.alpha = 1
        }
        
        dismissAnimationBlock = {
            print("TFYSwiftBounceAnimator: 执行消失动画")
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            backgroundView.alpha = 0
        }
        
        // 设置弹性动画参数
        displaySpringDampingRatio = 0.6
        displaySpringVelocity = 0.8
        dismissSpringDampingRatio = 0.8
        dismissSpringVelocity = 0.5
        displayDuration = 0.6
        dismissDuration = 0.6
        
        print("TFYSwiftBounceAnimator: 弹性动画参数设置完成")
    }
}

open class TFYSwiftSlideAnimator: TFYSwiftBaseAnimator {
    public enum SlideDirection {
        case fromTop, fromBottom, fromLeft, fromRight
    }
    
    private let direction: SlideDirection
    
    public init(direction: SlideDirection, layout: Layout = .center(.init())) {
        self.direction = direction
        super.init(layout: layout)
    }
    
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        contentView.alpha = 0
        backgroundView.alpha = 0
        
        // 根据方向设置初始位置
        let screenBounds = UIScreen.main.bounds
        switch direction {
        case .fromTop:
            contentView.transform = CGAffineTransform(translationX: 0, y: -screenBounds.height)
        case .fromBottom:
            contentView.transform = CGAffineTransform(translationX: 0, y: screenBounds.height)
        case .fromLeft:
            contentView.transform = CGAffineTransform(translationX: -screenBounds.width, y: 0)
        case .fromRight:
            contentView.transform = CGAffineTransform(translationX: screenBounds.width, y: 0)
        }
        
        displayAnimationBlock = {
            contentView.alpha = 1
            contentView.transform = .identity
            backgroundView.alpha = 1
        }
        
        dismissAnimationBlock = {
            contentView.alpha = 0
            switch self.direction {
            case .fromTop:
                contentView.transform = CGAffineTransform(translationX: 0, y: -screenBounds.height)
            case .fromBottom:
                contentView.transform = CGAffineTransform(translationX: 0, y: screenBounds.height)
            case .fromLeft:
                contentView.transform = CGAffineTransform(translationX: -screenBounds.width, y: 0)
            case .fromRight:
                contentView.transform = CGAffineTransform(translationX: screenBounds.width, y: 0)
            }
            backgroundView.alpha = 0
        }
    }
}

open class TFYSwiftRotateAnimator: TFYSwiftBaseAnimator {
    open override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
        super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
        
        print("TFYSwiftRotateAnimator: 设置旋转动画")
        
        contentView.alpha = 0
        backgroundView.alpha = 0
        // 设置初始旋转角度为 -180 度，这样会有明显的旋转效果
        contentView.transform = CGAffineTransform(rotationAngle: -.pi)
        
        print("TFYSwiftRotateAnimator: 初始旋转角度设置为 -180 度")
        
        displayAnimationBlock = {
            print("TFYSwiftRotateAnimator: 执行显示动画")
            contentView.alpha = 1
            contentView.transform = .identity
            backgroundView.alpha = 1
        }
        
        dismissAnimationBlock = {
            print("TFYSwiftRotateAnimator: 执行消失动画")
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(rotationAngle: .pi)
            backgroundView.alpha = 0
        }
        
        // 设置更长的动画时间以突出旋转效果
        displayDuration = 0.8
        dismissDuration = 0.8
        displayAnimationOptions = .curveEaseInOut
        dismissAnimationOptions = .curveEaseInOut
        
        print("TFYSwiftRotateAnimator: 动画时间设置为 0.8 秒")
    }
}

// MARK: - Bottom Sheet PopupView Convenience
public extension TFYSwiftPopupView {
    @discardableResult
    static func showBottomSheet(
        contentView: UIView,
        configuration: TFYSwiftBottomSheetAnimator.Configuration = TFYSwiftBottomSheetAnimator.Configuration(),
        popupConfig: TFYSwiftPopupViewConfiguration = TFYSwiftPopupViewConfiguration(),
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> TFYSwiftPopupView {
        let animator = TFYSwiftBottomSheetAnimator(configuration: configuration)
        return TFYSwiftPopupView.show(
            contentView: contentView,
            configuration: popupConfig,
            animator: animator,
            animated: animated,
            completion: completion
        )
    }
}

// MARK: - 实用方法扩展
public extension TFYSwiftPopupView {
    
    /// 显示警告弹窗
    @discardableResult
    static func showAlert(
        title: String? = nil,
        message: String,
        buttonTitle: String = "确定",
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> TFYSwiftPopupView {
        
        let alertView = createAlertView(title: title, message: message, buttonTitle: buttonTitle)
        
        var config = TFYSwiftPopupViewConfiguration()
        config.isDismissible = true
        config.tapOutsideToDismiss = true
        config.autoDismissDelay = 0
        config.enableHapticFeedback = true
        
        return show(
            contentView: alertView,
            configuration: config,
            animated: animated,
            completion: completion
        )
    }
    
    /// 显示确认弹窗
    @discardableResult
    static func showConfirm(
        title: String? = nil,
        message: String,
        confirmTitle: String = "确定",
        cancelTitle: String = "取消",
        animated: Bool = true,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> TFYSwiftPopupView {
        
        let confirmView = createConfirmView(
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            cancelTitle: cancelTitle,
            onConfirm: onConfirm,
            onCancel: onCancel
        )
        
        var config = TFYSwiftPopupViewConfiguration()
        config.isDismissible = true
        config.tapOutsideToDismiss = false
        config.autoDismissDelay = 0
        config.enableHapticFeedback = true
        
        return show(
            contentView: confirmView,
            configuration: config,
            animated: animated
        )
    }
    
    /// 显示加载弹窗
    @discardableResult
    static func showLoading(
        message: String = "加载中...",
        animated: Bool = true
    ) -> TFYSwiftPopupView {
        
        let loadingView = createLoadingView(message: message)
        
        var config = TFYSwiftPopupViewConfiguration()
        config.isDismissible = false
        config.tapOutsideToDismiss = false
        config.autoDismissDelay = 0
        config.enableHapticFeedback = false
        
        return show(
            contentView: loadingView,
            configuration: config,
            animated: animated
        )
    }
    
    /// 显示成功提示
    @discardableResult
    static func showSuccess(
        message: String,
        duration: TimeInterval = 2.0,
        animated: Bool = true
    ) -> TFYSwiftPopupView {
        
        let successView = createSuccessView(message: message)
        
        var config = TFYSwiftPopupViewConfiguration()
        config.isDismissible = true
        config.tapOutsideToDismiss = false
        config.autoDismissDelay = duration
        config.enableHapticFeedback = true
        
        return show(
            contentView: successView,
            configuration: config,
            animated: animated
        )
    }
    
    /// 显示错误提示
    @discardableResult
    static func showError(
        message: String,
        duration: TimeInterval = 3.0,
        animated: Bool = true
    ) -> TFYSwiftPopupView {
        
        let errorView = createErrorView(message: message)
        
        var config = TFYSwiftPopupViewConfiguration()
        config.isDismissible = true
        config.tapOutsideToDismiss = false
        config.autoDismissDelay = duration
        config.enableHapticFeedback = true
        
        return show(
            contentView: errorView,
            configuration: config,
            animated: animated
        )
    }
    
    // MARK: - 私有辅助方法
    private static func createAlertView(title: String?, message: String, buttonTitle: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            stackView.addArrangedSubview(titleLabel)
        }
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        stackView.addArrangedSubview(messageLabel)
        
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
        
        button.addTarget(self, action: #selector(alertButtonTapped(_:)), for: .touchUpInside)
        
        return containerView
    }
    
    private static func createConfirmView(
        title: String?,
        message: String,
        confirmTitle: String,
        cancelTitle: String,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            stackView.addArrangedSubview(titleLabel)
        }
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        stackView.addArrangedSubview(messageLabel)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        stackView.addArrangedSubview(buttonStackView)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.backgroundColor = UIColor.systemGray5
        cancelButton.setTitleColor(.systemGray, for: .normal)
        cancelButton.layer.cornerRadius = 8
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(cancelButton)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle(confirmTitle, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.backgroundColor = UIColor.systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 存储回调
        cancelButton.tag = 1001
        confirmButton.tag = 1002
        
        cancelButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        
        return containerView
    }
    
    private static func createLoadingView(message: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        stackView.addArrangedSubview(activityIndicator)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        stackView.addArrangedSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
        ])
        
        return containerView
    }
    
    private static func createSuccessView(message: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        let successImageView = UIImageView()
        successImageView.image = UIImage(systemName: "checkmark.circle.fill")
        successImageView.tintColor = .systemGreen
        successImageView.contentMode = .scaleAspectFit
        successImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(successImageView)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        stackView.addArrangedSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            successImageView.widthAnchor.constraint(equalToConstant: 48),
            successImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        return containerView
    }
    
    private static func createErrorView(message: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        let errorImageView = UIImageView()
        errorImageView.image = UIImage(systemName: "xmark.circle.fill")
        errorImageView.tintColor = .systemRed
        errorImageView.contentMode = .scaleAspectFit
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(errorImageView)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        stackView.addArrangedSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            errorImageView.widthAnchor.constraint(equalToConstant: 48),
            errorImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        return containerView
    }
    
    @objc private static func alertButtonTapped(_ sender: UIButton) {
        // 查找弹窗并消失
        if let popupView = sender.findPopupView() {
            popupView.dismiss(animated: true)
        }
    }
    
    @objc private static func confirmButtonTapped(_ sender: UIButton) {
        // 查找弹窗并消失
        if let popupView = sender.findPopupView() {
            popupView.dismiss(animated: true)
        }
    }
}

// MARK: - UIView 扩展
private extension UIView {
    func findPopupView() -> TFYSwiftPopupView? {
        var currentView: UIView? = self
        while currentView != nil {
            if let popupView = currentView as? TFYSwiftPopupView {
                return popupView
            }
            currentView = currentView?.superview
        }
        return nil
    }
}

// MARK: - 详细使用示例和示范

/*
 
 ========================================
 TFYSwiftPopupView 完整使用指南
 ========================================
 
 1. 基本使用
 ========================================
 
 // 创建自定义内容视图
 let customView = UIView()
 customView.backgroundColor = .white
 customView.layer.cornerRadius = 12
 
 // 基本配置
 var config = TFYSwiftPopupViewConfiguration()
 config.isDismissible = true
 config.tapOutsideToDismiss = true
 config.enableHapticFeedback = true
 config.autoDismissDelay = 0
 
 // 显示弹窗
 let popupView = TFYSwiftPopupView.show(
     contentView: customView,
     configuration: config,
     animated: true
 ) {
     print("弹窗显示完成")
 }
 
 2. 不同动画效果
 ========================================
 
 // 淡入淡出动画
 let fadeAnimator = TFYSwiftFadeInOutAnimator()
 
 // 缩放动画
 let zoomAnimator = TFYSwiftZoomInOutAnimator()
 
 // 3D翻转动画
 let flipAnimator = TFYSwift3DFlipAnimator()
 
 // 弹性动画
 let bounceAnimator = TFYSwiftBounceAnimator()
 
 // 滑动动画
 let slideAnimator = TFYSwiftSlideAnimator(direction: .fromBottom)
 
 // 旋转动画
 let rotateAnimator = TFYSwiftRotateAnimator()
 
 // 使用不同动画器
 TFYSwiftPopupView.show(
     contentView: customView,
     animator: bounceAnimator,
     animated: true
 )
 
 3. 底部弹出框
 ========================================
 
 // 底部弹出框配置
 var bottomSheetConfig = TFYSwiftBottomSheetAnimator.Configuration()
 bottomSheetConfig.defaultHeight = 300
 bottomSheetConfig.minimumHeight = 100
 bottomSheetConfig.maximumHeight = 600
 bottomSheetConfig.allowsFullScreen = true
 
 // 显示底部弹出框
 TFYSwiftPopupView.showBottomSheet(
     contentView: customView,
     configuration: bottomSheetConfig
 )
 
 4. 实用方法
 ========================================
 
 // 显示警告弹窗
 TFYSwiftPopupView.showAlert(
     title: "提示",
     message: "这是一个警告弹窗",
     buttonTitle: "知道了"
 )
 
 // 显示确认弹窗
 TFYSwiftPopupView.showConfirm(
     title: "确认",
     message: "确定要删除吗？",
     confirmTitle: "删除",
     cancelTitle: "取消",
     onConfirm: {
         print("用户确认删除")
     },
     onCancel: {
         print("用户取消删除")
     }
 )
 
 // 显示加载弹窗
 let loadingPopup = TFYSwiftPopupView.showLoading(message: "加载中...")
 
 // 隐藏加载弹窗
 loadingPopup.dismiss(animated: true)
 
 // 显示成功提示
 TFYSwiftPopupView.showSuccess(message: "操作成功！")
 
 // 显示错误提示
 TFYSwiftPopupView.showError(message: "操作失败，请重试")
 
 5. 高级配置
 ========================================
 
 // 键盘配置
 var keyboardConfig = KeyboardConfiguration()
 keyboardConfig.isEnabled = true
 keyboardConfig.avoidingMode = .transform
 keyboardConfig.additionalOffset = 20
 
 // 容器配置
 var containerConfig = ContainerConfiguration()
 containerConfig.width = .fixed(300)
 containerConfig.height = .automatic
 containerConfig.cornerRadius = 16
 containerConfig.shadowEnabled = true
 containerConfig.shadowColor = .black
 containerConfig.shadowOpacity = 0.3
 containerConfig.shadowRadius = 10
 
 // 主配置
 var advancedConfig = TFYSwiftPopupViewConfiguration()
 advancedConfig.keyboardConfiguration = keyboardConfig
 advancedConfig.containerConfiguration = containerConfig
 advancedConfig.maxPopupCount = 5
 advancedConfig.enableDragToDismiss = true
 advancedConfig.dragDismissThreshold = 0.3
 advancedConfig.theme = .dark
 advancedConfig.enableAccessibility = true
 
 6. 代理使用
 ========================================
 
 class ViewController: UIViewController, TFYSwiftPopupViewDelegate {
     
     func showCustomPopup() {
         let customView = createCustomView()
         
         let popupView = TFYSwiftPopupView.show(contentView: customView)
         popupView.delegate = self
     }
     
     // MARK: - TFYSwiftPopupViewDelegate
     
     func popupViewWillAppear(_ popupView: TFYSwiftPopupView) {
         print("弹窗即将显示")
     }
     
     func popupViewDidAppear(_ popupView: TFYSwiftPopupView) {
         print("弹窗已显示")
     }
     
     func popupViewWillDisappear(_ popupView: TFYSwiftPopupView) {
         print("弹窗即将消失")
     }
     
     func popupViewDidDisappear(_ popupView: TFYSwiftPopupView) {
         print("弹窗已消失")
     }
     
     func popupViewShouldDismiss(_ popupView: TFYSwiftPopupView) -> Bool {
         // 检查是否可以消失
         return true
     }
     
     func popupViewDidTapBackground(_ popupView: TFYSwiftPopupView) {
         print("用户点击了背景")
     }
 }
 
 7. 主题支持
 ========================================
 
 // 使用系统主题
 var config = TFYSwiftPopupViewConfiguration()
 config.theme = .current // 自动适配深色/浅色模式
 
 // 使用自定义主题
 config.theme = .custom(
     backgroundColor: UIColor.systemBlue.withAlphaComponent(0.9),
     textColor: .white,
     cornerRadius: 20
 )
 
 8. 多弹窗管理
 ========================================
 
 // 获取当前弹窗数量
 let count = TFYSwiftPopupView.currentPopupCount
 print("当前显示弹窗数量: \(count)")
 
 // 获取所有当前弹窗
 let allPopups = TFYSwiftPopupView.allCurrentPopups
 
 // 关闭所有弹窗
 TFYSwiftPopupView.dismissAll(animated: true) {
     print("所有弹窗已关闭")
 }
 
 9. 自定义动画器
 ========================================
 
 class CustomAnimator: TFYSwiftBaseAnimator {
     
     override func setup(popupView: TFYSwiftPopupView, contentView: UIView, backgroundView: TFYSwiftPopupView.BackgroundView) {
         super.setup(popupView: popupView, contentView: contentView, backgroundView: backgroundView)
         
         // 设置初始状态
         contentView.alpha = 0
         contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5).rotated(by: .pi)
         
         // 设置显示动画
         displayAnimationBlock = {
             contentView.alpha = 1
             contentView.transform = .identity
         }
         
         // 设置消失动画
         dismissAnimationBlock = {
             contentView.alpha = 0
             contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5).rotated(by: .pi)
         }
     }
 }
 
 // 使用自定义动画器
 let customAnimator = CustomAnimator()
 TFYSwiftPopupView.show(
     contentView: customView,
     animator: customAnimator,
     animated: true
 )
 
 10. 性能优化建议
 ========================================
 
 // 1. 合理设置弹窗数量限制
 config.maxPopupCount = 3
 
 // 2. 使用自动消失减少内存占用
 config.autoDismissDelay = 5.0
 
 // 3. 大量数据时关闭动画
 config.animationDuration = 0.1
 
 // 4. 合理使用主题
 config.theme = .current // 自动适配系统主题
 
 // 5. 及时清理弹窗
 TFYSwiftPopupView.dismissAll()
 
 11. 注意事项
 ========================================
 
 // 1. 确保contentView没有被添加到其他视图
 // 2. 合理设置弹窗数量限制，避免内存泄漏
 // 3. 在适当的时机调用dismissAll()清理弹窗
 // 4. 注意键盘处理，避免遮挡输入框
 // 5. 合理使用代理方法，避免循环引用
 // 6. 大量数据时考虑关闭动画提升性能
 // 7. 注意深色模式适配
 // 8. 合理使用触觉反馈，提升用户体验
 
 */
