//
//  AllDemosViewController.swift
//  TFYSwiftTabBarController
//
//  完整功能演示页面 - 展示所有优化后的功能
//  支持iOS 15+，适配iOS 26特性
//
//  演示内容：
//  1. 基础功能 - TabBar基本使用
//  2. 液态玻璃 - iOS 26视觉效果
//  3. 动态字体 - 自适应字体大小
//  4. 自定义颜色 - 主题配置
//  5. 徽章显示 - 基础徽章功能
//  6. 徽章动画 - 脉冲/增量/显隐
//  7. 选择动画 - 9种动画类型
//  8. 长按手势 - 快捷菜单支持
//  9. 点击劫持 - 自定义行为
//  10. 布局定制 - 多种布局模式
//  11. 可访问性 - VoiceOver支持
//  12. 性能测试 - 缓存和监控
//  13. 内存优化 - 智能缓存管理
//  14. 高级功能 - 组合配置
//

import UIKit

@available(iOS 15.0, *)
class AllDemosViewController: UITableViewController {
    
    // MARK: - 动画类型枚举
    enum AnimationType {
        case play
        case scale
        case bounce
        case rotate
        case pulse
        case shake
    }
    
    // MARK: - 演示类型枚举
    
    enum Demo: CaseIterable {
        case basic
        case liquidGlass
        case dynamicFont
        case customColors
        case badges
        case badgeAnimations
        case animations
        case longPress
        case hijack
        case layout
        case accessibility
        case performance
        case memoryOptimization
        case advancedFeatures
        
        var title: String {
            switch self {
            case .basic: return "基础功能演示"
            case .liquidGlass: return "iOS 26 液态玻璃"
            case .dynamicFont: return "动态字体支持"
            case .customColors: return "自定义颜色主题"
            case .badges: return "徽章显示功能"
            case .badgeAnimations: return "徽章动画效果"
            case .animations: return "选择动画展示"
            case .longPress: return "长按手势支持"
            case .hijack: return "点击劫持演示"
            case .layout: return "布局定制功能"
            case .accessibility: return "可访问性支持"
            case .performance: return "性能测试"
            case .memoryOptimization: return "内存优化"
            case .advancedFeatures: return "高级功能"
            }
        }
        
        var description: String {
            switch self {
            case .basic: return "展示TabBar的基础功能，包括图标、文字、选中状态等"
            case .liquidGlass: return "展示iOS 26系统液态玻璃效果，半透明模糊背景"
            case .dynamicFont: return "展示动态字体支持，自动适配系统字体大小"
            case .customColors: return "展示自定义颜色主题，支持多种颜色搭配"
            case .badges: return "展示徽章显示功能，支持数字和文字徽章"
            case .badgeAnimations: return "展示徽章动画，包括脉冲、增量、批量操作"
            case .animations: return "展示9种选择动画效果：缩放、弹跳、脉冲等"
            case .longPress: return "展示长按手势功能，支持快捷菜单和自定义操作"
            case .hijack: return "展示点击劫持功能，自定义点击行为"
            case .layout: return "展示布局定制功能，支持多种布局方式"
            case .accessibility: return "展示可访问性支持，包括VoiceOver等"
            case .performance: return "展示容器缓存和性能监控功能"
            case .memoryOptimization: return "展示内存优化功能，智能缓存管理"
            case .advancedFeatures: return "展示高级功能，包括预加载、组合配置等"
            }
        }
        
        var icon: String {
            switch self {
            case .basic: return "star.fill"
            case .liquidGlass: return "sparkles"
            case .dynamicFont: return "textformat.size"
            case .customColors: return "paintbrush.fill"
            case .badges: return "number.circle.fill"
            case .badgeAnimations: return "bell.badge.fill"
            case .animations: return "play.circle.fill"
            case .longPress: return "hand.point.up.left.fill"
            case .hijack: return "hand.tap.fill"
            case .layout: return "rectangle.grid.2x2.fill"
            case .accessibility: return "accessibility"
            case .performance: return "speedometer"
            case .memoryOptimization: return "memorychip.fill"
            case .advancedFeatures: return "gearshape.2.fill"
            }
        }
        
        var color: UIColor {
            switch self {
            case .basic: return .systemBlue
            case .liquidGlass: return .systemPurple
            case .dynamicFont: return .systemGreen
            case .customColors: return .systemRed
            case .badges: return .systemOrange
            case .badgeAnimations: return .systemYellow
            case .animations: return .systemPink
            case .longPress: return .systemMint
            case .hijack: return .systemTeal
            case .layout: return .systemIndigo
            case .accessibility: return .systemBrown
            case .performance: return .systemCyan
            case .memoryOptimization: return .systemGreen
            case .advancedFeatures: return .systemGray
            }
        }
    }
    
    // MARK: - 属性
    
    private let demos = Demo.allCases
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI设置
    
    private func setupUI() {
        title = "TFYSwiftTabBarController"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 设置表格视图
        tableView.register(DemoCell.self, forCellReuseIdentifier: "DemoCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        // 添加头部视图
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        headerView.backgroundColor = .systemGroupedBackground
        
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text = "TFYSwiftTabBarController"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // 创建副标题标签
        let subtitleLabel = UILabel()
        subtitleLabel.text = "强大的iOS TabBar解决方案"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(subtitleLabel)
        
        // 创建描述标签
        let descriptionLabel = UILabel()
        descriptionLabel.text = "支持iOS 15+，完美适配iOS 26，提供丰富的自定义选项和流畅的动画效果"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .tertiaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(descriptionLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: headerView.bottomAnchor, constant: -20)
        ])
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - 表格视图数据源
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath) as! DemoCell
        let demo = demos[indexPath.row]
        cell.configure(with: demo)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let demo = demos[indexPath.row]
        let controller = createDemoController(for: demo)
        
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - 演示控制器创建
    
    private func createDemoController(for demo: Demo) -> UIViewController {
        switch demo {
        case .basic:
            return createBasicDemo()
        case .liquidGlass:
            return createLiquidGlassDemo()
        case .dynamicFont:
            return createDynamicFontDemo()
        case .customColors:
            return createCustomColorsDemo()
        case .badges:
            return createBadgesDemo()
        case .badgeAnimations:
            return createBadgeAnimationsDemo()
        case .animations:
            return createAnimationsDemo()
        case .longPress:
            return createLongPressDemo()
        case .hijack:
            return createHijackDemo()
        case .layout:
            return createLayoutDemo()
        case .accessibility:
            return createAccessibilityDemo()
        case .performance:
            return createPerformanceDemo()
        case .memoryOptimization:
            return createMemoryOptimizationDemo()
        case .advancedFeatures:
            return createAdvancedFeaturesDemo()
        }
    }
    
    // MARK: - 基础功能演示
    
    private func createBasicDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createBasic()
        controller.title = "基础功能演示"
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "首页", content: "这是基础功能演示的首页")
        let vc2 = createDemoViewController(title: "搜索", content: "这是搜索功能页面")
        let vc3 = createDemoViewController(title: "消息", content: "这是消息功能页面")
        let vc4 = createDemoViewController(title: "我的", content: "这是个人中心页面")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "首页", image: "house", selectedImage: "house.fill")
        let item2 = createTabBarItem(title: "搜索", image: "magnifyingglass", selectedImage: "magnifyingglass")
        let item3 = createTabBarItem(title: "消息", image: "message", selectedImage: "message.fill")
        let item4 = createTabBarItem(title: "我的", image: "person", selectedImage: "person.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        vc4.tabBarItem = item4
        
        controller.viewControllers = [vc1, vc2, vc3, vc4]
        
        return controller
    }
    
    // MARK: - iOS 26 液态玻璃演示
    
    private func createLiquidGlassDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "iOS 26 液态玻璃演示"
        controller.enableLiquidGlassEffect = true
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "Glass", content: "展示iOS 26系统液态玻璃效果")
        let vc2 = createDemoViewController(title: "模糊", content: "展示背景模糊效果")
        let vc3 = createDemoViewController(title: "圆角", content: "展示圆角设计效果")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "Glass", image: "sparkles", selectedImage: "sparkles")
        let item2 = createTabBarItem(title: "模糊", image: "eye", selectedImage: "eye.fill")
        let item3 = createTabBarItem(title: "圆角", image: "circle", selectedImage: "circle.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        return controller
    }
    
    // MARK: - 动态字体演示
    
    private func createDynamicFontDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithDynamicFont()
        controller.title = "动态字体演示"
        controller.enableDynamicFont = true
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "字体", content: "展示动态字体适配功能")
        let vc2 = createDemoViewController(title: "缩放", content: "展示字体缩放效果")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "字体", image: "textformat", selectedImage: "textformat")
        let item2 = createTabBarItem(title: "缩放", image: "textformat.size", selectedImage: "textformat.size")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        
        controller.viewControllers = [vc1, vc2]
        
        return controller
    }
    
    // MARK: - 自定义颜色演示
    
    private func createCustomColorsDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "自定义颜色演示"
        controller.enableLiquidGlassEffect = true
        
        // 设置自定义颜色
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemRed,
            iconColor: .systemGray,
            selectedIconColor: .systemRed
        )
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "红色主题", content: "展示红色主题效果")
        let vc2 = createDemoViewController(title: "自定义颜色", content: "展示自定义颜色效果")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "红色", image: "heart", selectedImage: "heart.fill")
        let item2 = createTabBarItem(title: "自定义", image: "paintbrush", selectedImage: "paintbrush.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        
        controller.viewControllers = [vc1, vc2]
        
        return controller
    }
    
    // MARK: - 徽章演示
    
    private func createBadgesDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "徽章演示"
        controller.enableLiquidGlassEffect = true
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "数字徽章", content: "展示数字徽章效果")
        let vc2 = createDemoViewController(title: "文字徽章", content: "展示文字徽章效果")
        let vc3 = createDemoViewController(title: "自定义徽章", content: "展示自定义徽章效果")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "数字", image: "1.circle", selectedImage: "1.circle.fill")
        let item2 = createTabBarItem(title: "文字", image: "text.badge.plus", selectedImage: "text.badge.plus")
        let item3 = createTabBarItem(title: "自定义", image: "star", selectedImage: "star.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        // 设置徽章
        controller.setBadgeValue("5", forTabAt: 0)
        controller.setBadgeValue("NEW", forTabAt: 1)
        controller.setBadgeValue("!", forTabAt: 2)
        
        return controller
    }
    
    // MARK: - 徽章动画演示
    
    private func createBadgeAnimationsDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "徽章动画演示"
        controller.enableLiquidGlassEffect = true
        
        // 创建视图控制器
        let vc1 = createInteractiveBadgeViewController(title: "脉冲动画", badgeType: .pulse)
        let vc2 = createInteractiveBadgeViewController(title: "增量更新", badgeType: .increment)
        let vc3 = createInteractiveBadgeViewController(title: "显示隐藏", badgeType: .showHide)
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "脉冲", image: "bell.badge", selectedImage: "bell.badge.fill")
        let item2 = createTabBarItem(title: "增量", image: "plus.circle", selectedImage: "plus.circle.fill")
        let item3 = createTabBarItem(title: "切换", image: "eye", selectedImage: "eye.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        // 设置初始徽章
        controller.setBadgeValue("5", forTabAt: 0)
        controller.setBadgeValue("1", forTabAt: 1)
        controller.setBadgeValue("NEW", forTabAt: 2)
        
        return controller
    }
    
    // MARK: - 动画演示
    
    private func createAnimationsDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createFullFeatured()
        controller.title = "选择动画演示"
        controller.enableLiquidGlassEffect = true
        
        // 设置动画样式
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemPurple,
            iconColor: .systemGray,
            selectedIconColor: .systemPurple
        )
        
        // 创建动画类型视图控制器
        let vc1 = createAnimationTypeViewController(title: "缩放", type: .scale(), controller: controller)
        let vc2 = createAnimationTypeViewController(title: "弹跳", type: .bounce, controller: controller)
        let vc3 = createAnimationTypeViewController(title: "脉冲", type: .pulse, controller: controller)
        let vc4 = createAnimationTypeViewController(title: "无动画", type: .none, controller: controller)
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "缩放", image: "arrow.up.left.and.arrow.down.right", selectedImage: "arrow.up.left.and.arrow.down.right")
        let item2 = createTabBarItem(title: "弹跳", image: "arrow.up.bounce", selectedImage: "arrow.up.bounce")
        let item3 = createTabBarItem(title: "脉冲", image: "heart.circle", selectedImage: "heart.circle.fill")
        let item4 = createTabBarItem(title: "无动画", image: "pause.circle", selectedImage: "pause.circle.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        vc4.tabBarItem = item4
        
        controller.viewControllers = [vc1, vc2, vc3, vc4]
        
        // 默认使用缩放动画
        controller.setSelectionAnimation(.scale(), duration: 0.25)
        
        return controller
    }
    
    // MARK: - 长按手势演示
    
    private func createLongPressDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLongPress()
        controller.title = "长按手势演示"
        controller.enableLiquidGlassEffect = true
        
        // 设置长按处理器
        controller.longPressHandler = { [weak controller] tabBarController, item, index in
            guard controller != nil else { return }
            
            let alert = UIAlertController(
                title: item.title,
                message: "你长按了「\(item.title ?? "")」标签页",
                preferredStyle: .actionSheet
            )
            
            alert.addAction(UIAlertAction(title: "刷新页面", style: .default) { _ in
                print("刷新页面: \(index)")
            })
            
            alert.addAction(UIAlertAction(title: "设置", style: .default) { _ in
                print("打开设置: \(index)")
            })
            
            alert.addAction(UIAlertAction(title: "关于", style: .default) { _ in
                print("关于: \(index)")
            })
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            
            tabBarController.present(alert, animated: true)
        }
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "长按我", content: "长按TabBar项目查看快捷菜单")
        let vc2 = createDemoViewController(title: "试试看", content: "长按可以显示更多操作")
        let vc3 = createDemoViewController(title: "很方便", content: "支持多种快捷操作")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "长按我", image: "hand.point.up.left", selectedImage: "hand.point.up.left.fill")
        let item2 = createTabBarItem(title: "试试看", image: "hand.tap", selectedImage: "hand.tap.fill")
        let item3 = createTabBarItem(title: "很方便", image: "hand.raised", selectedImage: "hand.raised.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        return controller
    }
    
    // MARK: - 点击劫持演示
    
    private func createHijackDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "点击劫持演示"
        controller.enableLiquidGlassEffect = true
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "劫持", content: "展示点击劫持功能")
        let vc2 = createDemoViewController(title: "自定义", content: "展示自定义点击行为")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "劫持", image: "hand.tap", selectedImage: "hand.tap.fill")
        let item2 = createTabBarItem(title: "自定义", image: "gearshape", selectedImage: "gearshape.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        
        controller.viewControllers = [vc1, vc2]
        
        return controller
    }
    
    // MARK: - 布局演示
    
    private func createLayoutDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createBasic()
        controller.title = "布局演示"
        
        // 设置布局
        controller.setItemPositioning(.fill)
        controller.setItemEdgeInsets(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "填充", content: "展示填充布局")
        let vc2 = createDemoViewController(title: "居中", content: "展示居中布局")
        let vc3 = createDemoViewController(title: "自定义", content: "展示自定义布局")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "填充", image: "rectangle.fill", selectedImage: "rectangle.fill")
        let item2 = createTabBarItem(title: "居中", image: "circle.fill", selectedImage: "circle.fill")
        let item3 = createTabBarItem(title: "自定义", image: "square.fill", selectedImage: "square.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        return controller
    }
    
    // MARK: - 可访问性演示
    
    private func createAccessibilityDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createBasic()
        controller.title = "可访问性演示"
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "可访问性", content: "展示可访问性支持")
        let vc2 = createDemoViewController(title: "VoiceOver", content: "展示VoiceOver支持")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "可访问性", image: "accessibility", selectedImage: "accessibility")
        let item2 = createTabBarItem(title: "VoiceOver", image: "speaker.wave.2", selectedImage: "speaker.wave.2.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        
        controller.viewControllers = [vc1, vc2]
        
        return controller
    }
    
    // MARK: - 性能演示
    
    private func createPerformanceDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createFullFeatured()
        controller.title = "性能演示"
        
        // 预加载内容提升性能
        controller.preloadTabBarContent()
        
        // 创建性能测试视图控制器
        let vc1 = createPerformanceTestViewController(title: "容器缓存", testType: .caching, controller: controller)
        let vc2 = createPerformanceTestViewController(title: "内存信息", testType: .memoryInfo, controller: controller)
        let vc3 = createPerformanceTestViewController(title: "动画性能", testType: .animation, controller: controller)
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "缓存", image: "arrow.triangle.2.circlepath", selectedImage: "arrow.triangle.2.circlepath.circle.fill")
        let item2 = createTabBarItem(title: "内存", image: "memorychip", selectedImage: "memorychip.fill")
        let item3 = createTabBarItem(title: "动画", image: "speedometer", selectedImage: "speedometer")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        return controller
    }
    
    // MARK: - 内存优化演示
    
    private func createMemoryOptimizationDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createFullFeatured()
        controller.title = "内存优化演示"
        
        // 创建内存优化视图控制器
        let vc1 = createMemoryOptimizationViewController(title: "查看缓存", controller: controller)
        let vc2 = createMemoryOptimizationViewController(title: "清理缓存", controller: controller)
        let vc3 = createMemoryOptimizationViewController(title: "优化内存", controller: controller)
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "查看", image: "doc.text.magnifyingglass", selectedImage: "doc.text.magnifyingglass")
        let item2 = createTabBarItem(title: "清理", image: "trash", selectedImage: "trash.fill")
        let item3 = createTabBarItem(title: "优化", image: "wand.and.stars", selectedImage: "wand.and.stars")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        return controller
    }
    
    // MARK: - 高级功能演示
    
    private func createAdvancedFeaturesDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "高级功能演示"
        controller.enableLiquidGlassEffect = true
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "手势", content: "展示手势支持")
        let vc2 = createDemoViewController(title: "多语言", content: "展示多语言支持")
        let vc3 = createDemoViewController(title: "主题", content: "展示主题切换")
        let vc4 = createDemoViewController(title: "配置", content: "展示配置选项")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "手势", image: "hand.point.up", selectedImage: "hand.point.up.fill")
        let item2 = createTabBarItem(title: "多语言", image: "globe", selectedImage: "globe")
        let item3 = createTabBarItem(title: "主题", image: "paintpalette", selectedImage: "paintpalette.fill")
        let item4 = createTabBarItem(title: "配置", image: "gearshape.2", selectedImage: "gearshape.2.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        vc4.tabBarItem = item4
        
        controller.viewControllers = [vc1, vc2, vc3, vc4]
        
        return controller
    }
    
    // MARK: - 动画视图控制器创建方法
    
    private func createAnimationViewController(title: String, animationType: AnimationType) -> UIViewController {
        let controller = UIViewController()
        controller.title = title
        
        // 创建滚动视图
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(scrollView)
        
        // 创建内容视图
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 创建副标题标签
        let subtitleLabel = UILabel()
        subtitleLabel.text = getAnimationSubtitle(for: animationType)
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // 创建动画视图
        let animationView = createAnimationView(for: animationType)
        contentView.addSubview(animationView)
        
        // 创建功能列表
        let featuresLabel = UILabel()
        featuresLabel.text = "• 支持iOS 15+\n• 适配iOS 26特性\n• Liquid Glass效果\n• 动态字体支持\n• 自定义颜色主题\n• 徽章显示功能\n• 动画效果\n• 点击劫持\n• 布局定制\n• 可访问性支持\n• 性能优化"
        featuresLabel.font = UIFont.systemFont(ofSize: 16)
        featuresLabel.textColor = .tertiaryLabel
        featuresLabel.textAlignment = .left
        featuresLabel.numberOfLines = 0
        featuresLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(featuresLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // ScrollView约束
            scrollView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
            
            // ContentView约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 副标题约束
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 动画视图约束
            animationView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            animationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            
            // 功能列表约束
            featuresLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30),
            featuresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            featuresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            featuresLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // 开始动画
        startAnimation(for: animationView, type: animationType)
        
        return controller
    }
    
    private func getAnimationSubtitle(for type: AnimationType) -> String {
        switch type {
        case .play:
            return "展示播放动画效果"
        case .scale:
            return "展示缩放动画效果"
        case .bounce:
            return "展示弹跳动画效果"
        case .rotate:
            return "展示旋转动画效果"
        case .pulse:
            return "展示脉冲动画效果"
        case .shake:
            return "展示摇摆动画效果"
        }
    }
    
    private func createAnimationView(for type: AnimationType) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemPurple
        iconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconView)
        
        // 设置图标
        switch type {
        case .play:
            iconView.image = UIImage(systemName: "play.circle.fill")
        case .scale:
            iconView.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right.circle.fill")
        case .bounce:
            iconView.image = UIImage(systemName: "arrow.up.circle.fill")
        case .rotate:
            iconView.image = UIImage(systemName: "arrow.clockwise.circle.fill")
        case .pulse:
            iconView.image = UIImage(systemName: "heart.circle.fill")
        case .shake:
            iconView.image = UIImage(systemName: "hand.wave.circle.fill")
        }
        
        // 设置约束
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 100),
            iconView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        return containerView
    }
    
    private func startAnimation(for view: UIView, type: AnimationType) {
        guard let iconView = view.subviews.first as? UIImageView else { return }
        
        switch type {
        case .play:
            startPlayAnimation(iconView)
        case .scale:
            startScaleAnimation(iconView)
        case .bounce:
            startBounceAnimation(iconView)
        case .rotate:
            startRotateAnimation(iconView)
        case .pulse:
            startPulseAnimation(iconView)
        case .shake:
            startShakeAnimation(iconView)
        }
    }
    
    private func startPlayAnimation(_ iconView: UIImageView) {
        // 旋转动画
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 2.0
        rotation.repeatCount = .infinity
        iconView.layer.add(rotation, forKey: "rotation")
    }
    
    private func startScaleAnimation(_ iconView: UIImageView) {
        // 缩放动画
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 1.3
        scale.duration = 1.0
        scale.autoreverses = true
        scale.repeatCount = .infinity
        iconView.layer.add(scale, forKey: "scale")
    }
    
    private func startBounceAnimation(_ iconView: UIImageView) {
        // 弹跳动画
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.values = [0, -20, 0]
        bounce.duration = 1.0
        bounce.repeatCount = .infinity
        bounce.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        iconView.layer.add(bounce, forKey: "bounce")
    }
    
    private func startRotateAnimation(_ iconView: UIImageView) {
        // 旋转动画
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 3.0
        rotation.repeatCount = .infinity
        iconView.layer.add(rotation, forKey: "rotation")
    }
    
    private func startPulseAnimation(_ iconView: UIImageView) {
        // 脉冲动画
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.2
        pulse.duration = 0.8
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        iconView.layer.add(pulse, forKey: "pulse")
    }
    
    private func startShakeAnimation(_ iconView: UIImageView) {
        // 摇摆动画
        let shake = CAKeyframeAnimation(keyPath: "transform.rotation")
        shake.values = [0, -0.1, 0.1, -0.1, 0.1, 0]
        shake.duration = 0.5
        shake.repeatCount = .infinity
        iconView.layer.add(shake, forKey: "shake")
    }
    
    // MARK: - 徽章类型枚举
    
    enum BadgeType {
        case pulse
        case increment
        case showHide
    }
    
    enum PerformanceTestType {
        case caching
        case memoryInfo
        case animation
    }
    
    // MARK: - 辅助方法
    
    private func createInteractiveBadgeViewController(title: String, badgeType: BadgeType) -> UIViewController {
        let controller = UIViewController()
        controller.title = title
        controller.view.backgroundColor = .systemBackground
        
        // 创建说明标签
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(label)
        
        // 创建操作按钮
        let button = UIButton(type: .system)
        button.setTitle("点击测试", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(button)
        
        // 根据类型设置按钮动作
        switch badgeType {
        case .pulse:
            button.addAction(UIAction { [weak controller] _ in
                if let tabBarController = controller?.tabBarController as? TFYSwiftTabbarController {
                    tabBarController.pulseBadge(forTabAt: 0)
                }
            }, for: .touchUpInside)
            
        case .increment:
            button.addAction(UIAction { [weak controller] _ in
                if let tabBarController = controller?.tabBarController as? TFYSwiftTabbarController {
                    tabBarController.incrementBadge(forTabAt: 1, by: 1)
                }
            }, for: .touchUpInside)
            
        case .showHide:
            var isHidden = false
            button.addAction(UIAction { [weak controller] _ in
                if let tabBarController = controller?.tabBarController as? TFYSwiftTabbarController {
                    if isHidden {
                        tabBarController.showBadge(forTabAt: 2, animated: true)
                    } else {
                        tabBarController.hideBadge(forTabAt: 2, animated: true)
                    }
                    isHidden.toggle()
                }
            }, for: .touchUpInside)
        }
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            label.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            button.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40)
        ])
        
        return controller
    }
    
    private func createAnimationTypeViewController(
        title: String,
        type: TFYSwiftTabBarItemAnimationType,
        controller: TFYSwiftTabbarController
    ) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        vc.view.backgroundColor = .systemBackground
        
        // 创建标题
        let label = UILabel()
        label.text = "当前动画: \(title)"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label)
        
        // 创建切换按钮
        let button = UIButton(type: .system)
        button.setTitle("切换到此动画", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(button)
        
        button.addAction(UIAction { _ in
            controller.setSelectionAnimation(type, duration: 0.25)
            print("✅ 已切换到\(title)动画")
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: -50),
            
            button.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30)
        ])
        
        return vc
    }
    
    private func createPerformanceTestViewController(
        title: String,
        testType: PerformanceTestType,
        controller: TFYSwiftTabbarController
    ) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        vc.view.backgroundColor = .systemBackground
        
        // 创建结果文本视图
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(textView)
        
        // 创建测试按钮
        let button = UIButton(type: .system)
        button.setTitle("运行测试", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(button)
        
        button.addAction(UIAction { _ in
            var result = ""
            
            switch testType {
            case .caching:
                let memoryInfo = controller.getTabBarMemoryInfo()
                result = """
                📊 容器缓存信息
                ==================
                缓存容器数: \(memoryInfo["containerCacheCount"] ?? 0)
                活动容器数: \(memoryInfo["itemContainersCount"] ?? 0)
                More视图: \(memoryInfo["hasMoreContentView"] as? Bool == true ? "是" : "否")
                
                💡 提示：
                - 缓存容器会被复用，提升性能
                - 切换tab时容器不会重建
                - 内存压力时可清理缓存
                """
                
            case .memoryInfo:
                let memoryInfo = controller.getTabBarMemoryInfo()
                let processInfo = ProcessInfo.processInfo
                result = """
                💾 内存使用信息
                ==================
                物理内存: \(String(format: "%.2f", Double(processInfo.physicalMemory) / 1024 / 1024 / 1024)) GB
                缓存容器: \(memoryInfo["containerCacheCount"] ?? 0)
                活动容器: \(memoryInfo["itemContainersCount"] ?? 0)
                
                优化建议：
                - 定期调用optimizeMemory()
                - 内存警告时清理缓存
                - 后台时释放资源
                """
                
            case .animation:
                let animationType = controller.customTabBar.selectionAnimationType
                let duration = controller.customTabBar.animationDuration
                
                result = """
                ⚡️ 动画配置信息
                ==================
                当前动画类型: \(animationType == .scale() ? "缩放" : animationType == .bounce ? "弹跳" : animationType == .pulse ? "脉冲" : "其他")
                动画时长: \(String(format: "%.2f", duration))秒
                
                支持的动画类型：
                • 缩放 (scale)
                • 弹跳 (bounce)
                • 脉冲 (pulse)
                • 淡入淡出 (fade)
                • 滑动 (slide)
                • 旋转 (rotation)
                
                性能建议：
                - 动画时长: 0.2-0.3秒
                - 减少动画可禁用
                - 使用CATransaction优化
                """
            }
            
            textView.text = result
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 300),
            
            button.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor)
        ])
        
        return vc
    }
    
    private func createMemoryOptimizationViewController(
        title: String,
        controller: TFYSwiftTabbarController
    ) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        vc.view.backgroundColor = .systemBackground
        
        // 创建信息标签
        let infoLabel = UILabel()
        infoLabel.text = title
        infoLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        infoLabel.textColor = .label
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(infoLabel)
        
        // 创建结果标签
        let resultLabel = UILabel()
        resultLabel.font = UIFont.systemFont(ofSize: 16)
        resultLabel.textColor = .secondaryLabel
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(resultLabel)
        
        // 创建操作按钮
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(button)
        
        switch title {
        case "查看缓存":
            button.setTitle("查看缓存信息", for: .normal)
            button.addAction(UIAction { _ in
                let memoryInfo = controller.getTabBarMemoryInfo()
                resultLabel.text = """
                缓存容器数: \(memoryInfo["containerCacheCount"] ?? 0)
                活动容器数: \(memoryInfo["itemContainersCount"] ?? 0)
                """
            }, for: .touchUpInside)
            
        case "清理缓存":
            button.setTitle("清理所有缓存", for: .normal)
            button.addAction(UIAction { _ in
                controller.clearTabBarCache()
                let memoryInfo = controller.getTabBarMemoryInfo()
                resultLabel.text = """
                ✅ 缓存已清理
                当前缓存: \(memoryInfo["containerCacheCount"] ?? 0)
                """
            }, for: .touchUpInside)
            
        case "优化内存":
            button.setTitle("执行内存优化", for: .normal)
            button.addAction(UIAction { _ in
                controller.optimizeMemory()
                resultLabel.text = "✅ 内存优化完成\n已清理不必要的资源"
            }, for: .touchUpInside)
            
        default:
            button.setTitle("测试", for: .normal)
        }
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            infoLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -40),
            
            button.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            button.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
            
            resultLabel.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 40),
            resultLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 40),
            resultLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -40)
        ])
        
        return vc
    }
    
    // MARK: - 辅助方法
    
    private func createDemoViewController(title: String, content: String) -> UIViewController {
        let controller = UIViewController()
        controller.title = title
        
        // 创建滚动视图
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(scrollView)
        
        // 创建内容视图
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 创建内容标签
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = UIFont.systemFont(ofSize: 18)
        contentLabel.textColor = .secondaryLabel
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)
        
        // 创建功能列表
        let featuresLabel = UILabel()
        featuresLabel.text = "• 支持iOS 15+\n• 适配iOS 26特性\n• Liquid Glass效果\n• 动态字体支持\n• 自定义颜色主题\n• 徽章显示功能\n• 动画效果\n• 点击劫持\n• 布局定制\n• 可访问性支持\n• 性能优化"
        featuresLabel.font = UIFont.systemFont(ofSize: 16)
        featuresLabel.textColor = .tertiaryLabel
        featuresLabel.textAlignment = .left
        featuresLabel.numberOfLines = 0
        featuresLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(featuresLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // ScrollView约束
            scrollView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
            
            // ContentView约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 内容约束
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 功能列表约束
            featuresLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 30),
            featuresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            featuresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            featuresLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        return controller
    }
    
    private func createTabBarItem(title: String, image: String, selectedImage: String) -> UITabBarItem {
        let item = UITabBarItem(
            title: title,
            image: UIImage(systemName: image),
            selectedImage: UIImage(systemName: selectedImage)
        )
        return item
    }
}

// MARK: - 演示单元格

@available(iOS 15.0, *)
class DemoCell: UITableViewCell {
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let colorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        // 设置颜色视图
        colorView.layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        // 设置图标视图
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        
        // 设置标题标签
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 设置描述标签
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 颜色视图约束
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 50),
            colorView.heightAnchor.constraint(equalToConstant: 50),
            
            // 图标视图约束
            iconView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            // 标题标签约束
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // 描述标签约束
            descriptionLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with demo: AllDemosViewController.Demo) {
        titleLabel.text = demo.title
        descriptionLabel.text = demo.description
        iconView.image = UIImage(systemName: demo.icon)
        colorView.backgroundColor = demo.color
    }
}
