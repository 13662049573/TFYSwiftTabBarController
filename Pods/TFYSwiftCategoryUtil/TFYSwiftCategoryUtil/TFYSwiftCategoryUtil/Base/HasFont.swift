//
//  HasFont.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

/// 字体设置协议，支持 UILabel、UIButton、UITextField、UITextView 等控件统一设置字体
public protocol HasFont {
    /// 设置字体
    /// - Parameter font: 字体对象
    func set(font: UIFont)
}

// MARK: - UIKit 控件对 HasFont 协议的实现

extension UILabel: HasFont {
    /// 设置 UILabel 的字体
    public func set(font: UIFont) {
        self.font = font
    }
}

extension UIButton: HasFont {
    /// 设置 UIButton 的字体（作用于 titleLabel）
    public func set(font: UIFont) {
        self.titleLabel?.font = font
    }
}

extension UITextField: HasFont {
    /// 设置 UITextField 的字体
    public func set(font: UIFont) {
        self.font = font
    }
}

extension UITextView: HasFont {
    /// 设置 UITextView 的字体
    public func set(font: UIFont) {
        self.font = font
    }
}

// MARK: - 链式字体设置扩展
public extension TFY where Base: HasFont {
    /// 设置字体特征（SymbolicTraits）
    /// - Parameter traits: 字体特征
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func fontDescriptor(symblicTraits traits: UIFontDescriptor.SymbolicTraits) -> Self {
        if let currentFont = (base as? UILabel)?.font ?? (base as? UITextField)?.font ?? (base as? UITextView)?.font,
           let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
            let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
            base.set(font: newFont)
        }
        return self
    }
    
    /// 设置字体样式（TextStyle）
    /// - Parameters:
    ///   - style: 字体样式
    ///   - traits: 可选字体特征
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func fontStyle(_ style: UIFont.TextStyle, traits: UIFontDescriptor.SymbolicTraits? = nil) -> Self {
        let font = UIFont.preferredFont(forTextStyle: style)
        if let traits = traits,
           let descriptor = font.fontDescriptor.withSymbolicTraits(traits) {
            let newFont = UIFont(descriptor: descriptor, size: font.pointSize)
            base.set(font: newFont)
        } else {
            base.set(font: font)
        }
        return self
    }
    
    /// 设置动态字体（支持无障碍字体缩放）
    /// - Parameters:
    ///   - style: 字体样式
    ///   - maxSize: 最大字号（可选）
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func dynamicFont(style: UIFont.TextStyle, maxSize: CGFloat? = nil) -> Self {
        let metrics = UIFontMetrics(forTextStyle: style)
        let baseFont = UIFont.preferredFont(forTextStyle: style)
        if let maxSize = maxSize {
            let scaledFont = metrics.scaledFont(for: baseFont, maximumPointSize: maxSize)
            base.set(font: scaledFont)
        } else {
            let scaledFont = metrics.scaledFont(for: baseFont)
            base.set(font: scaledFont)
        }
        return self
    }
    
    /// 设置自定义字体
    /// - Parameter font: 字体对象
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.set(font: font)
        return self
    }
    
    /// 设置系统字体
    /// - Parameter fontSize: 字号
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func systemFont(ofSize fontSize: CGFloat) -> Self {
        base.set(font: .systemFont(ofSize: fontSize))
        return self
    }
    
    /// 设置粗体系统字体
    /// - Parameter fontSize: 字号
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func boldSystemFont(ofSize fontSize: CGFloat) -> Self {
        base.set(font: .boldSystemFont(ofSize: fontSize))
        return self
    }
    
    /// 设置带权重的系统字体
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - weight: 字重
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func systemFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> Self {
        base.set(font: .systemFont(ofSize: fontSize, weight: weight))
        return self
    }
    
    /// 设置斜体系统字体
    /// - Parameter fontSize: 字号
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func italicSystemFont(ofSize fontSize: CGFloat) -> Self {
        if let font = UIFont(name: ".SFUI-RegularItalic", size: fontSize) {
            base.set(font: font)
        }
        return self
    }
    
    /// 设置自定义字体（通过名称）
    /// - Parameters:
    ///   - name: 字体名称
    ///   - size: 字号
    /// - Returns: 支持链式调用的 TFY 包装
    @discardableResult
    func customFont(name: String, size: CGFloat) -> Self {
        if let font = UIFont(name: name, size: size) {
            base.set(font: font)
        }
        return self
    }
}
