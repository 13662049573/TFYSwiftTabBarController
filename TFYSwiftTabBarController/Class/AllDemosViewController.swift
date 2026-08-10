//
//  AllDemosViewController.swift
//  TFYSwiftTabBarController
//
//  示范入口：按能力分组展示 TFYSwiftTabbarKit 全量 API
//

import UIKit

@available(iOS 15.0, *)
final class AllDemosViewController: UITableViewController {

    init() {
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private enum Section: Int, CaseIterable {
        case basics
        case plus
        case badge
        case lottie
        case flat
        case navigation
        case advanced

        var title: String {
            switch self {
            case .basics: return "基础风格"
            case .plus: return "中间 Plus 按钮"
            case .badge: return "徽章"
            case .lottie: return "Lottie"
            case .flat: return "FlatDesign"
            case .navigation: return "导航与扩展"
            case .advanced: return "组合"
            }
        }
    }

    private struct Item {
        let title: String
        let subtitle: String
        let factory: () -> UIViewController
    }

    private lazy var data: [[Item]] = [
        [
            Item(title: "基础四 Tab", subtitle: ".default + 资源图", factory: DemoFactories.basicDefault),
            Item(title: "System 风格", subtitle: "styleType = .system", factory: DemoFactories.systemStyle),
            Item(title: "Liquid Glass", subtitle: "styleType = .liquidGlass", factory: DemoFactories.liquidGlass),
            Item(title: "代理与动态配置", subtitle: "delegate / selectedIndex / setViewControllers", factory: DemoFactories.delegateAndConfiguration),
            Item(title: "Item 布局偏移", subtitle: "图片内边距 / 标题偏移 / 图片偏移", factory: DemoFactories.itemLayoutAdjustments),
            Item(title: "外观定制", subtitle: "高度 / tint / 阴影 / separator", factory: DemoFactories.customAppearance)
        ],
        [
            Item(title: "Plus 仅动作", subtitle: "弹窗，无 Child VC", factory: DemoFactories.plusActionOnly),
            Item(title: "Plus + Child VC", subtitle: "中间位真实子控制器", factory: DemoFactories.plusWithChild)
        ],
        [
            Item(title: "徽章全能力", subtitle: "红点 / 数字 / NEW / 动画 / BarItem", factory: DemoFactories.badges)
        ],
        [
            Item(title: "Lottie Tab · 灰色图片型", subtitle: "3 个 JSON + 7 个 PNG 作为真实 TabBar", factory: DemoFactories.grayLottieTabs),
            Item(title: "Lottie Tab · 绿色", subtitle: "4 个独立动画，使用 URL 配置", factory: DemoFactories.lottieTabs),
            Item(title: "Lottie Tab · 彩色", subtitle: "4 个独立矢量动画，使用文件路径配置", factory: DemoFactories.colorLottieTabs),
            Item(title: "Lottie 资源实验室", subtitle: "浏览全部 11 个 JSON，控制播放 / 进度 / 速度 / 循环", factory: DemoFactories.lottieResources)
        ],
        [
            Item(title: "Flat 独立组件", subtitle: "TFYSwiftFlatDesignTabBar", factory: DemoFactories.flatDesignStandalone),
            Item(title: "Flat styleType", subtitle: "控制器 .flatDesign", factory: DemoFactories.flatDesignStyleController)
        ],
        [
            Item(title: "Push 隐藏 TabBar", subtitle: "BaseNav + 动画显隐 + 切 Tab", factory: DemoFactories.pushHideTabBar)
        ],
        [
            Item(title: "高级组合", subtitle: "Plus + Badge + 外观", factory: DemoFactories.advancedCombo)
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TFYSwiftTabbarKit"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.sectionHeaderTopPadding = 8
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = data[indexPath.section][indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.secondaryText = item.subtitle
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        TFYSwiftPlusButton.removePlusButton()
        let item = data[indexPath.section][indexPath.row]
        let demo = item.factory()
        DemoSupport.injectCloseButton(into: demo)
        let presenter: UIViewController
        if demo is UINavigationController || demo is UITabBarController {
            presenter = demo
        } else {
            let nav = UINavigationController(rootViewController: demo)
            DemoSupport.injectCloseButton(into: demo)
            presenter = nav
        }
        presenter.modalPresentationStyle = .fullScreen
        present(presenter, animated: true)
    }
}
