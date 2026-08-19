import TFYSwiftTabBarController
import UIKit

/// OC `CYLMineViewController`: row index becomes badge, then push with pop disabled.
final class MineViewController: DemoActionTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tfy_showBadgeValue("新", animationType: .scale)
        applyOpaqueNavigationBar()
        sections = [
            Section(title: "我的 · 对照 CYLMine", rows: [
                Row(title: "清除「我的」角标", subtitle: "tfy_clearBadge", action: { $0.tfy_clearBadge() }),
                Row(title: "恢复角标", subtitle: "tfy_resumeBadge", action: { $0.tfy_resumeBadge() }),
                Row(title: "testPush 红页（禁侧滑）", subtitle: "对照 CYLMineViewController testPush", action: { ($0 as? MineViewController)?.testPush() }),
                Row(title: "强制 Dark 测布局", subtitle: "OC 用 overrideUserInterfaceStyle 刷 TabBar", action: {
                    $0.overrideUserInterfaceStyle = .dark
                }),
                Row(title: "强制 Light", subtitle: "浅色", action: { $0.overrideUserInterfaceStyle = .light }),
                Row(title: "跟随系统", subtitle: "unspecified", action: { $0.overrideUserInterfaceStyle = .unspecified }),
            ]),
            Section(title: "我的列表（点行 = 角标数字 + testPush）", rows: (0..<30).map { index in
                Row(title: "我的 \(index)", subtitle: "badge = \(index)，再 Push 红页", action: { host in
                    host.tfy_badgeCenterOffset = .zero
                    host.tfy_showBadgeValue("\(index)", animationType: .none)
                    (host as? MineViewController)?.testPush()
                })
            }),
        ]
    }

    @objc func testPush() {
        let page = TFYSwiftBaseViewController()
        page.title = "testPush"
        page.view.backgroundColor = .systemRed
        page.tfy_disablePopGestureRecognizer = true
        page.tfy_hidesBottomBarWhenPushed = true
        let label = UILabel()
        label.text = "对照 CYLMineViewController.testPush\n已禁用侧滑返回，用导航返回键。"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        page.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: page.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: page.view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: page.view.leadingAnchor, constant: 24),
        ])
        navigationController?.pushViewController(page, animated: true)
    }

    private func applyOpaqueNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}
