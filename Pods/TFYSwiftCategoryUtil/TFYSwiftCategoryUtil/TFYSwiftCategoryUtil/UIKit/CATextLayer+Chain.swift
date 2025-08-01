//
//  CATextLayer+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit
/**
 CATextLayer 使用Core Text 进行绘制，渲染速度比使用 Web Kit 的 UILable 快很多。而且 UILable 主要是管理内容，而 CATextLayer 则是绘制内容。
 */
// MARK: - 一、基本的链式编程 扩展
public extension CATextLayer {
    
    // MARK: 1.1、设置文字的内容
    /// 设置文字的内容
    /// - Parameter text: 文字内容，不能为空
    /// - Returns: 返回自身
    @discardableResult
    func text(_ text: String) -> Self {
        self.string = text
        return self
    }
    
    // MARK: 1.2、设置 NSAttributedString 文字
    /// 设置 NSAttributedString 文字
    /// - Parameter attributedText: NSAttributedString 文字，不能为空
    /// - Returns: 返回自身
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        self.string = attributedText
        return self
    }
    
    // MARK: 1.3、自动换行，默认NO
    /// 自动换行，默认NO
    /// - Parameter isWrapped: 是否自动换行
    /// - Returns: 返回自身
    @discardableResult
    func isWrapped(_ isWrapped: Bool) -> Self {
        self.isWrapped = isWrapped
        return self
    }
    
    // MARK: 1.4、当文本显示不全时的裁剪方式
    /// 当文本显示不全时的裁剪方式
    /// - Parameter truncationMode: 裁剪方式
    /// none 不剪裁，默认
    /// start 剪裁开始部分
    /// end 剪裁结束部分
    /// middle 剪裁中间部分
    /// - Returns: 返回自身
    @discardableResult
    func truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        self.truncationMode = truncationMode
        return self
    }
    
    // MARK: 1.5、文本显示模式：左 中 右
    /// 文本显示模式：左 中 右
    /// - Parameter alignment: 文本显示模式
    /// - Returns: 返回自身
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        switch alignment {
        case .left:
            self.alignmentMode = .left
        case .right:
            self.alignmentMode = .right
        case .center:
            self.alignmentMode = .center
        case .natural:
            self.alignmentMode = .natural
        case .justified:
            self.alignmentMode = .justified
        default:
            self.alignmentMode = .left
        }
        return self
    }
    
    // MARK: 1.6、设置字体的颜色
    /// 设置字体的颜色
    /// - Parameter color: 字体的颜色，不能为空
    /// - Returns: 返回自身
    @discardableResult
    func color(_ color: UIColor) -> Self {
        self.foregroundColor = color.cgColor
        return self
    }
    
    // MARK: 1.7、设置字体的颜色(十六进制)
    /// 设置字体的颜色(十六进制)
    /// - Parameter hex: 十六进制字符串颜色，不能为空
    /// - Returns: 返回自身
    @discardableResult
    func color(_ hex: String) -> Self {
        guard let cgColor = UIColor(hexString: hex)?.cgColor else {
            TFYUtils.Logger.log("⚠️ CATextLayer: 颜色十六进制字符串无效")
            return self
        }
        self.foregroundColor = cgColor
        return self
    }
    
    // MARK: 1.8、设置字体的大小
    /// 设置字体的大小
    /// - Parameter fontSize: 字体的大小，必须大于0
    /// - Returns: 返回自身
    @discardableResult
    func font(_ fontSize: CGFloat) -> Self {
        guard fontSize > 0 else {
            TFYUtils.Logger.log("⚠️ CATextLayer: 字体大小必须大于0")
            return self
        }
        self.fontSize = fontSize
        if #available(iOS 9.0, *) {
            self.font = CTFontCreateWithName("PingFangSC-Regular" as CFString, fontSize, nil)
        }
        self.contentsScale = UIScreen.main.scale
        return self
    }
    
    // MARK: 1.9、设置字体的Font
    /// 设置字体的Font
    /// - Parameter font: 字体的Font，不能为空
    /// - Returns: 返回自身
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        self.contentsScale = UIScreen.main.scale
        return self
    }
    
    // MARK: 1.10、设置字体粗体
    /// 设置字体粗体
    /// - Parameter boldfontSize: 粗体字体大小，必须大于0
    /// - Returns: 返回自身
    @discardableResult
    func boldFont(_ boldfontSize: CGFloat) -> Self {
        guard boldfontSize > 0 else {
            TFYUtils.Logger.log("⚠️ CATextLayer: 粗体字体大小必须大于0")
            return self
        }
        self.fontSize = boldfontSize
        if #available(iOS 9.0, *) {
            self.font = CTFontCreateWithName("PingFangSC-Medium" as CFString, boldfontSize, nil)
        } else {
            self.font = CTFontCreateWithName("Helvetica-bold" as CFString, boldfontSize, nil)
        }
        self.contentsScale = UIScreen.main.scale
        return self
    }
    
    // MARK: 1.11、设置行间距
    /// 设置行间距
    /// - Parameter lineSpacing: 行间距
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        if let attributedString = self.string as? NSAttributedString {
            let mutableString = NSMutableAttributedString(attributedString: attributedString)
            mutableString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: mutableString.length))
            self.string = mutableString
        } else if let string = self.string as? String {
            let attributedString = NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle])
            self.string = attributedString
        }
        
        return self
    }
    
    // MARK: 1.12、设置文本阴影
    /// 设置文本阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - radius: 阴影半径
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func textShadow(color: UIColor, offset: CGSize, radius: CGFloat) -> Self {
        self.shadowColor = color.cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = 1.0
        return self
    }
    
    // MARK: 1.13、设置背景色
    /// 设置背景色
    /// - Parameter color: 背景颜色
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color.cgColor
        return self
    }
    
    // MARK: 1.14、设置边框
    /// 设置边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func border(color: UIColor, width: CGFloat) -> Self {
        self.borderColor = color.cgColor
        self.borderWidth = width
        return self
    }
    
    // MARK: 1.15、设置圆角
    /// 设置圆角
    /// - Parameter radius: 圆角半径
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        self.cornerRadius = radius
        self.masksToBounds = true
        return self
    }
    
    // MARK: 1.16、设置透明度
    /// 设置透明度
    /// - Parameter opacity: 透明度值（0-1）
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func opacity(_ opacity: Float) -> Self {
        self.opacity = opacity
        return self
    }
    
    // MARK: 1.17、设置是否隐藏
    /// 设置是否隐藏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
    
    // MARK: 1.18、设置位置和大小
    /// 设置位置和大小
    /// - Parameter frame: 位置和大小
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    // MARK: 1.19、设置锚点
    /// 设置锚点
    /// - Parameter anchorPoint: 锚点
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func anchorPoint(_ anchorPoint: CGPoint) -> Self {
        self.anchorPoint = anchorPoint
        return self
    }
    
    // MARK: 1.20、设置变换
    /// 设置变换
    /// - Parameter transform: 变换矩阵
    /// - Returns: 返回自身
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func transform(_ transform: CATransform3D) -> Self {
        self.transform = transform
        return self
    }
}
