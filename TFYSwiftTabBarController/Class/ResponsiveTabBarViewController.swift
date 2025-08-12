//
//  ResponsiveTabBarViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// 响应式布局功能展示
class ResponsiveTabBarViewController: TFYSwiftTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupResponsiveTabBar()
    }
    
    private func setupResponsiveTabBar() {
        // 创建自定义TabBarItem
        let homeItem = createTabBarItem(title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        let findItem = createTabBarItem(title: "发现", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        let messageItem = createTabBarItem(title: "消息", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        let meItem = createTabBarItem(title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        // 创建视图控制器
        let homeVC = createViewController(title: "首页")
        let findVC = createViewController(title: "发现")
        let messageVC = createViewController(title: "消息")
        let meVC = createViewController(title: "我的")
        
        // 设置TabBarItem
        homeVC.tabBarItem = homeItem
        findVC.tabBarItem = findItem
        messageVC.tabBarItem = messageItem
        meVC.tabBarItem = meItem
        
        // 设置视图控制器
        viewControllers = [homeVC, findVC, messageVC, meVC]
        
        // 设置响应式布局
        setupResponsiveLayout()
        
        // 添加布局控制按钮
        addLayoutControlButtons()
    }
    
    private func createTabBarItem(title: String, image: UIImage?, selectedImage: UIImage?) -> TFYSwiftTabBarItem {
        let contentView = TFYSwiftTabBarItemContentView()
        contentView.tabbarTitle = title
        contentView.image = image
        contentView.selectedImage = selectedImage
        
        return TFYSwiftTabBarItem(contentView, title: title, image: image, selectedImage: selectedImage)
    }
    
    private func createViewController(title: String) -> UINavigationController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = title
        
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    private func setupResponsiveLayout() {
        if tabBar is TFYSwiftTabBar {
            // 根据设备方向调整布局
            updateLayoutForOrientation()
            
            // 监听设备方向变化
            NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }
    
    @objc private func orientationChanged() {
        updateLayoutForOrientation()
    }
    
    private func updateLayoutForOrientation() {
        guard let customTabBar = tabBar as? TFYSwiftTabBar else { return }
        
        let orientation = UIDevice.current.orientation
        let isLandscape = orientation.isLandscape || (orientation == .unknown && UIScreen.main.bounds.width > UIScreen.main.bounds.height)
        
        if isLandscape {
            // 横屏布局
            customTabBar.itemCustomPositioning = .fillExcludeSeparator
            customTabBar.itemEdgeInsets = UIEdgeInsets(top: 2, left: 20, bottom: 2, right: 20)
        } else {
            // 竖屏布局
            customTabBar.itemCustomPositioning = .fill
            customTabBar.itemEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
    }
    
    private func addLayoutControlButtons() {
        guard let firstNav = viewControllers?.first as? UINavigationController,
              let firstVC = firstNav.viewControllers.first else { return }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        let automaticButton = UIButton(type: .system)
        automaticButton.setTitle("自动布局", for: .normal)
        automaticButton.backgroundColor = UIColor.systemBlue
        automaticButton.setTitleColor(.white, for: .normal)
        automaticButton.layer.cornerRadius = 8
        automaticButton.addTarget(self, action: #selector(setAutomaticLayout), for: .touchUpInside)
        
        let fillButton = UIButton(type: .system)
        fillButton.setTitle("填充布局", for: .normal)
        fillButton.backgroundColor = UIColor.systemGreen
        fillButton.setTitleColor(.white, for: .normal)
        fillButton.layer.cornerRadius = 8
        fillButton.addTarget(self, action: #selector(setFillLayout), for: .touchUpInside)
        
        let centeredButton = UIButton(type: .system)
        centeredButton.setTitle("居中布局", for: .normal)
        centeredButton.backgroundColor = UIColor.systemOrange
        centeredButton.setTitleColor(.white, for: .normal)
        centeredButton.layer.cornerRadius = 8
        centeredButton.addTarget(self, action: #selector(setCenteredLayout), for: .touchUpInside)
        
        stackView.addArrangedSubview(automaticButton)
        stackView.addArrangedSubview(fillButton)
        stackView.addArrangedSubview(centeredButton)
        
        firstVC.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: firstVC.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: firstVC.view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 120),
            stackView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc private func setAutomaticLayout() {
        if let customTabBar = tabBar as? TFYSwiftTabBar {
            customTabBar.itemCustomPositioning = .automatic
            showMessage("已设置为自动布局")
        }
    }
    
    @objc private func setFillLayout() {
        if let customTabBar = tabBar as? TFYSwiftTabBar {
            customTabBar.itemCustomPositioning = .fill
            showMessage("已设置为填充布局")
        }
    }
    
    @objc private func setCenteredLayout() {
        if let customTabBar = tabBar as? TFYSwiftTabBar {
            customTabBar.itemCustomPositioning = .centered
            showMessage("已设置为居中布局")
        }
    }
    
    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: "布局设置", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        
        // 修复iOS 15.0+的API变更
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
} 
