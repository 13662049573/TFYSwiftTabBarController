//
//  TFYSwiftNavigationController.swift
//  TFYSwiftNavigationController
//
//  Created by 田风有 on 2022/5/4.
//

import UIKit

public class TFYSwiftNavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        removedimmingView()
        TFYSwiftNavigationBar.setup()
        TFYSwiftNavigationBarStyle.backgroundColor = .secondarySystemBackground
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        removedimmingView()
    }
    
    private func removedimmingView() {
        let viewsArr:[UIView] = view.subviews
        viewsArr.forEach { view in
            if view.isKind(of: NSClassFromString("UINavigationTransitionView")!) {
                let views:[UIView] = view.subviews
                views.forEach { subView in
                    if subView.isKind(of: NSClassFromString("UIViewControllerWrapperView")!) {
                        let perViews:[UIView] = subView.subviews
                        perViews.forEach { perView in
                            if perView.isKind(of: NSClassFromString("_UIParallaxDimmingView")!) {
                                perView.backgroundColor = .clear
                                perView.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UINavigationController {
    
    /// 关联对象的keys
    private struct AssociatedKeys {
        
        static var gestureDelegate = UnsafeRawPointer(bitPattern: "gestureDelegate".hashValue)!
        static var fullscreenPopGestureDelegate = UnsafeRawPointer(bitPattern: "fullscreenPopGestureDelegate".hashValue)!
        static var fullscreenPopGestureRecognizer = UnsafeRawPointer(bitPattern: "fullscreenPopGestureRecognizer".hashValue)!
        static var enableSYNavigationBar = UnsafeRawPointer(bitPattern: "enableSYNavigationBar".hashValue)!
    }
    
    /// 关联gestureDelegate
    private var tfy_gestureDelegate: TFYSwiftNavigationGestureRecognizerDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.gestureDelegate) as? TFYSwiftNavigationGestureRecognizerDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.gestureDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 关联fullscreenPopGestureDelegate
    private var tfy_fullscreenPopGestureDelegate: TFYSwiftFullscreenPopGestureRecognizerDelegate {
        if let delegate = objc_getAssociatedObject(self, &AssociatedKeys.fullscreenPopGestureDelegate) as? TFYSwiftFullscreenPopGestureRecognizerDelegate {
            return delegate
        }
        let delegate = TFYSwiftFullscreenPopGestureRecognizerDelegate(navigationController: self)
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.fullscreenPopGestureDelegate,
                                 delegate,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return delegate
    }
    
    /// 关联fullscreenPopGestureRecognizer
    public var tfy_fullscreenPopGestureRecognizer: UIPanGestureRecognizer {
        if let fullscreenPopGR = objc_getAssociatedObject(self, &AssociatedKeys.fullscreenPopGestureRecognizer) as? UIPanGestureRecognizer {
            return fullscreenPopGR
        }
        let fullscreenPopGestureRecognizer = UIPanGestureRecognizer()
        fullscreenPopGestureRecognizer.maximumNumberOfTouches = 1
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.fullscreenPopGestureRecognizer,
                                 fullscreenPopGestureRecognizer,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return fullscreenPopGestureRecognizer
    }
    
    /// 关联enableSYNavigationBar
    @objc open var tfy_enableYCNavigationBar: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.enableSYNavigationBar) as? Bool) ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.enableSYNavigationBar, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// UINavigationController swizzleMethod
    static let swizzleUINavigationControllerOnce: Void = {
        let cls = UINavigationController.self
        TFYSwiftNavigationBarUtility.swizzleMethod(cls, #selector(UINavigationController.pushViewController(_:animated:)), #selector(UINavigationController.tfy_pushViewController(_:animated:)))
        TFYSwiftNavigationBarUtility.swizzleMethod(cls, #selector(UINavigationController.setViewControllers(_:animated:)), #selector(UINavigationController.tfy_setViewControllers(_:animated:)))
    }()
    
    /// 配置NavigationBar
    func configureNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
       
        tfy_gestureDelegate = TFYSwiftNavigationGestureRecognizerDelegate(navigationController: self)
        interactivePopGestureRecognizer?.delegate = tfy_gestureDelegate
    }
    
    /// 自定义实现pushViewController
    @objc private func tfy_pushViewController(_ viewController: UIViewController, animated: Bool) {
        /// 防止VC重复Push
        guard !viewControllers.contains(viewController) else {
            return
        }
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            let backButtonItem: UIBarButtonItem
            if let customView = viewController.tfy_backButtonCustomView {
                backButtonItem = UIBarButtonItem(customView: customView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
                customView.isUserInteractionEnabled = true
                customView.addGestureRecognizer(tap)
            } else {
                let backImage = viewController.tfy_backImage
                backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonClicked))
            }
            viewController.navigationItem.leftBarButtonItem = backButtonItem
        }
        
        if viewController.tfy_fullScreenInteractivePopEnabled {
            addCustomFullscreenPopGesture()
        }
        
        tfy_pushViewController(viewController, animated: animated)
    }
    
    /// 自定义实现setViewControllers
    @objc private func tfy_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if viewControllers.count > 1 {
            for (index, viewController) in viewControllers.enumerated() {
                if index != 0 {
                    viewController.hidesBottomBarWhenPushed = true
                    
                    let backButtonItem: UIBarButtonItem
                    if let customView = viewController.tfy_backButtonCustomView {
                        backButtonItem = UIBarButtonItem(customView: customView)
                        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
                        customView.isUserInteractionEnabled = true
                        customView.addGestureRecognizer(tap)
                    } else {
                        let backImage = viewController.tfy_backImage
                        backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonClicked))
                    }
                    viewController.navigationItem.leftBarButtonItem = backButtonItem
                }
                
                if viewController.tfy_fullScreenInteractivePopEnabled {
                    addCustomFullscreenPopGesture()
                }
            }
        }
        
        tfy_setViewControllers(viewControllers, animated: animated)
        
    }
    
    /// 添加自定义全屏返回手势
    private func addCustomFullscreenPopGesture() {
        guard let gestureRecognizers = interactivePopGestureRecognizer?.view?.gestureRecognizers else {
            return
        }
        if !gestureRecognizers.contains(tfy_fullscreenPopGestureRecognizer),
            let targets = interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray,
            let internalTarget = (targets.firstObject as? NSObject)?.value(forKey: "target") {
            let internalAction = NSSelectorFromString("handleNavigationTransition:")
            tfy_fullscreenPopGestureRecognizer.delegate = tfy_fullscreenPopGestureDelegate
            tfy_fullscreenPopGestureRecognizer.addTarget(internalTarget, action: internalAction)
            interactivePopGestureRecognizer?.isEnabled = false
            interactivePopGestureRecognizer?.view?.addGestureRecognizer(tfy_fullscreenPopGestureRecognizer)
        }
    }
    
    /// 返回按钮事件
    @objc private func backButtonClicked() {
        topViewController?.tfy_backButtonClicked()
    }
    
}


// MARK: - fileprivate

/// 导航栏默认手势代理对象
fileprivate class TFYSwiftNavigationGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    fileprivate weak var navigationController: UINavigationController?
    
    fileprivate init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = navigationController else {
            return true
        }
        if let topViewController = navigationController.viewControllers.last {
            if topViewController.tfy_disableInteractivePopGesture {
                return false
            }
        }
        return true
    }
}


/// 自定义全屏返回手势代理对象
fileprivate class TFYSwiftFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    fileprivate weak var navigationController: UINavigationController?
    
    fileprivate init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = navigationController,
              let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        if navigationController.viewControllers.count <= 1 {
            return false
        }
        
        if let topViewController = navigationController.viewControllers.last {
            if !topViewController.tfy_fullScreenInteractivePopEnabled {
                return false
            }
        }
        
        if let topViewController = navigationController.viewControllers.last {
            let beganPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let maxAllowedDistance = topViewController.tfy_fullScreenPopMaxAllowedDistanceToLeftEdge
            if maxAllowedDistance > 0 && beganPoint.x > maxAllowedDistance {
                return false
            }
        }

        let isTransitioning = navigationController.value(forKey: "_isTransitioning") as? Bool ?? false
        if isTransitioning {
            return false
        }

        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        let multiplier: CGFloat = isLeftToRight ? 1: -1
        if translation.x * multiplier <= 0 {
            return false
        }
        return true
    }
}
