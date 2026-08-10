//
//  TFYSwiftBadgeProtocol.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLBadgeProtocol.h
//

import UIKit

public let TFYSwiftBadgeBreatheAnimationKey = "tfy.badge.breathe"
public let TFYSwiftBadgeRotateAnimationKey = "tfy.badge.rotate"
public let TFYSwiftBadgeShakeAnimationKey = "tfy.badge.shake"
public let TFYSwiftBadgeScaleAnimationKey = "tfy.badge.scale"
public let TFYSwiftBadgeBounceAnimationKey = "tfy.badge.bounce"
public let TFYSwiftBadgeLeftRightOnceAnimationKey = "tfy.badge.LeftRightOnce"
public let TFYSwiftBadgeRightLeftOnceAnimationKey = "tfy.badge.RightLeftOnce"
public let TFYSwiftBadgeFadeInOnceAnimationKey = "tfy.badge.FadeInOnce"
public let TFYSwiftBadgeRollingOnceAnimationKey = "tfy.badge.RollingOnce"
public let TFYSwiftBadgeScaleOnceAnimationKey = "tfy.badge.ScaleOnce"

@objc public enum TFYSwiftBadgeStyle: UInt {
    case redDot = 1
    case number
    case new
    case other
}

@objc public enum TFYSwiftBadgeAnimationType: UInt {
    case none = 0
    case scale
    case shake
    case bounce
    case breathe
    case leftRightOnce
    case rightLeftOnce
    case fadeInOnce
    case rollingOnce
    case scaleOnce
}

public protocol TFYSwiftBadgeProtocol: AnyObject {
    var tfy_badgeFont: UIFont? { get set }
    var tfy_badgeBackgroundColor: UIColor? { get set }
    var tfy_badgeTextColor: UIColor? { get set }
    var tfy_badgeFrame: CGRect { get set }
    var tfy_badgeFrameValue: NSValue? { get set }
    var tfy_badgeCenterOffset: CGPoint { get set }
    var tfy_badgeCenterOffsetValue: NSValue? { get set }
    var tfy_badgeAnimationType: TFYSwiftBadgeAnimationType { get set }
    var tfy_badgeAnimationTypeValue: NSNumber? { get set }
    var tfy_badgeMaximumBadgeNumber: Int { get set }
    var tfy_badgeMaximumBadgeNumberValue: NSNumber? { get set }
    var tfy_badgeRadius: CGFloat { get set }
    var tfy_badgeRadiusValue: NSNumber? { get set }
    var tfy_badgeMargin: CGFloat { get set }
    var tfy_badgeMarginValue: NSNumber? { get set }
    var tfy_badgeCornerRadius: CGFloat { get set }
    var tfy_badgeCornerRadiusValue: NSNumber? { get set }
    var tfy_delayIfNeededForSeconds: CGFloat { get set }

    func tfy_isShowBadge() -> Bool
    func tfy_showBadge()
    func tfy_showBadgeValue(_ value: String?, animationType: TFYSwiftBadgeAnimationType)
    func tfy_clearBadge()
    func tfy_resumeBadge()
    func tfy_isPauseBadge() -> Bool
    func tfy_getActualBadgeSuperView() -> Any?
    func tfy_isReady() -> Bool
}
