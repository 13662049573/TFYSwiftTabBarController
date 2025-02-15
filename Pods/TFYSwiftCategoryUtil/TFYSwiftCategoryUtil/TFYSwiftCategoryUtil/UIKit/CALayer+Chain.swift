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
    func pauseAnimation() {
        // 取出当前时间,转成动画暂停的时间
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        // 设置动画运行速度为0
        speed = 0.0
        // 设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        timeOffset = pausedTime
    }

    /// 恢复动画
    func resumeAnimation() {
        // 获取暂停的时间差
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        // 用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
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
        set{
            self.setValue(newValue, forKeyPath: "transform.rotation")
        }
        get{
            let v = self.value(forKeyPath: "transform.rotation")
            return v as! CGFloat
        }
    }
    
    func removeAllSublayers() {
        for layer in self.sublayers! {
            layer.removeFromSuperlayer()
        }
    }
    
    func setLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        
        self.shadowColor = color.cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = 1
        self.shouldRasterize = true
        self.rasterizationScale = UIScreen.main.scale
        
    }
    
    func snapshotImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.render(in: UIGraphicsGetCurrentContext()!)
        
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap!
        
    }
    
    func addFadeAnimation(with duration: TimeInterval, curve: UIView.AnimationCurve) {
        
        if duration <= 0 {
            return
        }
        
        var mediaFunction: CAMediaTimingFunctionName = .default
        
        switch curve {
            
        case .easeInOut:
            mediaFunction = CAMediaTimingFunctionName.easeInEaseOut
        case .easeIn:
            mediaFunction = CAMediaTimingFunctionName.easeIn
        case .easeOut:
            mediaFunction = CAMediaTimingFunctionName.easeOut
        case .linear:
            mediaFunction = CAMediaTimingFunctionName.linear
        default:
            break
        }
        
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: mediaFunction)
        transition.type = CATransitionType.fade
        self.add(transition, forKey: "yam.fade")
        
    }
    
    func removePreviousFadeAnimation() {
        self.removeAnimation(forKey: "yam.fade")
    }
}

extension CALayer {
    /// return a image layer
    class func layer(withImage image: UIImage) -> CALayer {
        let layer = CALayer()
        layer.contents = image.cgImage
        layer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        return layer
    }
}

extension CATextLayer {
    /// retuan a text layer
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
