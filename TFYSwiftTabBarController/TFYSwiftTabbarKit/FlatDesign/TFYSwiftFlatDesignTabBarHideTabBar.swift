//
//  TFYSwiftFlatDesignTabBarHideTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLFlatDesignTabBarHideTabBar
//

import UIKit

/// System UITabBar stand-in that stays hidden when FlatDesign custom tab bar is used.
@objc open class TFYSwiftFlatDesignTabBarHideTabBar: UITabBar {

    private weak var platterView: UIView?

    open override var isHidden: Bool {
        get { super.isHidden }
        set { super.isHidden = true }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        tfy_platterView?.tfy_setHidden(true)
        platterView?.tfy_setHidden(true)
    }

    open override func addSubview(_ view: UIView) {
        if view is UITabBar { return }
        if view.tfy_isPlatterView() {
            view.isHidden = true
            tfy_platterView = view
            platterView = view
            return
        }
        super.addSubview(view)
    }

    open override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if tfy_isContinuousGestureRecognizer(gestureRecognizer) || tfy_isLongGestureRecognizer(gestureRecognizer) {
            gestureRecognizer.isEnabled = false
        }
        super.addGestureRecognizer(gestureRecognizer)
    }

    private func tfy_isContinuousGestureRecognizer(_ gesture: UIGestureRecognizer) -> Bool {
        gesture.tfy_isContinuousGestureRecognizer()
    }

    private func tfy_isLongGestureRecognizer(_ gesture: UIGestureRecognizer) -> Bool {
        gesture.tfy_isLongGestureRecognizer()
    }
}
