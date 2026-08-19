import TFYSwiftTabBarController
import UIKit

/// OC `CYLSameCityViewController`: push detail with hidden nav + disabled pop.
final class CityViewController: DemoActionTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            Section(title: "同城 · 对照 CYLSameCity", rows: [
                Row(title: "Push 详情（隐藏导航 + 禁用侧滑）", subtitle: "cyl_setNavigationBarHidden + disablePop", action: { $0.pushCityDetail(hidesNav: true, disablePop: true) }),
                Row(title: "Push 详情（隐藏 TabBar）", subtitle: "tfy_hidesBottomBarWhenPushed", action: { $0.pushCityDetail(hidesNav: false, disablePop: false) }),
                Row(title: "选中「我的」", subtitle: "popSelect MineViewController", action: {
                    _ = $0.tfy_popSelectTabBarChildViewController(for: MineViewController.self)
                }),
            ]),
            Section(title: "同城列表", rows: (0..<15).map { index in
                Row(title: "同城 \(index)", subtitle: "Push 详情后点屏幕可跳「我的」", action: { $0.pushCityDetail(hidesNav: true, disablePop: true, title: "同城详情 \(index)") })
            }),
        ]
    }
}

private extension UIViewController {
    func pushCityDetail(hidesNav: Bool, disablePop: Bool, title: String? = nil) {
        let detail = DetailViewController()
        detail.title = title ?? "同城详情"
        detail.tfy_hidesBottomBarWhenPushed = true
        detail.tfy_navigationBarHidden = hidesNav
        detail.tfy_disablePopGestureRecognizer = disablePop
        navigationController?.pushViewController(detail, animated: true)
    }
}
