//
//  CAGradientLayer+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit

// MARK: - 一、基本的扩展
public enum GradientDirection {
    /// 水平从左到右
    case horizontal
    ///  垂直从上到下
    case vertical
    /// 左上到右下
    case leftOblique
    /// 右上到左下
    case rightOblique
    /// 其他情况.
    case other(CGPoint, CGPoint)

    public func point() -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .rightOblique:
            return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
        case .other(let stat, let end):
            return (stat, end)
        }
    }
}
public extension TFY where Base: CAGradientLayer {

    // MARK: 1.1、设置渐变色图层
    /// 设置渐变色图层
    /// - Parameters:
    ///   - direction: 渐变方向，默认水平
    ///   - gradientColors: 渐变的颜色数组（不能为空，建议为UIColor或CGColor）
    ///   - gradientLocations: 渐变颜色的终止位置（可选，必须递增，长度与colors一致）
    /// - Returns: 配置好的CAGradientLayer
    func gradientLayer(_ direction: GradientDirection = .horizontal, _ gradientColors: [Any], _ gradientLocations: [NSNumber]? = nil) -> CAGradientLayer {
        // 参数安全检查
        let colors = normalizedGradientColors(gradientColors)
        guard !colors.isEmpty else {
            TFYUtils.Logger.log("⚠️ CAGradientLayer: 渐变颜色数组不能为空或类型无效")
            return self.base
        }

        // 设置渐变的颜色数组
        self.base.colors = colors
        // 设置渐变颜色的终止位置
        self.base.locations = sanitizedLocations(gradientLocations, colorCount: colors.count)
        // 设置渲染的起始结束位置（渐变方向设置）
        let (start, end) = direction.point()
        self.base.startPoint = start
        self.base.endPoint = end
        return self.base
    }

    // MARK: 1.2、安全设置渐变色图层
    /// 安全设置渐变色图层，仅接收 UIColor
    /// - Parameters:
    ///   - direction: 渐变方向
    ///   - colors: 渐变颜色
    ///   - locations: 渐变位置
    /// - Returns: 配置好的CAGradientLayer
    func safeGradientLayer(_ direction: GradientDirection = .horizontal,
                           colors: [UIColor],
                           locations: [CGFloat]? = nil) -> CAGradientLayer {
        let nsLocations = locations?.map { NSNumber(value: Double($0)) }
        return gradientLayer(direction, colors, nsLocations)
    }
}

private extension TFY where Base: CAGradientLayer {
    func normalizedGradientColors(_ colors: [Any]) -> [CGColor] {
        return colors.compactMap { color in
            if let uiColor = color as? UIColor {
                return uiColor.cgColor
            }
            let cfColor = color as CFTypeRef
            if CFGetTypeID(cfColor) == CGColor.typeID {
                return unsafeBitCast(cfColor, to: CGColor.self)
            }
            return nil
        }
    }

    func sanitizedLocations(_ locations: [NSNumber]?, colorCount: Int) -> [NSNumber]? {
        guard colorCount > 1 else { return locations == nil ? nil : [0] }
        guard let locations = locations, locations.count == colorCount else {
            return evenlyDistributedLocations(colorCount: colorCount)
        }

        let clampedValues = locations.map { min(1, max(0, $0.doubleValue)) }
        guard zip(clampedValues, clampedValues.dropFirst()).allSatisfy({ $0 <= $1 }) else {
            return evenlyDistributedLocations(colorCount: colorCount)
        }
        return clampedValues.map { NSNumber(value: $0) }
    }

    func evenlyDistributedLocations(colorCount: Int) -> [NSNumber] {
        guard colorCount > 1 else { return [0] }
        return (0..<colorCount).map { index in
            NSNumber(value: Double(index) / Double(colorCount - 1))
        }
    }
}
