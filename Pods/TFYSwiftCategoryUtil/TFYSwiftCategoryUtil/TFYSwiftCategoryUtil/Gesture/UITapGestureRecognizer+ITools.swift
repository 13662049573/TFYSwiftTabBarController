//
//  UITapGestureRecognizer+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit

// MARK: - 点击手势扩展
public extension TFY where Base == UITapGestureRecognizer {
    
    /// 设置手势识别器的委托
    /// - Parameter delegate: 委托对象
    /// - Returns: 链式调用对象
    @discardableResult
    func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    
    /// 设置手势识别器是否启用
    /// - Parameter enabled: 是否启用
    /// - Returns: 链式调用对象
    @discardableResult
    func enabled(_ enabled: Bool) -> Self {
        base.isEnabled = enabled
        return self
    }
    
    /// 设置是否取消视图中的触摸事件
    /// - Parameter cancels: 是否取消
    /// - Returns: 链式调用对象
    @discardableResult
    func cancelsTouchesInView(_ cancels: Bool) -> Self {
        base.cancelsTouchesInView = cancels
        return self
    }

    /// 设置是否延迟触摸事件开始
    /// - Parameter delayeBegan: 是否延迟
    /// - Returns: 链式调用对象
    @discardableResult
    func delaysTouchesBegan(_ delayeBegan: Bool) -> Self {
        base.delaysTouchesBegan = delayeBegan
        return self
    }
    
    /// 设置是否延迟触摸事件结束
    /// - Parameter delayeEnded: 是否延迟
    /// - Returns: 链式调用对象
    @discardableResult
    func delaysTouchesEnded(_ delayeEnded: Bool) -> Self {
        base.delaysTouchesEnded = delayeEnded
        return self
    }

    /// 设置允许的触摸类型
    /// - Parameter types: 触摸类型数组
    /// - Returns: 链式调用对象
    @discardableResult
    func allowedTouchTypes(_ types: [NSNumber]) -> Self {
        guard !types.isEmpty else { return self }
        base.allowedTouchTypes = types
        return self
    }
    
    /// 设置允许的按压类型
    /// - Parameter types: 按压类型数组
    /// - Returns: 链式调用对象
    @discardableResult
    func allowedPressTypes(_ types: [NSNumber]) -> Self {
        guard !types.isEmpty else { return self }
        base.allowedPressTypes = types
        return self
    }

    /// 设置是否需要独占触摸类型
    /// - Parameter requirs: 是否需要
    /// - Returns: 链式调用对象
    @discardableResult
    func requiresExclusiveTouchType(_ requirs: Bool) -> Self {
        base.requiresExclusiveTouchType = requirs
        return self
    }

    /// 设置调试名称
    /// - Parameter name: 名称
    /// - Returns: 链式调用对象
    @discardableResult
    func name(_ name: String?) -> Self {
        base.name = name
        return self
    }

    /// 设置需要失败的手势识别器
    /// - Parameter fail: 手势识别器
    /// - Returns: 链式调用对象
    @discardableResult
    func require(_ fail: UIGestureRecognizer) -> Self {
        base.require(toFail: fail)
        return self
    }
    
    /// 添加目标动作
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 动作方法
    /// - Returns: 链式调用对象
    @discardableResult
    func addTarget(_ target: Any, action: Selector) -> Self {
        guard let _ = target as? NSObjectProtocol else { return self }
        base.addTarget(target, action: action)
        return self
    }

    /// 移除目标动作
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 动作方法
    /// - Returns: 链式调用对象
    @discardableResult
    func removeTarget(_ target: Any?, action: Selector?) -> Self {
        base.removeTarget(target, action: action)
        return self
    }
    
    /// 设置需要的点击次数
    /// - Parameter number: 点击次数
    /// - Returns: 链式调用对象
    @discardableResult
    func numberOfTapsRequired(_ number: Int) -> Self {
        base.numberOfTapsRequired = max(1, number)
        return self
    }
    
    /// 设置需要的触摸手指数
    /// - Parameter number: 手指数
    /// - Returns: 链式调用对象
    @discardableResult
    func numberOfTouchesRequired(_ number: Int) -> Self {
        base.numberOfTouchesRequired = max(1, number)
        return self
    }

    /// 设置需要的按钮掩码(iOS 13.4+)
    /// - Parameter mask: 按钮掩码
    /// - Returns: 链式调用对象
    @available(iOS 13.4, *)
    @discardableResult
    func buttonMaskRequired(_ mask: UIEvent.ButtonMask) -> Self {
        base.buttonMaskRequired = mask
        return self
    }
}

// MARK: - 关联键定义
private struct GestureRecognizerAssociatedKeys {
    static var functionName = UnsafeRawPointer(bitPattern: "functionName".hashValue)!
    static var closure = UnsafeRawPointer(bitPattern: "closure".hashValue)!
    static var clickGestureClosure = UnsafeRawPointer(bitPattern: "UITapGestureRecognizer+closure".hashValue)!
}

// MARK: - UIGestureRecognizer扩展
@objc public extension UIGestureRecognizer {
    
    /// 方法名称(用于自定义)
    var funcName: String {
        get {
            if let name = objc_getAssociatedObject(self, GestureRecognizerAssociatedKeys.functionName) as? String {
                return name
            }
            let name = String(describing: self.classForCoder)
            objc_setAssociatedObject(self, GestureRecognizerAssociatedKeys.functionName, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
        set {
            objc_setAssociatedObject(self, GestureRecognizerAssociatedKeys.functionName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 添加闭包回调
    /// - Parameter closure: 回调闭包
    func addAction(_ closure: @escaping (UIGestureRecognizer) -> Void) {
        objc_setAssociatedObject(self, GestureRecognizerAssociatedKeys.closure, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(p_invoke))
    }
    
    /// 私有调用方法
    @objc private func p_invoke() {
        if let closure = objc_getAssociatedObject(self, GestureRecognizerAssociatedKeys.closure) as? (UIGestureRecognizer) -> Void {
            closure(self)
        }
    }
}

// MARK: - UITapGestureRecognizer扩展
@objc public extension UITapGestureRecognizer {
    
    /// 添加点击手势闭包回调
    /// - Parameter closure: 回调闭包
    override func addAction(_ closure: @escaping (UITapGestureRecognizer) -> Void) {
        objc_setAssociatedObject(self, GestureRecognizerAssociatedKeys.clickGestureClosure, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(p_invokeTap))
    }
    
    /// 私有调用方法
    @objc private func p_invokeTap() {
        if let closure = objc_getAssociatedObject(self, GestureRecognizerAssociatedKeys.clickGestureClosure) as? (UITapGestureRecognizer) -> Void {
            closure(self)
        }
    }
    
    /// UILabel富文本点击处理(带高亮效果)
    /// - Parameters:
    ///   - linkDic: 链接字典[显示文本: 链接]
    ///   - highlightColor: 高亮颜色(默认浅蓝色)
    ///   - action: 点击回调
    func didTapLabelAttributedText(
        _ linkDic: [String: String],
        highlightColor: UIColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3),
        action: @escaping (String, String?) -> Void
    ) {
        // 确保是UILabel
        guard let label = self.view as? UILabel,
              let attributedText = label.attributedText else {
            assertionFailure("Only supports UILabel")
            return
        }
        
        // 创建文本布局管理器
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        // 配置布局
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 配置文本容器
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        // 计算点击位置
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (label.bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
            y: (label.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY
        )
        
        let locationInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        
        // 获取点击的字符索引
        let indexOfCharacter = layoutManager.characterIndex(
            for: locationInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        // 遍历链接字典检查点击
        linkDic.forEach { text, link in
            let range = (attributedText.string as NSString).range(of: text)
            if NSLocationInRange(indexOfCharacter, range) {
                // 创建带高亮效果的富文本
                let highlightedText = NSMutableAttributedString(attributedString: attributedText)
                
                // 添加背景色属性
                highlightedText.addAttribute(
                    .backgroundColor,
                    value: highlightColor,
                    range: range
                )
                
                // 更新label文本
                label.attributedText = highlightedText
                
                // 延迟恢复原始文本
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    label.attributedText = attributedText
                }
                
                // 触发回调
                action(text, link)
            }
        }
    }
    
    /// UILabel富文本点击处理(带自定义高亮样式)
    /// - Parameters:
    ///   - linkDic: 链接字典[显示文本: 链接]
    ///   - highlightAttributes: 高亮时的富文本属性
    ///   - action: 点击回调
    func didTapLabelAttributedText(
        _ linkDic: [String: String],
        highlightAttributes: [NSAttributedString.Key: Any],
        action: @escaping (String, String?) -> Void
    ) {
        // 确保是UILabel
        guard let label = self.view as? UILabel,
              let attributedText = label.attributedText else {
            assertionFailure("Only supports UILabel")
            return
        }
        
        // 创建文本布局管理器
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        // 配置布局
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 配置文本容器
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        // 计算点击位置
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (label.bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
            y: (label.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY
        )
        
        let locationInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        
        // 获取点击的字符索引
        let indexOfCharacter = layoutManager.characterIndex(
            for: locationInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        // 遍历链接字典检查点击
        linkDic.forEach { text, link in
            let range = (attributedText.string as NSString).range(of: text)
            if NSLocationInRange(indexOfCharacter, range) {
                // 创建带高亮效果的富文本
                let highlightedText = NSMutableAttributedString(attributedString: attributedText)
                
                // 添加自定义高亮属性
                highlightedText.addAttributes(
                    highlightAttributes,
                    range: range
                )
                
                // 更新label文本
                label.attributedText = highlightedText
                
                // 延迟恢复原始文本
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    label.attributedText = attributedText
                }
                
                // 触发回调
                action(text, link)
            }
        }
    }
}
