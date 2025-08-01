import Combine
import CoreLocation

// MARK: - CLLocationManager Extensions
/// CLLocationManager 扩展，提供便捷的位置管理操作
/// 支持 iOS 15.0 及以上版本
/// 支持 iPhone 和 iPad 适配

public extension CLLocationManager {
    
    // MARK: - Authorization Methods
    /// 授权方法
    
    /**
     ```
     class LocationStore: ObservableObject {
     
         @Published var status: CLAuthorizationStatus = .notDetermined
         let manager = CLLocationManager()
         var cancellables = Set<AnyCancellable>()
         
         func requestPermission() {
             manager
                 .requestLocationWhenInUseAuthorization()
                 .assign(to: &$status)
         }
     }
     ```
     */
    /// 请求使用中位置授权并订阅 `CLAuthorizationStatus` 更新
    /// - Returns: 授权状态发布者
    func requestLocationWhenInUseAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        AuthorizationPublisher(manager: self, authorizationType: .whenInUse)
            .eraseToAnyPublisher()
    }
    
    /**
     ```
     class LocationStore: ObservableObject {
     
         @Published var status: CLAuthorizationStatus = .notDetermined
         let manager = CLLocationManager()
         var cancellables = Set<AnyCancellable>()
         
         func requestPermission() {
             manager
                 .requestLocationWhenInUseAuthorization()
                 .assign(to: &$status)
         }
     }
     ```
     */
    /// 请求始终位置授权，包含升级提示
    /// - Returns: 授权状态发布者
    func requestLocationAlwaysAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        AuthorizationPublisher(manager: self, authorizationType: .whenInUse)
            .flatMap { status -> AnyPublisher<CLAuthorizationStatus, Never> in
                if status == CLAuthorizationStatus.authorizedWhenInUse {
                    return AuthorizationPublisher(
                        manager: self,
                        authorizationType: .always
                    )
                    .eraseToAnyPublisher()
                }
                return Just(status).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    /// 请求授权并升级到始终授权
    /// 先请求使用中授权，如果用户同意则升级到始终授权
    /// - Returns: 授权状态发布者
    func requestAuthorizationWithUpgrade() -> AnyPublisher<CLAuthorizationStatus, Never> {
        AuthorizationPublisher(manager: self, authorizationType: .whenInUse)
            .flatMap { status -> AnyPublisher<CLAuthorizationStatus, Never> in
                if status == .authorizedWhenInUse {
                    return AuthorizationPublisher(
                        manager: self,
                        authorizationType: .always
                    )
                    .eraseToAnyPublisher()
                }
                return Just(status).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Location Updates
    /// 位置更新方法
    
    /**
     ```
     class LocationStore: ObservableObject {
         
         @Published var coordinate: CLLocationCoordinate2D = .zero
         let manager = CLLocationManager()
         var cancellables = Set<AnyCancellable>()
         
         func requestLocation() {
             manager
                 .receiveLocationUpdates()
                 .compactMap(\.last)
                 .map(\.coordinate)
                 .replaceError(with: .zero)
                 .assign(to: &$coordinate)
         }
     }
     ```
     */
    /// 接收位置管理器发送的位置更新
    /// - Parameter oneTime: 单次位置更新或持续更新，默认为 false
    /// - Returns: 位置数组或错误的发布者
    func receiveLocationUpdates(oneTime: Bool = false) -> AnyPublisher<[CLLocation], Error> {
        LocationPublisher(manager: self, onTimeUpdate: oneTime)
            .eraseToAnyPublisher()
    }
    
    /// 接收单次位置更新
    /// - Returns: 位置数组或错误的发布者
    func receiveSingleLocationUpdate() -> AnyPublisher<[CLLocation], Error> {
        return receiveLocationUpdates(oneTime: true)
    }
    
    /// 接收持续位置更新
    /// - Returns: 位置数组或错误的发布者
    func receiveContinuousLocationUpdates() -> AnyPublisher<[CLLocation], Error> {
        return receiveLocationUpdates(oneTime: false)
    }
    
    // MARK: - Heading Updates
    /// 方向更新方法
    
    /// 接收方向更新
    /// - Returns: 方向信息或错误的发布者
    func receiveHeadingUpdates() -> AnyPublisher<CLHeading, Error> {
        return HeadingPublisher(manager: self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Region Monitoring
    /// 区域监控方法
    
    /// 监控指定区域
    /// - Parameter region: 要监控的区域
    /// - Returns: 区域事件发布者
    func monitorRegion(_ region: CLRegion) -> AnyPublisher<RegionEvent, Error> {
        return RegionPublisher(manager: self, region: region)
            .eraseToAnyPublisher()
    }
    
    /// 监控多个区域
    /// - Parameter regions: 要监控的区域数组
    /// - Returns: 区域事件发布者
    func monitorRegions(_ regions: [CLRegion]) -> AnyPublisher<RegionEvent, Error> {
        return RegionsPublisher(manager: self, regions: regions)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Visit Monitoring
    /// 访问监控方法
    
    /// 监控访问事件
    /// - Returns: 访问事件发布者
    func monitorVisits() -> AnyPublisher<CLVisit, Error> {
        return VisitPublisher(manager: self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Authorization Access Level
    /// 授权访问级别
    
    /// 授权类型枚举
    internal enum AuthorizationType: String {
        case always, whenInUse
    }
    
    // MARK: - Utility Methods
    /// 实用方法
    
    /// 检查位置服务是否可用
    /// - Returns: 位置服务是否可用
    var isLocationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// 检查授权状态
    /// - Returns: 当前授权状态
    var currentAuthorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return self.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    /// 检查是否有位置权限
    /// - Returns: 是否有位置权限
    var hasLocationPermission: Bool {
        switch currentAuthorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            return false
        }
    }
    
    /// 检查是否有始终位置权限
    /// - Returns: 是否有始终位置权限
    var hasAlwaysLocationPermission: Bool {
        return currentAuthorizationStatus == .authorizedAlways
    }
    
    /// 配置位置管理器为最佳精度
    func configureForBestAccuracy() {
        desiredAccuracy = kCLLocationAccuracyBest
        distanceFilter = kCLDistanceFilterNone
        activityType = .fitness
    }
    
    /// 配置位置管理器为导航精度
    func configureForNavigation() {
        desiredAccuracy = kCLLocationAccuracyBestForNavigation
        distanceFilter = kCLDistanceFilterNone
        activityType = .automotiveNavigation
    }
    
    /// 配置位置管理器为省电模式
    func configureForPowerSaving() {
        desiredAccuracy = kCLLocationAccuracyHundredMeters
        distanceFilter = 100
        activityType = .other
    }
}

// MARK: - Region Event Type
/// 区域事件类型

public enum RegionEvent {
    case enter(CLRegion)
    case exit(CLRegion)
    case stateChange(CLRegion, CLRegionState)
}

// MARK: - Heading Publisher
/// 方向发布者

private class HeadingPublisher: NSObject, Publisher, CLLocationManagerDelegate {
    typealias Output = CLHeading
    typealias Failure = Error
    
    let manager: CLLocationManager
    private var subscriber: AnySubscriber<CLHeading, Error>?
    
    init(manager: CLLocationManager) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, HeadingPublisher.Failure == S.Failure, HeadingPublisher.Output == S.Input {
        self.subscriber = AnySubscriber(subscriber)
        subscriber.receive(subscription: HeadingSubscription(publisher: self))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        _ = subscriber?.receive(newHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        subscriber?.receive(completion: .failure(error))
    }
}

private class HeadingSubscription: Subscription {
    private let publisher: HeadingPublisher
    
    init(publisher: HeadingPublisher) {
        self.publisher = publisher
    }
    
    func request(_ demand: Subscribers.Demand) {
        publisher.manager.startUpdatingHeading()
    }
    
    func cancel() {
        publisher.manager.stopUpdatingHeading()
    }
}

// MARK: - Region Publisher
/// 区域发布者

private class RegionPublisher: NSObject, Publisher, CLLocationManagerDelegate {
    typealias Output = RegionEvent
    typealias Failure = Error
    
    let manager: CLLocationManager
    let region: CLRegion
    private var subscriber: AnySubscriber<RegionEvent, Error>?
    
    init(manager: CLLocationManager, region: CLRegion) {
        self.manager = manager
        self.region = region
        super.init()
        self.manager.delegate = self
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, RegionPublisher.Failure == S.Failure, RegionPublisher.Output == S.Input {
        self.subscriber = AnySubscriber(subscriber)
        subscriber.receive(subscription: RegionSubscription(publisher: self))
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == self.region.identifier {
            _ = subscriber?.receive(.enter(region))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == self.region.identifier {
            _ = subscriber?.receive(.exit(region))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if region.identifier == self.region.identifier {
            _ = subscriber?.receive(.stateChange(region, state))
        }
    }
}

private class RegionSubscription: Subscription {
    private let publisher: RegionPublisher
    
    init(publisher: RegionPublisher) {
        self.publisher = publisher
    }
    
    func request(_ demand: Subscribers.Demand) {
        publisher.manager.startMonitoring(for: publisher.region)
    }
    
    func cancel() {
        publisher.manager.stopMonitoring(for: publisher.region)
    }
}

// MARK: - Regions Publisher
/// 多区域发布者

private class RegionsPublisher: NSObject, Publisher, CLLocationManagerDelegate {
    typealias Output = RegionEvent
    typealias Failure = Error
    
    let manager: CLLocationManager
    let regions: [CLRegion]
    private var subscriber: AnySubscriber<RegionEvent, Error>?
    
    init(manager: CLLocationManager, regions: [CLRegion]) {
        self.manager = manager
        self.regions = regions
        super.init()
        self.manager.delegate = self
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, RegionsPublisher.Failure == S.Failure, RegionsPublisher.Output == S.Input {
        self.subscriber = AnySubscriber(subscriber)
        subscriber.receive(subscription: RegionsSubscription(publisher: self))
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if regions.contains(where: { $0.identifier == region.identifier }) {
            _ = subscriber?.receive(.enter(region))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if regions.contains(where: { $0.identifier == region.identifier }) {
            _ = subscriber?.receive(.exit(region))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if regions.contains(where: { $0.identifier == region.identifier }) {
            _ = subscriber?.receive(.stateChange(region, state))
        }
    }
}

private class RegionsSubscription: Subscription {
    private let publisher: RegionsPublisher
    
    init(publisher: RegionsPublisher) {
        self.publisher = publisher
    }
    
    func request(_ demand: Subscribers.Demand) {
        for region in publisher.regions {
            publisher.manager.startMonitoring(for: region)
        }
    }
    
    func cancel() {
        for region in publisher.regions {
            publisher.manager.stopMonitoring(for: region)
        }
    }
}

// MARK: - Visit Publisher
/// 访问发布者

private class VisitPublisher: NSObject, Publisher, CLLocationManagerDelegate {
    typealias Output = CLVisit
    typealias Failure = Error
    
    let manager: CLLocationManager
    private var subscriber: AnySubscriber<CLVisit, Error>?
    
    init(manager: CLLocationManager) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, VisitPublisher.Failure == S.Failure, VisitPublisher.Output == S.Input {
        self.subscriber = AnySubscriber(subscriber)
        subscriber.receive(subscription: VisitSubscription(publisher: self))
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        _ = subscriber?.receive(visit)
    }
}

private class VisitSubscription: Subscription {
    private let publisher: VisitPublisher
    
    init(publisher: VisitPublisher) {
        self.publisher = publisher
    }
    
    func request(_ demand: Subscribers.Demand) {
        publisher.manager.startMonitoringVisits()
    }
    
    func cancel() {
        publisher.manager.stopMonitoringVisits()
    }
}
