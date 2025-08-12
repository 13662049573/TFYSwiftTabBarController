import Combine

// MARK: - Subscriber Extensions
/// Subscriber 扩展，提供便捷的订阅者操作
/// 支持 iOS 15.0 及以上版本

public extension Subscribers {
    
    /// 接收完成回调类型别名
    typealias ReceivedCompletion<E: Error> = (Subscribers.Completion<E>) -> Void
    
    /// 接收值回调类型别名
    typealias ReceivedValue<Input> = (Input) -> Void
    
    /// 限制接收次数的订阅者
    /// 用于限制 Publisher 发送的数据量，防止内存溢出
    class LimitedSink<Input, Failure>: Subscriber, Cancellable where Failure: Error {
        
        /// 最大接收次数
        private let demand: Int
        
        /// 当前已接收次数
        private var receivedCount: Int = 0
        
        /// 接收值的回调
        private let receivedValue: ReceivedValue<Input>
        
        /// 接收完成的回调
        private var receivedCompletion: ReceivedCompletion<Failure>?
        
        /// 订阅对象
        private var subscription: Subscription?
        
        /// 初始化限制接收次数的订阅者
        /// - Parameters:
        ///   - demand: 最大接收次数
        ///   - receivedValue: 接收值的回调
        init(demand: Int, receivedValue: @escaping ReceivedValue<Input>) {
            self.demand = demand
            self.receivedValue = receivedValue
        }
        
        /// 便利初始化方法，包含完成回调
        /// - Parameters:
        ///   - demand: 最大接收次数
        ///   - receivedCompletion: 接收完成的回调
        ///   - receivedValue: 接收值的回调
        convenience init(demand: Int, receivedCompletion: @escaping ReceivedCompletion<Failure>, receivedValue: @escaping ReceivedValue<Input>) {
            self.init(demand: demand, receivedValue: receivedValue)
            self.receivedCompletion = receivedCompletion
        }

        /// 接收订阅
        /// - Parameter subscription: 订阅对象
        public func receive(subscription: Subscription) {
            self.subscription = subscription
            // 请求指定数量的数据
            subscription.request(.max(demand))
        }
    
        /// 接收输入值
        /// - Parameter input: 输入值
        /// - Returns: 需求数量
        public func receive(_ input: Input) -> Subscribers.Demand {
            receivedValue(input)
            receivedCount += 1
            
            // 如果达到最大接收次数，取消订阅
            if receivedCount >= demand {
                cancel()
                return .none
            }
            
            return .none
        }
    
        /// 接收完成信号
        /// - Parameter completion: 完成状态
        public func receive(completion: Subscribers.Completion<Failure>) {
            receivedCompletion?(completion)
        }
        
        /// 取消订阅
        public func cancel() {
            subscription?.cancel()
            subscription = nil
        }
    }
    
    /// 缓冲订阅者
    /// 用于缓存一定数量的数据，然后一次性处理
    class BufferedSink<Input, Failure>: Subscriber, Cancellable where Failure: Error {
        
        /// 缓冲区大小
        private let bufferSize: Int
        
        /// 缓冲区
        private var buffer: [Input] = []
        
        /// 处理缓冲数据的回调
        private let processBuffer: ([Input]) -> Void
        
        /// 接收完成的回调
        private var receivedCompletion: ReceivedCompletion<Failure>?
        
        /// 订阅对象
        private var subscription: Subscription?
        
        /// 初始化缓冲订阅者
        /// - Parameters:
        ///   - bufferSize: 缓冲区大小
        ///   - processBuffer: 处理缓冲数据的回调
        init(bufferSize: Int, processBuffer: @escaping ([Input]) -> Void) {
            self.bufferSize = bufferSize
            self.processBuffer = processBuffer
        }
        
        /// 便利初始化方法，包含完成回调
        /// - Parameters:
        ///   - bufferSize: 缓冲区大小
        ///   - receivedCompletion: 接收完成的回调
        ///   - processBuffer: 处理缓冲数据的回调
        convenience init(bufferSize: Int, receivedCompletion: @escaping ReceivedCompletion<Failure>, processBuffer: @escaping ([Input]) -> Void) {
            self.init(bufferSize: bufferSize, processBuffer: processBuffer)
            self.receivedCompletion = receivedCompletion
        }
        
        /// 接收订阅
        /// - Parameter subscription: 订阅对象
        public func receive(subscription: Subscription) {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
        
        /// 接收输入值
        /// - Parameter input: 输入值
        /// - Returns: 需求数量
        public func receive(_ input: Input) -> Subscribers.Demand {
            buffer.append(input)
            
            // 当缓冲区满时，处理数据
            if buffer.count >= bufferSize {
                processBuffer(buffer)
                buffer.removeAll()
            }
            
            return .max(1)
        }
        
        /// 接收完成信号
        /// - Parameter completion: 完成状态
        public func receive(completion: Subscribers.Completion<Failure>) {
            // 处理剩余的缓冲数据
            if !buffer.isEmpty {
                processBuffer(buffer)
                buffer.removeAll()
            }
            
            receivedCompletion?(completion)
        }
        
        /// 取消订阅
        public func cancel() {
            subscription?.cancel()
            subscription = nil
        }
    }
}

// MARK: - Convenience Subscriber Methods
/// 便捷的订阅者创建方法

public extension Publisher {
    
    /// 限制接收次数的订阅
    /// - Parameters:
    ///   - demand: 最大接收次数
    ///   - receiveValue: 接收值的回调
    /// - Returns: AnyCancellable 用于取消订阅
    func sinkLimited(demand: Int, receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        let subscriber = Subscribers.LimitedSink<Output, Failure>(demand: demand, receivedValue: receiveValue)
        subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
    
    /// 限制接收次数的订阅（包含完成回调）
    /// - Parameters:
    ///   - demand: 最大接收次数
    ///   - receiveCompletion: 接收完成的回调
    ///   - receiveValue: 接收值的回调
    /// - Returns: AnyCancellable 用于取消订阅
    func sinkLimited(demand: Int, receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void, receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        let subscriber = Subscribers.LimitedSink<Output, Failure>(demand: demand, receivedCompletion: receiveCompletion, receivedValue: receiveValue)
        subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
    
    /// 缓冲订阅
    /// - Parameters:
    ///   - bufferSize: 缓冲区大小
    ///   - processBuffer: 处理缓冲数据的回调
    /// - Returns: AnyCancellable 用于取消订阅
    func sinkBuffered(bufferSize: Int, processBuffer: @escaping ([Output]) -> Void) -> AnyCancellable {
        let subscriber = Subscribers.BufferedSink<Output, Failure>(bufferSize: bufferSize, processBuffer: processBuffer)
        subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
    
    /// 缓冲订阅（包含完成回调）
    /// - Parameters:
    ///   - bufferSize: 缓冲区大小
    ///   - receiveCompletion: 接收完成的回调
    ///   - processBuffer: 处理缓冲数据的回调
    /// - Returns: AnyCancellable 用于取消订阅
    func sinkBuffered(bufferSize: Int, receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void, processBuffer: @escaping ([Output]) -> Void) -> AnyCancellable {
        let subscriber = Subscribers.BufferedSink<Output, Failure>(bufferSize: bufferSize, receivedCompletion: receiveCompletion, processBuffer: processBuffer)
        subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}
