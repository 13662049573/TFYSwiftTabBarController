//
//  UITabBarItem+TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from UITabBarItem+CYLTabBarControllerExtention
//

import ObjectiveC
import UIKit

public extension UITabBarItem {

    @objc var tfy_lottieURL: URL? {
        get { objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.lottieURL) as? URL }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.lottieURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfy_lottieSizeValue: NSValue? {
        get { objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.lottieSizeValue) as? NSValue }
        set { objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.lottieSizeValue, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfy_imagePositionAdjustment: UIOffset {
        get {
            (objc_getAssociatedObject(self, &TFYSwiftAssociatedKeys.imagePositionAdjustment) as? NSValue)?.uiOffsetValue ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftAssociatedKeys.imagePositionAdjustment, NSValue(uiOffset: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc var tfy_tabButton: UIControl? {
        (tfy_view as? UIControl)
    }

    @objc var tfy_view: UIView? {
        let selector = NSSelectorFromString("view")
        if responds(to: selector) {
            return perform(selector)?.takeUnretainedValue() as? UIView
        }
        return nil
    }

    @objc func tfy_isReady() -> Bool {
        (tfy_imageView()?.frame.size.width ?? 0) > 10 || (tfy_view?.tfy_tabLabel()?.frame.size.width ?? 0) > 10
    }

    @objc func tfy_imageView() -> UIImageView? {
        tfy_view?.tfy_tabImageView()
    }

    @objc func tfy_imageViewInTabBarButton() -> UIImageView? {
        tfy_view?.tfy_tabImageView()
    }

    @objc var tfy_selectedTabButton: UIControl? {
        guard TFYSwiftConstants.isLiquidGlassActive(), let view = tfy_view else { return nil }
        guard let index = view.superview?.subviews.firstIndex(of: view), index != NSNotFound else { return nil }
        guard let platterView = tfy_tabBarController?.tabBar.tfy_platterView, platterView.tfy_isPlatterView() else { return nil }
        guard let selectedContentView = platterView.subviews.first(where: { $0.tfy_isPlatterSelectedContentView() }) else { return nil }
        guard index < selectedContentView.subviews.count else { return nil }
        return selectedContentView.subviews[index] as? UIControl
    }

    @objc var tfy_visiableTabButton: UIControl? {
        if TFYSwiftConstants.isLiquidGlassActive() {
            return tfy_selectedTabButton
        }
        return tfy_tabButton
    }
}
