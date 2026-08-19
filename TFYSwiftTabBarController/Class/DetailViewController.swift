import TFYSwiftTabBarController
import UIKit

/// OC `CYLDetailsViewController`: orange page, tap → popSelect 我的 + testPush.
final class DetailViewController: TFYSwiftBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if title == nil { title = "详情" }
        view.backgroundColor = .systemOrange

        let label = UILabel()
        label.text = "点击屏幕可跳转到「我的」，执行 testPush"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
        ])

        navigationItem.backBarButtonItem?.tfy_badgeBackgroundColor = .systemRed
        navigationItem.backBarButtonItem?.tfy_badgeCenterOffset = CGPoint(x: -5, y: 3)
        navigationItem.backBarButtonItem?.tfy_showBadgeValue("", animationType: .scale)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        tfy_popSelectTabBarChildViewController(for: MineViewController.self) { selected in
            (selected as? MineViewController)?.testPush()
        }
    }
}
