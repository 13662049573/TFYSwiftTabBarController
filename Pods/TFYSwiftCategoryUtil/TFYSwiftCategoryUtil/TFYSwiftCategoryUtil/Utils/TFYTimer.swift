//
//  TFYTimer.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/18.
//

import Foundation

public class  TFYTimer {
    
    private let internalTimer: DispatchSourceTimer
    
    private var isRunning = false
    
    public let repeats: Bool
    
    public typealias SwiftTimerHandler = (TFYTimer) -> Void
    
    private var handler: SwiftTimerHandler
    
    public init(interval: DispatchTimeInterval, repeats: Bool = false, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main , handler: @escaping SwiftTimerHandler) {
        
        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            internalTimer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }
    
    public static func repeaticTimer(interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main , handler: @escaping SwiftTimerHandler ) -> TFYTimer {
        return TFYTimer(interval: interval, repeats: true, leeway: leeway, queue: queue, handler: handler)
    }
    
    deinit {
        if !self.isRunning {
            internalTimer.resume()
        }
    }
    
    //您可以使用此方法触发一个重复计时器，而不中断它的常规触发计划。如果计时器是非重复的，它在触发后自动失效，即使它的预定触发日期没有到达。
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }
    
    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }
    
    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }
    
    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }
    
    public func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }

    }
}

//MARK: Throttle
public extension TFYTimer {
    
    private static var workItems = [String:DispatchWorkItem]()
    
    ///在指定的interval后调用Handler
    ///在间隔时间内再次调用将取消先前的调用
    static func debounce(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: @escaping () -> Void ) {
        
        //如果已经存在
        if let item = workItems[identifier] {
            item.cancel()
        }

        let item = DispatchWorkItem {
            handler();
            workItems.removeValue(forKey: identifier)
        };
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item);
    }
    
    ///在指定的interval后调用Handler
    ///在间隔时间内再次调用无效
    static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: @escaping () -> Void ) {
        
        //如果已经存在
        if workItems[identifier] != nil {
            return;
        }
        
        let item = DispatchWorkItem {
            handler();
            workItems.removeValue(forKey: identifier)
        };
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item);
        
    }
    
    static func cancelThrottlingTimer(identifier: String) {
        if let item = workItems[identifier] {
            item.cancel()
            workItems.removeValue(forKey: identifier)
        }
    }
    
    
    
}

//MARK: Count Down
public class TFYCountDownTimer {
    
    private let internalTimer: TFYTimer
    
    private var leftTimes: Int
    
    private let originalTimes: Int
    
    private let handler: (TFYCountDownTimer, _ leftTimes: Int) -> Void
    
    public init(interval: DispatchTimeInterval, times: Int,queue: DispatchQueue = .main , handler:  @escaping (TFYCountDownTimer, _ leftTimes: Int) -> Void ) {
        
        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.internalTimer = TFYTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        self.internalTimer.rescheduleHandler { [weak self]  swiftTimer in
            if let strongSelf = self {
                if strongSelf.leftTimes > 0 {
                    strongSelf.leftTimes = strongSelf.leftTimes - 1
                    strongSelf.handler(strongSelf, strongSelf.leftTimes)
                } else {
                    strongSelf.internalTimer.suspend()
                }
            }
        }
    }
    
    public func start() {
        self.internalTimer.start()
    }
    
    public func suspend() {
        self.internalTimer.suspend()
    }
    
    public func reCountDown() {
        self.leftTimes = self.originalTimes
    }
    
}

public extension DispatchTimeInterval {
    
    static func fromSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return .milliseconds(Int(seconds * 1000))
    }
}
