//
//  UIView+TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from UIView+CYLTabBarControllerExtention
//

import ObjectiveC
import UIKit

public extension UIView {

    // MARK: - Tab / Plus identification

    @objc func tfy_isPlusButton() -> Bool {
        self is TFYSwiftPlusButton
    }

    @objc func tfy_isTabButton() -> Bool {
        let classString = NSStringFromClass(type(of: self))
        if classString.hasSuffix("BarButton"), classString.hasPrefix("UITab") {
            return true
        }

        if !TFYSwiftConstants.isLiquidGlassActive() {
            return (classString.hasSuffix("BarButton") && classString.hasPrefix("UITab")) || tfy_isKindOfClass(UIControl.self)
        }

        if tfy_noNeedUIDesignRequiresCompatibilityWithIOS26 {
            return self is UIControl
        }
        return self is UIControl
    }

    private var tfy_noNeedUIDesignRequiresCompatibilityWithIOS26: Bool {
        tfy_isIOS26 && (tfy_tabBarController?.noNeedUIDesignCompatibility ?? false)
    }

    // MARK: - Platter / Liquid Glass

    @objc func tfy_isPlatterView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        return classString.hasSuffix("PlatterView") && classString.hasPrefix("UIKit")
    }

    @objc func tfy_isPlatterPortalView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        return tfy_isViewPortalView(self)
    }

    @objc func tfy_isViewPortalView(_ view: UIView) -> Bool {
        struct Holder {
            static let portalViewClass: AnyClass? = NSClassFromString(TFYSwiftPrivateUIKitClassNames.portalView)
        }
        guard let portalViewClass = Holder.portalViewClass else { return false }
        return view.isKind(of: portalViewClass)
    }

    @objc func tfy_isPlatterContentView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        let isContent = classString.contains("ContentView") && !classString.contains("Selected")
        return isContent && !isHidden
    }

    @objc func tfy_isPlatterSelectedContentView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        return classString.hasSuffix("SelectedContentView") && !isHidden
    }

    @objc func tfy_isPlatterVisualProviderFloatingSelectedContentView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        let match = classString.hasPrefix("_UITab")
            && classString.contains("VisualProvider")
            && classString.contains("_Floating")
            && classString.contains("SelectedContentView")
        return match && !isHidden
    }

    @objc func tfy_isPlatterLiquidLensView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        let match = classString.hasPrefix("_UI")
            && classString.contains("LiquidLens")
            && classString.contains("View")
            && !classString.contains("DestOutView")
            && !classString.contains("BackdropView")
        return match && !isHidden
    }

    @objc func tfy_isPlatterLiquidLensClearGlassView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        let match = classString.hasPrefix("_UI")
            && classString.contains("LiquidLens")
            && classString.hasSuffix("ClearGlassView")
        return match && !isHidden
    }

    @objc func tfy_isPlatterLiquidLensTabSelectionView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        return classString.hasPrefix("_UITab") && classString.hasSuffix("SelectionView") && !isHidden
    }

    @objc func tfy_isPlatterLiquidLensBackdropView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        let match = classString.hasPrefix("_UI")
            && classString.contains("LiquidLens")
            && classString.hasSuffix("BackdropView")
        return match && !isHidden
    }

    @objc func tfy_isPlatterDestOutView() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        let classString = NSStringFromClass(type(of: self))
        let match = classString.hasPrefix("_UI")
            && classString.contains("LiquidLens")
            && classString.contains("View")
            && classString.contains("DestOutView")
        return match && !isHidden
    }

    // MARK: - Tab subview typing

    @objc func tfy_isTabImageView() -> Bool {
        guard tfy_isKindOfClass(UIImageView.self) else { return false }
        let subString = "Indi" + "cat" + "orVi"
        let isBackgroundImage = tfy_classStringHasSuffix(subString)
        return !isBackgroundImage
    }

    @objc func tfy_isTabLabel() -> Bool {
        if !TFYSwiftConstants.isLiquidGlassActive() {
            return tfy_isKindOfClass(UILabel.self)
        }
        let classString = NSStringFromClass(type(of: self))
        if classString.hasSuffix("Label"), classString.contains("TabButton"), classString.contains("_UI") {
            return true
        }
        return self is UILabel
    }

    @objc func tfy_isButtonLabel() -> Bool {
        let classString = NSStringFromClass(type(of: self))
        return classString.hasSuffix("Label") && classString.hasPrefix("UIButton")
    }

    @objc func tfy_isTabBadgeView() -> Bool {
        guard tfy_isUIViewSubclassNotExactUIView() else { return false }
        let prefix = "_U" + "IB" + "adg"
        return tfy_classStringHasPrefix(prefix)
    }

    @objc func tfy_isTabBackgroundView() -> Bool {
        guard tfy_isUIViewSubclassNotExactUIView() else { return false }
        let prefix = "_U" + "IB" + "arBac"
        return tfy_classStringHasPrefix(prefix) && tfy_classStringHasSuffix("nd")
    }

    @objc func tfy_imageView() -> UIImageView? {
        for case let subview as UIImageView in subviews {
            return subview
        }
        return nil
    }

    @objc func tfy_tabImageView() -> UIImageView? {
        var imageView: UIImageView?
        for subview in tfy_allSubviews() {
            if let iv = subview as? UIImageView, iv.tfy_isTabImageView() {
                imageView = iv
                break
            }
        }
        if imageView == nil, let iv = tfy_imageViewInTabBarButton() {
            imageView = iv
        }
        return imageView
    }

    @objc func tfy_swappableImageViewViewInTabBarButton() -> UIImageView? {
        for subview in subviews {
            let classString = NSStringFromClass(type(of: subview))
            if classString.hasSuffix("ImageView"), classString.hasPrefix("UITabB") {
                return subview as? UIImageView
            }
        }
        return nil
    }

    @objc func tfy_otherImageViewViewInTabBarButton() -> UIImageView? {
        var imageView: UIImageView?
        for subview in subviews {
            let classString = NSStringFromClass(type(of: subview))
            if classString.hasSuffix("ImageView"), classString.hasPrefix("UITabB") {
                return subview as? UIImageView
            }
            if let iv = subview as? UIImageView, !classString.contains("SelectionIndicatorView") {
                imageView = iv
            }
        }
        return imageView
    }

    @objc func tfy_imageViewInTabBarButton() -> UIImageView? {
        // Do not KVC `imageView`. iOS 26 `_UITabButton` / `_UIButtonBarButton`
        // throw NSUnknownKeyException; Swift cannot catch NSException.
        // `NSStringFromClass` may be module-qualified (`UIKit._UITabButton`),
        // so a leading-`_` check on the full string is not enough.
        let lastComponent = NSStringFromClass(type(of: self))
            .split(separator: ".")
            .last
            .map(String.init) ?? ""
        if !lastComponent.hasPrefix("_"),
           let button = self as? UIButton,
           let imageView = button.imageView {
            return imageView
        }

        if let imageView = tfy_firstImageViewAmongTabButtonViews(subviews) {
            return imageView
        }
        return tfy_firstImageViewAmongTabButtonViews(Array(tfy_allSubviews().dropFirst()))
    }

    /// OC `cyl_imageViewInTabBarButton` subview walk. Liquid-glass tab buttons nest the icon.
    private func tfy_firstImageViewAmongTabButtonViews(_ views: [UIView]) -> UIImageView? {
        var imageView: UIImageView?
        for subview in views {
            let classString = NSStringFromClass(type(of: subview))
            if classString.hasPrefix("UITabBar"), classString.hasSuffix("SwappableImageView") {
                return subview as? UIImageView
            }
            if let iv = subview as? UIImageView,
               !classString.hasSuffix("SelectionIndicatorView"),
               !classString.hasPrefix("UITabBar") {
                imageView = iv
            }
        }
        return imageView
    }

    @objc func tfy_allSubviews() -> [UIView] {
        var all: [UIView] = [self]
        for subview in subviews {
            all.append(contentsOf: subview.tfy_allSubviews())
        }
        return all
    }

    @objc func tfy_tabBadgeView() -> UIView? {
        for subview in tfy_allSubviews() where subview.tfy_isTabBadgeView() {
            return subview
        }
        return nil
    }

    @objc func tfy_tabLabel() -> UILabel? {
        for subview in tfy_allSubviews() {
            if let label = subview as? UILabel, label.tfy_isTabLabel() {
                return label
            }
        }
        return nil
    }

    @objc func tfy_isTabEffectView() -> Bool {
        type(of: self) == UIVisualEffectView.self
    }

    @objc func tfy_isTabEffectContentView() -> Bool {
        guard tfy_isUIViewSubclassNotExactUIView() else { return false }
        let prefix = "_U" + "IVisualE" + "ffectC"
        return tfy_classStringHasPrefix(prefix) && tfy_classStringHasSuffix("entView")
    }

    @objc func tfy_tabEffectView() -> UIVisualEffectView? {
        for subview in subviews where subview.tfy_isTabEffectView() {
            return subview as? UIVisualEffectView
        }
        return nil
    }

    @objc func tfy_tabShadowImageView() -> UIImageView? {
        if #available(iOS 10.0, *) {
            guard let subview = tfy_tabBackgroundView() else { return nil }
            for child in subview.subviews where child.bounds.height <= 1.0 {
                return child as? UIImageView
            }
        } else {
            for subview in subviews where subview.bounds.height <= 1.0 {
                return subview as? UIImageView
            }
        }
        return nil
    }

    @objc func tfy_tabBackgroundView() -> UIView? {
        for subview in subviews where subview.tfy_isTabBackgroundView() {
            return subview
        }
        return nil
    }

    @objc func tfy_isLottieAnimationView() -> Bool {
        // OC: isKindOfClass:[UIView] && !isMemberOfClass:[UIView]
        guard tfy_isUIViewSubclassNotExactUIView() else { return false }

        if let lotClass = NSClassFromString("LOTAnimationView"), isKind(of: lotClass) {
            return true
        }

        let className = NSStringFromClass(type(of: self))
        let swiftCompatClassStringCandidates = [
            "TFYSwiftCompatibleLOTAnimationView",
            "CYLCompatibleLOTAnimationView"
        ]
        return swiftCompatClassStringCandidates.contains(where: { className.contains($0) })
    }

    @objc func tfy_addPlatterViewThenBringSubviewToFront(_ view: UIView) {
        if let tabBar = tfy_tabBarController?.tabBar, tabBar.tfy_platterContentView != nil {
            tabBar.tfy_platterView?.addSubview(view)
        } else {
            addSubview(view)
        }
        tfy_bringSubviewToFront(view)
    }

    @objc func tfy_isViewAddedToPlatterView(_ view: UIView) -> Bool {
        if let contentView = tfy_tabBarController?.tabBar.tfy_platterContentView {
            return view.superview === contentView
        }
        return view.superview === self
    }

    @objc func tfy_bringSubviewToFront(_ view: UIView) {
        if let platterView = tfy_tabBarController?.tabBar.tfy_platterView {
            insertSubview(view, belowSubview: platterView)
        } else {
            tfy_bringSubviewToTop(view)
        }
    }

    @objc func tfy_bringSubviewToTop(_ view: UIView) {
        addSubview(view)
        bringSubviewToFront(view)
        view.layer.zPosition = TFYSwiftLayerFrontZPosition
    }

    @objc func tfy_setHidden(_ hidden: Bool) {
        if hidden {
            isOpaque = false
            self.isHidden = true
            alpha = 0
            isUserInteractionEnabled = false
            tfy_isPlaceholder = false
        } else {
            isOpaque = true
            self.isHidden = false
            alpha = 1
            isUserInteractionEnabled = true
            tfy_isPlaceholder = true
        }
    }

    @objc func tfy_takeSnapshot() -> UIImage? {
        guard let platterView = tfy_tabBarController?.tabBar.tfy_platterView else { return nil }
        return tfy_takeSnapshotWithoutViews([platterView])
    }

    @objc func tfy_takeSnapshotWithoutViews(_ hideViews: [UIView]) -> UIImage? {
        hideViews.forEach { $0.tfy_setHidden(true) }

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        hideViews.forEach { $0.tfy_setHidden(false) }
        return image
    }

    @objc func tfy_resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage? {
        let newRect = CGRect(origin: .zero, size: newSize).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext(), let imageRef = image.cgImage else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.interpolationQuality = .high
        context.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height))
        context.draw(imageRef, in: newRect)
        let newImageRef = context.makeImage()
        UIGraphicsEndImageContext()
        guard let newImageRef else { return nil }
        return UIImage(cgImage: newImageRef)
    }

    // MARK: - Deprecated helpers

    @objc func tfy_tabBadgeBackgroundView() -> UIView? {
        tfy_tabBackgroundView()
    }

    @objc func tfy_tabBadgeBackgroundSeparator() -> UIImageView? {
        tfy_tabShadowImageView()
    }

    @objc class func tfy_tabBadgePointView(withClolor color: UIColor, radius: CGFloat) -> UIView {
        let pointView = UIView()
        pointView.translatesAutoresizingMaskIntoConstraints = false
        pointView.backgroundColor = color
        pointView.layer.cornerRadius = radius
        pointView.layer.masksToBounds = true
        pointView.isHidden = true
        pointView.addConstraint(NSLayoutConstraint(item: pointView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: radius * 2))
        pointView.addConstraint(NSLayoutConstraint(item: pointView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: radius * 2))
        return pointView
    }

    // MARK: - Internal helpers

    /// OC `isKindOfClass:[UIView] && !isMemberOfClass:[UIView]`.
    /// Private UIKit views (`_UIBarBackground`, `_UIBadgeView`, Lottie views) are subclasses, not exact `UIView`.
    @objc func tfy_isUIViewSubclassNotExactUIView() -> Bool {
        isKind(of: UIView.self) && type(of: self) != UIView.self
    }

    @objc func tfy_isKindOfClass(_ aClass: AnyClass) -> Bool {
        guard isKind(of: aClass), type(of: self) != aClass else { return false }
        return tfy_isTabBarClass()
    }

    @objc func tfy_isTabBarClass() -> Bool {
        tfy_classStringHasPrefix("UI" + "T" + "abBar")
    }

    @objc func tfy_classStringHasPrefix(_ prefix: String) -> Bool {
        NSStringFromClass(type(of: self)).hasPrefix(prefix)
    }

    @objc func tfy_classStringHasSuffix(_ suffix: String) -> Bool {
        NSStringFromClass(type(of: self)).hasSuffix(suffix)
    }

    @objc func tfy_contentView() -> UIView? {
        if responds(to: NSSelectorFromString("view")) {
            return tfy_valueForKey("view") as? UIView
        }
        return nil
    }
}

// MARK: - UITabBar platter storage (used by tab extensions)

public extension UITabBar {

    @objc var tfy_platterView: UIView? {
        get { objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.platterView) as? UIView }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.platterView, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    @objc var tfy_platterContentView: UIView? {
        get { objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.platterContentView) as? UIView }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.platterContentView, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    @objc func tfy_hasPlusChildViewController() -> Bool {
        guard let plusChild = TFYSwiftPlusChildViewController else { return false }
        let context = plusChild.tfy_context
        let isSameContext = context == tfy_context && !context.isEmpty && !tfy_context.isEmpty
        let isAdded = tfy_tabBarController?.viewControllers?.contains(plusChild) ?? false
        return plusChild.tfy_plusViewControllerEverAdded && isSameContext && isAdded
    }

    @objc func tfy_subTabBarButtons() -> [UIControl] {
        if TFYSwiftConstants.isLiquidGlassActive() {
            return tfy_tabBarSubviews()
        }
        return tfy_visibleControls().filter { control in
            if control.tfy_isPlusButton(), !(TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded ?? false) {
                return false
            }
            return true
        }
    }

    @objc func tfy_selectedContentControl(fromContentControl contentControl: UIControl) -> UIControl? {
        let buttons = tfy_subTabBarButtons()
        if let index = buttons.firstIndex(where: { $0 === contentControl }) {
            return tfy_platterSelectedContentView(withIndex: index)
        }
        let visibleIndex = contentControl.tfy_tabBarItemVisibleIndex
        if visibleIndex != NSNotFound {
            let selected = tfy_platterSelectedContentViews()
            if visibleIndex < selected.count { return selected[visibleIndex] }
            return tfy_platterSelectedContentView(withIndex: visibleIndex)
        }
        return nil
    }

    @objc func tfy_normalContentControl(fromSelectedContentControl selectedContentControl: UIControl) -> UIControl? {
        guard let index = tfy_platterSelectedContentViews().firstIndex(of: selectedContentControl), index != NSNotFound else {
            return nil
        }
        let buttons = tfy_subTabBarButtons()
        guard index < buttons.count else { return nil }
        return buttons[index]
    }

    @objc func tfy_platterSelectedContentView(withIndex index: Int) -> UIControl? {
        let views = tfy_platterSelectedContentViews()
        guard index >= 0, index < views.count else { return nil }
        return views[index]
    }

    @objc func tfy_platterSelectedContentViews() -> [UIControl] {
        guard let platterView = tfy_platterView else { return [] }
        guard let contentView = platterView.subviews.first(where: { $0.tfy_isPlatterSelectedContentView() }) else {
            return subviews.compactMap { $0 as? UIControl }
        }
        return tfy_allTabControls(from: contentView)
    }

    @objc func tfy_tabBarSubviews() -> [UIControl] {
        if !TFYSwiftConstants.isLiquidGlassActive() {
            return subviews.compactMap { $0 as? UIControl }
        }
        guard let platterView = tfy_platterView, platterView.tfy_isPlatterView() else {
            return subviews.compactMap { $0 as? UIControl }
        }
        guard let contentView = platterView.subviews.first(where: { $0.tfy_isPlatterContentView() }) else {
            return subviews.compactMap { $0 as? UIControl }
        }
        return tfy_allTabControls(from: contentView)
    }

    @objc func tfy_visibleControls() -> [UIControl] {
        var buttons = tfy_originalTabBarButtons()
        if !buttons.contains(where: { ($0 as AnyObject) === (TFYSwiftExternPlusButton as AnyObject?) }) {
            if let plus = TFYSwiftExternPlusButton {
                buttons.append(plus)
            }
        }
        return buttons.sorted { $0.frame.origin.x < $1.frame.origin.x }
    }

    private func tfy_originalTabBarButtons() -> [UIControl] {
        tfy_sortedSubviews().filter { $0.tfy_isTabButton() }
    }

    private func tfy_sortedSubviews() -> [UIControl] {
        let tabButtons = subviews.compactMap { view -> UIControl? in
            guard view.tfy_isTabButton(), let control = view as? UIControl else { return nil }
            return control
        }
        if tabButtons.isEmpty {
            return tfy_tabBarSubviews()
        }
        return tabButtons.sorted { $0.frame.origin.x < $1.frame.origin.x }
    }

    private func tfy_allTabControls(from contentView: UIView) -> [UIControl] {
        var controls: [UIControl] = []
        for subview in contentView.subviews {
            if let control = subview as? UIControl, control.tfy_isTabButton() {
                controls.append(control)
            }
        }
        return controls
    }
}
