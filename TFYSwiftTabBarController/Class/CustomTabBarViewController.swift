//
//  CustomTabBarViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// 自定义TabBar功能展示
class CustomTabBarViewController: TFYSwiftTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
    
    private func setupCustomTabBar() {
        // 创建自定义TabBarItem
        let homeItem = createCustomTabBarItem(title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        let findItem = createCustomTabBarItem(title: "发现", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        let messageItem = createCustomTabBarItem(title: "消息", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        let meItem = createCustomTabBarItem(title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
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
        
        // 自定义TabBar样式
        if let customTabBar = tabBar as? TFYSwiftTabBar {
            customTabBar.itemEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            customTabBar.itemCustomPositioning = .fillExcludeSeparator
        }
    }
    
    private func createCustomTabBarItem(title: String, image: UIImage?, selectedImage: UIImage?) -> TFYSwiftTabBarItem {
        let contentView = TFYSwiftTabBarItemContentView()
        contentView.tabbarTitle = title
        contentView.image = image
        contentView.selectedImage = selectedImage
        
        // 自定义颜色
        contentView.textColor = UIColor(white: 0.57254902, alpha: 1.0)
        contentView.highlightTextColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0)
        contentView.iconColor = UIColor(white: 0.57254902, alpha: 1.0)
        contentView.highlightIconColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0)
        
        return TFYSwiftTabBarItem(contentView, title: title, image: image, selectedImage: selectedImage)
    }
    
    private func createViewController(title: String) -> UINavigationController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = title
        
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
} 