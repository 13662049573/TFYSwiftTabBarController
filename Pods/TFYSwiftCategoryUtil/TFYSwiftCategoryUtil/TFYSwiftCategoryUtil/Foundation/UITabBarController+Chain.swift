//
//  UITabBarController+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public extension TFY where Base: UITabBarController {
    @discardableResult
    func addChild(_ vc:UIViewController) -> TFY {
        base.addChild(vc)
        return self
    }
    
    @discardableResult
    func viewControllers(_ vc:[UIViewController]) -> TFY {
        base.viewControllers = vc
        return self
    }
}

public extension TFY where Base: UITabBar {
    
    /// 去掉tabBar顶部线条
    @discardableResult
    func hideLine() -> TFY {
       
        let rect = CGRect(x: 0, y: 0, width: base.bounds.size.width, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.clear.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        base.backgroundImage = image
        base.shadowImage = image
        return self
    }
    
    @discardableResult
    func isTranslucent(_ b:Bool) -> TFY {
        base.isTranslucent = b
        return self
    }
    
    @discardableResult
    func barTintColor(_ b:UIColor) -> TFY {
        base.barTintColor = b
        return self
    }
    
    
    @discardableResult
    func addTabBarItem(_ item:UITabBarItem) -> TFY {
        base.items?.append(item)
        return self
    }
    
    @discardableResult
    func tabBarItems(_ items:[UITabBarItem]) -> TFY {
        base.items = items
        return self
    }

    @discardableResult
    func imageInsets(_ t:[UIEdgeInsets]) -> TFY {
        base.tfy_imageInsets = t
        return self
    }
    
    @discardableResult
    func imageNormals(_ t:[UIImage?]) -> TFY {
        base.tfy_imageNormals = t
        return self
    }
    
    @discardableResult
    func imageSelects(_ t:[UIImage?]) -> TFY {
        base.tfy_imageSelects = t
        return self
    }
    @discardableResult
    func titles(_ t:[String?]) -> TFY {
        base.tfy_titles = t
        return self
    }
    @discardableResult
    func badges(_ t:[String?]) -> TFY {
        base.tfy_badges = t
        return self
    }
    
    @discardableResult @available(iOS 10.0, *)
    func badgeColors(_ t:[UIColor?]) -> TFY {
        base.tfy_badgeColors = t
        return self
    }
    
    @discardableResult
    func colorNormals(_ t:[UIColor?]) -> TFY {
        base.tfy_colorNormals = t
        return self
    }
    @discardableResult
    func colorSelecteds(_ t:[UIColor?]) -> TFY {
        base.tfy_colorSelecteds = t
        return self
    }
    
    
    @discardableResult
    func colorHighlighteds(_ t:[UIColor?]) -> TFY {
        base.tfy_colorHighlighteds = t
        return self
    }
    @discardableResult
    func fontNormals(_ t:[UIFont?]) -> TFY {
        base.tfy_fontNormals = t
        return self
    }
    @discardableResult
    func fontSelecteds(_ t:[UIFont?]) -> TFY {
        base.tfy_fontSelecteds = t
        return self
    }
    
    @discardableResult
    func fontHighlighteds(_ t:[UIFont?]) -> TFY {
        base.tfy_fontHighlighteds = t
        return self
    }
    @discardableResult @available(iOS 10.0, *)
    func badgeColorNormals(_ t:[UIColor?]) -> TFY {
        base.tfy_badgeColorNormals = t
        return self
    }
    @discardableResult @available(iOS 10.0, *)
    func badgeColorSelecteds(_ t:[UIColor?]) -> TFY {
        base.tfy_badgeColorSelecteds = t
        return self
    }
    @discardableResult @available(iOS 10.0, *)
    func badgeColorHighlighteds(_ t:[UIColor?]) -> TFY {
        base.tfy_badgeColorHighlighteds = t
        return self
    }
    
    @discardableResult @available(iOS 10.0, *)
    func badgeFontNormals(_ t:[UIFont?]) -> TFY {
        base.tfy_badgeFontNormals = t
        return self
    }
    
    
    @discardableResult @available(iOS 10.0, *)
    func badgeFontSelecteds(_ t:[UIFont?]) -> TFY {
        base.tfy_badgeFontSelecteds = t
        return self
    }
    
    
    @discardableResult @available(iOS 10.0, *)
    func badgeFontHighlighteds(_ t:[UIFont?]) -> TFY {
        base.tfy_badgeFontHighlighteds = t
        return self
    }
    
    @discardableResult
    func color(_ normals:[UIColor?] = [], selecteds:[UIColor?] = [], highlighteds:[UIColor?] = []) -> TFY {
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
    
    @discardableResult
    func font(_ normals:[UIFont?] = [], selecteds:[UIFont?] = [], highlighteds:[UIFont?] = []) -> TFY {
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
    @discardableResult
    func setTitle<T>(_ value:[T?], key:NSAttributedString.Key, for state: UIControl.State) -> TFY {
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
    
    func getTitle<T>(_ key:NSAttributedString.Key, for state: UIControl.State) -> [T?] {
        let fonts = base.items?.map({ (item) -> T? in
            guard let attributes = item.titleTextAttributes(for: state) else { return nil }
            guard let font = attributes[key] as? T else{ return nil }
            return font
        })
        return fonts ?? []
    }
    
    
    @discardableResult @available(iOS 10.0, *)
    func setBadge<T>(_ value:[T?], key:NSAttributedString.Key, for state: UIControl.State) -> TFY {
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
    
    
    
    var tfy_colorNormals:[UIColor?] {
        set{
            self.tfy.setTitle(newValue, key: .foregroundColor, for: .normal)
        }
        get{
            return self.tfy.getTitle(.foregroundColor, for: .normal)
        }
    }
    
    
    var tfy_colorSelecteds:[UIColor?] {
        set{
            self.tfy.setTitle(newValue, key: .foregroundColor, for: .selected)
        }
        get{
            return self.tfy.getTitle(.foregroundColor, for: .selected)
        }
    }
    
    
    var tfy_colorHighlighteds:[UIColor?] {
        set{
            self.tfy.setTitle(newValue, key: .foregroundColor, for: .highlighted)
        }
        get{
            return self.tfy.getTitle(.foregroundColor, for: .highlighted)
        }
    }
    
    var tfy_fontNormals:[UIFont?] {
        set{
            self.tfy.setTitle(newValue, key: .font, for: .normal)
        }
        get{
            return self.tfy.getTitle(.font, for: .normal)
        }
    }
    
    
    var tfy_fontSelecteds:[UIFont?] {
        set{
            self.tfy.setTitle(newValue, key: .font, for: .selected)
        }
        get{
            return self.tfy.getTitle(.font, for: .selected)
        }
    }
    
    
    var tfy_fontHighlighteds:[UIFont?] {
        set{
            self.tfy.setTitle(newValue, key: .font, for: .highlighted)
        }
        get{
            return self.tfy.getTitle(.font, for: .highlighted)
        }
    }
    
    //MARK:--- badge ----------
    
    @available(iOS 10.0, *)
    var tfy_badgeColorNormals:[UIColor?] {
        set{
            self.tfy.setBadge(newValue, key: .foregroundColor, for: .normal)
        }
        get{
            return self.tfy.getBadge(.foregroundColor, for: .normal)
        }
    }
    
    @available(iOS 10.0, *)
    var tfy_badgeColorSelecteds:[UIColor?] {
        set{
            self.tfy.setBadge(newValue, key: .foregroundColor, for: .selected)
        }
        get{
            return self.tfy.getBadge(.foregroundColor, for: .selected)
        }
    }
    
    @available(iOS 10.0, *)
    var tfy_badgeColorHighlighteds:[UIColor?] {
        set{
            self.tfy.setBadge(newValue, key: .foregroundColor, for: .highlighted)
        }
        get{
            return self.tfy.getBadge(.foregroundColor, for: .highlighted)
        }
    }
    
    @available(iOS 10.0, *)
    var tfy_badgeFontNormals:[UIFont?] {
        set{
            self.tfy.setBadge(newValue, key: .font, for: .normal)
        }
        get{
            return self.tfy.getBadge(.font, for: .normal)
        }
    }
    @available(iOS 10.0, *)
    var tfy_badgeFontSelecteds:[UIFont?] {
        set{
            self.tfy.setBadge(newValue, key: .font, for: .selected)
        }
        get{
            return self.tfy.getBadge(.font, for: .selected)
        }
    }
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
