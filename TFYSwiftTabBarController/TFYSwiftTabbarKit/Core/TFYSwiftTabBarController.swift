//
//  TFYSwiftTabBarController.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLTabBarController.h / CYLTabBarController.m (core path)
//

import ObjectiveC
import UIKit

@objc public protocol TFYSwiftTabBarControllerDelegate: UITabBarControllerDelegate {
    @objc optional func tabBarController(_ tabBarController: TFYSwiftTabBarController, didSelectControl control: UIControl)
    @objc optional func tabBarController(_ tabBarController: TFYSwiftTabBarController, shouldShowPlatterLiquidLensViewForControl control: UIControl) -> Bool
}

public typealias TFYSwiftViewDidLayoutSubViewsBlock = (TFYSwiftTabBarController) -> Void

@objc open class TFYSwiftTabBarController: UITabBarController, TFYSwiftTabBarControllerDelegate {

    private static var tabImageViewDefaultOffsetContext: UInt8 = 0

    @objc public var tabBarStyleType: TFYSwiftTabBarStyleType = .default {
        didSet { applyTabBarStyleType(tabBarStyleType) }
    }

    public var viewDidLayoutSubviewsBlock: TFYSwiftViewDidLayoutSubViewsBlock?
    public var tabBarItemsAttributes: [[AnyHashable: Any]] = []
    @objc public var tabBarHeight: CGFloat {
        get {
            if _tabBarHeight == 0 {
                if TFYSwiftTabBarHeight == 0 { TFYSwiftTabBarHeight = 49 }
                _tabBarHeight = TFYSwiftTabBarHeight
            }
            return _tabBarHeight
        }
        set {
            if isFlatDesignStyle {
                guard _tabBarHeight != newValue else { return }
                _tabBarHeight = newValue
                TFYSwiftTabBarHeight = newValue
                tfy_flatDesignUpdateTabBarHeight(newValue)
                return
            }
            _tabBarHeight = newValue
            TFYSwiftTabBarHeight = newValue
        }
    }

    @objc public private(set) var imageInsets: UIEdgeInsets = .zero
    @objc public private(set) var titlePositionAdjustment: UIOffset = .zero
    @objc public private(set) var imagePositionAdjustment: UIOffset = .zero
    @objc public var adjustTabBarItemImageViewSizeDependOnSuperView = true
    @objc public var context: String? {
        get { tfy_context }
        set { applyContext(newValue) }
    }
    @objc public var noNeedUIDesignCompatibility = false
    @objc public private(set) var lottieViewAdded = false
    @objc(isLottieViewAdded) public var isLottieViewAdded: Bool { lottieViewAdded }
    @objc public private(set) var lottieURLs = NSMutableArray()
    @objc public private(set) var lottieSizes = NSMutableArray()

    private var _tabBarHeight: CGFloat = 0
    /// Stored custom tab bar (CYLTabBar or FlatDesignTabBar). Internal for FlatDesign extension.
    var _cylTabBar: UIView?
    /// Manual `tfy_hideTabBarAnimated` — layout must not snap the bar back on screen.
    var tfy_isTabBarSlidOffscreen = false
    private var _storedViewControllers: [UIViewController]?
    private var observingTabImageViewDefaultOffset = false
    private var invokeOnceViewDidLayoutSubViewsBlock = false
    private var tabItemPlaceholderImage: UIImage?

    private var isFlatDesignStyle: Bool { tabBarStyleType == .flatDesign }

    // MARK: - Init

    @objc public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(
        viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]]
    ) {
        self.init(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            imageInsets: .zero,
            titlePositionAdjustment: .zero,
            styleType: .default,
            context: nil
        )
    }

    public convenience init(
        viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        imageInsets: UIEdgeInsets,
        titlePositionAdjustment: UIOffset
    ) {
        self.init(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            imageInsets: imageInsets,
            titlePositionAdjustment: titlePositionAdjustment,
            styleType: .default,
            context: nil
        )
    }

    public convenience init(
        viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        imageInsets: UIEdgeInsets,
        titlePositionAdjustment: UIOffset,
        context: String?
    ) {
        self.init(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            imageInsets: imageInsets,
            titlePositionAdjustment: titlePositionAdjustment,
            styleType: .default,
            context: context
        )
    }

    public convenience init(
        viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        styleType: TFYSwiftTabBarStyleType,
        context: String?
    ) {
        self.init(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            imageInsets: .zero,
            titlePositionAdjustment: .zero,
            styleType: styleType,
            context: context
        )
    }

    public init(
        viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        imageInsets: UIEdgeInsets,
        titlePositionAdjustment: UIOffset,
        styleType: TFYSwiftTabBarStyleType,
        context: String?
    ) {
        super.init(nibName: nil, bundle: nil)
        self.imageInsets = imageInsets
        self.titlePositionAdjustment = titlePositionAdjustment
        self.tabBarItemsAttributes = tabBarItemsAttributes
        self.tabBarStyleType = styleType
        _ = tfy_cylTabBar
        applyContext(context)
        self.viewControllers = viewControllers
        delegate = self
    }

    public class func tabBarController(
        withViewControllers viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]]
    ) -> TFYSwiftTabBarController {
        TFYSwiftTabBarController(viewControllers: viewControllers, tabBarItemsAttributes: tabBarItemsAttributes)
    }

    public class func tabBarController(
        withViewControllers viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        imageInsets: UIEdgeInsets,
        titlePositionAdjustment: UIOffset
    ) -> TFYSwiftTabBarController {
        TFYSwiftTabBarController(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            imageInsets: imageInsets,
            titlePositionAdjustment: titlePositionAdjustment
        )
    }

    public class func tabBarController(
        withViewControllers viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        imageInsets: UIEdgeInsets,
        titlePositionAdjustment: UIOffset,
        context: String?
    ) -> TFYSwiftTabBarController {
        TFYSwiftTabBarController(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            imageInsets: imageInsets,
            titlePositionAdjustment: titlePositionAdjustment,
            context: context
        )
    }

    public class func tabBarController(
        withViewControllers viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        styleType: TFYSwiftTabBarStyleType,
        context: String?
    ) -> TFYSwiftTabBarController {
        TFYSwiftTabBarController(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            styleType: styleType,
            context: context
        )
    }

    public class func tabBarController(
        withViewControllers viewControllers: [UIViewController],
        tabBarItemsAttributes: [[AnyHashable: Any]],
        imageInsets: UIEdgeInsets,
        titlePositionAdjustment: UIOffset,
        styleType: TFYSwiftTabBarStyleType,
        context: String?
    ) -> TFYSwiftTabBarController {
        TFYSwiftTabBarController(
            viewControllers: viewControllers,
            tabBarItemsAttributes: tabBarItemsAttributes,
            imageInsets: imageInsets,
            titlePositionAdjustment: titlePositionAdjustment,
            styleType: styleType,
            context: context
        )
    }

    deinit {
        guard !isFlatDesignStyle else { return }
        removePlusButtonIfNeeded()
        if let bar = tfy_cylTabBar as? TFYSwiftTabBar, observingTabImageViewDefaultOffset {
            bar.tfy_removeObserver(self, forKeyPath: "tabImageViewDefaultOffset")
        }
    }

    // MARK: - Custom Tab Bar (KVC)

    @objc public var tfy_cylTabBar: UIView {
        if isFlatDesignStyle {
            if _cylTabBar is TFYSwiftTabBar {
                _cylTabBar = nil
            }
            if _cylTabBar == nil {
                tfy_installFlatDesignTabBarIfNeeded()
            }
            return _cylTabBar ?? tabBar
        }
        if _cylTabBar is TFYSwiftFlatDesignTabBar {
            _cylTabBar = nil
        }
        if _cylTabBar == nil {
            setUpDefaultStyleTabBar()
            if !observingTabImageViewDefaultOffset, let bar = _cylTabBar as? TFYSwiftTabBar {
                bar.addObserver(self, forKeyPath: "tabImageViewDefaultOffset", options: .new, context: &Self.tabImageViewDefaultOffsetContext)
                observingTabImageViewDefaultOffset = true
            }
            NotificationCenter.default.post(name: .TFYSwiftTabBarStyleTypeDidChange, object: self)
        }
        return _cylTabBar ?? tabBar
    }

    @objc public func tfy_setTabBar(_ tabBar: UIView?) {
        _cylTabBar = tabBar
    }

    open override var tabBar: UITabBar {
        if let custom = _cylTabBar as? UITabBar { return custom }
        return super.tabBar
    }

    open override var viewControllers: [UIViewController]? {
        get { _storedViewControllers ?? super.viewControllers }
        set {
            // Do not write `_storedViewControllers` first: UIKit's setter compares
            // via this getter and will no-op if it already matches, leaving the
            // internal list empty. iOS 26 then asserts in setSelectedViewController:.
            tfy_applyViewControllers(newValue)
        }
    }

    /// Install VCs into UIKit's list. The getter must not already return `viewControllers`
    /// or iOS 26 skips the update and later `setSelectedViewController:` asserts.
    func commitViewControllersToSuper(_ viewControllers: [UIViewController]?) {
        _storedViewControllers = nil
        if let viewControllers {
            super.setViewControllers(viewControllers, animated: false)
        } else {
            super.viewControllers = nil
        }
        _storedViewControllers = viewControllers
    }

    // MARK: - Lifecycle

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !isFlatDesignStyle else {
            tfy_flatDesignViewDidLayoutSubviews()
            invokeLayoutBlockIfNeeded()
            return
        }

        tfy_cylTabBar.layoutSubviews()
        if let tabBar = tfy_cylTabBar as? TFYSwiftTabBar {
            tabBar.tfy_visibleControls().enumerated().forEach { idx, control in
                if TFYSwiftConstants.isLiquidGlassActive() { return }
                if control.tfy_isChildViewControllerPlusButton() { return }
                control.tfy_tabLabel()?.textAlignment = .center
                control.removeTarget(self, action: #selector(tabChangedToControl(_:)), for: .touchUpInside)
                control.addTarget(self, action: #selector(tabChangedToControl(_:)), for: .touchUpInside)
                if idx == selectedIndex, !(control is TFYSwiftPlusButton) {
                    control.isSelected = true
                }
            }

            if !lottieViewAdded {
                let subButtons = tabBar.tfy_subTabBarButtonsWithoutPlusButton()
                let lottieEnabled = isLottieEnabled()
                if !TFYSwiftConstants.isLiquidGlassActive() {
                    if !lottieEnabled || subButtons.count != lottieURLs.count {
                        lottieViewAdded = true
                    } else {
                        initLottieTabBar(tabBar)
                    }
                } else if !lottieEnabled {
                    lottieViewAdded = true
                } else {
                    initLottieTabBar(tabBar)
                }
            }
        }

        configureLiquidGlassPlusButtonIfNeeded()
        invokeLayoutBlockIfNeeded()
        tfy_keepTabBarOffscreenIfNeeded()
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard !isFlatDesignStyle else { return }
        if tfy_isTabBarSlidOffscreen { return }
        if TFYSwiftConstants.isLiquidGlassActive() || tabBarHeight == 0 { return }
        var frame = tfy_cylTabBar.frame
        let height = tabBarFrame.size.height
        frame.size.height = height
        frame.origin.y = view.frame.height - height
        tfy_cylTabBar.frame = frame
    }

    func tfy_keepTabBarOffscreenIfNeeded() {
        guard tfy_isTabBarSlidOffscreen, !isFlatDesignStyle else { return }
        let y = view.bounds.height
        tfy_cylTabBar.frame.origin.y = y
        for subview in view.subviews {
            let name = NSStringFromClass(type(of: subview))
            if name == "_UITabContainerView" || (name.hasPrefix("_UITab") && name.contains("Container")) {
                subview.frame.origin.y = y
            }
        }
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let controller = selectedViewController else { return .all }
        if let nav = controller as? UINavigationController {
            return nav.topViewController?.supportedInterfaceOrientations ?? .all
        }
        return controller.supportedInterfaceOrientations
    }

    open override var childForStatusBarStyle: UIViewController? {
        selectedViewController ?? _storedViewControllers?.last ?? tfy_getRootViewController()
    }

    open override var childForStatusBarHidden: UIViewController? {
        childForStatusBarStyle
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        childForStatusBarStyle?.preferredStatusBarUpdateAnimation ?? .fade
    }

    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        childForStatusBarStyle
    }

    // MARK: - Selection

    @objc public func tabChangedToControl(_ control: UIControl) {
        tabChangedToSelectedViewController(nil, control: control)
    }

    @objc public func tabChangedToSelectedViewController(_ viewController: UIViewController?, control: UIControl?) {
        tabChangedToSelectedIndex(UInt(selectedIndex), viewController: viewController, control: control)
    }

    @objc public func tabChangedToSelectedIndex(
        _ selectedIndex: UInt,
        viewController: UIViewController?,
        control: UIControl?
    ) {
        guard !isFlatDesignStyle else { return }
        guard tfy_cylTabBar is UITabBar || tfy_cylTabBar is TFYSwiftTabBar else { return }

        let vc = viewController ?? selectedViewController
        if vc?.tfy_isPlaceholder == true { return }

        var resolvedControl = control
        if resolvedControl == nil {
            resolvedControl = vc?.tfy_getViewControllerInsteadOfNavigationController().tfy_tabButton
        }
        if resolvedControl == nil {
            resolvedControl = vc?.tfy_tabButton
        }

        if let targetVC = vc ?? selectedViewController {
            updateSelectionStatusIfNeeded(
                for: nil,
                shouldSelectViewController: targetVC
            )
        }
        if let resolvedControl {
            didSelectControl(resolvedControl)
        }

        guard let itemVC = vc ?? selectedViewController else { return }
        let item = itemVC.tabBarItem
        let isPlusChild = resolvedControl?.tfy_isChildViewControllerPlusButton() ?? false
        if isLottieEnabled(), !isPlusChild, itemVC.tfy_isPlaceholder != true, let control = resolvedControl {
            addLottieImage(
                with: control,
                lottieURL: item?.tfy_lottieURL,
                lottieSizeValue: item?.tfy_lottieSizeValue,
                animation: true
            )
        }
    }

    open override var selectedViewController: UIViewController? {
        get { super.selectedViewController }
        set {
            guard let requested = newValue else { return }
            let installed = (super.viewControllers ?? []) + children
            let target = installed.first(where: { $0.tfy_isEqualToViewController(requested) }) ?? requested
            guard installed.contains(where: { $0 === target }) else {
                if let idx = (viewControllers ?? []).firstIndex(where: { $0.tfy_isEqualToViewController(requested) }),
                   idx != NSNotFound {
                    super.selectedIndex = idx
                }
                return
            }
            super.selectedViewController = target

            guard !isFlatDesignStyle else {
                tfy_flatDesignDidSelectViewController(target)
                return
            }
            if target.tfy_isPlaceholder { return }

            fixTabBarTransparencyIfNeeded()

            if !TFYSwiftConstants.isLiquidGlassActive() { return }

            if target === TFYSwiftPlusChildViewController {
                TFYSwiftExternPlusButton?.isSelected = true
                tabChangedToSelectedIndex(
                    TFYSwiftPlusButtonIndex,
                    viewController: target,
                    control: TFYSwiftExternPlusButton
                )
            } else {
                tabChangedToSelectedIndex(
                    UInt(selectedIndex),
                    viewController: target,
                    control: target.tfy_tabButton
                )
            }
        }
    }

    open override var selectedIndex: Int {
        get { super.selectedIndex }
        set {
            let selectedIndex = newValue
            guard !isFlatDesignStyle else {
                tfy_flatDesignSetSelectedIndex(selectedIndex)
                return
            }
            guard selectedIndex >= 0, selectedIndex != NSNotFound else { return }
            var selectedViewController: UIViewController?
            if let vcs = viewControllers, selectedIndex < vcs.count {
                selectedViewController = vcs[selectedIndex]
            }
            if selectedViewController?.tfy_isPlaceholder == true { return }
            if let selectedViewController {
                self.selectedViewController = selectedViewController
            } else {
                super.selectedIndex = selectedIndex
            }
            tabChangedToSelectedIndex(UInt(selectedIndex), viewController: selectedViewController, control: nil)
        }
    }

    @objc(setTabBarHidden:animated:)
    open override func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        guard tabBarStyleType == .flatDesign else {
            if #available(iOS 18.0, *) {
                super.setTabBarHidden(hidden, animated: animated)
            } else {
                tabBar.isHidden = hidden
            }
            return
        }
        tfy_setFlatDesignTabBarHidden(hidden, animated: animated)
    }

    // MARK: - UITabBarControllerDelegate

    open func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tfy_isPlaceholder { return false }

        if #available(iOS 18.0, *) {
            if let fromView = selectedViewController?.view,
               let toView = viewController.view,
               fromView !== toView {
                UIView.transition(from: fromView, to: toView, duration: 0.01, options: .transitionCrossDissolve)
            }
        }

        updateSelectionStatusIfNeeded(for: tabBarController, shouldSelectViewController: viewController)
        return viewController !== tabBarController.selectedViewController
    }

    @objc public func tabBarController(
        _ tabBarController: TFYSwiftTabBarController,
        shouldShowPlatterLiquidLensViewForControl control: UIControl
    ) -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive(), tabBar is TFYSwiftTabBar else { return false }
        guard hasPlusChildViewController() else { return true }
        if selectedViewController === TFYSwiftPlusChildViewController,
           (tabBar as? TFYSwiftTabBar)?.isPlusButtonLayoutCentered() != true {
            return false
        }
        return true
    }

    // MARK: - Public API

    @objc public func setViewDidLayoutSubViewsBlock(_ block: TFYSwiftViewDidLayoutSubViewsBlock?) {
        viewDidLayoutSubviewsBlock = block
    }

    @objc public func setViewDidLayoutSubViewsBlockInvokeOnce(_ invokeOnce: Bool, block: TFYSwiftViewDidLayoutSubViewsBlock?) {
        invokeOnceViewDidLayoutSubViewsBlock = invokeOnce
        viewDidLayoutSubviewsBlock = block
    }

    @objc public func lottieAnimationViewContentMode() -> UIView.ContentMode {
        .scaleAspectFit
    }

    @objc public func hideTabBarShadowImageView() {
        guard !isFlatDesignStyle else { return }
        tfy_cylTabBar.layoutIfNeeded()
        tfy_cylTabBar.tfy_tabShadowImageView()?.tfy_setHidden(true)
    }

    @objc public func hideTabBadgeBackgroundSeparator() {
        hideTabBarShadowImageView()
    }

    @objc public func hasPlusButton() -> Bool {
        customTabBarHasPlusButton()
    }

    @objc public func allItemsInTabBarCount() -> UInt {
        var count = TFYSwiftTabbarItemsCount
        if hasPlusButton() { count += 1 }
        return count
    }

    @objc public func appDelegate() -> UIApplicationDelegate? {
        UIApplication.shared.delegate
    }

    @objc public func rootWindow() -> UIWindow {
        tfy_getRootWindow() ?? UIWindow()
    }

    public func reloadTabBarItems(withAttributes tabBarItemsAttributes: [[AnyHashable: Any]]) {
        guard !isFlatDesignStyle else { return }
        self.tabBarItemsAttributes = tabBarItemsAttributes
        invokeOnceViewDidLayoutSubViewsBlock = true
        lottieViewAdded = false
        lottieURLs.removeAllObjects()
        lottieSizes.removeAllObjects()
        let index = selectedIndex
        let selected = _storedViewControllers?[safe: index]
        let superView = selected?.view.superview
        var vcs = _storedViewControllers ?? []
        if hasPlusChildViewController(), Int(TFYSwiftPlusButtonIndex) < vcs.count {
            vcs.remove(at: Int(TFYSwiftPlusButtonIndex))
        }
        viewControllers = vcs
        view.setNeedsLayout()
        selectedIndex = index
        if let selected, let superView {
            superView.addSubview(selected.view)
        }
    }

    @objc public func visiableTabBarSize() -> CGSize {
        (tfy_tabBarController?.tabBar as? UITabBar)?.tfy_boundsSize() ?? .zero
    }

    @objc public func setTintColor(_ tintColor: UIColor) {
        guard !isFlatDesignStyle else { return }
        (tfy_cylTabBar as? UITabBar)?.tintColor = tintColor
    }

    @objc public func updateSelectionStatusIfNeeded(
        for tabBarController: UITabBarController?,
        shouldSelectViewController viewController: UIViewController
    ) {
        let should = viewController !== (tabBarController ?? self).selectedViewController
        updateSelectionStatusIfNeeded(
            for: tabBarController,
            shouldSelectViewController: viewController,
            shouldSelect: should
        )
        guard let tabBar = (tabBarController ?? self).tabBar as? TFYSwiftTabBar else { return }
        if should, tabBar.tfy_shouldUpdateHiddenStatueForPlusButtonLabel() {
            TFYSwiftExternPlusButton?.setTabLabelHidden(viewController === TFYSwiftPlusChildViewController)
        }
        if (tabBarController ?? self).selectedViewController === TFYSwiftPlusChildViewController,
           tabBar.tfy_shouldUpdateHiddenStatueForPlusButtonLabel(), !should {
            TFYSwiftExternPlusButton?.setTabLabelHidden(true)
        }
    }

    @objc public func updateSelectionStatusIfNeeded(
        for tabBarController: UITabBarController?,
        shouldSelectViewController viewController: UIViewController,
        shouldSelect: Bool
    ) {
        guard !isFlatDesignStyle else { return }
        viewController.tabBarItem.tfy_tabButton?.tfy_userInteractionDisabled = !shouldSelect
        guard shouldSelect, hasPlusChildViewController() else { return }
        let plusButton = TFYSwiftExternPlusButton
        let isCurrent = viewController.tfy_isEqualToViewController(TFYSwiftPlusChildViewController ?? UIViewController())
        if plusButton?.isSelected == true, !isCurrent {
            plusButton?.isSelected = false
        }
        if isCurrent {
            NotificationCenter.default.post(name: .TFYSwiftTabBarItemLottieAnimationPlaying, object: self)
        }
    }

    // MARK: - KVO

    open override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard context == UnsafeMutableRawPointer(&Self.tabImageViewDefaultOffsetContext) else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if let offset = change?[.newKey] as? CGFloat {
            offsetTabBarTabImageViewToFit(offset)
        } else if let number = change?[.newKey] as? NSNumber {
            offsetTabBarTabImageViewToFit(number.doubleValue)
        }
    }

    // MARK: - View Controllers Setup

    @objc public func tfy_applyViewControllers(_ viewControllers: [UIViewController]?) {
        setViewControllers(viewControllers)
    }

    @objc(tfy_setViewControllers:)
    public func setViewControllers(_ viewControllers: [UIViewController]?) {
        if isFlatDesignStyle {
            _storedViewControllers = viewControllers
            _ = tfy_cylTabBar
            tfy_flatDesignSetViewControllers(viewControllers)
            return
        }

        if let existing = _storedViewControllers, !existing.isEmpty {
            for vc in existing {
                vc.willMove(toParent: nil)
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
            if hasPlusChildViewController(), !isPlusViewControllerAdded(existing),
               let plusChild = TFYSwiftPlusChildViewController {
                plusChild.willMove(toParent: nil)
                plusChild.view.removeFromSuperview()
                plusChild.removeFromParent()
            }
        }

        guard let viewControllers, !viewControllers.isEmpty else {
            _storedViewControllers?.forEach {
                $0.tfy_getViewControllerInsteadOfNavigationController().tfy_setTabBarController(nil)
                $0.tfy_setTabBarController(nil)
            }
            commitViewControllersToSuper(nil)
            return
        }

        alignTabControlIfNeeded(with: viewControllers)
        TFYSwiftTabbarItemsCount = UInt(viewControllers.count)

        guard tfy_cylTabBar is TFYSwiftTabBar, let tabBar = tfy_cylTabBar as? TFYSwiftTabBar else {
            commitViewControllersToSuper(viewControllers)
            return
        }

        TFYSwiftTabBarItemWidth = (tabBar.tfy_boundsSize().width - TFYSwiftPlusButtonWidth) / CGFloat(TFYSwiftTabbarItemsCount)
        var idx = 0
        for viewController in _storedViewControllers ?? viewControllers {
            var title: String?
            var normalImageInfo: Any?
            var selectedImageInfo: Any?
            var titleAdj = UIOffset.zero
            var imageAdj = UIOffset.zero
            var insets = UIEdgeInsets.zero
            var lottieURL: URL?
            var lottieSizeValue: NSValue?

            if viewController !== TFYSwiftPlusChildViewController {
                if tabBarItemsAttributes.count > idx {
                    let attrs = tabBarItemsAttributes[idx]
                    if #available(iOS 13.0, *) {
                        title = (attrs[TFYSwiftTabBarItemTitle] as? String) ?? ""
                    } else {
                        title = attrs[TFYSwiftTabBarItemTitle] as? String
                    }
                    normalImageInfo = attrs[TFYSwiftTabBarItemImage]
                    selectedImageInfo = attrs[TFYSwiftTabBarItemSelectedImage]
                    lottieURL = attrs[TFYSwiftTabBarLottieURL] as? URL
                    if lottieURL == nil, let path = attrs[TFYSwiftTabBarLottieFilePath] as? String {
                        lottieURL = TFYSwiftConstants.tfy_getURL(from: path)
                    }
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
                }
            } else {
                title = ""
                viewController.tabBarItem.title = ""
                if !(TFYSwiftConstants.isLiquidGlassActive() && hasPlusButton()) {
                    idx -= 1
                }
            }

            addOneChildViewController(
                viewController,
                withTitle: title,
                normalImageInfo: normalImageInfo,
                selectedImageInfo: selectedImageInfo,
                titlePositionAdjustment: titleAdj,
                imagePositionAdjustment: imageAdj,
                imageInsets: insets,
                lottieURL: lottieURL,
                lottieSizeValue: lottieSizeValue
            )

            wireTabBarControllerReferences(for: viewController)
            idx += 1
        }
        // UITabBarController only installs tab buttons in the superclass setter.
        // OC `@synthesize viewControllers = _viewControllers` has no Swift equivalent.
        commitViewControllersToSuper(_storedViewControllers)
    }

    // MARK: - Private — Tab Bar Setup

    private func setUpDefaultStyleTabBar() {
        setUpTabBar(nil)
    }

    private func setUpTabBar(_ customTabBar: UIView?) {
        let bar: TFYSwiftTabBar
        if let custom = customTabBar as? TFYSwiftTabBar {
            bar = custom
        } else {
            bar = TFYSwiftTabBar()
            bar.tfy_setTabBarController(self)
        }
        _cylTabBar = bar
        tfy_setValue(bar, forKey: "tabBar")
        setUpIPAD(for: bar)
    }

    private func setUpIPAD(for tabBar: TFYSwiftTabBar) {
        if #available(iOS 18.0, *), UIDevice.current.userInterfaceIdiom == .pad {
            mode = .tabBar
            traitOverrides.horizontalSizeClass = .compact
            view.addSubview(tabBar)
            let containerClass = "_UITabContainerView"
            var setupSuccess = false
            for subview in view.subviews where String(describing: type(of: subview)) == containerClass {
                subview.isHidden = true
                setupSuccess = true
            }
            if !setupSuccess {
                tfy_cylTabBar.removeFromSuperview()
                view.addSubview(tfy_cylTabBar)
            }
        }
    }

    private var tabBarFrame: CGRect {
        let height = tabBarHeight + view.safeAreaInsets.bottom
        return CGRect(x: 0, y: view.bounds.height - height, width: view.bounds.width, height: height)
    }

    private func applyTabBarStyleType(_ styleType: TFYSwiftTabBarStyleType) {
        var resolved = styleType
        if tfy_isIOS27, styleType == .default {
            let requiresCompat = Bundle.main.object(forInfoDictionaryKey: "UIDesignRequiresCompatibility") as? Bool ?? false
            if requiresCompat { resolved = .flatDesign }
        }
        switch resolved {
        case .default, .system, .liquidGlass:
            noNeedUIDesignCompatibility = true
        case .flatDesign:
            noNeedUIDesignCompatibility = false
        @unknown default:
            noNeedUIDesignCompatibility = true
        }
    }

    // MARK: - Private — Plus Button Alignment

    private func hasPlusChildViewController() -> Bool {
        customTabBarHasPlusChildViewController()
    }

    /// OC `CYL_PERFORM_SELECTOR_BOOL(self.cyl_tabBar, hasPlusButton)` — FlatDesign is not `TFYSwiftTabBar`.
    private func customTabBarHasPlusButton() -> Bool {
        if let bar = tfy_cylTabBar as? TFYSwiftTabBar { return bar.hasPlusButton() }
        if let bar = tfy_cylTabBar as? TFYSwiftFlatDesignTabBar { return bar.hasPlusButton() }
        return false
    }

    private func customTabBarHasPlusChildViewController() -> Bool {
        if let bar = tfy_cylTabBar as? TFYSwiftTabBar { return bar.hasPlusChildViewController() }
        if let bar = tfy_cylTabBar as? TFYSwiftFlatDesignTabBar { return bar.hasPlusChildViewController() }
        return false
    }

    private func isPlusViewControllerAdded(_ viewControllers: [UIViewController]?) -> Bool {
        tfy_isPlusViewControllerAdded(viewControllers ?? [])
    }

    private func addChildViewControllerIfNeeded(_ viewController: UIViewController) {
        guard !viewController.tfy_isPlaceholder else { return }
        guard !viewController.tfy_getViewControllerInsteadOfNavigationController().tfy_isPlaceholder else { return }
        addChild(viewController)
    }

    private func isEmbedInTabBarController(_ viewController: UIViewController) -> Bool {
        let resolved = viewController.tfy_getViewControllerInsteadOfNavigationController()
        guard viewController.tfy_tabBarController != nil || resolved.tfy_tabBarController != nil else { return false }
        if viewController.tfy_isPlaceholder || resolved.tfy_isPlaceholder { return false }
        guard let vcs = viewController.tfy_tabBarController?.viewControllers else { return false }
        return vcs.contains { $0.tfy_getViewControllerInsteadOfNavigationController() === resolved }
    }

    func alignTabControlIfNeeded(with viewControllers: [UIViewController]) {
        if isFlatDesignStyle {
            alignFlatDesignTabControlIfNeeded(with: viewControllers)
            return
        }
        guard customTabBarHasPlusButton() else {
            _storedViewControllers = viewControllers
            return
        }
        doubleCheckTabControlAlign(with: _storedViewControllers ?? viewControllers)
        let isAdded = isPlusViewControllerAdded(_storedViewControllers ?? [])
        let addedFlag = TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded ?? false
        let hasPlusChild = hasPlusChildViewController() && !isAdded && !addedFlag

        if hasPlusChild {
            alignTabControlIfNeededWithPlusChild(from: viewControllers)
            TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded = true
        } else {
            TFYSwiftExternPlusButton?.tfy_tabBarChildViewControllerIndex = NSNotFound
        }

        if !TFYSwiftConstants.isLiquidGlassActive() {
            if !hasPlusChild { _storedViewControllers = viewControllers }
            return
        }
        if !hasPlusButton() {
            if !hasPlusChild { _storedViewControllers = viewControllers }
            return
        }
        guard tfy_cylTabBar is TFYSwiftTabBar else {
            if !hasPlusChild { _storedViewControllers = viewControllers }
            return
        }

        if hasPlusButton(), TFYSwiftConstants.isLiquidGlassActive() {
            alignTabControlIfNeededWithPlusChild(from: viewControllers)
            let plusInfo: [AnyHashable: Any] = [
                TFYSwiftTabBarItemTitle: "",
                TFYSwiftTabBarItemImage: UIImage.tfy_tabItemPlaceholderImage() as Any,
                TFYSwiftTabBarItemSelectedImage: UIImage.tfy_tabItemPlaceholderImage() as Any
            ]
            tabBarItemsAttributes = alignViewControllers(tabBarItemsAttributes, withPlusPlaceholder: plusInfo)
        }
        doubleCheckTabControlAlign(with: _storedViewControllers ?? viewControllers)
    }

    /// OC `alignTabControlIfNeededWithViewControllers:` FlatDesign branch — insert plus child + placeholder attrs.
    private func alignFlatDesignTabControlIfNeeded(with viewControllers: [UIViewController]) {
        guard tfy_cylTabBar is TFYSwiftFlatDesignTabBar else { return }
        guard customTabBarHasPlusButton() else {
            _storedViewControllers = viewControllers
            return
        }
        doubleCheckTabControlAlign(with: _storedViewControllers ?? viewControllers)
        let isAdded = isPlusViewControllerAdded(_storedViewControllers ?? [])
        let addedFlag = TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded ?? false
        let hasPlusChild = hasPlusChildViewController() && !isAdded && !addedFlag
        if hasPlusChild {
            alignTabControlIfNeededWithPlusChild(from: viewControllers)
            TFYSwiftPlusChildViewController?.tfy_plusViewControllerEverAdded = true
        } else {
            TFYSwiftExternPlusButton?.tfy_tabBarChildViewControllerIndex = NSNotFound
        }
        guard customTabBarHasPlusButton(), tfy_cylTabBar is TFYSwiftFlatDesignTabBar else {
            if !hasPlusChild { _storedViewControllers = viewControllers }
            return
        }
        alignTabControlIfNeededWithPlusChild(from: viewControllers)
        let plusInfo: [AnyHashable: Any] = [
            TFYSwiftTabBarItemTitle: "",
            TFYSwiftTabBarItemImage: UIImage.tfy_tabItemPlaceholderImage() as Any,
            TFYSwiftTabBarItemSelectedImage: UIImage.tfy_tabItemPlaceholderImage() as Any
        ]
        tabBarItemsAttributes = alignViewControllers(tabBarItemsAttributes, withPlusPlaceholder: plusInfo)
        doubleCheckTabControlAlign(with: _storedViewControllers ?? viewControllers)
    }

    private func alignTabControlIfNeededWithPlusChild(from viewControllers: [UIViewController]) {
        guard customTabBarHasPlusButton() else {
            _storedViewControllers = viewControllers
            return
        }
        let placeholder: UIViewController
        if hasPlusChildViewController() {
            placeholder = TFYSwiftPlusChildViewController!
        } else {
            let vc = UIViewController()
            vc.tfy_isPlaceholder = true
            placeholder = vc
        }
        _storedViewControllers = alignViewControllers(viewControllers, withPlusPlaceholder: placeholder)
        TFYSwiftExternPlusButton?.tfy_tabBarChildViewControllerIndex = NSNotFound
    }

    private func alignViewControllers<T>(_ array: [T], withPlusPlaceholder placeholder: T) -> [T] {
        guard customTabBarHasPlusButton() else { return array }
        var result = array
        let plusIndex = Int(TFYSwiftPlusButtonIndex != 0 ? TFYSwiftPlusButtonIndex : UInt(array.count / 2))
        guard result.count > plusIndex else { return result }
        result.insert(placeholder, at: plusIndex)
        TFYSwiftExternPlusButton?.tfy_tabBarItemVisibleIndex = Int(plusIndex)
        if let vc = placeholder as? UIViewController {
            addChildViewControllerIfNeeded(vc)
        }
        return result
    }

    private func doubleCheckTabControlAlign(with viewControllers: [UIViewController]?) {
        let vcs = viewControllers ?? _storedViewControllers
        guard let vcs, tabBarItemsAttributes.count == vcs.count else {
            #if DEBUG
            assertionFailure("tabBarItemsAttributes count must match viewControllers count")
            #endif
            return
        }
    }

    // MARK: - Private — Child VC

    private func addOneChildViewController(
        _ viewController: UIViewController,
        withTitle title: String?,
        normalImageInfo: Any?,
        selectedImageInfo: Any?,
        titlePositionAdjustment: UIOffset,
        imagePositionAdjustment: UIOffset,
        imageInsets: UIEdgeInsets,
        lottieURL: URL?,
        lottieSizeValue: NSValue?
    ) {
        viewController.tabBarItem.title = title
        viewController.tfy_getViewControllerInsteadOfNavigationController().tabBarItem.title = title
        let normalImage = UIImage.tfy_imageNamed(normalImageInfo)
        viewController.tabBarItem.image = normalImage
        viewController.tabBarItem.selectedImage = UIImage.tfy_imageNamed(selectedImageInfo)

        var insets = imageInsets
        if insets == .zero { insets = self.imageInsets }
        viewController.tabBarItem.imageInsets = insets

        var titleOffset = titlePositionAdjustment
        if titleOffset == .zero { titleOffset = self.titlePositionAdjustment }
        viewController.tabBarItem.titlePositionAdjustment = titleOffset

        var imageOffset = imagePositionAdjustment
        if imageOffset == .zero { imageOffset = self.imagePositionAdjustment }
        viewController.tabBarItem.tfy_imagePositionAdjustment = imageOffset

        if let lottieURL {
            lottieURLs.add(lottieURL)
            viewController.tabBarItem.tfy_lottieURL = lottieURL
            viewController.tfy_getViewControllerInsteadOfNavigationController().tabBarItem.tfy_lottieURL = lottieURL
            let trueSize = TFYSwiftConstants.tfy_getTrueLottieSizeValue(lottieSizeValue, fromNormalImage: normalImage)
            lottieSizes.add(trueSize)
            viewController.tabBarItem.tfy_lottieSizeValue = trueSize
            viewController.tfy_getViewControllerInsteadOfNavigationController().tabBarItem.tfy_lottieSizeValue = trueSize
        }
    }

    private func wireTabBarControllerReferences(for viewController: UIViewController) {
        viewController.tfy_setTabBarController(self)
        viewController.tfy_getViewControllerInsteadOfNavigationController().tfy_setTabBarController(self)
        (viewController.tfy_getActualBadgeSuperView() as? NSObject)?.tfy_setTabBarController(self)
        (viewController.tfy_getViewControllerInsteadOfNavigationController().tfy_getActualBadgeSuperView() as? NSObject)?.tfy_setTabBarController(self)
        (viewController.tabBarItem.tfy_getActualBadgeSuperView() as? NSObject)?.tfy_setTabBarController(self)
        (viewController.tfy_getViewControllerInsteadOfNavigationController().tabBarItem.tfy_getActualBadgeSuperView() as? NSObject)?.tfy_setTabBarController(self)
    }

    // MARK: - Private — Selection / Lottie

    private func didSelectControl(_ control: UIControl) {
        var shouldSelect = true
        if !control.tfy_userInteractionDisabled, !control.isHidden {
            shouldSelect = true
        } else {
            shouldSelect = false
        }

        let contentControl = control
        var selectedContentControl: UIControl?
        if let tabBar = tfy_cylTabBar as? TFYSwiftTabBar {
            selectedContentControl = tabBar.tfy_selectedContentControl(fromContentControl: control)
            if control.tfy_isPlusControl() {
                tabBar.tfy_setSelectedControl(TFYSwiftExternPlusButton)
            } else {
                tabBar.tfy_setSelectedControl(selectedContentControl ?? contentControl)
            }
            if shouldSelect {
                tabBar.tfy_visibleControls().forEach { $0.isSelected = false }
                tabBar.tfy_platterSelectedContentViews().forEach { $0.isSelected = false }
                contentControl.isSelected = true
                selectedContentControl?.isSelected = true
            }
        }

        let delegateControl = control
        beginShowPlatterLiquidLensView(for: delegateControl)
        if TFYSwiftConstants.isLiquidGlassActive(),
           let cover = TFYSwiftExternPlusButton?.selectedContentView {
            alignLiquidGlassPlusSelectedCover(cover)
        }
        if shouldSelect,
           let delegate = delegate as? TFYSwiftTabBarControllerDelegate {
            delegate.tabBarController?(self, didSelectControl: delegateControl)
        }
    }

    private func beginShowPlatterLiquidLensView(for control: UIControl) {
        guard TFYSwiftConstants.isLiquidGlassActive(), let tabBar = tabBar as? TFYSwiftTabBar else { return }
        var shouldShow = true
        if let delegate = delegate as? TFYSwiftTabBarControllerDelegate {
            shouldShow = delegate.tabBarController?(self, shouldShowPlatterLiquidLensViewForControl: control) ?? true
        } else {
            shouldShow = tabBarController(self, shouldShowPlatterLiquidLensViewForControl: control)
        }
        if shouldShow {
            tabBar.tfy_platterLiquidLensViewContentView()?.tfy_setHidden(false)
            tabBar.liquidGlassContinuousGestureRecognizer?.isEnabled = true
            tabBar.liquidGlassLongGestureRecognizer?.isEnabled = true
        } else {
            tabBar.tfy_platterLiquidLensViewContentView()?.tfy_setHidden(true)
            tabBar.liquidGlassContinuousGestureRecognizer?.isEnabled = false
            tabBar.liquidGlassLongGestureRecognizer?.isEnabled = false
        }
    }

    private func isLottieEnabled() -> Bool {
        TFYSwiftConstants.isLottieEnabled(fromLottieURLs: lottieURLs, tabBarItemsAttributes: tabBarItemsAttributes)
    }

    private func initLottieTabBar(_ tabBar: TFYSwiftTabBar) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if TFYSwiftConstants.isLiquidGlassActive() {
                self.viewControllers?.enumerated().forEach { idx, viewController in
                    guard let control = viewController.tfy_tabButton,
                          let url = viewController.tabBarItem.tfy_lottieURL,
                          self.isEmbedInTabBarController(viewController),
                          !control.tfy_isPlusControl() else { return }
                    let defaultSelected = idx == self.selectedIndex
                    self.addLottieImage(
                        with: control,
                        lottieURL: url,
                        lottieSizeValue: viewController.tabBarItem.tfy_lottieSizeValue,
                        animation: defaultSelected,
                        defaultSelected: defaultSelected
                    )
                    self.lottieViewAdded = true
                }
            } else {
                tabBar.tfy_subTabBarButtonsWithoutPlusButton().enumerated().forEach { idx, control in
                    let defaultSelected = idx == self.selectedIndex
                    self.addLottieImage(with: control, animation: defaultSelected, defaultSelected: defaultSelected)
                    self.lottieViewAdded = true
                }
            }
        }
    }

    private func addLottieImage(with control: UIControl, animation: Bool) {
        addLottieImage(with: control, lottieURL: nil, lottieSizeValue: nil, animation: animation)
    }

    private func addLottieImage(
        with control: UIControl,
        lottieURL: URL?,
        lottieSizeValue: NSValue?,
        animation: Bool,
        defaultSelected: Bool = false
    ) {
        if control.tfy_isPlusControl() { return }

        var url = lottieURL
        var sizeValue = lottieSizeValue
        if let tabBar = tfy_cylTabBar as? TFYSwiftTabBar,
           let index = tabBar.tfy_subTabBarButtons().firstIndex(of: control) {
            if url == nil, index < lottieURLs.count {
                url = lottieURLs[index] as? URL
            }
            if sizeValue == nil, index < lottieSizes.count {
                sizeValue = lottieSizes[index] as? NSValue
            }
        }

        guard let url, let sizeValue else { return }
        let size = sizeValue.cgSizeValue
        control.tfy_addLottieImage(withLottieURL: url, size: size, contentMode: lottieAnimationViewContentMode())
        guard let tabBar = tfy_cylTabBar as? TFYSwiftTabBar else { return }
        let selectedContent = tabBar.tfy_selectedContentControl(fromContentControl: control)
        selectedContent?.tfy_addLottieImage(withLottieURL: url, size: size, contentMode: lottieAnimationViewContentMode())
        if animation {
            tabBar.tfy_animationLottieImage(
                withSelectedControl: control,
                lottieURL: url,
                size: size,
                defaultSelected: defaultSelected,
                contentMode: lottieAnimationViewContentMode()
            )
            if let selectedContent {
                tabBar.tfy_animationLottieImage(
                    withSelectedControl: selectedContent,
                    lottieURL: url,
                    size: size,
                    defaultSelected: defaultSelected,
                    contentMode: lottieAnimationViewContentMode()
                )
            }
        }
    }

    private func addLottieImage(
        with control: UIControl,
        lottieURL: URL?,
        lottieSizeValue: NSValue?,
        animation: Bool
    ) {
        addLottieImage(
            with: control,
            lottieURL: lottieURL,
            lottieSizeValue: lottieSizeValue,
            animation: animation,
            defaultSelected: false
        )
    }

    private func addLottieImage(with control: UIControl, animation: Bool, defaultSelected: Bool) {
        if TFYSwiftConstants.isLiquidGlassActive() {
            addLottieImage(with: control, lottieURL: nil, lottieSizeValue: nil, animation: animation, defaultSelected: defaultSelected)
            return
        }
        guard let tabBar = tfy_cylTabBar as? TFYSwiftTabBar else { return }
        let index = tabBar.tfy_subTabBarButtonsWithoutPlusButton().firstIndex(of: control) ?? NSNotFound
        guard index != NSNotFound, !control.tfy_isPlusButton() else { return }
        let url = lottieURLs[index] as? URL
        let sizeValue = lottieSizes[index] as? NSValue
        guard let url, let sizeValue else { return }
        let size = sizeValue.cgSizeValue
        control.tfy_addLottieImage(withLottieURL: url, size: size, contentMode: lottieAnimationViewContentMode())
        if animation {
            tabBar.tfy_animationLottieImage(
                withSelectedControl: control,
                lottieURL: url,
                size: size,
                defaultSelected: defaultSelected,
                contentMode: lottieAnimationViewContentMode()
            )
        }
    }

    // MARK: - Private — Misc

    private func removePlusButtonIfNeeded() {
        guard hasPlusButton() else { return }
        if let type = TFYSwiftExternPlusButton.map({ type(of: $0) }),
           let plusType = type as? TFYSwiftPlusButtonSubclassing.Type,
           let plusContext = plusType.tabBarContext?(),
           plusContext != tfy_context {
            TFYSwiftPlusButton.removePlusButton()
        }
    }

    private func applyContext(_ context: String?) {
        guard !isFlatDesignStyle else { return }
        if let context, !context.isEmpty {
            tfy_context = context
        }
        if let bar = tfy_cylTabBar as? TFYSwiftTabBar {
            bar.context = tfy_context
            bar.setValue(tfy_context, forKey: "context")
        }
    }

    private func offsetTabBarTabImageViewToFit(_ tabImageViewDefaultOffset: CGFloat) {
        guard titlePositionAdjustment == .zero, imageInsets == .zero else { return }
        guard let items = (tfy_cylTabBar as? UITabBar)?.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: tabImageViewDefaultOffset, left: 0, bottom: -tabImageViewDefaultOffset, right: 0)
            if titlePositionAdjustment == .zero {
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: .greatestFiniteMagnitude)
            }
        }
    }

    private func fixTabBarTransparencyIfNeeded() {
        guard tfy_systemVersionGreaterThanOrEqualTo("15.0"), !TFYSwiftConstants.isLiquidGlassActive() else { return }
        guard UITabBar.appearance().backgroundImage == nil else { return }
        if let bg = tfy_cylTabBar.tfy_tabBackgroundView()?.tfy_tabEffectView() {
            bg.alpha = 1
        }
        if let shadow = tfy_cylTabBar.tfy_tabShadowImageView()?.subviews.first {
            shadow.alpha = 1
        }
    }

    private func configureLiquidGlassPlusButtonIfNeeded() {
        guard TFYSwiftConstants.isLiquidGlassActive(), hasPlusButton(), tfy_cylTabBar is TFYSwiftTabBar else { return }
        guard let plusIndex = TFYSwiftExternPlusButton?.tfy_tabBarItemVisibleIndex,
              let plusOrigin = (tfy_cylTabBar as? TFYSwiftTabBar)?.tfy_platterContentViewWithIndex(plusIndex) else { return }
        let selectedCover = TFYSwiftExternPlusButton?.resolveSelectedContentView()
        let plusSelected = plusOrigin.tfy_platterSelectedControl()
        plusOrigin.tfy_tabImageView()?.tfy_setHidden(true)
        plusOrigin.tfy_swappableImageViewViewInTabBarButton()?.tfy_setHidden(true)
        plusOrigin.tfy_tabLabel()?.isHidden = true
        plusSelected?.tfy_tabLabel()?.isHidden = true

        let delay: TimeInterval = 0.5
        if hasPlusChildViewController(), let selectedCover, let plusSelected {
            plusSelected.tfy_coverTabImageViewOrTabButton(
                true,
                newView: selectedCover,
                offset: UIOffset.zero,
                show: true,
                delayIfNeededForSeconds: delay
            ) { [weak self] _, _, cover in
                guard let self, let cover else { return }
                self.alignLiquidGlassPlusSelectedCover(cover)
                TFYSwiftExternPlusButton?.setTabLabelHidden(
                    self.selectedViewController === TFYSwiftPlusChildViewController
                )
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                plusSelected?.tfy_tabImageView()?.tfy_setHidden(true)
                plusSelected?.tfy_swappableImageViewViewInTabBarButton()?.tfy_setHidden(true)
                plusSelected?.tfy_tabLabel()?.isHidden = true
            }
        }
    }

    private func alignLiquidGlassPlusSelectedCover(_ cover: UIView) {
        guard let plus = TFYSwiftExternPlusButton, let platterView = plus.superview else { return }
        cover.backgroundColor = .clear
        cover.isOpaque = false
        cover.clipsToBounds = false
        cover.isUserInteractionEnabled = false
        if let container = cover.superview {
            cover.center = container.convert(plus.center, from: platterView)
        }
    }

    private func invokeLayoutBlockIfNeeded() {
        if invokeOnceViewDidLayoutSubViewsBlock {
            let key = "shouldInvokeOnceViewDidLayoutSubViewsBlock"
            if objc_getAssociatedObject(self, key) != nil { return }
            viewDidLayoutSubviewsBlock?(self)
            objc_setAssociatedObject(self, key, key, .OBJC_ASSOCIATION_RETAIN)
        } else {
            viewDidLayoutSubviewsBlock?(self)
        }
    }

}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
