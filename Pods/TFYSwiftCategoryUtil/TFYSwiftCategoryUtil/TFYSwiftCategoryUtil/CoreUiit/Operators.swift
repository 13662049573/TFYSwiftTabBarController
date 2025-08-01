import CoreGraphics

// MARK: - CGSize Operators
/// 扩展 CGSize 的操作符，提供便捷的数学运算
/// 支持 iOS 15.0 及以上版本

/// CGSize 加法操作符
/// - Parameters:
///   - lhs: 左侧 CGSize
///   - rhs: 右侧 CGSize
/// - Returns: 两个 CGSize 的宽度和高度分别相加的结果
public func +(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

/// CGSize 减法操作符
/// - Parameters:
///   - lhs: 左侧 CGSize
///   - rhs: 右侧 CGSize
/// - Returns: 两个 CGSize 的宽度和高度分别相减的结果
public func -(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}

/// CGSize 与 CGFloat 乘法操作符
/// - Parameters:
///   - lhs: CGSize
///   - rhs: CGFloat 缩放因子
/// - Returns: CGSize 的宽度和高度分别乘以缩放因子的结果
public func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

/// CGFloat 与 CGSize 乘法操作符（交换律）
/// - Parameters:
///   - lhs: CGFloat 缩放因子
///   - rhs: CGSize
/// - Returns: CGSize 的宽度和高度分别乘以缩放因子的结果
public func *(lhs: CGFloat, rhs: CGSize) -> CGSize {
    return rhs * lhs
}

/// CGSize 与 CGFloat 除法操作符
/// - Parameters:
///   - lhs: CGSize
///   - rhs: CGFloat 除数
/// - Returns: CGSize 的宽度和高度分别除以除数的结果
public func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
    guard rhs != 0 else {
        // 防止除零错误，返回原始大小
        return lhs
    }
    return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}

// MARK: - CGPoint Operators
/// 扩展 CGPoint 的操作符，提供便捷的数学运算

/// CGPoint 加法操作符
/// - Parameters:
///   - lhs: 左侧 CGPoint
///   - rhs: 右侧 CGPoint
/// - Returns: 两个 CGPoint 的 x 和 y 分别相加的结果
public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

/// CGPoint 减法操作符
/// - Parameters:
///   - lhs: 左侧 CGPoint
///   - rhs: 右侧 CGPoint
/// - Returns: 两个 CGPoint 的 x 和 y 分别相减的结果
public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

/// CGPoint 与 CGFloat 乘法操作符
/// - Parameters:
///   - lhs: CGPoint
///   - rhs: CGFloat 缩放因子
/// - Returns: CGPoint 的 x 和 y 分别乘以缩放因子的结果
public func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

/// CGFloat 与 CGPoint 乘法操作符（交换律）
/// - Parameters:
///   - lhs: CGFloat 缩放因子
///   - rhs: CGPoint
/// - Returns: CGPoint 的 x 和 y 分别乘以缩放因子的结果
public func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
    return rhs * lhs
}

/// CGPoint 与 CGFloat 除法操作符
/// - Parameters:
///   - lhs: CGPoint
///   - rhs: CGFloat 除数
/// - Returns: CGPoint 的 x 和 y 分别除以除数的结果
public func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    guard rhs != 0 else {
        // 防止除零错误，返回原始点
        return lhs
    }
    return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}

// MARK: - CGRect Operators
/// 扩展 CGRect 的操作符，提供便捷的数学运算

/// CGRect 与 CGSize 乘法操作符（缩放矩形）
/// - Parameters:
///   - lhs: CGRect
///   - rhs: CGSize 缩放因子
/// - Returns: 缩放后的 CGRect
public func *(lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(
        x: lhs.origin.x * rhs.width,
        y: lhs.origin.y * rhs.height,
        width: lhs.size.width * rhs.width,
        height: lhs.size.height * rhs.height
    )
}

/// CGSize 与 CGRect 乘法操作符（交换律）
/// - Parameters:
///   - lhs: CGSize 缩放因子
///   - rhs: CGRect
/// - Returns: 缩放后的 CGRect
public func *(lhs: CGSize, rhs: CGRect) -> CGRect {
    return rhs * lhs
}
