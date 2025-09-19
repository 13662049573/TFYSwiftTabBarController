//
//  TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBar实现
//  支持iOS 15+，适配iOS 26特性
//

import UIKit

// MARK: - TabBar定位枚举
@available(iOS 15.0, *)
public enum TFYSwiftTabBarItemPositioning {
    case automatic
    case fill
    case fillExcludeSeparator
    case centered
}

// MARK: - TabBar代理协议
@available(iOS 15.0, *)
public protocol TFYSwiftTabBarDelegate: AnyObject {
    func tabBar(_ tabBar: TFYSwiftTabBar, shouldSelect item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: TFYSwiftTabBar, didSelect item: UITabBarItem)
    func tabBar(_ tabBar: TFYSwiftTabBar, shouldHijack item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: TFYSwiftTabBar, didHijack item: UITabBarItem)
}

// MARK: - 主TabBar类
@available(iOS 15.0, *)
open class TFYSwiftTabBar: UITabBar {
    
    // MARK: - 公开属性
    
    /// TabBar代理
    public weak var customDelegate: TFYSwiftTabBarDelegate?
    
    /// 关联的TabBarController
    public weak var tabBarController: TFYSwiftTabbarController?
    
    /// 自定义定位模式
    public var itemCustomPositioning: TFYSwiftTabBarItemPositioning = .fill {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 项目边距
    public var itemEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 项目宽度（0表示自动计算）
    public override var itemWidth: CGFloat {
        get { super.itemWidth }
        set {
            super.itemWidth = newValue
            setNeedsLayout()
        }
    }
    
    /// 项目间距
    public override var itemSpacing: CGFloat {
        get { super.itemSpacing }
        set {
            super.itemSpacing = newValue
            setNeedsLayout()
        }
    }
    
    /// 默认文字颜色
    public var defaultTextColor: UIColor = .label {
        didSet {
            updateAllItemsAppearance()
        }
    }
    
    /// 默认选中文字颜色
    public var defaultSelectedTextColor: UIColor = .systemBlue {
        didSet {
            updateAllItemsAppearance()
        }
    }
    
    /// 默认图标颜色
    public var defaultIconColor: UIColor = .label {
        didSet {
            updateAllItemsAppearance()
        }
    }
    
    /// 默认选中图标颜色
    public var defaultSelectedIconColor: UIColor = .systemBlue {
        didSet {
            updateAllItemsAppearance()
        }
    }
    
    /// 默认徽章偏移
    public var defaultBadgeOffset: UIOffset = UIOffset(horizontal: 6, vertical: -18) {
        didSet {
            updateAllItemsAppearance()
        }
    }
    
    /// 是否启用iOS 26 Liquid Glass效果
    public var enableLiquidGlassEffect: Bool = false {
        didSet {
            updateLiquidGlassEffect()
        }
    }
    
    /// 是否启用动态字体支持
    public var enableDynamicFont: Bool = true {
        didSet {
            updateDynamicFontSupport()
        }
    }
    
    // MARK: - 私有属性
    
    private var itemContainers: [TFYSwiftTabBarItemContainer] = []
    private var moreContentView: TFYSwiftTabBarItemMoreContentView?
    private var needsLayoutUpdate = true
    
    // MARK: - 初始化
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBar()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBar()
    }
    
    // MARK: - 设置方法
    
    private func setupTabBar() {
        // 基础设置
        isTranslucent = true  // 启用半透明以支持玻璃效果
        backgroundColor = .clear
        
        // 设置frame和autoresizingMask
        frame = bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 设置默认间距和边距
        itemSpacing = 8
        itemEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        // 设置默认颜色
        defaultTextColor = .label
        defaultSelectedTextColor = .systemBlue
        defaultIconColor = .label
        defaultSelectedIconColor = .systemBlue
        
        // 配置外观
        configureAppearance()
        
        // 设置iOS 26特性
        if #available(iOS 26.0, *) {
            setupiOS26Features()
        }
    }
    
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()  // 使用透明背景支持玻璃效果
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        
        // 移除选择指示器
        appearance.selectionIndicatorTintColor = .clear
        appearance.selectionIndicatorImage = UIImage()
        
        // 隐藏系统按钮
        appearance.stackedLayoutAppearance.normal.iconColor = .clear
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.stackedLayoutAppearance.selected.iconColor = .clear
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
    
    }
    
    @available(iOS 26.0, *)
    private func setupiOS26Features() {
        // iOS 26 Liquid Glass效果
        if enableLiquidGlassEffect {
            setupLiquidGlassEffect()
        }
        
        // 动态字体支持
        if enableDynamicFont {
            setupDynamicFontSupport()
        }
    }
    
    @available(iOS 26.0, *)
    private func setupLiquidGlassEffect() {
        // 确保TabBar完全覆盖系统TabBar
        frame = bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 使用系统原生的玻璃效果
        if #available(iOS 26.0, *) {
            // iOS 26 原生玻璃效果
            setupSystemLiquidGlassEffect()
        } else {
            // 降级到自定义模糊效果
            setupCustomBlurEffect()
        }
    }
    
    @available(iOS 26.0, *)
    private func setupSystemLiquidGlassEffect() {
        // 设置系统原生玻璃效果
        isTranslucent = true
        backgroundColor = .clear
        
        // 设置圆角和阴影
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
        
        // 使用系统原生的玻璃效果
        if let tabBarController = tabBarController {
            // 配置系统TabBar外观以支持玻璃效果
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            
            // 设置玻璃效果
            appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
            appearance.backgroundColor = .clear
            
            // 清除系统元素
            appearance.shadowColor = .clear
            appearance.selectionIndicatorTintColor = .clear
            appearance.selectionIndicatorImage = UIImage()
            
            // 隐藏系统按钮
            appearance.stackedLayoutAppearance.normal.iconColor = .clear
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.stackedLayoutAppearance.selected.iconColor = .clear
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
            
            // 应用外观
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
            tabBarController.tabBar.isTranslucent = true
            tabBarController.tabBar.backgroundColor = .clear
        }
        
        #if DEBUG
        print("🔧 [TFYSwiftTabBar] 已启用iOS 26系统原生玻璃效果")
        #endif
    }
    
    private func setupCustomBlurEffect() {
        // 降级到自定义模糊效果
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 16
        blurView.clipsToBounds = true
        insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        #if DEBUG
        print("🔧 [TFYSwiftTabBar] 已启用自定义模糊效果")
        #endif
    }
    
    private func setupDynamicFontSupport() {
        // 监听动态字体变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func contentSizeCategoryDidChange() {
        updateAllItemsAppearance()
    }
    
    // MARK: - 公共方法
    
    /// 重新加载TabBar项目
    public func reload() {
        #if DEBUG
        print("🔄 [TFYSwiftTabBar] 重新加载TabBar项目")
        #endif
        
        // 强制更新布局
        updateItemContainers()
        updateAllItemsAppearance()
    }
    
    // MARK: - 布局方法
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // 总是更新布局，确保按钮显示
        hideSystemButtons()
        updateItemContainers()
        
        // 确保TabBar在最前面
        superview?.bringSubviewToFront(self)
    }
    
    private func updateItemContainers() {
        guard let items = self.items, !items.isEmpty else { 
            #if DEBUG
            print("⚠️ [TFYSwiftTabBar] 没有TabBar项目")
            #endif
            return
        }
        
        #if DEBUG
        print("🔄 [TFYSwiftTabBar] 更新容器: 项目数量=\(items.count)")
        #endif
        
        // 清理旧容器
        itemContainers.forEach { $0.removeFromSuperview() }
        itemContainers.removeAll()
        
        // 创建新容器
        for (index, item) in items.enumerated() {
            let container = TFYSwiftTabBarItemContainer(tabBar: self, item: item, index: index)
            addSubview(container)
            itemContainers.append(container)
            
            // 确保容器可见和可交互
            container.isHidden = false
            container.alpha = 1.0
            container.isUserInteractionEnabled = true
            
            #if DEBUG
            print("   - 创建容器\(index): \(item.title ?? "无标题"), 可见=\(!container.isHidden), 交互=\(container.isUserInteractionEnabled)")
            #endif
        }
        
        // 布局容器
        layoutItemContainers()
        
        // 隐藏系统按钮
        hideSystemButtons()
        
        // 更新外观
        updateAllItemsAppearance()
    }
    
    private func layoutItemContainers() {
        guard !itemContainers.isEmpty else { return }
        
        let containerCount = itemContainers.count
        let availableWidth = bounds.width - itemEdgeInsets.left - itemEdgeInsets.right
        let availableHeight = bounds.height - itemEdgeInsets.top - itemEdgeInsets.bottom
        
        // 计算容器宽度和间距
        let totalSpacing = itemSpacing * CGFloat(containerCount - 1)
        let containerWidth: CGFloat
        
        if itemWidth > 0 {
            // 使用固定宽度
            containerWidth = itemWidth
        } else {
            // 自动计算宽度，确保不重叠
            containerWidth = (availableWidth - totalSpacing) / CGFloat(containerCount)
        }
        
        let containerHeight = availableHeight
        
        // 计算起始位置，确保居中
        let totalWidth = CGFloat(containerCount) * containerWidth + totalSpacing
        let startX = itemEdgeInsets.left + (availableWidth - totalWidth) / 2
        
        #if DEBUG
        print("🔧 [TFYSwiftTabBar] 布局调试:")
        print("   - 容器数量: \(containerCount)")
        print("   - 可用宽度: \(availableWidth)")
        print("   - 容器宽度: \(containerWidth)")
        print("   - 项目间距: \(itemSpacing)")
        print("   - 总宽度: \(totalWidth)")
        print("   - 起始X: \(startX)")
        #endif
        
        for (index, container) in itemContainers.enumerated() {
            let x = startX + CGFloat(index) * (containerWidth + itemSpacing)
            let y = itemEdgeInsets.top
            
            container.frame = CGRect(
                x: x,
                y: y,
                width: containerWidth,
                height: containerHeight
            )
            
            #if DEBUG
            print("   - 容器\(index): x=\(x), y=\(y), width=\(containerWidth), height=\(containerHeight)")
            #endif
        }
    }
    
    private func hideSystemButtons() {
        // 减少日志输出，只在调试时打印
        #if DEBUG
        print("🔧 [TFYSwiftTabBar] 开始隐藏系统按钮...")
        #endif
        
        // 使用更安全的方法隐藏系统元素
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 递归隐藏所有系统子视图
            self.hideSystemSubviews(in: self)
            
            // 确保TabBar本身不显示系统元素
            self.backgroundColor = .clear
            self.isOpaque = false
            self.isTranslucent = true
            
            #if DEBUG
            print("🔧 [TFYSwiftTabBar] 系统按钮隐藏完成")
            #endif
        }
    }
    
    private func hideSystemSubviews(in view: UIView) {
        for subview in view.subviews {
            let className = String(describing: type(of: subview))
            
            // 跳过我们的自定义容器
            if subview is TFYSwiftTabBarItemContainer {
                continue
            }
            
            // 只隐藏系统TabBar相关元素
            if subview.isKind(of: NSClassFromString("UITabBarButton")!) ||
               className.contains("SelectionIndicator") || 
               className.contains("Capsule") ||
               className.contains("_UIBarBackground") || 
               className.contains("UIBarBackground") ||
               className.contains("_UITabBarPlatterView") || 
               className.contains("_UIPortalView") {
                
                // 安全地隐藏系统元素
                subview.isHidden = true
                subview.alpha = 0
                subview.isUserInteractionEnabled = false
                
                #if DEBUG
                print("✅ [TFYSwiftTabBar] 隐藏系统元素: \(className)")
                #endif
            } else {
                // 对于其他视图，递归检查子视图
                hideSystemSubviews(in: subview)
            }
        }
    }
    
    // MARK: - 外观更新
    
    private func updateAllItemsAppearance() {
        itemContainers.forEach { container in
            container.updateAppearance()
            container.updateSelectionState(animated: false)
        }
    }
    
    private func updateLiquidGlassEffect() {
        if #available(iOS 26.0, *) {
            if enableLiquidGlassEffect {
                setupLiquidGlassEffect()
            } else {
                // 移除模糊效果
                subviews.compactMap { $0 as? UIVisualEffectView }.forEach { $0.removeFromSuperview() }
                layer.cornerRadius = 0
                layer.shadowOpacity = 0
            }
        }
    }
    
    private func updateDynamicFontSupport() {
        if enableDynamicFont {
            setupDynamicFontSupport()
        } else {
            NotificationCenter.default.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
        }
    }
    
    // MARK: - 选择方法
    
    public func selectItem(at index: Int, animated: Bool = true) {
        guard let items = self.items,
              index >= 0 && index < items.count else { 
            print("❌ [TFYSwiftTabBar] 选择索引无效: \(index), 项目数量: \(items?.count ?? 0)")
            return
        }
        
        let item = items[index]
        print("🎯 [TFYSwiftTabBar] 选择项目: 索引\(index), 标题: \(item.title ?? "无标题")")
        
        // 检查是否应该选择
        if let delegate = customDelegate,
           !delegate.tabBar(self, shouldSelect: item) {
            print("🚫 [TFYSwiftTabBar] 代理拒绝选择")
            return
        }
        
        // 检查是否应该劫持
        if let delegate = customDelegate,
           delegate.tabBar(self, shouldHijack: item) {
            print("🔄 [TFYSwiftTabBar] 执行点击劫持")
            delegate.tabBar(self, didHijack: item)
            return
        }
        
        // 通过TabBarController来管理选择状态
        if let tabBarController = tabBarController {
            print("📱 [TFYSwiftTabBar] 通过TabBarController选择: \(index)")
            tabBarController.selectedIndex = index
        } else {
            print("⚠️ [TFYSwiftTabBar] 没有TabBarController，直接更新选择状态")
            // 如果没有TabBarController，直接更新选择状态
            updateSelectionState(animated: animated)
        }
        
        // 通知代理
        customDelegate?.tabBar(self, didSelect: item)
    }
    
    private func updateSelectionState(animated: Bool) {
        itemContainers.forEach { container in
            container.updateSelectionState(animated: animated)
        }
    }
    
    /// 响应TabBarController的选择变化
    public func updateSelectionFromTabBarController() {
        updateSelectionState(animated: true)
    }
    
    // MARK: - 清理
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 容器类
@available(iOS 15.0, *)
private class TFYSwiftTabBarItemContainer: UIView {
    
    private weak var tabBar: TFYSwiftTabBar?
    private let item: UITabBarItem
    private let index: Int
    private var contentView: UIView?
    
    init(tabBar: TFYSwiftTabBar, item: UITabBarItem, index: Int) {
        self.tabBar = tabBar
        self.item = item
        self.index = index
        super.init(frame: .zero)
        setupContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainer() {
        isUserInteractionEnabled = true
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        addGestureRecognizer(tapGesture)
        
        // 创建内容视图
        createContentView()
    }
    
    private func createContentView() {
        if let customItem = item as? TFYSwiftTabBarItem {
            // 自定义项目
            contentView = customItem.contentView
        } else {
            // 系统项目
            contentView = createSystemItemView()
        }
        
        guard let contentView = contentView else { return }
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 设置徽章
        if let badgeValue = item.badgeValue, !badgeValue.isEmpty {
            setupBadge(badgeValue)
        }
    }
    
    private func setupBadge(_ badgeValue: String) {
        guard let contentView = contentView as? TFYSwiftTabBarItemContentView else { return }
        
        // 确保徽章视图只添加一次
        if contentView.badgeView.superview == nil {
            contentView.addSubview(contentView.badgeView)
            print("🔧 [TFYSwiftTabBar] 添加徽章视图到容器")
        }
        
        contentView.badgeView.setBadgeValue(badgeValue)
        print("🔧 [TFYSwiftTabBar] 设置徽章值: \(badgeValue)")
    }
    
    private func createSystemItemView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        // 创建图标视图
        let imageView = UIImageView()
        imageView.image = item.image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = tabBar?.defaultIconColor ?? .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textAlignment = .center
        titleLabel.textColor = tabBar?.defaultTextColor ?? .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -4)
        ])
        
        #if DEBUG
        print("🔧 [TFYSwiftTabBar] 创建系统项目视图: \(item.title ?? "无标题"), 图标=\(item.image != nil ? "有" : "无")")
        #endif
        
        return containerView
    }
    
    @objc private func containerTapped() {
        tabBar?.selectItem(at: index, animated: true)
    }
    
    func updateAppearance() {
        guard let tabBar = tabBar else { return }
        
        // 更新颜色
        if let contentView = contentView as? TFYSwiftTabBarItemContentView {
            contentView.textColor = tabBar.defaultTextColor
            contentView.highlightTextColor = tabBar.defaultSelectedTextColor
            contentView.iconColor = tabBar.defaultIconColor
            contentView.highlightIconColor = tabBar.defaultSelectedIconColor
            contentView.badgeOffset = tabBar.defaultBadgeOffset
        } else {
            // 更新系统项目视图的颜色
            updateSystemItemAppearance(isSelected: false)
        }
    }
    
    func updateSelectionState(animated: Bool) {
        // 使用TabBarController的selectedIndex来判断选中状态
        let isSelected: Bool
        if let tabBarController = tabBar?.tabBarController {
            isSelected = tabBarController.selectedIndex == index
        } else {
            isSelected = tabBar?.selectedItem == item
        }
        
        #if DEBUG
        print("🎯 [TFYSwiftTabBar] 更新选中状态: 索引\(index), 选中=\(isSelected)")
        #endif
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.updateSelectionAppearance(isSelected: isSelected)
            }
        } else {
            updateSelectionAppearance(isSelected: isSelected)
        }
    }
    
    private func updateSelectionAppearance(isSelected: Bool) {
        guard tabBar != nil else { return }
        
        if let contentView = contentView as? TFYSwiftTabBarItemContentView {
            contentView.isSelected = isSelected
        } else {
            // 更新系统项目的外观
            updateSystemItemAppearance(isSelected: isSelected)
        }
    }
    
    private func updateSystemItemAppearance(isSelected: Bool) {
        guard let tabBar = tabBar else { return }
        
        // 更新图标和文字颜色 - 只在contentView中查找
        if let contentView = contentView {
            for subview in contentView.subviews {
                if let imageView = subview as? UIImageView {
                    imageView.tintColor = isSelected ? tabBar.defaultSelectedIconColor : tabBar.defaultIconColor
                    #if DEBUG
                    print("🔧 [TFYSwiftTabBar] 更新图标颜色: 索引\(index), 选中=\(isSelected), 颜色=\(imageView.tintColor)")
                    #endif
                } else if let label = subview as? UILabel {
                    label.textColor = isSelected ? tabBar.defaultSelectedTextColor : tabBar.defaultTextColor
                    #if DEBUG
                    print("🔧 [TFYSwiftTabBar] 更新文字颜色: 索引\(index), 选中=\(isSelected), 颜色=\(label.textColor)")
                    #endif
                }
            }
        }
        
        #if DEBUG
        print("🔧 [TFYSwiftTabBar] 更新系统项目外观: 索引\(index), 选中=\(isSelected)")
        #endif
    }
}

// MARK: - More内容视图
@available(iOS 15.0, *)
private class TFYSwiftTabBarItemMoreContentView: TFYSwiftTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMoreContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMoreContentView()
    }
    
    private func setupMoreContentView() {
        // 设置More按钮的特殊样式
        titleLabel.text = "更多"
        imageView.image = UIImage(systemName: "ellipsis")
    }
}
