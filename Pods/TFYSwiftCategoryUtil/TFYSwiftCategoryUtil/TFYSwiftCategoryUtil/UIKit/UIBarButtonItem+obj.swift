//
//  UIBarButtonItem+obj.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2024/10/27.
//

import Foundation
import UIKit

@objc public extension UIBarButtonItem {
    
    // MARK: - 关联对象键
    private struct AssociatedItemKeys {
        static var systemType: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "UIBarButtonItem+systemType".hashValue)!
        static var closure: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "UIBarButtonItem+closure".hashValue)!
    }
    
    // MARK: 1.1、系统类型
    /// 系统类型
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var systemType: UIBarButtonItem.SystemItem {
        get {
            if let obj = objc_getAssociatedObject(self, AssociatedItemKeys.systemType) as? UIBarButtonItem.SystemItem {
                return obj
            }
            return .done
        }
        set {
            objc_setAssociatedObject(self,AssociatedItemKeys.systemType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: 1.2、添加回调
    /// UIBarButtonItem 回调
    /// - Parameter closure: 回调闭包
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func addAction(_ closure: @escaping ((UIBarButtonItem) -> Void)) {
        objc_setAssociatedObject(self,AssociatedItemKeys.closure, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        target = self
        action = #selector(p_invoke)
    }

    // MARK: 1.3、私有调用方法
    /// 私有调用方法
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    private func p_invoke() {
        if let closure = objc_getAssociatedObject(self,AssociatedItemKeys.closure) as? ((UIBarButtonItem) -> Void) {
            closure(self)
        }
    }
    
    // MARK: 1.4、便利初始化方法
    /// 便利初始化方法
    /// - Parameters:
    ///   - obj: 对象名称（图片名或标题）
    ///   - style: 样式，默认plain
    ///   - tag: 标签，默认0
    ///   - target: 目标对象
    ///   - action: 选择器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    convenience init(obj: String, style: UIBarButtonItem.Style = .plain, tag: Int = 0, target: Any? = nil, action: Selector? = nil) {
        if let image = UIImage(named: obj) {
            self.init(image: image, style: style, target: target, action: action)
        } else {
            self.init(title: obj, style: style, target: target, action: action)
        }
        self.tag = tag
    }
    
    // MARK: 1.5、带回调的便利初始化方法
    /// 带回调的便利初始化方法
    /// - Parameters:
    ///   - obj: 对象名称（图片名或标题）
    ///   - style: 样式，默认plain
    ///   - tag: 标签，默认0
    ///   - action: 回调闭包
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    convenience init(obj: String, style: UIBarButtonItem.Style = .plain, tag: Int = 0, action: @escaping ((UIBarButtonItem) -> Void)) {
        self.init(obj: obj, style: style, tag: tag, target: nil, action: nil)
        self.addAction(action)
    }
    
    // MARK: 1.6、系统项便利初始化方法
    /// 系统项便利初始化方法
    /// - Parameters:
    ///   - systemItem: 系统项类型
    ///   - tag: 标签，默认0
    ///   - action: 回调闭包
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    convenience init(systemItem: UIBarButtonItem.SystemItem, tag: Int = 0, action: @escaping ((UIBarButtonItem) -> Void)) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        self.tag = tag
        self.systemType = systemItem
        self.addAction(action)
    }
    
    // MARK: 1.7、添加目标和动作
    /// 添加目标和动作
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 选择器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func addTargetForAction(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
    // MARK: 1.8、设置标题颜色
    /// 设置标题颜色
    /// - Parameters:
    ///   - textColor: 文字颜色
    ///   - state: 状态
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setTitleColor(_ textColor: UIColor, for state: UIControl.State) -> Self {
        guard var attributes = titleTextAttributes(for: state) else {
            setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: state)
            return self }
        attributes[.foregroundColor] = textColor
        setTitleTextAttributes(attributes, for: state)
        return self
    }
    
    // MARK: 1.9、设置标题字体
    /// 设置标题字体
    /// - Parameters:
    ///   - font: 字体
    ///   - state: 状态
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setTitleFont(_ font: UIFont, for state: UIControl.State) -> Self {
        guard var attributes = titleTextAttributes(for: state) else {
            setTitleTextAttributes([NSAttributedString.Key.font: font], for: state)
            return self }
        attributes[.font] = font
        setTitleTextAttributes(attributes, for: state)
        return self
    }

    // MARK: 1.10、创建固定间距
    /// 创建固定间距的UIBarButtonItem
    /// - Parameters:
    ///   - width: 宽度
    ///   - target: 目标对象
    ///   - action: 选择器
    /// - Returns: UIBarButtonItem实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func fixedSpace(width: CGFloat, target: Any? = nil, action: Selector? = nil) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: target, action: action)
        barButtonItem.width = width
        return barButtonItem
    }
    
    // MARK: 1.11、创建弹性间距
    /// 创建弹性间距的UIBarButtonItem
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 选择器
    /// - Returns: UIBarButtonItem实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func flexibleSpace(_ target: Any? = nil, action: Selector? = nil) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target, action: action)
    }
}

// MARK: - 二、间距相关扩展
public extension UIBarButtonItem{
    
    // MARK: 2.1、创建间距
    /// 创建间距
    /// - Parameters:
    ///   - width: 宽度，nil表示弹性间距
    ///   - target: 目标对象
    ///   - action: 选择器
    /// - Returns: UIBarButtonItem实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func space(_ width: CGFloat? = nil, target: Any? = nil, action: Selector? = nil) -> UIBarButtonItem {
        if let width = width {
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            barButtonItem.width = width
            return barButtonItem
        }
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    // MARK: 2.2、创建图片按钮
    /// 创建图片按钮
    /// - Parameters:
    ///   - image: 图片
    ///   - style: 样式，默认plain
    ///   - action: 回调闭包
    /// - Returns: UIBarButtonItem实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func imageButton(image: UIImage?, style: UIBarButtonItem.Style = .plain, action: @escaping ((UIBarButtonItem) -> Void)) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: style, target: nil, action: nil)
        button.addAction(action)
        return button
    }
    
    // MARK: 2.3、创建标题按钮
    /// 创建标题按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式，默认plain
    ///   - action: 回调闭包
    /// - Returns: UIBarButtonItem实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func titleButton(title: String, style: UIBarButtonItem.Style = .plain, action: @escaping ((UIBarButtonItem) -> Void)) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title, style: style, target: nil, action: nil)
        button.addAction(action)
        return button
    }
    
    // MARK: 2.4、创建自定义视图按钮
    /// 创建自定义视图按钮
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - action: 回调闭包
    /// - Returns: UIBarButtonItem实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func customButton(customView: UIView, action: @escaping ((UIBarButtonItem) -> Void)) -> UIBarButtonItem {
        let button = UIBarButtonItem(customView: customView)
        button.addAction(action)
        return button
    }
    
    // MARK: 2.5、设置按钮是否可用
    /// 设置按钮是否可用
    /// - Parameter enabled: 是否可用
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setEnabled(_ enabled: Bool) -> Self {
        self.isEnabled = enabled
        return self
    }
    
    // MARK: 2.6、设置按钮宽度
    /// 设置按钮宽度
    /// - Parameter width: 宽度
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setWidth(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }
    
    // MARK: 2.7、设置按钮标签
    /// 设置按钮标签
    /// - Parameter tag: 标签
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setTag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    // MARK: 2.8、设置按钮样式
    /// 设置按钮样式
    /// - Parameter style: 样式
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setStyle(_ style: UIBarButtonItem.Style) -> Self {
        self.style = style
        return self
    }
}
