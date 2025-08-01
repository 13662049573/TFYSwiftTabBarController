//
//  UINavigationBar+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UINavigationBar {
    /// 设置导航栏样式
    @discardableResult
    func barStyle(_ barStyle: UIBarStyle) -> Self {
        base.barStyle = barStyle
        return self
    }
    /// 设置是否半透明
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        base.isTranslucent = isTranslucent
        return self
    }
    /// 设置背景色调颜色
    @discardableResult
    func barTintColor(_ barTintColor: UIColor?) -> Self {
        base.barTintColor = barTintColor
        return self
    }
    /// 设置背景图片
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for barPosition: UIBarPosition = .any, barMetrics: UIBarMetrics = .default) -> Self {
        base.setBackgroundImage(backgroundImage, for: barPosition, barMetrics: barMetrics)
        return self
    }
    /// 设置阴影图片
    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> Self {
        base.shadowImage = shadowImage
        return self
    }
    /// 设置标题文本属性
    @discardableResult
    func titleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key : Any]?) -> Self {
        base.titleTextAttributes = titleTextAttributes
        return self
    }
    /// 设置是否偏好大标题（iOS 11.0+）
    @discardableResult
    func prefersLargeTitles(_ prefersLargeTitles: Bool) -> Self {
        if #available(iOS 11.0, *) {
            base.prefersLargeTitles = prefersLargeTitles
        }
        return self
    }
    /// 设置大标题文本属性（iOS 11.0+）
    @discardableResult
    func largeTitleTextAttributes(_ largeTitleTextAttributes: [NSAttributedString.Key : Any]?) -> Self {
        if #available(iOS 11.0, *) {
            base.largeTitleTextAttributes = largeTitleTextAttributes
        }
        return self
    }
}
