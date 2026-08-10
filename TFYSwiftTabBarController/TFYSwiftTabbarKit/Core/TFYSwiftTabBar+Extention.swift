//
//  TFYSwiftTabBar+Extention.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLTabBar+CYLTabBarControllerExtention.h/.m
//  UITabBar platter/bounds APIs complement UIView+TFYSwiftTabBar; TFYSwiftTabBar adds selection/Lottie.
//

import UIKit
import ObjectiveC

#if canImport(Lottie)
import Lottie
#endif

// MARK: - UITabBar (platter / bounds — not duplicated in UIView+TFYSwiftTabBar)

public extension UITabBar {

    @objc var tfy_portalView: UIView? {
        get { objc_getAssociatedObject(self, &TFYSwiftTabBarExtKeys.portalView) as? UIView }
        set { objc_setAssociatedObject(self, &TFYSwiftTabBarExtKeys.portalView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc func tfy_setPortalView(_ portalView: UIView?) { tfy_portalView = portalView }

    @objc var tfy_platterViewWidth: CGFloat {
        get { (objc_getAssociatedObject(self, &TFYSwiftTabBarExtKeys.platterViewWidth) as? NSNumber)?.doubleValue ?? 0 }
        set { objc_setAssociatedObject(self, &TFYSwiftTabBarExtKeys.platterViewWidth, NSNumber(value: Double(newValue)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc func tfy_setPlatterViewWidth(_ width: CGFloat) { tfy_platterViewWidth = width }

    @objc var tfy_platterViewSize: NSValue? {
        get { objc_getAssociatedObject(self, &TFYSwiftTabBarExtKeys.platterViewSize) as? NSValue }
        set { objc_setAssociatedObject(self, &TFYSwiftTabBarExtKeys.platterViewSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc func tfy_setPlatterViewSize(_ size: NSValue?) { tfy_platterViewSize = size }

    @objc var tfy_portalLayer: CALayer? {
        get { objc_getAssociatedObject(self, &TFYSwiftTabBarExtKeys.portalLayer) as? CALayer }
        set { objc_setAssociatedObject(self, &TFYSwiftTabBarExtKeys.portalLayer, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    @objc func tfy_setPortalLayer(_ layer: CALayer?) { tfy_portalLayer = layer }

    /// Platter content container for layout (CYLTabBar); not UIView.tfy_contentView().
    @objc var tfy_tabBarContentView: UIView { tfy_platterView ?? self }

    @objc func tfy_fullHeight() -> CGFloat { tfy_getTabBarFullH(tfy_boundsSize().height) }

    @objc func tfy_boundsSize() -> CGSize {
        let size = bounds.size
        if !TFYSwiftConstants.isLiquidGlassActive() {
            return CGSize(width: size.width, height: bounds.height - safeAreaInsets.bottom)
        }
        if tfy_noNeedUIDesignRequiresCompatibilityWithIOS26(tabBarController: tfy_tabBarController) {
            _ = tfy_tabBarSubviews()
            if let stored = tfy_platterViewSize?.cgSizeValue, stored.width > 0 { return stored }
        }
        return size
    }

    @objc func tfy_boundsWidthOffset() -> CGFloat {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return 0 }
        return (tfy_screenWidth() - tfy_boundsSize().width) * 0.5
    }

    @objc func tfy_platterLiquidLensView() -> UIView? {
        tfy_platterView?.subviews.first { $0.tfy_isPlatterLiquidLensView() }
    }

    @objc func tfy_platterLiquidLensViewContentView() -> UIView? {
        let selector = NSSelectorFromString("sourceView")
        if let portal = tfy_portalView,
           portal.responds(to: selector),
           let source = portal.perform(selector)?.takeUnretainedValue() as? UIView {
            return source
        }
        guard let lens = tfy_platterLiquidLensView() else { return nil }
        return lens.subviews.first
    }

    @objc func tfy_platterLiquidLensViewSubViews() -> [UIView]? {
        tfy_platterLiquidLensViewContentView()?.subviews
    }

    @objc func tfy_platterLiquidLensClearGlassView() -> UIView? {
        tfy_platterLiquidLensViewSubViews()?.first { $0.tfy_isPlatterLiquidLensClearGlassView() }
    }

    @objc func tfy_platterDestOutView() -> UIView? {
        tfy_platterView?.subviews.first { $0.tfy_isPlatterDestOutView() }
    }

    @objc func tfy_platterVisualProviderFloatingSelectedContentView() -> UIView? {
        tfy_platterView?.subviews.first { $0.tfy_isPlatterVisualProviderFloatingSelectedContentView() }
    }

    @objc func tfy_platterSelectedContentViewsWithoutPlusButton() -> [UIControl] {
        tfy_platterSelectedContentViews().filter { !$0.tfy_isPlusControl() }
    }

    @objc func tfy_platterSelectedContentViewWithoutPlusButtton(withIndex index: Int) -> UIControl? {
        let views = tfy_platterSelectedContentViewsWithoutPlusButton()
        guard index >= 0, index < views.count else { return nil }
        return views[index]
    }

    @objc func tfy_allTabViews(from contentView: UIView?) -> [UIControl]? {
        guard let contentView else { return nil }
        var itemViews = contentView.subviews.compactMap { $0 as? UIControl }
        itemViews.sort { $0.frame.minX < $1.frame.minX }
        return itemViews
    }

    @objc func tfy_subTabBarButtonsWithoutPlusButton() -> [UIControl] {
        tfy_visibleControls().filter { !$0.tfy_isPlusControl() }
    }

    @objc func tfy_tabBarButton(withTabIndex tabIndex: UInt) -> UIControl? {
        let plusIndex = TFYSwiftPlusChildViewController.flatMap {
            tfy_tabBarController?.viewControllers?.firstIndex(of: $0)
        } ?? NSNotFound
        let isPlusAdded = (TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded ?? false) && plusIndex != NSNotFound
        if isPlusAdded { return tfy_visibleControl(withIndex: tabIndex) }
        let withoutPlus = tfy_subTabBarButtonsWithoutPlusButton()
        guard tabIndex < withoutPlus.count else { return tfy_visibleControl(withIndex: tabIndex) }
        return withoutPlus[Int(tabIndex)]
    }

    @objc func tfy_visibleControl(withIndex index: UInt) -> UIControl? {
        let controls = tfy_visibleControls()
        guard index < controls.count else { return nil }
        return controls[Int(index)]
    }

    @objc func tfy_platterContentView(withIndex index: Int) -> UIControl? {
        let views = tfy_platterContentViews()
        guard index >= 0, index < views.count else { return nil }
        return views[index]
    }
}

// MARK: - TFYSwiftTabBar

public extension TFYSwiftTabBar {

    @objc var tfy_selectedControl: UIControl? {
        get {
            if let stored = objc_getAssociatedObject(self, &TFYSwiftTabBarExtKeys.selectedControl) as? UIControl {
                return stored
            }
            return tfy_platterSelectedContentViews().first
                ?? tfy_platterContentViews().first
                ?? tfy_visibleControls().first
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftTabBarExtKeys.selectedControl, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func tfy_setSelectedControl(_ control: UIControl?) { tfy_selectedControl = control }

    @objc func tfy_selectedIndex() -> Int { tfy_selectedControl?.tfy_tabBarItemVisibleIndex ?? 0 }

    @objc func tfy_originalTabBarButtons() -> [UIControl] {
        tfy_tabBarButton(fromTabBarSubviews: tfy_sortedSubviewsForCYL())
    }

    @objc func tfy_sortedSubviewsForCYL() -> [UIView] {
        let subs = tfy_tabBarSubviews()
        guard !subs.isEmpty else { return [] }
        return subs.filter { $0.tfy_isTabButton() }.sorted { $0.frame.minX < $1.frame.minX }
    }

    @objc func tfy_tabBarButton(fromTabBarSubviews tabBarSubviews: [UIView]) -> [UIControl] {
        guard !tabBarSubviews.isEmpty else { return [] }
        var result: [UIControl] = []
        for (idx, obj) in tabBarSubviews.enumerated() {
            guard let control = obj as? UIControl, control.tfy_isTabButton() else { continue }
            control.tfy_tabBarChildViewControllerIndex = idx
            result.append(control)
        }
        return result
    }

    @objc func tfy_cachedXOffset(withIndex index: CGFloat) -> CGFloat {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return 0 }
        let boundsWidthOffset = (tfy_boundsSize().width - tfy_screenWidth()) * 0.5
        return index < CGFloat(plusButtonIndex()) ? boundsWidthOffset : abs(boundsWidthOffset)
    }

    @objc func tfy_cachedWidthOffset(withIndex index: CGFloat) -> CGFloat {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return 0 }
        guard tabBarItemsCount > 0 else { return 0 }
        let originalWidth = tfy_boundsSize().width / CGFloat(tabBarItemsCount)
        return abs(originalWidth - tabBarItemWidth)
    }

    @objc func tfy_animationLottieImage(
        withSelectedControl selectedControl: UIControl,
        lottieURL: URL?,
        size: CGSize,
        defaultSelected: Bool,
        contentMode: UIView.ContentMode
    ) {
        #if canImport(Lottie)
        guard let lottieURL else { return }
        selectedControl.tfy_animationLottieImage(
            withLottieURL: lottieURL,
            size: size,
            defaultSelected: defaultSelected,
            contentMode: contentMode
        )
        #else
        _ = (selectedControl, lottieURL, size, defaultSelected, contentMode)
        #endif
    }

    @objc func tfy_stopAnimationOfAllLottieView() {
        #if canImport(Lottie)
        tfy_visibleControls().forEach { $0.tfy_stopAnimationOfLottieView() }
        tfy_platterSelectedContentViews().forEach { $0.tfy_stopAnimationOfLottieView() }
        #endif
    }

    @objc func tfy_shouldUpdateHiddenStatueForPlusButtonLabel() -> Bool {
        tfy_shouldUpdateHiddenStatueForPlusButtonLabel(for: tabBarController())
    }

    @objc func tfy_shouldUpdateHiddenStatueForPlusButtonLabel(for tabBarController: TFYSwiftTabBarController?) -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let controller = tabBarController ?? self.tabBarController()
        let tabBar = (controller?.tabBar as? TFYSwiftTabBar) ?? self
        guard tabBar.hasPlusChildViewController(), tabBar.hasPlusButton() else { return false }
        guard let label = TFYSwiftExternPlusButton?.tfy_tabLabel(), !(label.text?.isEmpty ?? true) else { return false }
        var shouldShow = false
        if let delegate = controller?.delegate as? TFYSwiftTabBarControllerDelegate,
           let plus = TFYSwiftExternPlusButton, let controller {
            shouldShow = delegate.tabBarController?(controller, shouldShowPlatterLiquidLensViewForControl: plus) ?? false
        }
        return shouldShow && !tabBar.isPlusButtonLayoutCentered()
    }
}

// MARK: - Keys / helpers

private enum TFYSwiftTabBarExtKeys {
    static var portalView: UInt8 = 0
    static var platterViewWidth: UInt8 = 0
    static var platterViewSize: UInt8 = 0
    static var portalLayer: UInt8 = 0
    static var selectedControl: UInt8 = 0
}

func tfy_uidesignOldVersionTabBarWithoutiOS26() -> Bool {
    !tfy_isIOS26 && !TFYSwiftConstants.isUsedLiquidGlass()
}

func tfy_noNeedUIDesignRequiresCompatibilityWithIOS26(tabBarController: TFYSwiftTabBarController?) -> Bool {
    tfy_isIOS26 && (tabBarController?.noNeedUIDesignCompatibility ?? false)
}

private extension UITabBar {
    func tfy_platterContentViews() -> [UIControl] { tfy_tabBarSubviews() }
}
