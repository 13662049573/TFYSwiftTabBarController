//
//  CAAnimation+TFYSwiftBadge.swift
//  TFYSwiftTabBarController
//
//  Converted from CAAnimation+CYLBadgeExtention
//

import UIKit

public enum TFYSwiftAxis: UInt {
    case x = 0
    case y
    case z
}

public func TFYSwiftDegreesToRadians(_ angle: CGFloat) -> CGFloat {
    angle / 180 * .pi
}

public func TFYSwiftRadiansToDegrees(_ radians: CGFloat) -> CGFloat {
    radians * (180 / .pi)
}

public extension CAAnimation {

    class func tfy_opacityForeverAnimation(_ time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.1
        animation.autoreverses = true
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fillMode = .forwards
        return animation
    }

    class func tfy_opacityTimesAnimation(_ repeatTimes: Float, durTimes time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.4
        animation.repeatCount = repeatTimes
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.autoreverses = true
        return animation
    }

    class func tfy_rotation(_ dur: Float, degree: Float, direction axis: TFYSwiftAxis, repeatCount: Int) -> CABasicAnimation {
        let axisArr = ["transform.rotation.x", "transform.rotation.y", "transform.rotation.z"]
        let animation = CABasicAnimation(keyPath: axisArr[Int(axis.rawValue)])
        animation.fromValue = 0
        animation.toValue = degree
        animation.duration = CFTimeInterval(dur)
        animation.autoreverses = false
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.repeatCount = Float(repeatCount)
        return animation
    }

    class func tfy_scale(from fromScale: CGFloat, toScale: CGFloat, durTimes time: Float, rep repeatTimes: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = fromScale
        animation.toValue = toScale
        animation.duration = CFTimeInterval(time)
        animation.autoreverses = true
        animation.repeatCount = repeatTimes
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }

    class func tfy_shakeAnimation(repeatTimes: Float, durTimes time: Float, forObj obj: Any) -> CAKeyframeAnimation {
        var originPos = CGPoint.zero
        var originSize = CGSize.zero
        if let layer = obj as? CALayer {
            originPos = layer.position
            originSize = layer.bounds.size
        }
        let hOffset = originSize.width / 4
        let anim = CAKeyframeAnimation()
        anim.keyPath = "position"
        anim.values = [
            NSValue(cgPoint: originPos),
            NSValue(cgPoint: CGPoint(x: originPos.x - hOffset, y: originPos.y)),
            NSValue(cgPoint: originPos),
            NSValue(cgPoint: CGPoint(x: originPos.x + hOffset, y: originPos.y)),
            NSValue(cgPoint: originPos)
        ]
        anim.repeatCount = repeatTimes
        anim.duration = CFTimeInterval(time)
        anim.fillMode = .forwards
        return anim
    }

    class func tfy_bounceAnimation(repeatTimes: Float, durTimes time: Float, forObj obj: Any) -> CAKeyframeAnimation {
        var originPos = CGPoint.zero
        var originSize = CGSize.zero
        if let layer = obj as? CALayer {
            originPos = layer.position
            originSize = layer.bounds.size
        }
        let hOffset = originSize.height / 4
        let anim = CAKeyframeAnimation()
        anim.keyPath = "position"
        anim.values = [
            NSValue(cgPoint: originPos),
            NSValue(cgPoint: CGPoint(x: originPos.x, y: originPos.y - hOffset)),
            NSValue(cgPoint: originPos),
            NSValue(cgPoint: CGPoint(x: originPos.x, y: originPos.y + hOffset)),
            NSValue(cgPoint: originPos)
        ]
        anim.repeatCount = repeatTimes
        anim.duration = CFTimeInterval(time)
        anim.fillMode = .forwards
        return anim
    }

    class func tfy_badgeOnceScaleAnimation(repeatTimes: Float, durTimes time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2.7
        animation.toValue = 1.0
        animation.repeatCount = repeatTimes
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }

    class func tfy_badgeOnceLeftRightAnimation(moveDistance: CGFloat, repeatTimes: Float, durTimes time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -moveDistance
        animation.toValue = 0
        animation.repeatCount = repeatTimes
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }

    class func tfy_badgeOnceRightLeftAnimation(moveDistance: CGFloat, repeatTimes: Float, durTimes time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = moveDistance
        animation.toValue = 0
        animation.repeatCount = repeatTimes
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }

    class func tfy_badgeOnceFadeInAnimation(repeatTimes: Float, durTimes time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.repeatCount = repeatTimes
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return animation
    }

    class func tfy_badgeOnceRollingAnimation(repeatTimes: Float, durTimes time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = Double.pi
        animation.toValue = 0
        animation.repeatCount = repeatTimes
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }

    class func tfy_springAnimation(forDuration duration: TimeInterval) -> CAKeyframeAnimation {
        let spring = CAKeyframeAnimation(keyPath: "transform.scale")
        spring.values = [0.85, 1.15, 0.9, 1.0]
        spring.keyTimes = [0, NSNumber(value: 0.15 / duration), NSNumber(value: 0.3 / duration), NSNumber(value: 0.45 / duration)]
        spring.duration = duration
        return spring
    }
}
