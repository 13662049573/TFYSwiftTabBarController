//
//  TFYSwiftBaseNavigationController.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLBaseNavigationController.h/.m
//

import UIKit

open class TFYSwiftBaseNavigationController: UINavigationController {

    /// TabBar child view controllers are lazily loaded; hide tab bar when pushing past root.
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            viewController.tfy_hidesBottomBarWhenPushed = true
        } else {
            viewController.tfy_hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
        tfy_syncFlatDesignTabBarVisibility()
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        tfy_toggleTabBarHidden()
        tfy_syncFlatDesignTabBarVisibility()
    }

    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let result = super.popToRootViewController(animated: animated)
        tfy_toggleTabBarHidden()
        tfy_syncFlatDesignTabBarVisibility()
        return result
    }

    open override func popViewController(animated: Bool) -> UIViewController? {
        let result = super.popViewController(animated: animated)
        tfy_toggleTabBarHidden()
        tfy_syncFlatDesignTabBarVisibility()
        return result
    }

    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let result = super.popToViewController(viewController, animated: animated)
        tfy_toggleTabBarHidden()
        tfy_syncFlatDesignTabBarVisibility()
        return result
    }

    private func tfy_toggleTabBarHidden() {
        let isHidden = viewControllers.count > 1
        guard let top = viewControllers.last else { return }
        top.tfy_hidesBottomBarWhenPushed = isHidden
    }

    private func tfy_syncFlatDesignTabBarVisibility() {
        guard let tab = tfy_tabBarController,
              tab.tabBarStyleType == .flatDesign else { return }
        // Defer until transition settles so top VC / hidesBottomBarWhenPushed are final.
        DispatchQueue.main.async {
            tab.updateBottomBarShowHideIfNeeded()
        }
    }
}
