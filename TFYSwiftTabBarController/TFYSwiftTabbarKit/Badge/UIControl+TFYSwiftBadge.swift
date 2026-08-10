//
//  UIControl+TFYSwiftBadge.swift
//  TFYSwiftTabBarController
//
//  Converted from UIControl+CYLBadgeExtention
//

import ObjectiveC
import UIKit

private extension UIControl {
    var tfy_actualBadgeHost: UIView? {
        tfy_getActualBadgeSuperView() as? UIView
    }
}

public extension UIControl {

    @objc override var tfy_badge: UIView? {
        get { tfy_actualBadgeHost?.tfy_badge }
        set { tfy_actualBadgeHost?.tfy_badge = newValue }
    }

    @objc override var tfy_badgeFont: UIFont? {
        get { tfy_actualBadgeHost?.tfy_badgeFont }
        set { tfy_actualBadgeHost?.tfy_badgeFont = newValue }
    }

    @objc override var tfy_badgeBackgroundColor: UIColor? {
        get { tfy_actualBadgeHost?.tfy_badgeBackgroundColor }
        set { tfy_actualBadgeHost?.tfy_badgeBackgroundColor = newValue }
    }

    @objc override var tfy_badgeTextColor: UIColor? {
        get { tfy_actualBadgeHost?.tfy_badgeTextColor }
        set { tfy_actualBadgeHost?.tfy_badgeTextColor = newValue }
    }

    @objc override var tfy_badgeAnimationType: TFYSwiftBadgeAnimationType {
        get { tfy_actualBadgeHost?.tfy_badgeAnimationType ?? .none }
        set { tfy_actualBadgeHost?.tfy_badgeAnimationType = newValue }
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
        tfy_actualBadgeHost?.tfy_showBadgeValue("", animationType: .none)
    }

    @objc override func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType) {
        tfy_actualBadgeHost?.tfy_showBadgeValue(value, animationType: animationType)
    }

    @objc override func tfy_clearBadge() {
        tfy_actualBadgeHost?.tfy_clearBadge()
    }

    @objc override func tfy_resumeBadge() {
        tfy_actualBadgeHost?.tfy_resumeBadge()
    }

    @objc override func tfy_isShowBadge() -> Bool {
        tfy_actualBadgeHost?.tfy_isShowBadge() ?? false
    }

    @objc override func tfy_isPauseBadge() -> Bool {
        tfy_actualBadgeHost?.tfy_isPauseBadge() ?? false
    }

    @objc override func tfy_getActualBadgeSuperView() -> Any? {
        let tabImageView = tfy_tabImageView()
        let lottieAnimationView = tfy_lottieAnimationView()

        var actualBadgeSuperView: UIView?
        if let lottieAnimationView, !lottieAnimationView.tfy_isInvisiable() {
            actualBadgeSuperView = lottieAnimationView
        } else if let tabImageView, !tabImageView.tfy_isInvisiable() {
            actualBadgeSuperView = tabImageView
        }

        if let actualBadgeSuperView {
            actualBadgeSuperView.clipsToBounds = false
            actualBadgeSuperView.layoutIfNeeded()
        }
        return actualBadgeSuperView
    }

    @objc override func tfy_isReady() -> Bool {
        if !TFYSwiftConstants.isLiquidGlassActive() {
            return true
        }
        guard tfy_platterSelectedControl()?.tfy_tabImageView() != nil else { return false }
        let isTabImageViewReady = (tfy_tabImageView()?.frame.size.width ?? 0) > 10 || (tfy_tabLabel()?.frame.size.width ?? 0) > 10
        var isLottieReady = true
        if tfy_tabBarController?.lottieURLs.count ?? 0 > 0 {
            isLottieReady = tfy_isLottieReady()
        }
        return isTabImageViewReady && isLottieReady
    }

    @objc func tfy_getActualBadgeSuperViewFromControl(_ tabButton: UIControl) -> UIView? {
        tabButton.tfy_getActualBadgeSuperView() as? UIView
    }
}
