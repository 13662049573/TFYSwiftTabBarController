//
//  Double+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/16.
//

import UIKit

extension Double: TFYCompatible {}

public extension TFY where Base == Double {
    // MARK: 1.1、转 Int
    /// 转 Int
    var int: Int { return Int(self.base) }
    
    // MARK: 1.2、转 CGFloat
    /// 转 CGFloat
    var cgFloat: CGFloat { return CGFloat(self.base) }

    // MARK: 1.3、转 Int64
    /// 转 Int64
    var int64: Int64 { return Int64(self.base) }
    
    // MARK: 1.4、转 Float
    /// 转 Float
    var float: Float { return Float(self.base) }
    
    // MARK: 1.5、转 String
    /// 转 String
    var string: String { return String(self.base) }
    
    // MARK: 1.6、转 NSNumber
    /// 转 NSNumber
    var number: NSNumber { return NSNumber.init(value: self.base) }
    
    // MARK: 1.7、转 Double
    /// 转 Double
    var double: Double { return self.base }
    
    // MARK:- 浮点数四舍五入
    /// 浮点数四舍五入
    /// - Parameter places: 数字
    /// - Returns: Double
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self.base * divisor).rounded() / divisor
    }
}
