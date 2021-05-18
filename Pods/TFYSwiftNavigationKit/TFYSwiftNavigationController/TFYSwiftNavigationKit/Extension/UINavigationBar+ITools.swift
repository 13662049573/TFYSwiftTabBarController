//
//  UINavigationBar+ITools.swift
//  TFYSwiftNavigationKit
//
//  Created by 田风有 on 2021/5/15.
//

import UIKit

public extension UINavigationBar {

    /// 标题透明度
    func setTitleAlpha(_ alpha: CGFloat) {
        let color = titleTextAttributes?[.foregroundColor] as? UIColor ?? defaultTitleColor
        setTitleColor(color.withAlphaComponent(alpha))
    }

    /// 开启最大标题的时候，字体透明度
    @available(iOS 11.0, *)
    func setLargeTitleAlpha(_ alpha: CGFloat) {
        let color = largeTitleTextAttributes?[.foregroundColor] as? UIColor ?? defaultTitleColor
        setLargeTitleColor(color.withAlphaComponent(alpha))
    }

    /// 标题颜色透明度
    func setTintAlpha(_ alpha: CGFloat) {
        tintColor = tintColor.withAlphaComponent(alpha)
    }
}

private extension UINavigationBar {
    
    var defaultTitleColor: UIColor {
        return barStyle == .default ? UIColor.black : UIColor.white
    }
    
    func setTitleColor(_ color: UIColor) {
        if var titleTextAttributes = titleTextAttributes {
            titleTextAttributes[.foregroundColor] = color
            self.titleTextAttributes = titleTextAttributes
        } else {
            titleTextAttributes = [.foregroundColor: color]
        }
    }
    
    @available(iOS 11.0, *)
    func setLargeTitleColor(_ color: UIColor) {
        if var largeTitleTextAttributes = largeTitleTextAttributes {
            largeTitleTextAttributes[.foregroundColor] = color
            self.largeTitleTextAttributes = largeTitleTextAttributes
        } else {
            self.largeTitleTextAttributes = [.foregroundColor: color]
        }
    }
}
