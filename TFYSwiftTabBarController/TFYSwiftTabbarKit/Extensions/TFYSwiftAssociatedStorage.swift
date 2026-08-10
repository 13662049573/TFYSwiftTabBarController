//
//  TFYSwiftAssociatedStorage.swift
//  TFYSwiftTabBarController
//
//  Shared associated-object keys used by TFYSwift extensions.
//

import Foundation
import UIKit

enum TFYSwiftAssociatedKeys {
    static var tabBarController: UInt8 = 0
    static var context: UInt8 = 0
    static var isPlaceholder: UInt8 = 0
    static var isForceLandscape: UInt8 = 0
    static var platterView: UInt8 = 0
    static var platterContentView: UInt8 = 0
    static var badge: UInt8 = 0
    static var badgeFont: UInt8 = 0
    static var badgeBackgroundColor: UInt8 = 0
    static var badgeTextColor: UInt8 = 0
    static var badgeAnimationType: UInt8 = 0
    static var badgeFrame: UInt8 = 0
    static var badgeCenterOffset: UInt8 = 0
    static var badgeMaximumBadgeNumber: UInt8 = 0
    static var badgeRadius: UInt8 = 0
    static var badgeMargin: UInt8 = 0
    static var badgeCornerRadius: UInt8 = 0
    static var delayIfNeededForSeconds: UInt8 = 0
    static var keepShowingPlusButtonLabel: UInt8 = 0
    static var shouldNotSelect: UInt8 = 0
    static var tabBarItemVisibleIndex: UInt8 = 0
    static var tabBarChildViewControllerIndex: UInt8 = 0
    static var lottieURL: UInt8 = 0
    static var loadedLottieFilePath: UInt8 = 0
    static var lottieSizeValue: UInt8 = 0
    static var imagePositionAdjustment: UInt8 = 0
    static var tabButton: UInt8 = 0
    static var tabIndex: UInt8 = 0
    static var plusViewControllerEverAdded: UInt8 = 0
    static var disablePopGestureRecognizer: UInt8 = 0
    static var hideNavigationBarSeparator: UInt8 = 0
    static var navigationBarHidden: UInt8 = 0
    static var hidesBottomBarWhenPushed: UInt8 = 0
    static var tabBadgePointView: UInt8 = 0
    static var tabBadgePointViewOffset: UInt8 = 0
    static var userInteractionDisabled: UInt8 = 0
}

enum TFYSwiftPrivateUIKitClassNames {
    static let portalView: String = ["_", "UI", "Portal", "View"].joined()
}

func tfy_getViewControllerInsteadOfNavigationController(from viewController: UIViewController?) -> UIViewController? {
    guard let viewController else { return nil }
    if let nav = viewController as? UINavigationController, let first = nav.viewControllers.first {
        return first
    }
    return viewController
}
