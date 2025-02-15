//
//  UIViewControllerr+NavigationBar.swift
//  TFYSwiftNavigationController
//
//  Created by 田风有 on 2022/5/4.
//

import Foundation
import UIKit

// MARK: -  自定义导航栏相关的属性, 支持UINavigationBar.appearance()
public extension UIViewController {
    
    // MARK: -  属性
    /// keys
    private struct TFYSwiftNavigationBarKeys {
        static var barStyle:UInt8 = 100
        static var backgroundColor:UInt8 = 101
        static var backgroundImage:UInt8 = 102
        static var tintColor:UInt8 = 103
        static var barAlpha:UInt8 = 104
        static var titleColor:UInt8 = 105
        static var titleFont:UInt8 = 106
        static var shadowHidden:UInt8 = 107
        static var shadowColor:UInt8 = 108
        static var enablePopGesture:UInt8 = 109
    }

    /// 导航栏样式，默认样式
    var tfy_barStyle: UIBarStyle {
        get {
            return objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.barStyle) as? UIBarStyle ?? UINavigationBar.appearance().barStyle
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.barStyle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            tfy_setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏前景色（item的文字图标颜色），默认黑色
    var tfy_tintColor: UIColor {
        get {
            if let tintColor = objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.tintColor) as? UIColor {
                return tintColor
            }
            if let tintColor = UINavigationBar.appearance().tintColor {
                return tintColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.tintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            tfy_setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    /// 导航栏标题文字颜色，默认黑色
    var tfy_titleColor: UIColor {
        get {
            if let titleColor = objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.titleColor) as? UIColor {
                return titleColor
            }
            if let titleColor = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor {
                return titleColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            tfy_setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏标题文字字体，默认17号粗体
    var tfy_titleFont: UIFont {
        get {
            if let titleFont = objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.titleFont) as? UIFont {
                return titleFont
            }
            if let titleFont = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.font] as? UIFont {
                return titleFont
            }
            return UIFont.boldSystemFont(ofSize: 17)
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.titleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            tfy_setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    /// 导航栏背景色，默认白色
    var tfy_backgroundColor: UIColor {
        get {
            if let backgroundColor = objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.backgroundColor) as? UIColor {
                return backgroundColor
            }
            if let backgroundColor = UINavigationBar.appearance().barTintColor {
                return backgroundColor
            }
            return .white
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            tfy_setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    /// 导航栏背景图片
    var tfy_backgroundImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.backgroundImage) as? UIImage ?? UINavigationBar.appearance().backgroundImage(for: .default)
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.backgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            tfy_setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    /// 导航栏背景透明度，默认1
    var tfy_barAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.barAlpha) as? CGFloat ?? 1
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.barAlpha, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            tfy_setNeedsNavigationBarBackgroundUpdate()
        }
    }

    /// 导航栏底部分割线是否隐藏，默认不隐藏
    var tfy_shadowHidden: Bool {
        get {
            return objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.shadowHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.shadowHidden, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            tfy_setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 导航栏底部分割线颜色
    var tfy_shadowColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.shadowColor) as? UIColor ?? UIColor(white: 0, alpha: 0.3)
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.shadowColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            tfy_setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 是否开启手势返回，默认开启
    var tfy_enablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &TFYSwiftNavigationBarKeys.enablePopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftNavigationBarKeys.enablePopGesture, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    // MARK: -  更新UI

    // 整体更新
    func tfy_setNeedsNavigationBarUpdate() {
        guard let naviController = navigationController as? TFYSwiftNavigationController else { return }
        naviController.tfy_updateNavigationBar(for: self)
    }
    
    // 更新文字、title颜色
    func tfy_setNeedsNavigationBarTintUpdate() {
        guard let naviController = navigationController as? TFYSwiftNavigationController else { return }
        naviController.tfy_updateNavigationBarTint(for: self)
    }

    // 更新背景
    func tfy_setNeedsNavigationBarBackgroundUpdate() {
        guard let naviController = navigationController as? TFYSwiftNavigationController else { return }
        naviController.tfy_updateNavigationBarBackground(for: self)
    }
    
    // 更新shadow
    func tfy_setNeedsNavigationBarShadowUpdate() {
        guard let naviController = navigationController as? TFYSwiftNavigationController else { return }
        naviController.tfy_updateNavigationBarShadow(for: self)
    }
    
}


