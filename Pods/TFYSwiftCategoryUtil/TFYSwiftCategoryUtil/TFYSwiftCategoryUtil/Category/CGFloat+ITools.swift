//
//  CGFloat+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/16.
//

import UIKit

extension CGFloat: TFYCompatible {}

public extension TFY where Base == CGFloat {
    
    // MARK: 1.1、转 Int
    /// 转 Int
    var int: Int { return Int(base) }
    
    // MARK: 1.2、转 CGFloat
    /// 转 CGFloat
    var cgFloat: CGFloat { return base }
    
    // MARK: 1.3、转 Int64
    /// 转 Int64
    var int64: Int64 { return Int64(base) }
    
    // MARK: 1.4、转 Float
    /// 转 Float
    var float: Float { return Float(base) }
    
    // MARK: 1.5、转 String
    /// 转 String
    var string: String { return String(base.tfy.double) }
    
    // MARK: 1.6、转 NSNumber
    /// 转 NSNumber
    var number: NSNumber { return NSNumber(value: base.tfy.double) }
    
    // MARK: 1.7、转 Double
    /// 转 Double
    var double: Double { return Double(base) }
    
    // MARK: 角度转弧度
    /// 角度转弧度
    /// - Returns: 弧度
    func degreesToRadians() -> CGFloat {
        return (.pi * base) / 180.0
    }
    
    // MARK: 弧度转角度
    /// 角弧度转角度
    /// - Returns: 角度
    func radiansToDegrees() -> CGFloat {
        return (base * 180.0) / .pi
    }
}
