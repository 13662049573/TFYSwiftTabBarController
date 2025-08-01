//
//  AnimationTabBarViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// 动画效果展示
class AnimationTabBarViewController: TFYSwiftTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimationTabBar()
    }
    
    private func setupAnimationTabBar() {
        // 创建自定义TabBarItem
        let homeItem = createAnimationTabBarItem(title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        let findItem = createAnimationTabBarItem(title: "发现", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        let messageItem = createAnimationTabBarItem(title: "消息", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        let meItem = createAnimationTabBarItem(title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
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
    }
    
    private func createAnimationTabBarItem(title: String, image: UIImage?, selectedImage: UIImage?) -> TFYSwiftTabBarItem {
        let contentView = AnimatedTabBarItemContentView()
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

/// 带动画效果的TabBarItem内容视图
class AnimatedTabBarItemContentView: TFYSwiftTabBarItemContentView {
    
    override func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
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
    
    override func reselectAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
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
    
    override func highlightAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.7
            }) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    override func dehighlightAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1.0
            }) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
} 