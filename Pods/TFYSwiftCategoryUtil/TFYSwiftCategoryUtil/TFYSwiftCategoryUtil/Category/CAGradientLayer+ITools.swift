//
//  CAGradientLayer+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/16.
//

import UIKit

// MARK:- 一、基本的扩展
public enum GradientDirection {
    /// 水平从左到右
    case horizontal
    ///  垂直从上到下
    case vertical
    /// 左上到右下
    case leftOblique
    /// 右上到左下
    case rightOblique
    /// 请他情况
    case other(CGPoint, CGPoint)
    
    public func point() -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .rightOblique:
            return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
        case .other(let stat, let end):
            return (stat, end)
        }
    }
}

public extension TFY where Base == CAGradientLayer {
    
    ///设置渐变色图层
    func gradientLayer(_ direction: GradientDirection = .horizontal, _ gradientColors: [Any], _ gradientLocations: [NSNumber]? = nil) -> CAGradientLayer {
        // 设置渐变的颜色数组
        base.colors = gradientColors
        // 设置渐变颜色的终止位置，这些值必须是递增的，数组的长度和 colors 的长度最好一致
        base.locations = gradientLocations
        // 设置渲染的起始结束位置（渐变方向设置）
        base.startPoint = direction.point().0
        base.endPoint = direction.point().1
        return base
    }
}
