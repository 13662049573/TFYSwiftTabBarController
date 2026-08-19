//
//  UIControl+TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from UIControl+CYLTabBarControllerExtention
//

import ObjectiveC
import UIKit

public extension UIControl {

    // MARK: - Associated indexes / flags

    @objc var tfy_shouldNotSelect: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.shouldNotSelect) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.shouldNotSelect, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfy_userInteractionDisabled: Bool {
        get { tfy_shouldNotSelect }
        set { tfy_shouldNotSelect = newValue }
    }

    @objc var tfy_tabBarItemVisibleIndex: Int {
        get {
            guard tfy_isTabButton() || tfy_isPlusButton() else { return NSNotFound }
            return (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBarItemVisibleIndex) as? NSNumber)?.intValue ?? NSNotFound
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBarItemVisibleIndex, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc var tfy_tabBarChildViewControllerIndex: Int {
        get {
            guard tfy_isTabButton() || tfy_isPlusButton() else { return NSNotFound }
            return (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBarChildViewControllerIndex) as? NSNumber)?.intValue ?? NSNotFound
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBarChildViewControllerIndex, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - State

    @objc func tfy_isChildViewControllerPlusButton() -> Bool {
        guard TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded ?? false else { return false }
        if tfy_isPlusButton(), TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded ?? false {
            return true
        }
        if TFYSwiftExternPlusButton?.tfy_tabBarItemVisibleIndex == tfy_tabBarItemVisibleIndex {
            return true
        }
        return false
    }

    @objc func tfy_isLottieReady() -> Bool {
        if let controller = tfy_tabBarController, controller.lottieURLs.count > 0 {
            return controller.isLottieViewAdded
        }
        if let lottieView = tfy_lottieAnimationView(), lottieView.frame.size.width > 10 {
            return true
        }
        return false
    }

    /// OC `cyl_isSelected`. Kept as alias of `tfy_isSelectedTab()`.
    @objc func tfy_isSelected() -> Bool { tfy_isSelectedTab() }

    @objc func tfy_isSelectedTab() -> Bool {
        let tabBarSelectedIndex = tfy_tabBarController?.selectedIndex ?? NSNotFound
        let childIndex = tfy_tabBarChildViewControllerIndex
        var isSelected = tabBarSelectedIndex == childIndex && isSelected
        if tfy_tabBarController?.tabBar.tfy_hasPlusChildViewController() ?? false {
            isSelected = isSelected && (TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded ?? false)
        }
        return isSelected
    }

    @objc func tfy_isPlusControl() -> Bool {
        self is TFYSwiftPlusButton || tfy_isChildViewControllerPlusButton()
    }

    @objc func tfy_lottieAnimationView() -> UIView? {
        if tfy_isPlusControl() { return nil }
        for subview in subviews {
            if subview.tfy_isLottieAnimationView() { return subview }
            for nested in subview.subviews where nested.tfy_isLottieAnimationView() {
                return nested
            }
        }
        return nil
    }

    // MARK: - Replace / cover

    @objc func tfy_replaceTabImageViewWithNewView(_ newView: UIView, show: Bool) {
        tfy_replaceTabImageViewWithNewView(newView, offset: .zero, show: show, completion: { _, _, _ in })
    }

    @objc func tfy_replaceTabImageViewWithNewView(
        _ newView: UIView,
        offset: UIOffset,
        show: Bool,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        tfy_replaceTabImageViewOrTabButton(false, newView: newView, offset: offset, show: show, shouldAutoHideNewView: true, shouldHideOriginalView: true, completion: completion)
    }

    @objc func tfy_replaceTabButtonWithNewView(_ newView: UIView, show: Bool) {
        tfy_replaceTabButtonWithNewView(newView, offset: .zero, show: show) { isReplaced, tabBarButton, _ in
            if isReplaced {
                tabBarButton.tfy_swappableImageViewViewInTabBarButton()?.isHidden = true
            }
        }
    }

    @objc func tfy_replaceTabButtonWithNewView(
        _ newView: UIView,
        offset: UIOffset,
        show: Bool,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        tfy_replaceTabImageViewOrTabButton(true, newView: newView, offset: offset, show: show, shouldAutoHideNewView: true, shouldHideOriginalView: true, completion: completion)
    }

    @objc func tfy_coverVisiableTabImageViewOrTabButton(
        _ isTabButton: Bool,
        contentNewView: UIView,
        seclectContentNewView: UIView,
        offset: UIOffset,
        show: Bool,
        delayIfNeededForSeconds delay: CGFloat,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        tfy_coverTabImageViewOrTabButton(isTabButton, newView: contentNewView, offset: offset, show: show, delayIfNeededForSeconds: delay) { isReplaced, tabBarButton, newView in
            if isReplaced, tabBarButton.tfy_platterSelectedControl() != nil {
                tabBarButton.tfy_coverSeclectContentTabImageViewOrTabButton(
                    isTabButton,
                    newView: seclectContentNewView,
                    offset: offset,
                    show: show,
                    delayIfNeededForSeconds: delay,
                    completion: completion
                )
            } else {
                completion(isReplaced, tabBarButton, newView)
            }
        }
    }

    @objc func tfy_coverVisiableTabImageViewOrTabButton(
        _ isTabButton: Bool,
        newView: UIView,
        offset: UIOffset,
        show: Bool,
        delayIfNeededForSeconds delay: CGFloat,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        tfy_coverSeclectContentTabImageViewOrTabButton(isTabButton, newView: newView, offset: offset, show: show, delayIfNeededForSeconds: delay, completion: completion)
    }

    @objc func tfy_coverSeclectContentTabImageViewOrTabButton(
        _ isTabButton: Bool,
        newView: UIView,
        offset: UIOffset,
        show: Bool,
        delayIfNeededForSeconds delay: CGFloat,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        let target = tfy_platterSelectedControl() ?? self
        target.tfy_coverTabImageViewOrTabButton(isTabButton, newView: newView, offset: offset, show: show, delayIfNeededForSeconds: delay, completion: completion)
    }

    @objc func tfy_coverTabImageViewOrTabButton(
        _ isTabButton: Bool,
        newView: UIView,
        offset: UIOffset,
        show: Bool,
        delayIfNeededForSeconds delay: CGFloat,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        let delaySeconds = tfy_isReady() ? 0 : delay
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delaySeconds)) { [weak self] in
            guard let self else { return }
            self.tfy_replaceTabImageViewOrTabButton(
                isTabButton,
                newView: newView,
                offset: offset,
                show: show,
                shouldAutoHideNewView: false,
                shouldHideOriginalView: false
            ) { isReplaced, tabBarButton, insertedView in
                if isReplaced {
                    tabBarButton.tfy_swappableImageViewViewInTabBarButton()?.isHidden = true
                    for obj in tabBarButton.subviews where obj !== insertedView {
                        obj.tfy_setHidden(show)
                    }
                }
                if show {
                    tabBarButton.tfy_clearBadge()
                } else {
                    tabBarButton.tfy_resumeBadge()
                }
                completion(isReplaced, tabBarButton, insertedView)
            }
        }
    }

    @objc func tfy_replaceTabImageViewOrTabButton(
        _ isTabButton: Bool,
        newView: UIView,
        offset: UIOffset,
        show: Bool,
        shouldAutoHideNewView: Bool,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        tfy_replaceTabImageViewOrTabButton(
            isTabButton,
            newView: newView,
            offset: offset,
            show: show,
            shouldAutoHideNewView: shouldAutoHideNewView,
            shouldHideOriginalView: true,
            completion: completion
        )
    }

    @objc func tfy_replaceTabImageViewOrTabButton(
        _ isTabButton: Bool,
        newView: UIView,
        offset: UIOffset,
        show theShow: Bool,
        shouldAutoHideNewView: Bool,
        shouldHideOriginalView: Bool,
        completion: @escaping (Bool, UIControl, UIView?) -> Void
    ) {
        let tabBarButton = self
        let swappableImageView = tabBarButton.tfy_tabImageView()
        var replacedView: UIView? = swappableImageView
        if isTabButton {
            replacedView = tabBarButton
        }
        guard let anchorView = replacedView else {
            completion(false, self, nil)
            return
        }

        if newView.frame.size == .zero {
            var frame = newView.frame
            if tfy_tabBarController?.adjustTabBarItemImageViewSizeDependOnSuperView ?? true {
                frame.size = tabBarButton.frame.size
            } else if let image = swappableImageView?.image {
                frame.size = image.size
            }
            newView.frame = frame
        }

        let newViewCreated = newView.superview != nil
        let newViewAddedToTabButton = subviews.contains(newView)
        let isNewViewAddedToTabButton = newViewCreated && newViewAddedToTabButton
        if newView.superview != nil, !newViewAddedToTabButton {
            newView.removeFromSuperview()
        }
        if isNewViewAddedToTabButton, theShow {
            completion(true, self, newView)
            return
        }

        let show = theShow
        if shouldHideOriginalView {
            swappableImageView?.isHidden = show
        }
        if isTabButton, shouldHideOriginalView {
            tabBarButton.tfy_tabLabel()?.isHidden = show
        }

        let shouldShowNewView = show && newView.superview == nil
        let shouldRemoveNewView = newView.superview != nil
        if shouldShowNewView {
            tabBarButton.addSubview(newView)
            let newViewSize = newView.frame.size
            if newView.translatesAutoresizingMaskIntoConstraints {
                let xAnchor = swappableImageView ?? anchorView
                newView.bounds.size = newViewSize
                newView.center = CGPoint(
                    x: xAnchor.center.x + offset.horizontal,
                    y: anchorView.center.y + offset.vertical
                )
            } else if #available(iOS 9.0, *) {
                NSLayoutConstraint.activate([
                    newView.centerXAnchor.constraint(equalTo: (swappableImageView ?? anchorView).centerXAnchor, constant: offset.horizontal),
                    newView.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor, constant: offset.vertical),
                    newView.widthAnchor.constraint(equalToConstant: newViewSize.width),
                    newView.heightAnchor.constraint(equalToConstant: newViewSize.height)
                ])
            }
            completion(true, self, newView)
            return
        }
        if shouldRemoveNewView, shouldAutoHideNewView {
            newView.removeFromSuperview()
            completion(false, self, nil)
            return
        }
        completion(false, self, nil)
    }

    // MARK: - Lottie

    @objc func tfy_addLottieImage(withLottieURL lottieURL: URL, size: CGSize, contentMode: UIView.ContentMode) {
        tfy_addLottieImage(withLottieFilePath: lottieURL.path, size: size, contentMode: contentMode)
    }

    @objc func tfy_addLottieImage(withLottieFilePath lottieFilePath: String, size: CGSize, contentMode: UIView.ContentMode) {
        guard let lottieURL = TFYSwiftConstants.tfy_getURL(from: lottieFilePath) else { return }
        var resolvedSize = size
        if resolvedSize == .zero {
            resolvedSize = CGSize(width: TFYSwiftTabBarItemImagePlaceholderWidth, height: TFYSwiftTabBarItemImagePlaceholderHeight)
        }
        if tfy_isPlusControl() { return }
        if tfy_lottieAnimationView() != nil { return }

        if let lottieView = tfy_makeObjCLottieView(url: lottieURL, size: resolvedSize)
            ?? tfy_makeCompatibleLottieView(filePath: lottieFilePath, size: resolvedSize) {
            lottieView.isUserInteractionEnabled = false
            lottieView.contentMode = contentMode
            lottieView.translatesAutoresizingMaskIntoConstraints = false
            lottieView.clipsToBounds = false
            tfy_replaceTabImageViewWithNewView(lottieView, show: true)
        }
    }

    @objc func tfy_animationLottieImage(
        withLottieURL lottieURL: URL,
        size: CGSize,
        defaultSelected: Bool,
        contentMode: UIView.ContentMode
    ) {
        if tfy_isPlusControl() || lottieURL.absoluteString.isEmpty { return }

        tfy_addLottieImage(withLottieURL: lottieURL, size: size, contentMode: contentMode)
        guard let lottieView = tfy_lottieAnimationView() else { return }

        NotificationCenter.default.post(name: .TFYSwiftTabBarItemLottieAnimationPlaying, object: self)

        let apply: () -> Void = {
            if defaultSelected {
                lottieView.setValue(1.0, forKey: "animationProgress")
                _ = lottieView.perform(NSSelectorFromString("forceDrawingUpdate"))
            } else {
                lottieView.setValue(0.0, forKey: "animationProgress")
                _ = lottieView.perform(NSSelectorFromString("play"))
            }
        }
        // OC: ObjC LOTAnimationView plays on main queue; CompatibleLOTAnimationView must not,
        // or pause/play can desync.
        let className = NSStringFromClass(type(of: lottieView))
        if className.contains("CompatibleLOTAnimationView") {
            apply()
        } else {
            DispatchQueue.main.async(execute: apply)
        }
    }

    @objc func tfy_stopAnimationOfLottieView() {
        guard let lottieView = tfy_lottieAnimationView() else { return }
        let progress = (lottieView.value(forKey: "animationProgress") as? NSNumber)?.doubleValue ?? 0
        guard progress > 0 else { return }
        _ = lottieView.perform(NSSelectorFromString("stop"))
    }

    // MARK: - Platter controls

    @objc func tfy_platterSelectedControl() -> UIControl? {
        let tabBar = tfy_tabBarController?.tabBar ?? tfy_enclosingTabBar()
        guard let tabBar else { return nil }
        return tabBar.tfy_selectedContentControl(fromContentControl: self) ?? self
    }

    @objc func tfy_isPlatterSelectedControl() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive(), superview != nil, tfy_tabBarController != nil else { return false }
        return superview?.tfy_isPlatterSelectedContentView() ?? false
    }

    @objc func tfy_isPlatterNormalControl() -> Bool {
        guard tfy_tabBarController?.tabBar != nil else { return false }
        return superview?.tfy_isPlatterContentView() ?? false
    }

    @objc func tfy_platterNormalControl() -> UIControl? {
        tfy_tabBarController?.tabBar.tfy_normalContentControl(fromSelectedContentControl: self) ?? self
    }

    @objc func tfy_hideControl() {
        let selectedControl = tfy_platterSelectedControl()
        isHidden = true
        tfy_tabLabel()?.isHidden = true
        tfy_swappableImageViewViewInTabBarButton()?.isHidden = true
        isUserInteractionEnabled = false
        selectedControl?.isHidden = true
        selectedControl?.tfy_swappableImageViewViewInTabBarButton()?.isHidden = true
        selectedControl?.tfy_tabLabel()?.isHidden = true
        selectedControl?.isUserInteractionEnabled = false
    }

    // MARK: - Deprecated badge point

    @objc var tfy_tabBadgePointView: UIView {
        get {
            if let view = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBadgePointView) as? UIView {
                return view
            }
            let view = UIView.tfy_tabBadgePointView(withClolor: .red, radius: 4.5)
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBadgePointView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
        set {
            if let existing = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBadgePointView) as? UIView {
                existing.removeFromSuperview()
            }
            if newValue.superview != nil {
                newValue.removeFromSuperview()
            }
            newValue.isHidden = true
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBadgePointView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc var tfy_tabBadgePointViewOffset: UIOffset {
        get {
            (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBadgePointViewOffset) as? NSValue)?.uiOffsetValue ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.tabBadgePointViewOffset, NSValue(uiOffset: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func tfy_showTabBadgePoint() {
        tfy_setShowTabBadgePointIfNeeded(true)
    }

    @objc func tfy_removeTabBadgePoint() {
        tfy_setShowTabBadgePointIfNeeded(false)
    }

    @objc func tfy_isShowTabBadgePoint() -> Bool {
        !tfy_tabBadgePointView.isHidden
    }

    private func tfy_setShowTabBadgePointIfNeeded(_ showTabBadgePoint: Bool) {
        tfy_setShowTabBadgePoint(showTabBadgePoint)
    }

    private func tfy_setShowTabBadgePoint(_ showTabBadgePoint: Bool) {
        if showTabBadgePoint, tfy_tabBadgePointView.superview == nil {
            tfy_bringSubviewToFront(tfy_tabBadgePointView)
            if let imageView = tfy_tabImageView() {
                addConstraint(NSLayoutConstraint(
                    item: tfy_tabBadgePointView,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: imageView,
                    attribute: .right,
                    multiplier: 1,
                    constant: tfy_tabBadgePointViewOffset.horizontal
                ))
                addConstraint(NSLayoutConstraint(
                    item: tfy_tabBadgePointView,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: imageView,
                    attribute: .top,
                    multiplier: 1,
                    constant: tfy_tabBadgePointViewOffset.vertical
                ))
            }
        }
        tfy_tabBadgePointView.isHidden = !showTabBadgePoint
        tfy_tabBadgeView()?.isHidden = showTabBadgePoint
    }
}

private extension UIControl {
    func tfy_makeObjCLottieView(url: URL, size: CGSize) -> UIView? {
        guard let view = tfy_objcAllocInit("LOTAnimationView", selector: "initWithContentsOfURL:", argument: url) as? UIView else {
            return nil
        }
        view.frame = CGRect(origin: .zero, size: size)
        return view
    }

    func tfy_makeCompatibleLottieView(filePath: String, size: CGSize) -> UIView? {
        TFYSwiftMakeCompatibleLottieView?(filePath, size)
    }
}

private func tfy_objcAllocInit(_ className: String, selector: String, argument: Any) -> AnyObject? {
    guard let cls = NSClassFromString(className) else { return nil }
    guard let allocated = (cls as AnyObject).perform(NSSelectorFromString("alloc"))?.takeUnretainedValue() else {
        return nil
    }
    return (allocated as AnyObject).perform(NSSelectorFromString(selector), with: argument)?.takeRetainedValue()
}
