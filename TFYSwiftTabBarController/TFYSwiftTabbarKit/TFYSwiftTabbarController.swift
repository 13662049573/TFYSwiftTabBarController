//
//  TFYSwiftTabbarController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit

// MARK: - Type Aliases
/// 是否需要自定义点击事件回调类型
public typealias TFYSwiftTabBarControllerShouldHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> Bool)
/// 自定义点击事件回调类型
public typealias TFYSwiftTabBarControllerDidHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> Void)

// MARK: - TFYSwiftTabbarController
/// 高度自定义的TabBar控制器
open class TFYSwiftTabbarController: UITabBarController, TFYSwiftTabBarDelegate {
    
    // MARK: - Properties
    
    /// 忽略下一个选择标志
    private var ignoreNextSelection = false
    
    /// 劫机是否应该选择行动
    open var shouldHijackHandler: TFYSwiftTabBarControllerShouldHijackHandler?
    
    /// 劫持行动选择
    open var didHijackHandler: TFYSwiftTabBarControllerDidHijackHandler?
    
    // MARK: - Static Methods
    
    /// 打印异常信息
    public static func printError(_ description: String) {
        #if DEBUG
        print("ERROR: TFYSwiftTabBarController catch an error '\(description)' \n")
        #endif
    }
    
    /// 检查当前tabBarController是否存在"More"tab
    public static func isShowingMore(_ tabBarController: UITabBarController?) -> Bool {
        return tabBarController?.moreNavigationController.parent != nil
    }
    
    // MARK: - Override Properties
    
    /// 观察者选项selectedViewController
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else { return }
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            
            guard let tabBar = self.tabBar as? TFYSwiftTabBar,
                  let items = tabBar.items,
                  let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            
            let value = (TFYSwiftTabbarController.isShowingMore(self) && index > items.count - 1) ? items.count - 1 : index
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }
    
    /// 观察者选项的selectedIndex
    open override var selectedIndex: Int {
        willSet {
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            
            guard let tabBar = self.tabBar as? TFYSwiftTabBar,
                  let items = tabBar.items else {
                return
            }
            
            let value = (TFYSwiftTabbarController.isShowingMore(self) && newValue > items.count - 1) ? items.count - 1 : newValue
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }
    
    // MARK: - Lifecycle
    
    /// 自定义设置选项卡使用KVC
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
    
    // MARK: - Private Methods
    
    /// 设置自定义TabBar
    private func setupCustomTabBar() {
        let tabBar = TFYSwiftTabBar()
        tabBar.delegate = self
        tabBar.customDelegate = self
        tabBar.tabBarController = self
        self.setValue(tabBar, forKey: "tabBar")
    }
    
    // MARK: - UITabBar Delegate
    
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else { return }
        
        if idx == tabBar.items!.count - 1, TFYSwiftTabbarController.isShowingMore(self) {
            ignoreNextSelection = true
            selectedViewController = moreNavigationController
            return
        }
        
        if let vc = viewControllers?[idx] {
            ignoreNextSelection = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: vc)
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        if let tabBar = tabBar as? TFYSwiftTabBar {
            tabBar.updateLayout()
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        if let tabBar = tabBar as? TFYSwiftTabBar {
            tabBar.updateLayout()
        }
    }
    
    // MARK: - TFYSwiftTabBar Delegate
    
    internal func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        guard let idx = tabBar.items?.firstIndex(of: item),
              let vc = viewControllers?[idx] else {
            return true
        }
        return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
    }
    
    internal func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool {
        guard let idx = tabBar.items?.firstIndex(of: item),
              let vc = viewControllers?[idx] else {
            return false
        }
        return shouldHijackHandler?(self, vc, idx) ?? false
    }
    
    internal func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item),
              let vc = viewControllers?[idx] else {
            return
        }
        didHijackHandler?(self, vc, idx)
    }
}
