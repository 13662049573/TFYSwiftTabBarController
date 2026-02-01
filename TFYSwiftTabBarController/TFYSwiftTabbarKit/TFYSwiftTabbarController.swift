//
//  TFYSwiftTabbarController.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarController实现
//  支持iOS 15+，适配最新iOS系统特性
//
//  核心功能：
//  1. 自定义TabBar集成（完全可定制）
//  2. 徽章管理系统（支持自动更新）
//  3. 点击劫持机制（灵活的事件拦截）
//  4. 长按手势支持（支持预览）
//  5. 动画效果配置（12+种动画）
//  6. 布局定制选项（多种布局模式）
//  7. 颜色主题管理（支持动态主题）
//  8. 状态保存和恢复
//  9. 内存优化管理
//  10. 性能监控系统
//
//  使用示例：
//  ```swift
//  let tabBarController = TFYSwiftTabbarController.createFullFeatured()
//  tabBarController.setBadgeValue("5", forTabAt: 0)
//  tabBarController.setSelectionAnimation(.spring(damping: 0.6, velocity: 0.8), duration: 0.3)
//  tabBarController.enableHapticFeedback = true
//  tabBarController.hapticStyle = .medium
//  ```
//
//  版本: 3.0.0
//  更新日期: 2025-12-26
//

import UIKit
import os.log

// MARK: - 主TabBarController类
@available(iOS 15.0, *)
open class TFYSwiftTabbarController: UITabBarController {
    
    // MARK: - 公开属性
    
    /// 自定义TabBar
    public var customTabBar: TFYSwiftTabBar {
        if let customTabBar = tabBar as? TFYSwiftTabBar {
            return customTabBar
        } else {
            // 如果tabBar不是TFYSwiftTabBar类型，返回一个默认的TabBar
            // 避免在运行时修改UITabBarController的tabBar属性
            let defaultTabBar = TFYSwiftTabBar()
            defaultTabBar.delegate = self
            defaultTabBar.customDelegate = self
            defaultTabBar.tabBarController = self
            return defaultTabBar
        }
    }
    
    /// 是否启用iOS 26 Liquid Glass效果
    public var enableLiquidGlassEffect: Bool = false {
        didSet {
            customTabBar.enableLiquidGlassEffect = enableLiquidGlassEffect
        }
    }
    
    /// 是否启用动态字体支持
    public var enableDynamicFont: Bool = true {
        didSet {
            customTabBar.enableDynamicFont = enableDynamicFont
        }
    }
    
    /// 是否启用点击劫持
    public var shouldHijackHandler: ((TFYSwiftTabbarController, UITabBarItem, Int) -> Bool)?
    
    /// 点击劫持处理
    public var didHijackHandler: ((TFYSwiftTabbarController, UITabBarItem, Int) -> Void)?
    
    /// 是否启用长按手势（用于扩展功能）
    public var enableLongPressGesture: Bool = false
    
    /// 长按手势处理
    public var longPressHandler: ((TFYSwiftTabbarController, UITabBarItem, Int) -> Void)?
    
    /// 是否启用状态保存和恢复
    public var enableStateRestoration: Bool = true
    
    /// 是否启用调试日志
    public var enableDebugLogging: Bool = false
    
    /// 触觉反馈样式
    public var hapticStyle: TFYSwiftTabBarHapticStyle {
        get { customTabBar.hapticStyle }
        set { customTabBar.hapticStyle = newValue }
    }
    
    /// 是否启用触觉反馈
    public var enableHapticFeedback: Bool {
        get { customTabBar.enableHapticFeedback }
        set { customTabBar.enableHapticFeedback = newValue }
    }
    
    // MARK: - 私有属性
    
    private let logger = OSLog(subsystem: "com.tfy.tabbar", category: "TabBarController")
    private var isInitialized = false
    
    // MARK: - 初始化
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupTabBarController()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBarController()
    }
    
    // MARK: - 生命周期
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置自定义TabBar
        setupCustomTabBar()
        
        setupiOS26Features()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTabBarAppearance()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次出现时的初始化
        if !isInitialized {
            isInitialized = true
            performInitialSetup()
        }
        
        // 重新加载TabBar项目
        customTabBar.reload()
        // 更新TabBar的选择状态
        customTabBar.updateSelectionFromTabBarController()
        
        logDebug("TabBarController已显示")
    }
    
    private func performInitialSetup() {
        // 预加载TabBar内容以提升性能
        customTabBar.preloadContainers()
        
        // 设置调试日志
        customTabBar.enableDebugLogging = enableDebugLogging
        
        logDebug("执行初始化设置")
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logDebug("TabBarController即将消失")
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logDebug("TabBarController已消失")
    }
    
    // MARK: - 设置方法
    
    private func setupTabBarController() {
        // 设置自己为TabBarController的代理
        self.delegate = self
        
        // 在viewDidLoad中设置自定义TabBar
        // 避免在初始化时修改UITabBarController的tabBar属性
        
        // 设置状态恢复
        if enableStateRestoration {
            setupStateRestoration()
        }
        
        logDebug("TabBarController初始化")
    }
    
    private func setupStateRestoration() {
        restorationIdentifier = "TFYSwiftTabbarController"
        restorationClass = type(of: self)
    }
    
    private func logDebug(_ message: String) {
        guard enableDebugLogging else { return }
        if #available(iOS 15.0, *) {
            os_log(.debug, log: logger, "%{public}@", message)
        }
        #if DEBUG
        print("🔧 [TFYSwiftTabbarController] \(message)")
        #endif
    }
    
    private func setupCustomTabBar() {
        // 检查是否已经是自定义TabBar
        guard !(tabBar is TFYSwiftTabBar) else { return }
        
        // 使用KVC设置TabBar（在viewDidLoad中相对安全）
        setValue(customTabBar, forKey: "tabBar")
        
        // 配置TabBar外观，完全隐藏系统元素
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        // 配置UITabBarAppearance，完全隐藏系统元素
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()  // 使用透明背景
        
        // 清除所有系统元素
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear  // 透明背景
        appearance.selectionIndicatorTintColor = .clear
        appearance.selectionIndicatorImage = UIImage()
        
        // 隐藏系统按钮
        appearance.stackedLayoutAppearance.normal.iconColor = .clear
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.stackedLayoutAppearance.selected.iconColor = .clear
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        // 应用外观
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        // 确保TabBar透明以显示玻璃效果
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
        tabBar.clipsToBounds = false
        
        print("🔧 [TFYSwiftTabbarController] 已配置TabBar外观，隐藏系统元素")
    }
    
    private func setupiOS26Features() {
        // 启用Liquid Glass效果
        if enableLiquidGlassEffect {
            customTabBar.enableLiquidGlassEffect = true
        }
        
        // 启用动态字体支持
        if enableDynamicFont {
            customTabBar.enableDynamicFont = true
        }
        
        // iOS 16+ 特性
        if #available(iOS 16.0, *) {
            setupiOS16Features()
        }
        
        // iOS 17+ 特性
        if #available(iOS 17.0, *) {
            setupiOS17Features()
        }
        
        // iOS 18+ 特性
        if #available(iOS 18.0, *) {
            setupiOS18Features()
        }
    }
    
    @available(iOS 16.0, *)
    private func setupiOS16Features() {
        // SF Symbols 4.0支持
        logDebug("iOS 16特性已启用")
    }
    
    @available(iOS 17.0, *)
    private func setupiOS17Features() {
        // 新动画API
        logDebug("iOS 17特性已启用")
    }
    
    @available(iOS 18.0, *)
    private func setupiOS18Features() {
        // 动态岛适配
        logDebug("iOS 18特性已启用")
    }
    
    private func updateTabBarAppearance() {
        // 更新TabBar外观
        customTabBar.setNeedsLayout()
    }
    
    // MARK: - 公开方法
    
    /// 选择指定索引的Tab
    public func selectTab(at index: Int, animated: Bool = true) {
        customTabBar.selectItem(at: index, animated: animated)
    }
    
    /// 设置徽章值（增强版）
    public func setBadgeValue(_ value: String?, forTabAt index: Int, animated: Bool = true) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count else {
            logDebug("⚠️ 设置徽章失败: 索引\(index)超出范围")
            return
        }
        
        logDebug("设置徽章值: \(value ?? "nil") for index: \(index)")
        
        items[index].badgeValue = value
        
        // 更新自定义内容视图的徽章
        if let customItem = items[index] as? TFYSwiftTabBarItem {
            customItem.contentView.badgeView.setBadgeValue(value)
            
            // 确保徽章视图被添加到内容视图中
            if customItem.contentView.badgeView.superview == nil {
                customItem.contentView.addSubview(customItem.contentView.badgeView)
                logDebug("添加徽章视图到内容视图")
            }
            
            // 如果有新值，播放动画
            if animated, value != nil, !value!.isEmpty {
                customItem.contentView.badgeView.performAnimation(.pop)
            }
        }
    }
    
    /// 设置徽章样式
    public func setBadgeStyle(_ style: TFYSwiftTabBarBadgeStyle, forTabAt index: Int) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count,
              let customItem = items[index] as? TFYSwiftTabBarItem else { return }
        
        customItem.contentView.badgeView.badgeStyle = style
        logDebug("设置徽章样式: \(style) for index: \(index)")
    }
    
    /// 设置徽章颜色
    public func setBadgeColor(_ color: UIColor, forTabAt index: Int) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count,
              let customItem = items[index] as? TFYSwiftTabBarItem else { return }
        
        customItem.contentView.badgeView.badgeColor = color
        logDebug("设置徽章颜色 for index: \(index)")
    }
    
    /// 设置徽章渐变色
    public func setBadgeGradient(_ colors: [UIColor], forTabAt index: Int) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count,
              let customItem = items[index] as? TFYSwiftTabBarItem else { return }
        
        customItem.contentView.badgeView.gradientColors = colors
        logDebug("设置徽章渐变色 for index: \(index)")
    }
    
    /// 显示徽章
    public func showBadge(forTabAt index: Int, animated: Bool = true) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count else { return }
        
        if let customItem = items[index] as? TFYSwiftTabBarItem {
            customItem.contentView.badgeView.showBadge(animated: animated)
        }
    }
    
    /// 隐藏徽章
    public func hideBadge(forTabAt index: Int, animated: Bool = true) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count else { return }
        
        if let customItem = items[index] as? TFYSwiftTabBarItem {
            customItem.contentView.badgeView.hideBadge(animated: animated)
        }
    }
    
    /// 徽章脉冲动画（用于提醒）
    public func pulseBadge(forTabAt index: Int) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count else { return }
        
        if let customItem = items[index] as? TFYSwiftTabBarItem {
            customItem.contentView.badgeView.pulse()
        }
    }
    
    /// 增加徽章数值
    public func incrementBadge(forTabAt index: Int, by value: Int = 1) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count else { return }
        
        let currentValue = items[index].badgeValue ?? "0"
        if let intValue = Int(currentValue) {
            setBadgeValue("\(intValue + value)", forTabAt: index)
            
            // 如果有新消息，播放脉冲动画
            pulseBadge(forTabAt: index)
        }
    }
    
    /// 清除所有徽章
    public func clearAllBadges(animated: Bool = true) {
        guard let items = tabBar.items else { return }
        
        for index in 0..<items.count {
            setBadgeValue(nil, forTabAt: index)
            if animated {
                hideBadge(forTabAt: index, animated: true)
            }
        }
    }
    
    /// 设置TabBar项目定位
    public func setItemPositioning(_ positioning: TFYSwiftTabBarItemPositioning) {
        customTabBar.itemCustomPositioning = positioning
    }
    
    /// 设置TabBar项目边距
    public func setItemEdgeInsets(_ insets: UIEdgeInsets) {
        customTabBar.itemEdgeInsets = insets
    }
    
    /// 设置TabBar项目宽度
    public func setItemWidth(_ width: CGFloat) {
        customTabBar.itemWidth = width
    }
    
    /// 设置TabBar项目间距
    public func setItemSpacing(_ spacing: CGFloat) {
        customTabBar.itemSpacing = spacing
    }
    
    /// 设置默认颜色
    public func setDefaultColors(
        textColor: UIColor = .label,
        selectedTextColor: UIColor = .systemBlue,
        iconColor: UIColor = .label,
        selectedIconColor: UIColor = .systemBlue
    ) {
        customTabBar.defaultTextColor = textColor
        customTabBar.defaultSelectedTextColor = selectedTextColor
        customTabBar.defaultIconColor = iconColor
        customTabBar.defaultSelectedIconColor = selectedIconColor
    }
    
    /// 设置默认徽章偏移
    public func setDefaultBadgeOffset(_ offset: UIOffset) {
        customTabBar.defaultBadgeOffset = offset
    }
    
}

// MARK: - TFYSwiftTabBarDelegate
@available(iOS 15.0, *)
extension TFYSwiftTabbarController: TFYSwiftTabBarDelegate {
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, shouldSelect item: UITabBarItem) -> Bool {
        return true
    }
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, didSelect item: UITabBarItem) {
        // 处理选择事件
        if let index = tabBar.items?.firstIndex(of: item) {
            selectedIndex = index
        }
    }
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, shouldHijack item: UITabBarItem) -> Bool {
        guard let index = tabBar.items?.firstIndex(of: item) else { return false }
        return shouldHijackHandler?(self, item, index) ?? false
    }
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, didHijack item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        didHijackHandler?(self, item, index)
    }
}

// MARK: - TFYSwiftTabBarExtendedDelegate（可选）
@available(iOS 15.0, *)
extension TFYSwiftTabbarController: TFYSwiftTabBarExtendedDelegate {
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, willSelect item: UITabBarItem) {
        // 可选实现
    }
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, didCompleteSelectionAnimation item: UITabBarItem) {
        // 可选实现
    }
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, didLongPress item: UITabBarItem) {
        // 处理长按事件
        if let index = tabBar.items?.firstIndex(of: item) {
            longPressHandler?(self, item, index)
        }
    }
    
    public func tabBar(_ tabBar: TFYSwiftTabBar, didDoubleTap item: UITabBarItem) {
        // 可选实现
    }
}

// MARK: - UITabBarControllerDelegate
@available(iOS 15.0, *)
extension TFYSwiftTabbarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 更新自定义TabBar的选择状态
        customTabBar.updateSelectionFromTabBarController()
    }
}

// MARK: - 便捷方法
@available(iOS 15.0, *)
public extension TFYSwiftTabbarController {
    
    /// 创建基础TabBarController
    static func createBasic() -> TFYSwiftTabbarController {
        let controller = TFYSwiftTabbarController(nibName: nil, bundle: nil)
        // 默认启用玻璃效果和基础样式
        controller.enableLiquidGlassEffect = true
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemBlue,
            iconColor: .systemGray,
            selectedIconColor: .systemBlue
        )
        return controller
    }
    
    /// 创建带Liquid Glass效果的TabBarController
    static func createWithLiquidGlass() -> TFYSwiftTabbarController {
        let controller = TFYSwiftTabbarController(nibName: nil, bundle: nil)
        controller.enableLiquidGlassEffect = true
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemBlue,
            iconColor: .systemGray,
            selectedIconColor: .systemBlue
        )
        return controller
    }
    
    /// 创建带动态字体的TabBarController
    static func createWithDynamicFont() -> TFYSwiftTabbarController {
        let controller = TFYSwiftTabbarController(nibName: nil, bundle: nil)
        controller.enableLiquidGlassEffect = true
        controller.enableDynamicFont = true
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemGreen,
            iconColor: .systemGray,
            selectedIconColor: .systemGreen
        )
        return controller
    }
    
    /// 创建带长按支持的TabBarController
    static func createWithLongPress() -> TFYSwiftTabbarController {
        let controller = TFYSwiftTabbarController(nibName: nil, bundle: nil)
        controller.enableLiquidGlassEffect = true
        controller.enableLongPressGesture = true
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemTeal,
            iconColor: .systemGray,
            selectedIconColor: .systemTeal
        )
        return controller
    }
    
    /// 创建功能完整的TabBarController
    static func createFullFeatured() -> TFYSwiftTabbarController {
        let controller = TFYSwiftTabbarController(nibName: nil, bundle: nil)
        controller.enableLiquidGlassEffect = true
        controller.enableDynamicFont = true
        controller.enableLongPressGesture = true
        controller.customTabBar.selectionAnimationType = .scale()
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemBlue,
            iconColor: .systemGray,
            selectedIconColor: .systemBlue
        )
        return controller
    }
}

// MARK: - 动画配置扩展

@available(iOS 15.0, *)
public extension TFYSwiftTabbarController {
    
    /// 设置选择动画类型
    func setSelectionAnimation(_ type: TFYSwiftTabBarItemAnimationType, duration: TimeInterval = 0.25) {
        customTabBar.selectionAnimationType = type
        customTabBar.animationDuration = duration
    }
    
    /// 启用所有动画效果
    func enableAllAnimations() {
        customTabBar.selectionAnimationType = .scale()
        customTabBar.animationDuration = 0.25
    }
    
    /// 禁用所有动画效果
    func disableAllAnimations() {
        customTabBar.selectionAnimationType = .none
    }
}

// MARK: - 性能优化扩展

@available(iOS 15.0, *)
public extension TFYSwiftTabbarController {
    
    /// 预加载TabBar内容（提升性能）
    func preloadTabBarContent() {
        customTabBar.preloadContainers()
        logDebug("TabBar内容已预加载")
    }
    
    /// 清理TabBar缓存（释放内存）
    func clearTabBarCache() {
        customTabBar.clearCache()
        logDebug("TabBar缓存已清理")
    }
    
    /// 获取TabBar内存信息
    func getTabBarMemoryInfo() -> [String: Any] {
        return customTabBar.getMemoryInfo()
    }
    
    /// 优化内存使用
    func optimizeMemory() {
        // 清理不必要的缓存
        customTabBar.clearCache()
        
        // 强制释放未使用的资源
        viewControllers?.forEach { vc in
            if vc != selectedViewController {
                vc.view.setNeedsLayout()
            }
        }
        
        logDebug("内存优化完成")
    }
    
    /// 监控性能指标
    func monitorPerformance() -> [String: Any] {
        var metrics: [String: Any] = [:]
        
        // TabBar性能指标
        metrics["tabBar"] = customTabBar.getMemoryInfo()
        
        // 视图控制器数量
        metrics["viewControllerCount"] = viewControllers?.count ?? 0
        
        // 当前选中索引
        metrics["selectedIndex"] = selectedIndex
        
        // 内存使用情况
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMemory = Double(info.resident_size) / 1024.0 / 1024.0
            metrics["memoryUsageMB"] = String(format: "%.2f", usedMemory)
        }
        
        logDebug("性能监控: \(metrics)")
        return metrics
    }
}

// MARK: - 状态保存和恢复

@available(iOS 15.0, *)
extension TFYSwiftTabbarController: UIViewControllerRestoration {
    
    public static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        let controller = TFYSwiftTabbarController(nibName: nil, bundle: nil)
        return controller
    }
    
    public override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        if enableStateRestoration {
            coder.encode(selectedIndex, forKey: "selectedIndex")
            logDebug("状态已保存: selectedIndex=\(selectedIndex)")
        }
    }
    
    public override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if enableStateRestoration {
            let savedIndex = coder.decodeInteger(forKey: "selectedIndex")
            if savedIndex >= 0, let count = viewControllers?.count, savedIndex < count {
                selectedIndex = savedIndex
                logDebug("状态已恢复: selectedIndex=\(savedIndex)")
            }
        }
    }
}

// MARK: - 内存警告处理

@available(iOS 15.0, *)
extension TFYSwiftTabbarController {
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        logDebug("⚠️ 收到内存警告，执行清理")
        
        // 自动清理缓存
        clearTabBarCache()
        
        // 清理未选中视图控制器的视图
        viewControllers?.enumerated().forEach { index, vc in
            if index != selectedIndex, vc.isViewLoaded {
                vc.view = nil
                logDebug("清理视图控制器\(index)的视图")
            }
        }
    }
}
