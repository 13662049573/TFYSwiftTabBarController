//
//  UIActivityIndicatorView+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit

public extension TFY where Base: UIActivityIndicatorView {
    
    // MARK: 1.1、设置活动指示器样式
    /// 设置活动指示器样式
    /// - Parameter activityIndicatorViewStyle: 活动指示器样式
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func activityIndicatorViewStyle(_ activityIndicatorViewStyle: UIActivityIndicatorView.Style) -> Self {
        #if swift(>=4.2)
        base.style = activityIndicatorViewStyle
        #else
        base.activityIndicatorViewStyle = activityIndicatorViewStyle
        #endif
        return self
    }
    
    // MARK: 1.2、设置停止时是否隐藏
    /// 设置停止时是否隐藏
    /// - Parameter hidesWhenStopped: 停止时是否隐藏
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func hidesWhenStopped(_ hidesWhenStopped: Bool) -> Self {
        base.hidesWhenStopped = hidesWhenStopped
        return self
    }
    
    // MARK: 1.3、设置颜色
    /// 设置颜色
    /// - Parameter color: 颜色
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func color(_ color: UIColor?) -> Self {
        base.color = color
        return self
    }
    
    // MARK: 1.4、开始动画
    /// 开始动画
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func startAnimating() -> Self {
        base.startAnimating()
        return self
    }
    
    // MARK: 1.5、停止动画
    /// 停止动画
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func stopAnimating() -> Self {
        base.stopAnimating()
        return self
    }
    
    // MARK: 1.6、设置大小
    /// 设置大小
    /// - Parameter size: 大小
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func size(_ size: CGSize) -> Self {
        base.frame.size = size
        return self
    }
    
    // MARK: 1.7、设置中心点
    /// 设置中心点
    /// - Parameter center: 中心点
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func center(_ center: CGPoint) -> Self {
        base.center = center
        return self
    }
    
    // MARK: 1.8、设置背景色
    /// 设置背景色
    /// - Parameter backgroundColor: 背景色
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        base.backgroundColor = backgroundColor
        return self
    }
    
    // MARK: 1.9、设置透明度
    /// 设置透明度
    /// - Parameter alpha: 透明度
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
    
    // MARK: 1.10、设置是否隐藏
    /// 设置是否隐藏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        base.isHidden = isHidden
        return self
    }
}

// MARK: - 二、UIActivityIndicatorView的便利方法
public extension UIActivityIndicatorView {
    
    // MARK: 2.1、创建标准活动指示器
    /// 创建标准活动指示器
    /// - Parameter style: 样式
    /// - Returns: 活动指示器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func standard(style: UIActivityIndicatorView.Style = .medium) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.hidesWhenStopped = true
        return indicator
    }
    
    // MARK: 2.2、创建大型活动指示器
    /// 创建大型活动指示器
    /// - Returns: 活动指示器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func large() -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }
    
    // MARK: 2.3、创建中型活动指示器
    /// 创建中型活动指示器
    /// - Returns: 活动指示器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func medium() -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .medium)
    }
    
    // MARK: 2.5、显示活动指示器
    /// 显示活动指示器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func show() {
        self.isHidden = false
        self.startAnimating()
    }
    
    // MARK: 2.6、隐藏活动指示器
    /// 隐藏活动指示器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func hide() {
        self.stopAnimating()
        if self.hidesWhenStopped {
            self.isHidden = true
        }
    }
    
    // MARK: 2.7、设置活动指示器到视图中心
    /// 设置活动指示器到视图中心
    /// - Parameter view: 父视图
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func centerInView(_ view: UIView) {
        self.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    // MARK: 2.8、创建带背景的活动指示器
    /// 创建带背景的活动指示器
    /// - Parameters:
    ///   - style: 样式
    ///   - backgroundColor: 背景色
    /// - Returns: 活动指示器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func withBackground(style: UIActivityIndicatorView.Style = .medium, backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5)) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.backgroundColor = backgroundColor
        indicator.layer.cornerRadius = 8
        indicator.hidesWhenStopped = true
        return indicator
    }
    
    // MARK: 2.9、创建自定义大小的活动指示器
    /// 创建自定义大小的活动指示器
    /// - Parameters:
    ///   - size: 大小
    ///   - color: 颜色
    /// - Returns: 活动指示器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func custom(size: CGSize, color: UIColor = .systemBlue) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.frame.size = size
        indicator.color = color
        indicator.hidesWhenStopped = true
        return indicator
    }
    
    // MARK: 2.10、添加活动指示器到视图
    /// 添加活动指示器到视图
    /// - Parameter view: 父视图
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func addToView(_ view: UIView) {
        view.addSubview(self)
        self.centerInView(view)
    }
    
    // MARK: 2.4、检查是否正在动画
    /// 检查是否正在动画
    /// - Returns: 是否正在动画
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isCurrentlyAnimating: Bool {
        return self.isAnimating
    }
}
