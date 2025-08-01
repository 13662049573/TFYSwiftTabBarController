//
//  NSAttributedString+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//  用途：NSAttributedString 链式编程扩展，支持富文本样式设置、图片插入等功能。
//

import Foundation
import UIKit

// MARK: - 一、文本设置的基本扩展
public extension TFY where Base: NSAttributedString {

    // MARK: 1.1、设置特定区域的字体大小
    /// 设置特定区域的字体大小
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 区域
    /// - Returns: 返回设置后的富文本
    func setRangeFontText(font: UIFont, range: NSRange) -> NSAttributedString {
        return setSpecificRangeTextMoreAttributes(attributes: [NSAttributedString.Key.font : font], range: range)
    }
    
    // MARK: 1.2、设置特定文字的字体大小
    /// 设置特定文字的字体大小
    /// - Parameters:
    ///   - text: 特定文字
    ///   - font: 字体
    /// - Returns: 返回设置后的富文本
    func setSpecificTextFont(_ text: String, font: UIFont) -> NSAttributedString {
        return setSpecificTextMoreAttributes(text, attributes: [NSAttributedString.Key.font : font])
    }
    
    // MARK: 1.3、设置特定区域的字体颜色
    /// 设置特定区域的字体颜色
    /// - Parameters:
    ///   - color: 字体颜色
    ///   - range: 区域
    /// - Returns: 返回设置后的富文本
    func setSpecificRangeTextColor(color: UIColor, range: NSRange) -> NSAttributedString {
        return setSpecificRangeTextMoreAttributes(attributes: [NSAttributedString.Key.foregroundColor : color], range: range)
    }
    
    // MARK: 1.4、设置特定文字的字体颜色
    /// 设置特定文字的字体颜色
    /// - Parameters:
    ///   - text: 特定文字
    ///   - color: 字体颜色
    /// - Returns: 返回设置后的富文本
    func setSpecificTextColor(_ text: String, color: UIColor) -> NSAttributedString {
        return setSpecificTextMoreAttributes(text, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    // MARK: 1.5、设置特定区域行间距
    /// 设置特定区域行间距
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - alignment: 对齐方式
    ///   - range: 区域
    /// - Returns: 返回设置后的富文本
    func setSpecificRangeTextLineSpace(lineSpace: CGFloat, alignment: NSTextAlignment, range: NSRange) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = alignment
        
        return setSpecificRangeTextMoreAttributes(attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
    }
    
    // MARK: 1.6、设置特定文字行间距
    /// 设置特定文字行间距
    /// - Parameters:
    ///   - text: 特定的文字
    ///   - lineSpace: 行间距
    ///   - alignment: 对齐方式
    /// - Returns: 返回设置后的富文本
    func setSpecificTextLineSpace(_ text: String, lineSpace: CGFloat, alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = alignment
        return setSpecificTextMoreAttributes(text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    // MARK: 1.7、设置特定区域的下划线
    /// 设置特定区域的下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式，默认单下划线
    ///   - range: 特定区域范围
    /// - Returns: 返回设置后的富文本
    func setSpecificRangeUnderLine(color: UIColor, stytle: NSUnderlineStyle = .single, range: NSRange) -> NSAttributedString {
        // 下划线样式
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return setSpecificRangeTextMoreAttributes(attributes: [NSAttributedString.Key.underlineStyle: lineStytle, NSAttributedString.Key.underlineColor: color], range: range)
    }
    
    // MARK: 1.8、设置特定文字的下划线
    /// 设置特定文字的下划线
    /// - Parameters:
    ///   - text: 特定文字
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式，默认单下划线
    /// - Returns: 返回设置后的富文本
    func setSpecificTextUnderLine(_ text: String, color: UIColor, stytle: NSUnderlineStyle = .single) -> NSAttributedString {
        // 下划线样式
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return setSpecificTextMoreAttributes(text, attributes: [NSAttributedString.Key.underlineStyle : lineStytle, NSAttributedString.Key.underlineColor: color])
    }
    
    // MARK: 1.9、设置特定区域的删除线
    /// 设置特定区域的删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 范围
    /// - Returns: 返回设置后的富文本
    func setSpecificRangeDeleteLine(color: UIColor, range: NSRange) -> NSAttributedString {
        var attributes = Dictionary<NSAttributedString.Key, Any>()
        // 删除线样式
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color
        
        let version = UIDevice.tfy.currentSystemVersion as NSString
        if version.floatValue >= 10.3 {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else if version.floatValue <= 9.0 {
            attributes[NSAttributedString.Key.strikethroughStyle] = []
        }
        return setSpecificRangeTextMoreAttributes(attributes: attributes, range: range)
    }
    
    // MARK: 1.10、设置特定文字的删除线
    /// 设置特定文字的删除线
    /// - Parameters:
    ///   - text: 特定文字
    ///   - color: 删除线颜色
    /// - Returns: 返回设置后的富文本
    func setSpecificTextDeleteLine(_ text: String, color: UIColor) -> NSAttributedString {
        var attributes = Dictionary<NSAttributedString.Key, Any>()
        // 删除线样式
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color
        
        let version = UIDevice.tfy.currentSystemVersion as NSString
        if version.floatValue >= 10.3 {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else if version.floatValue <= 9.0 {
            attributes[NSAttributedString.Key.strikethroughStyle] = []
        }
        return setSpecificTextMoreAttributes(text, attributes: attributes)
    }
    
    // MARK: 1.11、插入图片
    /// 插入图片
    /// - Parameters:
    ///   - imgName: 要添加的图片名称，如果是网络图片，需要传入完整路径名，且imgBounds必须传值
    ///   - imgBounds: 图片的大小，默认为.zero，即自动根据图片大小设置，并以底部基线为标准。 y > 0 ：图片向上移动；y < 0 ：图片向下移动
    ///   - imgIndex: 图片的位置，默认放在开头
    /// - Returns: 返回设置后的富文本
    func insertImage(imgName: String, imgBounds: CGRect = .zero, imgIndex: Int = 0) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self.base)
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        attch.image = loadImage(imageName: imgName)
        attch.bounds = imgBounds
        // 创建带有图片的富文本
        let string = NSAttributedString(attachment: attch)
        // 将图片添加到富文本
        attributedString.insert(string, at: imgIndex)
        return attributedString
    }
    
    // MARK: 1.12、首行缩进
    /// 首行缩进
    /// - Parameter edge: 缩进宽度
    /// - Returns: 返回设置后的富文本
    func firstLineLeftEdge(_ edge: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = edge
        return setSpecificRangeTextMoreAttributes(attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.base.length))
    }
    
    // MARK: 1.13、设置特定区域的多个字体属性
    /// 设置特定区域的多个字体属性
    /// - Parameters:
    ///   - attributes: 字体属性
    ///   - range: 特定区域
    /// - Returns: 返回设置后的富文本
    func setSpecificRangeTextMoreAttributes(attributes: Dictionary<NSAttributedString.Key, Any>, range: NSRange) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self.base)
        
        // 检查 range 是否越界
        let validRange = NSRange(location: range.location, length: min(range.length, self.base.length - range.location))
        guard validRange.location >= 0 && validRange.length > 0 && validRange.location + validRange.length <= self.base.length else {
            return self.base
        }
        
        for name in attributes.keys {
            if let value = attributes[name] {
                mutableAttributedString.addAttribute(name, value: value, range: validRange)
            }
        }
        return mutableAttributedString
    }

    // MARK: 1.14、设置特定文字的多个字体属性
    /// 设置特定文字的多个字体属性
    /// - Parameters:
    ///   - text: 特定文字
    ///   - attributes: 字体属性
    /// - Returns: 返回设置后的富文本
    func setSpecificTextMoreAttributes(_ text: String, attributes: Dictionary<NSAttributedString.Key, Any>) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self.base)
        let rangeArray = getStringRangeArray(with: [text])
        if !rangeArray.isEmpty {
            for name in attributes.keys {
                for range in rangeArray {
                    mutableAttributedString.addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return mutableAttributedString
    }
    
    // MARK: 1.15、设置特定区域的倾斜
    /// 设置特定区域的倾斜
    /// - Parameters:
    ///   - inclination: 倾斜度
    ///   - range: 特定区域范围
    /// - Returns: 返回设置后的富文本
    func setSpecificRangeBliqueness(inclination: Float = 0, range: NSRange) -> NSAttributedString {
        return setSpecificRangeTextMoreAttributes(attributes: [NSAttributedString.Key.obliqueness: inclination], range: range)
    }
    
    // MARK: 1.16、设置特定文字的倾斜
    /// 设置特定文字的倾斜
    /// - Parameters:
    ///   - text: 特定文字
    ///   - inclination: 倾斜度
    /// - Returns: 返回设置后的富文本
    func setSpecificTextBliqueness(_ text: String, inclination: Float = 0) -> NSAttributedString {
        return setSpecificTextMoreAttributes(text, attributes: [NSAttributedString.Key.obliqueness : inclination])
    }
}

// MARK: - Private Func
public extension TFY where Base: NSAttributedString {
    /// 获取对应字符串的range数组
    /// - Parameter textArray: 字符串数组
    /// - Returns: range数组
    private func getStringRangeArray(with textArray: Array<String>) -> Array<NSRange> {
        var rangeArray = Array<NSRange>()
        // 遍历
        for str in textArray {
            if base.string.contains(str) {
                let subStrArr = base.string.components(separatedBy: str)
                var subStrIndex = 0
                for i in 0 ..< (subStrArr.count - 1) {
                    let subDivisionStr = subStrArr[i]
                    if i == 0 {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2)
                    } else {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2 + str.lengthOfBytes(using: .unicode) / 2)
                    }
                    let newRange = NSRange(location: subStrIndex, length: str.count)
                    rangeArray.append(newRange)
                }
            }
        }
        return rangeArray
    }

    // MARK: 加载网络图片
    /// 加载网络图片
    /// - Parameter imageName: 图片名
    /// - Returns: 图片
    private func loadImage(imageName: String) -> UIImage? {
        if imageName.hasPrefix("http://") || imageName.hasPrefix("https://") {
            let imageURL = URL(string: imageName)
            var imageData: Data? = nil
            do {
                imageData = try Data(contentsOf: imageURL!)
                return UIImage(data: imageData!)!
            } catch {
                return nil
            }
        }
        return UIImage(named: imageName)!
    }
}

public extension TFY where Base: NSMutableParagraphStyle{
    
    func lineSpacingChain(_ value: CGFloat) -> Self {
        base.lineSpacing = value
        return self
    }
    
    func paragraphSpacingChain(_ value: CGFloat) -> Self {
        base.paragraphSpacing = value
        return self
    }
    
    func alignmentChain(_ value: NSTextAlignment) -> Self {
        base.alignment = value
        return self
    }
    
    func firstLineHeadIndentChain(_ value: CGFloat) -> Self {
        base.firstLineHeadIndent = value
        return self
    }
    
    func headIndentChain(_ value: CGFloat) -> Self {
        base.headIndent = value
        return self
    }
    
    func tailIndentChain(_ value: CGFloat) -> Self {
        base.tailIndent = value
        return self
    }
    
    func lineBreakModeChain(_ value: NSLineBreakMode) -> Self {
        base.lineBreakMode = value
        return self
    }
    
    func minimumLineHeightChain(_ value: CGFloat) -> Self {
        base.minimumLineHeight = value
        return self
    }
    
    func maximumLineHeightChain(_ value: CGFloat) -> Self {
        base.maximumLineHeight = value
        return self
    }
    
    func baseWritingDirectionChain(_ value: NSWritingDirection) -> Self {
        base.baseWritingDirection = value
        return self
    }
    
    func lineHeightMultipleChain(_ value: CGFloat) -> Self {
        base.lineHeightMultiple = value
        return self
    }
    
    func paragraphSpacingBeforeChain(_ value: CGFloat) -> Self {
        base.paragraphSpacingBefore = value
        return self
    }
    
    func hyphenationFactorChain(_ value: Float) -> Self {
        base.hyphenationFactor = value
        return self
    }
    
    func tabStopsChain(_ value: [NSTextTab]) -> Self {
        base.tabStops = value
        return self
    }
    
    func defaultTabIntervalChain(_ value: CGFloat) -> Self {
        base.defaultTabInterval = value
        return self
    }
    
    func allowsDefaultTighteningForTruncationChain(_ value: Bool) -> Self {
        base.allowsDefaultTighteningForTruncation = value
        return self
    }
    
    func lineBreakStrategyChain(_ value: NSParagraphStyle.LineBreakStrategy) -> Self {
        base.lineBreakStrategy = value
        return self
    }
        
    func addTabStopChain(_ value: NSTextTab) -> Self {
        base.addTabStop(value)
        return self
    }
    
    func removeTabStopChain(_ value: NSTextTab) -> Self {
        base.removeTabStop(value)
        return self
    }
    
    func setParagraphStyleChain(_ value: NSParagraphStyle) -> Self {
        base.setParagraphStyle(value)
        return self
    }
}

@objc public extension NSAttributedString{
    ///获取所有的 [Range: NSAttributedString] 集合
    var rangeSubAttStringDic: [String: NSAttributedString] {
        var dic = [String: NSAttributedString]()
        enumerateAttributes(in: NSMakeRange(0, self.length), options: .longestEffectiveRangeNotRequired) { (attrs, range, _) in
            let sub = self.attributedSubstring(from: range)
            dic[NSStringFromRange(range)] = sub
        }
        return dic
    }
        
    /// 富文本段落设置
    static func paraDict(_ font: UIFont = UIFont.systemFont(ofSize: 15.adap), textColor: UIColor = .black, alignment: NSTextAlignment = .left, lineSpacing: CGFloat = 0, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> [NSAttributedString.Key: Any] {
        let paraStyle = NSMutableParagraphStyle()
            .tfy
            .lineBreakModeChain(lineBreakMode)
            .lineSpacingChain(lineSpacing)
            .alignmentChain(alignment)
            .build

        let dic: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .backgroundColor:UIColor.clear,
            .paragraphStyle: paraStyle,
        ]
        return dic
    }
    
    /// 创建富文本
    static func create(_ text: String, textTaps: [String], font: UIFont = UIFont.systemFont(ofSize: 15.adap), tapFont: UIFont = UIFont.systemFont(ofSize: 15.adap), color: UIColor = .black, tapColor: UIColor = .blue, alignment: NSTextAlignment = .left, lineSpacing: CGFloat = 0, lineBreakMode: NSLineBreakMode = .byWordWrapping, rangeOptions mask: NSString.CompareOptions = []) -> NSAttributedString {
        let paraDic = paraDict(font, textColor: color, alignment: alignment, lineSpacing: lineSpacing, lineBreakMode: lineBreakMode)
        
        let linkDic: [NSAttributedString.Key: Any] = [
            .font: tapFont,
            .foregroundColor: tapColor,
            .backgroundColor: UIColor.clear,
        ]

        let attString = NSMutableAttributedString(string: text, attributes: paraDic)
        for e in textTaps {
            let nsRange = (attString.string as NSString).range(of: e, options: mask)
            attString.addAttributes(linkDic, range: nsRange)
        }
        return attString
    }
    
    /// 创建超链接富文本
    static func createLink(_ text: String, dic: [String: String], font: UIFont) -> NSMutableAttributedString {
        let attDic: [NSAttributedString.Key: Any] = [
            .font: font as Any
        ]
        let mattString = NSMutableAttributedString(string: text, attributes: attDic)
        dic.forEach { e in
            let linkAttDic: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.blue,
                .link: e.value,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]
            
            let attStr = NSAttributedString(string: e.key, attributes: linkAttDic)
            let range = (mattString.string as NSString).range(of: e.key)
            mattString.replaceCharacters(in: range, with: attStr)
        }
        return mattString
    }
    
    /// nsRange范围子字符串差异华显示
    static func attString(_ text: String, nsRange: NSRange, font: UIFont = UIFont.systemFont(ofSize: 15.adap), tapColor: UIColor = .black) -> NSAttributedString {
        assert((nsRange.location + nsRange.length) <= text.count)

        let attDic: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: tapColor,
        ]

        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttributes(attDic, range: nsRange)
        return attrString
    }
    
    ///  富文本只有同字体大小才能计算高度
    func size(with width: CGFloat) -> CGSize {
        var size = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil).size
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        return size
    }
    
}


public extension NSAttributedString{
    convenience init(data: Data, documentType: DocumentType, encoding: String.Encoding = .utf8) throws {
        try self.init(data: data,
                      options: [.documentType: documentType,
                                .characterEncoding: encoding.rawValue],
                      documentAttributes: nil)
    }
    convenience init(html data: Data) throws {
        try self.init(data: data, documentType: .html)
    }
    convenience init(txt data: Data) throws {
        try self.init(data: data, documentType: .plain)
    }
    convenience init(rtf data: Data) throws {
        try self.init(data: data, documentType: .rtf)
    }
    convenience init(rtfd data: Data) throws {
        try self.init(data: data, documentType: .rtfd)
    }
    
    func attributes(at index: Int) -> (NSRange, [NSAttributedString.Key: Any]) {
        var nsRange = NSMakeRange(0, 0)
        let dic = attributes(at: index, effectiveRange: &nsRange)
        return (nsRange, dic)
    }
}

// MARK: - Operators

public extension NSAttributedString {
    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }
    
    /// Add a NSAttributedString to another NSAttributedString.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
    /// Add a NSAttributedString to another NSAttributedString.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
}

public extension NSMutableAttributedString{
    ///获取或者替换某一段NSAttributedString
    subscript(index: NSInteger) -> NSAttributedString?{
        get {
            let keys = rangeSubAttStringDic.keys.sorted()
            if index < 0 || index >= keys.count {
                return nil
            }
            let key = keys[index]
            return rangeSubAttStringDic[key]
        }
        set {
            guard let newValue = newValue else { return }
            let keys = rangeSubAttStringDic.keys.sorted()
            if index < 0 || index >= keys.count {
                return
            }
            let key = keys[index]
            replaceCharacters(in: NSRangeFromString(key), with: newValue)
        }
    }
    
    /// 字符串添加前缀
    func appendPrefix(_ prefix: String = "*", color: UIColor = UIColor.red, font: UIFont) -> Self{
        guard let range = self.string.range(of: prefix) else {
            let attr = NSAttributedString(string: prefix,
                                          attributes: [NSAttributedString.Key.foregroundColor: color,
                                                       NSAttributedString.Key.font: font
                                          ])
            self.insert(attr, at: 0)
            return self
        }

        let nsRange = NSRange(range, in: self.string)
        addAttributes([NSAttributedString.Key.foregroundColor: color,
                       NSAttributedString.Key.font: font
        ], range: nsRange)
        return self
    }
    
    /// 字符串添加后缀
    func appendSuffix(_ suffix: String = "*", color: UIColor = UIColor.red, font:UIFont) -> Self{
        guard let range = self.string.range(of: suffix, options: .backwards) else {
            let attr = NSAttributedString(string: suffix,
                                          attributes: [NSAttributedString.Key.foregroundColor: color,
                                                       NSAttributedString.Key.font: font
                                          ])
            self.append(attr)
            return self
        }
        
        let nsRange = NSRange(range, in: self.string)
        addAttributes([NSAttributedString.Key.foregroundColor: color,
                       NSAttributedString.Key.font: font
        ], range: nsRange)
        return self
    }
}


public extension String {
    
    /// -> NSMutableAttributedString
    var matt: NSMutableAttributedString{
        return NSMutableAttributedString(string: self)
    }
    
}


@objc public extension NSAttributedString {
    
    /// -> NSMutableAttributedString
    var matt: NSMutableAttributedString{
        return NSMutableAttributedString(attributedString: self)
    }
    
}

