//
//  UIColor+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/12.
//

import Foundation
import UIKit

private extension Int64 {
    func duplicate4bits() -> Int64 {
        return (self << 4) + self
    }
}

public extension TFY where Base: UIColor {
    /// 随机颜色
    static var random: UIColor {
        return UIColor(red: CGFloat(arc4random() % 256) / 255.0,
                       green: CGFloat(arc4random() % 256) / 255.0,
                       blue: CGFloat(arc4random() % 256) / 255.0,
                       alpha: 0.5)
    }

    /// 颜色 --> 图片
    /// - Returns: UIImage?
    func toImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(base.cgColor)
        context.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 颜色 --> 暗黑色设置
    static func diabloDarkColor(light:UIColor,dark:UIColor) -> UIColor {
        if #available(iOS 13, *) {
            let color = UIColor.init { trainCollection -> UIColor in
                if trainCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
            return color
        } else {
            return light
        }
    }
}

public extension UIColor {
    
    private convenience init?(hex3: Int64, alpha: Float) {
          self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                      green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                      blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                      alpha: CGFloat(alpha))
    }

    private convenience init?(hex4: Int64, alpha: Float?) {
        self.init(red:   CGFloat( ((hex4 & 0xF000) >> 12).duplicate4bits() ) / 255.0,
                      green: CGFloat( ((hex4 & 0x0F00) >> 8).duplicate4bits() ) / 255.0,
                      blue:  CGFloat( ((hex4 & 0x00F0) >> 4).duplicate4bits() ) / 255.0,
                      alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( ((hex4 & 0x000F) >> 0).duplicate4bits() ) / 255.0)
    }

    private convenience init?(hex6: Int64, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }

    private convenience init?(hex8: Int64, alpha: Float?) {
        self.init(red:   CGFloat( (hex8 & 0xFF000000) >> 24 ) / 255.0,
                  green: CGFloat( (hex8 & 0x00FF0000) >> 16 ) / 255.0,
                  blue:  CGFloat( (hex8 & 0x0000FF00) >> 8 ) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( (hex8 & 0x000000FF) >> 0 ) / 255.0)
    }

    /**
      十六进制颜色值 支持 3,4,5,6,8
     */
    convenience init?(hexString: String, alpha: Float? = nil) {
        var hex = hexString

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int64(hex, radix: 16) else {
            self.init()
            return nil
        }

        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha ?? 1.0)
        case 4:
            self.init(hex4: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha ?? 1.0)
        case 8:
            self.init(hex8: hexVal, alpha: alpha)
        default:
            self.init()
            return nil
        }
    }
    /**
      自定义失败个数颜色
     */
     convenience init?(hex: Int, alpha: Float = 1.0) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: Int64(hex), alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
    
    /// New color from RGB value
    /// - Parameters:
    ///   - rgbValue: value
    ///   - alpha: alpha
    convenience init(rgbValue: UInt, alpha: CGFloat = 1) {
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    /// Color from HEX
    /// - Parameter hexCode: Hex w/o `#`
    convenience init(hexCode: String, alpha: CGFloat = 1) {
        var cString:String = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            self.init()
        } else {
            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        }
    }
    
    /// Check whether self is a light/bright color.
    /// https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    var isLight: Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
    }
    
    /// Check whether self is a light/bright color.
    /// https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    var isExtremelyLight: Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.9
    }
    
    /// Random color
    /// - Parameter alpha: alpha
    /// - Returns: new color
    static func random(alpha: CGFloat = 1.0) -> UIColor {
         let r = CGFloat.random(in: 0...1)
         let g = CGFloat.random(in: 0...1)
         let b = CGFloat.random(in: 0...1)
         
         return UIColor(red: r, green: g, blue: b, alpha: alpha)
     }
    
    /// Darken color
    /// - Parameter percentage: percentage
    /// - Returns: new color
    func lighten(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage) )
    }

    /// Darken color
    /// - Parameter percentage: percentage
    /// - Returns: new color
    func darken(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    /// Color for UI appearance ex: dark/light mode
    /// - Parameters:
    ///   - light: Light Color
    ///   - dark: Dark Color
    /// - Returns: UIColor
    @available(iOS 13.0, *)
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            } else {
                return light
            }
        }
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return self
        }
    }
}
