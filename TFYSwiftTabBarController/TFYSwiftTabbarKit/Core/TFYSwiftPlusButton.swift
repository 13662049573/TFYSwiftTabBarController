//
//  TFYSwiftPlusButton.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLPlusButton
//

import UIKit

public var TFYSwiftExternPlusButton: TFYSwiftPlusButton?
public var TFYSwiftPlusChildViewController: UIViewController?

@objc public protocol TFYSwiftPlusButtonSubclassing: AnyObject {
    static func plusButton() -> Any

    @objc optional static func indexOfPlusButtonInTabBar() -> UInt
    @objc optional static func multiplierOfTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat
    @objc optional static func constantOfPlusButtonCenterYOffsetForTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat
    @objc optional static func plusChildViewController() -> UIViewController
    @objc optional static func shouldSelectPlusChildViewController() -> Bool
    @objc optional static func tabBarContext() -> String
    @objc optional func touchableRect() -> CGRect
    @objc optional static func selectedContentView() -> UIButton
    @objc optional static func contentImage() -> UIImage?
    @objc optional static func selectedContentImage() -> UIImage?
    @objc optional func isLayoutCentered() -> Bool
    @objc optional static func matchedTabBarContext(_ tabBarContext: String) -> Bool
    /// Deprecated in 1.6.0. Use `multiplierOfTabBarHeight(_:)`.
    @objc optional static func multiplerInCenterY() -> CGFloat
}

open class TFYSwiftPlusButton: UIButton {

    public weak var selectedContentView: UIButton?
    public var selectedContentImage: UIImage?
    public var contentImage: UIImage?
    private var snapshot: UIImage?
    private weak var contentView: UIButton?

    /// Deprecated in 1.6.0. Use `registerPlusButton()`.
    @available(*, deprecated, renamed: "registerPlusButton()")
    open class func registerSubclass() {
        registerPlusButton()
    }

    open class func registerPlusButton() {
        guard let subclass = self as? TFYSwiftPlusButtonSubclassing.Type else { return }

        if let child = subclass.plusChildViewController?() {
            TFYSwiftPlusChildViewController = child
            let tabBarContext = matchedTabBarContext()
            if !tabBarContext.isEmpty {
                TFYSwiftPlusChildViewController?.tfy_context = tabBarContext
            }
            guard let plusButton = subclass.plusButton() as? TFYSwiftPlusButton else { return }
            TFYSwiftExternPlusButton = plusButton
            TFYSwiftPlusButtonWidth = plusButton.frame.size.width
            addSelectViewControllerTarget(plusButton)

            if let index = subclass.indexOfPlusButtonInTabBar?() {
                TFYSwiftPlusButtonIndex = index
            } else {
                #if DEBUG
                assertionFailure("If you want to add PlusChildViewController, you must implement `indexOfPlusButtonInTabBar`")
                #endif
            }
        } else {
            guard let plusButton = subclass.plusButton() as? TFYSwiftPlusButton else { return }
            TFYSwiftExternPlusButton = plusButton
            TFYSwiftPlusButtonWidth = plusButton.frame.size.width
        }
    }

    open class func removePlusButton() {
        if let button = TFYSwiftExternPlusButton {
            button.removeFromSuperview()
            TFYSwiftExternPlusButton = nil
        }
        if let child = TFYSwiftPlusChildViewController {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            child.tfy_plusViewControllerEverAdded = false
            TFYSwiftPlusChildViewController = nil
        }
    }

    @objc open func plusChildViewControllerButtonClicked(_ sender: UIButton) {
        if let type = type(of: self) as? TFYSwiftPlusButtonSubclassing.Type,
           type.shouldSelectPlusChildViewController?() == false {
            return
        }

        guard let plusChild = TFYSwiftPlusChildViewController else { return }
        let tabBarController = sender.tfy_tabBarController
            ?? tfy_flatDesignTabBarController(from: sender)
        guard let tabBarController,
              let index = tabBarController.viewControllers?.firstIndex(where: {
                  $0 === plusChild || $0.tfy_isEqualToViewController(plusChild)
              }) else { return }

        tabBarController.selectedIndex = index
        if !sender.tfy_userInteractionDisabled {
            sender.isSelected = true
            tabBarController.tabChangedToControl(self)
        }
    }

    private func tfy_flatDesignTabBarController(from view: UIView) -> TFYSwiftTabBarController? {
        var node: UIView? = view
        while let current = node {
            if let flat = current as? TFYSwiftFlatDesignTabBar,
               let tab = flat.delegate as? TFYSwiftTabBarController {
                return tab
            }
            node = current.superview
        }
        return nil
    }

    private class func addSelectViewControllerTarget(_ plusButton: TFYSwiftPlusButton) {
        var target: AnyObject = self
        var selectorNames = plusButton.actions(forTarget: target, forControlEvent: .touchUpInside) ?? []
        if selectorNames.isEmpty {
            target = plusButton
            selectorNames = plusButton.actions(forTarget: target, forControlEvent: .touchUpInside) ?? []
        }
        for name in selectorNames {
            plusButton.removeTarget(target, action: NSSelectorFromString(name), for: .touchUpInside)
        }
        plusButton.addTarget(plusButton, action: #selector(plusChildViewControllerButtonClicked(_:)), for: .touchUpInside)
    }

    @objc open func isLayoutCentered() -> Bool {
        constantOfPlusButtonCenterYOffsetForTabBarHeight() == 0
            && defaultMultiplierOfTabBarHeight() == 0.5
    }

    open func defaultMultiplierOfTabBarHeight() -> CGFloat {
        let height = tfy_tabBarController?.tabBar.tfy_boundsSize().height ?? 49
        return multiplierOfTabBarHeight(height, plusButtonHeight: frame.size.height)
    }

    open func multiplierOfTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat {
        multiplierOfTabBarHeight(tabBarHeight, plusButtonHeight: frame.size.height)
    }

    open func multiplierOfTabBarHeight(_ tabBarHeight: CGFloat, plusButtonHeight: CGFloat) -> CGFloat {
        if let type = type(of: self) as? TFYSwiftPlusButtonSubclassing.Type,
           let value = type.multiplierOfTabBarHeight?(tabBarHeight) {
            return value
        }
        if let type = type(of: self) as? TFYSwiftPlusButtonSubclassing.Type,
           let value = type.multiplerInCenterY?() {
            return value
        }
        let heightDifference = plusButtonHeight - tabBarHeight
        if heightDifference < 0 {
            return 0.5
        }
        var center = CGPoint(x: tabBarHeight * 0.5, y: tabBarHeight * 0.5)
        center.y -= heightDifference * 0.5
        return center.y / tabBarHeight
    }

    open func constantOfPlusButtonCenterYOffsetForTabBarHeight() -> CGFloat {
        let height = tfy_tabBarController?.tabBar.tfy_boundsSize().height ?? 49
        return constantOfPlusButtonCenterYOffsetForTabBarHeight(height)
    }

    open func constantOfPlusButtonCenterYOffsetForTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat {
        if let type = type(of: self) as? TFYSwiftPlusButtonSubclassing.Type,
           let value = type.constantOfPlusButtonCenterYOffsetForTabBarHeight?(tabBarHeight) {
            return value
        }
        return 0
    }

    @objc open func touchableRect() -> CGRect { frame }

    open func getSnapshot() -> UIImage? {
        if let snapshot {
            return UIImage(cgImage: snapshot.cgImage!, scale: snapshot.scale, orientation: snapshot.imageOrientation)
        }
        snapshot = tfy_takeSnapshot()
        return snapshot
    }

    @objc open class func selectedContentView() -> UIButton {
        let live = TFYSwiftExternPlusButton
        let wasHighlighted = live?.isHighlighted ?? false
        live?.isHighlighted = true
        guard let type = self as? TFYSwiftPlusButtonSubclassing.Type,
              let plusButton = type.plusButton() as? TFYSwiftPlusButton else {
            live?.isHighlighted = wasHighlighted
            return UIButton(type: .custom)
        }
        live?.isHighlighted = wasHighlighted
        plusButton.isHighlighted = true
        plusButton.isUserInteractionEnabled = false
        plusButton.backgroundColor = .clear
        plusButton.isOpaque = false
        return plusButton
    }

    open func resolveSelectedContentView() -> UIButton {
        if let selectedContentView { return selectedContentView }
        if let type = type(of: self) as? TFYSwiftPlusButtonSubclassing.Type,
           let button = type.selectedContentView?() {
            selectedContentView = button
            return button
        }
        let button = UIButton(type: .custom)
        let normal = (type(of: self) as? TFYSwiftPlusButtonSubclassing.Type)?.contentImage?()
            ?? contentImage
            ?? UIImage()
        let highlighted = (type(of: self) as? TFYSwiftPlusButtonSubclassing.Type)?.selectedContentImage?()
            ?? selectedContentImage
            ?? UIImage()
        button.setImage(normal, for: .normal)
        button.setImage(highlighted, for: .highlighted)
        button.frame = CGRect(origin: .zero, size: bounds.size)
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.sizeToFit()
        if !tfy_userInteractionDisabled {
            button.isHighlighted = true
        }
        selectedContentView = button
        return button
    }

    open func setTabLabelHidden(_ hidden: Bool) {
        guard TFYSwiftConstants.isLiquidGlassActive() else { return }
        guard let plus = TFYSwiftExternPlusButton, TFYSwiftPlusChildViewController != nil else { return }
        guard !plus.tfy_keepShowingPlusButtonLabel else { return }
        guard let label = plus.tfy_tabLabel(), !(label.text?.isEmpty ?? true) else { return }
        label.isHidden = hidden
        clearOpaqueLabelFill(label)
        let coverLabel = plus.resolveSelectedContentView().tfy_tabLabel()
        coverLabel?.isHidden = !hidden
        if let coverLabel {
            clearOpaqueLabelFill(coverLabel)
        }
    }

    private func clearOpaqueLabelFill(_ label: UILabel) {
        label.backgroundColor = .clear
        label.isOpaque = false
    }

    @objc open class func contentImage() -> UIImage? { nil }
    @objc open class func selectedContentImage() -> UIImage? { nil }

    open func resolveSelectedContentImage() -> UIImage? {
        if let selectedContentImage { return selectedContentImage }
        selectedContentImage = imageView?.image
        return selectedContentImage
    }

    open func resolveContentImage() -> UIImage? {
        if let contentImage { return contentImage }
        contentImage = imageView?.image
        return contentImage
    }

    open class func hasPlusButton(forTabBarContext tabBarContext: String?) -> Bool {
        let matched = matchedTabBarContext()
        guard let tabBarContext, !matched.isEmpty else { return false }
        return matched == tabBarContext
    }

    open class func hasPlusChildViewController(forTabBarContext tabBarContext: String?) -> Bool {
        let context = TFYSwiftPlusChildViewController?.tfy_context
        guard let context, let tabBarContext else { return false }
        return TFYSwiftPlusChildViewController != nil && context == tabBarContext
    }

    open class func matchedTabBarContext() -> String {
        if let type = self as? TFYSwiftPlusButtonSubclassing.Type,
           let context = type.tabBarContext?(), !context.isEmpty {
            return context
        }
        return NSStringFromClass(TFYSwiftTabBarController.self)
    }

    open class func index(forTabbarItemsCount tabbarItemsCount: UInt) -> UInt {
        if let type = self as? TFYSwiftPlusButtonSubclassing.Type,
           let index = type.indexOfPlusButtonInTabBar?() {
            return index
        }
        if tabbarItemsCount % 2 != 0 {
            #if DEBUG
            assertionFailure("If tabbar item count is odd, implement indexOfPlusButtonInTabBar")
            #endif
            return NSNotFound.magnitude
        }
        return tabbarItemsCount / 2
    }
}
