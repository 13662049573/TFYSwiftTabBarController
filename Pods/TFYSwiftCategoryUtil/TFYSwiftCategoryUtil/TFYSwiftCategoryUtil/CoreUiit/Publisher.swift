import Combine
import Foundation
import UIKit

// MARK: - Publisher Extensions
/// Publisher 扩展，提供便捷的 Combine 操作
/// 支持 iOS 15.0 及以上版本

public extension Publisher where Failure == Never {

    /// 在主线程上接收输出值 (DispatchQueue.main)
    /// 用于确保 UI 更新在主线程执行
    /// - Returns: 在主线程上接收的 Publisher
    func receiveOnMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        self.receive(on: DispatchQueue.main)
    }

    /// 单值接收函数，输出 `Result` 类型
    /// 将 Publisher 的输出包装在 Result 中，便于错误处理
    /// - Parameter result: 处理 Result<Output, Failure> 的闭包
    /// - Returns: AnyCancellable 用于取消订阅
    func sink(result: @escaping ((Result<Self.Output, Self.Failure>) -> Void)) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                result(.failure(error))
            case .finished: 
                // 完成时不调用 result，因为 Failure == Never
                break
            }
        }, receiveValue: { output in
            result(.success(output))
        })
    }

    /// 将属性分配给对象，无需使用 [weak self]
    /// 自动处理内存管理，避免循环引用
    /// - Parameters:
    ///   - keyPath: 属性路径
    ///   - root: 目标对象
    /// - Returns: AnyCancellable 用于取消订阅
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
    
    /// 延迟执行操作
    /// - Parameter delay: 延迟时间（秒）
    /// - Returns: 延迟后的 Publisher
    func delay(for delay: TimeInterval) -> Publishers.Delay<Self, DispatchQueue> {
        self.delay(for: .seconds(delay), scheduler: DispatchQueue.main)
    }
    
    /// 防抖操作，在指定时间内只保留最后一个值
    /// - Parameter interval: 防抖间隔时间（秒）
    /// - Returns: 防抖后的 Publisher
    func debounce(for interval: TimeInterval) -> Publishers.Debounce<Self, DispatchQueue> {
        self.debounce(for: .seconds(interval), scheduler: DispatchQueue.main)
    }
    
    /// 节流操作，在指定时间内只保留第一个值
    /// - Parameter interval: 节流间隔时间（秒）
    /// - Returns: 节流后的 Publisher
    func throttle(for interval: TimeInterval) -> Publishers.Throttle<Self, DispatchQueue> {
        self.throttle(for: .seconds(interval), scheduler: DispatchQueue.main, latest: false)
    }
}

// MARK: - Timer Publisher Protocol
/// 定时器启动协议，定义定时器的基本操作

public protocol TimerStartable {
    /// 启动定时器
    /// - Parameter totalTime: 总运行时间，nil 表示无限运行
    /// - Returns: 发布当前时间的 Publisher
    func start(totalTime: TimeInterval?) -> AnyPublisher<Date, Never>
    
    /// 停止定时器
    func stop()
}

// MARK: - Timer Publisher Extension
/// 自动连接定时器的扩展实现

extension Publishers.Autoconnect: TimerStartable where Upstream: Timer.TimerPublisher {
    
    /// 停止当前定时器发布者实例
    public func stop() {
        upstream.connect().cancel()
    }
    
    /// 启动定时器，可选择在指定时间后自动停止
    /// - Parameter totalTime: 总运行时间，nil 表示无限运行直到手动停止
    /// - Returns: 发布当前时间的 Publisher
    public func start(totalTime: TimeInterval? = nil) -> AnyPublisher<Date, Never> {
        var timeElapsed: TimeInterval = 0
        return flatMap { date in
            return Future<Date, Never> { promise in
                if let totalTime = totalTime, timeElapsed >= totalTime { 
                    self.stop() 
                }
                promise(.success(date))
                timeElapsed += 1
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - Convenience Timer Extensions
/// 便捷的定时器创建方法

public extension Publishers {
    
    /// 创建重复定时器
    /// - Parameters:
    ///   - interval: 时间间隔（秒）
    ///   - tolerance: 容差时间（秒）
    ///   - runLoop: 运行循环，默认为 main
    ///   - mode: 运行模式，默认为 common
    /// - Returns: 自动连接的定时器 Publisher
    static func timer(interval: TimeInterval, tolerance: TimeInterval = 0, runLoop: RunLoop = .main, mode: RunLoop.Mode = .common) -> Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: interval, tolerance: tolerance, on: runLoop, in: mode).autoconnect()
    }
    
    /// 创建单次定时器
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - runLoop: 运行循环，默认为 main
    ///   - mode: 运行模式，默认为 common
    /// - Returns: 单次定时器 Publisher
    static func timer(delay: TimeInterval, runLoop: RunLoop = .main, mode: RunLoop.Mode = .common) -> AnyPublisher<Date, Never> {
        Timer.publish(every: delay, tolerance: 0, on: runLoop, in: mode)
            .autoconnect()
            .first()
            .eraseToAnyPublisher()
    }
}
