//
//  TFYSwiftConstants.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLConstants / CYLTabBarController public constants.
//  Copyright © 2026. All rights reserved.
//

import UIKit

// MARK: - Attribute Keys

public let TFYSwiftTabBarItemTitle = "TFYSwiftTabBarItemTitle"
public let TFYSwiftTabBarItemImage = "TFYSwiftTabBarItemImage"
public let TFYSwiftTabBarItemSelectedImage = "TFYSwiftTabBarItemSelectedImage"
public let TFYSwiftTabBarLottieFilePath = "TFYSwiftTabBarLottieFilePath"
public let TFYSwiftTabBarLottieURL = "TFYSwiftTabBarLottieURL"
public let TFYSwiftTabBarLottieSize = "TFYSwiftTabBarLottieSize"
public let TFYSwiftTabBarItemImageInsets = "TFYSwiftTabBarItemImageInsets"
public let TFYSwiftTabBarItemTitlePositionAdjustment = "TFYSwiftTabBarItemTitlePositionAdjustment"
public let TFYSwiftTabBarItemImagePositionAdjustment = "TFYSwiftTabBarItemImagePositionAdjustment"

// MARK: - Layout Globals

public var TFYSwiftTabbarItemsCount: UInt = 0
public var TFYSwiftPlusButtonIndex: UInt = 0
public var TFYSwiftPlusButtonWidth: CGFloat = 0
public var TFYSwiftTabBarItemWidth: CGFloat = 0
public var TFYSwiftTabBarHeight: CGFloat = 49
public var TFYSwiftTabBarItemImagePlaceholderWidth: CGFloat = 22
public var TFYSwiftTabBarItemImagePlaceholderHeight: CGFloat = 22
/// CALayer.zPosition is Float. `CGFloat.greatestFiniteMagnitude` is DBL_MAX and trips iOS 26.
let TFYSwiftLayerFrontZPosition = CGFloat(Float.greatestFiniteMagnitude.nextDown)

/// Hook for `TFYSwiftTabBarControllerLottie`. Do not `perform` Swift Lottie inits — that crashes in `object_getMethodImplementation`.
public var TFYSwiftMakeCompatibleLottieView: ((String, CGSize) -> UIView?)?

// MARK: - Notifications

public extension Notification.Name {
    static let TFYSwiftTabBarItemLottieAnimationPlaying = Notification.Name("TFYSwiftTabBarItemLottieAnimationPlayingNotification")
    static let TFYSwiftTabBarStyleTypeDidChange = Notification.Name("TFYSwiftTabBarStyleTypeDidChangeNotification")
    static let TFYSwiftTabBarItemWidthDidChange = Notification.Name("TFYSwiftTabBarItemWidthDidChangeNotification")
}

// MARK: - Style

@objc public enum TFYSwiftTabBarStyleType: Int {
    case `default` = 0
    case system
    case flatDesign
    case liquidGlass
}

// MARK: - Constants

public final class TFYSwiftConstants: NSObject {

    private static var basisWidthScale: CGFloat = 1
    private static var basisHeightScale: CGFloat = 1
    private static var didInitializeScales = false

    private static func ensureScales() {
        guard !didInitializeScales else { return }
        didInitializeScales = true
        let size = tfy_getRootWindow()?.windowScene?.screen.bounds.size
            ?? UIScreen.main.bounds.size
        basisWidthScale = size.width / 375
        basisHeightScale = size.height / 667
    }

    @objc public class func uiBasisWidthScale() -> CGFloat {
        ensureScales()
        return basisWidthScale
    }

    @objc public class func uiBasisHeightScale() -> CGFloat {
        ensureScales()
        return basisHeightScale
    }

    /// Liquid Glass active when iOS 27+, or iOS 26+ without UIDesignRequiresCompatibility.
    @objc public class func isLiquidGlassActive() -> Bool {
        isUsedLiquidGlass()
    }

    @objc public class func isUsedLiquidGlass() -> Bool {
        struct Holder {
            static let value: Bool = {
                if #available(iOS 27.0, *) {
                    return true
                }
                if #available(iOS 26.0, *) {
                    let requiresCompat = Bundle.main.object(forInfoDictionaryKey: "UIDesignRequiresCompatibility") as? Bool ?? false
                    return !requiresCompat
                }
                return false
            }()
        }
        return Holder.value
    }

    @objc public class func tfy_getTrueLottieSizeValue(_ lottieSizeValue: NSValue?, fromNormalImage normalImage: UIImage?) -> NSValue {
        if let lottieSizeValue, lottieSizeValue.cgSizeValue != .zero {
            return lottieSizeValue
        }
        if let normalImage, normalImage.size != .zero {
            return NSValue(cgSize: normalImage.size)
        }
        return NSValue(cgSize: CGSize(
            width: TFYSwiftTabBarItemImagePlaceholderWidth,
            height: TFYSwiftTabBarItemImagePlaceholderHeight
        ))
    }

    @objc public class func tfy_getURL(from string: String?) -> URL? {
        guard let string, !string.isEmpty else { return nil }
        if FileManager.default.fileExists(atPath: string) {
            return URL(fileURLWithPath: string)
        }
        return nil
    }

    @objc public class func isLottieEnabled(
        fromLottieURLs lottieURLs: NSMutableArray?,
        tabBarItemsAttributes: [[AnyHashable: Any]]?
    ) -> Bool {
        let urlCount = lottieURLs?.count ?? 0
        var fromAttributes = false
        if let first = tabBarItemsAttributes?.first {
            fromAttributes = first[TFYSwiftTabBarLottieURL] != nil || first[TFYSwiftTabBarLottieFilePath] != nil
        }
        return urlCount > 0 || fromAttributes
    }
}

// MARK: - Window / Screen Helpers

public func tfy_getWindowScene() -> UIWindowScene? {
    UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }
}

public func tfy_getRootWindow() -> UIWindow? {
    if let window = UIApplication.shared.delegate?.window ?? nil {
        return window
    }
    return tfy_getWindowScene()?.windows.first
}

public func tfy_getRootViewController() -> UIViewController? {
    guard var root = tfy_getRootWindow()?.rootViewController else { return nil }
    while let presented = root.presentedViewController {
        root = presented
    }
    return root
}

public func tfy_getTabBarFullH(_ baseTabBarHeight: CGFloat) -> CGFloat {
    let bottom = tfy_getRootWindow()?.safeAreaInsets.bottom ?? 0
    return bottom > 0 ? baseTabBarHeight + bottom : baseTabBarHeight
}

public func tfy_screenSize() -> CGSize {
    var size = tfy_getWindowScene()?.screen.bounds.size ?? .zero
    if size.width == 0 || size.height == 0 {
        size = UIScreen.main.bounds.size
    }
    return size
}

public func tfy_screenWidth() -> CGFloat { tfy_screenSize().width }
public func tfy_screenHeight() -> CGFloat { tfy_screenSize().height }

public func tfy_scaleValue(_ value: CGFloat) -> CGFloat {
    value * TFYSwiftConstants.uiBasisWidthScale()
}

public func tfy_hScaleValue(_ value: CGFloat) -> CGFloat {
    value * TFYSwiftConstants.uiBasisHeightScale()
}

public func tfy_scaleFont(_ fontSize: CGFloat) -> UIFont {
    UIFont.systemFont(ofSize: tfy_scaleValue(fontSize))
}

public func tfy_scaleBoldFont(_ fontSize: CGFloat) -> UIFont {
    UIFont.boldSystemFont(ofSize: tfy_scaleValue(fontSize))
}

public func tfy_rgbColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}

public func tfy_rgbaColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
}

public func tfy_stringEqual(_ a: String?, _ b: String?) -> Bool {
    a == b
}

public func tfy_halfOfDiff(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat {
    (value1 - value2) * 0.5
}

public var tfy_isIOS26: Bool {
    (Float(UIDevice.current.systemVersion) ?? 0) >= 26
}

public var tfy_isIOS27: Bool {
    (Float(UIDevice.current.systemVersion) ?? 0) >= 27
}

public var tfy_isIPhone: Bool {
    UIDevice.current.userInterfaceIdiom == .phone
}

public func tfy_systemVersionGreaterThanOrEqualTo(_ version: String) -> Bool {
    (UIDevice.current.systemVersion as NSString).compare(version, options: .numeric) != .orderedAscending
}
