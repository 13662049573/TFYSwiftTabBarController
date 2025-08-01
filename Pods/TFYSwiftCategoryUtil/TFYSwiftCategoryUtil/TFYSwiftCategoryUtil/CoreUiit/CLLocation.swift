import CoreLocation
import Combine
import Foundation

// MARK: - CLLocation Extensions
/// CLLocation 扩展，提供便捷的位置操作
/// 支持 iOS 15.0 及以上版本
/// 支持 iPhone 和 iPad 适配

public extension CLLocation {

    // MARK: - Convenience Initializers
    /// 便捷初始化方法
    
    /// 使用坐标初始化位置
    /// - Parameter coordinate: 坐标
    convenience init(from coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    /// 使用坐标和海拔初始化位置
    /// - Parameters:
    ///   - coordinate: 坐标
    ///   - altitude: 海拔（米）
    convenience init(from coordinate: CLLocationCoordinate2D, altitude: CLLocationDistance) {
        self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBest, verticalAccuracy: kCLLocationAccuracyBest, timestamp: Date())
    }
    
    /// 使用坐标、海拔和精度初始化位置
    /// - Parameters:
    ///   - coordinate: 坐标
    ///   - altitude: 海拔（米）
    ///   - horizontalAccuracy: 水平精度
    ///   - verticalAccuracy: 垂直精度
    convenience init(from coordinate: CLLocationCoordinate2D, altitude: CLLocationDistance, horizontalAccuracy: CLLocationAccuracy, verticalAccuracy: CLLocationAccuracy) {
        self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, timestamp: Date())
    }
    
    // MARK: - Distance Calculations
    /// 距离计算方法
    
    /// 计算到另一个位置的距离（米）
    /// - Parameter other: 另一个位置
    /// - Returns: 距离（米）
    func distance(to other: CLLocation) -> CLLocationDistance {
        return self.distance(from: other)
    }
    
    /// 计算到指定坐标的距离（米）
    /// - Parameter coordinate: 目标坐标
    /// - Returns: 距离（米）
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let otherLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return self.distance(from: otherLocation)
    }
    
    /// 计算到指定坐标的距离（米）
    /// - Parameters:
    ///   - latitude: 纬度
    ///   - longitude: 经度
    /// - Returns: 距离（米）
    func distance(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> CLLocationDistance {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return distance(to: coordinate)
    }
    
    /// 计算到另一个位置的距离（公里）
    /// - Parameter other: 另一个位置
    /// - Returns: 距离（公里）
    func distanceInKilometers(to other: CLLocation) -> Double {
        return distance(to: other) / 1000.0
    }
    
    /// 计算到指定坐标的距离（公里）
    /// - Parameter coordinate: 目标坐标
    /// - Returns: 距离（公里）
    func distanceInKilometers(to coordinate: CLLocationCoordinate2D) -> Double {
        return distance(to: coordinate) / 1000.0
    }
    
    /// 计算到另一个位置的距离（英里）
    /// - Parameter other: 另一个位置
    /// - Returns: 距离（英里）
    func distanceInMiles(to other: CLLocation) -> Double {
        return distance(to: other) * 0.000621371
    }
    
    /// 计算到指定坐标的距离（英里）
    /// - Parameter coordinate: 目标坐标
    /// - Returns: 距离（英里）
    func distanceInMiles(to coordinate: CLLocationCoordinate2D) -> Double {
        return distance(to: coordinate) * 0.000621371
    }
    
    // MARK: - Bearing Calculations
    /// 方位角计算方法
    
    /// 计算到另一个位置的方位角（弧度）
    /// - Parameter other: 另一个位置
    /// - Returns: 方位角（弧度）
    func bearing(to other: CLLocation) -> Double {
        let lat1 = coordinate.latitude * .pi / 180
        let lat2 = other.coordinate.latitude * .pi / 180
        let deltaLon = (other.coordinate.longitude - coordinate.longitude) * .pi / 180
        
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
        let bearing = atan2(y, x)
        
        return bearing
    }
    
    /// 计算到指定坐标的方位角（弧度）
    /// - Parameter coordinate: 目标坐标
    /// - Returns: 方位角（弧度）
    func bearing(to coordinate: CLLocationCoordinate2D) -> Double {
        let otherLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return bearing(to: otherLocation)
    }
    
    /// 计算到另一个位置的方位角（度数）
    /// - Parameter other: 另一个位置
    /// - Returns: 方位角（度数）
    func bearingInDegrees(to other: CLLocation) -> Double {
        return bearing(to: other) * 180 / .pi
    }
    
    /// 计算到指定坐标的方位角（度数）
    /// - Parameter coordinate: 目标坐标
    /// - Returns: 方位角（度数）
    func bearingInDegrees(to coordinate: CLLocationCoordinate2D) -> Double {
        return bearing(to: coordinate) * 180 / .pi
    }
    
    // MARK: - Midpoint Calculations
    /// 中点计算方法
    
    /// 计算与另一个位置的中点
    /// - Parameter other: 另一个位置
    /// - Returns: 中点位置
    func midpoint(with other: CLLocation) -> CLLocation {
        let lat1 = coordinate.latitude * .pi / 180
        let lat2 = other.coordinate.latitude * .pi / 180
        let lon1 = coordinate.longitude * .pi / 180
        let lon2 = other.coordinate.longitude * .pi / 180
        let deltaLon = lon2 - lon1
        
        let Bx = cos(lat2) * cos(deltaLon)
        let By = cos(lat2) * sin(deltaLon)
        
        let midLat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + Bx) * (cos(lat1) + Bx) + By * By))
        let midLon = lon1 + atan2(By, cos(lat1) + Bx)
        
        let midCoordinate = CLLocationCoordinate2D(
            latitude: midLat * 180 / .pi,
            longitude: midLon * 180 / .pi
        )
        
        return CLLocation(coordinate: midCoordinate, altitude: (altitude + other.altitude) / 2, horizontalAccuracy: max(horizontalAccuracy, other.horizontalAccuracy), verticalAccuracy: max(verticalAccuracy, other.verticalAccuracy), timestamp: Date())
    }
    
    // MARK: - Validation Methods
    /// 验证方法
    
    /// 检查位置是否有效
    /// - Returns: 是否有效
    var isValid: Bool {
        return coordinate.latitude != 0 || coordinate.longitude != 0
    }
    
    /// 检查位置是否在指定范围内
    /// - Parameters:
    ///   - center: 中心位置
    ///   - radius: 半径（米）
    /// - Returns: 是否在范围内
    func isWithin(radius: CLLocationDistance, of center: CLLocation) -> Bool {
        return distance(to: center) <= radius
    }
    
    /// 检查位置是否在指定坐标范围内
    /// - Parameters:
    ///   - center: 中心坐标
    ///   - radius: 半径（米）
    /// - Returns: 是否在范围内
    func isWithin(radius: CLLocationDistance, of center: CLLocationCoordinate2D) -> Bool {
        return distance(to: center) <= radius
    }
    
    // MARK: - Geocoding
    /// 地理编码方法
    
    /// 地理编码错误类型
    enum GeocodeError: Error, LocalizedError {
        case invalid(String)
        case empty(String)
        case networkError(String)
        
        public var errorDescription: String? {
            switch self {
            case .invalid(let message):
                return "Invalid geocode: \(message)"
            case .empty(let message):
                return "Empty geocode result: \(message)"
            case .networkError(let message):
                return "Network error: \(message)"
            }
        }
    }

    /// 反向地理编码位置
    /// 将坐标转换为地址信息
    /// - Returns: 包含地址信息的 Future
    func reverseGeocode() -> Deferred<Future<[CLPlacemark], GeocodeError>> {
        Deferred {
            Future { promise in
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(self) { placemarks, error -> Void in
                    if let err = error {
                        return promise(.failure(.networkError("\(String(describing: err))")))
                    }
                    guard let marks = placemarks, !marks.isEmpty else {
                        return promise(.failure(.empty("\(String(describing: placemarks))")))
                    }
                    return promise(.success(marks))
                }
            }
        }
    }
    
    /// 反向地理编码位置（简化版本）
    /// 返回第一个地址信息
    /// - Returns: 包含地址信息的 Future
    func reverseGeocodeFirst() -> Deferred<Future<CLPlacemark, GeocodeError>> {
        Deferred {
            Future { promise in
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(self) { placemarks, error -> Void in
                    if let err = error {
                        return promise(.failure(.networkError("\(String(describing: err))")))
                    }
                    guard let marks = placemarks, let firstMark = marks.first else {
                        return promise(.failure(.empty("\(String(describing: placemarks))")))
                    }
                    return promise(.success(firstMark))
                }
            }
        }
    }
    
    // MARK: - Utility Methods
    /// 实用方法
    
    /// 获取位置的字符串表示
    /// - Parameter format: 格式类型
    /// - Returns: 格式化的字符串
    func formattedString(format: LocationFormat = .decimal) -> String {
        switch format {
        case .decimal:
            return String(format: "%.6f, %.6f", coordinate.latitude, coordinate.longitude)
        case .degreesMinutes:
            return "\(coordinate.latitude.toDegreesMinutes), \(coordinate.longitude.toDegreesMinutes)"
        case .degreesMinutesSeconds:
            return "\(coordinate.latitude.toDegreesMinutesSeconds), \(coordinate.longitude.toDegreesMinutesSeconds)"
        }
    }
    
    /// 获取位置的详细字符串表示
    /// - Returns: 详细的位置信息
    var detailedString: String {
        var result = "Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)"
        if altitude != 0 {
            result += ", Altitude: \(altitude)m"
        }
        if horizontalAccuracy > 0 {
            result += ", Accuracy: ±\(horizontalAccuracy)m"
        }
        if speed > 0 {
            result += ", Speed: \(speed)m/s"
        }
        if course > 0 {
            result += ", Course: \(course)°"
        }
        return result
    }
}

// MARK: - Location Format Enum
/// 位置格式枚举

public enum LocationFormat {
    case decimal
    case degreesMinutes
    case degreesMinutesSeconds
}

// MARK: - CLLocationDegrees Extensions
/// CLLocationDegrees 扩展

public extension CLLocationDegrees {
    
    /// 转换为度分格式
    var toDegreesMinutes: String {
        let degrees = Int(self)
        let minutes = abs(self - Double(degrees)) * 60
        return String(format: "%d° %.4f'", degrees, minutes)
    }
    
    /// 转换为度分秒格式
    var toDegreesMinutesSeconds: String {
        let degrees = Int(self)
        let minutes = Int((abs(self - Double(degrees)) * 60))
        let seconds = (abs(self - Double(degrees)) * 60 - Double(minutes)) * 60
        return String(format: "%d° %d' %.2f\"", degrees, minutes, seconds)
    }
}

// MARK: - CLLocation Convenience Methods
/// CLLocation 便捷方法

public extension CLLocation {
    
    /// 创建位置（使用度分格式）
    /// - Parameters:
    ///   - latitudeDegrees: 纬度度数
    ///   - latitudeMinutes: 纬度分钟
    ///   - longitudeDegrees: 经度度数
    ///   - longitudeMinutes: 经度分钟
    /// - Returns: 位置对象
    static func fromDegreesMinutes(
        latitudeDegrees: Int, latitudeMinutes: Double,
        longitudeDegrees: Int, longitudeMinutes: Double
    ) -> CLLocation {
        let latitude = Double(latitudeDegrees) + latitudeMinutes / 60.0
        let longitude = Double(longitudeDegrees) + longitudeMinutes / 60.0
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /// 创建位置（使用度分秒格式）
    /// - Parameters:
    ///   - latitudeDegrees: 纬度度数
    ///   - latitudeMinutes: 纬度分钟
    ///   - latitudeSeconds: 纬度秒数
    ///   - longitudeDegrees: 经度度数
    ///   - longitudeMinutes: 经度分钟
    ///   - longitudeSeconds: 经度秒数
    /// - Returns: 位置对象
    static func fromDegreesMinutesSeconds(
        latitudeDegrees: Int, latitudeMinutes: Int, latitudeSeconds: Double,
        longitudeDegrees: Int, longitudeMinutes: Int, longitudeSeconds: Double
    ) -> CLLocation {
        let latitude = Double(latitudeDegrees) + Double(latitudeMinutes) / 60.0 + latitudeSeconds / 3600.0
        let longitude = Double(longitudeDegrees) + Double(longitudeMinutes) / 60.0 + longitudeSeconds / 3600.0
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
