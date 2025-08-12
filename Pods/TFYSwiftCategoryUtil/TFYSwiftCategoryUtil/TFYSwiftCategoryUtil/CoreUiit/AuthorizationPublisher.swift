import Foundation
import Combine
import CoreLocation

// MARK: - Authorization Publisher Protocols
/// 授权发布者协议，定义授权状态回调
/// 支持 iOS 15.0 及以上版本

/// 发布者授权代理协议
protocol PublisherAuthorizationDelegate: AnyObject {
    /// 发送授权状态
    /// - Parameter status: 位置授权状态
    func send(status: CLAuthorizationStatus)
}

/// 订阅授权代理协议
protocol SubscriptionAuthorizationDelegate: AnyObject {
    /// 请求授权
    /// - Parameter type: 授权类型
    func requestAuthorization(type: CLLocationManager.AuthorizationType)
}

// MARK: - Authorization Subscription
/// 授权订阅类，处理授权状态的订阅逻辑

final class AuthorizationSubscription <S: Subscriber>: NSObject,
    PublisherAuthorizationDelegate,
    Subscription where S.Input == CLAuthorizationStatus,
                       S.Failure == Never {
    
    typealias Output = CLAuthorizationStatus
    typealias Failure = Never

    /// 订阅者
    var subscriber: S?
    
    /// 授权代理
    private var delegate: SubscriptionAuthorizationDelegate?
    
    /// 授权类型
    private let authorizationType: CLLocationManager.AuthorizationType
    
    /// 是否已请求授权
    private var hasRequestedAuthorization = false

    /// 初始化授权订阅
    /// - Parameters:
    ///   - subscriber: 订阅者
    ///   - authorizationType: 授权类型
    ///   - delegate: 授权代理
    init(
        subscriber: S,
        authorizationType: CLLocationManager.AuthorizationType,
        delegate: SubscriptionAuthorizationDelegate
    ) {
        self.subscriber = subscriber
        self.delegate = delegate
        self.authorizationType = authorizationType
        super.init()
    }
    
    /// 请求数据
    /// - Parameter demand: 需求数量
    func request(_ demand: Subscribers.Demand) {
        // 避免重复请求授权
        guard !hasRequestedAuthorization else { return }
        hasRequestedAuthorization = true
        delegate?.requestAuthorization(type: authorizationType)
    }

    /// 取消订阅
    func cancel() {
        subscriber = nil
        delegate = nil
    }
    
    // MARK: - PublisherAuthorizationDelegate
    
    /// 发送授权状态
    /// - Parameter status: 位置授权状态
    func send(status: CLAuthorizationStatus) {
        _ = subscriber?.receive(status)
    }
}

// MARK: - Authorization Publisher
/// 授权发布者类，管理位置授权状态

final class AuthorizationPublisher: NSObject,
                                    Publisher,
                                    CLLocationManagerDelegate,
                                    SubscriptionAuthorizationDelegate {

    typealias Output = CLAuthorizationStatus
    typealias Failure = Never

    /// 位置管理器
    private let manager: CLLocationManager
    
    /// 授权类型
    private let authorizationType: CLLocationManager.AuthorizationType
    
    /// 发布者授权代理
    private var publisherAuthorizationDelegate: PublisherAuthorizationDelegate?
    
    /// 是否已初始化
    private var isInitialized = false

    /// 初始化授权发布者
    /// - Parameters:
    ///   - manager: 位置管理器
    ///   - authorizationType: 授权类型
    init(manager: CLLocationManager, authorizationType: CLLocationManager.AuthorizationType) {
        self.manager = manager
        self.authorizationType = authorizationType
        super.init()
        self.manager.delegate = self
    }
    
    /// 接收订阅者
    /// - Parameter subscriber: 订阅者
    func receive<S>(subscriber: S) where S: Subscriber, AuthorizationPublisher.Failure == S.Failure, AuthorizationPublisher.Output == S.Input {
        let subscription = AuthorizationSubscription(
            subscriber: subscriber,
            authorizationType: authorizationType,
            delegate: self
        )
        subscriber.receive(subscription: subscription)
        publisherAuthorizationDelegate = subscription
        
        // 发送当前授权状态
        if !isInitialized {
            isInitialized = true
            publisherAuthorizationDelegate?.send(status: manager.authorizationStatus)
        }
    }

    // MARK: - CLLocationManagerDelegate

    /// 位置管理器授权状态改变回调
    /// - Parameters:
    ///   - manager: 位置管理器
    ///   - status: 新的授权状态
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        publisherAuthorizationDelegate?.send(status: status)
    }
    
    /// 位置管理器授权状态改变回调（iOS 14+）
    /// - Parameters:
    ///   - manager: 位置管理器
    ///   - status: 新的授权状态
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        publisherAuthorizationDelegate?.send(status: manager.authorizationStatus)
    }

    // MARK: - AuthorizationSubscriptionDelegate

    /// 请求授权
    /// - Parameter type: 授权类型
    func requestAuthorization(type: CLLocationManager.AuthorizationType) {
        switch type {
        case .whenInUse:
            (manager as CLLocationManager).requestWhenInUseAuthorization()
        case .always:
            (manager as CLLocationManager).requestAlwaysAuthorization()
        }
    }
}

// MARK: - CLLocationManager Authorization Extensions
/// CLLocationManager 授权扩展

public extension CLLocationManager {
    
    /// 请求使用中授权
    /// - Returns: 授权状态发布者
    func publisherForWhenInUseAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        AuthorizationPublisher(manager: self, authorizationType: .whenInUse)
            .eraseToAnyPublisher()
    }
    
    /// 请求始终授权
    /// - Returns: 授权状态发布者
    func publisherForAlwaysAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        AuthorizationPublisher(manager: self, authorizationType: .always)
            .eraseToAnyPublisher()
    }
}

