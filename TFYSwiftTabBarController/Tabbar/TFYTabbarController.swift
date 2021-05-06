//
//  TFYTabbarController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit

class TFYTabbarController: TFYSwiftTabbarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        localTabbar()
        // Do any additional setup after loading the view.
        // 请忽略这个，这是我测试小火箭用的
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabbarIcon), name: NSNotification.Name(rawValue: "changeTabbarIcon"), object: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        super.tabBar(tabBar, didSelect: item)
        
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        print("当前是：\(index)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// - Parameter nofi: 通知参数
    @objc func changeTabbarIcon(nofi: Notification) {
        guard let value = nofi.userInfo!["value"] as? String else {
            return
        }
        tabBarView.changeHomeTabbarIcon(value: value)
    }
    
    // 移除通知
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

extension TFYTabbarController {
    // MARK: 本地TabBar的配置
    /// 本地TabBar的配置
    func localTabbar() {
        let vc1 = TFYSwiftHomeController()
        vc1.view.backgroundColor = UIColor.purple
        
        let vc2 = TFYSwiftTradeController()
        vc2.view.backgroundColor = UIColor.white
        
        let vc3 = TFYSwiftProfileController()
        vc3.view.backgroundColor = UIColor.yellow
        
        let vc4 = ViewController()
        vc4.view.backgroundColor = UIColor.orange
        
        viewControllers = [UINavigationController(rootViewController: vc1), UINavigationController(rootViewController: vc2), UINavigationController(rootViewController: vc3),UINavigationController(rootViewController: vc4)]
        
        let titleColor = UIColor.red
        let selectedColor = UIColor.orange
        // 测试读取本地图片
        let tabBarItemOne = TFYSwiftTabBarItem(localImageCount: 5, duration: 0.5, title: "行情", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_quotation")
        let tabBarItemTwo = TFYSwiftTabBarItem(title: "交易", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_trade")
        let tabBarItemThree = TFYSwiftTabBarItem(title: "我的", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "tabbar_profile")
        
        let tabBarItemfour = TFYSwiftTabBarItem(title: "测试", titleColor: titleColor, selectedTitleColor: selectedColor, defaultImageName: "new_tabbar_community")
        
        tabBarView.barButtonItems = [tabBarItemOne, tabBarItemTwo, tabBarItemThree,tabBarItemfour]
        tabBarView.tabBarItem = tabBarItemTwo
    }
}
