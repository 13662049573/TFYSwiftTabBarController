//
//  UIFont+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public extension UIFont {
    
    /// check if font is bold
    var isBold: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    /// check if font is italic
    var isItalic: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    /// check if font is monoSpace
    var isMonoSpace: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitMonoSpace)
    }
    
    /// change the font to bold and italic
    func toBoldItalic() -> UIFont {
        return UIFont(descriptor: self.fontDescriptor.withSymbolicTraits([UIFontDescriptor.SymbolicTraits.traitBold, UIFontDescriptor.SymbolicTraits.traitItalic])!, size: self.pointSize)
    }
    
    /// change the font to bold
    func toBold() -> UIFont {
        return UIFont(descriptor: self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)!, size: self.pointSize)
    }
    
    /// change the font to italic
    func toItalic() -> UIFont {
        return UIFont(descriptor: self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitItalic)!, size: self.pointSize)
    }
    
    /// change the font to system font
    func toSystem() -> UIFont {
        return UIFont.systemFont(ofSize: self.pointSize)
    }
    
    /// return a font object for the specified CTFontRef
    class func fontWith(CTFont: CTFont) -> UIFont? {
        let name = CTFontCopyPostScriptName(CTFont) as String
        let size = CTFontGetSize(CTFont)
        let font = self.init(name: name, size: size)
        return font
    }
    
    /// return a font object for the specified CGFont
    class func fontWith(cgFont: CGFont, size: CGFloat) -> UIFont? {
        guard let name = cgFont.postScriptName as String? else { return nil }
        let font = self.init(name: name, size: size)
        return font
        
    }
    
    /// create the CTFont object
    func toCTFont() -> CTFont {
        let font = CTFontCreateWithName(self.fontName as CFString, self.pointSize, nil)
        return font
    }
    
    /// create the CGFont object
    func toCGFont() -> CGFont? {
        let font = CGFont(self.fontName as CFString)
        return font
    }
    
    static func normalFont(_ size: CGFloat, _ name: String) -> UIFont {
        guard name.utf16.count > 0 else {
            return UIFont.systemFont(ofSize: size)
        }
        return UIFont.init(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

