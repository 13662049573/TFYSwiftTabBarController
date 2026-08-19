import TFYSwiftTabBarController
import UIKit

/// Mirrors OC `CYLMainRootViewController`: a nav shell that swaps tab-bar styles.
final class DemoRootNavigationController: UINavigationController {
    private(set) var currentStyle: TFYSwiftTabBarStyleType = .default

    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        installTabBar(style: .default)
    }

    @discardableResult
    func installTabBar(style: TFYSwiftTabBarStyleType, context: String? = nil) -> TFYSwiftTabBarController {
        PlusButtonSubclass.registerPlusButton()
        currentStyle = style
        let tab = MainTabBarController(style: style, context: context)
        viewControllers = [tab]
        return tab
    }
}

extension UIViewController {
    var demoRoot: DemoRootNavigationController? {
        if let root = tfy_getRootViewController() as? DemoRootNavigationController {
            return root
        }
        var walker: UIViewController? = self
        while let parent = walker?.parent {
            if let root = parent as? DemoRootNavigationController { return root }
            walker = parent
        }
        return navigationController as? DemoRootNavigationController
            ?? presentingViewController as? DemoRootNavigationController
    }
}
