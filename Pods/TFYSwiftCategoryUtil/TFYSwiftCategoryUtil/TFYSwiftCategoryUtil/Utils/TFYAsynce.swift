//
//  TFYAsynce.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/4/25.
//

import Foundation

public typealias Block = () -> Void

public struct TFYAsynce {
    /// 异步处理数据
    public static func async(_ block: @escaping Block) {
        _async(block)
    }
    
    /// 异步 主线程 处理数据
    public static func async(_ block: @escaping Block, _ mainblock: @escaping Block) {
        _async(block,mainblock)
    }
    
    /// 异步延迟
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ block: @escaping Block) -> DispatchWorkItem {
        return _asyncDelay(seconds, block)
    }
    
    /// 主线程延迟
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ block: @escaping Block, _ mainblock: @escaping Block) -> DispatchWorkItem {
        return _asyncDelay(seconds, block, mainblock)
    }
    
}

extension TFYAsynce {
    
    private static func _async(_ block: @escaping Block, _ mainblock: Block? = nil) {
        let item = DispatchWorkItem(block: block)
        DispatchQueue.global().async(execute: item)
        if let main = mainblock {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
    
    private static func _asyncDelay(_ seconds: Double, _ block: @escaping Block, _ mainblock: Block? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainblock {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
