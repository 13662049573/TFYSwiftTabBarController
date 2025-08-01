//
//  BasicTabBarViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// 基础TabBar功能展示
class BasicTabBarViewController: TFYSwiftTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicTabBar()
    }
    
    private func setupBasicTabBar() {
        // 创建视图控制器
        let homeVC = createViewController(title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        let findVC = createViewController(title: "发现", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        let messageVC = createViewController(title: "消息", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        let meVC = createViewController(title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        // 设置视图控制器
        viewControllers = [homeVC, findVC, messageVC, meVC]
        
        // 设置TabBar样式
        tabBar.tintColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(white: 0.57254902, alpha: 1.0)
    }
    
    private func createViewController(title: String, image: UIImage?, selectedImage: UIImage?) -> UINavigationController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = title
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        
        return nav
    }
} 