import TFYSwiftTabBarController
import UIKit

/// OC `CYLMessageViewController`: every row pushes a nested tab bar.
final class MessageViewController: DemoActionTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tfy_showBadgeValue("11", animationType: .none)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "嵌套", style: .plain, target: self, action: #selector(pushNested))
        navigationItem.leftBarButtonItem?.tfy_badgeBackgroundColor = .systemRed
        sections = [
            Section(title: "消息 · 对照 CYLMessage", rows: [
                Row(title: "Push 嵌套 TFY TabBar", subtitle: "createNewTabBarWithContext + push", action: { DemoCatalog.pushNestedTab(from: $0) }),
                Row(title: "角标 11", subtitle: "本 Tab 默认数字", action: { $0.tfy_showBadgeValue("11", animationType: .none) }),
                Row(title: "红点", subtitle: "tfy_showBadge", action: { $0.tfy_showBadge() }),
                Row(title: "清除消息角标", subtitle: "tfy_clearBadge", action: { $0.tfy_clearBadge() }),
                Row(title: "左侧导航按钮红点", subtitle: "viewDidAppear 也会刷一次", action: {
                    $0.navigationItem.leftBarButtonItem?.tfy_showBadge()
                }),
            ]),
            Section(title: "消息列表", rows: (0..<15).map { index in
                Row(title: "消息 \(index)", subtitle: "对照 OC：点进去再套一层 TabBar", action: { DemoCatalog.pushNestedTab(from: $0) })
            }),
        ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.leftBarButtonItem?.tfy_showBadge()
    }

    @objc private func pushNested() {
        DemoCatalog.pushNestedTab(from: self)
    }
}
