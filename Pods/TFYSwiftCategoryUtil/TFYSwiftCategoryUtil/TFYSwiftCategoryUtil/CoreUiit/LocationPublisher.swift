import Combine
import CoreLocation

// MARK: - Location Publisher Protocols
/// 位置发布者协议，定义位置更新回调
/// 支持 iOS 15.0 及以上版本

/// 发布者位置代理协议
public protocol PublisherLocationDelegate: AnyObject {
    /// 开始位置更新
    func startLocationUpdates()
}

/// 订阅位置代理协议
public protocol SubscriptionLocationDelegate: AnyObject {
    /// 位置更新回调
    /// - Parameter locations: 位置数组
    func didUpdate(with locations: [CLLocation])
    
    /// 位置更新失败回调
    /// - Parameter error: 错误信息
    func didFail(with error: Error)
}

// MARK: - Location Subscription
/// 位置订阅类，处理位置更新的订阅逻辑

public final class LocationSubscription <S: Subscriber>:
    NSObject,
    SubscriptionLocationDelegate,
    Subscription where S.Input == [CLLocation],
                       S.Failure == Error {

    /// 订阅者
    var subscriber: S?
    
    /// 发布者代理
    private var publisherDelegate: PublisherLocationDelegate?
    
    /// 是否已开始位置更新
    private var hasStartedUpdates = false
    
    /// 初始化位置订阅
    /// - Parameters:
    ///   - subscriber: 订阅者
    ///   - delegate: 发布者代理
    init(subscriber: S?, delegate: PublisherLocationDelegate?) {
        self.subscriber = subscriber
        self.publisherDelegate = delegate
        super.init()
    }

    /// 位置更新回调
    /// - Parameter locations: 位置数组
    public func didUpdate(with locations: [CLLocation]) {
        _ = subscriber?.receive(locations)
    }
    
    /// 位置更新失败回调
    /// - Parameter error: 错误信息
    public func didFail(with error: Error) {
        _ = subscriber?.receive(completion: .failure(error))
    }
    
    /// 请求数据
    /// - Parameter demand: 需求数量
    public func request(_ demand: Subscribers.Demand) {
        // 避免重复开始位置更新
        guard !hasStartedUpdates else { return }
        hasStartedUpdates = true
        publisherDelegate?.startLocationUpdates()
    }

    /// 取消订阅
    public func cancel() {
        subscriber = nil
        publisherDelegate = nil
    }
}

// MARK: - Location Publisher
/// 位置发布者类，管理位置更新

public final class LocationPublisher: NSObject,
                               Publisher,
                               CLLocationManagerDelegate,
                               PublisherLocationDelegate {
    public typealias Output = [CLLocation]
    public typealias Failure = Error
    
    /// 位置管理器
    private let manager: CLLocationManager
    
    /// 是否为单次更新
    private let oneTimeUpdate: Bool
    
    /// 订阅者代理
    private var subscriberDelegate: SubscriptionLocationDelegate?
    
    /// 是否已初始化
    private var isInitialized = false
    
    /// 初始化位置发布者
    /// - Parameters:
    ///   - manager: 位置管理器
    ///   - onTimeUpdate: 是否为单次更新
    init(manager: CLLocationManager, onTimeUpdate: Bool = false) {
        self.manager = manager
        self.oneTimeUpdate = onTimeUpdate
        super.init()
        self.manager.delegate = self
    }
    
    // MARK: Publisher
    
    /// 接收订阅者
    /// - Parameter subscriber: 订阅者
    public func receive<S>(subscriber: S) where S : Subscriber, LocationPublisher.Failure == S.Failure, LocationPublisher.Output == S.Input {
        let subscription = LocationSubscription(
            subscriber: subscriber,
            delegate: self
        )
        subscriber.receive(subscription: subscription)
        subscriberDelegate = subscription
        
        // 发送当前位置（如果可用）
        if !isInitialized {
            isInitialized = true
            if let location = manager.location {
                subscriberDelegate?.didUpdate(with: [location])
            }
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    /// 位置管理器错误回调
    /// - Parameters:
    ///   - manager: 位置管理器
    ///   - error: 错误信息
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        subscriberDelegate?.didFail(with: error)
        manager.stopUpdatingLocation()
    }
    
    /// 位置管理器位置更新回调
    /// - Parameters:
    ///   - manager: 位置管理器
    ///   - locations: 位置数组
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        subscriberDelegate?.didUpdate(with: locations)
        
        // 如果是单次更新，停止位置更新
        if oneTimeUpdate {
            manager.stopUpdatingLocation()
        }
    }
    
    /// 位置管理器授权状态改变回调
    /// - Parameters:
    ///   - manager: 位置管理器
    ///   - status: 授权状态
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            let error = NSError(domain: "LocationPublisher", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"])
            subscriberDelegate?.didFail(with: error)
        case .authorizedWhenInUse, .authorizedAlways:
            // 授权成功，可以开始位置更新
            break
        case .notDetermined:
            // 等待用户决定
            break
        @unknown default:
            break
        }
    }
    
    /// 位置管理器授权状态改变回调（iOS 14+）
    /// - Parameter manager: 位置管理器
    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .denied, .restricted:
            let error = NSError(domain: "LocationPublisher", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"])
            subscriberDelegate?.didFail(with: error)
        case .authorizedWhenInUse, .authorizedAlways:
            // 授权成功，可以开始位置更新
            break
        case .notDetermined:
            // 等待用户决定
            break
        @unknown default:
            break
        }
    }
    
    // MARK: PublisherLocationDelegate
    
    /// 开始位置更新
    public func startLocationUpdates() {
        // 检查位置服务是否可用
        guard CLLocationManager.locationServicesEnabled() else {
            let error = NSError(domain: "LocationPublisher", code: 2, userInfo: [NSLocalizedDescriptionKey: "Location services are disabled"])
            subscriberDelegate?.didFail(with: error)
            return
        }
        
        // 检查授权状态
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if oneTimeUpdate {
                manager.requestLocation()
            } else {
                manager.startUpdatingLocation()
            }
        case .denied, .restricted:
            let error = NSError(domain: "LocationPublisher", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"])
            subscriberDelegate?.didFail(with: error)
        case .notDetermined:
            // 等待授权回调
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Location Publisher Extensions
/// 位置发布者扩展

public extension CLLocationManager {
    
    /// 创建位置发布者
    /// - Parameter oneTime: 是否为单次更新
    /// - Returns: 位置发布者
    func locationPublisher(oneTime: Bool = false) -> LocationPublisher {
        return LocationPublisher(manager: self, onTimeUpdate: oneTime)
    }
    
    /// 创建单次位置发布者
    /// - Returns: 单次位置发布者
    func singleLocationPublisher() -> LocationPublisher {
        return LocationPublisher(manager: self, onTimeUpdate: true)
    }
    
    /// 创建持续位置发布者
    /// - Returns: 持续位置发布者
    func continuousLocationPublisher() -> LocationPublisher {
        return LocationPublisher(manager: self, onTimeUpdate: false)
    }
}


