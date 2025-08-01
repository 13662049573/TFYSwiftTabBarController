//
//  BadgeTabBarViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// 徽章功能展示
class BadgeTabBarViewController: TFYSwiftTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBadgeTabBar()
    }
    
    private func setupBadgeTabBar() {
        // 创建自定义TabBarItem
        let homeItem = createBadgeTabBarItem(title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"), badgeValue: "99+")
        let findItem = createBadgeTabBarItem(title: "发现", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"), badgeValue: "5")
        let messageItem = createBadgeTabBarItem(title: "消息", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"), badgeValue: "")
        let meItem = createBadgeTabBarItem(title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"), badgeValue: nil)
        
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
        
        // 添加徽章更新按钮
        addBadgeUpdateButton()
    }
    
    private func createBadgeTabBarItem(title: String, image: UIImage?, selectedImage: UIImage?, badgeValue: String?) -> TFYSwiftTabBarItem {
        let contentView = TFYSwiftTabBarItemContentView()
        contentView.tabbarTitle = title
        contentView.image = image
        contentView.selectedImage = selectedImage
        contentView.badgeValue = badgeValue
        
        // 自定义徽章颜色
        if badgeValue != nil {
            contentView.badgeColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
        
        return TFYSwiftTabBarItem(contentView, title: title, image: image, selectedImage: selectedImage)
    }
    
    private func createViewController(title: String) -> UINavigationController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = title
        
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    private func addBadgeUpdateButton() {
        guard let firstNav = viewControllers?.first as? UINavigationController,
              let firstVC = firstNav.viewControllers.first else { return }
        
        let button = UIButton(type: .system)
        button.setTitle("更新徽章", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(updateBadge), for: .touchUpInside)
        
        firstVC.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: firstVC.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: firstVC.view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func updateBadge() {
        // 随机更新徽章
        let badgeValues = ["1", "5", "99+", "", nil]
        let randomValue = badgeValues.randomElement()
        
        if let tabBarItem = viewControllers?[1].tabBarItem as? TFYSwiftTabBarItem {
            tabBarItem.badgeValue = randomValue as? String
        }
    }
} 
