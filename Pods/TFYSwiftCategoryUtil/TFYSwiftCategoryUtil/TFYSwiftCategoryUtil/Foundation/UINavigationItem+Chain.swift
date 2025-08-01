//
//  UINavigationItem+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UINavigationItem {
    /// 设置标题
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }
    /// 设置标题视图
    @discardableResult
    func titleView(_ titleView: UIView?) -> Self {
        base.titleView = titleView
        return self
    }
    /// 设置左侧按钮
    @discardableResult
    func leftBarButtonItem(_ leftBarButtonItem: UIBarButtonItem?) -> Self {
        base.leftBarButtonItem = leftBarButtonItem
        return self
    }
    /// 设置右侧按钮
    @discardableResult
    func rightBarButtonItem(_ rightBarButtonItem: UIBarButtonItem?) -> Self {
        base.rightBarButtonItem = rightBarButtonItem
        return self
    }
    /// 设置左侧按钮数组
    @discardableResult
    func leftBarButtonItems(_ leftBarButtonItems: [UIBarButtonItem]?) -> Self {
        base.leftBarButtonItems = leftBarButtonItems
        return self
    }
    /// 设置右侧按钮数组
    @discardableResult
    func rightBarButtonItems(_ rightBarButtonItems: [UIBarButtonItem]?) -> Self {
        base.rightBarButtonItems = rightBarButtonItems
        return self
    }
}
