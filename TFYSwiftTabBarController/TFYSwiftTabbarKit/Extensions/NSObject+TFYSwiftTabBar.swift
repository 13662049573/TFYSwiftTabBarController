//
//  NSObject+TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from NSObject+CYLTabBarControllerExtention.h/.m
//  and NSObject (CYLTabBarControllerReferenceExtension) in CYLTabBarController.h
//

import UIKit
import ObjectiveC

// MARK: - String

extension String {

    func tfy_trim() -> String {
        var set = CharacterSet.whitespacesAndNewlines
        set.insert("\0")
        return trimmingCharacters(in: set)
    }
}

// MARK: - Associated Keys

private var tfyContextKey: UInt8 = 0
private var tfyIsForceLandscapeKey: UInt8 = 0
private var tfyIsPlaceholderKey: UInt8 = 0
private var tfyTabBarControllerKey: UInt8 = 0

// MARK: - NSObject (TabBar Extension)

extension NSObject {

    var tfy_context: String {
        get {
            if let stored = objc_getAssociatedObject(self, &tfyContextKey) as? String, !stored.isEmpty {
                return stored
            }
            return NSStringFromClass(TFYSwiftTabBarController.self)
        }
        set {
            let value = newValue.isEmpty ? NSStringFromClass(TFYSwiftTabBarController.self) : newValue
            objc_setAssociatedObject(self, &tfyContextKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var tfy_isForceLandscape: Bool {
        get { (objc_getAssociatedObject(self, &tfyIsForceLandscapeKey) as? NSNumber)?.boolValue ?? false }
        set {
            objc_setAssociatedObject(self, &tfyIsForceLandscapeKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var tfy_isPlaceholder: Bool {
        get {
            let stored = (objc_getAssociatedObject(self, &tfyIsPlaceholderKey) as? NSNumber)?.boolValue ?? false
            guard let viewController = self as? UIViewController else { return stored }
            let resolved = viewController.tfy_getViewControllerInsteadOfNavigationController()
            let fromNav = (objc_getAssociatedObject(resolved, &tfyIsPlaceholderKey) as? NSNumber)?.boolValue ?? false
            return stored || fromNav
        }
        set {
            objc_setAssociatedObject(self, &tfyIsPlaceholderKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let viewController = self as? UIViewController else { return }
            let resolved = viewController.tfy_getViewControllerInsteadOfNavigationController()
            objc_setAssociatedObject(resolved, &tfyIsPlaceholderKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Weak-reference block pattern from CYLTabBarControllerReferenceExtension.
    var tfy_tabBarController: TFYSwiftTabBarController? {
        get {
            if let block = objc_getAssociatedObject(self, &tfyTabBarControllerKey) as? () -> AnyObject?,
               let controller = block() as? TFYSwiftTabBarController,
               controller.tfy_isSystemStyleTabBar() {
                return controller
            }
            if let viewController = self as? UIViewController,
               let parent = viewController.parent,
               let controller = parent.tfy_tabBarController,
               controller.tfy_isSystemStyleTabBar() {
                return controller
            }
            if let root = tfy_getRootViewController()?.tfy_getViewControllerInsteadOfNavigationController(),
               root.tfy_isSystemStyleTabBar(),
               let controller = root as? TFYSwiftTabBarController {
                return controller
            }
            if let block = objc_getAssociatedObject(self, &tfyTabBarControllerKey) as? () -> AnyObject? {
                return block() as? TFYSwiftTabBarController
            }
            return nil
        }
        set {
            weak let weakController = newValue
            let block: () -> AnyObject? = { weakController as AnyObject? }
            objc_setAssociatedObject(self, &tfyTabBarControllerKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func tfy_setTabBarController(_ tabBarController: TFYSwiftTabBarController?) {
        self.tfy_tabBarController = tabBarController
    }

    func tfy_sharedAppDelegate() -> (UIResponder & UIApplicationDelegate) {
        guard let delegate = UIApplication.shared.delegate else {
            fatalError("UIApplication.shared.delegate is nil")
        }
        if let responder = delegate as? UIResponder & UIApplicationDelegate {
            return responder
        }
        fatalError("UIApplication.shared.delegate is not UIResponder")
    }

    func tfy_forceUpdateInterfaceOrientation(_ orientation: UIInterfaceOrientation) {
        let appDelegate = tfy_sharedAppDelegate()
        let isForceLandscape = orientation == .landscapeLeft || orientation == .landscapeRight
        (appDelegate as NSObject).tfy_isForceLandscape = isForceLandscape

        if appDelegate.responds(to: #selector(UIApplicationDelegate.application(_:supportedInterfaceOrientationsFor:))) {
            _ = appDelegate.application?(UIApplication.shared, supportedInterfaceOrientationsFor: tfy_getRootWindow())
        }

        if #available(iOS 16.0, *) {
            guard let windowScene = tfy_getWindowScene() else { return }
            var topVC = windowScene.keyWindow?.rootViewController
            while let presented = topVC?.presentedViewController {
                topVC = presented
            }
            guard let topVC else { return }

            var targetMask = tfy_mask(from: orientation)
            let supportedMask = topVC.supportedInterfaceOrientations
            if supportedMask.intersection(targetMask).isEmpty {
                targetMask = supportedMask
            }
            topVC.setNeedsUpdateOfSupportedInterfaceOrientations()
            let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: targetMask)
            windowScene.requestGeometryUpdate(preferences) { _ in }
        } else if UIDevice.current.responds(to: NSSelectorFromString("setOrientation:")) {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        }
    }

    @objc(tfy_setValue:forKey:)
    func tfy_setValue(_ value: Any?, forKey key: String) {
        TFYSwiftKVCHelper.setValue(value, forKey: key, on: self)
    }

    func tfy_ivarList() -> String {
        let selector = NSSelectorFromString("_ivarDescription")
        guard responds(to: selector),
              let systemResult = tfy_performStringSelector(selector) else {
            return ""
        }
        let pattern = "^(\\s+)(\\S+)"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return systemResult
        }
        var lines = systemResult.components(separatedBy: "\n")
        for (idx, line) in lines.enumerated() {
            if line.tfy_trim().count <= 2 { continue }
            if line.hasPrefix("\t\t") { continue }
            let nsLine = line as NSString
            let range = NSRange(location: 0, length: nsLine.length)
            guard let match = regex.firstMatch(in: line, options: [], range: range),
                  match.numberOfRanges >= 3 else { continue }
            let indentRange = match.range(at: 1)
            let nameRange = match.range(at: 2)
            let ivarName = nsLine.substring(with: nameRange)
            guard let ivar = class_getInstanceVariable(object_getClass(self), ivarName) else { continue }
            let offset = ivar_getOffset(ivar)
            let offsetRange = NSRange(location: NSMaxRange(indentRange), length: 0)
            let replacement = "[\(offset)|0x\(String(format: "%lx", offset).uppercased())]"
            lines[idx] = (line as NSString).replacingCharacters(in: offsetRange, with: replacement)
        }
        return lines.joined(separator: "\n")
    }

    func tfy_methodList() -> String? {
        tfy_performStringSelector(NSSelectorFromString("_methodDescription"))
    }

    func tfy_shortMethodList() -> String? {
        tfy_performStringSelector(NSSelectorFromString("_shortMethodDescription"))
    }

    func tfy_viewInfo() -> String {
        guard self is UIView else { return "Sorry, only support UIView" }
        return tfy_performStringSelector(NSSelectorFromString("recursiveDescription")) ?? ""
    }

    func tfy_isContinuousGestureRecognizer() -> Bool {
        let name = NSStringFromClass(type(of: self))
        return name.hasPrefix("_UIContinuous") && name.hasSuffix("tionGestureRecognizer")
    }

    func tfy_isLongGestureRecognizer() -> Bool {
        let name = NSStringFromClass(type(of: self))
        return name.hasPrefix("UILongPr") && name.hasSuffix("essGestureRecognizer")
    }

    func tfy_isPlusViewControllerAdded(_ viewControllers: [UIViewController]) -> Bool {
        guard let plusChild = TFYSwiftPlusChildViewController else { return false }
        if viewControllers.contains(plusChild) { return true }
        return viewControllers.contains { $0.tfy_isEqualToViewController(plusChild) }
    }

    func tfy_removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        TFYSwiftKVCHelper.removeObserver(observer, forKeyPath: keyPath, from: self)
    }

    // MARK: - Class Methods

    @objc class func tfy_topmostViewController() -> UIViewController? {
        guard var top = tfy_getRootWindow()?.rootViewController else { return nil }
        while true {
            if let presented = top.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController, let visible = nav.topViewController {
                top = visible
            } else if let tab = top as? UITabBarController, let selected = tab.selectedViewController {
                top = selected
            } else {
                break
            }
        }
        return top
    }

    @objc class func tfy_currentNavigationController() -> UINavigationController? {
        tfy_topmostViewController()?.navigationController
    }

    @objc class func tfy_dismissAll(_ completion: (() -> Void)?) {
        guard var top = tfy_getRootViewController() else {
            completion?()
            return
        }
        var list: [UIViewController] = []
        while true {
            if let presented = top.presentedViewController {
                top = presented
                list.append(top)
            } else if let nav = top as? UINavigationController, let visible = nav.topViewController {
                top = visible
            } else if let tab = top as? UITabBarController, let selected = tab.selectedViewController {
                top = selected
            } else {
                break
            }
        }
        guard !list.isEmpty else {
            completion?()
            return
        }
        for i in stride(from: list.count - 1, through: 0, by: -1) {
            let vc = list[i]
            if let nav = vc as? UINavigationController {
                nav.popToRootViewController(animated: false)
            }
            vc.dismiss(animated: false, completion: i == 0 ? completion : nil)
        }
    }

    func tfy_performStringSelector(_ selector: Selector) -> String? {
        guard responds(to: selector) else { return nil }
        return perform(selector)?.takeUnretainedValue() as? String
    }
}

// MARK: - Objective-C runtime helpers

enum TFYSwiftKVCHelper {
    static func setValue(_ value: Any?, forKey key: String, on object: NSObject) {
        object.setValue(value, forKey: key)
    }

    static func removeObserver(_ observer: NSObject, forKeyPath keyPath: String, from object: NSObject) {
        object.removeObserver(observer, forKeyPath: keyPath)
    }
}

// MARK: - Private Helpers

private func tfy_mask(from orientation: UIInterfaceOrientation) -> UIInterfaceOrientationMask {
    switch orientation {
    case .portrait: return .portrait
    case .portraitUpsideDown: return .portraitUpsideDown
    case .landscapeLeft: return .landscapeLeft
    case .landscapeRight: return .landscapeRight
    default: return .portrait
    }
}
