//
//  MoreTabBarViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// More按钮功能展示
class MoreTabBarViewController: TFYSwiftTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoreTabBar()
    }
    
    private func setupMoreTabBar() {
        // 创建自定义TabBarItem
        let homeItem = createTabBarItem(title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        let findItem = createTabBarItem(title: "发现", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        let messageItem = createTabBarItem(title: "消息", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        let meItem = createTabBarItem(title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        let moreItem = createTabBarItem(title: "更多", image: UIImage(named: "more"), selectedImage: UIImage(named: "more_1"))
        
        // 创建视图控制器
        let homeVC = createViewController(title: "首页")
        let findVC = createViewController(title: "发现")
        let messageVC = createViewController(title: "消息")
        let meVC = createViewController(title: "我的")
        let moreVC = createViewController(title: "更多")
        
        // 设置TabBarItem
        homeVC.tabBarItem = homeItem
        findVC.tabBarItem = findItem
        messageVC.tabBarItem = messageItem
        meVC.tabBarItem = meItem
        moreVC.tabBarItem = moreItem
        
        // 设置视图控制器
        viewControllers = [homeVC, findVC, messageVC, meVC, moreVC]
        
        // 自定义More按钮样式
        if let customTabBar = tabBar as? TFYSwiftTabBar {
            let customMoreContentView = CustomMoreContentView()
            customMoreContentView.tabbarTitle = "更多"
            customMoreContentView.image = UIImage(named: "more")
            customMoreContentView.selectedImage = UIImage(named: "more_1")
            customMoreContentView.textColor = UIColor(white: 0.57254902, alpha: 1.0)
            customMoreContentView.highlightTextColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0)
            customMoreContentView.iconColor = UIColor(white: 0.57254902, alpha: 1.0)
            customMoreContentView.highlightIconColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0)
            
            customTabBar.moreContentView = customMoreContentView
        }
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
}

/// 自定义More按钮内容视图
class CustomMoreContentView: TFYSwiftTabBarItemContentView {
    
    override func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi / 4)
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform.identity
                }) { _ in
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }
    
    override func deselectAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
            }) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
} 