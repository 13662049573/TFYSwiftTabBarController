//
//  UIControl+TFYSwiftBadge.swift
//  TFYSwiftTabBarController
//
//  Converted from UIControl+CYLBadgeExtention
//

import ObjectiveC
import UIKit

private extension UIControl {
    /// Image/lottie host. Nil when the host is this control — forwarding would recurse.
    var tfy_actualBadgeHost: UIView? {
        let host = tfy_getActualBadgeSuperView() as? UIView
        return host === self ? nil : host
    }
}

public extension UIControl {

    @objc override var tfy_badge: UIView? {
        get {
            if let host = tfy_actualBadgeHost { return host.tfy_badge }
            return objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badge) as? UIView
        }
        set {
            if let host = tfy_actualBadgeHost {
                host.tfy_badge = newValue
            } else {
                objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badge, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    @objc override var tfy_badgeFont: UIFont? {
        get {
            if let host = tfy_actualBadgeHost { return host.tfy_badgeFont }
            return (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeFont) as? UIFont) ?? TFYSwiftBadgeDefaultFont
        }
        set {
            if let host = tfy_actualBadgeHost {
                host.tfy_badgeFont = newValue
            } else {
                objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeFont, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    @objc override var tfy_badgeBackgroundColor: UIColor? {
        get {
            if let host = tfy_actualBadgeHost { return host.tfy_badgeBackgroundColor }
            return objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeBackgroundColor) as? UIColor
        }
        set {
            if let host = tfy_actualBadgeHost {
                host.tfy_badgeBackgroundColor = newValue
            } else {
                objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    @objc override var tfy_badgeTextColor: UIColor? {
        get {
            if let host = tfy_actualBadgeHost { return host.tfy_badgeTextColor }
            return objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeTextColor) as? UIColor
        }
        set {
            if let host = tfy_actualBadgeHost {
                host.tfy_badgeTextColor = newValue
            } else {
                objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeTextColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    @objc override var tfy_badgeAnimationType: TFYSwiftBadgeAnimationType {
        get {
            if let host = tfy_actualBadgeHost { return host.tfy_badgeAnimationType }
            if let number = objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeAnimationType) as? NSNumber {
                return TFYSwiftBadgeAnimationType(rawValue: number.uintValue) ?? .none
            }
            return .none
        }
        set {
            if let host = tfy_actualBadgeHost {
                host.tfy_badgeAnimationType = newValue
            } else {
                objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.badgeAnimationType, NSNumber(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    @objc override var tfy_badgeAnimationTypeValue: NSNumber? {
        get { NSNumber(value: tfy_badgeAnimationType.rawValue) }
        set { tfy_badgeAnimationType = TFYSwiftBadgeAnimationType(rawValue: newValue?.uintValue ?? 0) ?? .none }
    }

    @objc override var tfy_badgeFrame: CGRect {
        get { tfy_actualBadgeHost?.tfy_badgeFrame ?? .zero }
        set { tfy_actualBadgeHost?.tfy_badgeFrame = newValue }
    }

    @objc override var tfy_badgeFrameValue: NSValue? {
        get { NSValue(cgRect: tfy_badgeFrame) }
        set { tfy_badgeFrame = newValue?.cgRectValue ?? .zero }
    }

    @objc override var tfy_badgeCenterOffset: CGPoint {
        get { tfy_actualBadgeHost?.tfy_badgeCenterOffset ?? .zero }
        set { tfy_actualBadgeHost?.tfy_badgeCenterOffset = newValue }
    }

    @objc override var tfy_badgeCenterOffsetValue: NSValue? {
        get { NSValue(cgPoint: tfy_badgeCenterOffset) }
        set { tfy_badgeCenterOffset = newValue?.cgPointValue ?? .zero }
    }

    @objc override var tfy_badgeMaximumBadgeNumber: Int {
        get { tfy_actualBadgeHost?.tfy_badgeMaximumBadgeNumber ?? 99 }
        set { tfy_actualBadgeHost?.tfy_badgeMaximumBadgeNumber = newValue }
    }

    @objc override var tfy_badgeMaximumBadgeNumberValue: NSNumber? {
        get { NSNumber(value: tfy_badgeMaximumBadgeNumber) }
        set { tfy_badgeMaximumBadgeNumber = newValue?.intValue ?? 99 }
    }

    @objc override var tfy_badgeRadius: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeRadius ?? 0 }
        set { tfy_actualBadgeHost?.tfy_badgeRadius = newValue }
    }

    @objc override var tfy_badgeRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeRadius)) }
        set { tfy_badgeRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc override var tfy_badgeMargin: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeMargin ?? 8 }
        set { tfy_actualBadgeHost?.tfy_badgeMargin = newValue }
    }

    @objc override var tfy_badgeMarginValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeMargin)) }
        set { tfy_badgeMargin = CGFloat(newValue?.doubleValue ?? 8) }
    }

    @objc override var tfy_badgeCornerRadius: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeCornerRadius ?? 0 }
        set { tfy_actualBadgeHost?.tfy_badgeCornerRadius = newValue }
    }

    @objc override var tfy_badgeCornerRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeCornerRadius)) }
        set { tfy_badgeCornerRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc override var tfy_delayIfNeededForSeconds: CGFloat {
        get {
            (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.delayIfNeededForSeconds) as? NSNumber)?.doubleValue ?? 0
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.delayIfNeededForSeconds, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc override func tfy_showBadge() {
        tfy_showBadgeValue("", animationType: .none)
    }

    @objc override func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType) {
        let boxed = NSNumber(value: animationType.rawValue)
        if let host = tfy_actualBadgeHost {
            host.tfy_showBadgeValue(value, animationTypeValue: boxed)
        } else {
            tfy_showBadgeValue(value, animationTypeValue: boxed)
        }
    }

    @objc override func tfy_clearBadge() {
        if let host = tfy_actualBadgeHost {
            host.tfy_clearBadge()
            return
        }
        tfy_badge?.tfy_setHidden(true)
    }

    @objc override func tfy_resumeBadge() {
        if let host = tfy_actualBadgeHost {
            host.tfy_resumeBadge()
            return
        }
        if let badge = tfy_badge, badge.tfy_isHidden {
            badge.tfy_setHidden(false)
        }
    }

    @objc override func tfy_isShowBadge() -> Bool {
        if let host = tfy_actualBadgeHost { return host.tfy_isShowBadge() }
        guard let badge = tfy_badge else { return false }
        return !badge.tfy_isHidden
    }

    @objc override func tfy_isPauseBadge() -> Bool {
        if let host = tfy_actualBadgeHost { return host.tfy_isPauseBadge() }
        guard let badge = tfy_badge else { return false }
        return badge.tfy_isHidden
    }

    @objc override func tfy_getActualBadgeSuperView() -> Any? {
        // `_UIButtonBarButton` is a nav-bar control. Tab-image KVC (`imageView`) throws.
        if NSStringFromClass(type(of: self)) == "_UIButtonBarButton" {
            let content = tfy_findBarButtonContentView()
            return content === self ? nil : content
        }

        let tabImageView = tfy_tabImageView()
        let lottieAnimationView = tfy_lottieAnimationView()

        var actualBadgeSuperView: UIView?
        if let lottieAnimationView, lottieAnimationView.tfy_isValidBadgeAnchor() {
            actualBadgeSuperView = lottieAnimationView
        } else if let tabImageView, tabImageView.tfy_isValidBadgeAnchor() {
            actualBadgeSuperView = tabImageView
        }

        if let actualBadgeSuperView {
            actualBadgeSuperView.tfy_unclipForBadge()
            actualBadgeSuperView.layoutIfNeeded()
            return actualBadgeSuperView
        }
        // iOS 26 `_UITabButton` icon is often a 1pt placeholder; pin the badge on the control.
        tfy_unclipForBadge()
        if tfy_usesLiquidGlassBadgePlacement(),
           let selected = tfy_platterSelectedControl(),
           selected !== self,
           selected.tfy_isValidBadgeAnchor() {
            return selected
        }
        return self
    }

    @objc override func tfy_isReady() -> Bool {
        if !tfy_usesLiquidGlassBadgePlacement() {
            return true
        }
        if bounds.width > 10 { return true }
        // `_UITabButton` / portal icon is often 1pt; still paint, then reparent onto the tab bar.
        return superview != nil
    }

    @objc func tfy_getActualBadgeSuperViewFromControl(_ tabButton: UIControl) -> UIView? {
        tabButton.tfy_getActualBadgeSuperView() as? UIView
    }
}

