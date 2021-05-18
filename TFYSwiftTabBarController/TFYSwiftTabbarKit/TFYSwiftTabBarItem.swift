//
//  TFYSwiftTabBarItem.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit

public class TFYSwiftTabBarItem: UITabBarItem {

    internal weak var tabBar: TFYSwiftTabBar?
    public private(set) var containerView: TFYSwiftTabBarItemContainerView?
    
    /// 初始化方法
    public init(containerView: TFYSwiftTabBarItemContainerView) {
        super.init()
        self.containerView = containerView
    }
    
    /// 设置`item`的宽度，如果为`nil`或者`0`，框架内部会自动设置宽度(当`tabBar`的`layoutType`为`fillUp`时，有效)
    public var itemWidth: CGFloat? {
        didSet {
            guard let tabBar = self.tabBar else { return }
            if tabBar.layoutType == .fillUp {
                tabBar.setNeedsLayout()
                tabBar.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
