import Foundation

// 提取自 ZSUtils.swift 的执行限制管理工具，独立文件便于维护与复用
// 提取自 ZSLimitManager.swift 的执行限制管理工具，独立文件便于维护与复用
// 文件内统一的存储键前缀，集中管理，避免硬编码分散（fileprivate 以便同文件内多个 extension 访问）
fileprivate enum ExecutionStorageKeyPrefix {
    static let count = "execution_count_"
    static let times = "execution_times_"
    static let last = "last_execution_"
}

// 线程安全与共享资源
fileprivate enum ExecutionShared {
    static let queue = DispatchQueue(label: "com.zs.utils.executionlimit")
    static let calendar = Calendar.current
    static let dailyFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f
    }()
}

/// 执行限制管理器 - 支持每日、每周、每月等不同时间周期
public enum TFYLimitManager {
        private static let serviceName = Bundle.main.bundleIdentifier ?? "com.zs.shortplay"
        /// 时间周期类型（简化版）
        public enum TimePeriod {
            case everyDays(Int)  // 每N天（通用）
            var description: String {
                switch self {
                case .everyDays(let days): return "every_\(days)_days"
                }
            }
        }

        /// 限制配置
        public struct LimitConfig {
            let maxExecutions: Int
            let timePeriod: TimePeriod
            let minIntervalBetweenExecutions: TimeInterval
            let allowOverflow: Bool

            public init(
                maxExecutions: Int,
                timePeriod: TimePeriod,
                minIntervalBetweenExecutions: TimeInterval = 1.0,
                allowOverflow: Bool = false
            ) {
                self.maxExecutions = maxExecutions
                self.timePeriod = timePeriod
                self.minIntervalBetweenExecutions = minIntervalBetweenExecutions
                self.allowOverflow = allowOverflow
            }
        }

        /// 检查是否可以执行操作（检查并更新记录）
        public static func canExecute(for key: String, with config: LimitConfig) -> Bool {
            let currentTime = Date()
            // 串行化处理，确保一致性
            var result = false
            ExecutionShared.queue.sync {
                if canExecuteUnified(for: key, with: config, currentTime: currentTime) {
                    let (countKey, executionKey, lastExecutionKey) = getStorageKeys(for: key, timePeriod: config.timePeriod, currentTime: currentTime)
                    let currentCount = (try? TFYUtils.Keychain.readInt(service: serviceName, account: countKey)) ?? 0
                    updateExecutionRecord(countKey: countKey, executionKey: executionKey, lastExecutionKey: lastExecutionKey, currentTime: currentTime, currentCount: currentCount)
                    result = true
                }
            }
            return result
        }

        /// 清理过期的执行记录
        public static func cleanupExpiredRecords() {
            do {
                let allItems = try TFYUtils.Keychain.getAllItems()
                let executionKeys = allItems.compactMap { (item: [String: Any]) -> String? in
                    guard let account = item[kSecAttrAccount as String] as? String else { return nil }
                    return account.hasPrefix(ExecutionStorageKeyPrefix.times) || account.hasPrefix(ExecutionStorageKeyPrefix.count) ? account : nil
                }

                let today = Date()
                let currentDaily = ExecutionShared.dailyFormatter.string(from: today)

                for key in executionKeys {
                    guard let underscoreIndex = key.lastIndex(of: "_") else { continue }
                    let periodString = String(key[key.index(after: underscoreIndex)...])

                    // 只处理 yyyy-MM-dd 格式
                    if periodString.count == 10 && periodString != currentDaily {
                        try? TFYUtils.Keychain.delete(service: serviceName, account: key)
                    }
                }
            } catch {
                // 忽略清理错误，避免影响主流程
            }
        }

        // MARK: - 私有辅助方法
        private static func getCountKey(for key: String, timePeriod: TimePeriod, currentTime: Date) -> String {
            let periodString = getPeriodString(for: timePeriod, currentTime: currentTime)
            return "\(ExecutionStorageKeyPrefix.count)\(key)_\(periodString)"
        }

        private static func getExecutionKey(for key: String, timePeriod: TimePeriod, currentTime: Date) -> String {
            let periodString = getPeriodString(for: timePeriod, currentTime: currentTime)
            return "\(ExecutionStorageKeyPrefix.times)\(key)_\(periodString)"
        }

        private static func getPeriodString(for timePeriod: TimePeriod, currentTime: Date) -> String {
            let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
            let targetDate = getBaseDate(for: timePeriod, currentTime: currentTime)
            return formatter.string(from: targetDate)
        }

        private static func extractDateFromKey(_ key: String) -> Date? {
            // 从最后一个下划线后截取周期字符串，避免 key 中包含下划线导致解析失败
            guard let underscoreIndex = key.lastIndex(of: "_") else { return nil }
            let dateString = String(key[key.index(after: underscoreIndex)...])
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: dateString)
        }
        
        // MARK: - 统一执行检查方法
        
        /// 统一处理所有时间周期的执行检查（只读，不修改状态）
        private static func canExecuteUnified(for key: String, with config: LimitConfig, currentTime: Date) -> Bool {
            // 获取存储键
            let (countKey, _, lastExecutionKey) = getStorageKeys(for: key, timePeriod: config.timePeriod, currentTime: currentTime)
            
            // 获取当前执行次数
            let currentCount = (try? TFYUtils.Keychain.readInt(service: serviceName, account: countKey)) ?? 0
            
            // 检查是否已经达到最大执行次数
            if currentCount >= config.maxExecutions && !config.allowOverflow {
                return false
            }
            
            // 检查时间间隔限制
            if !isTimeIntervalValid(for: key, timePeriod: config.timePeriod, currentTime: currentTime, config: config, lastExecutionKey: lastExecutionKey) {
                return false
            }
            
            return true
        }
        
        /// 只读检查是否可以执行操作（不更新记录）
        public static func canExecuteReadOnly(for key: String, with config: LimitConfig) -> Bool {
            let currentTime = Date()
            var result = false
            ExecutionShared.queue.sync {
                result = canExecuteUnified(for: key, with: config, currentTime: currentTime)
            }
            return result
        }
        
        
        /// 检查时间间隔是否有效
        private static func isTimeIntervalValid(for key: String, timePeriod: TimePeriod, currentTime: Date, config: LimitConfig, lastExecutionKey: String) -> Bool {
            if case .everyDays(let days) = timePeriod {
                return checkEveryDaysInterval(lastExecutionKey: lastExecutionKey, currentTime: currentTime, days: days, config: config)
            }
            return true
        }
        
        /// 检查每N天的时间间隔
        private static func checkEveryDaysInterval(lastExecutionKey: String, currentTime: Date, days: Int, config: LimitConfig) -> Bool {
            guard let lastTime = try? TFYUtils.Keychain.readDate(service: serviceName, account: lastExecutionKey) else { return true }
            
            let calendar = ExecutionShared.calendar
            
            // 计算天数差，使用更精确的方法
            let lastDate = calendar.startOfDay(for: lastTime)
            let currentDate = calendar.startOfDay(for: currentTime)
            let daysSinceLastExecution = calendar.dateComponents([.day], from: lastDate, to: currentDate).day ?? 0
            
            // 如果是同一天（daysSinceLastExecution == 0）
            if daysSinceLastExecution == 0 {
                // 对于 maxExecutions = 1 的情况，同一天内不允许再次执行
                if config.maxExecutions == 1 {
                    return false
                }
                // 对于 maxExecutions > 1 的情况，只检查最小时间间隔
                return currentTime.timeIntervalSince(lastTime) >= config.minIntervalBetweenExecutions
            }
            
            // 不同天的情况，检查天数间隔
            return daysSinceLastExecution >= days && currentTime.timeIntervalSince(lastTime) >= config.minIntervalBetweenExecutions
        }
        
        
        /// 更新执行记录
        private static func updateExecutionRecord(countKey: String, executionKey: String, lastExecutionKey: String, currentTime: Date, currentCount: Int) {
            // 增加执行次数
            try? TFYUtils.Keychain.saveInt(currentCount + 1, service: serviceName, account: countKey)
            
            // 记录执行时间（限制数组增长，最多保留最近 50 条）
            var executionTimes: [Date] = (try? TFYUtils.Keychain.readObjectArray(Date.self, service: serviceName, account: executionKey)) ?? []
            executionTimes.append(currentTime)
            if executionTimes.count > 50 {
                executionTimes.removeFirst(executionTimes.count - 50)
            }
            try? TFYUtils.Keychain.saveObjectArray(executionTimes, service: serviceName, account: executionKey)
            
            // 更新最后执行时间（用于every系列）
            try? TFYUtils.Keychain.saveDate(currentTime, service: serviceName, account: lastExecutionKey)
        }
        
        /// 获取存储键
        private static func getStorageKeys(for key: String, timePeriod: TimePeriod, currentTime: Date) -> (countKey: String, executionKey: String, lastExecutionKey: String) {
            let countKey = getCountKey(for: key, timePeriod: timePeriod, currentTime: currentTime)
            let executionKey = getExecutionKey(for: key, timePeriod: timePeriod, currentTime: currentTime)
            let lastExecutionKey = "\(ExecutionStorageKeyPrefix.last)\(key)"
            
            return (countKey, executionKey, lastExecutionKey)
        }
        
        /// 获取基础日期（用于分组）
        private static func getBaseDate(for timePeriod: TimePeriod, currentTime: Date) -> Date {
            if case .everyDays(let days) = timePeriod {
                return getBaseDateForEveryDays(currentTime: currentTime, days: days)
            }
            return currentTime
        }
        
        /// 获取每N天的基础日期（用于分组）
        private static func getBaseDateForEveryDays(currentTime: Date, days: Int) -> Date {
            let calendar = ExecutionShared.calendar
            let components = calendar.dateComponents([.year, .month, .day], from: currentTime)
            guard let startOfDay = calendar.date(from: components) else { return currentTime }
            
            // 计算从1970年1月1日开始的天数，确保时区一致性
            let daysSinceEpoch = Int(startOfDay.timeIntervalSince1970 / 86400)
            let baseDays = (daysSinceEpoch / days) * days
            
            return Date(timeIntervalSince1970: TimeInterval(baseDays * 86400))
        }
}

// MARK: - 便捷方法（兼容 ZSUtils 接口）
extension TFYLimitManager {

    /// 清理指定key的所有记录
    public static func cleanupRecords(for key: String) {
        resetExecutionRecord(for: key)
    }
    
    /// 批量清理指定keys的所有记录
    public static func cleanupRecords(for keys: [String]) {
        for key in keys {
            resetExecutionRecord(for: key)
        }
    }
    
    // MARK: - 统一执行限制方法（通用版）
    
    /// 统一执行限制检查（检查并更新记录）
    /// - Parameters:
    ///   - key: 唯一标识符
    ///   - days: 天数间隔（用户自定义：1=每1天，2=每2天，7=每7天，30=每30天等）
    ///   - maxExecutions: 最大执行次数（默认1次）
    ///   - minInterval: 最小间隔时间（秒，默认1秒）
    /// - Returns: 是否可以执行
    public static func canExecute(key: String, days: Int = 1, maxExecutions: Int = 1, minInterval: TimeInterval = 1.0) -> Bool {
        // 参数验证
        guard !key.isEmpty else { return false }
        guard days > 0 else { return false }
        guard maxExecutions > 0 else { return false }
        guard minInterval >= 0 else { return false }
        
        let config = TFYLimitManager.LimitConfig(
            maxExecutions: maxExecutions,
            timePeriod: .everyDays(days),
            minIntervalBetweenExecutions: minInterval
        )
        return TFYLimitManager.canExecute(for: key, with: config)
    }

    /// 统一执行限制检查（只读，不更新记录）
    /// - Parameters:
    ///   - key: 唯一标识符
    ///   - days: 天数间隔（用户自定义：1=每1天，2=每2天，7=每7天，30=每30天等）
    ///   - maxExecutions: 最大执行次数（默认1次）
    ///   - minInterval: 最小间隔时间（秒，默认1秒）
    /// - Returns: 是否可以执行
    public static func canExecuteReadOnly(key: String, days: Int = 1, maxExecutions: Int = 1, minInterval: TimeInterval = 1.0) -> Bool {
        // 参数验证
        guard !key.isEmpty else { return false }
        guard days > 0 else { return false }
        guard maxExecutions > 0 else { return false }
        guard minInterval >= 0 else { return false }
        
        let config = TFYLimitManager.LimitConfig(
            maxExecutions: maxExecutions,
            timePeriod: .everyDays(days),
            minIntervalBetweenExecutions: minInterval
        )
        return TFYLimitManager.canExecuteReadOnly(for: key, with: config)
    }
    
    /// 获取剩余执行次数
    /// - Parameters:
    ///   - key: 唯一标识符
    ///   - days: 天数间隔（用户自定义：1=每1天，2=每2天，7=每7天，30=每30天等）
    ///   - maxExecutions: 最大执行次数（默认1次）
    /// - Returns: 剩余执行次数
    public static func remainingExecutions(key: String, days: Int = 1, maxExecutions: Int = 1) -> Int {
        // 参数验证
        guard !key.isEmpty else { return 0 }
        guard days > 0 else { return 0 }
        guard maxExecutions > 0 else { return 0 }
        
        let config = TFYLimitManager.LimitConfig(maxExecutions: maxExecutions, timePeriod: .everyDays(days))
        let currentTime = Date()
        let periodString = TFYLimitManager.getPeriodString(for: config.timePeriod, currentTime: currentTime)
        let countKey = "\(ExecutionStorageKeyPrefix.count)\(key)_\(periodString)"
        let currentCount = (try? TFYUtils.Keychain.readInt(service: serviceName, account: countKey)) ?? 0
        return max(0, config.maxExecutions - currentCount)
    }
    
    /// 获取上次执行时间
    public static func getLastExecutionTime(for key: String) -> Date? {
        let lastExecutionKey = "\(ExecutionStorageKeyPrefix.last)\(key)"
        return try? TFYUtils.Keychain.readDate(service: serviceName, account: lastExecutionKey)
    }
    
    /// 重置指定key的执行记录
    public static func resetExecutionRecord(for key: String) {
        let lastExecutionKey = "\(ExecutionStorageKeyPrefix.last)\(key)"
        try? TFYUtils.Keychain.delete(service: serviceName, account: lastExecutionKey)
        
        // 清理所有相关的计数记录
        do {
            let allItems = try TFYUtils.Keychain.getAllItems()
            let relatedKeys = allItems.compactMap { (item: [String: Any]) -> String? in
                guard let account = item[kSecAttrAccount as String] as? String else { return nil }
                return account.contains(key) && (account.hasPrefix(ExecutionStorageKeyPrefix.count) || account.hasPrefix(ExecutionStorageKeyPrefix.times)) ? account : nil
            }
            
            for relatedKey in relatedKeys {
                try? TFYUtils.Keychain.delete(service: serviceName, account: relatedKey)
            }
        } catch {
            // 忽略错误
        }
    }
    
    /// 清理所有执行记录（重置整个系统）
    public static func cleanupAllExecutionRecords() {
        do {
            let allItems = try TFYUtils.Keychain.getAllItems()
            let executionKeys = allItems.compactMap { (item: [String: Any]) -> String? in
                guard let account = item[kSecAttrAccount as String] as? String else { return nil }
                return account.hasPrefix(ExecutionStorageKeyPrefix.count) ||
                       account.hasPrefix(ExecutionStorageKeyPrefix.times) ||
                       account.hasPrefix(ExecutionStorageKeyPrefix.last) ? account : nil
            }
            
            for key in executionKeys {
                try? TFYUtils.Keychain.delete(service: serviceName, account: key)
            }
        } catch {
            // 忽略错误
        }
    }
}




// MARK: - 使用示例（Usage Examples）
// 注意：以下均为示例代码，请根据业务替换 key、阈值参数
//
// 基础Key
// let key = "feature_key"
// let vipKey = "vip_welfare_pop"
// let claimKey = "vip_isShowClaim"
//
// ===== 核心API（统一执行限制管理） =====
//
// 1) 执行限制检查（检查并更新记录）
// let canExecute = ZSLimitManager.canExecute(key: key, days: 1, maxExecutions: 1)        // 每1天1次
// let canExecute = ZSLimitManager.canExecute(key: key, days: 2, maxExecutions: 1)        // 每2天1次
// let canExecute = ZSLimitManager.canExecute(key: key, days: 7, maxExecutions: 3)        // 每7天3次
// let canExecute = ZSLimitManager.canExecute(key: key, days: 30, maxExecutions: 10)      // 每30天10次
// let canExecute = ZSLimitManager.canExecute(key: key, days: 365, maxExecutions: 20)     // 每365天20次
//
// 2) 只读检查（不更新记录，用于UI显示状态）
// let canExecute = ZSLimitManager.canExecuteReadOnly(key: key, days: 1, maxExecutions: 1)
// let canExecute = ZSLimitManager.canExecuteReadOnly(key: vipKey, days: 1, maxExecutions: 1)
//
// 3) 获取剩余执行次数
// let remaining = ZSLimitManager.remainingExecutions(key: key, days: 1, maxExecutions: 1)
// let remaining = ZSLimitManager.remainingExecutions(key: vipKey, days: 1, maxExecutions: 1)
//
// ===== 数据管理功能 =====
//
// 4) 清理过期记录（建议在应用启动时调用）
// ZSLimitManager.cleanupExpiredRecords()
//
// 5) 清理指定key的所有记录
// ZSLimitManager.resetExecutionRecord(for: "vip_welfare_pop")
// ZSLimitManager.resetExecutionRecord(for: "daily_checkin")
//
// 6) 批量清理多个key的记录
// ZSLimitManager.cleanupRecords(for: ["vip_welfare_pop", "daily_checkin", "weekly_task"])
//
// 7) 清理所有执行记录（重置整个系统）
// ZSLimitManager.cleanupAllExecutionRecords()
//
// 8) 获取上次执行时间
// if let lastTime = ZSLimitManager.getLastExecutionTime(for: "vip_welfare_pop") {
//     print("上次执行时间: \(lastTime)")
// }
//
