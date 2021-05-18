//
//  ParagraphStyle+ITools.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/5/5.
//

import Foundation
import UIKit

public extension TFY where Base == NSMutableParagraphStyle {
    
    /// 字体的行间距
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> Self {
        base.lineSpacing = lineSpacing
        return self
    }
    
    /// 文本首行缩进
    @discardableResult
    func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Self {
        base.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    
    /// （两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        base.alignment = alignment
        return self
    }
    
    /// 结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
    @discardableResult
    func lineBreakMode(_ breakMode: NSLineBreakMode) -> Self {
        base.lineBreakMode = breakMode
        return self
    }
    
    /// 整体缩进(首行除外)
    @discardableResult
    func headIndent(_ headIndent: CGFloat) -> Self {
        base.headIndent = headIndent
        return self
    }
    
    /// 距页边距到后边缘的距离；如果是负数或0，则来自其他边距
    @discardableResult
    func tailIndent(_ tailIndent: CGFloat) -> Self {
        base.tailIndent = tailIndent
        return self
    }
    
    /// 最低行高
    @discardableResult
    func minimumLineHeight(_ minimumLine: CGFloat) -> Self {
        base.minimumLineHeight = minimumLine
        return self
    }
    
    /// 最大行高
    @discardableResult
    func maximumLineHeight(_ maximunLine: CGFloat) -> Self {
        base.maximumLineHeight = maximunLine
        return self
    }
    
    /// 段与段之间的间距
    @discardableResult
    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        base.paragraphSpacing = paragraphSpacing
        return self
    }
    
    /// 段首行空白空间
    @discardableResult
    func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Self {
        base.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
    
    /// 段首行空白空间
    @discardableResult
    func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> Self {
        base.baseWritingDirection = baseWritingDirection
        return self
    }
    
    /// 在限制最小和最大线条高度之前，将自然线条高度乘以该因子（如果为正）。
    @discardableResult
    func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> Self {
        base.lineHeightMultiple = lineHeightMultiple
        return self
    }
    
    /// 在限制最小和最大线条高度之前，将自然线条高度乘以该因子（如果为正）。
    @discardableResult
    func hyphenationFactor(_ hyphenationFactor: Float) -> Self {
        base.hyphenationFactor = hyphenationFactor
        return self
    }
    
    /// 文档范围的默认选项卡间隔
    @discardableResult
    func defaultTabInterval(_ defaultTabInterval: CGFloat) -> Self {
        base.defaultTabInterval = defaultTabInterval
        return self
    }
    
    /// 一组NSTextTabs。 内容应按位置排序。 默认值是一个由12个左对齐制表符组成的数组，间隔为28pt
    @discardableResult
    func tabStops(_ tabStops: [NSTextTab]!) -> Self {
        base.tabStops = tabStops
        return self
    }
    
    /// 一个布尔值，指示系统在截断文本之前是否可以收紧字符间间距
    @discardableResult
    func allowsDefaultTighteningForTruncation(_ allowTruncation: Bool) -> Self {
        base.allowsDefaultTighteningForTruncation = allowTruncation
        return self
    }
    
}
