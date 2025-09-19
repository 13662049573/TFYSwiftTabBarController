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
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let menu = AllDemosViewController()
        let nav = TFYSwiftNavigationController(rootViewController: menu)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}

