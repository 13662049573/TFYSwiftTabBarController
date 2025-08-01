//
//  HasText.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

// MARK: - 文本处理协议
/// 文本处理协议，支持 UILabel、UITextField、UITextView 等控件统一设置文本、颜色、对齐、行距等
public protocol HasText {
    /// 设置文本
    /// - Parameter text: 普通文本
    func set(text: String?)
    /// 设置富文本
    /// - Parameter attributedText: 富文本对象
    func set(attributedText: NSAttributedString?)
    /// 设置文本颜色
    /// - Parameter color: 颜色
    func set(color: UIColor)
    /// 设置文本对齐方式
    /// - Parameter alignment: 对齐方式
    func set(alignment: NSTextAlignment)
    /// 设置行数
    /// - Parameter numberOfLines: 行数
    func set(numberOfLines: Int)
    /// 设置行间距
    /// - Parameter lineSpacing: 行间距
    func set(lineSpacing: CGFloat)
    /// 设置字间距
    /// - Parameter kern: 字间距
    func set(kern: CGFloat)
    /// 设置占位符
    /// - Parameter placeholder: 占位符文本
    func set(placeholder: String?)
}

// MARK: - UILabel 扩展
extension UILabel: HasText {
    /// 设置 UILabel 的文本
    public func set(text: String?) { self.text = text }
    /// 设置 UILabel 的富文本
    public func set(attributedText: NSAttributedString?) { self.attributedText = attributedText }
    /// 设置 UILabel 的文本颜色
    public func set(color: UIColor) { self.textColor = color }
    /// 设置 UILabel 的文本对齐方式
    public func set(alignment: NSTextAlignment) { self.textAlignment = alignment }
    /// 设置 UILabel 的行数
    public func set(numberOfLines: Int) { self.numberOfLines = numberOfLines }
    /// 设置 UILabel 的行间距
    public func set(lineSpacing: CGFloat) {
        guard let text = self.text, !text.isEmpty else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributedString = NSAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle
        ])
        self.attributedText = attributedString
    }
    /// 设置 UILabel 的字间距
    public func set(kern: CGFloat) {
        guard let text = self.text, !text.isEmpty else { return }
        let attributedString = NSAttributedString(string: text, attributes: [
            .kern: kern
        ])
        self.attributedText = attributedString
    }
    /// UILabel 不支持占位符
    public func set(placeholder: String?) {}
}

// MARK: - UITextField 扩展
extension UITextField: HasText {
    /// 设置 UITextField 的文本
    public func set(text: String?) { self.text = text }
    /// 设置 UITextField 的富文本
    public func set(attributedText: NSAttributedString?) { self.attributedText = attributedText }
    /// 设置 UITextField 的文本颜色
    public func set(color: UIColor) { self.textColor = color }
    /// 设置 UITextField 的文本对齐方式
    public func set(alignment: NSTextAlignment) { self.textAlignment = alignment }
    /// UITextField 不支持多行
    public func set(numberOfLines: Int) {}
    /// 设置 UITextField 的行间距
    public func set(lineSpacing: CGFloat) {
        guard let text = self.text, !text.isEmpty else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributedString = NSAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle
        ])
        self.attributedText = attributedString
    }
    /// 设置 UITextField 的字间距
    public func set(kern: CGFloat) {
        guard let text = self.text, !text.isEmpty else { return }
        let attributedString = NSAttributedString(string: text, attributes: [
            .kern: kern
        ])
        self.attributedText = attributedString
    }
    /// 设置 UITextField 的占位符
    public func set(placeholder: String?) { self.placeholder = placeholder }
}

// MARK: - UITextView 扩展
extension UITextView: HasText {
    /// 设置 UITextView 的文本
    public func set(text: String?) { self.text = text }
    /// 设置 UITextView 的富文本
    public func set(attributedText: NSAttributedString?) { self.attributedText = attributedText }
    /// 设置 UITextView 的文本颜色
    public func set(color: UIColor) { self.textColor = color }
    /// 设置 UITextView 的文本对齐方式
    public func set(alignment: NSTextAlignment) { self.textAlignment = alignment }
    /// UITextView 默认支持多行
    public func set(numberOfLines: Int) {}
    /// 设置 UITextView 的行间距
    public func set(lineSpacing: CGFloat) {
        guard let text = self.text, !text.isEmpty else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributedString = NSAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle
        ])
        self.attributedText = attributedString
    }
    /// 设置 UITextView 的字间距
    public func set(kern: CGFloat) {
        guard let text = self.text, !text.isEmpty else { return }
        let attributedString = NSAttributedString(string: text, attributes: [
            .kern: kern
        ])
        self.attributedText = attributedString
    }
    /// UITextView 不直接支持占位符，如需支持需自定义实现
    public func set(placeholder: String?) {}
}

// MARK: - 链式文本设置扩展
public extension TFY where Base: HasText {
    /// 设置文本
    /// - Parameter text: 普通文本
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func text(_ text: String?) -> Self {
        base.set(text: text)
        return self
    }
    /// 设置富文本
    /// - Parameter attributedText: 富文本对象
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        base.set(attributedText: attributedText)
        return self
    }
    /// 设置文本颜色
    /// - Parameter textColor: 颜色
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        base.set(color: textColor)
        return self
    }
    /// 设置文本对齐方式
    /// - Parameter textAlignment: 对齐方式
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        base.set(alignment: textAlignment)
        return self
    }
    /// 设置行数
    /// - Parameter number: 行数
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func numberOfLines(_ number: Int) -> Self {
        base.set(numberOfLines: number)
        return self
    }
    /// 设置行间距
    /// - Parameter spacing: 行间距
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Self {
        base.set(lineSpacing: spacing)
        return self
    }
    /// 设置字间距
    /// - Parameter kern: 字间距
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func kern(_ kern: CGFloat) -> Self {
        base.set(kern: kern)
        return self
    }
    /// 设置占位符
    /// - Parameter text: 占位符文本
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func placeholder(_ text: String?) -> Self {
        base.set(placeholder: text)
        return self
    }
    /// 设置富文本属性
    /// - Parameter attributes: 富文本属性字典
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func attributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        if let text = (base as? UILabel)?.text ?? (base as? UITextField)?.text ?? (base as? UITextView)?.text {
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            base.set(attributedText: attributedString)
        }
        return self
    }
}

