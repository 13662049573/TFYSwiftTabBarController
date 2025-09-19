//
//  AllDemosViewController.swift
//  TFYSwiftTabBarController
//
//  全新的演示页面
//  展示所有TabBar功能
//

import UIKit

@available(iOS 15.0, *)
class AllDemosViewController: UITableViewController {
    
    // MARK: - 动画类型枚举
    enum AnimationType {
        case play
        case scale
        case bounce
    }
    
    // MARK: - 演示类型枚举
    
    private enum Demo: CaseIterable {
        case basic
        case liquidGlass
        case dynamicFont
        case customColors
        case badges
        case animations
        case hijack
        case layout
        case accessibility
        case performance
        
        var title: String {
            switch self {
            case .basic: return "基础功能"
            case .liquidGlass: return "iOS 26 Liquid Glass"
            case .dynamicFont: return "动态字体支持"
            case .customColors: return "自定义颜色"
            case .badges: return "徽章显示"
            case .animations: return "动画效果"
            case .hijack: return "点击劫持"
            case .layout: return "布局定制"
            case .accessibility: return "可访问性"
            case .performance: return "性能测试"
            }
        }
        
        var description: String {
            switch self {
            case .basic: return "展示基础TabBar功能"
            case .liquidGlass: return "展示iOS 26 Liquid Glass效果"
            case .dynamicFont: return "展示动态字体适配"
            case .customColors: return "展示自定义颜色主题"
            case .badges: return "展示徽章显示功能"
            case .animations: return "展示动画效果"
            case .hijack: return "展示点击劫持功能"
            case .layout: return "展示布局定制功能"
            case .accessibility: return "展示可访问性支持"
            case .performance: return "展示性能优化"
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
    
    // MARK: - 设置方法
    
    private func setupUI() {
        title = "TFYSwiftTabBarController 演示"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
        tableView.rowHeight = 80
    }
    
    // MARK: - TableView数据源
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        let demo = demos[indexPath.row]
        
        cell.textLabel?.text = demo.title
        cell.detailTextLabel?.text = demo.description
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - TableView代理
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let demo = demos[indexPath.row]
        let demoController = createDemoController(for: demo)
        
        navigationController?.pushViewController(demoController, animated: true)
    }
    
    // MARK: - 创建演示控制器
    
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
        case .animations:
            return createAnimationsDemo()
        case .hijack:
            return createHijackDemo()
        case .layout:
            return createLayoutDemo()
        case .accessibility:
            return createAccessibilityDemo()
        case .performance:
            return createPerformanceDemo()
        }
    }
    
    // MARK: - 演示创建方法
    
    private func createBasicDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "基础功能演示"
        controller.enableLiquidGlassEffect = true
        
        // 设置基础样式
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemBlue,
            iconColor: .systemGray,
            selectedIconColor: .systemBlue
        )
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "首页", content: "这是首页内容")
        let vc2 = createDemoViewController(title: "搜索", content: "这是搜索内容")
        let vc3 = createDemoViewController(title: "消息", content: "这是消息内容")
        let vc4 = createDemoViewController(title: "我的", content: "这是我的内容")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "首页", image: "house", selectedImage: "house.fill")
        let item2 = createTabBarItem(title: "搜索", image: "magnifyingglass", selectedImage: "magnifyingglass")
        let item3 = createTabBarItem(title: "消息", image: "bell", selectedImage: "bell.fill")
        let item4 = createTabBarItem(title: "我的", image: "person", selectedImage: "person.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        vc4.tabBarItem = item4
        
        controller.viewControllers = [vc1, vc2, vc3, vc4]
        
        return controller
    }
    
    private func createLiquidGlassDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "iOS 26 Liquid Glass演示"
        controller.enableLiquidGlassEffect = true
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "Liquid Glass", content: "展示iOS 26 Liquid Glass效果")
        let vc2 = createDemoViewController(title: "模糊效果", content: "展示背景模糊效果")
        let vc3 = createDemoViewController(title: "圆角阴影", content: "展示圆角和阴影效果")
        
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
    
    private func createDynamicFontDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "动态字体演示"
        controller.enableLiquidGlassEffect = true
        controller.enableDynamicFont = true
        
        // 设置字体样式
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemGreen,
            iconColor: .systemGray,
            selectedIconColor: .systemGreen
        )
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "动态字体", content: "展示动态字体适配功能")
        let vc2 = createDemoViewController(title: "字体缩放", content: "展示字体缩放效果")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "字体", image: "textformat", selectedImage: "textformat")
        let item2 = createTabBarItem(title: "缩放", image: "textformat.size", selectedImage: "textformat.size")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        
        controller.viewControllers = [vc1, vc2]
        
        return controller
    }
    
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
    
    private func createBadgesDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "徽章演示"
        controller.enableLiquidGlassEffect = true
        
        // 设置徽章样式
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemOrange,
            iconColor: .systemGray,
            selectedIconColor: .systemOrange
        )
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "徽章", content: "展示徽章显示功能")
        let vc2 = createDemoViewController(title: "数字徽章", content: "展示数字徽章")
        let vc3 = createDemoViewController(title: "文字徽章", content: "展示文字徽章")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "徽章", image: "bell", selectedImage: "bell.fill")
        let item2 = createTabBarItem(title: "数字", image: "number", selectedImage: "number")
        let item3 = createTabBarItem(title: "文字", image: "text.badge", selectedImage: "text.badge")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        // 设置徽章
        controller.setBadgeValue("3", forTabAt: 0)
        controller.setBadgeValue("99+", forTabAt: 1)
        controller.setBadgeValue("NEW", forTabAt: 2)
        
        return controller
    }
    
    private func createAnimationsDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "动画演示"
        controller.enableLiquidGlassEffect = true
        
        // 设置动画样式
        controller.setDefaultColors(
            textColor: .systemGray,
            selectedTextColor: .systemPurple,
            iconColor: .systemGray,
            selectedIconColor: .systemPurple
        )
        
        // 创建动画视图控制器
        let vc1 = createAnimationViewController(title: "动画", animationType: .play)
        let vc2 = createAnimationViewController(title: "缩放", animationType: .scale)
        let vc3 = createAnimationViewController(title: "弹跳", animationType: .bounce)
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "动画", image: "play", selectedImage: "play.fill")
        let item2 = createTabBarItem(title: "缩放", image: "arrow.up.left.and.arrow.down.right", selectedImage: "arrow.up.left.and.arrow.down.right")
        let item3 = createTabBarItem(title: "弹跳", image: "arrow.up", selectedImage: "arrow.up")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        return controller
    }
    
    private func createHijackDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createWithLiquidGlass()
        controller.title = "点击劫持演示"
        
        // 启用玻璃效果
        controller.enableLiquidGlassEffect = true
        
        // 设置劫持处理
        controller.shouldHijackHandler = { _, _, index in
            return index == 1 // 劫持第二个Tab
        }
        
        controller.didHijackHandler = { [weak controller] _, _, _ in
            let alert = UIAlertController(title: "被劫持", message: "这个Tab被劫持了！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            controller?.present(alert, animated: true)
        }
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "正常", content: "这个Tab正常工作")
        let vc2 = createDemoViewController(title: "劫持", content: "这个Tab会被劫持")
        let vc3 = createDemoViewController(title: "正常", content: "这个Tab也正常工作")
        
        // 创建TabBarItem - 使用更合适的图标
        let item1 = createTabBarItem(title: "正常", image: "checkmark.circle", selectedImage: "checkmark.circle.fill")
        let item2 = createTabBarItem(title: "劫持", image: "hand.raised", selectedImage: "hand.raised.fill")
        let item3 = createTabBarItem(title: "正常", image: "checkmark.circle", selectedImage: "checkmark.circle.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        controller.viewControllers = [vc1, vc2, vc3]
        
        return controller
    }
    
    private func createLayoutDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createBasic()
        controller.title = "布局演示"
        
        // 设置布局
        controller.setItemPositioning(.fill)
        controller.setItemEdgeInsets(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        controller.setItemSpacing(8)
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "布局", content: "展示布局定制功能")
        let vc2 = createDemoViewController(title: "边距", content: "展示边距设置")
        let vc3 = createDemoViewController(title: "间距", content: "展示间距设置")
        let vc4 = createDemoViewController(title: "宽度", content: "展示宽度设置")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "布局", image: "rectangle.grid.2x2", selectedImage: "rectangle.grid.2x2")
        let item2 = createTabBarItem(title: "边距", image: "rectangle.inset", selectedImage: "rectangle.inset")
        let item3 = createTabBarItem(title: "间距", image: "rectangle.split.2x1", selectedImage: "rectangle.split.2x1")
        let item4 = createTabBarItem(title: "宽度", image: "rectangle.portrait", selectedImage: "rectangle.portrait")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        vc4.tabBarItem = item4
        
        controller.viewControllers = [vc1, vc2, vc3, vc4]
        
        return controller
    }
    
    private func createAccessibilityDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createBasic()
        controller.title = "可访问性演示"
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "可访问性", content: "展示可访问性支持")
        let vc2 = createDemoViewController(title: "VoiceOver", content: "展示VoiceOver支持")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "可访问性", image: "accessibility", selectedImage: "accessibility")
        let item2 = createTabBarItem(title: "VoiceOver", image: "speaker", selectedImage: "speaker.fill")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        
        controller.viewControllers = [vc1, vc2]
        
        return controller
    }
    
    private func createPerformanceDemo() -> UIViewController {
        let controller = TFYSwiftTabbarController.createBasic()
        controller.title = "性能演示"
        
        // 创建视图控制器
        let vc1 = createDemoViewController(title: "性能", content: "展示性能优化")
        let vc2 = createDemoViewController(title: "内存", content: "展示内存优化")
        
        // 创建TabBarItem
        let item1 = createTabBarItem(title: "性能", image: "speedometer", selectedImage: "speedometer")
        let item2 = createTabBarItem(title: "内存", image: "memorychip", selectedImage: "memorychip")
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        
        controller.viewControllers = [vc1, vc2]
        
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 内容约束
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 功能列表约束
            featuresLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 30),
            featuresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            featuresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            featuresLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        return controller
    }
    
    private func createTabBarItem(title: String, image: String, selectedImage: String) -> TFYSwiftTabBarItem {
        let contentView = TFYSwiftTabBarItemContentView()
        contentView.titleLabel.text = title
        contentView.imageView.image = UIImage(systemName: image)
        contentView.highlightImage = UIImage(systemName: selectedImage)
        
        return TFYSwiftTabBarItem(
            contentView: contentView,
            title: title,
            image: UIImage(systemName: image),
            selectedImage: UIImage(systemName: selectedImage)
        )
    }
}
