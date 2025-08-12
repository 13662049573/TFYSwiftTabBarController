//
//  TFYAsynce.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/4/25.
//

import Foundation

/// 通用闭包类型
public typealias TFYSwiftBlock = () -> Void
/// 带返回值的闭包类型
public typealias TFYSwiftResultBlock<T> = () -> T
/// 带参数的闭包类型
public typealias TFYSwiftParamBlock<T> = (T) -> Void
/// 带参数和返回值的闭包类型
public typealias TFYSwiftParamResultBlock<T, R> = (T) -> R

// MARK: - 异步处理工具
public struct TFYAsynce {
    /// 默认的全局队列优先级
    public static let defaultQoS: DispatchQoS = .default
    
    /// 异步处理数据
    public static func async(
        qos: DispatchQoS = .default,
        _ block: @escaping TFYSwiftBlock
    ) {
        _async(qos: qos, block)
    }
    
    /// 异步处理数据并在主线程回调
    public static func async(
        qos: DispatchQoS = .default,
        _ block: @escaping TFYSwiftBlock,
        mainBlock: @escaping TFYSwiftBlock
    ) {
        _async(qos: qos, block, mainBlock)
    }
    
    /// 异步延迟执行
    @discardableResult
    public static func asyncDelay(
        _ seconds: Double,
        qos: DispatchQoS = .default,
        _ block: @escaping TFYSwiftBlock
    ) -> DispatchWorkItem {
        return _asyncDelay(seconds, qos: qos, block)
    }
    
    /// 异步延迟执行并在主线程回调
    @discardableResult
    public static func asyncDelay(
        _ seconds: Double,
        qos: DispatchQoS = .default,
        _ block: @escaping TFYSwiftBlock,
        mainBlock: @escaping TFYSwiftBlock
    ) -> DispatchWorkItem {
        return _asyncDelay(seconds, qos: qos, block, mainBlock)
    }
    
    /// 异步执行任务并获取结果
    public static func asyncResult<T>(
        qos: DispatchQoS = .default,
        _ block: @escaping TFYSwiftResultBlock<T>,
        completion: @escaping TFYSwiftParamBlock<T>
    ) {
        _async(qos: qos) {
            let result = block()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    /// 取消延迟执行的任务
    public static func cancelDelayTask(_ workItem: DispatchWorkItem) {
        workItem.cancel()
    }
}

// MARK: - 私有实现
private extension TFYAsynce {
    /// 异步执行
    static func _async(
        qos: DispatchQoS,
        _ block: @escaping TFYSwiftBlock,
        _ mainBlock: TFYSwiftBlock? = nil
    ) {
        let item = DispatchWorkItem(qos: qos, block: block)
        DispatchQueue.global(qos: qos.qosClass).async(execute: item)
        if let main = mainBlock {
            item.notify(queue: .main, execute: main)
        }
    }
    
    /// 异步延迟执行
    static func _asyncDelay(
        _ seconds: Double,
        qos: DispatchQoS,
        _ block: @escaping TFYSwiftBlock,
        _ mainBlock: TFYSwiftBlock? = nil
    ) -> DispatchWorkItem {
        let item = DispatchWorkItem(qos: qos, block: block)
        DispatchQueue.global(qos: qos.qosClass).asyncAfter(
            deadline: .now() + seconds,
            execute: item
        )
        if let main = mainBlock {
            item.notify(queue: .main, execute: main)
        }
        return item
    }
}

// MARK: - 便利扩展
public extension TFYAsynce {
    /// 主线程执行
    static func main(_ block: @escaping TFYSwiftBlock) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
    
    /// 主线程延迟执行
    @discardableResult
    static func mainDelay(_ seconds: Double, _ block: @escaping TFYSwiftBlock) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: item)
        return item
    }
    
    /// 并发执行多个任务
    static func concurrent(
        _ blocks: [TFYSwiftBlock],
        qos: DispatchQoS = .default,
        completion: TFYSwiftBlock? = nil
    ) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: qos.qosClass)
        
        blocks.forEach { block in
            queue.async(group: group) {
                block()
            }
        }
        
        if let completion = completion {
            group.notify(queue: .main) {
                completion()
            }
        }
    }
    
    /// 并发执行多个任务并收集结果（结果顺序与输入一致，completion在主线程）
    static func concurrentResults<T>(
        _ blocks: [TFYSwiftResultBlock<T>],
        qos: DispatchQoS = .default,
        completion: @escaping TFYSwiftParamBlock<[T]>
    ) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: qos.qosClass)
        var collectedResults = Array<T?>(repeating: nil, count: blocks.count)
        let lock = NSLock()
        
        for (index, block) in blocks.enumerated() {
            queue.async(group: group) {
                let result = block()
                lock.lock()
                collectedResults[index] = result
                lock.unlock()
            }
        }
        
        group.notify(queue: .main) {
            completion(collectedResults.compactMap { $0 })
        }
    }
    
    /// 重试机制（可自定义是否继续重试，completion在主线程）
    static func retry<T>(
        maxAttempts: Int = 3,
        delay: TimeInterval = 1.0,
        qos: DispatchQoS = .default,
        _ operation: @escaping TFYSwiftResultBlock<T>,
        shouldRetry: ((T, Int) -> Bool)? = nil,
        completion: @escaping TFYSwiftParamBlock<T>
    ) {
        var attempts = 0
        func attempt() {
            attempts += 1
            let result = operation()
            if let shouldRetry = shouldRetry, shouldRetry(result, attempts), attempts < maxAttempts {
                asyncDelay(delay, qos: qos) {
                    attempt()
                }
            } else if shouldRetry == nil && attempts < maxAttempts {
                asyncDelay(delay, qos: qos) {
                    attempt()
                }
            } else {
                main {
                    completion(result)
                }
            }
        }
        async(qos: qos) {
            attempt()
        }
    }
    
    /// 防抖执行（注意：闭包内状态仅适用于单实例/单线程场景，线程安全需业务方保证）
    static func debounce(
        delay: TimeInterval,
        qos: DispatchQoS = .default,
        _ block: @escaping TFYSwiftBlock
    ) -> TFYSwiftBlock {
        var workItem: DispatchWorkItem?
        return {
            workItem?.cancel()
            workItem = asyncDelay(delay, qos: qos, block)
        }
    }
    
    /// 节流执行（注意：闭包内状态仅适用于单实例/单线程场景，线程安全需业务方保证）
    static func throttle(
        interval: TimeInterval,
        qos: DispatchQoS = .default,
        _ block: @escaping TFYSwiftBlock
    ) -> TFYSwiftBlock {
        var lastExecutionTime: TimeInterval = 0
        return {
            let currentTime = Date().timeIntervalSinceReferenceDate
            if currentTime - lastExecutionTime >= interval {
                lastExecutionTime = currentTime
                async(qos: qos, block)
            }
        }
    }
}

// MARK: - TFYAsynce 用法示例
/*
// 1. 基本异步执行
TFYAsynce.async {
    // 在后台线程执行耗时操作
    let result = performHeavyCalculation()
    print("计算结果: \(result)")
}

TFYAsynce.async {
    // 后台处理
    let data = fetchDataFromServer()
} mainBlock: {
    // 主线程更新UI
    updateUI(with: data)
}

// 2. 异步延迟执行
let workItem = TFYAsynce.asyncDelay(2.0) {
    print("2秒后执行")
}

// 取消延迟任务
TFYAsynce.cancelDelayTask(workItem)

// 延迟执行并在主线程回调
TFYAsynce.asyncDelay(3.0) {
    let result = processData()
    return result
} mainBlock: {
    print("数据处理完成")
}

// 3. 获取异步结果
TFYAsynce.asyncResult {
    // 在后台线程执行
    return fetchUserData()
} completion: { userData in
    // 在主线程处理结果
    self.updateUserInterface(with: userData)
}

// 4. 主线程执行
TFYAsynce.main {
    // 确保在主线程执行UI更新
    self.tableView.reloadData()
}

// 主线程延迟执行
let mainWorkItem = TFYAsynce.mainDelay(1.0) {
    self.showAlert(message: "操作完成")
}

// 5. 并发执行多个任务
let tasks = [
    { fetchUserProfile() },
    { fetchUserPosts() },
    { fetchUserSettings() }
]

TFYAsynce.concurrent(tasks) {
    print("所有任务完成")
}

// 6. 并发执行并收集结果
let resultTasks: [TFYSwiftResultBlock<String>] = [
    { fetchUserProfile() },
    { fetchUserPosts() },
    { fetchUserSettings() }
]

TFYAsynce.concurrentResults(resultTasks) { results in
    // results 顺序与输入一致
    let profile = results[0]
    let posts = results[1]
    let settings = results[2]
    print("获取到用户资料: \(profile)")
    print("获取到用户帖子: \(posts)")
    print("获取到用户设置: \(settings)")
}

// 7. 重试机制
TFYAsynce.retry(maxAttempts: 3, delay: 2.0) {
    // 可能失败的网络请求
    return try performNetworkRequest()
} shouldRetry: { result, attempt in
    // 自定义重试条件
    if case .failure(let error) = result {
        print("第\(attempt)次尝试失败: \(error)")
        return error.isRetryable
    }
    return false
} completion: { result in
    switch result {
    case .success(let data):
        print("请求成功: \(data)")
    case .failure(let error):
        print("最终失败: \(error)")
    }
}

// 8. 防抖和节流
class SearchViewController: UIViewController {
    private let searchTextField = UITextField()
    private var debouncedSearch: TFYSwiftBlock?
    private var throttledSave: TFYSwiftBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        setupAutoSave()
    }
    
    private func setupSearch() {
        // 防抖：用户停止输入500ms后执行搜索
        debouncedSearch = TFYAsynce.debounce(delay: 0.5) {
            self.performSearch()
        }
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        debouncedSearch?()
    }
    
    private func performSearch() {
        let query = searchTextField.text ?? ""
        TFYAsynce.asyncResult {
            return searchAPI.search(query: query)
        } completion: { results in
            self.updateSearchResults(results)
        }
    }
    
    private func setupAutoSave() {
        // 节流：最多每2秒保存一次
        throttledSave = TFYAsynce.throttle(interval: 2.0) {
            self.saveCurrentState()
        }
    }
    
    private func saveCurrentState() {
        TFYAsynce.async {
            // 后台保存
            self.saveToDatabase()
        } mainBlock: {
            print("自动保存完成")
        }
    }
}

// 9. 复杂异步流程
class DataManager {
    func loadUserDashboard() {
        // 第一步：并发加载基础数据
        TFYAsynce.concurrentResults([
            { self.fetchUserProfile() },
            { self.fetchUserNotifications() },
            { self.fetchUserPreferences() }
        ]) { [weak self] results in
            guard let self = self else { return }
            
            // 第二步：根据用户偏好加载个性化内容
            let preferences = results[2]
            TFYAsynce.asyncResult({
                return self.fetchPersonalizedContent(preferences: preferences)
            }) { content in
                // 第三步：在主线程更新UI
                TFYAsynce.main {
                    self.updateDashboard(
                        profile: results[0],
                        notifications: results[1],
                        content: content
                    )
                }
            }
        }
    }
    
    // 模拟方法
    private func fetchUserProfile() -> UserProfile { return UserProfile() }
    private func fetchUserNotifications() -> [Notification] { return [] }
    private func fetchUserPreferences() -> UserPreferences { return UserPreferences() }
    private func fetchPersonalizedContent(preferences: UserPreferences) -> [Content] { return [] }
    private func updateDashboard(profile: UserProfile, notifications: [Notification], content: [Content]) {}
}

// 10. 错误处理和重试
class NetworkService {
    func fetchDataWithRetry() {
        TFYAsynce.retry(maxAttempts: 3, delay: 1.0) {
            return self.performNetworkRequest()
        } shouldRetry: { result, attempt in
            switch result {
            case .success:
                return false // 成功，不重试
            case .failure(let error):
                if error.isNetworkError && attempt < 3 {
                    print("网络错误，第\(attempt)次重试")
                    return true
                }
                return false
            }
        } completion: { result in
            switch result {
            case .success(let data):
                self.handleSuccess(data)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func performNetworkRequest() -> Result<Data, Error> {
        // 模拟网络请求
        return .success(Data())
    }
    
    private func handleSuccess(_ data: Data) {
        TFYAsynce.main {
            print("数据获取成功")
        }
    }
    
    private func handleError(_ error: Error) {
        TFYAsynce.main {
            print("最终失败: \(error)")
        }
    }
}

// 模拟类型
struct UserProfile {}
struct UserPreferences {}
struct Content {}
struct Notification {}
extension Error {
    var isNetworkError: Bool { return false }
    var isRetryable: Bool { return false }
}
*/
