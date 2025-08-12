//
//  UILabel+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UILabel {
    /// 设置行数
    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> Self {
        base.numberOfLines = max(0, numberOfLines)
        return self
    }
    /// 设置是否自动调整字体大小以适应宽度
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    /// 获取适合指定大小的尺寸
    @discardableResult
    func sizeThatFits(size:CGSize) -> CGSize {
        let sizes:CGSize = base.sizeThatFits(size)
        return sizes
    }
}

public extension UILabel {
    /// 改变字体
    func changeFont(_ font: UIFont) {
        changeFont(font, for: text ?? "")
    }

    /// 改变字体
    func changeFont(_ font: UIFont, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.font, value: font, for: text)
    }

    /// 改变字间距
    func changeKern(_ kern: CGFloat) {
        changeKern(kern, for: text ?? "")
    }

    /// 改变字间距
    func changeKern(_ kern: CGFloat, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.kern, value: kern, for: text)
    }

    /// 改变行间距
    func changeLineSpacing(_ lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        changeParagraphStyle(paragraphStyle)
    }

    /// 段落样式
    func changeParagraphStyle(_ paragraphStyle: NSParagraphStyle) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        let textLength = NSString(string: text ?? "").length
        if textLength > 0 {
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: textLength))
        }
        attributedText = attributedString
    }

    // MARK: - 颜色设置

    /// 改变文本颜色
    func changeTextColor(_ color: UIColor) {
        changeTextColor(color, for: text ?? "")
    }

    /// 改变文本颜色
    func changeTextColor(_ color: UIColor, for text: String) {
        guard !text.isEmpty else { return }
        changeTextColor(color, for: [text])
    }

    /// 改变多个文本的颜色
    func changeTextColor(_ color: UIColor, for texts: [String]) {
        guard !texts.isEmpty else { return }
        let attributedString = NSMutableAttributedString(string: text ?? "")
        for textStr in texts {
            guard !textStr.isEmpty else { continue }
            addAttribute(.foregroundColor, value: color, for: textStr, in: attributedString)
        }
        attributedText = attributedString
    }

    /// 改变不同文本的不同颜色
    func changeTextColors(_ colors: [UIColor], for texts: [String]) {
        guard colors.count == texts.count, !colors.isEmpty else { return }
        let attributedString = NSMutableAttributedString(string: text ?? "")
        for (index, color) in colors.enumerated() {
            guard index < texts.count, !texts[index].isEmpty else { continue }
            addAttribute(.foregroundColor, value: color, for: texts[index], in: attributedString)
        }
        attributedText = attributedString
    }

    /// 改变背景颜色
    func changeBackgroundColor(_ color: UIColor) {
        changeBackgroundColor(color, for: text ?? "")
    }

    /// 改变背景颜色
    func changeBackgroundColor(_ color: UIColor, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.backgroundColor, value: color, for: text)
    }

    // MARK: - 文本效果设置

    /// 改变连笔字
    func changeLigature(_ ligature: NSNumber) {
        changeLigature(ligature, for: text ?? "")
    }

    /// 改变连笔字
    func changeLigature(_ ligature: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.ligature, value: ligature, for: text)
    }

    /// 改变删除线样式
    func changeStrikethroughStyle(_ style: NSNumber) {
        changeStrikethroughStyle(style, for: text ?? "")
    }

    /// 改变删除线样式
    func changeStrikethroughStyle(_ style: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.strikethroughStyle, value: style, for: text)
    }

    /// 改变删除线颜色
    func changeStrikethroughColor(_ color: UIColor) {
        changeStrikethroughColor(color, for: text ?? "")
    }

    /// 改变删除线颜色
    func changeStrikethroughColor(_ color: UIColor, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.strikethroughColor, value: color, for: text)
    }

    /// 改变下划线样式
    func changeUnderlineStyle(_ style: NSNumber) {
        changeUnderlineStyle(style, for: text ?? "")
    }

    /// 改变下划线样式
    func changeUnderlineStyle(_ style: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.underlineStyle, value: style, for: text)
    }

    /// 改变下划线颜色
    func changeUnderlineColor(_ color: UIColor) {
        changeUnderlineColor(color, for: text ?? "")
    }

    /// 改变下划线颜色
    func changeUnderlineColor(_ color: UIColor, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.underlineColor, value: color, for: text)
    }

    // MARK: - 描边设置

    /// 改变描边颜色
    func changeStrokeColor(_ color: UIColor) {
        changeStrokeColor(color, for: text ?? "")
    }

    /// 改变描边颜色
    func changeStrokeColor(_ color: UIColor, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.strokeColor, value: color, for: text)
    }

    /// 改变描边宽度
    func changeStrokeWidth(_ width: NSNumber) {
        changeStrokeWidth(width, for: text ?? "")
    }

    /// 改变描边宽度
    func changeStrokeWidth(_ width: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.strokeWidth, value: width, for: text)
    }

    // MARK: - 其他效果设置

    /// 改变阴影
    func changeShadow(_ shadow: NSShadow) {
        changeShadow(shadow, for: text ?? "")
    }

    /// 改变阴影
    func changeShadow(_ shadow: NSShadow, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.shadow, value: shadow, for: text)
    }

    /// 改变文本效果
    func changeTextEffect(_ effect: String) {
        changeTextEffect(effect, for: text ?? "")
    }

    /// 改变文本效果
    func changeTextEffect(_ effect: String, for text: String) {
        guard !text.isEmpty, !effect.isEmpty else { return }
        addAttribute(.textEffect, value: effect, for: text)
    }

    /// 改变文本附件
    func changeAttachment(_ attachment: NSTextAttachment) {
        changeAttachment(attachment, for: text ?? "")
    }

    /// 改变文本附件
    func changeAttachment(_ attachment: NSTextAttachment, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.attachment, value: attachment, for: text)
    }

    /// 改变链接
    func changeLink(_ link: String) {
        changeLink(link, for: text ?? "")
    }

    /// 改变链接
    func changeLink(_ link: String, for text: String) {
        guard !text.isEmpty, !link.isEmpty else { return }
        addAttribute(.link, value: link, for: text)
    }

    // MARK: - 文本变换设置

    /// 改变基准线偏移
    func changeBaselineOffset(_ offset: NSNumber) {
        changeBaselineOffset(offset, for: text ?? "")
    }

    /// 改变基准线偏移
    func changeBaselineOffset(_ offset: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.baselineOffset, value: offset, for: text)
    }

    /// 改变倾斜
    func changeObliqueness(_ obliqueness: NSNumber) {
        changeObliqueness(obliqueness, for: text ?? "")
    }

    /// 改变倾斜
    func changeObliqueness(_ obliqueness: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.obliqueness, value: obliqueness, for: text)
    }

    /// 改变字粗细
    func changeExpansion(_ expansion: NSNumber) {
        changeExpansion(expansion, for: text ?? "")
    }

    /// 改变字粗细
    func changeExpansion(_ expansion: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.expansion, value: expansion, for: text)
    }

    /// 改变书写方向
    func changeWritingDirection(_ direction: [Any], for text: String) {
        guard !text.isEmpty, !direction.isEmpty else { return }
        addAttribute(.writingDirection, value: direction, for: text)
    }

    /// 改变垂直字形
    func changeVerticalGlyphForm(_ form: NSNumber, for text: String) {
        guard !text.isEmpty else { return }
        addAttribute(.verticalGlyphForm, value: form, for: text)
    }

    /// 改变字间距（CoreText）
    func changeCTKern(_ kern: NSNumber) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        let textLength = NSString(string: text ?? "").length
        if textLength > 1 {
            attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: kern, range: NSRange(location: 0, length: textLength - 1))
        }
        attributedText = attributedString
    }

    // MARK: - 图片设置

    /// 为UILabel首部设置图片标签
    func setImages(_ images: [UIImage], text: String, imageSpan: CGFloat = 0) {
        guard !images.isEmpty else { return }

        let textAttrStr = NSMutableAttributedString()
        for image in images {
            let attach = NSTextAttachment()
            attach.image = image
            let imgH: CGFloat = font.pointSize
            let imgW: CGFloat = (image.size.width / image.size.height) * imgH
            let textPaddingTop: CGFloat = (font.lineHeight - font.pointSize) / 2
            attach.bounds = CGRect(x: 0, y: -textPaddingTop, width: imgW, height: imgH)

            let imgStr = NSAttributedString(attachment: attach)
            textAttrStr.append(imgStr)
            textAttrStr.append(NSAttributedString(string: " "))
        }

        textAttrStr.append(NSAttributedString(string: text))

        if imageSpan != 0 {
            textAttrStr.addAttribute(.kern, value: imageSpan, range: NSRange(location: 0, length: images.count * 2))
        }
        attributedText = textAttrStr
    }

    // MARK: - 私有辅助方法

    private func addAttribute(_ key: NSAttributedString.Key, value: Any, for text: String, in attributedString: NSMutableAttributedString? = nil) {
        guard !text.isEmpty else { return }

        let targetAttributedString = attributedString ?? NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        let options: NSString.CompareOptions = [.caseInsensitive, .backwards, .diacriticInsensitive, .widthInsensitive]
        let textRange = NSString(string: self.text ?? "").range(of: text, options: options)

        if textRange.location != NSNotFound {
            targetAttributedString.addAttribute(key, value: value, range: textRange)
        }

        if attributedString == nil {
            attributedText = targetAttributedString
        }
    }
}
