//
//  DemoFactories.swift
//  TFYSwiftTabBarController
//
//  全量功能示范工厂：覆盖 TFYSwiftTabbarKit 公开能力
//

import SnapKit
import UIKit

@available(iOS 15.0, *)
enum DemoFactories {

    // MARK: - 基础风格

    static func basicDefault() -> UIViewController {
        DemoSupport.makeTab(
            style: .default,
            detail: "styleType = .default\n四 Tab + 资源图 + BaseNavigationController"
        )
    }

    static func systemStyle() -> UIViewController {
        DemoSupport.makeTab(
            style: .system,
            detail: "styleType = .system\n更接近系统 TabBar 行为"
        )
    }

    static func liquidGlass() -> UIViewController {
        DemoSupport.makeTab(
            style: .liquidGlass,
            detail: "styleType = .liquidGlass\n在支持 Liquid Glass 的系统上启用 platter 路径；低版本会降级"
        )
    }

    static func customAppearance() -> UIViewController {
        DemoSupport.makeTab(
            style: .default,
            detail: "tabBarHeight / setTintColor / hideTabBarShadowImageView / reloadTabBarItems",
            configureTab: { tab in
                tab.tabBarHeight = 54
                tab.setTintColor(.systemTeal)
                tab.hideTabBarShadowImageView()
                tab.setViewDidLayoutSubViewsBlockInvokeOnce(true) { controller in
                    controller.hideTabBadgeBackgroundSeparator()
                }
            }
        )
    }

    static func delegateAndConfiguration() -> UIViewController {
        let children = DemoSupport.makeFourChildren(
            detail: "TFYSwiftTabBarControllerDelegate\n右上角可切换 selectedIndex、重设控制器并刷新 Item"
        )
        return DelegateConfigurationDemoController(
            viewControllers: children,
            tabBarItemsAttributes: DemoSupport.standardFourAttrs(lottie: false)
        )
    }

    static func itemLayoutAdjustments() -> UIViewController {
        var attributes = DemoSupport.standardFourAttrs()
        attributes[0][TFYSwiftTabBarItemImageInsets] = NSValue(
            uiEdgeInsets: UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
        )
        attributes[1][TFYSwiftTabBarItemTitlePositionAdjustment] = NSValue(
            uiOffset: UIOffset(horizontal: 0, vertical: -4)
        )
        var imageAdjustedAttributes = attributes[2]
        imageAdjustedAttributes[TFYSwiftTabBarItemImagePositionAdjustment] = NSValue(
            uiOffset: UIOffset(horizontal: 5, vertical: 0)
        )
        attributes[2] = imageAdjustedAttributes
        return DemoSupport.makeTab(
            attributes: attributes,
            detail: "依次展示 imageInsets / titlePositionAdjustment / imagePositionAdjustment"
        )
    }

    // MARK: - Plus

    static func plusActionOnly() -> UIViewController {
        DemoActionPlusButton.registerPlusButton()
        return DemoSupport.makeTab(
            style: .default,
            context: DemoActionPlusButton.contextKey,
            detail: "TFYSwiftPlusButtonSubclassing\n仅动作中间按钮（弹 Alert），不插入 Child VC"
        )
    }

    static func plusWithChild() -> UIViewController {
        DemoChildPlusButton.registerPlusButton()
        // Plus child 会插入到 index 2，外部传 4 个；库会对齐
        return DemoSupport.makeTab(
            style: .default,
            context: DemoChildPlusButton.contextKey,
            detail: "中间按钮带 plusChildViewController\n点相机按钮进入「发布」页"
        )
    }

    // MARK: - Badge

    static func badges() -> UIViewController {
        let tab = DemoSupport.makeTab(
            style: .default,
            detail: "UIViewController / UITabBarItem Badge API\ntfy_showBadge / tfy_showBadgeValue / tfy_clearBadge / 动画"
        ) { index, child in
            guard let page = (child as? UINavigationController)?.topViewController as? DemoInfoViewController else { return }
            // Replace with interactive page below via configureTab after creation — handled in actions on first tab
            _ = (index, page)
        }

        // Rebuild first page with badge actions
        guard let nav0 = tab.viewControllers?[0] as? UINavigationController else { return tab }
        let host = nav0.topViewController
        let actions: [(String, () -> Void)] = [
            ("红点", { host?.tfy_showBadge() }),
            ("数字 5 · bounce", { host?.tfy_showBadgeValue("5", animationType: .bounce) }),
            ("数字 120 → 99+", { host?.tfy_showBadgeValue("120", animationType: .scale) }),
            ("NEW · scaleOnce", { host?.tfy_showBadgeValue("NEW", animationType: .scaleOnce) }),
            ("shake", { host?.tfy_showBadgeValue("8", animationType: .shake) }),
            ("breathe", { host?.tfy_showBadgeValue("3", animationType: .breathe) }),
            ("none", { host?.tfy_showBadgeValue("1", animationType: .none) }),
            ("leftRightOnce", { host?.tfy_showBadgeValue("2", animationType: .leftRightOnce) }),
            ("rightLeftOnce", { host?.tfy_showBadgeValue("3", animationType: .rightLeftOnce) }),
            ("rollingOnce", { host?.tfy_showBadgeValue("4", animationType: .rollingOnce) }),
            ("clear", { host?.tfy_clearBadge() }),
            ("resume", { host?.tfy_resumeBadge() }),
            ("Tab1 红点", {
                tab.viewControllers?[1].tfy_getViewControllerInsteadOfNavigationController().tfy_showBadge()
            }),
            ("Tab2 数字 via tabBarItem", {
                tab.viewControllers?[2].tabBarItem.tfy_showBadgeValue("99", animationType: .fadeInOnce)
            })
        ]
        let page = DemoInfoViewController(
            titleText: "徽章",
            detail: "覆盖红点 / 数字 / NEW / 多种动画 / clear / resume",
            actions: actions
        )
        page.navigationItem.leftBarButtonItem = host?.navigationItem.leftBarButtonItem
        nav0.setViewControllers([page], animated: false)

        // Nav bar button badge
        let barItem = UIBarButtonItem(title: "铃铛", style: .plain, target: nil, action: nil)
        page.navigationItem.rightBarButtonItem = barItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            barItem.tfy_showBadgeValue("2", animationType: .bounce)
        }
        return tab
    }

    // MARK: - Lottie

    static func lottieTabs() -> UIViewController {
        lottieTabBar(
            titles: ["首页", "发现", "资讯", "我的"],
            images: ["home", "find", "message", "me"],
            selectedImages: ["home_1", "find_1", "message_1", "me_1"],
            lottieNames: [
                "green_lottie_tab_home", "green_lottie_tab_discover",
                "green_lottie_tab_news", "green_lottie_tab_mine"
            ],
            usesURL: true,
            detail: "绿色 Lottie TabBar\n使用 TFYSwiftTabBarLottieURL，四个 Tab 各自播放独立动画"
        )
    }

    static func grayLottieTabs() -> UIViewController {
        lottieTabBar(
            titles: ["首页", "消息", "我的"],
            images: ["home", "message", "me"],
            selectedImages: ["home_1", "message_1", "me_1"],
            lottieNames: [
                "gray_tabbar_home_animation", "gray_tabbar_message_animation", "gray_tabbar_me_animation"
            ],
            usesURL: false,
            detail: "灰色图片型 Lottie TabBar\nJSON 会加载 LottieResources 中对应的 7 张 PNG 帧资源"
        )
    }

    static func colorLottieTabs() -> UIViewController {
        lottieTabBar(
            titles: ["首页", "搜索", "消息", "我的"],
            images: ["home", "find", "message", "me"],
            selectedImages: ["home_1", "find_1", "message_1", "me_1"],
            lottieNames: ["tab_home_animate", "tab_search_animate", "tab_message_animate", "tab_me_animate"],
            usesURL: false,
            detail: "彩色矢量 Lottie TabBar\n使用 TFYSwiftTabBarLottieFilePath，点击每个 Tab 重新播放"
        )
    }

    static func lottieResources() -> UIViewController {
        LottieResourcesDemoViewController()
    }

    private static func lottieTabBar(
        titles: [String],
        images: [String],
        selectedImages: [String],
        lottieNames: [String],
        usesURL: Bool,
        detail: String
    ) -> UIViewController {
        let attributes = titles.indices.map { index in
            DemoSupport.attrs(
                title: titles[index],
                image: images[index],
                selectedImage: selectedImages[index],
                lottieName: lottieNames[index],
                lottieUsesURL: usesURL,
                lottieSize: CGSize(width: 30, height: 30)
            )
        }
        return DemoSupport.makeTab(titles: titles, attributes: attributes, detail: detail)
    }

    // MARK: - FlatDesign

    static func flatDesignStandalone() -> UIViewController {
        FlatDesignDemoViewController()
    }

    static func flatDesignStyleController() -> UIViewController {
        DemoSupport.makeTab(
            style: .flatDesign,
            detail: "styleType = .flatDesign\n核心路径对 Flat 多为早期返回；完整交互见「Flat 独立组件」"
        )
    }

    // MARK: - Navigation / Extensions

    static func pushHideTabBar() -> UIViewController {
        let tab = DemoSupport.makeTab(
            style: .default,
            detail: "TFYSwiftBaseNavigationController\nPush 二级页自动 hidesBottomBarWhenPushed"
        )
        guard let nav = tab.viewControllers?[0] as? UINavigationController,
              let root = nav.topViewController as? DemoInfoViewController else { return tab }

        let page = DemoInfoViewController(
            titleText: "导航",
            detail: "Push 后隐藏 TabBar；返回恢复",
            actions: [
                ("Push 二级页", { [weak nav] in
                    let next = DemoInfoViewController(
                        titleText: "二级页",
                        detail: "tfy_hidesBottomBarWhenPushed = true（BaseNavigationController 默认）"
                    )
                    nav?.pushViewController(next, animated: true)
                }),
                ("动画隐藏 TabBar", { [weak root] in
                    root?.tfy_hideTabBarAnimated(true)
                }),
                ("动画显示 TabBar", { [weak root] in
                    root?.tfy_showTabBarAnimated(true)
                }),
                ("切换到「我的」", { [weak root] in
                    _ = root?.tfy_popSelectTabBarChildViewController(at: 3)
                })
            ]
        )
        page.navigationItem.leftBarButtonItem = root.navigationItem.leftBarButtonItem
        nav.setViewControllers([page], animated: false)
        return tab
    }

    // MARK: - Advanced

    static func advancedCombo() -> UIViewController {
        DemoChildPlusButton.registerPlusButton()
        return DemoSupport.makeTab(
            style: .default,
            context: DemoChildPlusButton.contextKey,
            detail: "组合：Plus Child + 徽章 + tint + 自定义高度",
            configureTab: { tab in
                tab.tabBarHeight = 52
                tab.setTintColor(.systemIndigo)
                tab.setViewDidLayoutSubViewsBlockInvokeOnce(true) { controller in
                    controller.viewControllers?[0]
                        .tfy_getViewControllerInsteadOfNavigationController()
                        .tfy_showBadgeValue("9", animationType: .bounce)
                    controller.viewControllers?[1]
                        .tfy_getViewControllerInsteadOfNavigationController()
                        .tfy_showBadge()
                }
            }
        )
    }
}

// MARK: - FlatDesign standalone host

@available(iOS 15.0, *)
final class FlatDesignDemoViewController: TFYSwiftBaseViewController, TFYSwiftFlatDesignTabBarDelegate {

    private let flatBar = TFYSwiftFlatDesignTabBar()
    private let contentLabel = UILabel()
    private var items: [TFYSwiftFlatDesignTabBarItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FlatDesign"
        view.backgroundColor = .systemBackground

        contentLabel.font = .preferredFont(forTextStyle: .title3)
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.text = "TFYSwiftFlatDesignTabBar\n独立组件展示"
        view.addSubview(contentLabel)
        view.addSubview(flatBar)

        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerY.equalToSuperview().offset(-40)
        }
        flatBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(83)
        }

        flatBar.delegate = self
        flatBar.tintColor = UIColor.systemBlue
        flatBar.barTintColor = .secondarySystemBackground
        flatBar.useLayoutSafeAreaInsets = true

        let titles = ["首页", "发现", "消息", "我的"]
        let images = ["home", "find", "message", "me"]
        let selected = ["home_1", "find_1", "message_1", "me_1"]
        let lottieNames = [
            "green_lottie_tab_home",
            "green_lottie_tab_discover",
            "green_lottie_tab_news",
            "green_lottie_tab_mine"
        ]
        items = titles.enumerated().map { index, title in
            flatBar.addItem(
                withTitle: title,
                tabBarItemImage: images[index],
                tabBarItemSelectedImage: selected[index],
                index: index,
                titlePositionAdjustment: .zero,
                imageInsets: .zero,
                lottieFilePath: Bundle.main.path(forResource: lottieNames[index], ofType: "json"),
                lottieSizeValue: NSValue(cgSize: CGSize(width: 26, height: 26))
            )
        }
        flatBar.items = items
        flatBar.selectedIndex = 0
        items[1].badgeValue = "3"
        items[2].badgeValue = ""
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "更新 Item", primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                self.items[1].badgeValue = self.items[1].badgeValue == "8" ? "3" : "8"
                self.items[1].title = self.items[1].title == "发现" ? "动态" : "发现"
            }),
            UIBarButtonItem(title: "显隐", primaryAction: UIAction { [weak self] _ in
                self?.flatBar.isHidden.toggle()
            })
        ]
    }

    func tabBar(_ tabBar: TFYSwiftFlatDesignTabBar, didSelect item: TFYSwiftFlatDesignTabBarItem) {
        contentLabel.text = "选中：\(item.title ?? "")\nindex = \(item.index)\nbadge = \(item.badgeValue ?? "nil")"
    }
}

// MARK: - Lottie resources lab

@available(iOS 15.0, *)
final class LottieResourcesDemoViewController: TFYSwiftBaseViewController {

    private let animationView = TFYSwiftCompatibleLOTAnimationView(frame: .zero)
    private let resourceButton = UIButton(type: .system)
    private let progressSlider = UISlider()
    private let loopSwitch = UISwitch()
    private let statusLabel = UILabel()
    private var selectedResource = DemoSupport.lottieResourceNames[0]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lottie 资源实验室"
        view.backgroundColor = .systemBackground
        configureLayout()
        configureControls()
        selectResource(selectedResource)
    }

    private func configureLayout() {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        scrollView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }

        let intro = UILabel()
        intro.text = "已收录 LottieResources 全部 11 个 JSON（灰色动画会同时加载目录中的 PNG 帧资源）"
        intro.font = .preferredFont(forTextStyle: .body)
        intro.textColor = .secondaryLabel
        intro.numberOfLines = 0

        resourceButton.configuration = .borderedProminent()
        resourceButton.accessibilityIdentifier = "lottie.resource"
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .secondarySystemBackground
        animationView.layer.cornerRadius = 16
        animationView.clipsToBounds = true
        animationView.snp.makeConstraints { make in
            make.height.equalTo(220)
        }

        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.accessibilityIdentifier = "lottie.progress"

        statusLabel.font = .preferredFont(forTextStyle: .footnote)
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 0

        [intro, resourceButton, animationView, progressSlider, makePlaybackRow(), makeOptionsRow(), statusLabel]
            .forEach(stack.addArrangedSubview)
    }

    private func configureControls() {
        resourceButton.menu = UIMenu(
            title: "选择动画资源",
            children: DemoSupport.lottieResourceNames.map { [weak self] name in
                UIAction(title: name) { _ in self?.selectResource(name) }
            }
        )
        resourceButton.showsMenuAsPrimaryAction = true
        progressSlider.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            animationView.currentProgress = CGFloat(progressSlider.value)
            updateStatus()
        }, for: .valueChanged)
        loopSwitch.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            animationView.loopAnimationCount = loopSwitch.isOn ? -1 : 0
            updateStatus()
        }, for: .valueChanged)
    }

    private func makePlaybackRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 8
        let controls: [(String, String, () -> Void)] = [
            ("播放", "lottie.play", { [weak self] in self?.animationView.play() }),
            ("暂停", "lottie.pause", { [weak self] in self?.animationView.pause() }),
            ("停止", "lottie.stop", { [weak self] in self?.animationView.stop() })
        ]
        controls.forEach { title, identifier, action in
            let button = UIButton(type: .system)
            button.configuration = .bordered()
            button.configuration?.title = title
            button.accessibilityIdentifier = identifier
            button.addAction(UIAction { _ in action() }, for: .touchUpInside)
            row.addArrangedSubview(button)
        }
        return row
    }

    private func makeOptionsRow() -> UIStackView {
        let speed = UISegmentedControl(items: ["0.5×", "1×", "2×"])
        speed.selectedSegmentIndex = 1
        speed.accessibilityIdentifier = "lottie.speed"
        speed.addAction(UIAction { [weak self, weak speed] _ in
            guard let self, let speed else { return }
            animationView.animationSpeed = [0.5, 1, 2][speed.selectedSegmentIndex]
            updateStatus()
        }, for: .valueChanged)

        let loopLabel = UILabel()
        loopLabel.text = "循环"
        let loopRow = UIStackView(arrangedSubviews: [loopLabel, loopSwitch])
        loopRow.axis = .horizontal
        loopRow.spacing = 8

        let row = UIStackView(arrangedSubviews: [speed, loopRow])
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .fillProportionally
        row.spacing = 16
        return row
    }

    private func selectResource(_ name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            statusLabel.text = "资源缺失：\(name).json"
            return
        }
        selectedResource = name
        resourceButton.configuration?.title = name
        animationView.compatibleAnimation = TFYSwiftCompatibleLOTAnimation(filepath: path)
        animationView.currentProgress = 0
        progressSlider.value = 0
        animationView.play()
        updateStatus()
    }

    private func updateStatus() {
        statusLabel.text = "\(selectedResource).json\n时长 \(String(format: "%.2f", animationView.duration))s · 进度 \(Int(animationView.currentProgress * 100))% · 速度 \(animationView.animationSpeed)× · \(loopSwitch.isOn ? "循环" : "单次")"
    }
}

@available(iOS 15.0, *)
final class DelegateConfigurationDemoController: TFYSwiftTabBarController, TFYSwiftTabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        viewControllers?.forEach { child in
            let host = (child as? UINavigationController)?.topViewController ?? child
            host.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "下一项", primaryAction: UIAction { [weak self] _ in
                    guard let self, let count = viewControllers?.count, count > 0 else { return }
                    selectedIndex = (selectedIndex + 1) % count
                }),
                UIBarButtonItem(title: "重载", primaryAction: UIAction { [weak self] _ in
                    guard let self, let current = viewControllers else { return }
                    setViewControllers(current)
                    reloadTabBarItems(withAttributes: tabBarItemsAttributes)
                })
            ]
        }
    }

    func tabBarController(_ tabBarController: TFYSwiftTabBarController, didSelectControl control: UIControl) {
        let host = (selectedViewController as? UINavigationController)?.topViewController ?? selectedViewController
        host?.navigationItem.prompt = "delegate didSelectControl · index \(selectedIndex)"
    }

    override func tabBarController(
        _ tabBarController: TFYSwiftTabBarController,
        shouldShowPlatterLiquidLensViewForControl control: UIControl
    ) -> Bool {
        true
    }
}
