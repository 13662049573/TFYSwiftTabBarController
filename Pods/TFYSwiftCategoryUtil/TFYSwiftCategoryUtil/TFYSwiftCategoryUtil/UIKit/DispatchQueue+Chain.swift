//
//  DispatchQueue+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation

// MARK: - 一、基本的扩展
public extension TFY where Base == DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    // MARK: 1.1、函数只被执行一次
    /// 函数只被执行一次
    /// - Parameters:
    ///   - token: 函数标识
    ///   - block: 执行的闭包
    /// - Returns: 一次性函数
    static func once(token: String, block: () -> ()) {
        if _onceTracker.contains(token) {
            return
        }
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        _onceTracker.append(token)
        block()
    }
}

// MARK: - 二、延迟事件
public extension TFY where Base == DispatchQueue {
    // MARK: 2.1、异步做一些任务
    /// 异步做一些任务
    /// - Parameter TFYTask: 任务
    /// - Returns: DispatchWorkItem
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func async(_ TFYTask: @escaping TFYSwiftBlock) -> DispatchWorkItem {
        return _asyncDelay(0, TFYTask)
    }
    
    // MARK: 2.2、异步做任务后回到主线程做任务
    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - TFYTask: 异步任务
    ///   - mainJKTask: 主线程任务
    /// - Returns: DispatchWorkItem
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func async(_ TFYTask: @escaping TFYSwiftBlock, _ mainJKTask: @escaping TFYSwiftBlock) -> DispatchWorkItem{
        return _asyncDelay(0, TFYTask, mainJKTask)
    }
    
    // MARK: 2.3、异步延迟(子线程执行任务)
    /// 异步延迟(子线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter TFYTask: 延迟的block
    /// - Returns: DispatchWorkItem
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func asyncDelay(_ seconds: Double, _ TFYTask: @escaping TFYSwiftBlock) -> DispatchWorkItem {
        return _asyncDelay(seconds, TFYTask)
    }
    
    // MARK: 2.4、异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter TFYTask: 延迟的block
    /// - Parameter mainTFYTask: 延迟的主线程block
    /// - Returns: DispatchWorkItem
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func asyncDelay(_ seconds: Double,
                            _ TFYTask: @escaping TFYSwiftBlock,
                        _ mainTFYTask: @escaping TFYSwiftBlock) -> DispatchWorkItem {
        return _asyncDelay(seconds, TFYTask, mainTFYTask)
    }
}

// MARK: - 私有的方法
extension TFY where Base == DispatchQueue {
    
    /// 延迟任务
    /// - Parameters:
    ///   - seconds: 延迟时间
    ///   - TFYTask: 任务
    ///   - mainJKTask: 任务
    /// - Returns: DispatchWorkItem
    fileprivate static func _asyncDelay(_ seconds: Double,
                                         _ TFYTask: @escaping TFYSwiftBlock,
                                     _ mainTFYTask: TFYSwiftBlock? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: TFYTask)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainTFYTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}

// MARK: - 三、DispatchQueue的便利方法
public extension DispatchQueue {
    
    // MARK: 3.1、主线程执行
    /// 主线程执行
    /// - Parameter block: 执行块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func main(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
    
    // MARK: 3.2、后台线程执行
    /// 后台线程执行
    /// - Parameter block: 执行块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func background(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async(execute: block)
    }
    
    // MARK: 3.3、用户交互线程执行
    /// 用户交互线程执行
    /// - Parameter block: 执行块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func userInteractive(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async(execute: block)
    }
    
    // MARK: 3.4、用户初始化线程执行
    /// 用户初始化线程执行
    /// - Parameter block: 执行块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func userInitiated(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async(execute: block)
    }
    
    // MARK: 3.5、工具线程执行
    /// 工具线程执行
    /// - Parameter block: 执行块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func utility(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .utility).async(execute: block)
    }
    
    // MARK: 3.6、延迟执行
    /// 延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - block: 执行块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func delay(_ delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
    }
    
    // MARK: 3.7、重复执行
    /// 重复执行
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - block: 执行块
    /// - Returns: Timer对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func repeatTask(interval: TimeInterval, block: @escaping () -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            block()
        }
    }
    
    // MARK: 3.8、同步执行
    /// 同步执行
    /// - Parameter block: 执行块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func sync(_ block: () -> Void) {
        DispatchQueue.main.sync(execute: block)
    }
    
    // MARK: 3.9、异步执行并返回结果
    /// 异步执行并返回结果
    /// - Parameter block: 执行块
    /// - Returns: DispatchWorkItem
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func asyncResult(_ block: @escaping () -> Void) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        DispatchQueue.global().async(execute: workItem)
        return workItem
    }
    
    // MARK: 3.10、取消延迟任务
    /// 取消延迟任务
    /// - Parameter workItem: 工作项
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func cancel(_ workItem: DispatchWorkItem) {
        workItem.cancel()
    }
}
