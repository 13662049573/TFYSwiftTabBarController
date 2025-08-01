//
//  UITabBarController+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit

public extension TFY where Base: UITabBarController {
    /// 添加子视图控制器
    @discardableResult
    func addChild(_ vc:UIViewController) -> Self {
        base.addChild(vc)
        return self
    }
    /// 设置视图控制器数组
    @discardableResult
    func viewControllers(_ vc:[UIViewController]) -> Self {
        base.viewControllers = vc
        return self
    }
}

public extension TFY where Base: UITabBar {
    /// 去掉tabBar顶部线条
    @discardableResult
    func hideLine() -> Self {
        let rect = CGRect(x: 0, y: 0, width: base.bounds.size.width, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        base.backgroundImage = image
        base.shadowImage = image
        return self
    }
    /// 设置是否半透明
    @discardableResult
    func isTranslucent(_ b:Bool) -> Self {
        base.isTranslucent = b
        return self
    }
    /// 设置背景色调颜色
    @discardableResult
    func barTintColor(_ b:UIColor) -> Self {
        base.barTintColor = b
        return self
    }
    /// 添加TabBar项目
    @discardableResult
    func addTabBarItem(_ item:UITabBarItem) -> Self {
        base.items?.append(item)
        return self
    }
    /// 设置TabBar项目数组
    @discardableResult
    func tabBarItems(_ items:[UITabBarItem]) -> Self {
        base.items = items
        return self
    }
    /// 设置图片内边距
    @discardableResult
    func imageInsets(_ t:[UIEdgeInsets]) -> Self {
        base.tfy_imageInsets = t
        return self
    }
    /// 设置正常状态图片
    @discardableResult
    func imageNormals(_ t:[UIImage?]) -> Self {
        base.tfy_imageNormals = t
        return self
    }
    /// 设置选中状态图片
    @discardableResult
    func imageSelects(_ t:[UIImage?]) -> Self {
        base.tfy_imageSelects = t
        return self
    }
    /// 设置标题数组
    @discardableResult
    func titles(_ t:[String?]) -> Self {
        base.tfy_titles = t
        return self
    }
    /// 设置徽章数组
    @discardableResult
    func badges(_ t:[String?]) -> Self {
        base.tfy_badges = t
        return self
    }
    /// 设置徽章颜色数组（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func badgeColors(_ t:[UIColor?]) -> Self {
        base.tfy_badgeColors = t
        return self
    }
    /// 设置正常状态颜色
    @discardableResult
    func colorNormals(_ t:[UIColor?]) -> Self {
        base.tfy_colorNormals = t
        return self
    }
    /// 设置选中状态颜色
    @discardableResult
    func colorSelecteds(_ t:[UIColor?]) -> Self {
        base.tfy_colorSelecteds = t
        return self
    }
    /// 设置高亮状态颜色
    @discardableResult
    func colorHighlighteds(_ t:[UIColor?]) -> Self {
        base.tfy_colorHighlighteds = t
        return self
    }
    /// 设置正常状态字体
    @discardableResult
    func fontNormals(_ t:[UIFont?]) -> Self {
        base.tfy_fontNormals = t
        return self
    }
    /// 设置选中状态字体
    @discardableResult
    func fontSelecteds(_ t:[UIFont?]) -> Self {
        base.tfy_fontSelecteds = t
        return self
    }
    /// 设置高亮状态字体
    @discardableResult
    func fontHighlighteds(_ t:[UIFont?]) -> Self {
        base.tfy_fontHighlighteds = t
        return self
    }
    /// 设置徽章正常状态颜色（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func badgeColorNormals(_ t:[UIColor?]) -> Self {
        base.tfy_badgeColorNormals = t
        return self
    }
    /// 设置徽章选中状态颜色（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func badgeColorSelecteds(_ t:[UIColor?]) -> Self {
        base.tfy_badgeColorSelecteds = t
        return self
    }
    /// 设置徽章高亮状态颜色（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func badgeColorHighlighteds(_ t:[UIColor?]) -> Self {
        base.tfy_badgeColorHighlighteds = t
        return self
    }
    /// 设置徽章正常状态字体（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func badgeFontNormals(_ t:[UIFont?]) -> Self {
        base.tfy_badgeFontNormals = t
        return self
    }
    /// 设置徽章选中状态字体（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func badgeFontSelecteds(_ t:[UIFont?]) -> Self {
        base.tfy_badgeFontSelecteds = t
        return self
    }
    /// 设置徽章高亮状态字体（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func badgeFontHighlighteds(_ t:[UIFont?]) -> Self {
        base.tfy_badgeFontHighlighteds = t
        return self
    }
    /// 批量设置颜色
    @discardableResult
    func color(_ normals:[UIColor?] = [], selecteds:[UIColor?] = [], highlighteds:[UIColor?] = []) -> Self {
        base.tfy_colorNormals = normals
        base.tfy_colorSelecteds = selecteds
        base.tfy_colorHighlighteds = highlighteds
        if #available(iOS 10.0, *) {
            base.tfy_badgeColorNormals = normals
            base.tfy_badgeColorSelecteds = selecteds
            base.tfy_badgeColorHighlighteds = highlighteds
        } else {
            
        }
        return self
    }
    /// 批量设置字体
    @discardableResult
    func font(_ normals:[UIFont?] = [], selecteds:[UIFont?] = [], highlighteds:[UIFont?] = []) -> Self {
        base.tfy_fontNormals = normals
        base.tfy_fontSelecteds = selecteds
        base.tfy_fontHighlighteds = highlighteds
        if #available(iOS 10.0, *) {
            base.tfy_badgeFontNormals = normals
            base.tfy_badgeFontSelecteds = selecteds
            base.tfy_badgeFontHighlighteds = highlighteds
        }
        return self
    }
    
    //MARK:--- badge ----------
    /// 设置标题属性
    @discardableResult
    func setTitle<T>(_ value:[T?], key:NSAttributedString.Key, for state: UIControl.State) -> Self {
        guard let items = base.items else { return self}
        for (i, item) in items.enumerated() where i < value.count && value[i] != nil {
            if var attributes = item.titleTextAttributes(for: state) {
                attributes[key] = value[i]
                item.setTitleTextAttributes(attributes, for:state)
            }else{
                item.setTitleTextAttributes([key:value[i]!], for:state)
            }
        }
        return self
    }
    /// 获取标题属性
    func getTitle<T>(_ key:NSAttributedString.Key, for state: UIControl.State) -> [T?] {
        let fonts = base.items?.map({ (item) -> T? in
            guard let attributes = item.titleTextAttributes(for: state) else { return nil }
            guard let font = attributes[key] as? T else{ return nil }
            return font
        })
        return fonts ?? []
    }
    /// 设置徽章属性（iOS 10.0+）
    @discardableResult @available(iOS 10.0, *)
    func setBadge<T>(_ value:[T?], key:NSAttributedString.Key, for state: UIControl.State) -> Self {
        guard let items = base.items else { return self}
        for (i, item) in items.enumerated() where i < value.count && value[i] != nil {
            if var attributes = item.badgeTextAttributes(for: state) {
                attributes[key] = value[i]
                item.setBadgeTextAttributes(attributes, for:state)
            }else{
                item.setBadgeTextAttributes([key:value[i]!], for:state)
            }
        }
        return self
    }
    /// 获取徽章属性（iOS 10.0+）
    @available(iOS 10.0, *)
    func getBadge<T>(_ key:NSAttributedString.Key, for state: UIControl.State) -> [T?] {
        let fonts = base.items?.map({ (item) -> T? in
            guard let attributes = item.badgeTextAttributes(for: state) else { return nil }
            guard let font = attributes[key] as? T else{ return nil }
            return font
        })
        return fonts ?? []
    }
}

public extension UITabBar {
    /// 正常状态图片数组
    var tfy_imageNormals:[UIImage?] {
        set{
            guard let items = self.items else { return }
            for (i, item) in items.enumerated() where i < newValue.count {
                if let img = newValue[i] {
                    item.image = img.withRenderingMode(.alwaysOriginal)
                }
            }
        }
        get{
            return self.items?.map{$0.image} ?? []
        }
    }
    /// 选中状态图片数组
    var tfy_imageSelects:[UIImage?] {
        set{
            guard let items = self.items else { return }
            for (i, item) in items.enumerated() where i < newValue.count {
                if let img = newValue[i] {
                    item.selectedImage = img.withRenderingMode(.alwaysOriginal)
                }
            }
        }
        get{
            return self.items?.map{$0.selectedImage} ?? []
        }
    }
    /// 矫正TabBar图片位置
    var tfy_imageInsets:[UIEdgeInsets] {
        set{
            guard let items = self.items else { return }
            for (i, item) in items.enumerated() where i < newValue.count {
                item.imageInsets = newValue[i]
            }
        }
        get{
            return self.items?.map{$0.imageInsets} ?? []
        }
    }
    /// 标题数组
    var tfy_titles:[String?] {
        set{
            guard let items = self.items else { return }
            for (i, item) in items.enumerated() where i < newValue.count {
                item.title = newValue[i]
            }
        }
        get{
            return self.items?.map{$0.title} ?? []
        }
    }
    /// 徽章数组
    var tfy_badges:[String?] {
        set{
            guard let items = self.items else { return }
            for (i, item) in items.enumerated() where i < newValue.count {
                item.badgeValue = newValue[i]
            }
        }
        get{
            return self.items?.map{$0.badgeValue} ?? []
        }
    }
    /// 徽章颜色数组（iOS 10.0+）
    @available(iOS 10.0, *)
    var tfy_badgeColors:[UIColor?] {
        set{
            guard let items = self.items else { return }
            for (i, item) in items.enumerated() where i < newValue.count {
                item.badgeColor = newValue[i]
            }
        }
        get{
            return self.items?.map{$0.badgeColor} ?? []
        }
    }
    /// 正常状态颜色数组
    var tfy_colorNormals:[UIColor?] {
        set{
            self.tfy.setTitle(newValue, key: .foregroundColor, for: .normal)
        }
        get{
            return self.tfy.getTitle(.foregroundColor, for: .normal)
        }
    }
    /// 选中状态颜色数组
    var tfy_colorSelecteds:[UIColor?] {
        set{
            self.tfy.setTitle(newValue, key: .foregroundColor, for: .selected)
        }
        get{
            return self.tfy.getTitle(.foregroundColor, for: .selected)
        }
    }
    /// 高亮状态颜色数组
    var tfy_colorHighlighteds:[UIColor?] {
        set{
            self.tfy.setTitle(newValue, key: .foregroundColor, for: .highlighted)
        }
        get{
            return self.tfy.getTitle(.foregroundColor, for: .highlighted)
        }
    }
    /// 正常状态字体数组
    var tfy_fontNormals:[UIFont?] {
        set{
            self.tfy.setTitle(newValue, key: .font, for: .normal)
        }
        get{
            return self.tfy.getTitle(.font, for: .normal)
        }
    }
    /// 选中状态字体数组
    var tfy_fontSelecteds:[UIFont?] {
        set{
            self.tfy.setTitle(newValue, key: .font, for: .selected)
        }
        get{
            return self.tfy.getTitle(.font, for: .selected)
        }
    }
    /// 高亮状态字体数组
    var tfy_fontHighlighteds:[UIFont?] {
        set{
            self.tfy.setTitle(newValue, key: .font, for: .highlighted)
        }
        get{
            return self.tfy.getTitle(.font, for: .highlighted)
        }
    }
    
    //MARK:--- badge ----------
    /// 徽章正常状态颜色数组（iOS 10.0+）
    @available(iOS 10.0, *)
    var tfy_badgeColorNormals:[UIColor?] {
        set{
            self.tfy.setBadge(newValue, key: .foregroundColor, for: .normal)
        }
        get{
            return self.tfy.getBadge(.foregroundColor, for: .normal)
        }
    }
    /// 徽章选中状态颜色数组（iOS 10.0+）
    @available(iOS 10.0, *)
    var tfy_badgeColorSelecteds:[UIColor?] {
        set{
            self.tfy.setBadge(newValue, key: .foregroundColor, for: .selected)
        }
        get{
            return self.tfy.getBadge(.foregroundColor, for: .selected)
        }
    }
    /// 徽章高亮状态颜色数组（iOS 10.0+）
    @available(iOS 10.0, *)
    var tfy_badgeColorHighlighteds:[UIColor?] {
        set{
            self.tfy.setBadge(newValue, key: .foregroundColor, for: .highlighted)
        }
        get{
            return self.tfy.getBadge(.foregroundColor, for: .highlighted)
        }
    }
    /// 徽章正常状态字体数组（iOS 10.0+）
    @available(iOS 10.0, *)
    var tfy_badgeFontNormals:[UIFont?] {
        set{
            self.tfy.setBadge(newValue, key: .font, for: .normal)
        }
        get{
            return self.tfy.getBadge(.font, for: .normal)
        }
    }
    /// 徽章选中状态字体数组（iOS 10.0+）
    @available(iOS 10.0, *)
    var tfy_badgeFontSelecteds:[UIFont?] {
        set{
            self.tfy.setBadge(newValue, key: .font, for: .selected)
        }
        get{
            return self.tfy.getBadge(.font, for: .selected)
        }
    }
    /// 徽章高亮状态字体数组（iOS 10.0+）
    @available(iOS 10.0, *)
    var tfy_badgeFontHighlighteds:[UIFont?] {
        set{
            self.tfy.setBadge(newValue, key: .font, for: .highlighted)
        }
        get{
            return self.tfy.getBadge(.font, for: .highlighted)
        }
    }
}
