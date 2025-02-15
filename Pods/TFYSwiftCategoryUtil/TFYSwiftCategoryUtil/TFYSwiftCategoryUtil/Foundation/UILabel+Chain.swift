//
//  UILabel+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UILabel {

    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> TFY {
        base.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> TFY {
        base.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult
    func sizeThatFits(size:CGSize) -> CGSize {
        let sizes:CGSize = base.sizeThatFits(size)
        return sizes
    }
}

public extension TFY where Base: UILabel {
    /// 改变字段间距
    func changeFontWithTextFont(font:UIFont) {
        self.changeFontWithTextFont(font: font, text: base.text ?? "")
    }
    /// 改变行间距
    func changeFontWithTextFont(font:UIFont,text:String) {
        self.attributedString(value: font, text: text, name: NSAttributedString.Key.font)
    }
    
    /// 改变行间距
    func changeSpaceWithTextSpace(textSpace:CGFloat) {
        self.changeSpaceWithTextSpace(textSpace: textSpace, text: base.text ?? "")
    }
    /// 改变行间距
    func changeSpaceWithTextSpace(textSpace:CGFloat,text:String) {
        self.attributedString(value: textSpace, text: text, name: NSAttributedString.Key.kern)
    }
    
    /// 改变行间距
    func changeLineSpaceWithTextLineSpace(textLineSpace:CGFloat) {
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textLineSpace
        paragraphStyle.alignment = base.textAlignment
        self.changeParagraphStyleWithTextParagraphStyle(paragraphStyle: paragraphStyle)
    }

    /// 段落样式
    func changeParagraphStyleWithTextParagraphStyle(paragraphStyle:NSParagraphStyle) {
        let att:NSAttributedString = NSAttributedString(string: "")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(attributedString: base.attributedText ?? att)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, NSString(string: base.text ?? "").length))
        base.attributedText = attributedString
    }
    
    /// 改变字段颜色
    func changeColorWithTextColor(textColor:UIColor) {
        self.changeColorWithTextColor(textColor: textColor, text: base.text ?? "")
    }
    
    /// 改变字段颜色
    func changeColorWithTextColor(textColor:UIColor,text:String) {
        self.changeColorWithTextColor(textColor: textColor, texts: [text])
    }
    
    /// 改变字段颜色
    func changeColorWithTextColor(textColor:UIColor,texts:[String]) {
        texts.forEach { markContent in
            let textAttrString:NSMutableAttributedString = base.attributedText?.mutableCopy() as! NSMutableAttributedString
            var range:NSRange = NSString(string: base.text ?? "").range(of: markContent, options: NSString.CompareOptions.diacriticInsensitive)
            while range.length != NSNotFound {
                textAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
                range = NSString(string: base.text ?? "").range(of: markContent, options: NSString.CompareOptions.diacriticInsensitive, range: NSMakeRange(range.location + range.length, NSString(string: base.text ?? "").length - (range.location + range.length)))
            }
            base.attributedText = textAttrString
        }
    }
    
    /// 改变字段背景颜色
    func changeBgColorWithBgTextColor(bgTextColor:UIColor) {
        self.changeBgColorWithBgTextColor(bgTextColor: bgTextColor,text: base.text ?? "")
    }
    
    /// 改变字段背景颜色
    func changeBgColorWithBgTextColor(bgTextColor:UIColor,text:String) {
        self.attributedString(value: bgTextColor, text: text, name: NSAttributedString.Key.backgroundColor)
    }
    
    /// 改变字段连笔字 value值为1或者0
    func changeLigatureWithTextLigature(textLigature:NSNumber) {
        self.changeLigatureWithTextLigature(textLigature: textLigature, text: base.text ?? "")
    }
    
    /// 改变字段连笔字 value值为1或者0
    func changeLigatureWithTextLigature(textLigature:NSNumber,text:String) {
        self.attributedString(value: textLigature, text: text, name: NSAttributedString.Key.ligature)
    }
    
    /// 改变字间距
    func changeKernWithTextKern(textKern:NSNumber) {
        self.changeKernWithTextKern(textKern: textKern, text: base.text ?? "")
    }
    
    /// 改变字间距
    func changeKernWithTextKern(textKern:NSNumber,text:String) {
        self.attributedString(value: textKern, text: text, name: NSAttributedString.Key.kern)
    }
    
    /// 改变字的删除线
    func changeStrikethroughStyleWithTextStrikethroughStyle(textStrikethroughStyle:NSNumber) {
        self.changeStrikethroughStyleWithTextStrikethroughStyle(textStrikethroughStyle: textStrikethroughStyle, text: base.text ?? "")
    }
    
    /// 改变字的删除线
    func changeStrikethroughStyleWithTextStrikethroughStyle(textStrikethroughStyle:NSNumber,text:String) {
        self.attributedString(value: textStrikethroughStyle, text: text, name: NSAttributedString.Key.strikethroughStyle)
    }
    
    /// 改变字的删除线颜色
    func changeStrikethroughColorWithTextStrikethroughColor(textStrikethroughColor:UIColor) {
        self.changeStrikethroughColorWithTextStrikethroughColor(textStrikethroughColor: textStrikethroughColor, text: base.text ?? "")
    }
    
    /// 改变字的删除线颜色
    func changeStrikethroughColorWithTextStrikethroughColor(textStrikethroughColor:UIColor,text:String) {
        self.attributedString(value: textStrikethroughColor, text: text, name: NSAttributedString.Key.strikethroughColor)
    }
    
    /// 改变字的下划线
    func changeUnderlineStyleWithTextStrikethroughStyle(textUnderlineStyle:NSNumber) {
        self.changeUnderlineStyleWithTextStrikethroughStyle(textUnderlineStyle: textUnderlineStyle, text: base.text ?? "")
    }
    
    /// 改变字的下划线
    func changeUnderlineStyleWithTextStrikethroughStyle(textUnderlineStyle:NSNumber,text:String) {
        self.attributedString(value: textUnderlineStyle, text: text, name: NSAttributedString.Key.underlineStyle)
    }
    
    /// 改变字的下划线颜色
    func changeUnderlineColorWithTextStrikethroughColor(textUnderlineColor:UIColor) {
        self.changeUnderlineColorWithTextStrikethroughColor(textUnderlineColor: textUnderlineColor, text: base.text ?? "")
    }
    
    /// 改变字的下划线颜色
    func changeUnderlineColorWithTextStrikethroughColor(textUnderlineColor:UIColor,text:String) {
        self.attributedString(value: textUnderlineColor, text: text, name: NSAttributedString.Key.underlineColor)
    }
    
    /// 改变字的颜色
    func changeStrokeColorWithTextStrikethroughColor(textStrokeColor:UIColor) {
        self.changeStrokeColorWithTextStrikethroughColor(textStrokeColor: textStrokeColor, text: base.text ?? "")
    }
    
    /// 改变字的颜色
    func changeStrokeColorWithTextStrikethroughColor(textStrokeColor:UIColor,text:String) {
        self.attributedString(value: textStrokeColor, text: text, name: NSAttributedString.Key.strokeColor)
    }
    
    /// 改变字的描边
    func changeStrokeWidthWithTextStrikethroughWidth(textStrokeWidth:NSNumber) {
        self.changeStrokeWidthWithTextStrikethroughWidth(textStrokeWidth: textStrokeWidth, text: base.text ?? "")
    }
    
    /// 改变字的描边
    func changeStrokeWidthWithTextStrikethroughWidth(textStrokeWidth:NSNumber,text:String) {
        self.attributedString(value: textStrokeWidth, text: text, name: NSAttributedString.Key.strokeWidth)
    }
    
    
    /// 改变字的阴影
    func changeShadowWithTextShadow(textShadow:NSShadow) {
        self.changeShadowWithTextShadow(textShadow: textShadow, text: base.text ?? "")
    }
    
    /// 改变字的阴影
    func changeShadowWithTextShadow(textShadow:NSShadow,text:String) {
        self.attributedString(value: textShadow, text: text, name: NSAttributedString.Key.shadow)
    }
    
    /// 改变字的特殊效果
    func changeTextEffectWithTextEffect(textEffect:String) {
        self.changeTextEffectWithTextEffect(textEffect: textEffect, text: base.text ?? "")
    }
    
    
    /// 改变字的特殊效果
    func changeTextEffectWithTextEffect(textEffect:String,text:String) {
        self.attributedString(value: textEffect, text: text, name: NSAttributedString.Key.textEffect)
    }
    
    /// 改变字的文本附件
    func changeAttachmentWithTextAttachment(textAttachment:NSTextAttachment) {
        self.changeAttachmentWithTextAttachment(textAttachment: textAttachment, text: base.text ?? "")
    }
    
    /// 改变字的文本附件
    func changeAttachmentWithTextAttachment(textAttachment:NSTextAttachment,text:String) {
        self.attributedString(value: textAttachment, text: text, name: NSAttributedString.Key.attachment)
    }
    
    /// 改变字的链接
    func changeLinkWithTextLink(textLink:String) {
        self.changeLinkWithTextLink(textLink: textLink, text: base.text ?? "")
    }
    
    /// 改变字的链接
    func changeLinkWithTextLink(textLink:String,text:String) {
        self.attributedString(value: textLink, text: text, name: NSAttributedString.Key.link)
    }
    
    /// 改变字的基准线偏移 value>0坐标往上偏移 value<0坐标往下偏移
    func changeBaselineOffsetWithTextBaselineOffset(textBaselineOffset:NSNumber) {
        self.changeBaselineOffsetWithTextBaselineOffset(textBaselineOffset: textBaselineOffset, text: base.text ?? "")
    }
    
    /// 改变字的基准线偏移 value>0坐标往上偏移 value<0坐标往下偏移
    func changeBaselineOffsetWithTextBaselineOffset(textBaselineOffset:NSNumber,text:String) {
        self.attributedString(value: textBaselineOffset, text: text, name: NSAttributedString.Key.baselineOffset)
    }
    
    /// 改变字的倾斜 value>0向右倾斜 value<0向左倾斜
    func changeObliquenessWithTextObliqueness(textObliqueness:NSNumber) {
        self.changeObliquenessWithTextObliqueness(textObliqueness: textObliqueness, text: base.text ?? "")
    }
    
    /// 改变字的倾斜 value>0向右倾斜 value<0向左倾斜
    func changeObliquenessWithTextObliqueness(textObliqueness:NSNumber,text:String) {
        self.attributedString(value: textObliqueness, text: text, name: NSAttributedString.Key.obliqueness)
    }
    
    /// 改变字粗细 0就是不变 >0加粗 <0加细
    func changeExpansionsWithTextExpansion(textExpansion:NSNumber) {
        self.changeExpansionsWithTextExpansion(textExpansion: textExpansion, text:base.text ?? "")
    }
    
    /// 改变字粗细 0就是不变 >0加粗 <0加细
    func changeExpansionsWithTextExpansion(textExpansion:NSNumber,text:String) {
        self.attributedString(value: textExpansion, text: text, name: NSAttributedString.Key.expansion)
    }
    
    /// 改变字方向 NSWritingDirection
    func changeWritingDirectionWithTextExpansion(textWritingDirection:[Any],text:String) {
        self.attributedString(value: textWritingDirection, text: text, name: NSAttributedString.Key.writingDirection)
    }
    
    /// 改变字的水平或者竖直 1竖直 0水平
    func changeVerticalGlyphFormWithTextVerticalGlyphForm(textVerticalGlyphForm:NSNumber,text:String) {
        self.attributedString(value: textVerticalGlyphForm, text: text, name: NSAttributedString.Key.verticalGlyphForm)
    }
    
    /// 改变字的两端对齐
    func changeCTKernWithTextCTKern(textCTKern:NSNumber) {
        let att:NSAttributedString = NSAttributedString(string: "")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(attributedString: base.attributedText ?? att)
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: textCTKern, range: NSMakeRange(0, NSString(string: base.text ?? "").length-1))
        base.attributedText = attributedString
    }
    
    /// 为UILabel首部设置图片标签
    func changeImage(text:String,images:[UIImage],imageSpan:CGFloat) {
        
        let textAttrStr:NSMutableAttributedString = NSMutableAttributedString()
        images.forEach { image in
            let attach:NSTextAttachment = NSTextAttachment()
            attach.image = image
            let imgH:CGFloat = base.font.pointSize
            let imgW:CGFloat = (image.size.width / image.size.height) * imgH
            let textPaddingTop:CGFloat = (base.font.lineHeight - base.font.pointSize) / 2
            attach.bounds = CGRect(x: 0, y: -textPaddingTop, width: imgW, height: imgH)
            
            let imgStr:NSAttributedString = NSAttributedString(attachment: attach)
            textAttrStr.append(imgStr)
            textAttrStr.append(NSAttributedString(string: " "))
        }
        
        textAttrStr.append(NSAttributedString(string: text))
                           
        if imageSpan != 0 {
            textAttrStr.addAttribute(NSAttributedString.Key.kern, value: imageSpan, range: NSMakeRange(0, images.count * 2))
        }
        base.attributedText = textAttrStr
    }
    
    private func attributedString(value:Any,text:String,name:NSAttributedString.Key) {
        let att:NSAttributedString = NSAttributedString(string: "")
        let options: NSString.CompareOptions = [.caseInsensitive,.backwards,.diacriticInsensitive,.widthInsensitive]
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(attributedString: base.attributedText ?? att)
        let textRange:NSRange = NSString(string: base.text ?? "").range(of: text, options: options)
        if textRange.location != NSNotFound {
            attributedString.addAttribute(name, value: value, range: textRange)
        }
        base.attributedText = attributedString
    }
    
}
