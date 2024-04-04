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
    @discardableResult
    static func async(_ TFYTask: @escaping TFYSwiftBlock) -> DispatchWorkItem {
        return _asyncDelay(0, TFYTask)
    }
    
    // MARK: 2.2、异步做任务后回到主线程做任务
    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - TFYTask: 异步任务
    ///   - mainJKTask: 主线程任务
    @discardableResult
    static func async(_ TFYTask: @escaping TFYSwiftBlock, _ mainJKTask: @escaping TFYSwiftBlock) -> DispatchWorkItem{
        return _asyncDelay(0, TFYTask, mainJKTask)
    }
    
    // MARK: 2.3、异步延迟(子线程执行任务)
    /// 异步延迟(子线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter TFYTask: 延迟的block
    @discardableResult
    static func asyncDelay(_ seconds: Double, _ TFYTask: @escaping TFYSwiftBlock) -> DispatchWorkItem {
        return _asyncDelay(seconds, TFYTask)
    }
    
    // MARK: 2.4、异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter TFYTask: 延迟的block
    /// - Parameter mainTFYTask: 延迟的主线程block
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
