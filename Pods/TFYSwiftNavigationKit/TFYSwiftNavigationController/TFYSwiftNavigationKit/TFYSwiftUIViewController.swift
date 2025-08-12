//
//  TFYSwiftUIViewController.swift
//  TFYSwiftNavigationController
//
//  Created by mi ni on 2025/2/13.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 关联对象的Keys
    private struct AssociatedKeys {
        static var navigationBar = UnsafeRawPointer(bitPattern: "navigationBar".hashValue)!
        static var navigationBarBackgroundColor = UnsafeRawPointer(bitPattern: "navigationBarBackgroundColor".hashValue)!
        static var navigationBarBackgroundImage = UnsafeRawPointer(bitPattern: "navigationBarBackgroundImage".hashValue)!
        static var barTintColor = UnsafeRawPointer(bitPattern: "barTintColor".hashValue)!
        static var tintColor = UnsafeRawPointer(bitPattern: "tintColor".hashValue)!
        static var titleTextAttributes = UnsafeRawPointer(bitPattern: "titleTextAttributes".hashValue)!
        static var useSystemBlurNavBar = UnsafeRawPointer(bitPattern: "useSystemBlurNavBar".hashValue)!
        static var shadowImage = UnsafeRawPointer(bitPattern: "shadowImage".hashValue)!
        static var shadowImageTintColor = UnsafeRawPointer(bitPattern: "shadowImageTintColor".hashValue)!
        static var backButtonCustomView = UnsafeRawPointer(bitPattern: "backButtonCustomView".hashValue)!
        static var backImage = UnsafeRawPointer(bitPattern: "backImage".hashValue)!
        static var disableInteractivePopGesture = UnsafeRawPointer(bitPattern: "disableInteractivePopGesture".hashValue)!
        static var fullScreenInteractiveEnabled = UnsafeRawPointer(bitPattern: "fullScreenInteractivePopEnabled".hashValue)!
        static var fullScreenPopMaxAllowedDistanceToLeftEdge = UnsafeRawPointer(bitPattern: "fullScreenPopMaxAllowedDistanceToLeftEdge".hashValue)!
        static var automaticallyHideSYNavBarInChildViewController = UnsafeRawPointer(bitPattern: "automaticallyHideSYNavBarInChildViewController".hashValue)!
        static var viewWillDisappear = UnsafeRawPointer(bitPattern: "viewWillDisappear".hashValue)!
    }
    
    /// 自定义导航栏
    public var tfy_navigationBar: TFYSwiftNavigationBar {
        if let bar = objc_getAssociatedObject(self, &AssociatedKeys.navigationBar) as? TFYSwiftNavigationBar {
            return bar
        }
        let bar = TFYSwiftNavigationBar(frame: .zero)
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar
    }
    
    /// 导航栏背景色
    @objc open var tfy_navigationBarBackgroundColor: UIColor? {
        if let color = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundColor) as? UIColor {
            return color
        }
        let color = TFYSwiftNavigationBarStyle.backgroundColor
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return color
    }
    
    /// 导航栏背景图片
    @objc open var tfy_navigationBarBackgroundImage: UIImage? {
        if let backgroundImage = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundImage) as? UIImage {
            return backgroundImage
        }
        let backgroundImage = TFYSwiftNavigationBarStyle.backgroundImage
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundImage, backgroundImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return backgroundImage
    }
    
    /// 是否使用系统毛玻璃的导航栏
    @objc open var tfy_useSystemBlurNavBar: Bool {
        if let useSystemBlurNavBar = objc_getAssociatedObject(self, &AssociatedKeys.useSystemBlurNavBar) as? Bool {
            return useSystemBlurNavBar
        }
        let useSystemBlurNavBar = false
        objc_setAssociatedObject(self, &AssociatedKeys.useSystemBlurNavBar, useSystemBlurNavBar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return useSystemBlurNavBar
    }
    
    /// 导航栏颜色
    @objc open var tfy_barTintColor: UIColor? {
        if let barBarTintColor = objc_getAssociatedObject(self, &AssociatedKeys.barTintColor) as? UIColor {
            return barBarTintColor
        }
        let barBarTintColor: UIColor? = nil
        objc_setAssociatedObject(self, &AssociatedKeys.barTintColor, barBarTintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return barBarTintColor
    }
    
    /// 导航栏内容颜色
    @objc open var tfy_tintColor: UIColor? {
        if let barTintColor = objc_getAssociatedObject(self, &AssociatedKeys.tintColor) as? UIColor {
            return barTintColor
        }
        let barTintColor = TFYSwiftNavigationBarStyle.tintColor
        objc_setAssociatedObject(self, &AssociatedKeys.tintColor, barTintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return barTintColor
    }
    
    /// 导航栏标题属性配置
    @objc open var tfy_titleTextAttributes: [NSAttributedString.Key: Any]? {
        if let attributes = objc_getAssociatedObject(self, &AssociatedKeys.titleTextAttributes) as? [NSAttributedString.Key: Any] {
            return attributes
        }
        let attributes = TFYSwiftNavigationBarStyle.titleTextAttributes
        objc_setAssociatedObject(self, &AssociatedKeys.titleTextAttributes, attributes, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return attributes
    }
    
    /// 导航栏阴影图片
    @objc open var tfy_shadowImage: UIImage? {
        if let shadowImage = objc_getAssociatedObject(self, &AssociatedKeys.shadowImage) as? UIImage {
            return shadowImage
        }
        let shadowImage = TFYSwiftNavigationBarStyle.shadowImage
        objc_setAssociatedObject(self, &AssociatedKeys.shadowImage, shadowImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return shadowImage
    }
    
    /// 导航栏阴影图片颜色
    @objc open var tfy_shadowImageTintColor: UIColor? {
        if let shadowImageTintColor = objc_getAssociatedObject(self, &AssociatedKeys.shadowImageTintColor) as? UIColor {
            return shadowImageTintColor
        }
        let shadowImageTintColor: UIColor? = nil
        objc_setAssociatedObject(self, &AssociatedKeys.shadowImageTintColor, shadowImageTintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return shadowImageTintColor
    }

    /// 导航栏返回按钮图片
    @objc open var tfy_backImage: UIImage? {
        if let backImage = objc_getAssociatedObject(self, &AssociatedKeys.backImage) as? UIImage {
            return backImage
        }
        let backImage = TFYSwiftNavigationBarStyle.backImage
        objc_setAssociatedObject(self, &AssociatedKeys.backImage, backImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return backImage
    }
    
    /// 自定义导航栏返回视图
    @objc open var tfy_backButtonCustomView: UIView? {
        if let backButtonCustomView = objc_getAssociatedObject(self, &AssociatedKeys.backButtonCustomView) as? UIView {
            return backButtonCustomView
        }
        let backButtonCustomView = TFYSwiftNavigationBarStyle.backButtonCustomView
        objc_setAssociatedObject(self, &AssociatedKeys.backButtonCustomView, backButtonCustomView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return backButtonCustomView
    }
    
    /// 系统默认导航栏Pop返回手势是否可用 tfy_disableInteractivePopGesture/tfy_fullScreenInteractivePopEnabled只能使用一个
    @objc open var tfy_disableInteractivePopGesture: Bool {
        if let disableInteractivePopGesture = objc_getAssociatedObject(self, &AssociatedKeys.disableInteractivePopGesture) as? Bool {
            return disableInteractivePopGesture
        }
        let disableInteractivePopGesture = false
        objc_setAssociatedObject(self, &AssociatedKeys.disableInteractivePopGesture, disableInteractivePopGesture, .OBJC_ASSOCIATION_ASSIGN)
        return disableInteractivePopGesture
    }
    
    /// 导航栏全局返回手势是否可用
    @objc open var tfy_fullScreenInteractivePopEnabled: Bool {
        if let fullScreenInteractivePopEnabled = objc_getAssociatedObject(self, &AssociatedKeys.fullScreenInteractiveEnabled) as? Bool {
            return fullScreenInteractivePopEnabled
        }
        let fullScreenInteractivePopEnabled = TFYSwiftNavigationBarStyle.fullScreenPopGestureEnabled
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.fullScreenInteractiveEnabled,
                                 fullScreenInteractivePopEnabled,
                                 .OBJC_ASSOCIATION_ASSIGN)
        return fullScreenInteractivePopEnabled
    }
    
    /// 导航栏全局返回手势响应的左边距离
    @objc open var tfy_fullScreenPopMaxAllowedDistanceToLeftEdge: CGFloat {
        if let fullScreenPopMaxAllowedDistanceToLeftEdge =  objc_getAssociatedObject(self, &AssociatedKeys.fullScreenPopMaxAllowedDistanceToLeftEdge) as? CGFloat {
            return fullScreenPopMaxAllowedDistanceToLeftEdge
        }
        let fullScreenPopMaxAllowedDistanceToLeftEdge = CGFloat(0.0)
        objc_setAssociatedObject(self, &AssociatedKeys.fullScreenPopMaxAllowedDistanceToLeftEdge, fullScreenPopMaxAllowedDistanceToLeftEdge, .OBJC_ASSOCIATION_ASSIGN)
        return fullScreenPopMaxAllowedDistanceToLeftEdge
    }
    
    /// 子视图是否自动隐藏TFYSwiftNavigationBae(默认True)
    @objc open var tfy_automaticallyHideSYNavBarInChildViewController: Bool {
        if let automaticallyHideSYNavBarInChildViewController = objc_getAssociatedObject(self, &AssociatedKeys.automaticallyHideSYNavBarInChildViewController) as? Bool {
            return automaticallyHideSYNavBarInChildViewController
        }
        let automaticallyHideSYNavBarInChildViewController = true
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.automaticallyHideSYNavBarInChildViewController,
                                 automaticallyHideSYNavBarInChildViewController,
                                 .OBJC_ASSOCIATION_ASSIGN)
        return automaticallyHideSYNavBarInChildViewController
    }
}

// MARK: - Private Work
extension UIViewController {
    
    /// UIViewController swizzleMethod
    static let swizzleUIViewControllerOnce: Void = {
        let cls = UIViewController.self
        TFYSwiftNavigationBarUtility.swizzleMethod(cls, #selector(UIViewController.viewDidLoad), #selector(UIViewController.tfy_viewDidLoad))
        TFYSwiftNavigationBarUtility.swizzleMethod(cls, #selector(UIViewController.viewWillAppear(_:)), #selector(UIViewController.tfy_viewWillAppear(_:)))
        TFYSwiftNavigationBarUtility.swizzleMethod(cls, #selector(UIViewController.viewDidAppear(_:)), #selector(UIViewController.tfy_viewDidAppear(_:)))
        TFYSwiftNavigationBarUtility.swizzleMethod(cls, #selector(UIViewController.viewWillDisappear(_:)), #selector(UIViewController.tfy_viewWillDisappear(_:)))
    }()
    
    /// 记录视图是否将要消失
    private var tfy_viewWillDisappear: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.viewWillDisappear) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.viewWillDisappear, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 视图已经加载
    @objc private func tfy_viewDidLoad() {
        if navigationController != nil && navigationController!.tfy_enableYCNavigationBar {
            navigationController?.configureNavigationBar()
            /// 配置假的导航栏
            tfy_navigationBar.backgroundColor = tfy_navigationBarBackgroundColor
            tfy_navigationBar.shadowImageView.image = tfy_shadowImage
            if let color = tfy_shadowImageTintColor {
                tfy_navigationBar.shadowImageView.image = TFYSwiftNavigationBarUtility.imageFrom(color: color)
            }
            tfy_navigationBar.backgroundImageView.image = tfy_navigationBarBackgroundImage
            tfy_navigationBar.frame = CGRect(x: 0,
                                            y: 0,
                                            width: view.bounds.width,
                                            height: TFYSwiftNavigationBarUtility.navigationBarHeight)
            tfy_navigationBar.enableBlurEffect(tfy_useSystemBlurNavBar)
            
            /// 处理根视图是UIScrollView的布局问题
            if view is UIScrollView {
                navigationController?.view.insertSubview(tfy_navigationBar, at: 1)
            } else {
                view.addSubview(tfy_navigationBar)
            }
            
            /// 子控制器自动隐藏yc_navigationBar
            if let parent = parent, !(parent is UINavigationController)  && tfy_automaticallyHideSYNavBarInChildViewController {
                tfy_navigationBar.isHidden = true
            }
        }
        
        tfy_viewDidLoad()
    }
    
    /// 视图将要出现
    @objc private func tfy_viewWillAppear(_ animated: Bool) {
        if navigationController != nil && navigationController!.tfy_enableYCNavigationBar {
            navigationController?.navigationBar.barTintColor = tfy_barTintColor
            navigationController?.navigationBar.tintColor = tfy_tintColor
            navigationController?.navigationBar.titleTextAttributes = tfy_titleTextAttributes
            view.bringSubviewToFront(tfy_navigationBar)
            
            navigationController?.navigationBar.frameDidUpdated = { [weak self] frame in
                guard let self = self else { return }
                /// 避免手势返回，view 布局发生改变
                if self.tfy_viewWillDisappear {
                    return
                }
                let newFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + frame.origin.y)
                self.tfy_navigationBar.frame = newFrame
            }
        }
        tfy_viewWillDisappear = false
        tfy_viewWillAppear(animated)
    }
    
    /// 视图将要消失
    @objc private func tfy_viewWillDisappear(_ animated: Bool) {
        tfy_viewWillDisappear = true
        tfy_viewWillDisappear(animated)
    }
    
    /// 视图已经出现
    @objc private func tfy_viewDidAppear(_ animated: Bool) {
        if let navigationController = self.navigationController, navigationController.tfy_enableYCNavigationBar {
            let interactivePopGestureRecognizerEnabled = navigationController.viewControllers.count > 1
            navigationController.interactivePopGestureRecognizer?.isEnabled = interactivePopGestureRecognizerEnabled
        }
        tfy_viewDidAppear(animated)
    }
    
    /// 返回按钮的点击事件（子类可重写）
    @objc open func tfy_backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

