//
//  TFYSwiftTabbarController.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarController实现
//  支持iOS 15+，适配iOS 26特性
//

import UIKit

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
        // 重新加载TabBar项目
        customTabBar.reload()
        // 更新TabBar的选择状态
        customTabBar.updateSelectionFromTabBarController()
    }
    
    // MARK: - 设置方法
    
    private func setupTabBarController() {
        // 设置自己为TabBarController的代理
        self.delegate = self
        
        // 在viewDidLoad中设置自定义TabBar
        // 避免在初始化时修改UITabBarController的tabBar属性
    }
    
    private func setupCustomTabBar() {
        // 检查是否已经是自定义TabBar
        guard !(tabBar is TFYSwiftTabBar) else { return }
        
        // 创建自定义TabBar
        let customTabBar = TFYSwiftTabBar()
        customTabBar.delegate = self
        customTabBar.customDelegate = self
        customTabBar.tabBarController = self
        
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
        if #available(iOS 26.0, *) {
            // 启用Liquid Glass效果
            if enableLiquidGlassEffect {
                customTabBar.enableLiquidGlassEffect = true
            }
            
            // 启用动态字体支持
            if enableDynamicFont {
                customTabBar.enableDynamicFont = true
            }
        }
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
    
    /// 设置徽章值
    public func setBadgeValue(_ value: String?, forTabAt index: Int) {
        guard let items = tabBar.items,
              index >= 0 && index < items.count else { return }
        
        print("🔧 [TFYSwiftTabbarController] 设置徽章值: \(value ?? "nil") for index: \(index)")
        
        items[index].badgeValue = value
        
        // 更新自定义内容视图的徽章
        if let customItem = items[index] as? TFYSwiftTabBarItem {
            customItem.contentView.badgeView.setBadgeValue(value)
            // 确保徽章视图被添加到内容视图中
            if customItem.contentView.badgeView.superview == nil {
                customItem.contentView.addSubview(customItem.contentView.badgeView)
                print("🔧 [TFYSwiftTabbarController] 添加徽章视图到内容视图")
            }
        }
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
}
