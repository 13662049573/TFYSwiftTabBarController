//
//  SceneDelegate.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit
import TFYSwiftNavigationKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
   
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            // 设置根视图控制器为TabBar演示控制器
            let demoVC = TabBarDemoViewController()
            let navigationController = TFYSwiftNavigationController(rootViewController: demoVC)
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
            self.window = window
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

