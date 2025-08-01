//
//  UITextField+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit
import ObjectiveC

public extension TFY where Base: UITextField {
    /// 设置代理
    @discardableResult
    func delegate(_ delegate: UITextFieldDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    /// 设置占位符文本
    @discardableResult
    func placeholder(_ placeholder: String?) -> Self {
        base.placeholder = placeholder
        return self
    }
    /// 设置富文本占位符
    @discardableResult
    func attributedPlaceholder(_ attributedPlaceholder: NSAttributedString?) -> Self {
        base.attributedPlaceholder = attributedPlaceholder
        return self
    }
    /// 设置边框样式
    @discardableResult
    func borderStyle(_ borderStyle: UITextField.BorderStyle) -> Self {
        base.borderStyle = borderStyle
        return self
    }
    /// 设置默认文本属性
    @discardableResult
    func defaultTextAttributes(_ defaultTextAttributes: [String: Any]) -> Self {
        #if swift(>=4.2)
        base.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(defaultTextAttributes)
        #else
        base.defaultTextAttributes = defaultTextAttributes
        #endif
        return self
    }
    /// 设置开始编辑时是否清空文本
    @discardableResult
    func clearsOnBeginEditing(_ clearsOnBeginEditing: Bool) -> Self {
        base.clearsOnBeginEditing = clearsOnBeginEditing
        return self
    }
    /// 设置是否自动调整字体大小以适应宽度
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    /// 设置最小字体大小
    @discardableResult
    func minimumFontSize(_ minimumFontSize: CGFloat) -> Self {
        base.minimumFontSize = max(0, minimumFontSize)
        return self
    }
    /// 设置是否允许编辑文本属性
    @discardableResult
    func allowsEditingTextAttributes(_ allowsEditingTextAttributes: Bool) -> Self {
        base.allowsEditingTextAttributes = allowsEditingTextAttributes
        return self
    }
    /// 设置输入时的文本属性
    @discardableResult
    func typingAttributes(_ typingAttributes: [String: Any]?) -> Self {
        #if swift(>=4.2)
        base.typingAttributes = convertToOptionalNSAttributedStringKeyDictionary(typingAttributes)
        #else
        base.typingAttributes = typingAttributes
        #endif
        return self
    }
    /// 设置清除按钮模式
    @discardableResult
    func clearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> Self {
        base.clearButtonMode = clearButtonMode
        return self
    }
    /// 设置左侧视图
    @discardableResult
    func leftView(_ leftView: UIView?) -> Self {
        base.leftView = leftView
        return self
    }
    /// 设置左侧视图模式
    @discardableResult
    func leftViewMode(_ leftViewMode: UITextField.ViewMode) -> Self {
        base.leftViewMode = leftViewMode
        return self
    }
    /// 设置右侧视图
    @discardableResult
    func rightView(_ rightView: UIView?) -> Self {
        base.rightView = rightView
        return self
    }
    /// 设置右侧视图模式
    @discardableResult
    func rightViewMode(_ rightViewMode: UITextField.ViewMode) -> Self {
        base.rightViewMode = rightViewMode
        return self
    }
    /// 设置键盘类型
    @discardableResult
    func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        base.keyboardType = keyboardType
        return self
    }
    /// 设置返回键类型
    @discardableResult
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        base.returnKeyType = returnKeyType
        return self
    }
    /// 设置是否安全文本输入
    @discardableResult
    func isSecureTextEntry(_ isSecureTextEntry: Bool) -> Self {
        base.isSecureTextEntry = isSecureTextEntry
        return self
    }
    /// 设置文本内容类型（iOS 10.0+）
    @discardableResult
    func textContentType(_ textContentType: UITextContentType) -> Self {
        if #available(iOS 10.0, *) {
            base.textContentType = textContentType
        }
        return self
    }
    /// 设置占位符颜色
    @discardableResult
    func placeHolderColor(_ placeHolderColor: UIColor) -> Self {
        base.placeHolderColor = placeHolderColor
        return self
    }
    /// 设置文本内边距
    @discardableResult
    func textPadding(_ insets: UIEdgeInsets) -> Self {
        base.textPadding = insets
        return self
    }
}

extension UITextField {
    /// 占位符颜色（IBInspectable）
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            guard let newValue = newValue else { return }
            self.attributedPlaceholder = NSAttributedString(
                string: self.placeholder ?? "", 
                attributes: [NSAttributedString.Key.foregroundColor: newValue]
            )
        }
    }
}

private var textPaddingKey: UInt8 = 8

extension UITextField {
    /// 添加内边距支持
    var textPadding: UIEdgeInsets {
        get {
            objc_getAssociatedObject(self, &textPaddingKey) as? UIEdgeInsets ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &textPaddingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            swizzleMethodsIfNeeded()
        }
    }
    
    private static var swizzled = false
    private func swizzleMethodsIfNeeded() {
        guard !Self.swizzled else { return }
        
        let originalSelectors = [
            #selector(textRect(forBounds:)),
            #selector(editingRect(forBounds:)),
            #selector(placeholderRect(forBounds:))
        ]
        
        let swizzledSelectors = [
            #selector(swizzled_textRect(forBounds:)),
            #selector(swizzled_editingRect(forBounds:)),
            #selector(swizzled_placeholderRect(forBounds:))
        ]
        
        for (original, swizzled) in zip(originalSelectors, swizzledSelectors) {
            guard let originalMethod = class_getInstanceMethod(Self.self, original),
                  let swizzledMethod = class_getInstanceMethod(Self.self, swizzled) else { continue }
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        Self.swizzled = true
    }
    
    @objc private func swizzled_textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    @objc private func swizzled_editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    @objc private func swizzled_placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any])
    -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in
        (NSAttributedString.Key(rawValue: key), value)
    })
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in
        (NSAttributedString.Key(rawValue: key), value)
    })
}
