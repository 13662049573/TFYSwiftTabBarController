//
//  TFYSwiftUIViewController.swift
//  TFYSwiftNavigationController
//
//  Created by mi ni on 2025/2/13.
//

import Foundation
import UIKit

// MARK: - UIViewController Extension
@available(iOS 15.0, *)
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
        static var titleColor = UnsafeRawPointer(bitPattern: "titleColor".hashValue)!
        static var barAlpha = UnsafeRawPointer(bitPattern: "barAlpha".hashValue)!
        static var barStyle = UnsafeRawPointer(bitPattern: "barStyle".hashValue)!
        static var shadowHidden = UnsafeRawPointer(bitPattern: "shadowHidden".hashValue)!
    }
    
    // MARK: - Navigation Bar Properties
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
        get {
            if let color = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundColor) as? UIColor {
                return color
            }
            let defaultValue = TFYSwiftNavigationBarStyle.backgroundColor
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundColor, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航栏背景图片
    @objc open var tfy_navigationBarBackgroundImage: UIImage? {
        get {
            if let image = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundImage) as? UIImage {
                return image
            }
            let defaultValue = TFYSwiftNavigationBarStyle.backgroundImage
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundImage, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否使用系统毛玻璃的导航栏
    @objc open var tfy_useSystemBlurNavBar: Bool {
        get {
            if let blurEnabled = objc_getAssociatedObject(self, &AssociatedKeys.useSystemBlurNavBar) as? Bool {
                return blurEnabled
            }
            let defaultValue = false
            objc_setAssociatedObject(self, &AssociatedKeys.useSystemBlurNavBar, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.useSystemBlurNavBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // 实时更新毛玻璃效果
            DispatchQueue.main.async { [weak self] in
                self?.updateBlurEffect()
            }
        }
    }
    
    /// 导航栏颜色
    @objc open var tfy_barTintColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &AssociatedKeys.barTintColor) as? UIColor {
                return color
            }
            let defaultValue: UIColor? = nil
            objc_setAssociatedObject(self, &AssociatedKeys.barTintColor, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.barTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航栏内容颜色
    @objc open var tfy_tintColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &AssociatedKeys.tintColor) as? UIColor {
                return color
            }
            let defaultValue = TFYSwiftNavigationBarStyle.tintColor
            objc_setAssociatedObject(self, &AssociatedKeys.tintColor, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航栏标题属性配置
    @objc open var tfy_titleTextAttributes: [NSAttributedString.Key: Any]? {
        get {
            if let attrs = objc_getAssociatedObject(self, &AssociatedKeys.titleTextAttributes) as? [NSAttributedString.Key: Any] {
                return attrs
            }
            let defaultValue = TFYSwiftNavigationBarStyle.titleTextAttributes
            objc_setAssociatedObject(self, &AssociatedKeys.titleTextAttributes, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleTextAttributes, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航栏阴影图片
    @objc open var tfy_shadowImage: UIImage? {
        get {
            if let image = objc_getAssociatedObject(self, &AssociatedKeys.shadowImage) as? UIImage {
                return image
            }
            let defaultValue = TFYSwiftNavigationBarStyle.shadowImage
            objc_setAssociatedObject(self, &AssociatedKeys.shadowImage, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shadowImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航栏阴影图片颜色
    @objc open var tfy_shadowImageTintColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &AssociatedKeys.shadowImageTintColor) as? UIColor {
                return color
            }
            let defaultValue: UIColor? = nil
            objc_setAssociatedObject(self, &AssociatedKeys.shadowImageTintColor, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shadowImageTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 导航栏返回按钮图片
    @objc open var tfy_backImage: UIImage? {
        get {
            if let image = objc_getAssociatedObject(self, &AssociatedKeys.backImage) as? UIImage {
                return image
            }
            let defaultValue = TFYSwiftNavigationBarStyle.backImage
            objc_setAssociatedObject(self, &AssociatedKeys.backImage, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 自定义导航栏返回视图
    @objc open var tfy_backButtonCustomView: UIView? {
        get {
            if let view = objc_getAssociatedObject(self, &AssociatedKeys.backButtonCustomView) as? UIView {
                return view
            }
            let defaultValue = TFYSwiftNavigationBarStyle.backButtonCustomView
            objc_setAssociatedObject(self, &AssociatedKeys.backButtonCustomView, defaultValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backButtonCustomView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 系统默认导航栏Pop返回手势是否可用 tfy_disableInteractivePopGesture/tfy_fullScreenInteractivePopEnabled只能使用一个
    @objc open var tfy_disableInteractivePopGesture: Bool {
        get {
            if let disabled = objc_getAssociatedObject(self, &AssociatedKeys.disableInteractivePopGesture) as? Bool {
                return disabled
            }
            let defaultValue = false
            objc_setAssociatedObject(self, &AssociatedKeys.disableInteractivePopGesture, defaultValue, .OBJC_ASSOCIATION_ASSIGN)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disableInteractivePopGesture, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 导航栏全局返回手势是否可用
    @objc open var tfy_fullScreenInteractivePopEnabled: Bool {
        get {
            // 检查self是否有效
            guard self.isViewLoaded else {
                return false
            }
            
            if let enabled = objc_getAssociatedObject(self, &AssociatedKeys.fullScreenInteractiveEnabled) as? Bool {
                return enabled
            }
            let defaultValue = TFYSwiftNavigationBarStyle.fullScreenPopGestureEnabled
            objc_setAssociatedObject(self, &AssociatedKeys.fullScreenInteractiveEnabled, defaultValue, .OBJC_ASSOCIATION_ASSIGN)
            return defaultValue
        }
        set {
            // 检查self是否有效
            guard self.isViewLoaded else {
                return
            }
            
            objc_setAssociatedObject(self, &AssociatedKeys.fullScreenInteractiveEnabled, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 导航栏全局返回手势响应的左边距离
    @objc open var tfy_fullScreenPopMaxAllowedDistanceToLeftEdge: CGFloat {
        get {
            // 检查self是否有效
            guard self.isViewLoaded else {
                return 0.0
            }
            
            if let distance = objc_getAssociatedObject(self, &AssociatedKeys.fullScreenPopMaxAllowedDistanceToLeftEdge) as? CGFloat {
                return distance
            }
            let defaultValue = CGFloat(0.0)
            objc_setAssociatedObject(self, &AssociatedKeys.fullScreenPopMaxAllowedDistanceToLeftEdge, defaultValue, .OBJC_ASSOCIATION_ASSIGN)
            return defaultValue
        }
        set {
            // 检查self是否有效
            guard self.isViewLoaded else {
                return
            }
            
            objc_setAssociatedObject(self, &AssociatedKeys.fullScreenPopMaxAllowedDistanceToLeftEdge, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 子视图是否自动隐藏TFYSwiftNavigationBae(默认True)
    @objc open var tfy_automaticallyHideSYNavBarInChildViewController: Bool {
        get {
            if let hidden = objc_getAssociatedObject(self, &AssociatedKeys.automaticallyHideSYNavBarInChildViewController) as? Bool {
                return hidden
            }
            let defaultValue = true
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.automaticallyHideSYNavBarInChildViewController,
                                     defaultValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.automaticallyHideSYNavBarInChildViewController, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // MARK: - Additional Properties for Backward Compatibility
    
    /// 导航栏背景颜色 (兼容性属性)
    @objc open var tfy_backgroundColor: UIColor? {
        get {
            return tfy_navigationBarBackgroundColor
        }
        set {
            tfy_navigationBarBackgroundColor = newValue
        }
    }
    
    /// 导航栏背景图片 (兼容性属性)
    @objc open var tfy_backgroundImage: UIImage? {
        get {
            return tfy_navigationBarBackgroundImage
        }
        set {
            tfy_navigationBarBackgroundImage = newValue
        }
    }
    
    /// 导航栏标题颜色
    @objc open var tfy_titleColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &AssociatedKeys.titleColor) as? UIColor {
                return color
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航栏透明度
    @objc open var tfy_barAlpha: CGFloat {
        get {
            if let alpha = objc_getAssociatedObject(self, &AssociatedKeys.barAlpha) as? CGFloat {
                return alpha
            }
            return 1.0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.barAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航栏样式
    @objc open var tfy_barStyle: UIBarStyle {
        get {
            if let style = objc_getAssociatedObject(self, &AssociatedKeys.barStyle) as? UIBarStyle {
                return style
            }
            return .default
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.barStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否隐藏阴影
    @objc open var tfy_shadowHidden: Bool {
        get {
            if let hidden = objc_getAssociatedObject(self, &AssociatedKeys.shadowHidden) as? Bool {
                return hidden
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shadowHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Private Work
@available(iOS 15.0, *)
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
    
    // MARK: - Lifecycle Methods
    /// 视图已经加载
    @objc private func tfy_viewDidLoad() {
        if let navigationController = navigationController, navigationController.tfy_enableYCNavigationBar {
            navigationController.configureNavigationBar()
            configureCustomNavigationBar()
        }
        
        tfy_viewDidLoad()
    }
    
    /// 视图将要出现
    @objc private func tfy_viewWillAppear(_ animated: Bool) {
        if let navigationController = navigationController, navigationController.tfy_enableYCNavigationBar {
            configureSystemNavigationBar(navigationController)
            setupNavigationBarFrameUpdate(navigationController)
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
    
    // MARK: - Private Configuration Methods
    /// 配置自定义导航栏
    private func configureCustomNavigationBar() {
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
        
        addNavigationBarToView()
        configureChildViewControllerNavigationBar()
    }
    
    /// 添加导航栏到视图
    private func addNavigationBarToView() {
        /// 处理根视图是UIScrollView的布局问题
        if view is UIScrollView {
            navigationController?.view.insertSubview(tfy_navigationBar, at: 1)
        } else {
            view.addSubview(tfy_navigationBar)
        }
    }
    
    /// 配置子控制器导航栏
    private func configureChildViewControllerNavigationBar() {
        /// 子控制器自动隐藏yc_navigationBar
        if let parent = parent, !(parent is UINavigationController) && tfy_automaticallyHideSYNavBarInChildViewController {
            tfy_navigationBar.isHidden = true
        }
    }
    
    /// 配置系统导航栏
    private func configureSystemNavigationBar(_ navigationController: UINavigationController) {
        navigationController.navigationBar.barTintColor = tfy_barTintColor
        navigationController.navigationBar.tintColor = tfy_tintColor
        navigationController.navigationBar.titleTextAttributes = tfy_titleTextAttributes
        view.bringSubviewToFront(tfy_navigationBar)
    }
    
    /// 设置导航栏帧更新
    private func setupNavigationBarFrameUpdate(_ navigationController: UINavigationController) {
        navigationController.navigationBar.frameDidUpdated = { [weak self] frame in
            guard let self = self else { return }
            /// 避免手势返回，view 布局发生改变
            if self.tfy_viewWillDisappear {
                return
            }
            let newFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + frame.origin.y)
            self.tfy_navigationBar.frame = newFrame
        }
    }
    
    /// 更新毛玻璃效果
    private func updateBlurEffect() {
        guard self.isViewLoaded else { return }
        
        // 更新导航栏的毛玻璃效果
        tfy_navigationBar.enableBlurEffect(tfy_useSystemBlurNavBar)
        
        // 根据毛玻璃效果调整背景色
        if tfy_useSystemBlurNavBar {
            tfy_navigationBar.backgroundColor = .clear
        } else {
            tfy_navigationBar.backgroundColor = tfy_navigationBarBackgroundColor
        }
        
        // 强制刷新布局
        tfy_navigationBar.setNeedsLayout()
        tfy_navigationBar.layoutIfNeeded()
    }
    
    /// 检查毛玻璃效果状态
    @objc open func checkBlurEffectStatus() -> Bool {
        guard self.isViewLoaded else { return false }
        
        // 检查属性状态
        let propertyEnabled = tfy_useSystemBlurNavBar
        
        // 检查导航栏状态
        let navigationBarEnabled = tfy_navigationBar.isBlurEffectEnabled
        
        // 检查背景色状态
        let backgroundColorCorrect = tfy_navigationBar.backgroundColor == (propertyEnabled ? .clear : tfy_navigationBarBackgroundColor)
        
        return propertyEnabled == navigationBarEnabled && backgroundColorCorrect
    }
    
    /// 返回按钮的点击事件（子类可重写）
    @objc open func tfy_backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

