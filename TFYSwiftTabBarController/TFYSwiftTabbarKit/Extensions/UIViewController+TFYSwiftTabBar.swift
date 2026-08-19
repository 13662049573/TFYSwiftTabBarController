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

    /// Matches OC `cyl_isSystemStyleTabBar`: any CYL/TFY tab bar that is **not** FlatDesign.
    @objc func tfy_isSystemStyleTabBar() -> Bool {
        guard let controller = self as? TFYSwiftTabBarController else { return false }
        return controller.tabBarStyleType != .flatDesign
    }

    @objc func tfy_isFlatDesignStyleTabBar() -> Bool {
        guard let controller = self as? TFYSwiftTabBarController else { return false }
        return controller.tabBarStyleType == .flatDesign
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

    /// FlatDesign custom tab item (mirrors `cyl_tabBarItem`).
    @objc var tfy_tabBarItem: TFYSwiftFlatDesignTabBarItem {
        get {
            if let item = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.flatDesignTabBarItem) as? TFYSwiftFlatDesignTabBarItem {
                return item
            }
            let item = TFYSwiftFlatDesignTabBarItem(
                title: title ?? "Item",
                image: UIImage.tfy_tabItemPlaceholderImage(),
                selectedImage: UIImage.tfy_tabItemPlaceholderImage()
            )
            item.index = UInt(NSNotFound)
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.flatDesignTabBarItem, item, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let resolved = tfy_getViewControllerInsteadOfNavigationController()
            if resolved !== self {
                objc_setAssociatedObject(resolved, &TFYSwiftAssociatedKeys.flatDesignTabBarItem, item, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return item
        }
        set {
            let oldItem = (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.flatDesignTabBarItem) as? TFYSwiftFlatDesignTabBarItem)
                ?? tfy_getViewControllerInsteadOfNavigationController().tfy_tabBarItem
            if let tabBarController = tfyflatdesign_tabBarController as? TFYSwiftTabBarController,
               tabBarController.tabBarStyleType == .flatDesign {
                tabBarController.changeItem(oldItem, toItem: newValue)
                tfy_tabButton = newValue.tabBarButton
            }
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.flatDesignTabBarItem, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let resolved = tfy_getViewControllerInsteadOfNavigationController()
            if resolved !== self {
                objc_setAssociatedObject(resolved, &TFYSwiftAssociatedKeys.flatDesignTabBarItem, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @objc func tfy_setTabBarItem(_ tabBarItem: TFYSwiftFlatDesignTabBarItem?) {
        tfy_tabBarItem = tabBarItem ?? TFYSwiftFlatDesignTabBarItem(title: title, image: nil)
    }

    @objc var tfy_plusViewControllerEverAdded: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.plusViewControllerEverAdded) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.plusViewControllerEverAdded, NSNumber(value: newValue), .OBJC_ASSOCIATION_ASSIGN) }
    }

    // MARK: - Badge forwarding

    @objc func tfy_isShowBadge() -> Bool {
        tfy_actualBadgeHost?.tfy_isShowBadge() ?? false
    }

    @objc func tfy_showBadge() {
        tfy_showBadgeValue("", animationType: .none)
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType) {
        tfy_showBadgeValue(value, animationTypeValue: NSNumber(value: animationType.rawValue))
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationTypeValue: NSNumber?) {
        tfy_paintBadgeWhenReady(value, animationTypeValue: animationTypeValue, attemptsLeft: 8)
    }

    @objc func tfy_clearBadge() {
        tfy_paintClearBadge()
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
        let tabBarController = viewController.tfy_tabBarController
            ?? (viewController.tabBarController as? TFYSwiftTabBarController)
        guard let tabBarController else { return nil }
        let count = tabBarController.viewControllers?.count ?? 0
        guard index != UInt(NSNotFound), Int(index) < count else { return nil }
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
        let host = tfy_getViewControllerInsteadOfNavigationController()
        let tabBarController = host.tfy_tabBarController
            ?? (host.tabBarController as? TFYSwiftTabBarController)
        guard let tabBarController,
              let viewControllers = tabBarController.viewControllers else {
            return nil
        }
        let atIndex = tfy_index(for: classType, in: viewControllers)
        guard atIndex != NSNotFound else { return nil }
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
        tfy_resolveViewControllerInsteadOfNavigationController(from: self) ?? self
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
        if tfy_usesLiquidGlassBadgePlacement() {
            return tabBarItem.tfy_selectedTabButton ?? tfy_tabButton
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

    func tfy_usesLiquidGlassBadgePlacement() -> Bool {
        let tab = (tabBarController as? TFYSwiftTabBarController)
            ?? (tfyflatdesign_tabBarController as? TFYSwiftTabBarController)
        if tab?.tabBarStyleType == .flatDesign { return false }
        return TFYSwiftConstants.isLiquidGlassActive()
    }

    @objc func tfy_isReady() -> Bool {
        true
    }

    @objc func tfy_getActualBadgeSuperView() -> Any? {
        if tfy_isPlaceholder { return nil }

        let viewController = tfy_getViewControllerInsteadOfNavigationController()
        let viewControllerItem = viewController.tabBarItem
        let viewControllerControl = viewControllerItem?.tfy_tabButton
        let navigationViewControllerItem = viewController.navigationController?.tabBarItem

        // FlatDesign custom button wins even on iOS 26, where a hidden system `_UITabButton` still exists.
        if let tab = (viewController.tabBarController as? TFYSwiftTabBarController)
            ?? (viewController.tfyflatdesign_tabBarController as? TFYSwiftTabBarController),
           tab.tabBarStyleType == .flatDesign {
            if let button = viewController.tfy_tabBarItem.tabBarButton
                ?? viewController.navigationController?.tfy_tabBarItem.tabBarButton
                ?? (viewController.tfy_tabButton as? TFYSwiftFlatDesignTabBarButton) {
                return button.actualBadgeSuperView()
            }
        }

        if viewController.tfy_usesLiquidGlassBadgePlacement() {
            if let visible = viewController.tfy_visiableTabButton {
                return visible
            }
            if let viewControllerControl {
                return viewControllerControl
            }
            return navigationViewControllerItem
        }

        if let viewControllerControl {
            viewControllerControl.layoutIfNeeded()
            return viewControllerControl.tfy_getActualBadgeSuperView() ?? viewControllerControl
        }
        return navigationViewControllerItem?.tfy_getActualBadgeSuperView()
    }

    private func tfy_paintBadgeWhenReady(_ value: String?, animationTypeValue: NSNumber?, attemptsLeft: Int) {
        let host = tfy_getActualBadgeSuperView()
        let ready: Bool
        if let view = host as? UIView {
            ready = view.tfy_isReady()
        } else if let item = host as? UITabBarItem {
            ready = item.tfy_isReady() || item.tfy_tabButton != nil
        } else {
            ready = host != nil
        }
        if ready || attemptsLeft <= 0 {
            tfy_paintBadge(value, animationTypeValue: animationTypeValue)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.tfy_paintBadgeWhenReady(value, animationTypeValue: animationTypeValue, attemptsLeft: attemptsLeft - 1)
        }
    }

    private func tfy_paintBadge(_ value: String?, animationTypeValue: NSNumber?) {
        let inner = tfy_getViewControllerInsteadOfNavigationController()
        let host: Any
        if let resolved = tfy_getActualBadgeSuperView() {
            host = resolved
        } else if let button = inner.tfy_tabButton
            ?? (inner.tfy_usesLiquidGlassBadgePlacement() ? inner.tabBarItem.tfy_tabButton : nil) {
            host = button
        } else {
            host = inner.tabBarItem as Any
        }
        if let item = host as? UITabBarItem {
            item.tfy_showBadgeValue(value, animationTypeValue: animationTypeValue)
            return
        }
        if let control = host as? UIControl {
            let liquid = control.tfy_usesLiquidGlassBadgePlacement()
            let target: UIView = liquid
                ? control
                : ((control.tfy_getActualBadgeSuperView() as? UIView) ?? control)
            target.tfy_showBadgeValue(value, animationTypeValue: animationTypeValue)
            guard liquid else { return }
            let counterpart: UIControl? = control.tfy_isPlatterSelectedControl()
                ? control.tfy_platterNormalControl()
                : control.tfy_platterSelectedControl()
            if let counterpart, counterpart !== control {
                counterpart.tfy_showBadgeValue(value, animationTypeValue: animationTypeValue)
            }
            return
        }
        (host as? UIView)?.tfy_showBadgeValue(value, animationTypeValue: animationTypeValue)
    }

    private func tfy_paintClearBadge() {
        let host = tfy_getActualBadgeSuperView()
        if let item = host as? UITabBarItem {
            item.tfy_clearBadge()
            return
        }
        if let control = host as? UIControl {
            let liquid = control.tfy_usesLiquidGlassBadgePlacement()
            let target: UIView = liquid
                ? control
                : ((control.tfy_getActualBadgeSuperView() as? UIView) ?? control)
            target.tfy_clearBadge()
            if liquid {
                let counterpart: UIControl? = control.tfy_isPlatterSelectedControl()
                    ? control.tfy_platterNormalControl()
                    : control.tfy_platterSelectedControl()
                if let counterpart, counterpart !== control {
                    counterpart.tfy_clearBadge()
                }
            }
            return
        }
        (host as? UIView)?.tfy_clearBadge()
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
