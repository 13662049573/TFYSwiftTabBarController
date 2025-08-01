import CoreGraphics
import UIKit

// MARK: - CGRect Extensions
/// CGRect 扩展，提供便捷的矩形操作
/// 支持 iOS 15.0 及以上版本
/// 支持 iPhone 和 iPad 适配

public extension CGRect {
    
    // MARK: - Corner Points
    /// 矩形角点属性
    
    /// 左上角点
    var topLeft: CGPoint {
        return origin
    }
    
    /// 右上角点
    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    
    /// 顶部中点
    var topMiddle: CGPoint {
        return CGPoint(x: midX, y: minY)
    }
    
    /// 左下角点
    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
    
    /// 右下角点
    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    
    /// 底部中点
    var bottomMiddle: CGPoint {
        return CGPoint(x: midX, y: maxY)
    }
    
    /// 左侧中点
    var leftMiddle: CGPoint {
        return CGPoint(x: minX, y: midY)
    }
    
    /// 右侧中点
    var rightMiddle: CGPoint {
        return CGPoint(x: maxX, y: midY)
    }
    
    // MARK: - Center Properties
    /// 中心点属性
    
    /// 矩形中心点（考虑尺寸）
    var center: CGPoint {
        get {
            let x = origin.x + size.width / 2
            let y = origin.y + size.height / 2
            return CGPoint(x: x, y: y)
        }
        set {
            origin.x = newValue.x - size.width / 2
            origin.y = newValue.y - size.height / 2
        }
    }
    
    /// 以中心点为基准的正方形
    var sameCenterSquare: CGRect {
        let maxLength = max(size.width, size.height)
        var rect = CGRect(x: 0, y: 0, width: maxLength, height: maxLength)
        rect.center = center
        return rect
    }
    
    // MARK: - Size Properties
    /// 尺寸相关属性
    
    /// 矩形面积
    var area: CGFloat {
        return size.width * size.height
    }
    
    /// 矩形周长
    var perimeter: CGFloat {
        return 2 * (size.width + size.height)
    }
    
    /// 矩形对角线长度
    var diagonal: CGFloat {
        return sqrt(size.width * size.width + size.height * size.height)
    }
    
    /// 矩形的最小边长
    var minSide: CGFloat {
        return min(size.width, size.height)
    }
    
    /// 矩形的最大边长
    var maxSide: CGFloat {
        return max(size.width, size.height)
    }
    
    /// 矩形是否为正方形
    var isSquare: Bool {
        return abs(size.width - size.height) < CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Position Properties
    /// 位置相关属性
    
    /// 矩形是否在原点
    var isAtOrigin: Bool {
        return origin == .zero
    }
    
    /// 矩形是否为空
    var isRectEmpty: Bool {
        return size.width <= 0 || size.height <= 0
    }
    
    /// 矩形是否无限大
    var isInfinite: Bool {
        return size.width.isInfinite || size.height.isInfinite
    }
    
    // MARK: - Transformation Methods
    /// 变换方法
    
    /// 缩放矩形
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的矩形
    func scaled(by scale: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x * scale,
            y: origin.y * scale,
            width: size.width * scale,
            height: size.height * scale
        )
    }
    
    /// 缩放矩形（分别缩放 X 和 Y）
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的矩形
    func scaled(by scale: CGSize) -> CGRect {
        return CGRect(
            x: origin.x * scale.width,
            y: origin.y * scale.height,
            width: size.width * scale.width,
            height: size.height * scale.height
        )
    }
    
    /// 缩放矩形（分别缩放 X 和 Y）
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的矩形
    func scaled(by scale: CGPoint) -> CGRect {
        return CGRect(
            x: origin.x * scale.x,
            y: origin.y * scale.y,
            width: size.width * scale.x,
            height: size.height * scale.y
        )
    }
    
    /// 偏移矩形
    /// - Parameter offset: 偏移量
    /// - Returns: 偏移后的矩形
    func offset(by offset: CGPoint) -> CGRect {
        return CGRect(
            x: origin.x + offset.x,
            y: origin.y + offset.y,
            width: size.width,
            height: size.height
        )
    }
    
    /// 偏移矩形
    /// - Parameters:
    ///   - dx: X 轴偏移量
    ///   - dy: Y 轴偏移量
    /// - Returns: 偏移后的矩形
    func offset(dx: CGFloat, dy: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x + dx,
            y: origin.y + dy,
            width: size.width,
            height: size.height
        )
    }
    
    /// 内边距矩形
    /// - Parameter insets: 内边距
    /// - Returns: 内边距后的矩形
    func inset(by insets: UIEdgeInsets) -> CGRect {
        return CGRect(
            x: origin.x + insets.left,
            y: origin.y + insets.top,
            width: size.width - insets.left - insets.right,
            height: size.height - insets.top - insets.bottom
        )
    }
    
    /// 内边距矩形（使用自定义边距）
    /// - Parameters:
    ///   - top: 顶部边距
    ///   - left: 左侧边距
    ///   - bottom: 底部边距
    ///   - right: 右侧边距
    /// - Returns: 内边距后的矩形
    func inset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return CGRect(
            x: origin.x + left,
            y: origin.y + top,
            width: size.width - left - right,
            height: size.height - top - bottom
        )
    }
    
    /// 外边距矩形
    /// - Parameter insets: 外边距
    /// - Returns: 外边距后的矩形
    func outset(by insets: UIEdgeInsets) -> CGRect {
        return CGRect(
            x: origin.x - insets.left,
            y: origin.y - insets.top,
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }
    
    /// 外边距矩形（使用自定义边距）
    /// - Parameters:
    ///   - top: 顶部边距
    ///   - left: 左侧边距
    ///   - bottom: 底部边距
    ///   - right: 右侧边距
    /// - Returns: 外边距后的矩形
    func outset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return CGRect(
            x: origin.x - left,
            y: origin.y - top,
            width: size.width + left + right,
            height: size.height + top + bottom
        )
    }
    
    // MARK: - Intersection and Union Methods
    /// 交集和并集方法
    
    /// 计算与另一个矩形的交集
    /// - Parameter other: 另一个矩形
    /// - Returns: 交集矩形，如果没有交集则返回空矩形
    func intersection(with other: CGRect) -> CGRect {
        return self.intersection(other)
    }
    
    /// 计算与另一个矩形的并集
    /// - Parameter other: 另一个矩形
    /// - Returns: 并集矩形
    func union(with other: CGRect) -> CGRect {
        return self.union(other)
    }
    
    /// 检查是否与另一个矩形相交
    /// - Parameter other: 另一个矩形
    /// - Returns: 是否相交
    func intersects(with other: CGRect) -> Bool {
        return self.intersects(other)
    }
    
    // MARK: - Utility Methods
    /// 实用方法
    
    /// 将矩形限制在指定范围内
    /// - Parameter bounds: 限制范围
    /// - Returns: 限制后的矩形
    func clamped(to bounds: CGRect) -> CGRect {
        let clampedX = max(bounds.minX, min(bounds.maxX - size.width, origin.x))
        let clampedY = max(bounds.minY, min(bounds.maxY - size.height, origin.y))
        return CGRect(
            x: clampedX,
            y: clampedY,
            width: min(size.width, bounds.width),
            height: min(size.height, bounds.height)
        )
    }
    
    /// 将矩形居中于指定范围内
    /// - Parameter bounds: 目标范围
    /// - Returns: 居中后的矩形
    func centered(in bounds: CGRect) -> CGRect {
        let x = bounds.midX - size.width / 2
        let y = bounds.midY - size.height / 2
        return CGRect(
            x: x,
            y: y,
            width: size.width,
            height: size.height
        )
    }
    
    /// 将矩形对齐到指定位置
    /// - Parameters:
    ///   - bounds: 目标范围
    ///   - alignment: 对齐方式
    /// - Returns: 对齐后的矩形
    func aligned(in bounds: CGRect, alignment: Alignment) -> CGRect {
        let x: CGFloat
        let y: CGFloat
        
        switch alignment.horizontal {
        case .leading:
            x = bounds.minX
        case .center:
            x = bounds.midX - size.width / 2
        case .trailing:
            x = bounds.maxX - size.width
        }
        
        switch alignment.vertical {
        case .top:
            y = bounds.minY
        case .center:
            y = bounds.midY - size.height / 2
        case .bottom:
            y = bounds.maxY - size.height
        }
        
        return CGRect(
            x: x,
            y: y,
            width: size.width,
            height: size.height
        )
    }
    
    /// 将矩形分割为指定数量的子矩形
    /// - Parameters:
    ///   - rows: 行数
    ///   - columns: 列数
    /// - Returns: 子矩形数组
    func divided(rows: Int, columns: Int) -> [[CGRect]] {
        guard rows > 0 && columns > 0 else { return [] }
        
        let cellWidth = size.width / CGFloat(columns)
        let cellHeight = size.height / CGFloat(rows)
        
        var result: [[CGRect]] = []
        
        for row in 0..<rows {
            var rowRects: [CGRect] = []
            for column in 0..<columns {
                let rect = CGRect(
                    x: origin.x + CGFloat(column) * cellWidth,
                    y: origin.y + CGFloat(row) * cellHeight,
                    width: cellWidth,
                    height: cellHeight
                )
                rowRects.append(rect)
            }
            result.append(rowRects)
        }
        
        return result
    }
    
    /// 将矩形分割为指定数量的子矩形
    /// - Parameter count: 子矩形数量
    /// - Returns: 子矩形数组
    func divided(into count: Int) -> [CGRect] {
        guard count > 0 else { return [] }
        
        let sqrtCount = sqrt(Double(count))
        let rows = Int(ceil(sqrtCount))
        let columns = Int(ceil(Double(count) / Double(rows)))
        
        let divided = self.divided(rows: rows, columns: columns)
        return Array(divided.joined().prefix(count))
    }
}

// MARK: - CGRect Convenience Initializers
/// CGRect 便捷初始化方法

public extension CGRect {
    
    /// 使用中心点和尺寸初始化矩形
    /// - Parameters:
    ///   - center: 中心点
    ///   - size: 尺寸
    init(center: CGPoint, size: CGSize) {
        self.init(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
    
    /// 使用两个点初始化矩形
    /// - Parameters:
    ///   - point1: 第一个点
    ///   - point2: 第二个点
    init(from point1: CGPoint, to point2: CGPoint) {
        let minX = min(point1.x, point2.x)
        let minY = min(point1.y, point2.y)
        let maxX = max(point1.x, point2.x)
        let maxY = max(point1.y, point2.y)
        
        self.init(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }
    
    /// 使用点数组初始化矩形
    /// - Parameter points: 点数组
    init(containing points: [CGPoint]) {
        guard !points.isEmpty else {
            self.init()
            return
        }
        
        let minX = points.map { $0.x }.min() ?? 0
        let minY = points.map { $0.y }.min() ?? 0
        let maxX = points.map { $0.x }.max() ?? 0
        let maxY = points.map { $0.y }.max() ?? 0
        
        self.init(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }
}

// MARK: - CGRect Constants
/// CGRect 常量定义

public extension CGRect {
    /// 单位矩形
    static let unit = CGRect(x: 0, y: 0, width: 1, height: 1)
    
    /// 无限大矩形
    static let infinite = CGRect(
        x: -CGFloat.infinity,
        y: -CGFloat.infinity,
        width: CGFloat.infinity,
        height: CGFloat.infinity
    )
}

// MARK: - Alignment Type
/// 对齐类型定义

public struct Alignment {
    public let horizontal: HorizontalAlignment
    public let vertical: VerticalAlignment
    
    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    public static let center = Alignment(horizontal: .center, vertical: .center)
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
    public static let topCenter = Alignment(horizontal: .center, vertical: .top)
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
    public static let centerLeading = Alignment(horizontal: .leading, vertical: .center)
    public static let centerTrailing = Alignment(horizontal: .trailing, vertical: .center)
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
    public static let bottomCenter = Alignment(horizontal: .center, vertical: .bottom)
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)
}

public enum HorizontalAlignment {
    case leading, center, trailing
}

public enum VerticalAlignment {
    case top, center, bottom
}
