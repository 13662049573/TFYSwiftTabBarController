//
//  Timer+ITools.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/4/21.
//

import Foundation
import UIKit

extension Timer {
    
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
    
}

// MARK:- 私有的方法
public extension Timer {
    @objc fileprivate class func timerCB(timer: Timer) {
        guard let cb = timer.userInfo as? ((Timer) -> Void) else {
            timer.invalidate()
            return
        }
        cb(timer)
    }
}

/// MARK ---------------------------------------------------------------  Timer ---------------------------------------------------------------
public extension TFY where Base == Timer {
    
    /// 创建并调度一个计时器，该计时器将在指定的时间之后调用“block”。
    @discardableResult
    func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Self {
        let timer = base.tfy.new(after: interval, block)
        timer.tfy.start()
        return self
    }
    
    /// 创建并调度一个计时器，该计时器将在指定的时间间隔内重复调用“block”。
    @discardableResult
    func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Self {
        let timer = base.tfy.new(every: interval, block)
        timer.tfy.start()
        return self
    }
    
    /// 创建并调度一个计时器，该计时器将在指定的时间间隔内重复调用“block”。
    /// (此变量也将timer实例传递给块)
    @discardableResult
    func every(_ interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Self {
        let timer = base.tfy.new(every: interval, block)
        timer.start()
        return self
    }
    
    // MARK: 创建没有调度的计时器
    
    /// 创建一个计时器，在指定的时间之后调用' block '。
    ///
    /// - Note: 计时器在运行循环中调度之前不会启动。
    ///         使用“NSTimer。在一个步骤中创建和安排一个计时器。
    /// - Note: “new”类函数是使用方便初始化器时崩溃bug的解决方案(rdar://18720947)
    func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }
    
    /// 创建一个计时器，在指定的时间间隔内重复调用“block”。
    ///
    /// - Note: 计时器在运行循环中调度之前不会启动。
    ///         使用“NSTimer。每一步都要创建和安排一个计时器。
    /// - Note: “new”类函数是使用方便初始化器时崩溃bug的解决方案(rdar://18720947)
    func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }
    
    /// 创建一个计时器，在指定的时间间隔内重复调用“block”。
    /// (此变量也将timer实例传递给块)
    ///
    /// - Note: 计时器在运行循环中调度之前不会启动。
    ///         使用“NSTimer。每一步都要创建和安排一个计时器。
    /// - Note: “new”类函数是使用方便初始化器时崩溃bug的解决方案(rdar://18720947)
    func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Self {
        var timer: Base!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return self
    }
    
    // MARK: 手动操作
    
    /// 在运行循环中安排这个计时器
    ///
    /// 缺省情况下，定时器在当前运行环路上使用缺省模式。
    /// 指定' runLoop '或' modes '来覆盖这些默认值。
    func start(runLoop: RunLoop = .current, modes: RunLoop.Mode...) {
        let modes = modes.isEmpty ? [.default] : modes
        for mode in modes {
            runLoop.add(base, forMode: mode)
        }
    }
    
    // MARK: 1.2、类方法创建定时器
    ///  创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的block
    /// - Returns: 返回 Timer
    @discardableResult
    func scheduledSafeTimer(timeInterval: TimeInterval, repeats: Bool, block: @escaping ((Timer) -> Void)) -> Self {
        if #available(iOS 10.0, *) {
            Base.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: block)
            return self
        }
        Base.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(Base.timerCB(timer:)), userInfo: block, repeats: repeats)
        return self
    }

    // MARK: 1.3、C语言的形式创建定时器(创建后立即执行一次)
    /// C语言的形式创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - handler: 定时器的回调
    /// - Returns: 返回 Timer
    @discardableResult
    func runThisEvery(timeInterval: TimeInterval, handler: @escaping (Timer?) -> Void) -> Self? {
        let fireDate = CFAbsoluteTimeGetCurrent()
        guard let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, timeInterval, 0, 0, handler) else {
            return nil
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return self
    }
}
