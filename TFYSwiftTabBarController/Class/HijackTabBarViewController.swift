//
//  HijackTabBarViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// 事件劫持功能展示
class HijackTabBarViewController: TFYSwiftTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHijackTabBar()
    }
    
    private func setupHijackTabBar() {
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
        
        // 设置事件劫持
        setupHijackHandlers()
        
        // 添加控制按钮
        addControlButtons()
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
    
    private func setupHijackHandlers() {
        // 设置是否劫持事件
        shouldHijackHandler = { tabBarController, viewController, index in
            // 劫持第二个Tab（发现页面）
            return index == 1
        }
        
        // 设置劫持事件处理
        didHijackHandler = { [weak self] tabBarController, viewController, index in
            self?.showHijackAlert(index: index)
        }
    }
    
    private func showHijackAlert(index: Int) {
        let alert = UIAlertController(title: "事件劫持", message: "你点击了第\(index + 1)个Tab，但被劫持了！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        
        // 修复iOS 15.0+的API变更
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func addControlButtons() {
        guard let firstNav = viewControllers?.first as? UINavigationController,
              let firstVC = firstNav.viewControllers.first else { return }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        let enableButton = UIButton(type: .system)
        enableButton.setTitle("启用劫持", for: .normal)
        enableButton.backgroundColor = UIColor.systemGreen
        enableButton.setTitleColor(.white, for: .normal)
        enableButton.layer.cornerRadius = 8
        enableButton.addTarget(self, action: #selector(enableHijack), for: .touchUpInside)
        
        let disableButton = UIButton(type: .system)
        disableButton.setTitle("禁用劫持", for: .normal)
        disableButton.backgroundColor = UIColor.systemRed
        disableButton.setTitleColor(.white, for: .normal)
        disableButton.layer.cornerRadius = 8
        disableButton.addTarget(self, action: #selector(disableHijack), for: .touchUpInside)
        
        stackView.addArrangedSubview(enableButton)
        stackView.addArrangedSubview(disableButton)
        
        firstVC.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: firstVC.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: firstVC.view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 120),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func enableHijack() {
        shouldHijackHandler = { tabBarController, viewController, index in
            return index == 1
        }
        showMessage("劫持已启用")
    }
    
    @objc private func disableHijack() {
        shouldHijackHandler = nil
        showMessage("劫持已禁用")
    }
    
    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        
        // 修复iOS 15.0+的API变更
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
} 
