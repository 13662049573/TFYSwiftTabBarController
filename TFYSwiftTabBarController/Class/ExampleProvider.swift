//
//  ExampleProvider.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 2017/2/9.
//  Copyright © 2018年 Egg Swift. All rights reserved.
//

import UIKit


enum ExampleProvider {
    static func systemStyle() -> UITabBarController {
        let tabBarController = UITabBarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = UITabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = UITabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = UITabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = UITabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.tabBar.shadowImage = nil
            
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarController
    }
    
    static func customStyle() -> TFYSwiftTabbarController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarController
    }
    
    static func mixtureStyle() -> TFYSwiftTabbarController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = UITabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = UITabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarController
    }
    
    static func systemMoreStyle() -> UITabBarController {
        let tabBarController = UITabBarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        let v6 = ExampleViewController()
        let v7 = ExampleViewController()
        let v8 = ExampleViewController()
        
        v1.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = UITabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = UITabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = UITabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = UITabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        v6.tabBarItem = UITabBarItem.init(title: "Message", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        v7.tabBarItem = UITabBarItem.init(title: "Shop", image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_1"))
        v8.tabBarItem = UITabBarItem.init(title: "Cardboard", image: UIImage(named: "cardboard"), selectedImage: UIImage(named: "cardboard_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5, v6, v7, v8]
        
        return tabBarController
    }
    
    static func customMoreStyle() -> TFYSwiftTabbarController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        let v6 = ExampleViewController()
        let v7 = ExampleViewController()
        let v8 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        v6.tabBarItem = TFYSwiftTabBarItem.init(title: "Message", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        v7.tabBarItem = TFYSwiftTabBarItem.init(title: "Shop", image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_1"))
        v8.tabBarItem = TFYSwiftTabBarItem.init(title: "Cardboard", image: UIImage(named: "cardboard"), selectedImage: UIImage(named: "cardboard_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5, v6, v7, v8]
        
        return tabBarController
    }
    
    static func mixtureMoreStyle() -> TFYSwiftTabbarController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        let v6 = ExampleViewController()
        let v7 = ExampleViewController()
        let v8 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = UITabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = UITabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        v6.tabBarItem = UITabBarItem.init(title: "Message", image: UIImage(named: "message"), selectedImage: UIImage(named: "message_1"))
        v7.tabBarItem = TFYSwiftTabBarItem.init(title: "Shop", image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_1"))
        v8.tabBarItem = UITabBarItem.init(title: "Cardboard", image: UIImage(named: "cardboard"), selectedImage: UIImage(named: "cardboard_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5, v6, v7, v8]
        
        return tabBarController
    }
    
    static func navigationWithTabbarStyle() -> ExampleNavigationController {
        let tabBarController = ExampleProvider.customStyle()
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func tabbarWithNavigationStyle() -> TFYSwiftTabbarController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        let n1 = ExampleNavigationController.init(rootViewController: v1)
        let n2 = ExampleNavigationController.init(rootViewController: v2)
        let n3 = ExampleNavigationController.init(rootViewController: v3)
        let n4 = ExampleNavigationController.init(rootViewController: v4)
        let n5 = ExampleNavigationController.init(rootViewController: v5)
        
        v1.title = "Home"
        v2.title = "Find"
        v3.title = "Photo"
        v4.title = "List"
        v5.title = "Me"
        
        tabBarController.viewControllers = [n1, n2, n3, n4, n5]

        return tabBarController
    }
    
    static func customColorStyle() -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleBasicContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleBasicContentView(), title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleBasicContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleBasicContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func customBouncesStyle() -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleBouncesContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleBouncesContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleBouncesContentView(), title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleBouncesContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleBouncesContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func customBackgroundColorStyle(implies: Bool) -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        if let tabBar = tabBarController.tabBar as? TFYSwiftTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleBackgroundContentView(), title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleBackgroundContentView(), title: nil, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleBackgroundContentView.init(specialWithAutoImplies: implies), title: nil, image: UIImage(named: "photo_big"), selectedImage: UIImage(named: "photo_big_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleBackgroundContentView(), title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleBackgroundContentView(), title: nil, image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func customHighlightableStyle() -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        if let tabBar = tabBarController.tabBar as? TFYSwiftTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
				let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
				alertController.addAction(takePhotoAction)
				let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
				alertController.addAction(selectFromAlbumAction)
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				alertController.addAction(cancelAction)
				tabBarController?.present(alertController, animated: true, completion: nil)
			}
        }

        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func customTipsStyle(delegate: UITabBarControllerDelegate?) -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleTipsBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleTipsBasicContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleTipsBasicContentView(), title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleTipsBasicContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleTipsContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func systemRemindStyle() -> UITabBarController {
        let tabBarController = UITabBarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = UITabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = UITabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = UITabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = UITabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))

        v1.tabBarItem.badgeValue = "New"
        v2.tabBarItem.badgeValue = "99+"
        v3.tabBarItem.badgeValue = "1"
        if let tabBarItem = v3.tabBarItem as? TFYSwiftTabBarItem {
            tabBarItem.badgeColor = UIColor.blue
        }
        v4.tabBarItem.badgeValue = ""
        v5.tabBarItem.badgeValue = nil
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]

        return tabBarController
    }
    
    static func customRemindStyle() -> UITabBarController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        if let tabBarItem = v1.tabBarItem as? TFYSwiftTabBarItem {
            tabBarItem.badgeValue = "New"
        }
        if let tabBarItem = v2.tabBarItem as? TFYSwiftTabBarItem {
            tabBarItem.badgeValue = "99+"
        }
        if let tabBarItem = v3.tabBarItem as? TFYSwiftTabBarItem {
            tabBarItem.badgeValue = "1"
            tabBarItem.badgeColor = UIColor.blue
        }
        if let tabBarItem = v4.tabBarItem as? TFYSwiftTabBarItem {
            tabBarItem.badgeValue = ""
        }
        if let tabBarItem = v5.tabBarItem as? TFYSwiftTabBarItem {
            tabBarItem.badgeValue = nil
        }
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
    
        return tabBarController
    }
    
    static func customAnimateRemindStyle(implies: Bool) -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        if let tabBar = tabBarController.tabBar as? TFYSwiftTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView(), title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView(), title: nil, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView.init(specialWithAutoImplies: implies), title: nil, image: UIImage(named: "photo_big"), selectedImage: UIImage(named: "photo_big_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView(), title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView(), title: nil, image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        if let tabBarItem = v2.tabBarItem as? TFYSwiftTabBarItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                tabBarItem.badgeValue = "1"
            }
        }
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func customAnimateRemindStyle2(implies: Bool) -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        if let tabBar = tabBarController.tabBar as? TFYSwiftTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView2(), title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView2(), title: nil, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView2.init(specialWithAutoImplies: implies), title: nil, image: UIImage(named: "photo_big"), selectedImage: UIImage(named: "photo_big_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView2(), title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView2(), title: nil, image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        if let tabBarItem = v2.tabBarItem as? TFYSwiftTabBarItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                tabBarItem.badgeValue = "1"
            }
        }
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }

    static func customAnimateRemindStyle3(implies: Bool) -> ExampleNavigationController {
        let tabBarController = TFYSwiftTabbarController()
        if let tabBar = tabBarController.tabBar as? TFYSwiftTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView3(), title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView3(), title: nil, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView3.init(specialWithAutoImplies: implies), title: nil, image: UIImage(named: "photo_big"), selectedImage: UIImage(named: "photo_big_1"))
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView3(), title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleAnimateTipsContentView3(), title: nil, image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        if let tabBarItem = v2.tabBarItem as? TFYSwiftTabBarItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                tabBarItem.badgeValue = "1"
            }
        }
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
    static func lottieSytle() -> TFYSwiftTabbarController {
        let tabBarController = TFYSwiftTabbarController()
        let v1 = ExampleViewController()
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = TFYSwiftTabBarItem.init(ExampleLottieAnimateBasicContentView(), title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = TFYSwiftTabBarItem.init(ExampleLottieAnimateBasicContentView(), title: nil, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = TFYSwiftTabBarItem.init(ExampleLottieAnimateContentView(), title: nil, image: nil, selectedImage: nil)
        v4.tabBarItem = TFYSwiftTabBarItem.init(ExampleLottieAnimateBasicContentView(), title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = TFYSwiftTabBarItem.init(ExampleLottieAnimateBasicContentView(), title: nil, image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarController
    }

}
