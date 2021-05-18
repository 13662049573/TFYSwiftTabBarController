//
//  UIViewController+ITools.swift
//  TFYSwiftNavigationKit
//
//  Created by 田风有 on 2021/5/15.
//

import ObjectiveC
import UIKit

infix operator <=>

extension UINavigationController {
    
    var _configuration: Configuration {
        if let configuration = objc_getAssociatedObject(
            self,
            &TFYAssociatedKeys.configuration
        ) as? Configuration {
            return configuration
        }
        let configuration = Configuration()
        objc_setAssociatedObject(
            self,
            &TFYAssociatedKeys.configuration,
            configuration,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return configuration
    }
}

extension UIViewController {
    
    var _navigationBar: TFYNavigationBar {
        if let bar = objc_getAssociatedObject(self, &TFYAssociatedKeys.navigationBar) as? TFYNavigationBar {
            return bar
        }
        
        let bar = TFYNavigationBar(viewController: self)
        
        objc_setAssociatedObject(
            self,
            &TFYAssociatedKeys.navigationBar,
            bar,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        return bar
    }
    
    var _navigationItem: UINavigationItem {
        if let item = objc_getAssociatedObject(self, &TFYAssociatedKeys.navigationItem) as? UINavigationItem {
            return item
        }
        
        let item = TFYNavigationItem(viewController: self)
        item.copy(by: navigationItem)
        
        objc_setAssociatedObject(
            self,
            &TFYAssociatedKeys.navigationItem,
            item,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        return item
    }
}

private extension UINavigationItem {
    
    func copy(by navigationItem: UINavigationItem) {
        self.title = navigationItem.title
        self.prompt = navigationItem.prompt
    }
}


public extension UIViewController {
    
    func adjustsNavigationBarLayout() {
        _navigationBar.adjustsLayout()
        _navigationBar.setNeedsLayout()
    }
}

extension UIViewController {

    func setupNavigationBarWhenViewDidLoad() {
        guard let navigationController = navigationController else { return }
        
        navigationController.sendNavigationBarToBack()
        view.addSubview(_navigationBar)
        
        if #available(iOS 11.0, *) {
            _navigationItem.largeTitleDisplayMode = navigationController._configuration.largeTitle.displayMode
        }
        
        _navigationBar.apply(navigationController._configuration)
        
        let viewControllers = navigationController.viewControllers
        
        guard viewControllers.count > 1 else { return }
        
        guard let backItem = navigationController._configuration.backItem else {
            _navigationBar.backBarButtonItem = buildBackBarButtonItem(viewControllers)
            return
        }
        
        _navigationBar.backBarButtonItem = TFYBarButtonItem(from: backItem)
    }
    
    func updateNavigationBarWhenViewWillAppear() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.barStyle = _navigationBar.superBarStyle
        navigationBar.isHidden = _navigationBar.isHidden
        if #available(iOS 11.0, *) {
            adjustsSafeAreaInsetsAfterIOS11()
            navigationItem.title = _navigationItem.title
            navigationItem.largeTitleDisplayMode = _navigationItem.largeTitleDisplayMode
            navigationBar.prefersLargeTitles = _navigationBar.prefersLargeTitles
            navigationBar.largeTitleTextAttributes = _navigationBar.largeTitleTextAttributes
        }
        view.bringSubviewToFront(_navigationBar)
    }
    
    func adjustsSafeAreaInsetsAfterIOS11() {
        guard #available(iOS 11.0, *) else { return }
        
        let height = _navigationBar.additionalView?.frame.height ?? 0
        additionalSafeAreaInsets.top = _navigationBar.isHidden
            ? -view.safeAreaInsets.top
            : _navigationBar._additionalHeight + height
    }
}

private extension UIViewController {
    
    func buildBackBarButtonItem(_ viewControllers: [UIViewController]) -> TFYBarButtonItem {

//        let count = viewControllers.count

        let backButton = UIButton(type: .system)
        let image = UIImage(named: "navigation_back_default", in: Bundle.current, compatibleWith: nil)
        backButton.setImage(image, for: .normal)
        
//        if let title = viewControllers[count - 2]._navigationItem.title {
//            let maxWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 3
//            let width = (title as NSString).boundingRect(
//                with: CGSize(width: maxWidth, height: 20),
//                options: NSStringDrawingOptions.usesFontLeading,
//                attributes: [.font: UIFont.boldSystemFont(ofSize: 17)],
//                context: nil
//            ).size.width
////            backButton.setTitle(width < maxWidth ? title : "Back", for: .normal)
//        } else {
////            backButton.setTitle("Back", for: .normal)
//        }
//        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        backButton.contentEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 8)
        backButton.sizeToFit()
    
        return TFYBarButtonItem(style: .custom(backButton))
    }
}

private extension TFYNavigationBar {
    
    func apply(_ configuration: UINavigationController.Configuration) {
        isHidden = configuration.isHidden
        alpha = configuration.alpha
        isTranslucent = configuration.isTranslucent
        barTintColor = configuration.barTintColor
        tintColor = configuration.tintColor
        
        titleTextAttributes = configuration.titleTextAttributes
        shadowImage = configuration.shadowImage
        setBackgroundImage(
            configuration.background.image,
            for: configuration.background.barPosition,
            barMetrics: configuration.background.barMetrics
        )
        
        barStyle = configuration.barStyle
        statusBarStyle = configuration.statusBarStyle
        
        additionalHeight = configuration.additionalHeight
        
        isShadowHidden = configuration.isShadowHidden
        
        if let shadow = configuration.shadow {
            self.shadow = shadow
        }
        
        if #available(iOS 11.0, *) {
            layoutPaddings = configuration.layoutPaddings
            prefersLargeTitles = configuration.prefersLargeTitles
            largeTitleTextAttributes = configuration.largeTitle.textAttributes
        }
    }
}

private extension Bundle {
    
    static var current: Bundle? {
        guard let resourcePath = Bundle(for: TFYNavigationBar.self).resourcePath,
              let bundle = Bundle(path: "\(resourcePath)/TFYNavigationBar.bundle") else {
            return nil
        }
        return bundle
    }
}

private extension TFYBarButtonItem {
    
    convenience init(from backItem: UINavigationController.Configuration.BackItem) {
        switch backItem.style {
        case .title(let title):
            self.init(style: .title(title), tintColor: backItem.tintColor)
        case .image(let image):
            self.init(style: .image(image), tintColor: backItem.tintColor)
        }
    }
}


extension UIViewController: NavigationCompatible {}

public extension Navigation where Base: UIViewController {
    
    var bar: TFYNavigationBar {
        assert(
            !(base is UINavigationController),
            "UINavigationController不能使用这个属性，请使用配置。"
        )
        assert(
            base.navigationController?.navigation.configuration.isEnabled == true,
            "请确保UINavigationController navigation.configuration.isEnabled为true。"
        )
        return base._navigationBar
    }
    
    var item: UINavigationItem {
        assert(
            !(base is UINavigationController),
            "UINavigationController不能使用这个属性，请使用配置。"
        )
        assert(
            base.navigationController?.navigation.configuration.isEnabled == true,
            "请确保UINavigationController navigation.configuration.isEnabled为true。"
        )
        return base._navigationItem
    }
}

public extension Navigation where Base: UINavigationController {
    
    var configuration: UINavigationController.Configuration {
        return base._configuration
    }
}

extension UIViewController {
    
    static let methodSwizzling: Void = {
        #selector(viewDidLoad) <=> #selector(navigation_viewDidLoad)
        #selector(viewWillAppear(_:)) <=> #selector(navigation_viewWillAppear(_:))
        #selector(setNeedsStatusBarAppearanceUpdate) <=> #selector(navigation_setNeedsStatusBarAppearanceUpdate)
        #selector(viewDidLayoutSubviews) <=> #selector(navigation_viewDidLayoutSubviews)
    }()
    
    private var isNavigationBarEnabled: Bool {
        guard let navigationController = navigationController,
              navigationController.navigation.configuration.isEnabled,
              navigationController.viewControllers.contains(self) else {
            return false
        }
        
        return true
    }
    
    @objc private func navigation_viewDidLoad() {
        navigation_viewDidLoad()
        
        guard isNavigationBarEnabled else { return }
        
        setupNavigationBarWhenViewDidLoad()
        
        if let tableViewController = self as? UITableViewController {
            tableViewController.observeContentOffset()
        }
    }
    
    @objc private func navigation_viewWillAppear(_ animated: Bool) {
        navigation_viewWillAppear(animated)
        
        guard isNavigationBarEnabled else { return }
        
        updateNavigationBarWhenViewWillAppear()
    }
    
    @objc private func navigation_setNeedsStatusBarAppearanceUpdate() {
        navigation_setNeedsStatusBarAppearanceUpdate()
        
        adjustsNavigationBarLayout()
    }
    
    @objc private func navigation_viewDidLayoutSubviews() {
        navigation_viewDidLayoutSubviews()
        
        view.bringSubviewToFront(_navigationBar)
    }
}

private extension Selector {
    
    static func <=> (left: Selector, right: Selector) {
        if let originalMethod = class_getInstanceMethod(UIViewController.self, left),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, right) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
