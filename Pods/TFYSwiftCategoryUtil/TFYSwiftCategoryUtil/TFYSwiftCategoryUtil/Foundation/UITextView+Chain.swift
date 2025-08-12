//
//  UITextView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UITextView {
    /// 设置代理
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    /// 设置是否可编辑
    @discardableResult
    func isEditable(_ isEditable: Bool) -> Self {
        base.isEditable = isEditable
        return self
    }
    /// 设置是否可选择
    @discardableResult
    func isSelectable(_ isSelectable: Bool) -> Self {
        base.isSelectable = isSelectable
        return self
    }
    /// 设置文本容器内边距
    @discardableResult
    func textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        base.textContainerInset = textContainerInset
        return self
    }
    /// 设置数据检测器类型
    @discardableResult
    func dataDetectorTypes(_ dataDetectorTypes: UIDataDetectorTypes) -> Self {
        base.dataDetectorTypes = dataDetectorTypes
        return self
    }
    /// 设置是否允许编辑文本属性
    @discardableResult
    func allowsEditingTextAttributes(_ allowsEditingTextAttributes: Bool) -> Self {
        base.allowsEditingTextAttributes = allowsEditingTextAttributes
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
    /// 设置输入时的文本属性
    @discardableResult
    func typingAttributes(attributes b:[NSAttributedString.Key : Any]) -> Self {
        base.typingAttributes = b
        return self
    }
    /// 设置文本容器内边距（别名方法）
    @discardableResult
    func textContainerInset(containerInset c: UIEdgeInsets) -> Self {
        base.textContainerInset = c
        return self
    }
    /// 设置数据检测器类型（别名方法）
    @discardableResult
    func dataDetectorTypes(detectorTypes d: UIDataDetectorTypes) -> Self {
        base.dataDetectorTypes = d
        return self
    }
    /// 设置文本内边距
    @discardableResult
    func textPadding(insets d: UIEdgeInsets) -> Self {
        base.textPadding = d
        return self
    }
    /// 设置水平内边距
    @discardableResult
    func horizontalPadding(padding d: CGFloat) -> Self {
        base.horizontalPadding = max(0, d)
        return self
    }
    /// 设置垂直内边距
    @discardableResult
    func verticalPadding(padding d: CGFloat) -> Self {
        base.verticalPadding = max(0, d)
        return self
    }
}

private var textPaddingKey: UInt8 = 10

extension UITextView {
    /// 自定义文本内边距（兼容左右布局）
    var textPadding: UIEdgeInsets {
        get {
            objc_getAssociatedObject(self, &textPaddingKey) as? UIEdgeInsets ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &textPaddingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateTextPadding()
        }
    }
    
    private func updateTextPadding() {
        // 组合处理文本容器的边距
        textContainerInset = UIEdgeInsets(
            top: textPadding.top,
            left: textPadding.left - textContainer.lineFragmentPadding,
            bottom: textPadding.bottom,
            right: textPadding.right - textContainer.lineFragmentPadding
        )
        textContainer.lineFragmentPadding = 0
    }
    
    /// 快捷设置左右边距
    @IBInspectable var horizontalPadding: CGFloat {
        get { textPadding.left }
        set { 
            let newValue = max(0, newValue)
            textPadding = UIEdgeInsets(top: textPadding.top, left: newValue, bottom: textPadding.bottom, right: newValue) 
        }
    }
    
    /// 快捷设置上下边距
    @IBInspectable var verticalPadding: CGFloat {
        get { textPadding.top }
        set { 
            let newValue = max(0, newValue)
            textPadding = UIEdgeInsets(top: newValue, left: textPadding.left, bottom: newValue, right: textPadding.right) 
        }
    }
}
