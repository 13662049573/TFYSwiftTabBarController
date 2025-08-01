//
//  Timer+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit


// MARK: - 一、基本的扩展
public extension Timer {
    
    // MARK: 1.1、构造器创建定时器
    /// 构造器创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的block
    convenience init(safeTimerWithTimeInterval timeInterval: TimeInterval, repeats: Bool, block: @escaping ((Timer) -> Void)) {
        if #available(iOS 10.0, *) {
            self.init(timeInterval: timeInterval, repeats: repeats, block: block)
            return
        }
        self.init(timeInterval: timeInterval, target: Timer.self, selector: #selector(Timer.timerCB(timer:)), userInfo: block, repeats: repeats)
    }
    
    // MARK: 1.2、类方法创建定时器
    /// 创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的block
    /// - Returns: 返回 Timer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func scheduledSafeTimer(timeInterval: TimeInterval, repeats: Bool, block: @escaping ((Timer) -> Void)) -> Timer {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: block)
        }
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerCB(timer:)), userInfo: block, repeats: repeats)
    }

    // MARK: 1.3、C语言的形式创建定时器(创建后立即执行一次)
    /// C语言的形式创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - handler: 定时器的回调
    /// - Returns: 返回 Timer，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func runThisEvery(timeInterval: TimeInterval, handler: @escaping (Timer?) -> Void) -> Timer? {
        let fireDate = CFAbsoluteTimeGetCurrent()
        guard let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, timeInterval, 0, 0, handler) else {
            return nil
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer
    }
}

// MARK: - 私有的方法
public extension Timer {
    @objc fileprivate class func timerCB(timer: Timer) {
        guard let cb = timer.userInfo as? ((Timer) -> Void) else {
            timer.invalidate()
            return
        }
        cb(timer)
    }
    
    // MARK: 1.4、简化的定时器创建方法
    /// 简化的定时器创建方法
    /// - Parameters:
    ///   - Interval: 时间间隔，默认60秒
    ///   - repeats: 是否重复执行，默认true
    ///   - action: 执行代码的block
    /// - Returns: 返回 Timer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func scheduled(_ Interval: TimeInterval = 60, repeats: Bool = true, action: @escaping((Timer) -> Void)) -> Timer {
        return scheduledTimer(timeInterval: Interval, target: self, selector: #selector(handleInvoke(_:)), userInfo: action, repeats: repeats)
    }
    
    @objc private static func handleInvoke(_ timer: Timer) {
        if let action = timer.userInfo as? ((Timer) -> Void) {
            action(timer)
        }
    }
    // MARK: 1.5、激活定时器
    /// 激活定时器：触发时间设置在现在，这样定时器自动进入马上进入工作状态
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func activate() {
        self.fireDate = .distantPast
    }
    
    // MARK: 1.6、暂停定时器
    /// 暂停定时器：触发时间设置在未来，既很久之后，这样定时器自动进入等待触发的状态
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func pause() {
        self.fireDate = .distantFuture
    }
    // MARK: 1.7、创建GCD定时器
    /// 创建GCD定时器
    /// - Parameters:
    ///   - interval: 时间间隔，默认60秒
    ///   - repeats: 是否重复执行，默认true
    ///   - action: 执行代码的block
    /// - Returns: 返回 DispatchSourceTimer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func createGCDTimer(_ interval: TimeInterval = 60, repeats: Bool = true, action: @escaping(() -> Void)) -> DispatchSourceTimer {
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
        codeTimer.setEventHandler {
            if repeats == false {
                codeTimer.cancel()
            }
            DispatchQueue.main.async(execute: action)
        }
        
        codeTimer.resume()
        return codeTimer
    }
    
    // MARK: 1.8、取消GCD定时器
    /// 取消GCD定时器
    /// - Parameter timer: 要取消的定时器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func cancelGCDTimer(_ timer: DispatchSourceTimer?) {
        timer?.cancel()
    }
}

public extension DispatchSourceTimer{
    
    // MARK: 2.1、创建GCD定时器
    /// 创建GCD定时器
    /// - Parameters:
    ///   - interval: 时间间隔，默认60秒
    ///   - repeats: 是否重复执行，默认true
    ///   - action: 执行代码的block
    /// - Returns: 返回 DispatchSourceTimer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func create(_ interval: TimeInterval = 60, repeats: Bool = true, action: @escaping(() -> Void)) -> DispatchSourceTimer {
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
        codeTimer.setEventHandler {
            if repeats == false {
                codeTimer.cancel()
            }
            DispatchQueue.main.async(execute: action)
        }
        
        codeTimer.resume()
        return codeTimer
    }
    
    // MARK: 2.2、创建精确的GCD定时器
    /// 创建精确的GCD定时器
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - action: 执行代码的block
    /// - Returns: 返回 DispatchSourceTimer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func createPrecise(_ interval: TimeInterval, repeats: Bool = true, action: @escaping(() -> Void)) -> DispatchSourceTimer {
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .seconds(Int(interval)))
        codeTimer.setEventHandler {
            if repeats == false {
                codeTimer.cancel()
            }
            DispatchQueue.main.async(execute: action)
        }
        
        codeTimer.resume()
        return codeTimer
    }
    
    // MARK: 2.3、创建毫秒级GCD定时器
    /// 创建毫秒级GCD定时器
    /// - Parameters:
    ///   - milliseconds: 毫秒数
    ///   - repeats: 是否重复执行
    ///   - action: 执行代码的block
    /// - Returns: 返回 DispatchSourceTimer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func createMilliseconds(_ milliseconds: Int, repeats: Bool = true, action: @escaping(() -> Void)) -> DispatchSourceTimer {
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(milliseconds))
        codeTimer.setEventHandler {
            if repeats == false {
                codeTimer.cancel()
            }
            DispatchQueue.main.async(execute: action)
        }
        
        codeTimer.resume()
        return codeTimer
    }
    
    // MARK: 2.4、暂停GCD定时器
    /// 暂停GCD定时器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func tfy_pause() {
        self.suspend()
    }
    
    // MARK: 2.5、恢复GCD定时器
    /// 恢复GCD定时器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func tfy_resume() {
        self.resume()
    }
    
    // MARK: 2.6、检查GCD定时器是否已取消
    /// 检查GCD定时器是否已取消
    /// - Returns: 是否已取消
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var tfy_isCancelled: Bool {
        return self.isCancelled
    }
}

// MARK: - 三、Timer的便利方法
public extension Timer {
    
    // MARK: 3.1、创建倒计时定时器
    /// 创建倒计时定时器
    /// - Parameters:
    ///   - seconds: 倒计时秒数
    ///   - action: 执行代码的block
    /// - Returns: 返回 Timer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func countdown(_ seconds: Int, action: @escaping((Int) -> Void)) -> Timer {
        var remainingSeconds = seconds
        return Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            action(remainingSeconds)
            remainingSeconds -= 1
            if remainingSeconds < 0 {
                timer.invalidate()
            }
        }
    }
    
    // MARK: 3.2、创建延迟执行定时器
    /// 创建延迟执行定时器
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - action: 执行代码的block
    /// - Returns: 返回 Timer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func delay(_ delay: TimeInterval, action: @escaping() -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
    
    // MARK: 3.3、创建循环执行定时器
    /// 创建循环执行定时器
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - action: 执行代码的block
    /// - Returns: 返回 Timer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func repeatTask(_ interval: TimeInterval, action: @escaping() -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            action()
        }
    }
    
    // MARK: 3.4、创建主线程定时器
    /// 创建主线程定时器
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - action: 执行代码的block
    /// - Returns: 返回 Timer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func mainThread(_ interval: TimeInterval, repeats: Bool = true, action: @escaping() -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { _ in
            DispatchQueue.main.async {
                action()
            }
        }
    }
    
    // MARK: 3.5、创建后台线程定时器
    /// 创建后台线程定时器
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - action: 执行代码的block
    /// - Returns: 返回 Timer
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func background(_ interval: TimeInterval, repeats: Bool = true, action: @escaping() -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { _ in
            DispatchQueue.global().async {
                action()
            }
        }
    }
    
    // MARK: 3.6、检查定时器是否有效
    /// 检查定时器是否有效
    /// - Returns: 是否有效
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var tfy_isValid: Bool {
        return self.isValid
    }
    
    // MARK: 3.7、获取定时器的下次触发时间
    /// 获取定时器的下次触发时间
    /// - Returns: 下次触发时间
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var nextFireDate: Date? {
        return self.fireDate
    }
    
    // MARK: 3.8、设置定时器的下次触发时间
    /// 设置定时器的下次触发时间
    /// - Parameter date: 下次触发时间
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func setNextFireDate(_ date: Date) {
        self.fireDate = date
    }
    
    // MARK: 3.9、获取定时器的时间间隔
    /// 获取定时器的时间间隔
    /// - Returns: 时间间隔
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var tfy_timeInterval: TimeInterval {
        return self.timeInterval
    }
    
    // MARK: 3.10、获取定时器的用户信息
    /// 获取定时器的用户信息
    /// - Returns: 用户信息
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var tfy_userInfo: Any? {
        return self.userInfo
    }
}
