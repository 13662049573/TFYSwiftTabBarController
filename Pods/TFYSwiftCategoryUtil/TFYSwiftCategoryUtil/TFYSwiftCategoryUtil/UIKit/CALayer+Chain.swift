//
//  CALayer+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation
import UIKit

public extension CALayer {
    /// 暂停动画
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func pauseAnimation() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }

    /// 恢复动画
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
    
    var left: CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var top: CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var right: CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get{
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var bottom: CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
        get{
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    var width: CGFloat {
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get{
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get{
            return self.frame.size.height
        }
    }
    
    var centerX: CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width * 0.5
            self.frame = frame
        }
        get{
            return self.frame.origin.x + self.frame.size.width * 0.5
        }
    }
    
    var centerY: CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height * 0.5
            self.frame = frame
        }
        get{
            return self.frame.origin.y + self.frame.size.height * 0.5
        }
    }
    
    var origin: CGPoint {
        set{
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin
        }
    }
    
    var size: CGSize {
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get{
            return self.frame.size
        }
    }
    
    var transformRotation: CGFloat {
        set {
            self.setValue(newValue, forKeyPath: "transform.rotation")
        }
        get {
            let v = self.value(forKeyPath: "transform.rotation")
            return v as? CGFloat ?? 0
        }
    }
    
    /// 移除所有子图层
    /// - Note: 安全处理sublayers为nil的情况
    func removeAllSublayers() {
        guard let sublayers = self.sublayers else { return }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
    
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - radius: 阴影半径
    func setLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        self.shadowColor = color.cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = 1
        self.shouldRasterize = true
        self.rasterizationScale = UIScreen.main.scale
    }
    
    /// 截图当前图层
    /// - Returns: 截图UIImage，失败返回nil
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            print("⚠️ CALayer: 获取图形上下文失败")
            return nil
        }
        self.render(in: context)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        return snap
    }
    
    /// 添加淡入淡出动画
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - curve: 动画曲线
    func addFadeAnimation(with duration: TimeInterval, curve: UIView.AnimationCurve) {
        guard duration > 0 else { return }
        var mediaFunction: CAMediaTimingFunctionName = .default
        switch curve {
        case .easeInOut:
            mediaFunction = .easeInEaseOut
        case .easeIn:
            mediaFunction = .easeIn
        case .easeOut:
            mediaFunction = .easeOut
        case .linear:
            mediaFunction = .linear
        default:
            break
        }
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: mediaFunction)
        transition.type = .fade
        self.add(transition, forKey: "yam.fade")
    }
    
    /// 移除之前的淡入淡出动画
    func removePreviousFadeAnimation() {
        self.removeAnimation(forKey: "yam.fade")
    }
}

extension CALayer {
    /// 创建图片图层
    /// - Parameter image: 图片
    /// - Returns: 带图片内容的CALayer
    class func layer(withImage image: UIImage) -> CALayer {
        let layer = CALayer()
        layer.contents = image.cgImage
        layer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        return layer
    }
}

extension CATextLayer {
    /// 创建文本图层
    /// - Parameters:
    ///   - text: 文本内容
    ///   - mode: 对齐方式
    ///   - font: 字体
    /// - Returns: 配置好的CATextLayer
    class func layer(withText text: String, mode: CATextLayerAlignmentMode, font: UIFont) -> CATextLayer {
        let layer = CATextLayer()
        layer.string = text
        layer.alignmentMode = mode
        layer.foregroundColor = UIColor.darkText.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.isWrapped = true
        let fontRef = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        layer.font = fontRef
        layer.fontSize = font.pointSize
        return layer
    }
}
