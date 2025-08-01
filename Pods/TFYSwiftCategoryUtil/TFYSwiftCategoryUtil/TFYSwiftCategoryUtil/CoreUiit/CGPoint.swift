import CoreGraphics

// MARK: - CGPoint Extensions
/// CGPoint 扩展，提供便捷的点和向量操作
/// 支持 iOS 15.0 及以上版本
/// 支持 iPhone 和 iPad 适配

public extension CGPoint {
    
    /// 偏移点坐标
    /// - Parameters:
    ///   - x: X 轴偏移量，默认为 0
    ///   - y: Y 轴偏移量，默认为 0
    /// - Returns: 偏移后的新点
    func offseted(x: CGFloat = 0.0, y: CGFloat = 0.0) -> CGPoint {
        var point = self
        point.x += x
        point.y += y
        return point
    }
    
    /// 偏移点坐标（使用 CGVector）
    /// - Parameter offset: 偏移向量
    /// - Returns: 偏移后的新点
    func offseted(by offset: CGVector) -> CGPoint {
        return CGPoint(x: x + offset.dx, y: y + offset.dy)
    }
    
    /// 计算两点之间的距离
    /// - Parameter other: 另一个点
    /// - Returns: 两点之间的距离
    func distance(to other: CGPoint) -> CGFloat {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }
    
    /// 计算点到原点的距离
    /// - Returns: 到原点的距离
    var distanceFromOrigin: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    /// 计算两点之间的中点
    /// - Parameter other: 另一个点
    /// - Returns: 两点的中点
    func midpoint(with other: CGPoint) -> CGPoint {
        return CGPoint(x: (x + other.x) / 2, y: (y + other.y) / 2)
    }
    
    /// 计算点与指定点的角度（弧度）
    /// - Parameter other: 另一个点
    /// - Returns: 角度（弧度）
    func angle(to other: CGPoint) -> CGFloat {
        return atan2(other.y - y, other.x - x)
    }
    
    /// 计算点与指定点的角度（度数）
    /// - Parameter other: 另一个点
    /// - Returns: 角度（度数）
    func angleInDegrees(to other: CGPoint) -> CGFloat {
        return angle(to: other) * 180 / .pi
    }
    
    /// 将点旋转指定角度
    /// - Parameter angle: 旋转角度（弧度）
    /// - Returns: 旋转后的点
    func rotated(by angle: CGFloat) -> CGPoint {
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        return CGPoint(
            x: x * cosAngle - y * sinAngle,
            y: x * sinAngle + y * cosAngle
        )
    }
    
    /// 将点围绕指定中心点旋转
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - center: 旋转中心点
    /// - Returns: 旋转后的点
    func rotated(by angle: CGFloat, around center: CGPoint) -> CGPoint {
        let translated = CGPoint(x: x - center.x, y: y - center.y)
        let rotated = translated.rotated(by: angle)
        return CGPoint(x: rotated.x + center.x, y: rotated.y + center.y)
    }
    
    /// 将点缩放到指定比例
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的点
    func scaled(by scale: CGFloat) -> CGPoint {
        return CGPoint(x: x * scale, y: y * scale)
    }
    
    /// 将点缩放到指定比例（分别缩放 X 和 Y）
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的点
    func scaled(by scale: CGPoint) -> CGPoint {
        return CGPoint(x: x * scale.x, y: y * scale.y)
    }
    
    /// 将点缩放到指定比例（分别缩放 X 和 Y）
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的点
    func scaled(by scale: CGSize) -> CGPoint {
        return CGPoint(x: x * scale.width, y: y * scale.height)
    }
    
    /// 将点限制在指定矩形内
    /// - Parameter rect: 限制矩形
    /// - Returns: 限制后的点
    func clamped(to rect: CGRect) -> CGPoint {
        return CGPoint(
            x: max(rect.minX, min(rect.maxX, x)),
            y: max(rect.minY, min(rect.maxY, y))
        )
    }
    
    /// 将点限制在指定范围内
    /// - Parameters:
    ///   - minX: 最小 X 值
    ///   - maxX: 最大 X 值
    ///   - minY: 最小 Y 值
    ///   - maxY: 最大 Y 值
    /// - Returns: 限制后的点
    func clamped(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) -> CGPoint {
        return CGPoint(
            x: max(minX, min(maxX, x)),
            y: max(minY, min(maxY, y))
        )
    }
    
    /// 计算点是否在指定矩形内
    /// - Parameter rect: 目标矩形
    /// - Returns: 是否在矩形内
    func isInside(_ rect: CGRect) -> Bool {
        return rect.contains(self)
    }
    
    /// 计算点是否在指定圆形内
    /// - Parameters:
    ///   - center: 圆心
    ///   - radius: 半径
    /// - Returns: 是否在圆形内
    func isInside(circleWithCenter center: CGPoint, radius: CGFloat) -> Bool {
        return distance(to: center) <= radius
    }
    
    /// 将点转换为 CGVector
    /// - Returns: 对应的向量
    var asVector: CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    /// 计算点的标准化向量（单位向量）
    /// - Returns: 标准化后的点
    var normalized: CGPoint {
        let length = distanceFromOrigin
        guard length > 0 else { return .zero }
        return CGPoint(x: x / length, y: y / length)
    }
    
    /// 计算点与指定点的线性插值
    /// - Parameters:
    ///   - other: 另一个点
    ///   - t: 插值参数（0-1）
    /// - Returns: 插值后的点
    func interpolated(to other: CGPoint, t: CGFloat) -> CGPoint {
        return CGPoint(
            x: x + (other.x - x) * t,
            y: y + (other.y - y) * t
        )
    }
    
    /// 计算点与指定点的贝塞尔曲线插值
    /// - Parameters:
    ///   - other: 另一个点
    ///   - control: 控制点
    ///   - t: 插值参数（0-1）
    /// - Returns: 贝塞尔插值后的点
    func bezierInterpolated(to other: CGPoint, control: CGPoint, t: CGFloat) -> CGPoint {
        let t2 = t * t
        let t3 = t2 * t
        let oneMinusT = 1 - t
        let oneMinusT2 = oneMinusT * oneMinusT
        let oneMinusT3 = oneMinusT2 * oneMinusT
        
        return CGPoint(
            x: oneMinusT3 * x + 3 * oneMinusT2 * t * control.x + 3 * oneMinusT * t2 * other.x + t3 * other.x,
            y: oneMinusT3 * y + 3 * oneMinusT2 * t * control.y + 3 * oneMinusT * t2 * other.y + t3 * other.y
        )
    }
}

// MARK: - CGPoint Convenience Initializers
/// CGPoint 便捷初始化方法

public extension CGPoint {
    
    /// 使用 CGVector 初始化点
    /// - Parameter vector: 向量
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    /// 使用极坐标初始化点
    /// - Parameters:
    ///   - radius: 半径
    ///   - angle: 角度（弧度）
    init(radius: CGFloat, angle: CGFloat) {
        self.init(x: radius * cos(angle), y: radius * sin(angle))
    }
    
    /// 使用极坐标初始化点（度数）
    /// - Parameters:
    ///   - radius: 半径
    ///   - angleInDegrees: 角度（度数）
    init(radius: CGFloat, angleInDegrees: CGFloat) {
        self.init(radius: radius, angle: angleInDegrees * .pi / 180)
    }
}

// MARK: - CGPoint Constants
/// CGPoint 常量定义

public extension CGPoint {
    /// 单位点 (1, 1)
    static let one = CGPoint(x: 1, y: 1)
    
    /// 正无穷大点
    static let infinity = CGPoint(x: CGFloat.infinity, y: CGFloat.infinity)
    
    /// 负无穷大点
    static let negativeInfinity = CGPoint(x: -CGFloat.infinity, y: -CGFloat.infinity)
}
