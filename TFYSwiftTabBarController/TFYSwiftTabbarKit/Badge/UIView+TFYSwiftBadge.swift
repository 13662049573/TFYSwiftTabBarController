//
//  UIView+TFYSwiftBadge.swift
//  TFYSwiftTabBarController
//
//  Converted from UIView+CYLBadgeExtention (core badge with associated objects)
//

import ObjectiveC
import UIKit

private let tfyBadgeDefaultMaximumBadgeNumber = 99
private let tfyBadgeDefaultMargin: CGFloat = 8
private let tfyBadgeDefaultDelayIfNeededForSeconds: CGFloat = 0.5
private let tfyBadgeDefaultRedDotRadius: CGFloat = 4

public extension UIView {

    // MARK: - TFYSwiftBadgeProtocol storage

    @objc var tfy_badge: UIView? {
        get { objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badge) as? UIView }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badge, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    @objc var tfy_badgeFont: UIFont? {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeFont) as? UIFont) ?? TFYSwiftBadgeDefaultFont }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeFont, newValue, .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
            tfy_applyBadgeTextProperty { $0.font = newValue ?? TFYSwiftBadgeDefaultFont }
        }
    }

    @objc var tfy_badgeBackgroundColor: UIColor? {
        get { objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeBackgroundColor) as? UIColor }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
            tfy_badge?.backgroundColor = newValue
        }
    }

    @objc var tfy_badgeTextColor: UIColor? {
        get { objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeTextColor) as? UIColor }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeTextColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
            tfy_applyBadgeTextProperty { $0.textColor = newValue ?? .white }
        }
    }

    @objc var tfy_badgeAnimationType: TFYSwiftBadgeAnimationType {
        get {
            if let number = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeAnimationType) as? NSNumber {
                return TFYSwiftBadgeAnimationType(rawValue: number.uintValue) ?? .none
            }
            return .none
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeAnimationType, NSNumber(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
            tfy_removeAnimation()
            tfy_beginAnimation()
        }
    }

    @objc var tfy_badgeAnimationTypeValue: NSNumber? {
        get { NSNumber(value: tfy_badgeAnimationType.rawValue) }
        set { tfy_badgeAnimationType = TFYSwiftBadgeAnimationType(rawValue: newValue?.uintValue ?? 0) ?? .none }
    }

    @objc var tfy_badgeFrame: CGRect {
        get {
            guard let dict = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeFrame) as? [String: NSNumber], dict.count == 4 else {
                return .zero
            }
            return CGRect(
                x: dict["x"]?.doubleValue ?? 0,
                y: dict["y"]?.doubleValue ?? 0,
                width: dict["width"]?.doubleValue ?? 0,
                height: dict["height"]?.doubleValue ?? 0
            )
        }
        set {
            let frameInfo: [String: NSNumber] = [
                "x": NSNumber(value: Double(newValue.origin.x)),
                "y": NSNumber(value: Double(newValue.origin.y)),
                "width": NSNumber(value: Double(newValue.size.width)),
                "height": NSNumber(value: Double(newValue.size.height))
            ]
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeFrame, frameInfo, .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
            tfy_badge?.frame = newValue
        }
    }

    @objc var tfy_badgeFrameValue: NSValue? {
        get { NSValue(cgRect: tfy_badgeFrame) }
        set { tfy_badgeFrame = newValue?.cgRectValue ?? .zero }
    }

    @objc var tfy_badgeCenterOffset: CGPoint {
        get {
            guard let dict = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeCenterOffset) as? [String: NSNumber], dict.count == 2 else {
                return .zero
            }
            return CGPoint(x: dict["x"]?.doubleValue ?? 0, y: dict["y"]?.doubleValue ?? 0)
        }
        set {
            let centerInfo: [String: NSNumber] = [
                "x": NSNumber(value: Double(newValue.x)),
                "y": NSNumber(value: Double(newValue.y))
            ]
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeCenterOffset, centerInfo, .OBJC_ASSOCIATION_RETAIN)
            if tfy_shouldUpdateBadgeSubviews() { return }
            tfy_badgeInitIfNeeded()
            tfy_badge?.center = CGPoint(x: bounds.width + 2 + newValue.x, y: newValue.y)
        }
    }

    @objc var tfy_badgeCenterOffsetValue: NSValue? {
        get { NSValue(cgPoint: tfy_badgeCenterOffset) }
        set { tfy_badgeCenterOffset = newValue?.cgPointValue ?? .zero }
    }

    @objc var tfy_badgeMaximumBadgeNumber: Int {
        get {
            (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeMaximumBadgeNumber) as? NSNumber)?.intValue ?? tfyBadgeDefaultMaximumBadgeNumber
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeMaximumBadgeNumber, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
        }
    }

    @objc var tfy_badgeMaximumBadgeNumberValue: NSNumber? {
        get { NSNumber(value: tfy_badgeMaximumBadgeNumber) }
        set { tfy_badgeMaximumBadgeNumber = newValue?.intValue ?? tfyBadgeDefaultMaximumBadgeNumber }
    }

    @objc var tfy_badgeRadius: CGFloat {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeRadius) as? NSNumber)?.CGFloatValue ?? 0 }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeRadius, NSNumber(value: Double(newValue)), .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
        }
    }

    @objc var tfy_badgeRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeRadius)) }
        set { tfy_badgeRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc var tfy_badgeMargin: CGFloat {
        get {
            if let margin = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeMargin) as? NSNumber {
                return CGFloat(margin.doubleValue)
            }
            return tfyBadgeDefaultMargin
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeMargin, NSNumber(value: Double(newValue)), .OBJC_ASSOCIATION_RETAIN)
            tfy_badgeInitIfNeeded()
        }
    }

    @objc var tfy_badgeMarginValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeMargin)) }
        set { tfy_badgeMargin = CGFloat(newValue?.doubleValue ?? Double(tfyBadgeDefaultMargin)) }
    }

    @objc var tfy_badgeCornerRadius: CGFloat {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeCornerRadius) as? NSNumber)?.CGFloatValue ?? 0 }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeCornerRadius, NSNumber(value: Double(newValue)), .OBJC_ASSOCIATION_RETAIN) }
    }

    @objc var tfy_badgeCornerRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeCornerRadius)) }
        set { tfy_badgeCornerRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc var tfy_delayIfNeededForSeconds: CGFloat {
        get {
            (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.delayIfNeededForSeconds) as? NSNumber)?.CGFloatValue ?? tfyBadgeDefaultDelayIfNeededForSeconds
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.delayIfNeededForSeconds, NSNumber(value: Double(newValue)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc var tfy_keepShowingPlusButtonLabel: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.keepShowingPlusButtonLabel) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.keepShowingPlusButtonLabel, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // MARK: - Public API

    @objc func tfy_isReady() -> Bool {
        guard tfy_badgeClass() != nil else { return false }
        if tfy_usesLiquidGlassBadgePlacement() {
            return bounds.width > 10 || tfy_enclosingTabBar() != nil
        }
        guard let view = tfy_getActualBadgeSuperView() as? UIView else { return false }
        return view.bounds.width > 10
    }

    @objc func tfy_showBadge() {
        tfy_showBadgeValue("", animationType: .none)
    }

    @objc func tfy_showBadgeValue(_ value: String?) {
        tfy_showBadgeValue(value, animationType: .none)
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationTypeValue: NSNumber?) {
        tfy_resetBadgeSubviewsIfNeeded()
        let animationType = TFYSwiftBadgeAnimationType(rawValue: animationTypeValue?.uintValue ?? 0) ?? .none
        tfy_badgeAnimationType = animationType
        tfy_showBadgeWithValue(value)
        if animationType != .none {
            tfy_beginAnimation()
        }
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType) {
        tfy_showBadgeValue(value, animationTypeValue: NSNumber(value: animationType.rawValue))
    }

    @objc func tfy_clearBadge() {
        tfy_badge?.tfy_setHidden(true)
    }

    @objc func tfy_isShowBadge() -> Bool {
        guard let badge = tfy_badge else { return false }
        return !badge.tfy_isHidden
    }

    @objc func tfy_resumeBadge() {
        if tfy_isPauseBadge() {
            tfy_badge?.tfy_setHidden(false)
        }
    }

    @objc func tfy_isPauseBadge() -> Bool {
        guard let badge = tfy_badge else { return false }
        return badge.tfy_isHidden
    }

    @objc func tfy_getActualBadgeSuperView() -> Any? {
        layoutIfNeeded()
        return self
    }

    @objc var tfy_isHidden: Bool {
        tfy_isInvisiable()
    }

    @objc func tfy_isInvisiable() -> Bool {
        let isSizeZero = frame.size == .zero
        return isHidden || alpha <= 0.01 || superview == nil || isSizeZero
    }

    @objc func tfy_isValidBadgeAnchor() -> Bool {
        !tfy_isInvisiable() && bounds.width > 10 && bounds.height > 10
    }

    @objc func tfy_unclipForBadge() {
        var node: UIView? = self
        while let current = node {
            current.clipsToBounds = false
            current.layer.masksToBounds = false
            if current is UITabBar { break }
            node = current.superview
        }
    }

    @objc func tfy_enclosingTabBar() -> UITabBar? {
        var node: UIView? = self
        while let current = node {
            if let tabBar = current as? UITabBar { return tabBar }
            node = current.superview
        }
        if let tabBar = tfy_tabBarController?.tabBar { return tabBar }
        var responder: UIResponder? = next
        while let current = responder {
            if let tabBar = current as? UITabBar { return tabBar }
            if let tab = current as? UITabBarController { return tab.tabBar }
            responder = current.next
        }
        return tfy_tabBarFromRootWindow()
    }

    /// OS liquid glass is still on in FlatDesign; only the liquid *style* should reparent onto UITabBar.
    func tfy_usesLiquidGlassBadgePlacement() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        var node: UIView? = self
        while let current = node {
            if current is TFYSwiftFlatDesignTabBar || current is TFYSwiftFlatDesignTabBarButton {
                return false
            }
            node = current.superview
        }
        if let tab = tfy_tabBarController, tab.tabBarStyleType == .flatDesign {
            return false
        }
        if tfy_tabBarFromRootWindow() is TFYSwiftFlatDesignTabBarHideTabBar {
            return false
        }
        return true
    }

    /// Liquid-glass `_UITabButton` often lives in a portal, not under `UITabBar`.
    private func tfy_tabBarFromRootWindow() -> UITabBar? {
        func bar(from root: UIViewController?) -> UITabBar? {
            guard let root else { return nil }
            if let tab = root as? UITabBarController { return tab.tabBar }
            if let nav = root as? UINavigationController {
                return bar(from: nav.viewControllers.first) ?? bar(from: nav.visibleViewController)
            }
            for child in root.children {
                if let found = bar(from: child) { return found }
            }
            return nil
        }
        return bar(from: tfy_getRootViewController())
    }

    @objc func tfy_canNotResponseEvent() -> Bool {
        tfy_isInvisiable() || !isUserInteractionEnabled || tfy_isPlaceholder
    }

    @objc func tfy_findBarButtonContentView() -> UIView {
        let classString = NSStringFromClass(type(of: self))
        if classString == "UITabBarButton" || classString == "_UITabButton" {
            return tfy_tabImageView() ?? self
        }
        if classString == "_UIButtonBarButton" {
            for case let button as UIButton in subviews {
                return button
            }
        }
        return self
    }

    // MARK: - Swizzle hook (iOS 11+)

    @objc func tfy_badge_willMove(toSuperview newSuperview: UIView?) {
        tfy_badge_willMove(toSuperview: newSuperview)
        // Read the associated badge on this view. UIControl.tfy_badge goes through
        // tab-image KVC, which throws on `_UIButtonBarButton` (nav bar, not a tab).
        guard newSuperview != nil else { return }
        let badge = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badge) as? UIView
        if let badge {
            tfy_bringBadgeToFront(badge)
        }
    }

    // MARK: - Private

    private func tfy_resetBadgeSubviewsIfNeeded() {
        tfy_badge?.subviews.forEach { $0.removeFromSuperview() }
        if tfy_shouldUpdateBadgeSubviews() {
            tfy_badge?.removeFromSuperview()
            tfy_badge = nil
        }
    }

    private func tfy_showBadgeWithValue(_ value: String?) {
        guard let value else { return }
        let trimmed = value.trimmingCharacters(in: .decimalDigits)
        let isNumber = trimmed.isEmpty && !value.isEmpty
        if isNumber, let intValue = Int(value) {
            tfy_showNumberBadgeWithValue(intValue)
            return
        }
        if value.isEmpty {
            tfy_showRedDotBadge()
            return
        }
        if value == "new" || value == "NEW" {
            tfy_showNewBadge(value)
            return
        }
        tfy_showTextBadge(value)
    }

    private func tfy_showRedDotBadge() {
        guard tfy_isReady() else { return }
        tfy_badgeInitIfNeeded()
        guard let badge = tfy_badge else { return }
        if badge.tag != Int(TFYSwiftBadgeStyle.redDot.rawValue) {
            tfy_setBadgeText("")
            badge.tag = Int(TFYSwiftBadgeStyle.redDot.rawValue)
            tfy_resetRedDotBadgeFrame()
            badge.layer.cornerRadius = badge.bounds.width / 2
        }
        badge.tfy_setHidden(false)
        tfy_unclipForBadge()
        tfy_bringBadgeToFront(badge)
    }

    private func tfy_showNewBadge(_ value: String) {
        guard tfy_badgeClass() != nil else { return }
        let font = tfy_badgeFont ?? TFYSwiftBadgeDefaultFont
        let size = (value as NSString).size(withAttributes: [.font: font])
        let labelHeight = ceil(size.height) + tfy_badgeMargin
        tfy_badgeCornerRadius = labelHeight / 3
        tfy_showTextBadge(value)
    }

    private func tfy_showTextBadge(_ value: String) {
        guard tfy_isReady() else { return }
        if value.isEmpty {
            tfy_badge?.tfy_setHidden(true)
            return
        }
        tfy_badgeInitIfNeeded()
        guard let badge = tfy_badge else { return }
        badge.tag = Int(TFYSwiftBadgeStyle.other.rawValue)
        tfy_setBadgeText(value)
        tfy_applyBadgeTextProperty { $0.font = tfy_badgeFont ?? TFYSwiftBadgeDefaultFont }
        tfy_adjustLabelWidth(badge)
        tfy_addMargin()
        let radius = tfy_badgeCornerRadius != 0 ? tfy_badgeCornerRadius : badge.bounds.height / 2
        badge.layer.cornerRadius = radius
        badge.tfy_setHidden(false)
        tfy_unclipForBadge()
        tfy_bringBadgeToFront(badge)
    }

    private func tfy_showNumberBadgeWithValue(_ value: Int) {
        guard tfy_badgeClass() != nil else { return }
        if value <= 0 {
            tfy_badge?.tfy_setHidden(true)
            return
        }
        tfy_badgeInitIfNeeded()
        tfy_badge?.tfy_setHidden(value == 0)
        tfy_badge?.tag = Int(TFYSwiftBadgeStyle.number.rawValue)
        let text = value > tfy_badgeMaximumBadgeNumber ? "\(tfy_badgeMaximumBadgeNumber)+" : "\(value)"
        tfy_showTextBadge(text)
    }

    private func tfy_badgeInitIfNeeded() {
        guard tfy_isReady() else { return }
        if tfy_badgeBackgroundColor == nil { tfy_badgeBackgroundColor = .red }
        if tfy_badgeTextColor == nil { tfy_badgeTextColor = .white }
        guard tfy_badge == nil else { return }
        guard tfy_isReady(), let badgeClass = tfy_badgeClass() else { return }
        let badge = badgeClass.init(frame: frame)
        tfy_badge = badge
        tfy_resetRedDotBadgeFrame()
        tfy_configureBadgeView(badge)
        tfy_bringBadgeToFront(badge)
    }

    private func tfy_configureBadgeView(_ badge: UIView) {
        if let label = badge as? UILabel {
            label.textAlignment = .center
            label.textColor = tfy_badgeTextColor
            label.text = ""
            label.layer.cornerRadius = label.bounds.width / 2
            label.layer.masksToBounds = true
            label.tfy_setHidden(true)
            label.backgroundColor = tfy_badgeBackgroundColor
        } else if let badgeView = badge as? TFYSwiftTabBarBadgeView {
            badgeView.textAlignment = .center
            badgeView.textColor = tfy_badgeTextColor
            badgeView.text = ""
            badgeView.layer.cornerRadius = badgeView.bounds.width / 2
            badgeView.layer.masksToBounds = true
            badgeView.tfy_setHidden(true)
            badgeView.backgroundColor = tfy_badgeBackgroundColor
        }
    }

    private func tfy_bringBadgeToFront(_ view: UIView) {
        guard tfy_isReady() else { return }
        tfy_placeBadge(view)
        NotificationCenter.default.addObserver(
            forName: .TFYSwiftTabBarStyleTypeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            _ = self
        }
    }

    /// Icon top-right. Liquid glass masks anything outside the capsule, so stay inside.
    private func tfy_badgeCenterInHost() -> CGPoint {
        tfy_badgeCenter(in: self)
    }

    private func tfy_badgeCenter(in host: UIView) -> CGPoint {
        let offset = tfy_badgeCenterOffset
        if tfy_usesLiquidGlassBadgePlacement() {
            let x = max(8, host.bounds.width - 8 + offset.x)
            let y = offset.y == 0 ? 8 : offset.y
            return CGPoint(x: x, y: y)
        }
        return CGPoint(x: host.bounds.width + 2 + offset.x, y: offset.y)
    }

    /// Visible platter button / icon. Original `_UITabButton` is often hidden or 1pt.
    private func tfy_liquidGlassBadgeAnchor() -> UIView {
        var control: UIControl?
        if let selfControl = self as? UIControl {
            control = selfControl
        } else {
            var node: UIView? = superview
            while let current = node {
                if let found = current as? UIControl {
                    control = found
                    break
                }
                node = current.superview
            }
        }
        guard let control else { return self }
        let visible = control.tfy_platterSelectedControl() ?? control
        if let image = visible.tfy_tabImageView(), image.tfy_isValidBadgeAnchor() {
            return image
        }
        if visible.tfy_isValidBadgeAnchor() { return visible }
        if control.tfy_isValidBadgeAnchor() { return control }
        return visible
    }

    private func tfy_placeBadge(_ badge: UIView) {
        badge.isUserInteractionEnabled = false
        if tfy_usesLiquidGlassBadgePlacement(), let tabBar = tfy_enclosingTabBar() {
            tabBar.clipsToBounds = false
            tabBar.layer.masksToBounds = false
            let anchor = tfy_liquidGlassBadgeAnchor()
            var center = anchor.convert(tfy_badgeCenter(in: anchor), to: tabBar)
            let hit = tabBar.bounds.insetBy(dx: -80, dy: -80)
            if anchor.bounds.width <= 10 || !hit.contains(center) {
                let frame = anchor.convert(anchor.bounds, to: tabBar)
                if frame.width > 10, frame.height > 1 {
                    let offset = tfy_badgeCenterOffset
                    center = CGPoint(x: frame.maxX - 8 + offset.x, y: frame.minY + 8 + offset.y)
                }
            }
            if badge.superview !== tabBar {
                tabBar.addSubview(badge)
            }
            tabBar.bringSubviewToFront(badge)
            badge.center = center
            badge.layer.zPosition = TFYSwiftLayerFrontZPosition
            badge.tfy_setHidden(false)
            return
        }
        addSubview(badge)
        bringSubviewToFront(badge)
        badge.center = tfy_badgeCenterInHost()
        badge.layer.zPosition = TFYSwiftLayerFrontZPosition
    }

    private func tfy_resetRedDotBadgeFrame() {
        var redDotWidth = tfyBadgeDefaultRedDotRadius * 2
        if tfy_badgeRadius > 0 {
            redDotWidth = tfy_badgeRadius * 2
        }
        guard let badge = tfy_badge else { return }
        badge.bounds = CGRect(origin: .zero, size: CGSize(width: redDotWidth, height: redDotWidth))
        badge.layer.cornerRadius = redDotWidth / 2
        badge.layer.masksToBounds = true
        tfy_placeBadge(badge)
    }

    private func tfy_addMargin() {
        guard let badge = tfy_badge else { return }
        var frame = badge.frame
        frame.size.width += tfy_badgeMargin
        frame.size.height += tfy_badgeMargin
        if frame.width < frame.height {
            frame.size.width = frame.height
        }
        badge.frame = frame
    }

    private func tfy_adjustLabelWidth(_ badgeSuperView: UIView) {
        let label: UILabel? = {
            if let label = badgeSuperView as? UILabel { return label }
            if badgeSuperView.responds(to: NSSelectorFromString("badgeLabel")) {
                return badgeSuperView.perform(NSSelectorFromString("badgeLabel"))?.takeUnretainedValue() as? UILabel
            }
            return nil
        }()
        guard let label, let text = label.text, !text.isEmpty else { return }
        label.numberOfLines = 0
        let labelSize = tfy_getLabelSize(label)
        guard labelSize != .zero else { return }
        let frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: ceil(labelSize.width), height: ceil(labelSize.height))
        label.frame = frame
        badgeSuperView.frame = frame
    }

    private func tfy_getLabelSize(_ label: UILabel) -> CGSize {
        guard let text = label.text, let font = label.font else { return .zero }
        let size = CGSize(width: tfy_screenWidth(), height: tfy_screenHeight())
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        return (text as NSString).boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font, .paragraphStyle: style],
            context: nil
        ).size
    }

    private func tfy_beginAnimation() {
        guard let badge = tfy_badge else { return }
        let moveDistance = badge.frame.width * 1.5
        switch tfy_badgeAnimationType {
        case .breathe:
            badge.layer.add(CAAnimation.tfy_opacityForeverAnimation(1.4), forKey: TFYSwiftBadgeBreatheAnimationKey)
        case .shake:
            badge.layer.add(CAAnimation.tfy_shakeAnimation(repeatTimes: .greatestFiniteMagnitude, durTimes: 1, forObj: badge.layer), forKey: TFYSwiftBadgeShakeAnimationKey)
        case .scale:
            badge.layer.add(CAAnimation.tfy_scale(from: 1.4, toScale: 0.6, durTimes: 1, rep: .greatestFiniteMagnitude), forKey: TFYSwiftBadgeScaleAnimationKey)
        case .bounce:
            badge.layer.add(CAAnimation.tfy_bounceAnimation(repeatTimes: .greatestFiniteMagnitude, durTimes: 1, forObj: badge.layer), forKey: TFYSwiftBadgeBounceAnimationKey)
        case .leftRightOnce:
            badge.layer.add(CAAnimation.tfy_badgeOnceLeftRightAnimation(moveDistance: moveDistance, repeatTimes: 1, durTimes: 0.5), forKey: TFYSwiftBadgeLeftRightOnceAnimationKey)
        case .rightLeftOnce:
            badge.layer.add(CAAnimation.tfy_badgeOnceRightLeftAnimation(moveDistance: moveDistance, repeatTimes: 1, durTimes: 0.5), forKey: TFYSwiftBadgeRightLeftOnceAnimationKey)
        case .fadeInOnce:
            badge.layer.add(CAAnimation.tfy_badgeOnceFadeInAnimation(repeatTimes: 1, durTimes: 1.5), forKey: TFYSwiftBadgeFadeInOnceAnimationKey)
        case .rollingOnce:
            badge.layer.add(CAAnimation.tfy_badgeOnceRollingAnimation(repeatTimes: 1, durTimes: 0.5), forKey: TFYSwiftBadgeRollingOnceAnimationKey)
        case .scaleOnce:
            badge.layer.add(CAAnimation.tfy_badgeOnceScaleAnimation(repeatTimes: 1, durTimes: 0.5), forKey: TFYSwiftBadgeScaleOnceAnimationKey)
        case .none:
            break
        }
    }

    private func tfy_removeAnimation() {
        tfy_badge?.layer.removeAllAnimations()
    }

    private func tfy_badgeClass() -> UIView.Type? {
        if !tfy_isIOS27 {
            return UILabel.self
        }
        if tfy_isTFYSwiftTabBarStyleTypeLiquidGlass() {
            return TFYSwiftTabBarBadgeView.self
        }
        return UILabel.self
    }

    private func tfy_isTFYSwiftTabBarStyleTypeLiquidGlass() -> Bool {
        TFYSwiftConstants.isLiquidGlassActive()
    }

    private func tfy_shouldUpdateBadgeSubviews() -> Bool {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return false }
        if tfy_isIOS27, !(tfy_badge is UILabel) {
            return true
        }
        return true
    }

    private func tfy_setBadgeText(_ text: String) {
        if let label = tfy_badge as? UILabel {
            label.text = text
        } else if let badgeView = tfy_badge as? TFYSwiftTabBarBadgeView {
            badgeView.text = text
        }
    }

    private func tfy_applyBadgeTextProperty(_ block: (UILabel) -> Void) {
        if let label = tfy_badge as? UILabel {
            block(label)
        } else if let badgeView = tfy_badge as? TFYSwiftTabBarBadgeView {
            badgeView.font = tfy_badgeFont ?? TFYSwiftBadgeDefaultFont
            badgeView.textColor = tfy_badgeTextColor ?? .white
        }
    }
}

extension UIView: TFYSwiftBadgeProtocol {}

public enum TFYSwiftBarButtonSwizzleToken {
    public static func installWillMoveToSuperviewSwizzleIfNeeded() {
        guard #available(iOS 11.0, *) else { return }
        DispatchQueue.once(token: "tfy.UIButtonBarButton.willMoveToSuperview") {
            guard let barButtonClass = NSClassFromString("_UIButtonBarButton") else { return }
            let originalSelector = #selector(UIView.willMove(toSuperview:))
            let swizzledSelector = #selector(UIView.tfy_badge_willMove(toSuperview:))
            guard let originalMethod = class_getInstanceMethod(barButtonClass, originalSelector),
                  let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector) else {
                return
            }
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

private extension DispatchQueue {
    private static var _onceTokens = Set<String>()
    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard !_onceTokens.contains(token) else { return }
        _onceTokens.insert(token)
        block()
    }
}

private extension NSNumber {
    var CGFloatValue: CGFloat { CGFloat(truncating: self) }
}
