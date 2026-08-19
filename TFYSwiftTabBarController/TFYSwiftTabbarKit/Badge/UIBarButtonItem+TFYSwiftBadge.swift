//
//  UIBarButtonItem+TFYSwiftBadge.swift
//  TFYSwiftTabBarController
//
//  Converted from UIBarButtonItem+CYLBadgeExtention (includes _UIButtonBarButton swizzle)
//

import ObjectiveC
import UIKit

private extension UIBarButtonItem {
    var tfy_actualBadgeHost: UIView? {
        tfy_getActualBadgeSuperView() as? UIView
    }
}

public extension UIBarButtonItem {

    @objc func tfy_isReady() -> Bool {
        guard let view = tfy_getActualBadgeSuperView() as? UIView else { return false }
        return view.frame.size.width > 10
    }

    @objc func tfy_showBadge() {
        tfy_installWillMoveToSuperviewSwizzleIfNeeded()
        let delay = tfy_isReady() ? 0.0 : 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.tfy_actualBadgeHost?.tfy_showBadge()
        }
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType) {
        tfy_installWillMoveToSuperviewSwizzleIfNeeded()
        let delay = tfy_isReady() ? 0.0 : 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.tfy_actualBadgeHost?.tfy_showBadgeValue(value, animationType: animationType)
        }
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

    @objc func tfy_isShowBadge() -> Bool {
        tfy_actualBadgeHost?.tfy_isShowBadge() ?? false
    }

    @objc func tfy_getActualBadgeSuperView() -> Any? {
        guard let barButtonContentView = tfy_view?.tfy_findBarButtonContentView() as? UIButton else {
            return tfy_view
        }
        var actualBadgeSuperView: UIView = barButtonContentView
        if let imageView = barButtonContentView.imageView, imageView.frame.size.width > 10 {
            actualBadgeSuperView = imageView
        } else if let titleLabel = barButtonContentView.titleLabel, titleLabel.frame.size.width > 10 {
            actualBadgeSuperView = titleLabel
        }
        actualBadgeSuperView.layoutIfNeeded()
        return actualBadgeSuperView
    }

    @objc var tfy_view: UIView? {
        if responds(to: NSSelectorFromString("view")) {
            return (self as NSObject).tfy_valueForKey("view") as? UIView
        }
        return nil
    }

    @objc var tfy_badge: TFYSwiftTabBarBadgeView? {
        get { tfy_actualBadgeHost?.tfy_badge as? TFYSwiftTabBarBadgeView }
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

    @objc var tfy_badgeAnimationTypeValue: NSNumber? {
        get { NSNumber(value: tfy_badgeAnimationType.rawValue) }
        set { tfy_badgeAnimationType = TFYSwiftBadgeAnimationType(rawValue: newValue?.uintValue ?? 0) ?? .none }
    }

    @objc var tfy_badgeFrame: CGRect {
        get { tfy_actualBadgeHost?.tfy_badgeFrame ?? .zero }
        set { tfy_actualBadgeHost?.tfy_badgeFrame = newValue }
    }

    @objc var tfy_badgeFrameValue: NSValue? {
        get { NSValue(cgRect: tfy_badgeFrame) }
        set { tfy_badgeFrame = newValue?.cgRectValue ?? .zero }
    }

    @objc var tfy_badgeCenterOffset: CGPoint {
        get { tfy_actualBadgeHost?.tfy_badgeCenterOffset ?? .zero }
        set { tfy_actualBadgeHost?.tfy_badgeCenterOffset = newValue }
    }

    @objc var tfy_badgeCenterOffsetValue: NSValue? {
        get { NSValue(cgPoint: tfy_badgeCenterOffset) }
        set { tfy_badgeCenterOffset = newValue?.cgPointValue ?? .zero }
    }

    @objc var tfy_badgeMaximumBadgeNumber: Int {
        get { tfy_actualBadgeHost?.tfy_badgeMaximumBadgeNumber ?? 99 }
        set { tfy_actualBadgeHost?.tfy_badgeMaximumBadgeNumber = newValue }
    }

    @objc var tfy_badgeMaximumBadgeNumberValue: NSNumber? {
        get { NSNumber(value: tfy_badgeMaximumBadgeNumber) }
        set { tfy_badgeMaximumBadgeNumber = newValue?.intValue ?? 99 }
    }

    @objc var tfy_badgeRadius: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeRadius ?? 0 }
        set { tfy_actualBadgeHost?.tfy_badgeRadius = newValue }
    }

    @objc var tfy_badgeRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeRadius)) }
        set { tfy_badgeRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc var tfy_badgeMargin: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeMargin ?? 8 }
        set { tfy_actualBadgeHost?.tfy_badgeMargin = newValue }
    }

    @objc var tfy_badgeMarginValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeMargin)) }
        set { tfy_badgeMargin = CGFloat(newValue?.doubleValue ?? 8) }
    }

    @objc var tfy_badgeCornerRadius: CGFloat {
        get { tfy_actualBadgeHost?.tfy_badgeCornerRadius ?? 0 }
        set { tfy_actualBadgeHost?.tfy_badgeCornerRadius = newValue }
    }

    @objc var tfy_badgeCornerRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeCornerRadius)) }
        set { tfy_badgeCornerRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc var tfy_delayIfNeededForSeconds: CGFloat {
        get { tfy_isReady() ? 0 : 0.5 }
        set { _ = newValue }
    }

    @objc var tfy_delayIfNeededForSecondsValue: NSNumber? {
        NSNumber(value: Double(tfy_delayIfNeededForSeconds))
    }

    /// Swizzling -[_UIButtonBarButton willMoveToSuperview:]
    @objc func tfy_installWillMoveToSuperviewSwizzleIfNeeded() {
        TFYSwiftBarButtonSwizzleToken.installWillMoveToSuperviewSwizzleIfNeeded()
    }
}

extension UIBarButtonItem: TFYSwiftBadgeProtocol {}
