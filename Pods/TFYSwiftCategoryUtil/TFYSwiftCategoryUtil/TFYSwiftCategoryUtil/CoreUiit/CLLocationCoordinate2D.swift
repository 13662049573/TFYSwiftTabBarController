import CoreLocation

// MARK: - CLLocationCoordinate2D Extensions
/// CLLocationCoordinate2D 扩展，提供便捷的坐标操作
/// 支持 iOS 15.0 及以上版本
/// 支持 iPhone 和 iPad 适配

// MARK: - Equatable Extension
/// 等值比较扩展

extension CLLocationCoordinate2D: @retroactive Equatable {
    
    /// 等值比较操作符
    /// 比较两个坐标是否相等
    /// - Parameters:
    ///   - lhs: 左侧坐标
    ///   - rhs: 右侧坐标
    /// - Returns: 是否相等
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    /// 不等值比较操作符
    /// 比较两个坐标是否不相等
    /// - Parameters:
    ///   - lhs: 左侧坐标
    ///   - rhs: 右侧坐标
    /// - Returns: 是否不相等
    public static func != (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        !(lhs == rhs)
    }
}

// MARK: - Codable Extension
/// 编码解码扩展

extension CLLocationCoordinate2D: Codable {
    
    /// 零坐标点 (0, 0)
    public static let zero = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    /// 编码坐标到编码器
    /// - Parameter encoder: 编码器
    /// - Throws: 编码错误
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }

    /// 从解码器解码坐标
    /// - Parameter decoder: 解码器
    /// - Throws: 解码错误
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Coordinate Operations
/// 坐标操作方法

public extension CLLocationCoordinate2D {
    
    // MARK: - Distance Calculations
    /// 距离计算方法
    
    /// 计算到另一个坐标的距离（米）
    /// - Parameter other: 另一个坐标
    /// - Returns: 距离（米）
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: latitude, longitude: longitude)
        let location2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return location1.distance(from: location2)
    }
    
    /// 计算到指定坐标的距离（公里）
    /// - Parameter other: 另一个坐标
    /// - Returns: 距离（公里）
    func distanceInKilometers(to other: CLLocationCoordinate2D) -> Double {
        return distance(to: other) / 1000.0
    }
    
    /// 计算到指定坐标的距离（英里）
    /// - Parameter other: 另一个坐标
    /// - Returns: 距离（英里）
    func distanceInMiles(to other: CLLocationCoordinate2D) -> Double {
        return distance(to: other) * 0.000621371
    }
    
    // MARK: - Bearing Calculations
    /// 方位角计算方法
    
    /// 计算到另一个坐标的方位角（弧度）
    /// - Parameter other: 另一个坐标
    /// - Returns: 方位角（弧度）
    func bearing(to other: CLLocationCoordinate2D) -> Double {
        let lat1 = latitude * .pi / 180
        let lat2 = other.latitude * .pi / 180
        let deltaLon = (other.longitude - longitude) * .pi / 180
        
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
        let bearing = atan2(y, x)
        
        return bearing
    }
    
    /// 计算到另一个坐标的方位角（度数）
    /// - Parameter other: 另一个坐标
    /// - Returns: 方位角（度数）
    func bearingInDegrees(to other: CLLocationCoordinate2D) -> Double {
        return bearing(to: other) * 180 / .pi
    }
    
    // MARK: - Midpoint Calculations
    /// 中点计算方法
    
    /// 计算与另一个坐标的中点
    /// - Parameter other: 另一个坐标
    /// - Returns: 中点坐标
    func midpoint(with other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lat1 = latitude * .pi / 180
        let lat2 = other.latitude * .pi / 180
        let lon1 = longitude * .pi / 180
        let lon2 = other.longitude * .pi / 180
        let deltaLon = lon2 - lon1
        
        let Bx = cos(lat2) * cos(deltaLon)
        let By = cos(lat2) * sin(deltaLon)
        
        let midLat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + Bx) * (cos(lat1) + Bx) + By * By))
        let midLon = lon1 + atan2(By, cos(lat1) + Bx)
        
        return CLLocationCoordinate2D(
            latitude: midLat * 180 / .pi,
            longitude: midLon * 180 / .pi
        )
    }
    
    // MARK: - Validation Methods
    /// 验证方法
    
    /// 检查坐标是否有效
    /// - Returns: 是否有效
    var isValid: Bool {
        return latitude != 0 || longitude != 0
    }
    
    /// 检查坐标是否在有效范围内
    /// - Returns: 是否在有效范围内
    var isInValidRange: Bool {
        return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180
    }
    
    /// 检查坐标是否在指定范围内
    /// - Parameters:
    ///   - center: 中心坐标
    ///   - radius: 半径（米）
    /// - Returns: 是否在范围内
    func isWithin(radius: CLLocationDistance, of center: CLLocationCoordinate2D) -> Bool {
        return distance(to: center) <= radius
    }
    
    // MARK: - Coordinate Transformations
    /// 坐标变换方法
    
    /// 偏移坐标
    /// - Parameters:
    ///   - deltaLat: 纬度偏移量（度）
    ///   - deltaLon: 经度偏移量（度）
    /// - Returns: 偏移后的坐标
    func offset(deltaLat: CLLocationDegrees, deltaLon: CLLocationDegrees) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude + deltaLat,
            longitude: longitude + deltaLon
        )
    }
    
    /// 偏移坐标（使用距离）
    /// - Parameters:
    ///   - distance: 距离（米）
    ///   - bearing: 方位角（弧度）
    /// - Returns: 偏移后的坐标
    func offset(distance: CLLocationDistance, bearing: Double) -> CLLocationCoordinate2D {
        let lat1 = latitude * .pi / 180
        let lon1 = longitude * .pi / 180
        let brng = bearing
        let R = 6371000.0 // 地球半径（米）
        
        let lat2 = asin(sin(lat1) * cos(distance / R) + cos(lat1) * sin(distance / R) * cos(brng))
        let lon2 = lon1 + atan2(sin(brng) * sin(distance / R) * cos(lat1), cos(distance / R) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(
            latitude: lat2 * 180 / .pi,
            longitude: lon2 * 180 / .pi
        )
    }
    
    /// 偏移坐标（使用距离和方位角度数）
    /// - Parameters:
    ///   - distance: 距离（米）
    ///   - bearingDegrees: 方位角（度数）
    /// - Returns: 偏移后的坐标
    func offset(distance: CLLocationDistance, bearingDegrees: Double) -> CLLocationCoordinate2D {
        return offset(distance: distance, bearing: bearingDegrees * .pi / 180)
    }
    
    // MARK: - Utility Methods
    /// 实用方法
    
    /// 获取坐标的字符串表示
    /// - Parameter format: 格式类型
    /// - Returns: 格式化的字符串
    func formattedString(format: CoordinateFormat = .decimal) -> String {
        switch format {
        case .decimal:
            return String(format: "%.6f, %.6f", latitude, longitude)
        case .degreesMinutes:
            return "\(latitude.toDegreesMinutes), \(longitude.toDegreesMinutes)"
        case .degreesMinutesSeconds:
            return "\(latitude.toDegreesMinutesSeconds), \(longitude.toDegreesMinutesSeconds)"
        }
    }
    
    /// 获取坐标的详细字符串表示
    /// - Returns: 详细的坐标信息
    var detailedString: String {
        return "Latitude: \(latitude), Longitude: \(longitude)"
    }
    
    /// 获取坐标的简短字符串表示
    /// - Returns: 简短的坐标信息
    var shortString: String {
        return String(format: "%.4f, %.4f", latitude, longitude)
    }
}

// MARK: - Coordinate Format Enum
/// 坐标格式枚举

public enum CoordinateFormat {
    case decimal
    case degreesMinutes
    case degreesMinutesSeconds
}

// MARK: - CLLocationCoordinate2D Convenience Initializers
/// CLLocationCoordinate2D 便捷初始化方法

public extension CLLocationCoordinate2D {
    
    /// 使用度分格式初始化坐标
    /// - Parameters:
    ///   - latitudeDegrees: 纬度度数
    ///   - latitudeMinutes: 纬度分钟
    ///   - longitudeDegrees: 经度度数
    ///   - longitudeMinutes: 经度分钟
    init(latitudeDegrees: Int, latitudeMinutes: Double, longitudeDegrees: Int, longitudeMinutes: Double) {
        let latitude = Double(latitudeDegrees) + latitudeMinutes / 60.0
        let longitude = Double(longitudeDegrees) + longitudeMinutes / 60.0
        self.init(latitude: latitude, longitude: longitude)
    }
    
    /// 使用度分秒格式初始化坐标
    /// - Parameters:
    ///   - latitudeDegrees: 纬度度数
    ///   - latitudeMinutes: 纬度分钟
    ///   - latitudeSeconds: 纬度秒数
    ///   - longitudeDegrees: 经度度数
    ///   - longitudeMinutes: 经度分钟
    ///   - longitudeSeconds: 经度秒数
    init(latitudeDegrees: Int, latitudeMinutes: Int, latitudeSeconds: Double, longitudeDegrees: Int, longitudeMinutes: Int, longitudeSeconds: Double) {
        let latitude = Double(latitudeDegrees) + Double(latitudeMinutes) / 60.0 + latitudeSeconds / 3600.0
        let longitude = Double(longitudeDegrees) + Double(longitudeMinutes) / 60.0 + longitudeSeconds / 3600.0
        self.init(latitude: latitude, longitude: longitude)
    }
    
    /// 使用字符串初始化坐标（十进制格式）
    /// - Parameter coordinateString: 坐标字符串，格式为 "latitude,longitude"
    init?(from coordinateString: String) {
        let components = coordinateString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 2,
              let latitude = Double(components[0]),
              let longitude = Double(components[1]) else {
            return nil
        }
        self.init(latitude: latitude, longitude: longitude)
    }
}

// MARK: - CLLocationCoordinate2D Constants
/// CLLocationCoordinate2D 常量定义

public extension CLLocationCoordinate2D {
    
    /// 北京坐标
    static let beijing = CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)
    
    /// 上海坐标
    static let shanghai = CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737)
    
    /// 广州坐标
    static let guangzhou = CLLocationCoordinate2D(latitude: 23.1291, longitude: 113.2644)
    
    /// 深圳坐标
    static let shenzhen = CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694)
    
    /// 纽约坐标
    static let newYork = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    
    /// 伦敦坐标
    static let london = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
    
    /// 东京坐标
    static let tokyo = CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)
    
    /// 悉尼坐标
    static let sydney = CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)
}

// MARK: - CLLocationCoordinate2D Array Extensions
/// CLLocationCoordinate2D 数组扩展

public extension Array where Element == CLLocationCoordinate2D {
    
    /// 计算坐标数组的边界
    /// - Returns: 边界坐标（最小和最大坐标）
    var bounds: (min: CLLocationCoordinate2D, max: CLLocationCoordinate2D)? {
        guard !isEmpty else { return nil }
        
        let minLat = map { $0.latitude }.min() ?? 0
        let maxLat = map { $0.latitude }.max() ?? 0
        let minLon = map { $0.longitude }.min() ?? 0
        let maxLon = map { $0.longitude }.max() ?? 0
        
        return (
            min: CLLocationCoordinate2D(latitude: minLat, longitude: minLon),
            max: CLLocationCoordinate2D(latitude: maxLat, longitude: maxLon)
        )
    }
    
    /// 计算坐标数组的中心点
    /// - Returns: 中心坐标
    var center: CLLocationCoordinate2D? {
        guard !isEmpty else { return nil }
        
        let avgLat = map { $0.latitude }.reduce(0, +) / Double(count)
        let avgLon = map { $0.longitude }.reduce(0, +) / Double(count)
        
        return CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon)
    }
    
    /// 计算坐标数组的总距离
    /// - Returns: 总距离（米）
    var totalDistance: CLLocationDistance {
        guard count > 1 else { return 0 }
        
        var total: CLLocationDistance = 0
        for i in 0..<(count - 1) {
            total += self[i].distance(to: self[i + 1])
        }
        return total
    }
}
