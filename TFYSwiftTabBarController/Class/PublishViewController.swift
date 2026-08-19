import TFYSwiftTabBarController
import UIKit

/// OC Plus child (`CYLPlusChildViewController` / Publish).
final class PublishViewController: DemoActionTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发布"
        sections = [
            Section(title: "Plus 子控制器", rows: [
                Row(title: "说明", subtitle: "中间凸起按钮进来的页面，对应 plusChildViewController", action: { _ in }),
                Row(title: "回到首页", subtitle: "popSelect HomeViewController", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(for: HomeViewController.self)
                }),
                Row(title: "回到「我的」", subtitle: "popSelect MineViewController", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(for: MineViewController.self)
                }),
                Row(title: "Plus 信息", subtitle: "hasPlusButton · index · 是否居中", action: {
                    guard let tab = $0.demoTab else { return }
                    let bar = tab.tabBar as? TFYSwiftTabBar
                    $0.presentAlert(
                        "hasPlus \(tab.hasPlusButton())\nindex \(bar?.plusButtonIndex() ?? 2)\ncentered \(bar?.isPlusButtonLayoutCentered() ?? false)\nchild \(bar?.hasPlusChildViewController() ?? false)"
                    )
                }),
                Row(title: "本页角标 NEW", subtitle: "Plus 子页也可以挂角标", action: {
                    $0.tfy_showBadgeValue("new", animationType: .scale)
                }),
                Row(title: "清除本页角标", subtitle: "tfy_clearBadge", action: { $0.tfy_clearBadge() }),
            ]),
        ]
    }
}
