//
//  HijackTabBarController.swift
//  TabBar
//
//  Created by galaxy on 2020/10/29.
//

import UIKit

public class HijackTabBarController: TFYSwiftTabbarController {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var quanquanItemContainerView: TFYSwiftTabBarItemContainerView = {
        let quanquanItemContainerView = TFYSwiftTabBarItemContainerView()
        quanquanItemContainerView.normalImage = UIImage(named: "tab_bar_quanquan_normal")
        quanquanItemContainerView.selectedImage = UIImage(named: "tab_bar_quanquan_selected")
        quanquanItemContainerView.title = "圈圈"
        return quanquanItemContainerView
    }()
    
    private lazy var tantanItemContainerView: TFYSwiftTabBarItemContainerView = {
        let tantanItemContainerView = TFYSwiftTabBarItemContainerView()
        tantanItemContainerView.normalImage = UIImage(named: "tab_bar_tantan_normal")
        tantanItemContainerView.selectedImage = UIImage(named: "tab_bar_tantan_selected")
        tantanItemContainerView.title = "摊摊"
        return tantanItemContainerView
    }()
    
    private lazy var messageeItemContainerView: TFYSwiftTabBarItemContainerView = {
        let messageeItemContainerView = TFYSwiftTabBarItemContainerView()
        messageeItemContainerView.normalImage = UIImage(named: "tab_bar_message_normal")
        messageeItemContainerView.selectedImage = UIImage(named: "tab_bar_message_selected")
        messageeItemContainerView.title = "消息"
        return messageeItemContainerView
    }()
    
    private lazy var meItemContainerView: TFYSwiftTabBarItemContainerView = {
        let meItemContainerView = TFYSwiftTabBarItemContainerView()
        meItemContainerView.normalImage = UIImage(named: "tab_bar_me_normal")
        meItemContainerView.selectedImage = UIImage(named: "tab_bar_me_selected")
        meItemContainerView.title = "我的"
        return meItemContainerView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let quanquanItem = TFYSwiftTabBarItem(containerView: self.quanquanItemContainerView)
        let tantanItem = TFYSwiftTabBarItem(containerView: self.tantanItemContainerView)
        let messageItem = TFYSwiftTabBarItem(containerView: self.messageeItemContainerView)
        let meItem = TFYSwiftTabBarItem(containerView: self.meItemContainerView)
        
        let vc1 = HijackViewController()
        let vc2 = HijackViewController()
        let vc3 = HijackViewController()
        let vc4 = HijackViewController()
        let navi1 = TFYSwiftNaviController(rootViewController: vc1)
        let navi2 = TFYSwiftNaviController(rootViewController: vc2)
        let navi3 = TFYSwiftNaviController(rootViewController: vc3)
        let navi4 = TFYSwiftNaviController(rootViewController: vc4)
        
        navi1.tabBarItem = quanquanItem
        navi2.tabBarItem = tantanItem
        navi3.tabBarItem = messageItem
        navi4.tabBarItem = meItem
        
        self.viewControllers = [navi1, navi2, navi3, navi4]
        
        self.canHijackHandler = { (_, _, index) -> Bool in
            if index == 1 {
                return true
            }
            return false
        }
        self.didHijackHandler = { (_, _, index) in
            print("索引为\(index)的item的点击事件被拦截")
        }
    }
}
