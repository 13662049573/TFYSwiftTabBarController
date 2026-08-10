//
//  TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLTabBar.h / CYLTabBar.m
//

import UIKit

public typealias TFYSwiftTabBarDidLayoutSubViewsBlock = (TFYSwiftTabBar) -> Void

@objc open class TFYSwiftTabBar: UITabBar, UIGestureRecognizerDelegate {

    private static var tabBarContextKey: UInt8 = 0
    private static var tabBarAlphaContextKey: UInt8 = 0
    private static var tabBarContext: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(&tabBarContextKey)
    }
    private static var tabBarAlphaContext: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(&tabBarAlphaContextKey)
    }

    /// Default vertical offset for tab image centering.
    @objc public private(set) var tabImageViewDefaultOffset: CGFloat = 0

    @objc public var context: String? {
        get { tfy_context }
        set {
            if let newValue, !newValue.isEmpty {
                tfy_context = newValue
            }
            plusButton = TFYSwiftExternPlusButton
        }
    }

    @objc public var didLayoutSubViewsBlock: TFYSwiftTabBarDidLayoutSubViewsBlock?

    @objc public var plusButton: TFYSwiftPlusButton? {
        get {
            guard TFYSwiftExternPlusButton != nil, let stored = _plusButton else { return nil }
            let addedToTabBar = stored.superview === self
            let isSameContext = hasPlusButton()
            if addedToTabBar, isSameContext { return stored }
            return nil
        }
        set {
            guard let plusButton = newValue, hasPlusButton() else { return }
            _plusButton = plusButton
            guard !isPlusButtonActive else { return }
            let isFirstAdded = plusButton.superview == nil
            let isSameContext = hasPlusButton()
            if isSameContext, isFirstAdded {
                tfy_addPlatterViewThenBringSubviewToFront(plusButton)
                plusButtonActive = true
                plusButton.tfy_setTabBarController(tabBarController())
            }
        }
    }

    @objc public var tabBarItemWidth: CGFloat {
        get { _tabBarItemWidth }
        set {
            guard _tabBarItemWidth != newValue else { return }
            willChangeValue(forKey: "tabBarItemWidth")
            _tabBarItemWidth = newValue
            didChangeValue(forKey: "tabBarItemWidth")
        }
    }

    @objc public var tabBarItemsCount: UInt = 0

    @objc public var tabBarButtonArray: [UIControl] = []

    @objc public private(set) var plusButtonActive = false
    @objc public var isPlusButtonActive: Bool {
        get { plusButtonActive }
        set { plusButtonActive = newValue }
    }
    @objc public var isLensViewLifed = false
    @objc public weak var liquidGlassContinuousGestureRecognizer: UIGestureRecognizer?
    @objc public weak var liquidGlassLongGestureRecognizer: UIGestureRecognizer?

    private var _plusButton: TFYSwiftPlusButton?
    private var _tabBarItemWidth: CGFloat = 0
    private var observedViews = NSMutableSet()
    private var lottieObserver: NSObjectProtocol?

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    private func sharedInit() {
        addObserver(self, forKeyPath: "tabBarItemWidth", options: .new, context: TFYSwiftTabBar.tabBarContext)
        lottieObserver = NotificationCenter.default.addObserver(
            forName: .TFYSwiftTabBarItemLottieAnimationPlaying,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.tfy_stopAnimationOfAllLottieView()
        }
    }

    deinit {
        tfy_removeObserver(self, forKeyPath: "tabBarItemWidth")
        removeAlphaObserver()
        if let lottieObserver { NotificationCenter.default.removeObserver(lottieObserver) }
    }

    open override class func automaticallyNotifiesObservers(forKey key: String) -> Bool {
        false
    }

    // MARK: - Layout

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if TFYSwiftConstants.isLiquidGlassActive() {
            return sizeThatFits
        }
        let controller = tabBarController()
        let height = (controller?.tabBarHeight ?? TFYSwiftTabBarHeight) + (controller?.view.safeAreaInsets.bottom ?? 0)
        if height > 0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        tabBarButtonArray = tfy_originalTabBarButtons()
        presetUnselectedItemTintColor()
        if let first = tabBarButtonArray.first {
            setupTabImageViewDefaultOffset(first)
        }

        if tfy_systemVersionGreaterThanOrEqualTo("15.0"), !TFYSwiftConstants.isLiquidGlassActive(), !isHidden {
            removeAlphaObserver()
            let backgroundView = tfy_tabBackgroundView()
            let shadowView = tfy_tabShadowImageView()?.subviews.first
            if let shadowView, !observedViews.contains(shadowView) {
                observedViews.add(shadowView)
                shadowView.addObserver(self, forKeyPath: "alpha", options: .new, context: TFYSwiftTabBar.tabBarAlphaContext)
            }
            if UITabBar.appearance().backgroundImage != nil {
                if let imageView = backgroundView?.tfy_imageView(), !observedViews.contains(imageView) {
                    observedViews.add(imageView)
                    imageView.addObserver(self, forKeyPath: "alpha", options: .new, context: TFYSwiftTabBar.tabBarAlphaContext)
                }
            } else if let effectView = backgroundView?.tfy_tabEffectView(), !observedViews.contains(effectView) {
                observedViews.add(effectView)
                effectView.addObserver(self, forKeyPath: "alpha", options: .new, context: TFYSwiftTabBar.tabBarAlphaContext)
            }
        }

        let tabBarWidth = tfy_boundsSize().width
        guard plusButtonActive else {
            didLayoutSubViewsBlock?(self)
            return
        }

        let addedToTabBar = _plusButton?.superview === self
        if !addedToTabBar, hasPlusButton() {
            guard tabBarItemsCount > 0 else { return }
            tabBarItemWidth = tabBarWidth / CGFloat(tabBarItemsCount)
            for (buttonIndex, childView) in tabBarButtonArray.enumerated() {
                let childViewX = CGFloat(buttonIndex) * tabBarItemWidth
                changeX(forChildView: childView, childViewX: childViewX, tabBarItemWidth: tabBarItemWidth, index: UInt(buttonIndex))
            }
            didLayoutSubViewsBlock?(self)
            return
        }

        guard tabBarItemsCount > 0 else { return }
        let plusButtonWidth = _plusButton?.frame.width ?? 0
        tabBarItemWidth = (tabBarWidth - plusButtonWidth) / CGFloat(tabBarItemsCount)
        let plusButtonIndex = plusButtonIndex()
        for (buttonIndex, childView) in tabBarButtonArray.enumerated() {
            var childViewX: CGFloat
            var visibleTabIndex = CGFloat(buttonIndex)
            var itemWidth = tabBarItemWidth

            if tfy_hasPlusChildViewController() {
                if buttonIndex <= Int(plusButtonIndex) {
                    childViewX = CGFloat(buttonIndex) * tabBarItemWidth
                } else {
                    childViewX = CGFloat(buttonIndex - 1) * tabBarItemWidth + plusButtonWidth
                }
                if buttonIndex == Int(plusButtonIndex) {
                    itemWidth = plusButtonWidth
                }
            } else {
                if buttonIndex >= Int(plusButtonIndex) {
                    childViewX = CGFloat(buttonIndex) * tabBarItemWidth + plusButtonWidth
                    visibleTabIndex = CGFloat(buttonIndex + 1)
                } else {
                    childViewX = CGFloat(buttonIndex) * tabBarItemWidth
                }
            }

            childView.tfy_tabBarChildViewControllerIndex = buttonIndex
            let selectedContentControl = tfy_selectedContentControl(fromContentControl: childView)
            selectedContentControl?.tfy_tabBarChildViewControllerIndex = buttonIndex
            changeX(forChildView: childView, childViewX: childViewX, tabBarItemWidth: itemWidth, index: UInt(visibleTabIndex))
        }
        didLayoutSubViewsBlock?(self)
    }

    private func changeX(forChildView childView: UIControl, childViewX: CGFloat, tabBarItemWidth: CGFloat, index: UInt) {
        if !TFYSwiftConstants.isLiquidGlassActive() {
            childView.frame = CGRect(
                x: childViewX,
                y: childView.frame.minY,
                width: tabBarItemWidth,
                height: childView.frame.height
            )
        }
        let selectedContentControl = tfy_selectedContentControl(fromContentControl: childView)
        childView.tfy_tabBarItemVisibleIndex = Int(index)
        selectedContentControl?.transform = .identity
    }

    // MARK: - Plus Button

    @objc public func plusButtonIndex() -> UInt {
        guard let plusButton = _plusButton else { return UInt(NSNotFound) }
        let index = type(of: plusButton).index(forTabbarItemsCount: tabBarItemsCount)
        let tabBarWidth = tfy_boundsSize().width
        let tabBarHeight = tfy_boundsSize().height

        if !TFYSwiftConstants.isLiquidGlassActive() {
            let multiplier = multiplierOfTabBarHeight()
            let yOffset = constantOfPlusButtonCenterYOffset(forTabBarHeight: tabBarHeight)
            plusButton.center = CGPoint(
                x: tabBarWidth * 0.5,
                y: tabBarHeight * multiplier + yOffset
            )
            let childViewX = CGFloat(index) * tabBarItemWidth
            let itemWidth = plusButton.frame.width
            changeX(forChildView: plusButton, childViewX: childViewX, tabBarItemWidth: itemWidth, index: index)
            TFYSwiftPlusButtonIndex = index
        } else {
            TFYSwiftPlusButtonIndex = index
            let platterView = tfy_tabBarContentView
            let multiplier = multiplierOfTabBarHeight()
            let yOffset = constantOfPlusButtonCenterYOffset(forTabBarHeight: tabBarHeight)
            let platterCenter = platterView.superview?.convert(platterView.center, to: self) ?? platterView.center
            let systemDefaultY = tabBarHeight * multiplier + yOffset
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            plusButton.center = CGPoint(x: platterCenter.x, y: systemDefaultY)
            CATransaction.commit()
        }
        TFYSwiftExternPlusButton?.tfy_tabBarChildViewControllerIndex = Int(index)
        return index
    }

    @objc public func hasPlusButton() -> Bool {
        TFYSwiftPlusButton.hasPlusButton(forTabBarContext: context)
    }

    @objc public func hasPlusChildViewController() -> Bool {
        TFYSwiftPlusButton.hasPlusChildViewController(forTabBarContext: context)
    }

    @objc public func isPlusButtonLayoutCentered() -> Bool {
        plusButton?.isLayoutCentered() ?? false
    }

    @objc public func tabBarController() -> TFYSwiftTabBarController? {
        if let delegate = delegate as? TFYSwiftTabBarController {
            return delegate
        }
        return tfy_tabBarController
    }

    // MARK: - Hit Testing

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if tfy_canNotResponseEvent() {
            return super.hitTest(point, with: event)
        }
        if clipsToBounds, !self.point(inside: point, with: event) {
            return super.hitTest(point, with: event)
        }
        if let plusButton = plusButton {
            let frame = plusButton.touchableRect()
            if frame.contains(point) {
                return plusButton
            }
        }
        var buttons = tabBarButtonArray
        if buttons.isEmpty {
            buttons = tfy_visibleControls()
        }
        for selectedTabBarButton in buttons {
            let imageView = selectedTabBarButton.tfy_getActualBadgeSuperView() as? UIView
            let buttonFrame = selectedTabBarButton.frame
            let imageFrame = imageView.map { $0.convert($0.bounds, to: self) } ?? .zero
            let contains = buttonFrame.contains(point) || imageFrame.contains(point)
            if contains, !selectedTabBarButton.tfy_canNotResponseEvent() {
                return selectedTabBarButton
            }
        }
        if let result = super.hitTest(point, with: event) {
            return result
        }
        for subview in subviews.reversed() {
            let subPoint = convert(point, to: subview)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        return super.hitTest(point, with: event)
    }

    open override func addSubview(_ view: UIView) {
        if view.tfy_isPlatterView() {
            tfy_platterView = view
            for sub in view.subviews where sub.tfy_isPlatterContentView() {
                tfy_platterContentView = sub
                break
            }
        }
        if view.tfy_isPlatterPortalView(), tfy_portalView == nil {
            tfy_setPortalView(view)
        }
        super.addSubview(view)
    }

    open override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        guard TFYSwiftConstants.isLiquidGlassActive(), type(of: self) == TFYSwiftTabBar.self else {
            super.addGestureRecognizer(gestureRecognizer)
            return
        }
        if gestureRecognizer.tfy_isContinuousGestureRecognizer() {
            liquidGlassContinuousGestureRecognizer = gestureRecognizer
            gestureRecognizer.delegate = self
        }
        if gestureRecognizer.tfy_isLongGestureRecognizer() {
            liquidGlassLongGestureRecognizer = gestureRecognizer
            gestureRecognizer.delegate = self
        }
        super.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - UIGestureRecognizerDelegate

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive(), type(of: self) == TFYSwiftTabBar.self else {
            return true
        }
        let location = gestureRecognizer.location(in: self)
        let hitView = hitTest(location, with: nil)
        let tabBarController = tabBarController()

        if tfy_shouldUpdateHiddenStatueForPlusButtonLabel(),
           hitView is TFYSwiftPlusButton,
           tabBarController?.selectedViewController === TFYSwiftPlusChildViewController,
           !(TFYSwiftExternPlusButton?.tfy_keepShowingPlusButtonLabel ?? false) {
            return false
        }

        if (hitView?.tfy_isTabButton() == true || hitView is TFYSwiftPlusButton),
           let control = hitView as? UIControl,
           control.isSelected {
            tabBarController?.tabChangedToControl(control)
        }

        if hitView is TFYSwiftPlusButton, TFYSwiftPlusChildViewController == nil {
            if !(TFYSwiftExternPlusButton?.tfy_userInteractionDisabled ?? false) {
                if let plus = TFYSwiftExternPlusButton {
                    tabBarController?.tabChangedToControl(plus)
                }
            }
            return false
        }
        return true
    }

    // MARK: - KVO

    open override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if context == TFYSwiftTabBar.tabBarAlphaContext {
            if let view = object as? UIView, !view.isHidden,
               let newAlpha = change?[.newKey] as? Float, newAlpha == 0 {
                view.alpha = 1
            }
            return
        }
        guard context == TFYSwiftTabBar.tabBarContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        NotificationCenter.default.post(name: .TFYSwiftTabBarItemWidthDidChange, object: self)
        if #available(iOS 11.0, *), tfy_isIPhoneX {
            layoutIfNeeded()
        }
    }

    // MARK: - Private

    private func presetUnselectedItemTintColor() {
        if #available(iOS 13.0, *) {
            guard unselectedItemTintColor == nil else { return }
            var tabLabelTextColor = UIColor.tfy_systemGrayColor
            for childView in tabBarButtonArray where !childView.isSelected {
                if childView.tfy_tabEffectView() != nil, let label = childView.tfy_tabLabel() {
                    tabLabelTextColor = label.textColor
                }
            }
            if #available(iOS 26.0, *) {
                for obj in tfy_tabBarSubviews() {
                    for sub in obj.subviews where sub.tfy_isTabLabel() {
                        if let label = sub as? UILabel, label.textColor != nil {
                            tabLabelTextColor = label.textColor
                            break
                        }
                    }
                }
            }
            unselectedItemTintColor = tabLabelTextColor
        }
    }

    private func setupTabImageViewDefaultOffset(_ tabBarButton: UIView) {
        guard tabImageViewDefaultOffset <= 0 else { return }
        var shouldCustomize = true
        var offset: CGFloat = 0
        let tabButtonCenterY = tabBarButton.center.y
        for obj in tabBarButton.subviews {
            if obj.tfy_isTabLabel() { shouldCustomize = false }
            if obj.tfy_isTabImageView() {
                offset = (tabButtonCenterY - obj.center.y) * 0.5
                if offset == 0 { shouldCustomize = false }
            }
        }
        if shouldCustomize, offset != 0 {
            willChangeValue(forKey: "tabImageViewDefaultOffset")
            tabImageViewDefaultOffset = offset
            didChangeValue(forKey: "tabImageViewDefaultOffset")
        }
    }

    private func removeAlphaObserver() {
        guard tfy_systemVersionGreaterThanOrEqualTo("15.0"), !TFYSwiftConstants.isLiquidGlassActive() else { return }
        for case let view as UIView in observedViews {
            view.tfy_removeObserver(self, forKeyPath: "alpha")
        }
        observedViews.removeAllObjects()
    }

    private func multiplierOfTabBarHeight() -> CGFloat {
        guard let plusButton = _plusButton else { return 0.5 }
        return plusButton.multiplierOfTabBarHeight(tfy_boundsSize().height)
    }

    private func constantOfPlusButtonCenterYOffset(forTabBarHeight tabBarHeight: CGFloat) -> CGFloat {
        guard let plusButton = _plusButton else { return 0 }
        return plusButton.constantOfPlusButtonCenterYOffsetForTabBarHeight(tabBarHeight)
    }
}

// MARK: - Helpers

private var tfy_isIPhoneX: Bool {
    let size = tfy_screenSize()
    return min(size.width, size.height) >= 375 && max(size.width, size.height) >= 812
}
