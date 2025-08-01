//
//  CLLocation+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import CoreLocation

public extension TFY where Base: CLLocation {
    
    // MARK: 1.1、地理信息反编码
    /// 地理信息反编码
    /// - Parameters:
    ///   - latitude: 精度，必须在-90~90之间
    ///   - longitude: 纬度，必须在-180~180之间
    ///   - completionHandler: 回调函数
    static func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping CLGeocodeCompletionHandler) {
        guard (-90...90).contains(latitude), (-180...180).contains(longitude) else {
            TFYUtils.Logger.log("⚠️ CLLocation: 经纬度参数不合法")
            completionHandler([], NSError(domain: "CLLocation+Chain", code: -1, userInfo: [NSLocalizedDescriptionKey: "经纬度参数不合法"]))
            return
        }
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: completionHandler)
    }
    
    // MARK: 1.2、地理信息编码
    /// 地理信息编码
    /// - Parameters:
    ///   - address: 地址信息，不能为空
    ///   - completionHandler: 回调函数
    static func locationEncode(address: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        guard !address.isEmpty else {
            TFYUtils.Logger.log("⚠️ CLLocation: 地址不能为空")
            completionHandler([], NSError(domain: "CLLocation+Chain", code: -2, userInfo: [NSLocalizedDescriptionKey: "地址不能为空"]))
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: completionHandler)
    }
    
    // MARK: 1.3、计算两点之间的距离
    /// 计算两点之间的距离
    /// - Parameters:
    ///   - from: 起始位置
    ///   - to: 目标位置
    /// - Returns: 距离（米）
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func distance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
        return from.distance(from: to)
    }
    
    // MARK: 1.4、计算两点之间的方位角
    /// 计算两点之间的方位角
    /// - Parameters:
    ///   - from: 起始位置
    ///   - to: 目标位置
    /// - Returns: 方位角（度）
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func bearing(from: CLLocation, to: CLLocation) -> CLLocationDirection {
        let lat1 = from.coordinate.latitude.radians
        let lat2 = to.coordinate.latitude.radians
        let deltaLon = (to.coordinate.longitude - from.coordinate.longitude).radians
        
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
        let bearing = atan2(y, x)
        
        return bearing.degrees
    }
    
    // MARK: 1.5、检查位置是否有效
    /// 检查位置是否有效
    /// - Parameter location: 位置对象
    /// - Returns: 如果位置有效返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func isValid(_ location: CLLocation) -> Bool {
        return location.coordinate.latitude != 0 || location.coordinate.longitude != 0
    }
    
    // MARK: 1.6、获取位置描述
    /// 获取位置描述
    /// - Parameter location: 位置对象
    /// - Returns: 位置描述字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func description(for location: CLLocation) -> String {
        return "纬度: \(location.coordinate.latitude), 经度: \(location.coordinate.longitude), 精度: \(location.horizontalAccuracy)m"
    }
}

// MARK: - 二、CLLocationDegrees扩展
public extension CLLocationDegrees {
    /// 转换为弧度
    var radians: Double {
        return self * .pi / 180.0
    }
    
    /// 转换为度
    var degrees: Double {
        return self * 180.0 / .pi
    }
}
