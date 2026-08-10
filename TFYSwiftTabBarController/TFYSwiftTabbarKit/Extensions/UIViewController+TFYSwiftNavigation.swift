//
//  UIViewController+TFYSwiftNavigation.swift
//  TFYSwiftTabBarController
//
//  Converted from UIViewController+CYLNavigationControllerExtention
//

import ObjectiveC
import UIKit

private let tfyFullScreenAnimationTime: TimeInterval = 0.3

public extension UIViewController {

    @objc var tfy_disablePopGestureRecognizer: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.disablePopGestureRecognizer) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.disablePopGestureRecognizer, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfy_hideNavigationBarSeparator: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.hideNavigationBarSeparator) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.hideNavigationBarSeparator, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfy_navigationBarHidden: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.navigationBarHidden) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.navigationBarHidden, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfy_hidesBottomBarWhenPushed: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.hidesBottomBarWhenPushed) as? NSNumber)?.boolValue ?? false }
        set {
            hidesBottomBarWhenPushed = newValue
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.hidesBottomBarWhenPushed, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func tfy_disableInteractivePopGestureRecognizer() {
        guard navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) == true else {
            return
        }
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        if #available(iOS 26.0, *) {
            navigationController?.interactiveContentPopGestureRecognizer?.delegate = nil
        }
        tfy_resetTabBarHidden()
    }

    @objc func tfy_enableInteractivePopGestureRecognizer() {
        guard navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) == true else {
            return
        }
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if #available(iOS 26.0, *) {
            navigationController?.interactiveContentPopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
            navigationController?.interactiveContentPopGestureRecognizer?.isEnabled = true
        }
    }

    @objc func tfy_resetInteractivePopGestureRecognizer() {
        guard navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) == true else {
            return
        }
        let isSingle = (navigationController?.viewControllers.count ?? 0) == 1
        let needDisable = tfy_disablePopGestureRecognizer || isSingle
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !needDisable
        if #available(iOS 26.0, *) {
            navigationController?.interactiveContentPopGestureRecognizer?.isEnabled = !needDisable
        }
        tfy_resetTabBarHidden()
    }

    @objc func tfy_hideNavigationBarSeparatorIfNeeded() {
        guard tfy_hideNavigationBarSeparator else { return }
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }

    @objc func tfy_shouldNavigationBarVisible() -> Bool {
        guard let navigationController else { return true }
        var shouldSet = true
        var isPop = true
        var selfIndex = -1
        let vcList = navigationController.viewControllers
        for (index, vc) in vcList.enumerated() where vc === self {
            selfIndex = index
            if selfIndex == vcList.count - 1 {
                return true
            }
            isPop = false
            break
        }
        if isPop {
            let preVc = navigationController.viewControllers.last
            if tfy_navigationBarHidden == preVc?.tfy_navigationBarHidden {
                shouldSet = false
            }
        } else if selfIndex + 1 < vcList.count {
            let nextVc = vcList[selfIndex + 1]
            if tfy_navigationBarHidden == nextVc.tfy_navigationBarHidden {
                shouldSet = false
            }
        }
        return shouldSet
    }

    @objc func tfy_setNavigationBarVisibleIfNeeded(_ animated: Bool) {
        if tfy_navigationBarHidden, tfy_shouldNavigationBarVisible() {
            navigationController?.setNavigationBarHidden(!tfy_navigationBarHidden, animated: animated)
        }
    }

    @objc func tfy_setNavigationBarHiddenIfNeeded(_ animated: Bool) {
        if tfy_navigationBarHidden {
            navigationController?.setNavigationBarHidden(tfy_navigationBarHidden, animated: animated)
        }
    }

    @objc func tfy_viewWillAppearNavigationSetting(_ animated: Bool) {
        tfy_hideNavigationBarSeparatorIfNeeded()
        tfy_setNavigationBarHiddenIfNeeded(animated)
    }

    @objc func tfy_viewWillDisappearNavigationSetting(_ animated: Bool) {
        tfy_disableInteractivePopGestureRecognizer()
        tfy_setNavigationBarVisibleIfNeeded(animated)
    }

    @objc func tfy_viewDidDisappearNavigationSetting(_ animated: Bool) {
        tfy_enableInteractivePopGestureRecognizer()
    }

    @objc func tfy_viewDidAppearNavigationSetting(_ animated: Bool) {
        tfy_resetInteractivePopGestureRecognizer()
    }

    @objc func tfy_deallocNavigationSetting() {
        tfy_disableInteractivePopGestureRecognizer()
    }

    @objc func tfy_setTabBarVisible(_ visible: Bool, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        if hidesBottomBarWhenPushed == !visible {
            completion?(true)
            return
        }
        guard let tabBar = tfy_tabBarController?.tabBar else {
            completion?(false)
            return
        }
        let screenSize = tfy_screenSize()
        let tabBarHeight = tfy_getTabBarFullH(tabBar.frame.height)
        let visibleFrame = CGRect(x: 0, y: screenSize.height - tabBarHeight, width: screenSize.width, height: tabBarHeight)
        let hiddenFrame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: tabBarHeight)
        let duration = animated ? tfyFullScreenAnimationTime : 0
        if visible {
            tabBar.frame = hiddenFrame
        } else if tabBar.frame != visibleFrame {
            tabBar.frame = visibleFrame
        }
        let targetFrame = visible ? visibleFrame : hiddenFrame
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            tabBar.frame = targetFrame
        }, completion: completion)
    }

    @objc func tfy_tabBarIsVisible() -> Bool {
        guard let tabBar = tfy_tabBarController?.tabBar else { return false }
        return tabBar.frame.minY < tfy_screenSize().height
    }

    @objc func tfy_showTabBarAnimated(_ animated: Bool, completion: ((Bool) -> Void)? = nil) {
        tfy_setTabBarVisible(true, animated: animated, completion: completion)
    }

    @objc func tfy_hideTabBarAnimated(_ animated: Bool, completion: ((Bool) -> Void)? = nil) {
        tfy_setTabBarVisible(false, animated: animated, completion: completion)
    }

    @objc func tfy_toggleTabBarAnimated(_ animated: Bool, completion: ((Bool) -> Void)? = nil) {
        tfy_setTabBarVisible(!tfy_tabBarIsVisible(), animated: animated, completion: completion)
    }

    private func tfy_resetTabBarHidden() {}

    private func tfy_shouldTabBarHidden() -> Bool {
        let stack = tfy_getViewControllerInsteadOfNavigationController().navigationController?.viewControllers ?? []
        for index in 1..<stack.count where stack[index].tfy_hidesBottomBarWhenPushed {
            return true
        }
        return false
    }

    private func tfy_hideTabbar() {
        tfy_updateTabbar(shouldHidden: true)
        guard let coordinator = transitionCoordinator, let tabBar = tfy_tabBarController?.tabBar else { return }
        let tabbarImageView = tfy_imageView(fromSnapshotOf: tabBar)
        coordinator.viewController(forKey: .from)?.view.addSubview(tabbarImageView)
        coordinator.animate(alongsideTransition: nil) { context in
            tabbarImageView.removeFromSuperview()
            if context.isCancelled {
                self.tfy_updateTabbar(shouldHidden: false)
            }
        }
    }

    private func tfy_showTabbar() {
        guard let coordinator = transitionCoordinator else {
            tfy_updateTabbar(shouldHidden: false)
            return
        }
        guard let tabBar = tfy_tabBarController?.tabBar else { return }
        let tabbarImageView = tfy_imageView(fromSnapshotOf: tabBar)
        coordinator.viewController(forKey: .to)?.view.addSubview(tabbarImageView)
        coordinator.animate(alongsideTransition: nil) { context in
            tabbarImageView.removeFromSuperview()
            if !context.isCancelled {
                self.tfy_updateTabbar(shouldHidden: false)
            }
        }
    }

    private func tfy_imageView(fromSnapshotOf view: UIView) -> UIImageView {
        let imageView = UIImageView(image: view.tfy_takeSnapshotWithoutViews([]))
        imageView.frame = view.frame
        return imageView
    }

    private func tfy_updateTabbar(shouldHidden: Bool) {
        guard let tabBar = tfy_tabBarController?.tabBar else { return }
        tabBar.tfy_setHidden(shouldHidden)
        tabBar.subviews.forEach { $0.tfy_setHidden(shouldHidden) }
    }
}
