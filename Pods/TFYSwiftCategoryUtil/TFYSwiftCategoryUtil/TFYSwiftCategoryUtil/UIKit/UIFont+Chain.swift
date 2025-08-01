//
//  UIFont+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public extension UIFont {
    
    /// 检查字体是否为粗体
    /// - Returns: 如果字体为粗体则返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isBold: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    /// 检查字体是否为斜体
    /// - Returns: 如果字体为斜体则返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isItalic: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    /// 检查字体是否为等宽字体
    /// - Returns: 如果字体为等宽字体则返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isMonoSpace: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitMonoSpace)
    }
    
    /// 将字体转换为粗斜体
    /// - Returns: 粗斜体字体，如果转换失败则返回原字体
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toBoldItalic() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) else {
            print("⚠️ UIFont: 无法创建粗斜体字体描述符")
            return self
        }
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
    
    /// 将字体转换为粗体
    /// - Returns: 粗体字体，如果转换失败则返回原字体
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toBold() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else {
            print("⚠️ UIFont: 无法创建粗体字体描述符")
            return self
        }
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
    
    /// 将字体转换为斜体
    /// - Returns: 斜体字体，如果转换失败则返回原字体
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toItalic() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            print("⚠️ UIFont: 无法创建斜体字体描述符")
            return self
        }
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
    
    /// 将字体转换为系统字体
    /// - Returns: 相同大小的系统字体
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toSystem() -> UIFont {
        return UIFont.systemFont(ofSize: self.pointSize)
    }
    
    /// 从CTFont创建UIFont对象
    /// - Parameter CTFont: Core Text字体对象
    /// - Returns: 对应的UIFont对象，如果转换失败则返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    class func fontWith(CTFont: CTFont) -> UIFont? {
        guard let name = CTFontCopyPostScriptName(CTFont) as String? else {
            print("⚠️ UIFont: 无法获取CTFont的PostScript名称")
            return nil
        }
        let size = CTFontGetSize(CTFont)
        return self.init(name: name, size: size)
    }
    
    /// 从CGFont创建UIFont对象
    /// - Parameters:
    ///   - cgFont: Core Graphics字体对象
    ///   - size: 字体大小
    /// - Returns: 对应的UIFont对象，如果转换失败则返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    class func fontWith(cgFont: CGFont, size: CGFloat) -> UIFont? {
        guard size > 0 else {
            print("⚠️ UIFont: 字体大小必须大于0")
            return nil
        }
        
        guard let name = cgFont.postScriptName as String? else {
            print("⚠️ UIFont: 无法获取CGFont的PostScript名称")
            return nil
        }
        
        return self.init(name: name, size: size)
    }
    
    /// 创建CTFont对象
    /// - Returns: 对应的CTFont对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toCTFont() -> CTFont? {
        guard !self.fontName.isEmpty else {
            print("⚠️ UIFont: 字体名称为空")
            return nil
        }
        
        let font = CTFontCreateWithName(self.fontName as CFString, self.pointSize, nil)
        return font
    }
    
    /// 创建CGFont对象
    /// - Returns: 对应的CGFont对象，如果转换失败则返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toCGFont() -> CGFont? {
        guard !self.fontName.isEmpty else {
            print("⚠️ UIFont: 字体名称为空")
            return nil
        }
        
        guard let font = CGFont(self.fontName as CFString) else {
            print("⚠️ UIFont: 无法创建CGFont")
            return nil
        }
        
        return font
    }
    
    /// 创建指定名称和大小的字体
    /// - Parameters:
    ///   - size: 字体大小，必须大于0
    ///   - name: 字体名称，如果为空或无效则使用系统字体
    /// - Returns: 指定的字体或系统字体作为后备
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func normalFont(_ size: CGFloat, _ name: String) -> UIFont {
        // 参数验证
        guard size > 0 else {
            print("⚠️ UIFont: 字体大小必须大于0，使用默认大小12")
            return UIFont.systemFont(ofSize: 12)
        }
        
        guard !name.isEmpty else {
            print("⚠️ UIFont: 字体名称为空，使用系统字体")
            return UIFont.systemFont(ofSize: size)
        }
        
        // 尝试创建指定字体
        if let font = UIFont(name: name, size: size) {
            return font
        } else {
            print("⚠️ UIFont: 无法创建字体 '\(name)'，使用系统字体")
            return UIFont.systemFont(ofSize: size)
        }
    }
}

