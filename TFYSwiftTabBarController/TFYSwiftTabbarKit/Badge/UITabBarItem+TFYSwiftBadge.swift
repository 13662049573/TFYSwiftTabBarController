//
//  UITabBarItem+TFYSwiftBadge.swift
//  TFYSwiftTabBarController
//
//  Converted from UITabBarItem+CYLBadgeExtention
//

import ObjectiveC
import UIKit

private extension UITabBarItem {
    var tfy_actualBadgeView: UIView? {
        tfy_getActualBadgeSuperView() as? UIView
    }
}

public extension UITabBarItem {

    @objc var tfy_badge: TFYSwiftTabBarBadgeView? {
        get { tfy_actualBadgeView?.tfy_badge as? TFYSwiftTabBarBadgeView }
        set { tfy_actualBadgeView?.tfy_badge = newValue }
    }

    @objc var tfy_badgeFont: UIFont? {
        get { tfy_actualBadgeView?.tfy_badgeFont }
        set { tfy_actualBadgeView?.tfy_badgeFont = newValue }
    }

    @objc var tfy_badgeBackgroundColor: UIColor? {
        get { tfy_actualBadgeView?.tfy_badgeBackgroundColor }
        set { tfy_actualBadgeView?.tfy_badgeBackgroundColor = newValue }
    }

    @objc var tfy_badgeTextColor: UIColor? {
        get { tfy_actualBadgeView?.tfy_badgeTextColor }
        set { tfy_actualBadgeView?.tfy_badgeTextColor = newValue }
    }

    @objc var tfy_badgeAnimationType: TFYSwiftBadgeAnimationType {
        get { tfy_actualBadgeView?.tfy_badgeAnimationType ?? .none }
        set { tfy_actualBadgeView?.tfy_badgeAnimationType = newValue }
    }

    @objc var tfy_badgeAnimationTypeValue: NSNumber? {
        get { NSNumber(value: tfy_badgeAnimationType.rawValue) }
        set { tfy_badgeAnimationType = TFYSwiftBadgeAnimationType(rawValue: newValue?.uintValue ?? 0) ?? .none }
    }

    @objc var tfy_badgeFrame: CGRect {
        get { tfy_actualBadgeView?.tfy_badgeFrame ?? .zero }
        set { tfy_actualBadgeView?.tfy_badgeFrame = newValue }
    }

    @objc var tfy_badgeFrameValue: NSValue? {
        get { NSValue(cgRect: tfy_badgeFrame) }
        set { tfy_badgeFrame = newValue?.cgRectValue ?? .zero }
    }

    @objc var tfy_badgeCenterOffset: CGPoint {
        get { tfy_actualBadgeView?.tfy_badgeCenterOffset ?? .zero }
        set { tfy_actualBadgeView?.tfy_badgeCenterOffset = newValue }
    }

    @objc var tfy_badgeCenterOffsetValue: NSValue? {
        get { NSValue(cgPoint: tfy_badgeCenterOffset) }
        set { tfy_badgeCenterOffset = newValue?.cgPointValue ?? .zero }
    }

    @objc var tfy_badgeMaximumBadgeNumber: Int {
        get { tfy_actualBadgeView?.tfy_badgeMaximumBadgeNumber ?? 99 }
        set { tfy_actualBadgeView?.tfy_badgeMaximumBadgeNumber = newValue }
    }

    @objc var tfy_badgeMaximumBadgeNumberValue: NSNumber? {
        get { NSNumber(value: tfy_badgeMaximumBadgeNumber) }
        set { tfy_badgeMaximumBadgeNumber = newValue?.intValue ?? 99 }
    }

    @objc var tfy_badgeRadius: CGFloat {
        get { tfy_actualBadgeView?.tfy_badgeRadius ?? 0 }
        set { tfy_actualBadgeView?.tfy_badgeRadius = newValue }
    }

    @objc var tfy_badgeRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeRadius)) }
        set { tfy_badgeRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc var tfy_badgeMargin: CGFloat {
        get { tfy_actualBadgeView?.tfy_badgeMargin ?? 8 }
        set { tfy_actualBadgeView?.tfy_badgeMargin = newValue }
    }

    @objc var tfy_badgeMarginValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeMargin)) }
        set { tfy_badgeMargin = CGFloat(newValue?.doubleValue ?? 8) }
    }

    @objc var tfy_badgeCornerRadius: CGFloat {
        get { tfy_actualBadgeView?.tfy_badgeCornerRadius ?? 0 }
        set { tfy_actualBadgeView?.tfy_badgeCornerRadius = newValue }
    }

    @objc var tfy_badgeCornerRadiusValue: NSNumber? {
        get { NSNumber(value: Double(tfy_badgeCornerRadius)) }
        set { tfy_badgeCornerRadius = CGFloat(newValue?.doubleValue ?? 0) }
    }

    @objc var tfy_delayIfNeededForSeconds: CGFloat {
        get {
            CGFloat((objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.delayIfNeededForSeconds) as? NSNumber)?.doubleValue ?? 0)
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.delayIfNeededForSeconds, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func tfy_showBadge() {
        tfy_actualBadgeView?.tfy_showBadge()
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType) {
        tfy_showBadgeValue(value, animationTypeValue: NSNumber(value: animationType.rawValue))
    }

    @objc func tfy_showBadgeValue(_ value: String?, animationTypeValue: NSNumber?) {
        tfy_performOnPlatterCounterparts { view in
            view.tfy_showBadgeValue(value, animationTypeValue: animationTypeValue)
        }
    }

    @objc func tfy_clearBadge() {
        tfy_actualBadgeView?.tfy_clearBadge()
    }

    @objc func tfy_resumeBadge() {
        tfy_actualBadgeView?.tfy_resumeBadge()
    }

    @objc func tfy_isShowBadge() -> Bool {
        tfy_actualBadgeView?.tfy_isShowBadge() ?? false
    }

    @objc func tfy_isPauseBadge() -> Bool {
        tfy_actualBadgeView?.tfy_isPauseBadge() ?? false
    }

    @objc func tfy_getActualBadgeSuperView() -> Any? {
        if let tabButton = tfy_tabButton {
            if tabButton.tfy_usesLiquidGlassBadgePlacement() {
                return tabButton
            }
            return tabButton.tfy_getActualBadgeSuperView()
        }
        return nil
    }

    private func tfy_getActualBadgeSuperViewFromControl(_ tabButton: UIControl) -> UIView? {
        tabButton.tfy_getActualBadgeSuperView() as? UIView
    }

    private func tfy_performOnPlatterCounterparts(_ action: (UIView) -> Void) {
        guard let selfControl = tfy_tabButton else { return }
        if !selfControl.tfy_usesLiquidGlassBadgePlacement() {
            if let view = tfy_getActualBadgeSuperViewFromControl(selfControl) {
                action(view)
            }
            return
        }

        var normalControl: UIControl?
        var selectedControl: UIControl?
        if selfControl.tfy_isPlatterSelectedControl() {
            selectedControl = selfControl
        } else {
            normalControl = selfControl
        }

        if let normalControl {
            if let view = tfy_getActualBadgeSuperViewFromControl(normalControl) {
                action(view)
            }
            if let counterpart = normalControl.tfy_platterSelectedControl(),
               let view = tfy_getActualBadgeSuperViewFromControl(counterpart) {
                action(view)
            }
        } else if let selectedControl {
            if let view = tfy_getActualBadgeSuperViewFromControl(selectedControl) {
                action(view)
            }
            if let counterpart = selectedControl.tfy_platterNormalControl(),
               let view = tfy_getActualBadgeSuperViewFromControl(counterpart) {
                action(view)
            }
        }
    }
}

extension UITabBarItem: TFYSwiftBadgeProtocol {}
