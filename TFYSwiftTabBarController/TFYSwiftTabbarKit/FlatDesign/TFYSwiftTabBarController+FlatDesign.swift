//
//  TFYSwiftTabBarController+FlatDesign.swift
//  TFYSwiftTabBarController
//
//  FlatDesign path: install custom tab bar, animated hide/show, push-hide sync.
//  Converted from CYLTabBarController.m FlatDesign branches.
//

import ObjectiveC
import UIKit

public let TFYSwiftFlatDesignUITabBarControllerHideShowBarDuration: TimeInterval = 0.2

@objc public protocol TFYSwiftFlatDesignUITabBarControllerDelegate: UITabBarControllerDelegate {
    @objc optional func tabBarController(_ tabBarController: TFYSwiftTabBarController, willShowTabBar tabBar: TFYSwiftFlatDesignTabBar)
    @objc optional func tabBarController(_ tabBarController: TFYSwiftTabBarController, didShowTabBar tabBar: TFYSwiftFlatDesignTabBar)
    @objc optional func tabBarController(_ tabBarController: TFYSwiftTabBarController, willHideTabBar tabBar: TFYSwiftFlatDesignTabBar)
    @objc optional func tabBarController(_ tabBarController: TFYSwiftTabBarController, didHideTabBar tabBar: TFYSwiftFlatDesignTabBar)
}

private enum TFYSwiftFlatDesignControllerKeys {
    static var tabBarHidden: UInt8 = 0
    static var tabBarIsAnimating: UInt8 = 0
    static var lastShowHideTabBar: UInt8 = 0
    static var needsReloadItems: UInt8 = 0
    static var items: UInt8 = 0
    static var willShow: UInt8 = 0
    static var didShow: UInt8 = 0
    static var willHide: UInt8 = 0
    static var didHide: UInt8 = 0
    static var parallaxOverlay: UInt8 = 0
}

extension TFYSwiftTabBarController {

    // MARK: - Public FlatDesign surface

    /// FlatDesign manual hide flag (separate from system `isTabBarHidden` on iOS 18+).
    @objc public var tfy_flatTabBarHidden: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.tabBarHidden) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.tabBarHidden, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// ObjC-compatible `isTabBarHidden` for FlatDesign (avoids clashing with UITabBarController iOS 18 API).
    @objc(tfy_isTabBarHidden)
    public func tfy_isTabBarHidden() -> Bool { tfy_flatTabBarHidden }

    @objc public var flatDesignItems: NSMutableArray {
        if let items = objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.items) as? NSMutableArray {
            return items
        }
        let items = NSMutableArray()
        objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.items, items, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return items
    }

    @objc(tfy_setFlatDesignTabBarHidden:animated:)
    func tfy_setFlatDesignTabBarHidden(_ hidden: Bool, animated: Bool) {
        guard tabBarStyleType == .flatDesign,
              let flatBar = flatDesignTabBar else { return }

        // OC: iOS 18+ uses `super setTabBarHidden:YES` so the system (liquid-glass)
        // chrome stays gone while the custom FlatDesign bar is shown.
        hideSystemTabBarChrome(animated: animated)

        if tabBarIsAnimating {
            lastShowHideTabBar = hidden
            return
        }
        guard flatBar.superview === view else { return }
        guard tfy_flatTabBarHidden != hidden else { return }

        tfy_flatTabBarHidden = hidden
        lastShowHideTabBar = hidden
        if flatBar.isHidden == hidden { return }
        guard checkHidesBottomBarWhenPushed() else { return }

        if animated {
            tabBarIsAnimating = true
            notifyWillShowHide(hidden: hidden, tabBar: flatBar)

            let start = hidden ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: flatBar.frame.height)
            let end = hidden ? CGAffineTransform(translationX: 0, y: flatBar.frame.height) : .identity
            flatBar.transform = start
            flatBar.isHidden = false

            UIView.animate(withDuration: TFYSwiftFlatDesignUITabBarControllerHideShowBarDuration, animations: {
                flatBar.transform = end
            }, completion: { _ in
                flatBar.transform = .identity
                flatBar.isHidden = hidden
                self.updateAdditionalSafeAreaInsets(animated: animated)
                self.tabBarIsAnimating = false
                self.notifyDidShowHide(hidden: hidden, tabBar: flatBar)
                if self.lastShowHideTabBar != hidden {
                    self.setTabBarHidden(self.lastShowHideTabBar, animated: animated)
                }
            })
        } else {
            notifyWillShowHide(hidden: hidden, tabBar: flatBar)
            flatBar.isHidden = hidden
            updateAdditionalSafeAreaInsets(animated: animated)
            notifyDidShowHide(hidden: hidden, tabBar: flatBar)
        }
    }

    @objc public func changeItem(_ item: TFYSwiftFlatDesignTabBarItem, toItem: TFYSwiftFlatDesignTabBarItem) {
        guard tabBarStyleType == .flatDesign, flatDesignTabBar != nil else { return }
        let items = flatDesignItems
        let index = items.indexOfObjectIdentical(to: item)
        guard index != NSNotFound else { return }
        items.replaceObject(at: index, with: toItem)
        flatDesignTabBar?.items = items.compactMap { $0 as? TFYSwiftFlatDesignTabBarItem }
    }

    // MARK: - Install / layout hooks (called from Core)

    @objc func tfy_installFlatDesignTabBarIfNeeded() {
        guard tabBarStyleType == .flatDesign else { return }
        if _cylTabBar is TFYSwiftTabBar {
            _cylTabBar = nil
        }
        guard _cylTabBar == nil else { return }

        let hideBar = TFYSwiftFlatDesignTabBarHideTabBar()
        tfy_setValue(hideBar, forKey: "tabBar")
        hideSystemTabBarChrome(animated: false)

        let flat = TFYSwiftFlatDesignTabBar(frame: tfy_flatTabBarFrame())
        flat.delegate = self
        _cylTabBar = flat
        view.addSubview(flat)

        tfy_flatTabBarHidden = false
        setTabBarHidden(false, animated: false)
        updateAdditionalSafeAreaInsets(animated: false)
        NotificationCenter.default.post(name: .TFYSwiftTabBarStyleTypeDidChange, object: self)
    }

    @objc func tfy_flatDesignViewDidLayoutSubviews() {
        guard let flatBar = flatDesignTabBar else { return }
        hideSystemTabContainerViews()
        if !tabBarIsAnimating,
           flatBar.frame != tfy_flatTabBarFrame(),
           flatBar.superview === view {
            flatBar.frame = tfy_flatTabBarFrame()
        }
        updateAdditionalSafeAreaInsets(animated: false)
    }

    @objc func tfy_flatDesignSetViewControllers(_ viewControllers: [UIViewController]?) {
        guard let flatBar = flatDesignTabBar else {
            _ = tfy_cylTabBar
            guard flatDesignTabBar != nil else {
                commitViewControllersToSuper(viewControllers)
                return
            }
            tfy_flatDesignSetViewControllers(viewControllers)
            return
        }
        needsReloadItems = true
        lottieURLs.removeAllObjects()
        lottieSizes.removeAllObjects()
        TFYSwiftTabbarItemsCount = UInt(viewControllers?.count ?? 0)
        if TFYSwiftPlusButtonIndex == 0, let plus = TFYSwiftExternPlusButton {
            TFYSwiftPlusButtonIndex = type(of: plus).index(forTabbarItemsCount: TFYSwiftTabbarItemsCount)
        }
        if let viewControllers {
            alignTabControlIfNeeded(with: viewControllers)
        }
        let aligned = self.viewControllers ?? viewControllers
        aligned?.enumerated().forEach { idx, child in
            child.tfyflatdesign_tabBarController = self
            setupFlatDesignChild(child, idx: idx)
            child.tfy_tabButton = child.tfy_tabBarItem.tabBarButton
        }
        commitViewControllersToSuper(aligned)
        if needsReloadItems {
            captureFlatDesignItems()
            flatBar.items = flatDesignItems.compactMap { $0 as? TFYSwiftFlatDesignTabBarItem }
            needsReloadItems = false
        }
        flatBar.selectedItem = selectedViewController?.tfy_tabBarItem
        updateAdditionalSafeAreaInsets(animated: false)
    }

    @objc func tfy_flatDesignSetSelectedIndex(_ selectedIndex: Int) {
        guard flatDesignTabBar != nil else {
            super.selectedIndex = selectedIndex
            return
        }
        guard self.selectedIndex != selectedIndex else {
            updateBottomBarShowHideIfNeeded()
            return
        }
        super.selectedIndex = selectedIndex
        guard let vcs = viewControllers, selectedIndex >= 0, selectedIndex < vcs.count else { return }
        if needsReloadItems {
            captureFlatDesignItems()
            flatDesignTabBar?.items = flatDesignItems.compactMap { $0 as? TFYSwiftFlatDesignTabBarItem }
            needsReloadItems = false
        }
        tabChangedToFlatDesignSelectedIndex(selectedIndex, viewController: nil, selectedItem: nil)
        updateBottomBarShowHideIfNeeded()
    }

    @objc func tfy_flatDesignDidSelectViewController(_ selectedViewController: UIViewController) {
        guard flatDesignTabBar != nil else { return }
        let selectedIndex = viewControllers?.firstIndex(of: selectedViewController) ?? NSNotFound
        if selectedViewController === TFYSwiftPlusChildViewController {
            TFYSwiftExternPlusButton?.isSelected = true
        }
        tabChangedToFlatDesignSelectedIndex(selectedIndex, viewController: selectedViewController, selectedItem: nil)
        updateBottomBarShowHideIfNeeded()
    }

    @objc func tfy_flatDesignUpdateTabBarHeight(_ height: CGFloat) {
        guard flatDesignTabBar != nil else { return }
        if abs(tabBarHeight - height) > .ulpOfOne {
            // height applied via Core setter path
            updateAdditionalSafeAreaInsets(animated: false)
            view.setNeedsLayout()
        }
    }

    /// Called by FlatDesignTabBar button taps.
    @objc(_tfytabBarItemClicked:)
    func tfy_tabBarItemClicked(_ tabBarItem: TFYSwiftFlatDesignTabBarItem) {
        guard let flatBar = flatDesignTabBar,
              let items = flatBar.items,
              let index = items.firstIndex(where: { $0 === tabBarItem }),
              let vcs = viewControllers,
              index < vcs.count else { return }

        let didSelect = vcs[index]
        if didSelect.tfy_isPlaceholder { return }
        if didSelect.tfy_getViewControllerInsteadOfNavigationController().tfy_isPlaceholder { return }

        if let del = delegate as? TFYSwiftTabBarControllerDelegate {
            del.tabBarController?(self, didSelectControl: tabBarItem.tabBarButton ?? UIControl())
        }
        if let del = delegate, del.responds(to: #selector(UITabBarControllerDelegate.tabBarController(_:shouldSelect:))) {
            if del.tabBarController?(self, shouldSelect: didSelect) == false {
                return
            }
        }
        selectedIndex = index
        if let del = delegate, del.responds(to: #selector(UITabBarControllerDelegate.tabBarController(_:didSelect:))) {
            del.tabBarController?(self, didSelect: didSelect)
        }
    }

    // MARK: - Private helpers

    private var flatDesignTabBar: TFYSwiftFlatDesignTabBar? {
        _cylTabBar as? TFYSwiftFlatDesignTabBar
    }

    private var tabBarIsAnimating: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.tabBarIsAnimating) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.tabBarIsAnimating, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var lastShowHideTabBar: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.lastShowHideTabBar) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.lastShowHideTabBar, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var needsReloadItems: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.needsReloadItems) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.needsReloadItems, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var delegateWillShow: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.willShow) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.willShow, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var delegateDidShow: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.didShow) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.didShow, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var delegateWillHide: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.willHide) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.willHide, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var delegateDidHide: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.didHide) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.didHide, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func tfy_flatTabBarFrame() -> CGRect {
        let height = tabBarHeight + view.safeAreaInsets.bottom
        return CGRect(x: 0, y: view.bounds.height - height, width: view.bounds.width, height: height)
    }

    /// Keep UIKit's tab chrome hidden. iOS 26 still draws `_UITabContainerView`
    /// even after KVC-replacing `tabBar` with `TFYSwiftFlatDesignTabBarHideTabBar`.
    private func hideSystemTabBarChrome(animated: Bool) {
        if #available(iOS 18.0, *) {
            super.setTabBarHidden(true, animated: animated)
        }
        tabBar.isHidden = true
        hideSystemTabContainerViews()
    }

    private func hideSystemTabContainerViews() {
        for subview in view.subviews {
            let name = NSStringFromClass(type(of: subview))
            if name == "_UITabContainerView" || (name.hasPrefix("_UITab") && name.contains("Container")) {
                subview.isHidden = true
            }
        }
    }

    private func setupFlatDesignChild(_ viewController: UIViewController, idx: Int) {
        var title: String?
        var normalImageInfo: Any?
        var selectedImageInfo: Any?
        var titleAdj = UIOffset.zero
        var imageAdj = UIOffset.zero
        var insets = UIEdgeInsets.zero
        var lottieFilePath: String?
        var lottieSizeValue: NSValue?

        if viewController !== TFYSwiftPlusChildViewController, tabBarItemsAttributes.count > idx {
            let attrs = tabBarItemsAttributes[idx]
            if #available(iOS 13.0, *) {
                title = (attrs[TFYSwiftTabBarItemTitle] as? String) ?? ""
            } else {
                title = attrs[TFYSwiftTabBarItemTitle] as? String
            }
            normalImageInfo = attrs[TFYSwiftTabBarItemImage]
            selectedImageInfo = attrs[TFYSwiftTabBarItemSelectedImage]
            lottieFilePath = attrs[TFYSwiftTabBarLottieFilePath] as? String
            lottieSizeValue = attrs[TFYSwiftTabBarLottieSize] as? NSValue
            if let offsetValue = attrs[TFYSwiftTabBarItemTitlePositionAdjustment] as? NSValue {
                titleAdj = offsetValue.uiOffsetValue
            }
            if let imageOffsetValue = attrs[TFYSwiftTabBarItemImagePositionAdjustment] as? NSValue {
                imageAdj = imageOffsetValue.uiOffsetValue
            }
            if let insetsValue = attrs[TFYSwiftTabBarItemImageInsets] as? NSValue {
                insets = insetsValue.uiEdgeInsetsValue
            }
        } else {
            title = ""
        }

        var resolvedInsets = UIEdgeInsets.zero
        if insets != .zero { resolvedInsets = insets }
        var resolvedTitle = UIOffset.zero
        if titleAdj != .zero { resolvedTitle = titleAdj }
        var resolvedImage = UIOffset.zero
        if imageAdj != .zero { resolvedImage = imageAdj }

        let normalImage = UIImage.tfy_imageNamed(normalImageInfo)
        let selectedImage = UIImage.tfy_imageNamed(selectedImageInfo)
        let trueLottieSize = TFYSwiftConstants.tfy_getTrueLottieSizeValue(lottieSizeValue, fromNormalImage: normalImage)
        if let url = TFYSwiftConstants.tfy_getURL(from: lottieFilePath) {
            lottieURLs.add(url)
            lottieSizes.add(trueLottieSize)
        }

        let item = TFYSwiftFlatDesignTabBarItem(
            title: title ?? "",
            image: normalImage as Any?,
            selectedImage: selectedImage as Any?,
            index: idx,
            titlePositionAdjustment: resolvedTitle,
            imagePositionAdjustment: resolvedImage,
            imageInsets: resolvedInsets,
            lottieFilePath: lottieFilePath,
            lottieSizeValue: trueLottieSize
        )
        item.tfyflatdesign_tabBarController = self
        item.childViewController = viewController
        item.setTitleTextAttributes([.foregroundColor: UIColor.systemYellow], for: .selected)
        viewController.tfy_tabBarItem = item
    }

    private func captureFlatDesignItems() {
        let items = NSMutableArray()
        for (i, viewController) in (viewControllers ?? []).enumerated() {
            let item = viewController.tfy_tabBarItem
            viewController.tfyflatdesign_tabBarController = self
            item.index = UInt(i)
            items.add(item)
            viewController.tfy_tabButton = item.tabBarButton
        }
        syncSystemItems()
        flatDesignItems.removeAllObjects()
        flatDesignItems.addObjects(from: items as! [Any])
    }

    private func syncSystemItems() {
        for viewController in viewControllers ?? [] {
            let item = viewController.tfy_tabBarItem
            viewController.tabBarItem.title = item.title
            viewController.tabBarItem.image = item.image
            viewController.tabBarItem.titlePositionAdjustment = item.titlePositionAdjustment
            if let normal = item.titleTextAttributes(for: .normal) {
                viewController.tabBarItem.setTitleTextAttributes(normal, for: .normal)
            }
            if let selected = item.titleTextAttributes(for: .selected) {
                viewController.tabBarItem.setTitleTextAttributes(selected, for: .selected)
            }
        }
    }

    private func tabChangedToFlatDesignSelectedIndex(
        _ selectedIndex: Int,
        viewController: UIViewController?,
        selectedItem: TFYSwiftFlatDesignTabBarItem?
    ) {
        guard flatDesignTabBar != nil, flatDesignItems.count > 0 else { return }
        var item = selectedItem
        if item == nil, selectedIndex >= 0, selectedIndex < flatDesignItems.count {
            item = flatDesignItems[selectedIndex] as? TFYSwiftFlatDesignTabBarItem
        }
        flatDesignTabBar?.selectedItem = item
    }

    private func checkHidesBottomBarWhenPushed() -> Bool {
        let selected = selectedViewController
        if let nav = selected as? UINavigationController {
            var showsBottomBarIndex = -1
            for (index, vc) in nav.viewControllers.enumerated() {
                if vc.hidesBottomBarWhenPushed || vc.tfy_hidesBottomBarWhenPushed {
                    showsBottomBarIndex = index - 1
                    break
                }
                showsBottomBarIndex = index
            }
            let currentIndex = nav.viewControllers.firstIndex(of: nav.topViewController ?? nav) ?? 0
            return currentIndex <= showsBottomBarIndex
        }
        return !(selected?.hidesBottomBarWhenPushed ?? false)
    }

    private func shouldShowsBottomBar() -> Bool {
        if tfy_flatTabBarHidden { return false }
        return checkHidesBottomBarWhenPushed()
    }

    func updateBottomBarShowHideIfNeeded() {
        guard let flatBar = flatDesignTabBar else { return }
        let shows = shouldShowsBottomBar()
        if !tabBarIsAnimating {
            flatBar.isHidden = !shows
        }
        updateAdditionalSafeAreaInsets(animated: false)
    }

    func updateAdditionalSafeAreaInsets(animated: Bool) {
        guard let flatBar = flatDesignTabBar else { return }
        let barHidden = flatBar.isHidden || tfy_flatTabBarHidden
        let bottom = barHidden ? 0 : tabBarHeight + view.safeAreaInsets.bottom
        var controllers = viewControllers ?? []
        if tfy_showsMoreNavigationController() {
            controllers.append(moreNavigationController)
        }
        guard controllers.contains(where: { abs($0.additionalSafeAreaInsets.bottom - bottom) > 0.5 }) else { return }
        let apply = {
            for vc in controllers {
                var insets = vc.additionalSafeAreaInsets
                insets.bottom = bottom
                vc.additionalSafeAreaInsets = insets
            }
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: apply)
        } else {
            apply()
        }
    }

    func tfy_showsMoreNavigationController() -> Bool {
        guard tabBarStyleType == .flatDesign, _cylTabBar is TFYSwiftFlatDesignTabBar else { return false }
        return (viewControllers?.count ?? 0) > 5
            || (tabBar.items?.contains(where: { $0 === moreNavigationController.tabBarItem }) ?? false)
    }

    private func tfy_applySelectedAdditionalSafeAreaInsets(bottom: CGFloat) {
        guard let selected = selectedViewController else { return }
        var insets = selected.additionalSafeAreaInsets
        insets.bottom = bottom
        UIView.performWithoutAnimation {
            selected.additionalSafeAreaInsets = insets
            if tfy_showsMoreNavigationController(), moreNavigationController !== selected {
                moreNavigationController.additionalSafeAreaInsets = insets
            }
        }
    }

    private var parallaxOverlayView: TFYSwiftFlatDesignTabBarParallaxOverlayView? {
        get { objc_getAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.parallaxOverlay) as? TFYSwiftFlatDesignTabBarParallaxOverlayView }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignControllerKeys.parallaxOverlay, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private func tfy_addParallaxOverlayView(to viewController: UIViewController) {
        guard tabBarStyleType == .flatDesign, let flatBar = flatDesignTabBar else { return }
        let superview = viewController.view
        let overlay = parallaxOverlayView ?? TFYSwiftFlatDesignTabBarParallaxOverlayView(frame: superview?.bounds ?? .zero)
        parallaxOverlayView = overlay
        if let superview {
            superview.addSubview(overlay)
            superview.bringSubviewToFront(overlay)
        }
        if flatBar.superview !== overlay {
            if !tabBarIsAnimating {
                flatBar.frame = tfy_flatTabBarFrame()
            }
            flatBar.isHidden = false
            overlay.addSubview(flatBar)
        }
    }

    private func notifyWillShowHide(hidden: Bool, tabBar: TFYSwiftFlatDesignTabBar) {
        let del = delegate as? TFYSwiftFlatDesignUITabBarControllerDelegate
        if hidden {
            del?.tabBarController?(self, willHideTabBar: tabBar)
        } else {
            del?.tabBarController?(self, willShowTabBar: tabBar)
        }
    }

    private func notifyDidShowHide(hidden: Bool, tabBar: TFYSwiftFlatDesignTabBar) {
        let del = delegate as? TFYSwiftFlatDesignUITabBarControllerDelegate
        if hidden {
            del?.tabBarController?(self, didHideTabBar: tabBar)
        } else {
            del?.tabBarController?(self, didShowTabBar: tabBar)
        }
    }
}

// MARK: - FlatDesignTabBarDelegate

extension TFYSwiftTabBarController: TFYSwiftFlatDesignTabBarDelegate {
    public func tabBar(_ tabBar: TFYSwiftFlatDesignTabBar, didSelect item: TFYSwiftFlatDesignTabBarItem) {
        tfy_tabBarItemClicked(item)
    }
}

// MARK: - Navigation parallax (OC UINavigationControllerExtensionDelegate)

extension TFYSwiftTabBarController: TFYSwiftNavigationControllerExtensionDelegate {

    public func tfyflatdesign_navigationController(
        _ navigationController: UINavigationController,
        navigationBarDidChangeHeight height: CGFloat
    ) {}

    public func tfyflatdesign_navigationController(
        _ navigationController: UINavigationController,
        didBeginTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController,
        operation: UINavigationController.Operation
    ) {
        guard tabBarStyleType == .flatDesign, _cylTabBar is TFYSwiftFlatDesignTabBar else { return }
        view.isUserInteractionEnabled = false
        tfy_applySelectedAdditionalSafeAreaInsets(bottom: tabBarHeight + view.safeAreaInsets.bottom)
    }

    public func tfyflatdesign_navigationController(
        _ navigationController: UINavigationController,
        didUpdateInteractiveFrom fromVC: UIViewController,
        to toVC: UIViewController,
        percentComplete: CGFloat
    ) {}

    public func tfyflatdesign_navigationController(
        _ navigationController: UINavigationController,
        didUpdateInteractiveFrom fromVC: UIViewController,
        to toVC: UIViewController,
        popGestureRecognizer: UIGestureRecognizer
    ) {}

    public func tfyflatdesign_navigationController(
        _ navigationController: UINavigationController,
        willEndTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController,
        operation: UINavigationController.Operation,
        cancelled: Bool
    ) {
        guard tabBarStyleType == .flatDesign, let flatBar = flatDesignTabBar else { return }
        let showsTabBar = shouldShowsBottomBar()
        if operation == .push {
            if !showsTabBar, !flatBar.isHidden {
                tfy_addParallaxOverlayView(to: fromVC)
            }
        } else if showsTabBar, flatBar.isHidden {
            tfy_addParallaxOverlayView(to: toVC)
        }
        tfy_applySelectedAdditionalSafeAreaInsets(bottom: showsTabBar ? tabBarHeight + view.safeAreaInsets.bottom : 0)
    }

    public func tfyflatdesign_navigationController(
        _ navigationController: UINavigationController,
        didEndTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController,
        operation: UINavigationController.Operation,
        cancelled: Bool
    ) {
        guard tabBarStyleType == .flatDesign, let flatBar = flatDesignTabBar else { return }
        view.isUserInteractionEnabled = true
        if let overlay = parallaxOverlayView {
            overlay.removeFromSuperview()
            parallaxOverlayView = nil
        }
        if flatBar.superview !== view {
            flatBar.frame = tfy_flatTabBarFrame()
            view.addSubview(flatBar)
        }
        updateBottomBarShowHideIfNeeded()
    }
}
