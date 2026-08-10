//
//  UIViewController+TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from UIViewController+CYLTabBarControllerExtention
//

import ObjectiveC
import UIKit

public typealias TFYSwiftPopSelectTabBarChildViewControllerCompletion = (UIViewController) -> Void

public typealias TFYSwiftPushOrPopCompletionHandler = (
    _ shouldPop: Bool,
    _ viewControllerPopTo: UIViewController?,
    _ shouldPopSelectTabBarChildViewController: Bool,
    _ index: UInt
) -> Void

public typealias TFYSwiftPushOrPopCallback = (
    _ viewControllers: [UIViewController],
    _ completionHandler: @escaping TFYSwiftPushOrPopCompletionHandler
) -> Void

public extension UIViewController {

    private var tfy_actualBadgeHost: UIView? {
        tfy_getActualBadgeSuperView() as? UIView
    }

    @objc func tfy_isSystemStyleTabBar() -> Bool {
        if let controller = self as? TFYSwiftTabBarController {
            return controller.tabBarStyleType != .flatDesign
        }
        if let controller = tabBarController as? TFYSwiftTabBarController {
            return controller.tabBarStyleType != .flatDesign
        }
        return false
    }

    @objc func tfy_isFlatDesignStyleTabBar() -> Bool {
        if let controller = self as? TFYSwiftTabBarController {
            return controller.tabBarStyleType == .flatDesign
        }
        if let controller = tabBarController as? TFYSwiftTabBarController {
            return controller.tabBarStyleType == .flatDesign
        }
        return false
    }

    @objc var tfy_embedInTabBarController: Bool {
        tfy_isEmbedInTabBarController()
    }

    @objc func tfy_isEmbedInTabBarController() -> Bool {
        let viewControllerInstead = tfy_getViewControllerInsteadOfNavigationController()
        if tfy_tabBarController == nil && viewControllerInstead.tfy_tabBarController == nil {
            return false
        }
        if tfy_isPlusChildViewController() {
            return false
        }
        if tfy_isPlaceholder || viewControllerInstead.tfy_isPlaceholder {
            return false
        }
        guard let viewControllers = tfy_tabBarController?.viewControllers else { return false }
        for (index, vc) in viewControllers.enumerated() {
            if vc.tfy_getViewControllerInsteadOfNavigationController() === viewControllerInstead {
                tfy_setTabIndex(index)
                return true
            }
        }
        return false
    }

    @objc var tfy_tabIndex: Int {
        get {
            guard tfy_isEmbedInTabBarController() else { return NSNotFound }
            return (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.tabIndex) as? NSNumber)?.intValue ?? NSNotFound
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.tabIndex, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func tfy_setTabIndex(_ tabIndex: Int) {
        tfy_tabIndex = tabIndex
    }

    @objc var tfy_tabButton: UIControl? {
        get {
            if let stored = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.tabButton) as? UIControl {
                return stored
            }
            return tfy_resolveTabButton()
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.tabButton, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let resolved = tfy_getViewControllerInsteadOfNavigationController() as NSObject? {
                objc_setAssociatedObject(resolved, &TFYSwiftAssociatedKeys.tabButton, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @objc var tfy_plusViewControllerEverAdded: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.plusViewControllerEverAdded) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.plusViewControllerEverAdded, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // MARK: - Badge forwarding

    @objc func tfy_isShowBadge() -> Bool {
        tfy_actualBadgeHost?.tfy_isShowBadge() ?? false
    }

    @objc func tfy_showBadge() {
        tfy_actualBadgeHost?.tfy_showBadge()
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType) {
        tfy_showBadgeValue(value, animationTypeValue: NSNumber(value: animationType.rawValue))
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationTypeValue: NSNumber?) {
        tfy_actualBadgeHost?.tfy_showBadgeValue(value, animationTypeValue: animationTypeValue)
    }

    @objc func tfy_clearBadge() {
        tfy_actualBadgeHost?.tfy_clearBadge()
    }

    @objc func tfy_resumeBadge() {
        tfy_actualBadgeHost?.tfy_resumeBadge()
    }

    @objc func tfy_isPauseBadge() -> Bool {
        tfy_actualBadgeHost?.tfy_isPauseBadge() ?? false
    }

    @objc var tfy_badge: UIView? {
        get { tfy_actualBadgeHost?.tfy_badge }
        set { tfy_actualBadgeHost?.tfy_badge = newValue }
    }

    @objc var tfy_badgeFont: UIFont? {
        get { tfy_actualBadgeHost?.tfy_badgeFont }
        set { tfy_actualBadgeHost?.tfy_badgeFont = newValue }
    }

    @objc var tfy_badgeBackgroundColor: UIColor? {
        get { tfy_actualBadgeHost?.tfy_badgeBackgroundColor }
        set { tfy_actualBadgeHost?.tfy_badgeBackgroundColor = newValue }
    }

    @objc var tfy_badgeTextColor: UIColor? {
        get { tfy_actualBadgeHost?.tfy_badgeTextColor }
        set { tfy_actualBadgeHost?.tfy_badgeTextColor = newValue }
    }

    @objc var tfy_badgeAnimationType: TFYSwiftBadgeAnimationType {
        get { tfy_actualBadgeHost?.tfy_badgeAnimationType ?? .none }
        set { tfy_actualBadgeHost?.tfy_badgeAnimationType = newValue }
    }

    @objc var tfy_badgeFrame: CGRect {
        get { tfy_actualBadgeHost?.tfy_badgeFrame ?? .zero }
        set { tfy_actualBadgeHost?.tfy_badgeFrame = newValue }
    }

    @objc var tfy_badgeCenterOffset: CGPoint {
        get { tfy_actualBadgeHost?.tfy_badgeCenterOffset ?? .zero }
        set { tfy_actualBadgeHost?.tfy_badgeCenterOffset = newValue }
    }

    @objc var tfy_badgeMaximumBadgeNumber: Int {
        get { tfy_actualBadgeHost?.tfy_badgeMaximumBadgeNumber ?? 99 }
        set { tfy_actualBadgeHost?.tfy_badgeMaximumBadgeNumber = newValue }
    }

    @objc var tfy_badgeMargin: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeMargin ?? 8 }
        set { tfy_actualBadgeHost?.tfy_badgeMargin = newValue }
    }

    @objc var tfy_badgeRadius: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeRadius ?? 0 }
        set { tfy_actualBadgeHost?.tfy_badgeRadius = newValue }
    }

    @objc var tfy_badgeCornerRadius: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeCornerRadius ?? 0 }
        set { tfy_actualBadgeHost?.tfy_badgeCornerRadius = newValue }
    }

    // MARK: - Tab selection helpers

    @objc func tfy_popSelectTabBarChildViewController(at index: UInt) -> UIViewController? {
        tfy_popSelectTabBarChildViewController(at: index, animated: false)
    }

    @objc func tfy_popSelectTabBarChildViewController(at index: UInt, animated: Bool) -> UIViewController? {
        let viewController = tfy_getViewControllerInsteadOfNavigationController()
        viewController.tfy_checkTabBarChildControllerValidity(at: index)
        guard let tabBarController = viewController.tfy_tabBarController else { return nil }
        tabBarController.selectedIndex = Int(index)
        viewController.navigationController?.popToRootViewController(animated: animated)
        let selected = tabBarController.selectedViewController
        return selected?.tfy_getViewControllerInsteadOfNavigationController()
    }

    @objc func tfy_popSelectTabBarChildViewController(at index: UInt, completion: TFYSwiftPopSelectTabBarChildViewControllerCompletion?) {
        let selected = tfy_popSelectTabBarChildViewController(at: index)
        DispatchQueue.main.async {
            if let selected {
                completion?(selected)
            }
        }
    }

    @objc func tfy_popSelectTabBarChildViewController(for classType: AnyClass) -> UIViewController? {
        guard let tabBarController = tfy_getViewControllerInsteadOfNavigationController().tfy_tabBarController,
              let viewControllers = tabBarController.viewControllers else {
            return nil
        }
        let atIndex = tfy_index(for: classType, in: viewControllers)
        return tfy_popSelectTabBarChildViewController(at: UInt(atIndex))
    }

    @objc func tfy_popSelectTabBarChildViewController(for classType: AnyClass, completion: TFYSwiftPopSelectTabBarChildViewControllerCompletion?) {
        let selected = tfy_popSelectTabBarChildViewController(for: classType)
        DispatchQueue.main.async {
            if let selected {
                completion?(selected)
            }
        }
    }

    @objc func tfy_pushOrPopToViewController(
        _ viewController: UIViewController,
        animated: Bool,
        callback: TFYSwiftPushOrPopCallback?
    ) {
        guard let callback else {
            navigationController?.pushViewController(viewController, animated: animated)
            return
        }

        let popSelect: (Bool, UInt) -> Void = { shouldPopSelect, index in
            if shouldPopSelect {
                self.tfy_popSelectTabBarChildViewController(at: index) { selected in
                    selected.navigationController?.pushViewController(viewController, animated: animated)
                }
            } else {
                self.navigationController?.pushViewController(viewController, animated: animated)
            }
        }

        let sameTypeStack = tfy_getOtherSameClassTypeViewControllers(inCurrentNavigationControllerStack: viewController)
        let completionHandler: TFYSwiftPushOrPopCompletionHandler = { shouldPop, viewControllerPopTo, shouldPopSelectTabBarChildViewController, index in
            var shouldPopLocal = shouldPop
            if sameTypeStack.isEmpty {
                shouldPopLocal = false
            }
            DispatchQueue.main.async {
                if shouldPopLocal, let viewControllerPopTo {
                    self.navigationController?.popToViewController(viewControllerPopTo, animated: animated)
                    return
                }
                popSelect(shouldPopSelectTabBarChildViewController, index)
            }
        }
        callback(sameTypeStack, completionHandler)
    }

    @objc func tfy_pushViewController(_ viewController: UIViewController, animated: Bool) {
        let fromViewController = tfy_getViewControllerInsteadOfNavigationController()
        let childViewControllers = fromViewController.navigationController?.viewControllers ?? []
        if let last = childViewControllers.last, type(of: last) == type(of: viewController) {
            return
        }
        fromViewController.navigationController?.pushViewController(viewController, animated: animated)
    }

    @objc func tfy_getViewControllerInsteadOfNavigationController() -> UIViewController {
        if let nav = self as? UINavigationController, let first = nav.viewControllers.first {
            return first
        }
        return self
    }

    @objc func tfy_handleNavigationBackAction() {
        tfy_handleNavigationBackAction(withAnimated: true)
    }

    @objc func tfy_handleNavigationBackAction(withAnimated animated: Bool) {
        if presentationController == nil {
            navigationController?.popViewController(animated: animated)
            return
        }
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationController?.popViewController(animated: animated)
        } else {
            dismiss(animated: animated)
        }
    }

    @objc var tfy_visiableTabButton: UIControl? {
        if TFYSwiftConstants.isLiquidGlassActive() {
            return tabBarItem.tfy_selectedTabButton
        }
        return tfy_tabButton
    }

    @objc func tfy_isEqualToViewController(_ compairedViewController: UIViewController) -> Bool {
        if self === compairedViewController { return true }
        return tfy_getViewControllerInsteadOfNavigationController() === compairedViewController.tfy_getViewControllerInsteadOfNavigationController()
    }

    @objc func tfy_addChildViewController(_ childController: Any) {
        guard let viewController = childController as? UIViewController else { return }
        if viewController.tfy_isPlaceholder || viewController.tfy_getViewControllerInsteadOfNavigationController().tfy_isPlaceholder {
            return
        }
        addChild(viewController)
    }

    @objc func tfy_isReady() -> Bool {
        true
    }

    @objc func tfy_getActualBadgeSuperView() -> Any? {
        if tfy_isPlaceholder { return nil }

        let viewController = tfy_getViewControllerInsteadOfNavigationController()
        guard let viewControllerItem = viewController.tabBarItem else { return nil }
        let viewControllerControl = viewControllerItem.tfy_tabButton
        let navigationViewControllerItem = viewController.navigationController?.tabBarItem

        if TFYSwiftConstants.isLiquidGlassActive() {
            if let viewControllerControl {
                return viewControllerControl
            }
            return navigationViewControllerItem
        }

        if let viewControllerControl {
            viewControllerControl.layoutIfNeeded()
            return viewControllerControl.tfy_getActualBadgeSuperView()
        }
        return navigationViewControllerItem?.tfy_getActualBadgeSuperView()
    }

    // MARK: - Deprecated badge point

    @objc func tfy_showTabBadgePoint() {
        guard !tfy_isPlusChildViewController() else { return }
        tfy_showBadge()
    }

    @objc func tfy_removeTabBadgePoint() {
        guard !tfy_isPlusChildViewController() else { return }
        tfy_clearBadge()
    }

    @objc func tfy_isShowTabBadgePoint() -> Bool {
        guard !tfy_isPlusChildViewController() else { return false }
        return tfy_isShowBadge()
    }

    // MARK: - Private

    private func tfy_isPlusChildViewController() -> Bool {
        guard let plusChild = TFYSwiftPlusChildViewController else { return false }
        return self === plusChild
    }

    private func tfy_resolveTabButton() -> UIControl? {
        if tfy_tabIndex != NSNotFound,
           let items = tfy_tabBarController?.tabBar.items,
           tfy_tabIndex < items.count {
            return items[tfy_tabIndex].tfy_tabButton
        }
        if tfy_isPlaceholder || tfy_getViewControllerInsteadOfNavigationController().tfy_isPlaceholder {
            return TFYSwiftExternPlusButton
        }
        if let control = tabBarItem.tfy_tabButton {
            return control
        }
        return tfy_getViewControllerInsteadOfNavigationController().tabBarItem.tfy_tabButton
    }

    private func tfy_getOtherSameClassTypeViewControllers(inCurrentNavigationControllerStack viewController: UIViewController) -> [UIViewController] {
        var stack = navigationController?.viewControllers ?? []
        guard stack.count >= 2 else { return [] }
        stack.removeAll { $0 === self }
        return stack.filter { type(of: $0) == type(of: viewController) }
    }

    fileprivate func tfy_checkTabBarChildControllerValidity(at index: UInt) {
        guard let tabBarController = tfy_getViewControllerInsteadOfNavigationController().tfy_tabBarController,
              let viewControllers = tabBarController.viewControllers,
              Int(index) < viewControllers.count else {
            return
        }
        let viewController = viewControllers[Int(index)]
        if let plusButton = TFYSwiftExternPlusButton,
           let plusChild = TFYSwiftPlusChildViewController,
           Int(index) != Int(TFYSwiftPlusButtonIndex),
           viewController !== plusChild {
            plusButton.isSelected = false
        }
    }

    private func tfy_index(for classType: AnyClass, in viewControllers: [UIViewController]) -> Int {
        for (idx, obj) in viewControllers.enumerated() {
            let resolved = obj.tfy_getViewControllerInsteadOfNavigationController()
            if resolved.isKind(of: classType) {
                return idx
            }
        }
        return NSNotFound
    }
}

// Badge protocol methods provided by UIViewController+TFYSwiftTabBar / Badge extensions.
// extension UIViewController: TFYSwiftBadgeProtocol {}
