import TFYSwiftTabBarController
import UIKit

private var demoSavedFlatItemTitle: String?

/// Shared grouped catalog used by demo tabs.
class DemoActionTableController: TFYSwiftBaseTableViewController {

    struct Row {
        let title: String
        let subtitle: String
        let action: (UIViewController) -> Void
    }

    struct Section {
        let title: String
        let rows: [Row]
    }

    var sections: [Section] = []

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = sections[indexPath.section].rows[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = row.title
        config.secondaryText = row.subtitle
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].rows[indexPath.row].action(self)
    }
}

/// Full API catalog — OC home / FlatDesign table / badge / nav / plus / nested tab.
final class HomeViewController: DemoActionTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = makeSections()
        tableView.tableHeaderView = makeHeader()
        attachScrollEdgeIfNeeded()

        let flat = UIBarButtonItem(title: "扁平", style: .plain, target: self, action: #selector(tapFlat))
        let glass = UIBarButtonItem(title: "液态", style: .plain, target: self, action: #selector(tapGlass))
        navigationItem.leftBarButtonItem = flat
        navigationItem.rightBarButtonItem = glass
        flat.tfy_badgeBackgroundColor = .systemRed
        glass.tfy_badgeBackgroundColor = .systemRed
        glass.tfy_badgeCenterOffset = CGPoint(x: -5, y: 3)
        glass.tfy_showBadgeValue("", animationType: .shake)
        flat.tfy_showBadgeValue("", animationType: .scaleOnce)
    }

    private func makeHeader() -> UIView {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.text = "对照 CYLTabBarController 全量能力。首页是总目录；同城 / 消息 / 我的 / 发布各自还有原版动作。点中间 Plus「发布」。摇一摇当前 Tab 出角标。"
        let width = UIScreen.main.bounds.width - 48
        label.preferredMaxLayoutWidth = width
        let height = label.sizeThatFits(CGSize(width: width, height: 200)).height
        label.frame = CGRect(x: 16, y: 12, width: width, height: ceil(height))
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ceil(height) + 24))
        label.autoresizingMask = [.flexibleWidth]
        header.addSubview(label)
        return header
    }

    private func attachScrollEdgeIfNeeded() {
        if #available(iOS 26.0, *) {
            let interaction = UIScrollEdgeElementContainerInteraction()
            interaction.scrollView = tableView
            interaction.edge = .bottom
            demoTab?.tabBar.addInteraction(interaction)
        }
    }

    private func makeSections() -> [Section] {
        [
            Section(title: "样式", rows: [
                Row(title: "切换 Default", subtitle: "系统 / CYL 默认路径", action: { $0.switchStyle(.default) }),
                Row(title: "切换 LiquidGlass", subtitle: "iOS 26 液态玻璃", action: { $0.switchStyle(.liquidGlass) }),
                Row(title: "切换 FlatDesign", subtitle: "自定义扁平栏 + 转场视差", action: { $0.switchStyle(.flatDesign) }),
                Row(title: "动态重建 TabBar", subtitle: "createNewTabBarWithContext，带当前页 class", action: {
                    $0.demoRoot?.installTabBar(style: $0.demoRoot?.currentStyle ?? .default, context: String(describing: type(of: $0)))
                }),
            ]),
            Section(title: "Tab 角标 · 样式", rows: [
                Row(title: "tfy_showBadge 红点", subtitle: "无参数默认红点", action: { $0.tfy_showBadge() }),
                Row(title: "数字 99 · bounce", subtitle: "tfy_showBadgeValue(\"99\")", action: { $0.tfy_showBadgeValue("99", animationType: .bounce) }),
                Row(title: "红点 · shake", subtitle: "空字符串走红点", action: { $0.tfy_showBadgeValue("", animationType: .shake) }),
                Row(title: "NEW · scale", subtitle: "\"new\" 走胶囊文字", action: { $0.tfy_showBadgeValue("new", animationType: .scale) }),
                Row(title: "中文「新」", subtitle: "任意文字角标", action: { $0.tfy_showBadgeValue("新", animationType: .none) }),
                Row(title: "超过上限 120", subtitle: "tfy_badgeMaximumBadgeNumber 默认 99+", action: {
                    $0.tfy_badgeMaximumBadgeNumber = 99
                    $0.tfy_showBadgeValue("120", animationType: .none)
                }),
                Row(title: "清除角标", subtitle: "tfy_clearBadge（可 resume）", action: { $0.tfy_clearBadge() }),
                Row(title: "恢复角标", subtitle: "tfy_resumeBadge", action: { $0.tfy_resumeBadge() }),
                Row(title: "查询显示 / 暂停状态", subtitle: "tfy_isShowBadge · tfy_isPauseBadge", action: {
                    $0.presentAlert("show \($0.tfy_isShowBadge())\npause \($0.tfy_isPauseBadge())")
                }),
            ]),
            Section(title: "Tab 角标 · 动画", rows: [
                Row(title: "none", subtitle: "无动画", action: { $0.tfy_showBadgeValue("8", animationType: .none) }),
                Row(title: "breathe", subtitle: "呼吸", action: { $0.tfy_showBadgeValue("8", animationType: .breathe) }),
                Row(title: "shake", subtitle: "抖动", action: { $0.tfy_showBadgeValue("8", animationType: .shake) }),
                Row(title: "scale", subtitle: "循环缩放", action: { $0.tfy_showBadgeValue("8", animationType: .scale) }),
                Row(title: "bounce", subtitle: "弹跳", action: { $0.tfy_showBadgeValue("8", animationType: .bounce) }),
                Row(title: "leftRightOnce", subtitle: "左右一次", action: { $0.tfy_showBadgeValue("8", animationType: .leftRightOnce) }),
                Row(title: "rightLeftOnce", subtitle: "右左一次", action: { $0.tfy_showBadgeValue("8", animationType: .rightLeftOnce) }),
                Row(title: "fadeInOnce", subtitle: "淡入一次", action: { $0.tfy_showBadgeValue("8", animationType: .fadeInOnce) }),
                Row(title: "rollingOnce", subtitle: "翻滚一次", action: { $0.tfy_showBadgeValue("8", animationType: .rollingOnce) }),
                Row(title: "scaleOnce", subtitle: "缩放一次", action: { $0.tfy_showBadgeValue("8", animationType: .scaleOnce) }),
            ]),
            Section(title: "Tab 角标 · 外观", rows: [
                Row(title: "红点半径 8", subtitle: "tfy_badgeRadius", action: {
                    $0.tfy_badgeRadius = 8
                    $0.tfy_showBadgeValue("", animationType: .none)
                }),
                Row(title: "偏移 (6, -4)", subtitle: "tfy_badgeCenterOffset", action: {
                    $0.tfy_badgeCenterOffset = CGPoint(x: 6, y: -4)
                    $0.tfy_showBadgeValue("3", animationType: .none)
                }),
                Row(title: "蓝底白字", subtitle: "background / text color", action: {
                    $0.tfy_badgeBackgroundColor = .systemBlue
                    $0.tfy_badgeTextColor = .white
                    $0.tfy_showBadgeValue("6", animationType: .none)
                }),
                Row(title: "更大字体", subtitle: "tfy_badgeFont 18", action: {
                    $0.tfy_badgeFont = .boldSystemFont(ofSize: 18)
                    $0.tfy_showBadgeValue("9", animationType: .none)
                }),
                Row(title: "外边距 16", subtitle: "tfy_badgeMargin", action: {
                    $0.tfy_badgeMargin = 16
                    $0.tfy_showBadgeValue("2", animationType: .none)
                }),
                Row(title: "圆角 4", subtitle: "tfy_badgeCornerRadius", action: {
                    $0.tfy_badgeCornerRadius = 4
                    $0.tfy_showBadgeValue("角", animationType: .none)
                }),
                Row(title: "恢复默认外观", subtitle: "红底、零偏移、默认半径", action: {
                    $0.tfy_badgeBackgroundColor = .systemRed
                    $0.tfy_badgeTextColor = .white
                    $0.tfy_badgeCenterOffset = .zero
                    $0.tfy_badgeRadius = 0
                    $0.tfy_badgeMargin = 8
                    $0.tfy_badgeCornerRadius = 0
                    $0.tfy_badgeFont = nil
                    $0.tfy_showBadgeValue("1", animationType: .none)
                }),
            ]),
            Section(title: "导航栏按钮角标", rows: [
                Row(title: "右侧按钮红点 shake", subtitle: "UIBarButtonItem.tfy_showBadgeValue", action: {
                    $0.navigationItem.rightBarButtonItem?.tfy_showBadgeValue("", animationType: .shake)
                }),
                Row(title: "左侧按钮数字", subtitle: "扁平按钮显示 5", action: {
                    $0.navigationItem.leftBarButtonItem?.tfy_showBadgeValue("5", animationType: .scaleOnce)
                }),
                Row(title: "tfy_showBadge 右侧", subtitle: "无参数红点", action: {
                    $0.navigationItem.rightBarButtonItem?.tfy_showBadge()
                }),
                Row(title: "清除导航按钮角标", subtitle: "左右都清", action: {
                    $0.navigationItem.leftBarButtonItem?.tfy_clearBadge()
                    $0.navigationItem.rightBarButtonItem?.tfy_clearBadge()
                }),
            ]),
            Section(title: "TabBar 显隐 / 外观", rows: [
                Row(title: "动画隐藏 TabBar", subtitle: "tfy_hideTabBarAnimated", action: { $0.tfy_hideTabBarAnimated(true) }),
                Row(title: "动画显示 TabBar", subtitle: "tfy_showTabBarAnimated", action: { $0.tfy_showTabBarAnimated(true) }),
                Row(title: "setTabBarHidden 切换", subtitle: "含扁平自定义栏", action: {
                    guard let tab = $0.demoTab else { return }
                    let hidden = tab.tabBarStyleType == .flatDesign ? tab.tfy_isTabBarHidden() : tab.tabBar.isHidden
                    tab.setTabBarHidden(!hidden, animated: true)
                }),
                Row(title: "隐藏顶部分割线", subtitle: "hideTabBarShadowImageView", action: {
                    $0.demoTab?.hideTabBarShadowImageView()
                }),
                Row(title: "隐藏角标背景分割", subtitle: "hideTabBadgeBackgroundSeparator", action: {
                    $0.demoTab?.hideTabBadgeBackgroundSeparator()
                }),
                Row(title: "Tint 随机色", subtitle: "setTintColor（扁平样式会忽略）", action: {
                    $0.demoTab?.setTintColor(DemoCatalog.randomColor())
                }),
                Row(title: "reloadTabBarItems 改标题", subtitle: "非扁平：给标题加 ★", action: {
                    guard let tab = $0.demoTab else { return }
                    var attrs = tab.tabBarItemsAttributes
                    if attrs.isEmpty { attrs = MainTabBarController.makeAttributes() }
                    for index in attrs.indices {
                        if let title = attrs[index][TFYSwiftTabBarItemTitle] as? String, !title.contains("★") {
                            attrs[index][TFYSwiftTabBarItemTitle] = title + "★"
                        }
                    }
                    tab.reloadTabBarItems(withAttributes: attrs)
                }),
            ]),
            Section(title: "选中与跳转", rows: [
                Row(title: "selectedIndex = 1 同城", subtitle: "含 Plus 占位后的真实 index", action: { $0.demoTab?.selectedIndex = 1 }),
                Row(title: "选中「同城」", subtitle: "popSelect CityViewController", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(for: CityViewController.self)
                }),
                Row(title: "选中「消息」", subtitle: "popSelect MessageViewController", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(for: MessageViewController.self)
                }),
                Row(title: "选中「我的」", subtitle: "Plus 占位后我的是 index 4", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(for: MineViewController.self)
                }),
                Row(title: "选中 Plus「发布」", subtitle: "切到 Plus 子控制器", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(for: PublishViewController.self)
                }),
                Row(title: "按 index 0 回首页", subtitle: "tfy_popSelectTabBarChildViewController(at:)", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(at: 0)
                }),
                Row(title: "按 index 带动画", subtitle: "popSelect(at:animated:)", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(at: 1, animated: true)
                }),
            ]),
            Section(title: "导航栈", rows: [
                Row(title: "Push 隐藏 TabBar", subtitle: "tfy_hidesBottomBarWhenPushed", action: { $0.pushDetail(hidesTabBar: true, hidesNav: false, disablePop: false) }),
                Row(title: "Push 隐藏导航栏", subtitle: "tfy_navigationBarHidden", action: { $0.pushDetail(hidesTabBar: false, hidesNav: true, disablePop: false) }),
                Row(title: "Push 禁用侧滑返回", subtitle: "tfy_disablePopGestureRecognizer", action: { $0.pushDetail(hidesTabBar: true, hidesNav: false, disablePop: true) }),
                Row(title: "Push 详情（可点跳「我的」）", subtitle: "对照 CYLDetailsViewController", action: { $0.pushDetail(hidesTabBar: true, hidesNav: false, disablePop: false) }),
                Row(title: "tfy_pushViewController 详情", subtitle: "同类型已在栈顶则不再 push", action: {
                    let detail = DetailViewController()
                    detail.tfy_hidesBottomBarWhenPushed = true
                    $0.tfy_pushViewController(detail, animated: true)
                }),
                Row(title: "tfy_pushOrPopToViewController", subtitle: "回调里决定 pop / 切 Tab / push", action: {
                    let detail = DetailViewController()
                    detail.tfy_hidesBottomBarWhenPushed = true
                    $0.tfy_pushOrPopToViewController(detail, animated: true) { stack, handler in
                        handler(false, stack.last, false, 0)
                    }
                }),
                Row(title: "隐藏 / 显示导航分隔线", subtitle: "tfy_hideNavigationBarSeparator", action: {
                    $0.tfy_hideNavigationBarSeparator.toggle()
                }),
            ]),
            Section(title: "扁平 TabBar（切到扁平后点）", rows: [
                Row(title: "显示 / 隐藏扁平栏", subtitle: "setTabBarHidden", action: {
                    guard let tab = $0.demoTab else { return }
                    tab.setTabBarHidden(!tab.tfy_isTabBarHidden(), animated: true)
                }),
                Row(title: "图标不居中（系统效果）", subtitle: "layoutCentered = false 并清 title", action: {
                    $0.applyFlatCentered(false)
                }),
                Row(title: "图标居中显示", subtitle: "layoutCentered = true 并清 title", action: {
                    $0.applyFlatCentered(true)
                }),
                Row(title: "切换 Item 背景色", subtitle: "backgroundColor / selectedBackgroundColor", action: {
                    guard let tab = $0.demoTab else { return }
                    for vc in tab.viewControllers ?? [] {
                        let item = vc.tfy_tabBarItem
                        if item.backgroundColor == nil {
                            item.backgroundColor = UIColor(white: 0.18, alpha: 1)
                            item.selectedBackgroundColor = .black
                        } else {
                            item.backgroundColor = nil
                            item.selectedBackgroundColor = nil
                        }
                    }
                }),
                Row(title: "增高 10pt（≥100 回 49）", subtitle: "tabBarHeight", action: {
                    guard let tab = $0.demoTab else { return }
                    var height = tab.tabBarHeight + 10
                    if height >= 100 { height = 49 }
                    tab.tabBarHeight = height
                }),
                Row(title: "changeItem 换当前标题", subtitle: "changeItem(_:toItem:)", action: {
                    guard let tab = $0.demoTab else { return }
                    let old = $0.navigationController?.tfy_tabBarItem ?? $0.tfy_tabBarItem
                    let title = (old.title == "换") ? "首页" : "换"
                    let neu = TFYSwiftFlatDesignTabBarItem(title: title, image: old.image, selectedImage: old.selectedImage)
                    tab.changeItem(old, toItem: neu)
                }),
                Row(title: "和系统 UITabBar 比较", subtitle: "对照 CYLFlatDesignTabBarDemoViewController", action: {
                    let compare = FlatBarCompareViewController()
                    compare.tfy_hidesBottomBarWhenPushed = true
                    $0.navigationController?.pushViewController(compare, animated: true)
                }),
                Row(title: "Push 嵌套 TFY TabBar", subtitle: "对照 FlatDesign row 6", action: {
                    DemoCatalog.pushNestedTab(from: $0)
                }),
            ]),
            Section(title: "Plus / 查询", rows: [
                Row(title: "当前栏尺寸 / 数量 / Plus", subtitle: "visiableTabBarSize · allItemsInTabBarCount · hasPlusButton", action: {
                    guard let tab = $0.demoTab else { return }
                    let size = tab.visiableTabBarSize()
                    $0.presentAlert("visible \(Int(size.width))×\(Int(size.height))\nbounds \(Int(tab.tabBar.bounds.width))×\(Int(tab.tabBar.bounds.height))\nitems \(tab.allItemsInTabBarCount())\nhasPlus \(tab.hasPlusButton())\nstyle \(tab.tabBarStyleType.rawValue)")
                }),
                Row(title: "当前可见 Tab 按钮", subtitle: "tfy_visiableTabButton", action: {
                    let button = $0.tfy_visiableTabButton
                    $0.presentAlert(button.map { String(describing: type(of: $0)) } ?? "nil")
                }),
                Row(title: "布局回调 invokeOnce", subtitle: "setViewDidLayoutSubViewsBlockInvokeOnce", action: {
                    $0.demoTab?.setViewDidLayoutSubViewsBlockInvokeOnce(true) { tab in
                        tab.hideTabBarShadowImageView()
                    }
                }),
                Row(title: "Push 系统 UITabBarController", subtitle: "对照 FlatDesign「和系统比较」旁路", action: {
                    let system = SystemCompareTabBarController()
                    system.hidesBottomBarWhenPushed = true
                    system.tfy_hidesBottomBarWhenPushed = true
                    $0.navigationController?.pushViewController(system, animated: true)
                }),
            ]),
        ]
    }

    @objc private func tapFlat() { switchStyle(.flatDesign) }
    @objc private func tapGlass() { switchStyle(.liquidGlass) }
}

private extension UIViewController {
    func switchStyle(_ style: TFYSwiftTabBarStyleType) {
        demoRoot?.installTabBar(style: style, context: String(describing: type(of: self)))
    }

    func pushDetail(hidesTabBar: Bool, hidesNav: Bool, disablePop: Bool) {
        let detail = DetailViewController()
        detail.tfy_hidesBottomBarWhenPushed = hidesTabBar
        detail.tfy_navigationBarHidden = hidesNav
        detail.tfy_disablePopGestureRecognizer = disablePop
        navigationController?.pushViewController(detail, animated: true)
    }

    func applyFlatCentered(_ centered: Bool) {
        let item = navigationController?.tfy_tabBarItem ?? tfy_tabBarItem
        item.layoutCentered = centered
        if item.title != nil {
            demoSavedFlatItemTitle = item.title
            item.title = nil
        } else {
            item.title = demoSavedFlatItemTitle ?? "首页"
        }
    }
}

extension UIViewController {
    var demoTab: TFYSwiftTabBarController? {
        tfy_tabBarController ?? (tabBarController as? TFYSwiftTabBarController)
    }

    func presentAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default))
        present(alert, animated: true)
    }
}

enum DemoCatalog {
    static func randomColor() -> UIColor {
        UIColor(
            hue: CGFloat.random(in: 0...1),
            saturation: 0.55 + CGFloat.random(in: 0...0.4),
            brightness: 0.55 + CGFloat.random(in: 0...0.4),
            alpha: 1
        )
    }

    static func solidImage(_ color: UIColor, size: CGSize = CGSize(width: 4, height: 4)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }

    static func pushNestedTab(from host: UIViewController) {
        PlusButtonSubclass.registerPlusButton()
        let tab = MainTabBarController(style: host.demoRoot?.currentStyle ?? .default, context: String(describing: type(of: host)))
        tab.hidesBottomBarWhenPushed = true
        tab.tfy_hidesBottomBarWhenPushed = true
        host.navigationController?.pushViewController(tab, animated: true)
    }
}

/// OC `CYLFlatDesignTabBarDemoViewController`: custom bar vs system UITabBar.
final class FlatBarCompareViewController: TFYSwiftBaseViewController, UITableViewDelegate, UITableViewDataSource, TFYSwiftFlatDesignTabBarDelegate {

    private let flatBar = TFYSwiftFlatDesignTabBar()
    private let systemBar = UITabBar()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let actions = ["设置 barTintColor", "设置 backgroundImage", "设置 shadowImage", "设置 tintColor", "设置 items", "设置 清空"]
    private var compareItems: [TFYSwiftFlatDesignTabBarItem] = []
    private var systemItems: [UITabBarItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扁平 vs 系统 TabBar"
        view.backgroundColor = .systemBackground
        tfy_hidesBottomBarWhenPushed = true

        let titles = ["主页", "同城", "消息"]
        let symbols = ["house.fill", "leaf.fill", "message.fill"]
        compareItems = zip(titles, symbols).map { title, symbol in
            TFYSwiftFlatDesignTabBarItem(
                title: title,
                image: UIImage(systemName: symbol),
                selectedImage: UIImage(systemName: symbol)
            )
        }
        systemItems = zip(titles, symbols).map { title, symbol in
            UITabBarItem(title: title, image: UIImage(systemName: symbol), selectedImage: UIImage(systemName: symbol))
        }

        flatBar.tfy_context = String(describing: type(of: self))
        flatBar.delegate = self
        flatBar.items = compareItems
        systemBar.items = systemItems
        view.addSubview(flatBar)
        view.addSubview(systemBar)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.insertSubview(tableView, at: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let navMaxY = navigationController?.navigationBar.frame.maxY ?? view.safeAreaInsets.top
        flatBar.frame = CGRect(x: 0, y: navMaxY + 20, width: view.bounds.width, height: 49)
        var systemHeight: CGFloat = 49
        if #available(iOS 26.0, *) { systemHeight = 91 }
        systemBar.frame = CGRect(x: 0, y: flatBar.frame.maxY + 10, width: view.bounds.width, height: systemHeight)
        tableView.frame = CGRect(
            x: 0,
            y: systemBar.frame.maxY,
            width: view.bounds.width,
            height: view.bounds.height - systemBar.frame.maxY
        )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { actions.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = actions[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let color = DemoCatalog.randomColor().withAlphaComponent(0.5)
            flatBar.barTintColor = color
            systemBar.barTintColor = color
        case 1:
            let image = DemoCatalog.solidImage(DemoCatalog.randomColor())
            flatBar.backgroundImage = image
            systemBar.backgroundImage = image
        case 2:
            let image = DemoCatalog.solidImage(DemoCatalog.randomColor(), size: CGSize(width: 4, height: 1))
            flatBar.shadowImage = image
            systemBar.shadowImage = image
        case 3:
            let color = DemoCatalog.randomColor()
            flatBar.tintColor = color
            systemBar.tintColor = color
        case 4:
            if compareItems.count > 1 {
                compareItems.removeLast()
                systemItems.removeLast()
                flatBar.items = compareItems
                systemBar.items = systemItems
            }
        default:
            flatBar.backgroundImage = nil
            flatBar.shadowImage = nil
            flatBar.tintColor = nil
            flatBar.barTintColor = nil
            flatBar.items = nil
            systemBar.backgroundImage = nil
            systemBar.shadowImage = nil
            systemBar.tintColor = nil
            systemBar.barTintColor = nil
            systemBar.items = nil
        }
    }

    func tabBar(_ tabBar: TFYSwiftFlatDesignTabBar, didSelect item: TFYSwiftFlatDesignTabBarItem) {
        guard let tab = demoTab else { return }
        tab.setTabBarHidden(!tab.tfy_isTabBarHidden(), animated: true)
    }
}

/// Minimal system `UITabBarController` for side-by-side comparison.
final class SystemCompareTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let first = UIViewController()
        first.view.backgroundColor = .systemBackground
        first.tabBarItem = UITabBarItem(title: "系统一", image: UIImage(systemName: "circle"), selectedImage: UIImage(systemName: "circle.fill"))
        let second = UIViewController()
        second.view.backgroundColor = .secondarySystemBackground
        second.tabBarItem = UITabBarItem(title: "系统二", image: UIImage(systemName: "square"), selectedImage: UIImage(systemName: "square.fill"))
        viewControllers = [
            TFYSwiftBaseNavigationController(rootViewController: first),
            TFYSwiftBaseNavigationController(rootViewController: second),
        ]
        first.title = "系统 UITabBar"
        second.title = "系统第二页"
    }
}
