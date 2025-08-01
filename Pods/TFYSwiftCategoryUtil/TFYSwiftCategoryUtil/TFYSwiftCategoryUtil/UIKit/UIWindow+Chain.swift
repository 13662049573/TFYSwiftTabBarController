//
//  UIWindow+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation
import UIKit

public extension UIWindow {
    static var keyWindow: UIWindow? {
        var keyWindow:UIWindow?
        keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        return keyWindow
    }

    static var statusBarFrame: CGRect {
        return keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    }

    static var statusBarHeight: CGFloat {
        return statusBarFrame.size.height
    }

    static var safeAreaInsets: UIEdgeInsets {
        return keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
    }
}

public extension UIScreen {
    static var width: CGFloat {
        let size:CGSize = UIScreen.main.bounds.size
        return size.height < size.width ? size.height : size.width
    }

    static var height: CGFloat {
        let size:CGSize = UIScreen.main.bounds.size
        return size.height > size.width ? size.height : size.width
    }
    
    static var kscale:CGFloat {
        return UIScreen.main.scale
    }
}

public extension UIDevice {
    static var isIphoneX: Bool {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return true
        }
        if #available(iOS 11.0, *) {
            let bottom = UIWindow.safeAreaInsets.bottom
            if bottom > 0.0 {
                return true
            }
        }
        return false
    }
    
    static var bottomHeight: CGFloat {
        let bottomH:CGFloat = UIDevice.isIphoneX ? 83 : 49
        return bottomH
    }
    
    static var navBarHeight: CGFloat {
        let navH:CGFloat = UIDevice.isIphoneX ? 88 : 64
        return navH
    }
}

// MARK: - UIWindow扩展
public extension UIWindow {
    
    /// 获取当前窗口
    /// - Returns: 当前窗口
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }?
                .windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 获取所有窗口
    /// - Returns: 所有窗口数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var allWindows: [UIWindow] {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        } else {
            return UIApplication.shared.windows
        }
    }
    
    /// 获取可见窗口
    /// - Returns: 可见窗口数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var visibleWindows: [UIWindow] {
        return allWindows.filter { !$0.isHidden && $0.alpha > 0 }
    }
    
    /// 获取窗口的可见区域
    /// - Returns: 可见区域
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var visibleFrame: CGRect {
        return bounds.inset(by: safeAreaInsets)
    }
    
    /// 检查窗口是否可见
    /// - Returns: 如果窗口可见返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isVisible: Bool {
        return !isHidden && alpha > 0 && windowLevel == .normal
    }
    
    /// 设置窗口的层级深度
    /// - Parameter level: 层级深度
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func setWindowLevel(_ level: UIWindow.Level) {
        // windowLevel是只读属性，需要通过其他方式设置
        // 这里提供一个替代方案：通过修改窗口的zPosition来实现类似效果
        self.layer.zPosition = CGFloat(level.rawValue)
    }
    
    /// 显示窗口
    /// - Parameter animated: 是否动画
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func show(animated: Bool = true) {
        if animated {
            alpha = 0
            isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        } else {
            isHidden = false
            alpha = 1
        }
    }
    
    /// 隐藏窗口
    /// - Parameter animated: 是否动画
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func hide(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.isHidden = true
            }
        } else {
            isHidden = true
            alpha = 0
        }
    }
    
    /// 添加子窗口
    /// - Parameter window: 子窗口
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func addSubwindow(_ window: UIWindow) {
        addSubview(window)
        window.frame = bounds
        window.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /// 移除子窗口
    /// - Parameter window: 子窗口
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func removeSubwindow(_ window: UIWindow) {
        window.removeFromSuperview()
    }
    
    /// 获取所有子窗口
    /// - Returns: 子窗口数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var subwindows: [UIWindow] {
        return subviews.compactMap { $0 as? UIWindow }
    }
    
    /// 设置窗口的背景色
    /// - Parameter color: 背景颜色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    /// 设置窗口的圆角
    /// - Parameter radius: 圆角半径
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// 设置窗口的阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - radius: 阴影半径
    ///   - opacity: 阴影透明度
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func setShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    
    /// 获取窗口的变换
    /// - Returns: 变换矩阵
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var windowTransform: CGAffineTransform {
        return self.layer.affineTransform()
    }
    
    /// 设置窗口的变换
    /// - Parameter transform: 变换矩阵
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func setTransform(_ transform: CGAffineTransform) {
        // transform是只读属性，需要通过layer的transform来设置
        self.layer.setAffineTransform(transform)
    }
    
    /// 应用变换动画
    /// - Parameters:
    ///   - transform: 目标变换
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func animateTransform(_ transform: CGAffineTransform, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.layer.setAffineTransform(transform)
        }, completion: { _ in
            completion?()
        })
    }
    
    /// 设置窗口的根视图控制器
    /// - Parameters:
    ///   - viewController: 根视图控制器
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.rootViewController = viewController
            }, completion: { _ in
                completion?()
            })
        } else {
            self.rootViewController = viewController
            completion?()
        }
    }
    
    /// 获取窗口的截图
    /// - Returns: 截图图片
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

