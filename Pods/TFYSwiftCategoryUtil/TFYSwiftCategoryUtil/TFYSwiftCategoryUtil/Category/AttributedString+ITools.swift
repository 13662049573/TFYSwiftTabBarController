//
//  AttributedString+ITools.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/5/5.
//

import Foundation
import UIKit

public extension TFY where Base == NSMutableAttributedString {
    
    /// 字体大小
    @discardableResult
    func fontName(_ font: UIFont,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        return self
    }
    
    /// 字体间距
    @discardableResult
    func kernName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.kern, value: value, range: range)
        return self
    }
    
    /// 字体颜色
    @discardableResult
    func foregroundColorName(_ color: UIColor,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return self
    }
    
    /// 字符连体
    @discardableResult
    func ligatureName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.ligature, value: value, range: range)
        return self
    }
    
    /// 段落格式
    @discardableResult
    func paragraphStyleName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.paragraphStyle, value: value, range: range)
        return self
    }
    
    /// 背景颜色
    @discardableResult
    func backgroundColorName(_ color: UIColor,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
        return self
    }
    
    /// 删除线格式
    @discardableResult
    func strikethroughStyleName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.strikethroughStyle, value: value, range: range)
        return self
    }
    
    /// 删除线格式颜色
    @discardableResult
    func strikethroughColor(_ color: UIColor,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: range)
        return self
    }
    
    /// 下划线
    @discardableResult
    func underlineStyleName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.underlineStyle, value: value, range: range)
        return self
    }
    
    /// 下划线颜色
    @discardableResult
    func underlineColor(_ color: UIColor,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
        return self
    }
    
    /// 描绘边颜色
    @discardableResult
    func strokeColorName(_ color: UIColor,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.strokeColor, value: color, range: range)
        return self
    }
    
    /// 描边宽度，value是NSNumber
    @discardableResult
    func strokeWidthName(_ value: NSNumber,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.strokeWidth, value: value, range: range)
        return self
    }
    
    /// 阴影，value是NSShadow对象
    @discardableResult
    func shadowName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.shadow, value: value, range: range)
        return self
    }
    
    /// 文字效果，value是NSString
    @discardableResult
    func textEffectName(_ value: String,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.textEffect, value: value, range: range)
        return self
    }
    
    /// 附属，value是NSTextAttachment 对象
    @discardableResult
    func attachmentName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.attachment, value: value, range: range)
        return self
    }
    
    /// 链接，value是NSURL or NSString
    @discardableResult
    func linkName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.link, value: value, range: range)
        return self
    }
    
    /// NSNumber包含浮点值，以点为单位;基线偏移量，默认为0
    @discardableResult
    func baselineOffsetName(_ value:NSNumber,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.baselineOffset, value: value, range: range)
        return self
    }
    
    /// 字体倾斜
    @discardableResult
    func obliquenessName(_ value: Any, range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.obliqueness, value: value, range: range)
        return self
    }
    
    /// 字体扁平化
    @discardableResult
    func expansionName(_ value: Any,range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.expansion, value: value, range: range)
        return self
    }
    
    /// 垂直或者水平，value是 NSNumber，0表示水平，1垂直
    @discardableResult
    func verticalGlyphFormName(_ value: NSNumber, range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: value, range: range)
        return self
    }
    
    /// 文字的书写方向
    @discardableResult
    func writingDirectionName(_ value: NSArray, range: NSRange) -> Self {
        base.addAttribute(NSAttributedString.Key.writingDirection, value: value, range: range)
        return self
    }
    
    /// 删除不需要的约束
    @discardableResult
    func removeAttributeStringKey(_ value: NSAttributedString.Key,range: NSRange) -> Self {
        base.removeAttribute(value, range: range)
        return self
    }
    
    /// 替换属性字符串中某个位置,某个长度的字符串;
    @discardableResult
    func replacewithString(_ value: String, range: NSRange) -> Self {
        base.replaceCharacters(in: range, with: value)
        return self
    }
    
    /// 替换属性<NSAttributedString>中某个位置,某个长度的字符串;或者从某个属性字符串某个位置插入.
    @discardableResult
    func replaceAttributedString(_ value: NSAttributedString, range: NSRange) -> Self {
        base.replaceCharacters(in: range, with: value)
        return self
    }
    
    /// 或者从某个属性字符串某个位置插入.
    @discardableResult
    func insertString(_ attrString: NSAttributedString, value: Int) -> Self {
        base.insert(attrString, at: value)
        return self
    }
    
    /// 添加新的参数
    @discardableResult
    func appendString(attrString: NSAttributedString) -> Self {
        base.append(attrString)
        return self
    }
    
    /// 删除对应的长度
    @discardableResult
    func deleteInRange(range: NSRange) -> Self {
        base.deleteCharacters(in: range)
        return self
    }
}

