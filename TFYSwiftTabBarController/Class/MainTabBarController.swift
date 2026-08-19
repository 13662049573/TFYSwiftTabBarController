import TFYSwiftTabBarController
import UIKit

final class MainTabBarController: TFYSwiftTabBarController {

    convenience init(style: TFYSwiftTabBarStyleType, context: String?) {
        self.init(
            viewControllers: Self.makeViewControllers(style: style),
            tabBarItemsAttributes: Self.makeAttributes(),
            imageInsets: .zero,
            titlePositionAdjustment: UIOffset(horizontal: 0, vertical: -3.5),
            styleType: style,
            context: context
        )
        delegate = self
    }

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidLoad() {
        // Style must be set before super.viewDidLoad so KVC tabBar replacement sees it.
        super.viewDidLoad()
        UIApplication.shared.applicationSupportsShakeToEdit = true
        _ = becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        guard motion == .motionShake else { return }
        selectedViewController?
            .tfy_getViewControllerInsteadOfNavigationController()
            .tfy_showBadgeValue("摇", animationType: .bounce)
    }

    override func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        updateSelectionStatusIfNeeded(for: tabBarController, shouldSelectViewController: viewController)
        return true
    }

    func tabBarController(_ tabBarController: TFYSwiftTabBarController, didSelectControl control: UIControl) {
        guard control is TFYSwiftPlusButton else { return }
        control.tfy_showBadgeValue("", animationType: .scaleOnce)
    }

    static func makeViewControllers(style: TFYSwiftTabBarStyleType) -> [UIViewController] {
        let home = TFYSwiftBaseNavigationController(rootViewController: HomeViewController())
        let city = TFYSwiftBaseNavigationController(rootViewController: CityViewController())
        let message = TFYSwiftBaseNavigationController(rootViewController: MessageViewController())
        let mine = TFYSwiftBaseNavigationController(rootViewController: MineViewController())
        let suffix: String
        switch style {
        case .flatDesign: suffix = "（扁平）"
        case .liquidGlass: suffix = "（液态）"
        default: suffix = ""
        }
        zip([home, city, message, mine], ["首页", "同城", "消息", "我的"]).forEach { nav, title in
            nav.tfy_getViewControllerInsteadOfNavigationController().title = title + suffix
            nav.tfy_getViewControllerInsteadOfNavigationController().tfy_hideNavigationBarSeparator = true
        }
        return [home, city, message, mine]
    }

    static func makeAttributes() -> [[AnyHashable: Any]] {
        func tabImage(named name: String, symbol: String) -> Any {
            if let image = UIImage(named: name) { return image }
            return UIImage(systemName: symbol)?.withRenderingMode(.alwaysTemplate) as Any
        }
        func item(_ title: String, image: String, symbol: String, lottie: String) -> [AnyHashable: Any] {
            var attrs: [AnyHashable: Any] = [
                TFYSwiftTabBarItemTitle: title,
                TFYSwiftTabBarItemImage: tabImage(named: image, symbol: symbol),
                TFYSwiftTabBarItemSelectedImage: tabImage(named: image.replacingOccurrences(of: "_normal", with: "_highlight"), symbol: symbol),
            ]
            if let path = Bundle.main.path(forResource: lottie, ofType: "json") {
                attrs[TFYSwiftTabBarLottieFilePath] = path
            }
            return attrs
        }
        return [
            item("首页", image: "home_normal", symbol: "house.fill", lottie: "green_lottie_tab_home"),
            item("同城", image: "fishpond_normal", symbol: "leaf.fill", lottie: "green_lottie_tab_discover"),
            item("消息", image: "message_normal", symbol: "message.fill", lottie: "green_lottie_tab_news"),
            item("我的", image: "account_normal", symbol: "person.fill", lottie: "green_lottie_tab_mine"),
        ]
    }
}
