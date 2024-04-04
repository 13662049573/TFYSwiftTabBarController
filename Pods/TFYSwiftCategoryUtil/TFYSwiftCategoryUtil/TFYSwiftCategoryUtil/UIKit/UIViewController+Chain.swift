//
//  UIViewController+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation
import UIKit
import SafariServices

public func TopestController(inWindow window: UIWindow? = nil) -> UIViewController? {
    return TFY<UIViewController>.topestController(inWindow: window)
}

public enum UIViewControllerFindParentControllerOption {
    case first // 找到的第一个
    case last // 找到的最后一个
}

public extension TFY where Base: UIViewController {
    
    /// 获取当前controller指定class的parentViewController
    ///
    /// - Parameter clazz: 想要获取的parentViewController的class
    /// option: 查找选项
    ///
    /// - Returns: 当前controller指定class的parentViewController
    func findParentController(forClass clazz: AnyClass,
                              option: UIViewControllerFindParentControllerOption = .first) -> UIViewController? {
        var result: UIViewController? = nil
        
        var currentController = base.parent
        while let whileController = currentController {
            if whileController.isKind(of: clazz) {
                result = whileController
                
                if option == .first {
                    break
                }
            }
            currentController = whileController.parent
        }
        
        return result
    }
    
    /// 获取当前App最顶层的controller
    /// 通常为最后被present的controller
    /// 或UITabBarController中显示的controller
    /// 或UINavigationController中显示的controller
    ///
    /// - Returns: 当前App最顶层的controller
    static func topestController(inWindow window: UIWindow? = nil) -> UIViewController? {
        return topestController(withRootViewController: window?.rootViewController)
    }
    
    private static func topestController(withRootViewController rootViewController: UIViewController? = nil) -> UIViewController? {
        guard let controller = rootViewController ?? UIWindow.keyWindow!.rootViewController else {
            return nil
        }
        
        var findController: UIViewController? = controller
        
        if let presentedViewController = controller.presentedViewController {
            findController = presentedViewController
        }
        else if let tabBarController = controller as? UITabBarController {
            findController = tabBarController.selectedViewController ?? tabBarController.viewControllers?.last
        }
        else if let navigationController = controller as? UINavigationController {
            findController = navigationController.visibleViewController ?? navigationController.viewControllers.last
        }
        else {
            while let vc = findController, vc.isBeingDismissed {
                findController = findController?.presentingViewController
            }
            return findController
        }
        
        if findController == nil {
            return controller
        }
        
        return topestController(withRootViewController: findController)
    }
    
}


public extension UIViewController {
    
    /// ViewController class name
    var classNameValue: String { NSStringFromClass(self.classForCoder).components(separatedBy: ".").last! }
    
    /// Adds a child viewController to the current controller view
    /// - Parameter viewController: The child view
    func addChild(viewController: UIViewController, in view: UIView) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    /// Removes a child viewController from current
    /// - Parameter viewController: The child view controller to remove
    func removeChild(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    /// Combine an array of models and an array of views.
    ///
    /// - Parameters:
    ///   - models: The models as data source.
    ///   - views: The views in need of loading data. Note that this is an inout parameters.
    ///   - newViewGeneration: The function to generate new views, which would immediately be appended into `views`.
    ///   - operation: The main operation that combine each model and view together.
    ///   - remainingViews: The handler responsible for dealing with the rest of unused views.
    class func combine<Model, View>(models: [Model], into views: inout [View], newViewGeneration: () -> View, using operation: (Model, View) -> Void, remainingViews: (ArraySlice<View>) -> Void) {

        // If the models outnumber the views, generate more views
        if models.count > views.count {
            for _ in 0 ..< models.count - views.count {
                views.append(newViewGeneration())
            }
        }

        // Combine each model into each view
        for i in 0 ..< models.count {
            operation(models[i], views[i])
        }

        // Handle the rest of unused views
        if views.count > models.count {
            remainingViews(views.suffix(from: models.count))
        }
    }

    /// Present system alert
    ///
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message
    ///   - confirmTitle: Confirm button title
    ///   - confirmHandler: Confirm handler to run on press
    ///   - cancelTitle: Cancel button title
    ///   - cancelHandler: Cancel handler to run on press
    func showSystemAlert(
        title: String?,
        message: String? = nil,
        confirmTitle: String? = nil,
        confirmHandler: (() -> Void)? = nil,
        cancelTitle: String = "Cancel",
        cancelHandler: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let cancelAction = UIAlertAction(
            title: cancelTitle,
            style: .cancel,
            handler: { _ in cancelHandler?() }
        )
        alertController.addAction(cancelAction)

        if let confirmTitle = confirmTitle {
            let confirmAction = UIAlertAction(
                title: confirmTitle,
                style: .default,
                handler: { _ in confirmHandler?() }
            )
            alertController.addAction(confirmAction)
        }

        present(alertController, animated: true, completion: nil)
    }

    /// Present system alert with distructive primary action
    ///
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message
    ///   - confirmTitle: Confirm button title
    ///   - confirmHandler: Confirm handler to run on press
    ///   - cancelTitle: Cancel button title
    ///   - cancelHandler: Cancel handler to run on press
    func showSystemDistructiveAlert(
        title: String?,
        message: String? = nil,
        destructiveTitle: String?,
        destructiveHandler: (() -> Void)?,
        cancelTitle: String?,
        cancelHandler: (() -> Void)? = nil)
    {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(
            title: cancelTitle,
            style: .cancel,
            handler: { _ in
                cancelHandler?()
            }))
        alertViewController.addAction(UIAlertAction(
            title: destructiveTitle,
            style: .destructive,
            handler: { _ in
                destructiveHandler?()
            }))
        present(alertViewController, animated: true, completion: nil)
    }


    /// Present action sheet
    ///
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message
    ///   - actions: Actions in the sheet
    func showSystemActionSheet(title: String?, message: String?, validActions: (String?, (() -> Void)?)...) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        validActions.forEach { action in
            ac.addAction(UIAlertAction(
                title: action.0,
                style: .default,
                handler: { _ in
                    action.1?()
                }))
        }
        ac.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        present(ac, animated: true, completion: nil)
    }


    /// NavigationBar tint color
    var titleColor: UIColor? {
        get {
            return navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] as? UIColor
        }
        set {
            if navigationController?.navigationBar.titleTextAttributes == nil {
                navigationController?.navigationBar.titleTextAttributes = [:]
            }
            navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = newValue
        }
    }


    /// NavigationBar font
    var titleFont: UIFont? {
        get {
            return navigationController?.navigationBar.titleTextAttributes?[.font] as? UIFont
        }
        set {
            if navigationController?.navigationBar.titleTextAttributes == nil {
                navigationController?.navigationBar.titleTextAttributes = [:]
            }
            navigationController?.navigationBar.titleTextAttributes?[.font] = newValue
        }
    }

    /// Is view loaded and in window
    var viewIsVisible: Bool {
        return (isViewLoaded && view.window != nil)
    }

    private struct AutoHideKeyboardTapKey {
        static var autoHideKeyboardTapKey: UInt8 = 111
    }

    /// Should hide keyboard on view tap
    var automaticallyHideKeyboardWhenViewTapped: Bool {
        get {
            return objc_getAssociatedObject(self, &AutoHideKeyboardTapKey.autoHideKeyboardTapKey) != nil
        }
        set {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.resignTextFieldToHideKeyboard(_:)))
            view.addGestureRecognizer(tap)
            objc_setAssociatedObject(self, &AutoHideKeyboardTapKey.autoHideKeyboardTapKey, tap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
    }
    
    /// Resign keyboard
    @IBAction func resignTextFieldToHideKeyboard(_ sender: AnyObject) {
        view.endEditing(false)
    }

    /// Get the current visible view controller by crawling the view controller heirarchy
    ///
    /// - Parameter base: `UIViewController` to search
    /// - Returns: Current `UIViewController`
    @available(iOS 13.0, *)
    class func getCurrentViewController(base: UIViewController? = KeyWindows()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurrentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getCurrentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrentViewController(base: presented)
        }
        return base
    }
    
   class func KeyWindows() -> UIWindow? {
        var keyWindow:UIWindow?
        keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        return keyWindow
    }

    /// Add a bottom tool bar to view controller
    var bottomToolBar: UIView? {
        get {
            if let toolbarItems = toolbarItems, toolbarItems.count == 3 {
                return toolbarItems[1].customView
            }
            return nil
        }
        set {
            if let bar = newValue {
                let toolbarItems = [
                    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                    UIBarButtonItem(customView: bar),
                    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                ]
                setToolbarItems(toolbarItems, animated: false)
            } else {
                setToolbarItems(nil, animated: false)
            }
        }
    }

    /// Pop view controller from nav stack
    func popFromNavigationStack() {
        navigationController?.popViewController(animated: true)
    }

    /// Add dismiss `UIBarButtonItem` naviation item
    func addDismissNavigationItem(localizedTitle: String = "Dismiss", image: UIImage? = nil) {
        if let image = image {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(dismissSelf(_:)))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: localizedTitle, style: .plain, target: self, action: #selector(dismissSelf(_:)))
        }
    }

    @objc func dismissSelf(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private struct HidesNavigationBarBackgroundKey {
        static var whenVisible = "hidesNavigationBarBackgroundWhenVisible"
    }

    /// Hide navigation bar background when visible
    var hidesNavigationBarBackgroundWhenVisible: Bool {
        get {
            return (objc_getAssociatedObject(self,(HidesNavigationBarBackgroundKey.whenVisible)) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self,(HidesNavigationBarBackgroundKey.whenVisible), true, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    /// Navigation bar height
    var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.bounds.height ?? 0
    }

    /// Tab bar height
    var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.bounds.height ?? 0
    }

    func pushSafariViewController(urlString: String, entersReaderIfAvailable: Bool = false) {
        if let url = URL(string: urlString) {
            let safariViewController: SFSafariViewController = {
                if #available(iOS 11.0, *) {
                    let configuration = SFSafariViewController.Configuration()
                    configuration.entersReaderIfAvailable = entersReaderIfAvailable
                    return SFSafariViewController(url: url, configuration: configuration)
                } else {
                    return SFSafariViewController(url: url)
                }
            }()
            if #available(iOS 11.0, *) {
                safariViewController.dismissButtonStyle = .close
                safariViewController.configuration.entersReaderIfAvailable = true
            }
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
