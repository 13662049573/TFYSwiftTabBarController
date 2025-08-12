//
//  UIColor+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/12.
//  用途：UIColor 链式编程扩展，支持颜色转换、渐变、暗黑模式适配等功能。
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
                       alpha: 1.0)
    }

    /// 颜色 --> 图片
    /// - Parameter size: 图片尺寸，默认为1x1
    /// - Returns: UIImage?
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(base.cgColor)
        context.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 颜色 --> 暗黑色设置
    /// - Parameters:
    ///   - light: 浅色模式颜色
    ///   - dark: 深色模式颜色
    /// - Returns: 适配的颜色
    static func diabloDarkColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { traitCollection -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        } else {
            return light
        }
    }
    
    /// 获取颜色的十六进制字符串
    /// - Returns: 十六进制字符串，格式为"#RRGGBB"
    func toHexString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard base.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255)
        return String(format: "#%06X", rgb)
    }
    
    /// 混合两个颜色
    /// - Parameters:
    ///   - color: 要混合的颜色
    ///   - ratio: 混合比例 (0.0-1.0)
    /// - Returns: 混合后的颜色
    func blend(with color: UIColor, ratio: CGFloat) -> UIColor {
        let clampedRatio = max(0.0, min(1.0, ratio))
        
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        
        guard base.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1),
              color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2) else {
            return base
        }
        
        let newRed = red1 * (1 - clampedRatio) + red2 * clampedRatio
        let newGreen = green1 * (1 - clampedRatio) + green2 * clampedRatio
        let newBlue = blue1 * (1 - clampedRatio) + blue2 * clampedRatio
        let newAlpha = alpha1 * (1 - clampedRatio) + alpha2 * clampedRatio
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }
}

extension UIColor {
    public enum GradientChangeDirection: Int, CaseIterable {
        case level = 1           /// 水平渐变
        case vertical = 2        /// 竖直渐变
        case upwardDiagonal = 3  /// 向下对角线渐变
        case downDiagonal = 4    /// 向上对角线渐变
        
        // 保持向后兼容
        static let GradientChangeDirectionLevel = level
        static let GradientChangeDirectionVertical = vertical
        static let GradientChangeDirectionUpwardDiagonalLine = upwardDiagonal
        static let GradientChangeDirectionDownDiagonalLine = downDiagonal
    }
}

public extension UIColor {

    private convenience init?(hex3: Int64, alpha: Float) {
        self.init(red: CGFloat(((hex3 & 0xF00) >> 8).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex3 & 0x0F0) >> 4).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex3 & 0x00F) >> 0).duplicate4bits()) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex4: Int64, alpha: Float?) {
        self.init(red: CGFloat(((hex4 & 0xF000) >> 12).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex4 & 0x0F00) >> 8).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex4 & 0x00F0) >> 4).duplicate4bits()) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat(((hex4 & 0x000F) >> 0).duplicate4bits()) / 255.0)
    }

    private convenience init?(hex6: Int64, alpha: Float) {
        self.init(red: CGFloat((hex6 & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex6 & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((hex6 & 0x0000FF) >> 0) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex8: Int64, alpha: Float?) {
        self.init(red: CGFloat((hex8 & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((hex8 & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((hex8 & 0x0000FF00) >> 8) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat((hex8 & 0x000000FF) >> 0) / 255.0)
    }

    /**
     十六进制颜色值 支持 3,4,6,8位
     - Parameter hexString: 十六进制字符串
     - Parameter alpha: 透明度，可选
     */
    convenience init?(hexString: String, alpha: Float? = nil) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)

        // 移除#前缀
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard !hex.isEmpty, let hexVal = Int64(hex, radix: 16) else {
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
            return nil
        }
    }
    
    /**
     自定义十六进制颜色
     - Parameter hex: 十六进制整数值
     - Parameter alpha: 透明度
     */
    convenience init?(hex: Int, alpha: Float = 1.0) {
        guard (0x000000...0xFFFFFF) ~= hex else { return nil }
        self.init(hex6: Int64(hex), alpha: alpha)
    }
    
    /// 从RGB值创建颜色
    /// - Parameters:
    ///   - rgbValue: RGB值
    ///   - alpha: 透明度
    convenience init(rgbValue: UInt, alpha: CGFloat = 1) {
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    /// 从十六进制代码创建颜色
    /// - Parameters:
    ///   - hexCode: 十六进制代码（可包含#）
    ///   - alpha: 透明度
    convenience init(hexCode: String, alpha: CGFloat = 1) {
        var cString = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        guard cString.count == 6 else {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
            return
        }
        
        var rgbValue: UInt64 = 0
        if Scanner(string: cString).scanHexInt64(&rgbValue) {
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
    }
    
    /// 检查是否为浅色
    /// https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    var isLight: Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
    }
    
    /// 检查是否为极浅色
    var isExtremelyLight: Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.9
    }
    
    /// 检查是否为深色
    var isDark: Bool {
        return !isLight
    }
    
    /// 随机颜色
    /// - Parameter alpha: 透明度
    /// - Returns: 随机颜色
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// 变亮颜色
    /// - Parameter percentage: 变亮百分比
    /// - Returns: 变亮后的颜色
    func lighten(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage))
    }

    /// 变暗颜色
    /// - Parameter percentage: 变暗百分比
    /// - Returns: 变暗后的颜色
    func darken(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    /// 动态颜色（适配深色/浅色模式）
    /// - Parameters:
    ///   - light: 浅色模式颜色
    ///   - dark: 深色模式颜色
    /// - Returns: 动态颜色
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
    
    /// 获取颜色的亮度值
    /// - Returns: 亮度值 (0.0-1.0)
    var brightness: CGFloat {
        guard let components = cgColor.components, components.count > 2 else { return 0 }
        return ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
    }
    
    /// 获取颜色的饱和度
    /// - Returns: 饱和度值 (0.0-1.0)
    var saturation: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return 0
        }
        
        return saturation
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
    
    /// 创建渐变颜色
    /// - Parameters:
    ///   - size: 渐变尺寸
    ///   - direction: 渐变方向
    ///   - colors: 颜色数组
    /// - Returns: 渐变颜色
    static func colorGradientChangeWithSize(size: CGSize, direction: UIColor.GradientChangeDirection, colors: [CGColor]) -> UIColor {
        guard size.width > 0, size.height > 0, !colors.isEmpty else {
            return .clear
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        var startPoint = CGPoint.zero
        if direction == .downDiagonal {
            startPoint = CGPoint(x: 0.0, y: 1.0)
        }
        gradientLayer.startPoint = startPoint
        
        var endPoint = CGPoint.zero
        switch direction {
        case .level:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            endPoint = CGPoint(x: 0.0, y: 1.0)
        case .upwardDiagonal:
            endPoint = CGPoint(x: 1.0, y: 1.0)
        case .downDiagonal:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return .clear }
        gradientLayer.render(in: context)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return .clear }
        return UIColor(patternImage: image)
    }
    
    /// 获取颜色的RGBA组件
    /// - Returns: RGBA组件元组，如果获取失败返回nil
    func rgbaComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        return (red, green, blue, alpha)
    }
    
    /// 获取颜色的HSBA组件
    /// - Returns: HSBA组件元组，如果获取失败返回nil
    func hsbaComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }
        
        return (hue, saturation, brightness, alpha)
    }
    
    /// 获取颜色的对比色
    /// - Returns: 对比色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var contrastingColor: UIColor {
        return isLight ? .black : .white
    }
    
    /// 获取颜色的互补色
    /// - Returns: 互补色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var complementaryColor: UIColor {
        guard let components = rgbaComponents() else { return self }
        return UIColor(red: 1.0 - components.red,
                      green: 1.0 - components.green,
                      blue: 1.0 - components.blue,
                      alpha: components.alpha)
    }
    
    /// 获取颜色的灰度值
    /// - Returns: 灰度颜色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var grayscale: UIColor {
        guard let components = rgbaComponents() else { return self }
        let gray = 0.299 * components.red + 0.587 * components.green + 0.114 * components.blue
        return UIColor(red: gray, green: gray, blue: gray, alpha: components.alpha)
    }
    
    /// 设置颜色的透明度
    /// - Parameter alpha: 透明度值
    /// - Returns: 新的颜色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func withAlpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
    
    /// 创建系统颜色的动态版本
    /// - Parameters:
    ///   - lightColor: 浅色模式颜色
    ///   - darkColor: 深色模式颜色
    /// - Returns: 动态颜色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @available(iOS 13.0, *)
    static func adaptiveColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            case .light, .unspecified:
                return light
            @unknown default:
                return light
            }
        }
    }
    
    /// 创建颜色数组的渐变
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 位置数组（可选）
    /// - Returns: 渐变层
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func gradientLayer(colors: [UIColor], locations: [NSNumber]? = nil) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        return gradientLayer
    }
    
    /// 检查颜色是否透明
    /// - Returns: 如果颜色透明返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isTransparent: Bool {
        guard let components = rgbaComponents() else { return false }
        return components.alpha < 0.1
    }
    
    /// 检查颜色是否完全不透明
    /// - Returns: 如果颜色完全不透明返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isOpaque: Bool {
        guard let components = rgbaComponents() else { return false }
        return components.alpha > 0.99
    }
    
    /// 获取颜色的十六进制值（不带#）
    /// - Returns: 十六进制字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var hexValue: String {
        guard let components = rgbaComponents() else { return "000000" }
        let r = Int(components.red * 255)
        let g = Int(components.green * 255)
        let b = Int(components.blue * 255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
    
    /// 获取颜色的ARGB十六进制值
    /// - Returns: ARGB十六进制字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var argbHexValue: String {
        guard let components = rgbaComponents() else { return "00000000" }
        let a = Int(components.alpha * 255)
        let r = Int(components.red * 255)
        let g = Int(components.green * 255)
        let b = Int(components.blue * 255)
        return String(format: "%02X%02X%02X%02X", a, r, g, b)
    }
    
    /// 创建颜色并应用亮度调整
    /// - Parameter brightness: 亮度调整值 (-1.0 到 1.0)
    /// - Returns: 调整后的颜色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func withBrightness(_ brightness: CGFloat) -> UIColor {
        guard let components = hsbaComponents() else { return self }
        let newBrightness = max(0, min(1, components.brightness + brightness))
        return UIColor(hue: components.hue,
                      saturation: components.saturation,
                      brightness: newBrightness,
                      alpha: components.alpha)
    }
    
    /// 创建颜色并应用饱和度调整
    /// - Parameter saturation: 饱和度调整值 (-1.0 到 1.0)
    /// - Returns: 调整后的颜色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func withSaturation(_ saturation: CGFloat) -> UIColor {
        guard let components = hsbaComponents() else { return self }
        let newSaturation = max(0, min(1, components.saturation + saturation))
        return UIColor(hue: components.hue,
                      saturation: newSaturation,
                      brightness: components.brightness,
                      alpha: components.alpha)
    }
    
    /// 创建颜色并应用色相调整
    /// - Parameter hue: 色相调整值 (-1.0 到 1.0)
    /// - Returns: 调整后的颜色
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func withHue(_ hue: CGFloat) -> UIColor {
        guard let components = hsbaComponents() else { return self }
        let newHue = (components.hue + hue).truncatingRemainder(dividingBy: 1.0)
        return UIColor(hue: newHue,
                      saturation: components.saturation,
                      brightness: components.brightness,
                      alpha: components.alpha)
    }
}
