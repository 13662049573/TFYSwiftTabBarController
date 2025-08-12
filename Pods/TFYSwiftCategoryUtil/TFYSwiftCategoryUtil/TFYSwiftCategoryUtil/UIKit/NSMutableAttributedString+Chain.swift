//
//  NSMutableAttributedString+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit

public extension TFY where Base: NSMutableAttributedString {
    
    // MARK: 1.1、添加属性
    /// 添加属性
    /// - Parameters:
    ///   - name: 属性名
    ///   - value: 属性值
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) -> Self {
        base.addAttribute(name, value: value, range: range)
        return self
    }
    
    // MARK: 1.2、添加多个属性
    /// 添加多个属性
    /// - Parameters:
    ///   - attrs: 属性字典
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func addAttributes(_ attrs: [NSAttributedString.Key : Any] = [:], range: NSRange) -> Self {
        base.addAttributes(attrs, range: range)
        return self
    }
    
    // MARK: 1.3、移除属性
    /// 移除属性
    /// - Parameters:
    ///   - name: 属性名
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func removeAttribute(_ name: NSAttributedString.Key, range: NSRange) -> Self {
        base.removeAttribute(name, range: range)
        return self
    }
    
    // MARK: 1.4、设置字体
    /// 设置字体
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func font(_ font: UIFont, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.font, value: font, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.font, value: font, range: range)
        return self
    }
    
    // MARK: 1.5、设置系统字体
    /// 设置系统字体
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func systemFont(ofSize fontSize: CGFloat, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)
        return self
    }
    
    // MARK: 1.6、设置粗体系统字体
    /// 设置粗体系统字体
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func boldSystemFont(ofSize fontSize: CGFloat, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range)
        return self
    }
    
    // MARK: 1.7、设置段落样式
    /// 设置段落样式
    /// - Parameters:
    ///   - paragraphStyle: 段落样式
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func paragraphStyle(_ paragraphStyle: NSParagraphStyle, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return self
    }
    
    // MARK: 1.8、设置前景色
    /// 设置前景色
    /// - Parameters:
    ///   - foregroundColor: 前景色
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func foregroundColor(_ foregroundColor: UIColor, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.foregroundColor, value: foregroundColor, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.foregroundColor, value: foregroundColor, range: range)
        return self
    }
    
    // MARK: 1.9、设置背景色
    /// 设置背景色
    /// - Parameters:
    ///   - backgroundColor: 背景色
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.backgroundColor, value: backgroundColor, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.backgroundColor, value: backgroundColor, range: range)
        return self
    }
    
    // MARK: 1.10、设置连字
    /// 设置连字
    /// - Parameters:
    ///   - ligature: 连字值
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func ligature(_ ligature: Int, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.ligature, value: ligature, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.ligature, value: ligature, range: range)
        return self
    }
    
    // MARK: 1.11、设置字间距
    /// 设置字间距
    /// - Parameters:
    ///   - kern: 字间距
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func kern(_ kern: CGFloat, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.kern, value: kern, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.kern, value: kern, range: range)
        return self
    }
    
    // MARK: 1.12、设置删除线样式
    /// 设置删除线样式
    /// - Parameters:
    ///   - strikethroughStyle: 删除线样式
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func strikethroughStyle(_ strikethroughStyle: Int, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.strikethroughStyle, value: strikethroughStyle, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.strikethroughStyle, value: strikethroughStyle, range: range)
        return self
    }
    
    // MARK: 1.13、设置下划线样式
    /// 设置下划线样式
    /// - Parameters:
    ///   - underlineStyle: 下划线样式
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func underlineStyle(_ underlineStyle: Int, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.underlineStyle, value: underlineStyle, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.underlineStyle, value: underlineStyle, range: range)
        return self
    }
    
    // MARK: 1.14、设置描边颜色
    /// 设置描边颜色
    /// - Parameters:
    ///   - strokeColor: 描边颜色
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func strokeColor(_ strokeColor: UIColor, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.strokeColor, value: strokeColor, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.strokeColor, value: strokeColor, range: range)
        return self
    }
    
    // MARK: 1.15、设置描边宽度
    /// 设置描边宽度
    /// - Parameters:
    ///   - strokeWidth: 描边宽度
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func strokeWidth(_ strokeWidth: CGFloat, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.strokeWidth, value: strokeWidth, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.strokeWidth, value: strokeWidth, range: range)
        return self
    }
    
    // MARK: 1.16、设置阴影
    /// 设置阴影
    /// - Parameters:
    ///   - shadow: 阴影对象
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func shadow(_ shadow: NSShadow, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.shadow, value: shadow, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.shadow, value: shadow, range: range)
        return self
    }
    
    // MARK: 1.17、设置文本效果
    /// 设置文本效果
    /// - Parameters:
    ///   - textEffect: 文本效果
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func textEffect(_ textEffect: String, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.textEffect, value: textEffect, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.textEffect, value: textEffect, range: range)
        return self
    }
    
    // MARK: 1.18、设置附件
    /// 设置附件
    /// - Parameters:
    ///   - attachment: 文本附件
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func attachment(_ attachment: NSTextAttachment, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.attachment, value: attachment, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.attachment, value: attachment, range: range)
        return self
    }
    
    // MARK: 1.19、设置链接
    /// 设置链接
    /// - Parameters:
    ///   - link: 链接URL
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func link(_ link: URL, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.link, value: link, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.link, value: link, range: range)
        return self
    }
    
    // MARK: 1.20、设置基线偏移
    /// 设置基线偏移
    /// - Parameters:
    ///   - baselineOffset: 基线偏移
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func baselineOffset(_ baselineOffset: CGFloat, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.baselineOffset, value: baselineOffset, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.baselineOffset, value: baselineOffset, range: range)
        return self
    }
    
    // MARK: 1.21、设置下划线颜色
    /// 设置下划线颜色
    /// - Parameters:
    ///   - underlineColor: 下划线颜色
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func underlineColor(_ underlineColor: UIColor, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.underlineColor, value: underlineColor, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.underlineColor, value: underlineColor, range: range)
        return self
    }
    
    // MARK: 1.22、设置删除线颜色
    /// 设置删除线颜色
    /// - Parameters:
    ///   - strikethroughColor: 删除线颜色
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func strikethroughColor(_ strikethroughColor: UIColor, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.strikethroughColor, value: strikethroughColor, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.strikethroughColor, value: strikethroughColor, range: range)
        return self
    }
    
    // MARK: 1.23、设置倾斜度
    /// 设置倾斜度
    /// - Parameters:
    ///   - obliqueness: 倾斜度
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func obliqueness(_ obliqueness: CGFloat, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.obliqueness, value: obliqueness, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.obliqueness, value: obliqueness, range: range)
        return self
    }
    
    // MARK: 1.24、设置扩展
    /// 设置扩展
    /// - Parameters:
    ///   - expansion: 扩展值
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func expansion(_ expansion: CGFloat, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.expansion, value: expansion, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.expansion, value: expansion, range: range)
        return self
    }
    
    // MARK: 1.25、设置书写方向
    /// 设置书写方向
    /// - Parameters:
    ///   - writingDirection: 书写方向数组
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func writingDirection(_ writingDirection: [Int], range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.writingDirection, value: writingDirection, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.writingDirection, value: writingDirection, range: range)
        return self
    }
    
    // MARK: 1.26、设置垂直字形形式
    /// 设置垂直字形形式
    /// - Parameters:
    ///   - verticalGlyphForm: 垂直字形形式
    ///   - range: 范围，nil表示全部
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func verticalGlyphForm(_ verticalGlyphForm: Int, range: NSRange? = nil) -> Self {
        guard let range = range else {
            base.addAttribute(.verticalGlyphForm, value: verticalGlyphForm, range: NSMakeRange(0, base.length))
            return self
        }
        base.addAttribute(.verticalGlyphForm, value: verticalGlyphForm, range: range)
        return self
    }
    
    // MARK: 1.25、设置行间距
    /// 设置行间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat, range: NSRange? = nil) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        return self.paragraphStyle(paragraphStyle, range: range)
    }
    
    // MARK: 1.26、设置文本对齐
    /// 设置文本对齐
    /// - Parameters:
    ///   - alignment: 对齐方式
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment, range: NSRange? = nil) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return self.paragraphStyle(paragraphStyle, range: range)
    }
    
    // MARK: 1.27、设置首行缩进
    /// 设置首行缩进
    /// - Parameters:
    ///   - firstLineHeadIndent: 首行缩进
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat, range: NSRange? = nil) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        return self.paragraphStyle(paragraphStyle, range: range)
    }
    
    // MARK: 1.28、设置段落间距
    /// 设置段落间距
    /// - Parameters:
    ///   - paragraphSpacing: 段落间距
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func paragraphSpacing(_ paragraphSpacing: CGFloat, range: NSRange? = nil) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = paragraphSpacing
        return self.paragraphStyle(paragraphStyle, range: range)
    }
    
    // MARK: 1.29、设置字间距
    /// 设置字间距
    /// - Parameters:
    ///   - characterSpacing: 字间距
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func characterSpacing(_ characterSpacing: CGFloat, range: NSRange? = nil) -> Self {
        return self.kern(characterSpacing, range: range)
    }
    
    // MARK: 1.30、设置删除线
    /// 设置删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - style: 删除线样式
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func strikethrough(color: UIColor, style: NSUnderlineStyle = .single, range: NSRange? = nil) -> Self {
        let finalRange = range ?? NSMakeRange(0, base.length)
        base.addAttribute(.strikethroughStyle, value: style.rawValue, range: finalRange)
        base.addAttribute(.strikethroughColor, value: color, range: finalRange)
        return self
    }
    
    // MARK: 1.31、设置下划线
    /// 设置下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - style: 下划线样式
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func underline(color: UIColor, style: NSUnderlineStyle = .single, range: NSRange? = nil) -> Self {
        let finalRange = range ?? NSMakeRange(0, base.length)
        base.addAttribute(.underlineStyle, value: style.rawValue, range: finalRange)
        base.addAttribute(.underlineColor, value: color, range: finalRange)
        return self
    }
    
    // MARK: 1.32、设置阴影
    /// 设置阴影
    /// - Parameters:
    ///   - offset: 阴影偏移
    ///   - blurRadius: 模糊半径
    ///   - color: 阴影颜色
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func shadow(offset: CGSize = CGSize(width: 0, height: 1), blurRadius: CGFloat = 0, color: UIColor = .black, range: NSRange? = nil) -> Self {
        let shadow = NSShadow()
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowColor = color
        return self.shadow(shadow, range: range)
    }
    
    // MARK: 1.33、设置渐变文本
    /// 设置渐变文本
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func gradientText(colors: [UIColor], locations: [CGFloat]? = nil, range: NSRange? = nil) -> Self {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations?.map { NSNumber(value: Float($0)) }
        
        // 这里需要特殊处理，因为NSAttributedString不直接支持渐变
        // 可以通过其他方式实现，比如使用Core Graphics
        TFYUtils.Logger.log("渐变文本功能需要特殊实现")
        return self
    }
    
    // MARK: 1.34、设置文本描边
    /// 设置文本描边
    /// - Parameters:
    ///   - color: 描边颜色
    ///   - width: 描边宽度
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func stroke(color: UIColor, width: CGFloat, range: NSRange? = nil) -> Self {
        let finalRange = range ?? NSMakeRange(0, base.length)
        base.addAttribute(.strokeColor, value: color, range: finalRange)
        base.addAttribute(.strokeWidth, value: width, range: finalRange)
        return self
    }
    
    // MARK: 1.35、设置文本倾斜
    /// 设置文本倾斜
    /// - Parameters:
    ///   - angle: 倾斜角度
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func italic(angle: CGFloat = 0.2, range: NSRange? = nil) -> Self {
        return self.obliqueness(angle, range: range)
    }
    
    // MARK: 1.36、设置文本缩放
    /// 设置文本缩放
    /// - Parameters:
    ///   - scale: 缩放比例
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func scale(_ scale: CGFloat, range: NSRange? = nil) -> Self {
        return self.expansion(scale - 1.0, range: range)
    }
    
    // MARK: 1.37、设置文本高亮
    /// 设置文本高亮
    /// - Parameters:
    ///   - color: 高亮颜色
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func highlight(color: UIColor, range: NSRange? = nil) -> Self {
        return self.backgroundColor(color, range: range)
    }
    
    // MARK: 1.38、设置文本边框
    /// 设置文本边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func border(color: UIColor, width: CGFloat, range: NSRange? = nil) -> Self {
        let finalRange = range ?? NSMakeRange(0, base.length)
        base.addAttribute(.strokeColor, value: color, range: finalRange)
        base.addAttribute(.strokeWidth, value: -width, range: finalRange)
        return self
    }
    
    // MARK: 1.39、设置文本圆角背景
    /// 设置文本圆角背景
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - cornerRadius: 圆角半径
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func roundedBackground(color: UIColor, cornerRadius: CGFloat, range: NSRange? = nil) -> Self {
        // 这里需要特殊处理，因为NSAttributedString不直接支持圆角背景
        // 可以通过其他方式实现，比如使用Core Graphics
        TFYUtils.Logger.log("圆角背景功能需要特殊实现")
        return self.backgroundColor(color, range: range)
    }
    
    // MARK: 1.40、设置文本渐变背景
    /// 设置文本渐变背景
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - range: 范围
    /// - Returns: 链式调用对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func gradientBackground(colors: [UIColor], locations: [CGFloat]? = nil, range: NSRange? = nil) -> Self {
        // 这里需要特殊处理，因为NSAttributedString不直接支持渐变背景
        // 可以通过其他方式实现，比如使用Core Graphics
        TFYUtils.Logger.log("渐变背景功能需要特殊实现")
        return self
    }
}

// MARK: - 二、NSMutableAttributedString的便利方法
public extension NSMutableAttributedString {
    
    // MARK: 2.1、创建富文本
    /// 创建富文本
    /// - Parameter string: 字符串
    /// - Returns: 富文本对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    convenience init(attributedString: String) {
        self.init(string: attributedString)
    }
    
    // MARK: 2.2、从HTML创建富文本
    /// 从HTML创建富文本
    /// - Parameter htmlString: HTML字符串
    /// - Returns: 富文本对象，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    convenience init?(htmlString: String) {
        guard let data = htmlString.data(using: .utf8) else { return nil }
        try? self.init(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
    
    // MARK: 2.3、从RTF创建富文本
    /// 从RTF创建富文本
    /// - Parameter rtfData: RTF数据
    /// - Returns: 富文本对象，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    convenience init?(rtfData: Data) {
        try? self.init(data: rtfData, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
    }
    
    // MARK: 2.4、获取纯文本
    /// 获取纯文本
    /// - Returns: 纯文本字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var plainText: String {
        return self.string
    }
    
    // MARK: 2.5、获取HTML字符串
    /// 获取HTML字符串
    /// - Returns: HTML字符串，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func htmlString() -> String? {
        do {
            let data = try self.data(from: NSRange(location: 0, length: self.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.html])
            return String(data: data, encoding: .utf8)
        } catch {
            TFYUtils.Logger.log("转换HTML失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 2.6、获取RTF数据
    /// 获取RTF数据
    /// - Returns: RTF数据，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func rtfData() -> Data? {
        do {
            return try self.data(from: NSRange(location: 0, length: self.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
        } catch {
            TFYUtils.Logger.log("转换RTF失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 2.7、计算文本大小
    /// 计算文本大小
    /// - Parameter maxSize: 最大尺寸
    /// - Returns: 文本尺寸
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func size(maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) -> CGSize {
        let boundingRect = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return boundingRect.size
    }
    
    // MARK: 2.8、计算文本高度
    /// 计算文本高度
    /// - Parameter width: 宽度
    /// - Returns: 文本高度
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func height(width: CGFloat) -> CGFloat {
        return self.size(maxSize: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    // MARK: 2.9、计算文本宽度
    /// 计算文本宽度
    /// - Parameter height: 高度
    /// - Returns: 文本宽度
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func width(height: CGFloat) -> CGFloat {
        return self.size(maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
    }
    
    // MARK: 2.10、添加图片附件
    /// 添加图片附件
    /// - Parameters:
    ///   - image: 图片
    ///   - bounds: 边界
    ///   - index: 插入位置
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func addImage(_ image: UIImage, bounds: CGRect? = nil, at index: Int) {
        let attachment = NSTextAttachment()
        attachment.image = image
        if let bounds = bounds {
            attachment.bounds = bounds
        }
        
        let attributedString = NSAttributedString(attachment: attachment)
        self.insert(attributedString, at: index)
    }
    
    // MARK: 2.11、替换文本
    /// 替换文本
    /// - Parameters:
    ///   - string: 要替换的字符串
    ///   - with: 替换后的字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func replaceText(_ string: String, with replacement: String) {
        let range = NSRange(location: 0, length: self.length)
        self.replaceCharacters(in: range, with: replacement)
    }
    
    // MARK: 2.12、删除指定范围的文本
    /// 删除指定范围的文本
    /// - Parameter range: 范围
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func deleteText(in range: NSRange) {
        self.replaceCharacters(in: range, with: "")
    }
    
    // MARK: 2.13、在指定位置插入文本
    /// 在指定位置插入文本
    /// - Parameters:
    ///   - string: 要插入的文本
    ///   - index: 插入位置
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func insertText(_ string: String, at index: Int) {
        let range = NSRange(location: index, length: 0)
        self.replaceCharacters(in: range, with: string)
    }
    
    // MARK: 2.14、追加文本
    /// 追加文本
    /// - Parameter string: 要追加的文本
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func appendText(_ string: String) {
        self.insertText(string, at: self.length)
    }
    
    // MARK: 2.15、清空文本
    /// 清空文本
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func clear() {
        let range = NSRange(location: 0, length: self.length)
        self.replaceCharacters(in: range, with: "")
    }
    
    // MARK: 2.16、获取指定位置的字符
    /// 获取指定位置的字符
    /// - Parameter index: 位置索引
    /// - Returns: 字符，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func character(at index: Int) -> Character? {
        guard index >= 0, index < self.length else { return nil }
        let range = NSRange(location: index, length: 1)
        let substring = self.attributedSubstring(from: range)
        return substring.string.first
    }
    
    // MARK: 2.17、获取指定范围的子字符串
    /// 获取指定范围的子字符串
    /// - Parameter range: 范围
    /// - Returns: 子字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func substring(in range: NSRange) -> String {
        return self.attributedSubstring(from: range).string
    }
    
    // MARK: 2.18、检查是否包含指定字符串
    /// 检查是否包含指定字符串
    /// - Parameter string: 要检查的字符串
    /// - Returns: 是否包含
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func contains(_ string: String) -> Bool {
        return self.string.contains(string)
    }
    
    // MARK: 2.19、查找字符串位置
    /// 查找字符串位置
    /// - Parameter string: 要查找的字符串
    /// - Returns: 位置范围，未找到返回NSRange(location: NSNotFound, length: 0)
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func range(of string: String) -> NSRange {
        return (self.string as NSString).range(of: string)
    }
    
    // MARK: 2.20、替换所有匹配的字符串
    /// 替换所有匹配的字符串
    /// - Parameters:
    ///   - target: 目标字符串
    ///   - replacement: 替换字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func replaceAllOccurrences(of target: String, with replacement: String) {
        var range = self.range(of: target)
        while range.location != NSNotFound {
            self.replaceCharacters(in: range, with: replacement)
            let newRange = self.range(of: target)
            if newRange.location == NSNotFound {
                break
            }
            range = newRange
        }
    }
    
    // MARK: 2.21、获取行数
    /// 获取行数
    /// - Parameter width: 宽度
    /// - Returns: 行数
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func numberOfLines(width: CGFloat) -> Int {
        let size = self.size(maxSize: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let lineHeight = UIFont.systemFont(ofSize: 17).lineHeight
        return Int(ceil(size.height / lineHeight))
    }
    
    // MARK: 2.22、获取字符数
    /// 获取字符数
    /// - Returns: 字符数
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var characterCount: Int {
        return self.length
    }
    
    // MARK: 2.23、获取单词数
    /// 获取单词数
    /// - Returns: 单词数
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var wordCount: Int {
        let words = self.string.components(separatedBy: .whitespacesAndNewlines)
        return words.filter { !$0.isEmpty }.count
    }
    
    // MARK: 2.24、获取行数
    /// 获取行数
    /// - Returns: 行数
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var lineCount: Int {
        let lines = self.string.components(separatedBy: .newlines)
        return lines.count
    }
    
    // MARK: 2.25、检查是否为空
    /// 检查是否为空
    /// - Returns: 是否为空
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isEmpty: Bool {
        return self.length == 0
    }
    
    // MARK: 2.26、检查是否只包含空白字符
    /// 检查是否只包含空白字符
    /// - Returns: 是否只包含空白字符
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isBlank: Bool {
        return self.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: 2.27、去除首尾空白字符
    /// 去除首尾空白字符
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func trim() {
        let trimmedString = self.string.trimmingCharacters(in: .whitespacesAndNewlines)
        self.replaceText(self.string, with: trimmedString)
    }
    
    // MARK: 2.28、转换为大写
    /// 转换为大写
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toUppercase() {
        self.replaceText(self.string, with: self.string.uppercased())
    }
    
    // MARK: 2.29、转换为小写
    /// 转换为小写
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toLowercase() {
        self.replaceText(self.string, with: self.string.lowercased())
    }
    
    // MARK: 2.30、首字母大写
    /// 首字母大写
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func capitalize() {
        self.replaceText(self.string, with: self.string.capitalized)
    }
}
