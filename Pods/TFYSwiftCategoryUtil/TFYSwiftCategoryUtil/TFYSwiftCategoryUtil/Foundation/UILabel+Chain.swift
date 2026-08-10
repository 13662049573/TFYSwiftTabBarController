//
//  UILabel+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升、性能优化、代码复用
//

import UIKit

// MARK: - Supporting Types

/// 属性构建器，用于高效构建文本属性
private struct AttributeBuilder {
    private var attributes: [NSAttributedString.Key: Any] = [:]
    
    mutating func add(_ key: NSAttributedString.Key, value: Any) {
        attributes[key] = value
    }
    
    func build() -> [NSAttributedString.Key: Any] {
        return attributes
    }
}

/// 文本搜索策略
private enum TextSearchStrategy {
    case exact
    case caseInsensitive
    case reverse
}

/// 文本样式预设
public enum TextStyle {
    case title(font: UIFont, color: UIColor)
    case subtitle(font: UIFont, color: UIColor)
    case body(font: UIFont, color: UIColor)
    case caption(font: UIFont, color: UIColor)
    case custom([NSAttributedString.Key: Any])
}

// MARK: - TFY Chain Extension

public extension TFY where Base: UILabel {
    /// 设置行数
    /// - Parameter numberOfLines: 行数，自动限制为0或正数
    /// - Returns: 链式调用支持
    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> Self {
        base.numberOfLines = max(0, numberOfLines)
        return self
    }
    
    /// 设置是否自动调整字体大小以适应宽度
    /// - Parameter adjustsFontSizeToFitWidth: 是否自动调整字体大小
    /// - Returns: 链式调用支持
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    /// 获取适合指定大小的尺寸
    /// - Parameter size: 目标尺寸
    /// - Returns: 适合的尺寸
    @discardableResult
    func sizeThatFits(size: CGSize) -> CGSize {
        return base.sizeThatFits(size)
    }
}

// MARK: - UILabel Text Styling Extension

public extension UILabel {
    
    // MARK: - Font and Spacing
    
    /// 改变字体
    /// - Parameter font: 目标字体
    func changeFont(_ font: UIFont) {
        changeFont(font, for: text ?? "")
    }

    /// 改变字体
    /// - Parameters:
    ///   - font: 目标字体
    ///   - text: 要应用字体的文本
    func changeFont(_ font: UIFont, for text: String) {
        applyAttribute(.font, value: font, for: text)
    }

    /// 改变字间距
    /// - Parameter kern: 字间距值
    func changeKern(_ kern: CGFloat) {
        changeKern(kern, for: text ?? "")
    }

    /// 改变字间距
    /// - Parameters:
    ///   - kern: 字间距值
    ///   - text: 要应用字间距的文本
    func changeKern(_ kern: CGFloat, for text: String) {
        applyAttribute(.kern, value: kern, for: text)
    }

    /// 改变行间距
    /// - Parameter lineSpacing: 行间距值
    func changeLineSpacing(_ lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        changeParagraphStyle(paragraphStyle)
    }

    /// 改变段落样式
    /// - Parameter paragraphStyle: 段落样式
    func changeParagraphStyle(_ paragraphStyle: NSParagraphStyle) {
        guard let currentText = text, !currentText.isEmpty else { return }
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: currentText))
        let textLength = attributedString.length
        if textLength > 0 {
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: textLength))
        }
        attributedText = attributedString
    }

    // MARK: - Color Settings

    /// 改变文本颜色
    /// - Parameter color: 目标颜色
    func changeTextColor(_ color: UIColor) {
        changeTextColor(color, for: text ?? "")
    }

    /// 改变文本颜色
    /// - Parameters:
    ///   - color: 目标颜色
    ///   - text: 要应用颜色的文本
    func changeTextColor(_ color: UIColor, for text: String) {
        guard !text.isEmpty else { return }
        changeTextColor(color, for: [text])
    }

    /// 改变多个文本的颜色
    /// - Parameters:
    ///   - color: 目标颜色
    ///   - texts: 要应用颜色的文本数组
    func changeTextColor(_ color: UIColor, for texts: [String]) {
        guard !texts.isEmpty, let currentText = text, !currentText.isEmpty else { return }
        let attributedString = NSMutableAttributedString(string: currentText)
        for textStr in texts where !textStr.isEmpty {
            addAttributeToAllOccurrences(.foregroundColor, value: color, for: textStr, in: attributedString)
        }
        attributedText = attributedString
    }

    /// 改变不同文本的不同颜色
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - texts: 文本数组，数量必须与颜色数组相同
    func changeTextColors(_ colors: [UIColor], for texts: [String]) {
        guard colors.count == texts.count, !colors.isEmpty, let currentText = text, !currentText.isEmpty else { return }
        let attributedString = NSMutableAttributedString(string: currentText)
        let nsString = currentText as NSString
        
        var searchStartLocation = 0
        
        for (index, color) in colors.enumerated() where index < texts.count && !texts[index].isEmpty {
            let searchText = texts[index]
            let searchRange = NSRange(location: searchStartLocation, length: nsString.length - searchStartLocation)
            let foundRange = nsString.range(of: searchText, options: [], range: searchRange)
            
            if foundRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: color, range: foundRange)
                searchStartLocation = foundRange.location + foundRange.length
            }
        }
        
        attributedText = attributedString
    }

    /// 改变背景颜色
    /// - Parameter color: 目标背景颜色
    func changeBackgroundColor(_ color: UIColor) {
        changeBackgroundColor(color, for: text ?? "")
    }

    /// 改变背景颜色
    /// - Parameters:
    ///   - color: 目标背景颜色
    ///   - text: 要应用背景颜色的文本
    func changeBackgroundColor(_ color: UIColor, for text: String) {
        applyAttribute(.backgroundColor, value: color, for: text)
    }

    // MARK: - Text Effects

    /// 改变连笔字
    /// - Parameter ligature: 连笔字设置
    func changeLigature(_ ligature: NSNumber) {
        changeLigature(ligature, for: text ?? "")
    }

    /// 改变连笔字
    /// - Parameters:
    ///   - ligature: 连笔字设置
    ///   - text: 要应用连笔字的文本
    func changeLigature(_ ligature: NSNumber, for text: String) {
        applyAttribute(.ligature, value: ligature, for: text)
    }

    /// 改变删除线样式
    /// - Parameter style: 删除线样式
    func changeStrikethroughStyle(_ style: NSNumber) {
        changeStrikethroughStyle(style, for: text ?? "")
    }

    /// 改变删除线样式
    /// - Parameters:
    ///   - style: 删除线样式
    ///   - text: 要应用删除线的文本
    func changeStrikethroughStyle(_ style: NSNumber, for text: String) {
        applyAttribute(.strikethroughStyle, value: style, for: text)
    }

    /// 改变删除线颜色
    /// - Parameter color: 删除线颜色
    func changeStrikethroughColor(_ color: UIColor) {
        changeStrikethroughColor(color, for: text ?? "")
    }

    /// 改变删除线颜色
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - text: 要应用删除线颜色的文本
    func changeStrikethroughColor(_ color: UIColor, for text: String) {
        applyAttribute(.strikethroughColor, value: color, for: text)
    }

    /// 改变下划线样式
    /// - Parameter style: 下划线样式
    func changeUnderlineStyle(_ style: NSNumber) {
        changeUnderlineStyle(style, for: text ?? "")
    }

    /// 改变下划线样式
    /// - Parameters:
    ///   - style: 下划线样式
    ///   - text: 要应用下划线的文本
    func changeUnderlineStyle(_ style: NSNumber, for text: String) {
        applyAttribute(.underlineStyle, value: style, for: text)
    }

    /// 改变下划线颜色
    /// - Parameter color: 下划线颜色
    func changeUnderlineColor(_ color: UIColor) {
        changeUnderlineColor(color, for: text ?? "")
    }

    /// 改变下划线颜色
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - text: 要应用下划线颜色的文本
    func changeUnderlineColor(_ color: UIColor, for text: String) {
        applyAttribute(.underlineColor, value: color, for: text)
    }

    // MARK: - Stroke Settings

    /// 改变描边颜色
    /// - Parameter color: 描边颜色
    func changeStrokeColor(_ color: UIColor) {
        changeStrokeColor(color, for: text ?? "")
    }

    /// 改变描边颜色
    /// - Parameters:
    ///   - color: 描边颜色
    ///   - text: 要应用描边颜色的文本
    func changeStrokeColor(_ color: UIColor, for text: String) {
        applyAttribute(.strokeColor, value: color, for: text)
    }

    /// 改变描边宽度
    /// - Parameter width: 描边宽度
    func changeStrokeWidth(_ width: NSNumber) {
        changeStrokeWidth(width, for: text ?? "")
    }

    /// 改变描边宽度
    /// - Parameters:
    ///   - width: 描边宽度
    ///   - text: 要应用描边宽度的文本
    func changeStrokeWidth(_ width: NSNumber, for text: String) {
        applyAttribute(.strokeWidth, value: width, for: text)
    }

    // MARK: - Advanced Effects

    /// 改变阴影
    /// - Parameter shadow: 阴影对象
    func changeShadow(_ shadow: NSShadow) {
        changeShadow(shadow, for: text ?? "")
    }

    /// 改变阴影
    /// - Parameters:
    ///   - shadow: 阴影对象
    ///   - text: 要应用阴影的文本
    func changeShadow(_ shadow: NSShadow, for text: String) {
        applyAttribute(.shadow, value: shadow, for: text)
    }

    /// 改变文本效果
    /// - Parameter effect: 文本效果字符串
    func changeTextEffect(_ effect: String) {
        changeTextEffect(effect, for: text ?? "")
    }

    /// 改变文本效果
    /// - Parameters:
    ///   - effect: 文本效果字符串
    ///   - text: 要应用文本效果的文本
    func changeTextEffect(_ effect: String, for text: String) {
        guard !effect.isEmpty else { return }
        applyAttribute(.textEffect, value: effect, for: text)
    }

    /// 改变文本附件
    /// - Parameter attachment: 文本附件
    func changeAttachment(_ attachment: NSTextAttachment) {
        changeAttachment(attachment, for: text ?? "")
    }

    /// 改变文本附件
    /// - Parameters:
    ///   - attachment: 文本附件
    ///   - text: 要应用附件的文本
    func changeAttachment(_ attachment: NSTextAttachment, for text: String) {
        applyAttribute(.attachment, value: attachment, for: text)
    }

    /// 改变链接
    /// - Parameter link: 链接地址
    func changeLink(_ link: String) {
        changeLink(link, for: text ?? "")
    }

    /// 改变链接
    /// - Parameters:
    ///   - link: 链接地址
    ///   - text: 要应用链接的文本
    func changeLink(_ link: String, for text: String) {
        guard !link.isEmpty else { return }
        applyAttribute(.link, value: link, for: text)
    }

    // MARK: - Text Transformations

    /// 改变基准线偏移
    /// - Parameter offset: 基准线偏移值
    func changeBaselineOffset(_ offset: NSNumber) {
        changeBaselineOffset(offset, for: text ?? "")
    }

    /// 改变基准线偏移
    /// - Parameters:
    ///   - offset: 基准线偏移值
    ///   - text: 要应用基准线偏移的文本
    func changeBaselineOffset(_ offset: NSNumber, for text: String) {
        applyAttribute(.baselineOffset, value: offset, for: text)
    }

    /// 改变倾斜
    /// - Parameter obliqueness: 倾斜值
    func changeObliqueness(_ obliqueness: NSNumber) {
        changeObliqueness(obliqueness, for: text ?? "")
    }

    /// 改变倾斜
    /// - Parameters:
    ///   - obliqueness: 倾斜值
    ///   - text: 要应用倾斜的文本
    func changeObliqueness(_ obliqueness: NSNumber, for text: String) {
        applyAttribute(.obliqueness, value: obliqueness, for: text)
    }

    /// 改变字粗细
    /// - Parameter expansion: 字粗细值
    func changeExpansion(_ expansion: NSNumber) {
        changeExpansion(expansion, for: text ?? "")
    }

    /// 改变字粗细
    /// - Parameters:
    ///   - expansion: 字粗细值
    ///   - text: 要应用字粗细的文本
    func changeExpansion(_ expansion: NSNumber, for text: String) {
        applyAttribute(.expansion, value: expansion, for: text)
    }

    /// 改变书写方向
    /// - Parameters:
    ///   - direction: 书写方向数组
    ///   - text: 要应用书写方向的文本
    func changeWritingDirection(_ direction: [Any], for text: String) {
        guard !direction.isEmpty else { return }
        applyAttribute(.writingDirection, value: direction, for: text)
    }

    /// 改变垂直字形
    /// - Parameters:
    ///   - form: 垂直字形值
    ///   - text: 要应用垂直字形的文本
    func changeVerticalGlyphForm(_ form: NSNumber, for text: String) {
        applyAttribute(.verticalGlyphForm, value: form, for: text)
    }

    /// 改变字间距（CoreText）
    /// - Parameter kern: 字间距值
    func changeCTKern(_ kern: NSNumber) {
        guard let currentText = text, !currentText.isEmpty else { return }
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: currentText))
        let textLength = attributedString.length
        if textLength > 1 {
            attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: kern, range: NSRange(location: 0, length: textLength - 1))
        }
        attributedText = attributedString
    }

    // MARK: - Image Settings

    /// 为UILabel首部设置图片标签（优化版本）
    /// - Parameters:
    ///   - images: 图片数组
    ///   - text: 文本内容
    ///   - imageSpan: 图片间距，默认为0
    func setImages(_ images: [UIImage], text: String, imageSpan: CGFloat = 0) {
        guard !images.isEmpty else { return }

        let textAttrStr = NSMutableAttributedString()
        
        // 预计算字体相关尺寸，避免重复计算
        let fontSize = font.pointSize
        let lineHeight = font.lineHeight
        let textPaddingTop = (lineHeight - fontSize) / 2
        
        for image in images {
            let attach = NSTextAttachment()
            attach.image = image
            
            // 优化图片尺寸计算
            let aspectRatio = image.size.width / image.size.height
            let imgH = fontSize
            let imgW = aspectRatio * imgH
            
            attach.bounds = CGRect(x: 0, y: -textPaddingTop, width: imgW, height: imgH)

            let imgStr = NSAttributedString(attachment: attach)
            textAttrStr.append(imgStr)
            textAttrStr.append(NSAttributedString(string: " "))
        }

        textAttrStr.append(NSAttributedString(string: text))

        // 只在需要时添加字间距属性
        if imageSpan != 0 {
            let spanRange = NSRange(location: 0, length: images.count * 2)
            textAttrStr.addAttribute(.kern, value: imageSpan, range: spanRange)
        }
        
        attributedText = textAttrStr
    }

    // MARK: - Style Presets
    
    /// 应用预设的文本样式
    /// - Parameters:
    ///   - style: 预设样式
    ///   - text: 目标文本
    func applyStyle(_ style: TextStyle, for text: String) {
        guard !text.isEmpty else { return }
        
        var attributeBuilder = AttributeBuilder()
        
        switch style {
        case .title(let font, let color), .subtitle(let font, let color), .body(let font, let color), .caption(let font, let color):
            attributeBuilder.add(.font, value: font)
            attributeBuilder.add(.foregroundColor, value: color)
        case .custom(let attributes):
            for (key, value) in attributes {
                attributeBuilder.add(key, value: value)
            }
        }
        
        let attributes = attributeBuilder.build()
        setAttributes(attributes, for: text)
    }
    
    // MARK: - Batch Operations
    
    /// 批量设置文本属性
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - text: 目标文本
    func setAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) {
        guard !text.isEmpty, !attributes.isEmpty, let currentText = self.text, !currentText.isEmpty else { return }
        
        let targetAttributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: currentText))
        let textRange = findTextRangeInString(text, in: currentText)
        
        if textRange.location != NSNotFound {
            targetAttributedString.addAttributes(attributes, range: textRange)
            attributedText = targetAttributedString
        }
    }
    
    /// 使用属性构建器设置文本属性
    /// - Parameters:
    ///   - text: 目标文本
    ///   - builder: 属性构建器闭包
    fileprivate func setAttributes(for text: String, using builder: (inout AttributeBuilder) -> Void) {
        guard !text.isEmpty else { return }
        
        var attributeBuilder = AttributeBuilder()
        builder(&attributeBuilder)
        let attributes = attributeBuilder.build()
        
        guard !attributes.isEmpty else { return }
        setAttributes(attributes, for: text)
    }
    
    /// 批量设置多个文本的属性
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - texts: 文本数组
    func setAttributes(_ attributes: [NSAttributedString.Key: Any], for texts: [String]) {
        guard !texts.isEmpty, !attributes.isEmpty, let currentText = self.text, !currentText.isEmpty else { return }
        
        let targetAttributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: currentText))
        var hasChanges = false
        
        for text in texts {
            guard !text.isEmpty else { continue }
            let textRange = findTextRangeInString(text, in: currentText)
            if textRange.location != NSNotFound {
                targetAttributedString.addAttributes(attributes, range: textRange)
                hasChanges = true
            }
        }
        
        if hasChanges {
            attributedText = targetAttributedString
        }
    }

    // MARK: - Private Helper Methods

    /// 统一的属性应用方法（核心优化：减少重复代码）
    /// - Parameters:
    ///   - key: 属性键
    ///   - value: 属性值
    ///   - text: 目标文本
    private func applyAttribute(_ key: NSAttributedString.Key, value: Any, for text: String) {
        guard !text.isEmpty, let currentText = self.text, !currentText.isEmpty else { return }
        
        let targetAttributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: currentText))
        let textRange = findTextRangeInString(text, in: currentText)
        
        if textRange.location != NSNotFound {
            targetAttributedString.addAttribute(key, value: value, range: textRange)
            attributedText = targetAttributedString
        }
    }
    
    /// 添加属性到所有匹配的文本
    /// - Parameters:
    ///   - key: 属性键
    ///   - value: 属性值
    ///   - text: 目标文本
    ///   - attributedString: 属性字符串
    private func addAttributeToAllOccurrences(_ key: NSAttributedString.Key, value: Any, for text: String, in attributedString: NSMutableAttributedString) {
        guard !text.isEmpty else { return }
        
        let nsString = attributedString.string as NSString
        guard nsString.length > 0 else { return }
        
        var searchRange = NSRange(location: 0, length: nsString.length)
        
        while searchRange.location < nsString.length {
            let foundRange = nsString.range(of: text, options: [], range: searchRange)
            if foundRange.location == NSNotFound {
                break
            }
            
            attributedString.addAttribute(key, value: value, range: foundRange)
            
            // 移动搜索范围到找到的文本之后
            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = nsString.length - searchRange.location
        }
    }
    
    /// 在文本中查找指定字符串的范围（优化版本）
    /// - Parameters:
    ///   - searchText: 要搜索的文本
    ///   - fullText: 完整文本
    /// - Returns: 找到的文本范围，如果未找到返回NSNotFound
    private func findTextRangeInString(_ searchText: String, in fullText: String) -> NSRange {
        // 快速返回空字符串情况
        guard !searchText.isEmpty, !fullText.isEmpty else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        // 如果搜索文本比完整文本长，直接返回未找到
        guard searchText.count <= fullText.count else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        // 首先尝试精确匹配（最快）
        let exactRange = (fullText as NSString).range(of: searchText)
        if exactRange.location != NSNotFound {
            return exactRange
        }
        
        // 如果精确匹配失败，尝试忽略大小写和变音符号
        let searchOptions: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]
        let insensitiveRange = (fullText as NSString).range(of: searchText, options: searchOptions)
        if insensitiveRange.location != NSNotFound {
            return insensitiveRange
        }
        
        // 对于阿拉伯语等RTL语言，尝试反向搜索
        let reverseOptions: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive, .backwards]
        let reverseRange = (fullText as NSString).range(of: searchText, options: reverseOptions)
        if reverseRange.location != NSNotFound {
            return reverseRange
        }
        
        return NSRange(location: NSNotFound, length: 0)
    }
    
    /// 优化的文本搜索，支持多种策略
    /// - Parameters:
    ///   - searchText: 要搜索的文本
    ///   - fullText: 完整文本
    ///   - strategy: 搜索策略
    /// - Returns: 找到的文本范围，如果未找到返回NSNotFound
    private func findTextRangeInString(_ searchText: String, in fullText: String, strategy: TextSearchStrategy) -> NSRange {
        guard !searchText.isEmpty, !fullText.isEmpty, searchText.count <= fullText.count else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        switch strategy {
        case .exact:
            return (fullText as NSString).range(of: searchText)
        case .caseInsensitive:
            let options: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]
            return (fullText as NSString).range(of: searchText, options: options)
        case .reverse:
            let options: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive, .backwards]
            return (fullText as NSString).range(of: searchText, options: options)
        }
    }
}
