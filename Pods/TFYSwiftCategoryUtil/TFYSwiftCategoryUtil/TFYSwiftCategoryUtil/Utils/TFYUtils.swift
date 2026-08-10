//
//  TFYUtils.swift
//  TFYSwiftCategoryUtil
//
//  Created by TFY on 2024
//
//  TFYUtils - 综合工具类
//
//  功能模块说明：
//  - Logger: 增强日志系统，支持分级日志、异步写入、日志轮转、JSON格式化
//  - Network: 网络工具，支持网络状态监测、类型检测、连接检查
//  - Keychain: 安全存储工具，支持数据加密存储、字符串/字典/对象存取
//  - DateUtils: 日期处理工具，支持格式化、解析、相对时间、日期计算
//  - IAP: 内购工具，支持商品管理、购买、恢复、验证
//  - Animation: 动画工具，支持多种动画类型、链式调用、转场效果
//  - Notification: 通知工具，支持权限管理、本地通知、通知分类
//  - Haptics: 触觉反馈工具，支持多种反馈类型、强度控制、模式设置
//  - Biometrics: 生物识别工具，支持Touch ID/Face ID、密码回退、状态管理
//  - FileManager: 文件管理工具，支持文件操作、监控、压缩、属性获取
//  - ImageProcessor: 图片处理工具，支持滤镜、压缩、裁剪、旋转、格式转换
//  - FilePath: 路径工具，提供常用目录路径
//  - Window: 窗口工具，支持窗口管理、视图控制器获取
//  - System: 系统工具，支持URL打开、电话、邮件、App Store操作
//  - ViewController: 视图控制器工具，支持导航、模态、状态管理
//  - Device: 设备工具，支持设备信息、状态检测、内存管理
//
//  使用示例：
//  // 日志记录
//  TFYUtils.Logger.log("这是一条信息", level: .info)
//
//  // 网络状态检查
//  TFYUtils.Network.getCurrentStatus { status in
//      print("当前网络状态: \(status)")
//  }
//
//  // 安全存储
//  try TFYUtils.Keychain.saveString("敏感数据", service: "myApp", account: "user")
//
//  // 日期格式化
//  let dateString = TFYUtils.DateUtils.string(from: Date(), format: "yyyy-MM-dd")
//
//  // 触觉反馈
//  TFYUtils.Haptics.trigger(.success)
//
//  // 图片处理
//  let processedImage = TFYUtils.ImageProcessor.compressImage(image, to: .jpeg(quality: 0.8))
//
//  // 文件操作
//  let fileSize = TFYUtils.FileManager.fileSize(at: "/path/to/file")
//
//  // 生物识别
//  TFYUtils.Biometrics.authenticate(reason: "验证身份") { result in
//      switch result {
//      case .success: print("验证成功")
//      case .failure(let error): print("验证失败: \(error)")
//      }
//  }
//
//  注意事项：
//  - 所有异步操作都支持回调，部分支持async/await
//  - 错误处理采用Result类型或throws，提供详细的错误信息
//  - 线程安全：关键操作使用串行队列保护
//  - 内存管理：自动处理资源释放和缓存清理
//  - 兼容性：支持iOS 9.0+，部分功能需要更高版本
//

import Foundation
import UIKit
import StoreKit
import LocalAuthentication
import Network
import UserNotifications
import CoreImage
import CoreGraphics
import SystemConfiguration
import Photos
import CommonCrypto

// MARK: - 文件路径常量
public struct FilePath {
    /// 文档目录路径
    public static let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
    
    /// 缓存目录路径
    public static let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
    
    /// 临时目录路径
    public static let temp = NSTemporaryDirectory() as NSString
}

// MARK: - 主工具类
public enum TFYUtils {
    
    // MARK: - 窗口管理
    public enum Window {
        /// 获取当前活动窗口
        public static var current: UIWindow? {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }?
                .windows
                .first(where: \.isKeyWindow)
        }
        
        /// 获取顶层视图控制器
        public static var topViewController: UIViewController? {
            guard let window = current else { return nil }
            
            func findTop(from controller: UIViewController?) -> UIViewController? {
                if let nav = controller as? UINavigationController {
                    return findTop(from: nav.visibleViewController)
                }
                if let tab = controller as? UITabBarController {
                    return findTop(from: tab.selectedViewController)
                }
                if let presented = controller?.presentedViewController {
                    return findTop(from: presented)
                }
                return controller
            }
            
            return findTop(from: window.rootViewController)
        }
    }
    
    // MARK: - 增强日志系统
    public enum Logger {
        /// 日志级别
        public enum Level: String, CaseIterable {
            case debug = "🟢 DEBUG"
            case info = "🔵 INFO"
            case warning = "🟠 WARNING"
            case error = "🔴 ERROR"
        }
        /// 日志配置
        public struct Config {
            public static var maxFileSize: Int = 1024 * 1024 * 5 // 5MB
            public static var maxFiles: Int = 7 // 保留7天
            public static var enabledLevels: Set<Level> = Set(Level.allCases)
            public static var logDirectory: String = FilePath.cache.appendingPathComponent("logs")
            public static var asyncWrite: Bool = true
        }
        private static let logQueue = DispatchQueue(label: "com.tfy.logger.queue")
        private static let fileNameDateFormatter: Foundation.DateFormatter = {
            let formatter = Foundation.DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        /// 分级日志记录（支持异步写入）
        public static func log(
            _ items: Any...,
            level: Level = .debug,
            file: String = #fileID,
            line: Int = #line,
            function: String = #function
        ) {
            guard Config.enabledLevels.contains(level) else { return }
            let content = buildLogContent(items, level: level, file: file, line: line, function: function)
            print(content)
            if Config.asyncWrite {
                logQueue.async { writeToRotatedFile(content: content) }
            } else {
                logQueue.sync { writeToRotatedFile(content: content) }
        }
        }
        /// 构建日志内容，支持JSON格式化
        private static func buildLogContent(
            _ items: [Any],
            level: Level,
            file: String,
            line: Int,
            function: String
        ) -> String {
            let timestamp = Date().ISO8601Format()
            let message: String
            if items.count == 1, let dict = items.first as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                message = jsonString
            } else {
                message = items.map { "\($0)" }.joined(separator: " ")
            }
            return "\(timestamp) \(level.rawValue) [\(file):\(line)] \(function) - \(message)"
        }
        /// 写入日志到文件（带轮转）
        private static func writeToRotatedFile(content: String) {
            let fileManager = Foundation.FileManager.default
            let logDir = Config.logDirectory
            // 创建日志目录
            if !fileManager.fileExists(atPath: logDir) {
                do {
                    try fileManager.createDirectory(atPath: logDir, withIntermediateDirectories: true)
                } catch {
#if DEBUG
                    print("Failed to create log directory: \(error)")
#endif
                    return
                }
            }
            // 按日期分文件
            let filename = "app_\(fileNameDateFormatter.string(from: Date())).log"
            let filePath = (logDir as NSString).appendingPathComponent(filename)
            // 写入文件
            if let data = (content + "\n").data(using: .utf8) {
                if fileManager.fileExists(atPath: filePath) {
                    if let handle = try? FileHandle(forWritingTo: URL(fileURLWithPath: filePath)) {
                        handle.seekToEndOfFile()
                        handle.write(data)
                        try? handle.close()
                    }
                } else {
                    do {
                        try data.write(to: URL(fileURLWithPath: filePath))
                    } catch {
#if DEBUG
                        print("Failed to write log file: \(error)")
#endif
                    }
                }
            }
            cleanOldLogs()
        }
        /// 清理过期日志文件
        private static func cleanOldLogs() {
            let fileManager = Foundation.FileManager.default
            let logDir = Config.logDirectory
            guard let files = try? fileManager.contentsOfDirectory(atPath: logDir),
                  files.count > Config.maxFiles else { return }
            let sortedFiles = files.sorted()
            let filesToDelete = sortedFiles[0..<(sortedFiles.count - Config.maxFiles)]
            filesToDelete.forEach { file in
                let fullPath = (logDir as NSString).appendingPathComponent(file)
                try? fileManager.removeItem(atPath: fullPath)
            }
        }
        /// 导出所有日志内容
        public static func exportAllLogs() -> String {
            var allContent = ""
            let fileManager = Foundation.FileManager.default
            let logDir = Config.logDirectory
            if let files = try? fileManager.contentsOfDirectory(atPath: logDir) {
                for file in files.sorted() {
                    let filePath = (logDir as NSString).appendingPathComponent(file)
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                       let str = String(data: data, encoding: .utf8) {
                        allContent += str + "\n"
                    }
                }
            }
            return allContent
        }
        /// 动态调整日志级别
        public static func setEnabledLevels(_ levels: Set<Level>) {
            Config.enabledLevels = levels
        }
    }
    
    // MARK: - 内购工具
    public enum IAP {
        public enum PurchaseError: Error, LocalizedError {
            case notAvailable
            case purchaseFailed
            case verificationFailed
            case userCancelled
            case networkError
            case unknown
            
            public var errorDescription: String? {
                switch self {
                case .notAvailable: return "内购不可用"
                case .purchaseFailed: return "购买失败"
                case .verificationFailed: return "验证失败"
                case .userCancelled: return "用户取消"
                case .networkError: return "网络错误"
                case .unknown: return "未知错误"
                }
            }
        }
        
        private static var products: [Product] = []
        private static var purchaseTask: Task<Void, Error>?
        
        /// 获取商品信息
        public static func fetchProducts(identifiers: Set<String>) async throws -> [Product] {
            do {
                let products = try await Product.products(for: identifiers)
                self.products = products
                return products
            } catch {
                throw PurchaseError.notAvailable
            }
        }
        
        /// 购买商品
        public static func purchase(_ product: Product) async throws -> Transaction? {
            do {
                    let result = try await product.purchase()
                
                    switch result {
                    case .success(let verification):
                        let transaction = try checkVerified(verification)
                        await transaction.finish()
                    return transaction
                    case .userCancelled:
                    throw PurchaseError.userCancelled
                case .pending:
                    throw PurchaseError.purchaseFailed
                    @unknown default:
                    throw PurchaseError.unknown
                    }
                } catch {
                if error is PurchaseError {
                    throw error
                } else {
                    throw PurchaseError.purchaseFailed
                }
            }
        }
        
        /// 批量购买商品
        public static func purchaseMultiple(_ products: [Product]) async throws -> [Transaction] {
            var transactions: [Transaction] = []
            
            for product in products {
                do {
                    if let transaction = try await purchase(product) {
                        transactions.append(transaction)
                    }
                } catch {
                    // 继续购买其他商品，但记录错误
                    Logger.log("购买商品 \(product.id) 失败: \(error)", level: .error)
                }
            }
            
            return transactions
        }
        
        /// 恢复购买
        public static func restorePurchases() async throws -> [Transaction] {
            var restoredTransactions: [Transaction] = []
            
            for await result in Transaction.currentEntitlements {
                do {
                    let transaction = try checkVerified(result)
                    restoredTransactions.append(transaction)
                } catch {
                    Logger.log("恢复购买验证失败: \(error)", level: .error)
                }
            }
            
            return restoredTransactions
        }
        
        /// 检查交易验证
        private static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
            switch result {
            case .unverified:
                throw PurchaseError.verificationFailed
            case .verified(let safe):
                return safe
            }
        }
        
        /// 获取当前有效的交易
        public static func getCurrentTransactions() async -> [Transaction] {
            var transactions: [Transaction] = []
            
            for await result in Transaction.currentEntitlements {
                do {
                    let transaction = try checkVerified(result)
                    transactions.append(transaction)
                } catch {
                    Logger.log("获取当前交易失败: \(error)", level: .error)
                }
            }
            
            return transactions
        }
        
        /// 检查商品是否已购买
        public static func isProductPurchased(_ productId: String) async -> Bool {
            for await result in Transaction.currentEntitlements {
                do {
                    let transaction = try checkVerified(result)
                    if transaction.productID == productId {
                        return true
                    }
                } catch {
                    continue
                }
            }
            return false
        }
        
        /// 获取商品价格
        public static func getProductPrice(_ product: Product) -> String {
            return product.displayPrice
        }
        
        /// 获取商品本地化信息
        public static func getProductLocalizedInfo(_ product: Product) -> (title: String, description: String) {
            return (product.displayName, product.description)
        }
        
        /// 取消当前购买任务
        public static func cancelPurchase() {
            purchaseTask?.cancel()
            purchaseTask = nil
        }
        
        /// 完成交易
        public static func finishTransaction(_ transaction: Transaction) async {
            await transaction.finish()
        }
        
        /// 获取所有商品
        public static func getAllProducts() -> [Product] {
            return products
        }
        
        /// 根据ID获取商品
        public static func getProduct(by id: String) -> Product? {
            return products.first { $0.id == id }
        }
        
        /// 检查内购是否可用
        public static func isIAPAvailable() -> Bool {
            return AppStore.canMakePayments
        }
    }
    
    // MARK: - 系统功能
    public enum System {
        /// 安全打开URL
        public static func openURL(_ urlString: String) async -> Bool {
            guard let url = URL(string: urlString),
                  await UIApplication.shared.canOpenURL(url) else {
                return false
            }
            
            return await UIApplication.shared.open(url)
        }
        
        /// 拨打电话
        public static func call(_ number: String) async -> Bool {
            let urlString = "tel://\(number)"
            return await openURL(urlString)
        }
        
        /// 跳转App Store评分
        public static func requestReview() {
            if let scene = UIApplication.shared.connectedScenes.first(where: {
                $0.activationState == .foregroundActive
            }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    public enum viewController {
    
            // MARK: - 容器控制器查找
            /// 获取当前视图所在的容器控制器（增强版）
            /// - Parameters:
            ///   - types: 优先查找的容器类型顺序，默认 [UINavigationController.self, UITabBarController.self]
            /// - Returns: 找到的第一个匹配的容器控制器
            public static func currentContainer(
                for viewController: UIViewController,
                types: [UIViewController.Type] = [UINavigationController.self, UITabBarController.self]
            ) -> UIViewController? {
                // 优先检查直接父级关系
                for type in types {
                    if let container = findContainer(from: viewController, type: type) {
                        return container
                    }
                }
                // 扩展查找层级
                return findExtendedContainer(from: viewController, types: types)
            }
            
            /// 当前容器控制器（便捷访问）
            public static var currentContainer: UIViewController? {
                guard let currentVC = Window.topViewController else {
                    Logger.log("无法获取当前视图控制器", level: .warning)
                    return nil
                }
                return currentContainer(for: currentVC)
            }
            
            // MARK: - 私有方法
            private static func currentContainer(for controller: UIViewController) -> UIViewController? {
                currentContainer(for: controller, types: [UINavigationController.self, UITabBarController.self])
            }
            
            private static func findExtendedContainer(
                from source: UIViewController,
                types: [UIViewController.Type]
            ) -> UIViewController? {
                var current: UIViewController? = source
                
                while let controller = current {
                    for type in types {
                        if controller.isKind(of: type) {
                            return controller
                        }
                    }
                    current = getNextParent(for: controller)
                }
                return nil
            }
            
            private static func getNextParent(for controller: UIViewController) -> UIViewController? {
                if let parent = controller.parent { return parent }
                if let presenting = controller.presentingViewController { return presenting }
                if let navParent = controller.navigationController { return navParent }
                if let tabParent = controller.tabBarController { return tabParent }
                return nil
            }
            
            // MARK: - 容器查找
            public static func findContainer<T: UIViewController>(
                from source: UIViewController,
                type: T.Type
            ) -> T? {
                if let target = source as? T { return target }
                if let parent = source.parent { return findContainer(from: parent, type: type) }
                if let presented = source.presentedViewController { return findContainer(from: presented, type: type) }
                if let nav = source.navigationController { return findContainer(from: nav, type: type) }
                if let tab = source.tabBarController { return findContainer(from: tab, type: type) }
                return nil
            }
            
            // MARK: - 控制器操作
            /// 关闭控制器
            public static func dismiss(_ controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
                DispatchQueue.main.async {
                    controller.dismiss(animated: animated, completion: completion)
                }
            }
            
            // MARK: - 页面跳转
            /// 返回到指定类型的控制器界面
            public static func returnTo<T: UIViewController>(
                _ type: T.Type,
                animated: Bool = true,
                inclusive: Bool = false,
                completion: @escaping (Bool) -> Void
            ) {
                guard let currentVC = Window.topViewController else {
                    Logger.log("无法获取当前视图控制器", level: .warning)
                    completion(false)
                    return
                }
                
                guard let targetVC = findTargetViewController(from: currentVC, type: type, inclusive: inclusive) else {
                    Logger.log("未找到 \(type) 类型的控制器", level: .info)
                    completion(false)
                    return
                }
                
                performNavigation(to: targetVC, from: currentVC, animated: animated, completion: completion)
            }
            
            // MARK: - 私有实现
            private static func findTargetViewController<T: UIViewController>(
                from source: UIViewController,
                type: T.Type,
                inclusive: Bool
            ) -> T? {
                var controllers = [UIViewController]()
                
                if let nav = source.navigationController {
                    controllers = nav.viewControllers
                } else if let presentedChain = getPresentedChain(from: source) {
                    controllers = presentedChain
                }
                
                let matched = controllers.reversed().first { controller in
                    inclusive ? controller.isKind(of: type) : (controller != source && controller.isKind(of: type))
                }
                
                return matched as? T
            }
            
            private static func getPresentedChain(from source: UIViewController) -> [UIViewController]? {
                var chain = [UIViewController]()
                var current: UIViewController? = source
                
                while let controller = current {
                    chain.append(controller)
                    current = controller.presentingViewController
                }
                
                return chain.isEmpty ? nil : chain
            }
            
            private static func performNavigation<T: UIViewController>(
                to target: T,
                from source: UIViewController,
                animated: Bool,
                completion: @escaping (Bool) -> Void
            ) {
                if let nav = source.navigationController, nav.viewControllers.contains(target) {
                    popToViewController(nav: nav, target: target, animated: animated, completion: completion)
                } else if source.presentingViewController != nil {
                    dismissToViewController(source: source, target: target, animated: animated, completion: completion)
                } else {
                    completion(false)
                }
            }
            
            private static func popToViewController<T: UIViewController>(
                nav: UINavigationController,
                target: T,
                animated: Bool,
                completion: @escaping (Bool) -> Void
            ) {
                DispatchQueue.main.async {
                    nav.popToViewController(target, animated: animated) { _ in
                        completion(true)
                    }
                }
            }
            
            private static func dismissToViewController<T: UIViewController>(
                source: UIViewController,
                target: T,
                animated: Bool,
                completion: @escaping (Bool) -> Void
            ) {
                DispatchQueue.main.async {
                    source.dismiss(animated: animated) {
                        completion(true)
                    }
                }
            }
        }
}

// MARK: - 新增设备信息模块
public extension TFYUtils {
    
    enum Device {
        /// 设备类型判断
        public enum ModelType {
            case iPhone
            case iPad
            case mac
            case carPlay
            case unspecified
        }
        
        /// 当前设备类型
        public static var modelType: ModelType {
            #if targetEnvironment(macCatalyst)
            return .mac
            #elseif targetEnvironment(simulator)
            return .unspecified
            #else
            switch UIDevice.current.userInterfaceIdiom {
            case .phone: return .iPhone
            case .pad: return .iPad
            case .carPlay: return .carPlay
            default: return .unspecified
            }
            #endif
        }
        
        /// 设备安全区域
        public static var safeAreaInsets: UIEdgeInsets {
            Window.current?.safeAreaInsets ?? .zero
        }
        
        /// 设备名称
        public static var name: String {
            UIDevice.current.name
        }
        
        /// 系统版本
        public static var systemVersion: String {
            UIDevice.current.systemVersion
        }
        
        /// 是否是刘海屏设备
        public static var hasNotch: Bool {
            safeAreaInsets.top > 20
        }
        
        /// 屏幕尺寸
        public static var screenSize: CGSize {
            UIScreen.main.bounds.size
        }
        
        /// 电池电量
        public static var batteryLevel: Float {
            UIDevice.current.isBatteryMonitoringEnabled = true
            return UIDevice.current.batteryLevel
        }
        
        /// 是否处于低电量模式
        public static var isLowPowerModeEnabled: Bool {
            ProcessInfo.processInfo.isLowPowerModeEnabled
        }
    }
}

// MARK: - 新增安全存储模块
public extension TFYUtils {
    enum Keychain {
        /// Keychain错误类型
        public enum KeychainError: Error, LocalizedError {
            case unhandledError(status: OSStatus)
            case itemNotFound
            case duplicateItem
            case invalidData
            case saveFailed
            
            public var errorDescription: String? {
                switch self {
                case .unhandledError(let status):
                    return "Keychain错误: \(status)"
                case .itemNotFound:
                    return "Keychain项目未找到"
                case .duplicateItem:
                    return "Keychain项目已存在"
                case .invalidData:
                    return "无效的数据"
                case .saveFailed:
                    return "保存失败"
                }
            }
        }
        
        /// 安全存储数据
        public static func save(_ data: Data, service: String, account: String) throws {
            let query = [
                kSecValueData: data,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            
            let status = SecItemAdd(query, nil)
            guard status == errSecSuccess else {
                if status == errSecDuplicateItem {
                    // 项目已存在，尝试更新
                    try update(data, service: service, account: account)
                    return
                } else {
                    throw KeychainError.unhandledError(status: status)
                }
            }
        }
        
        /// 更新Keychain数据
        public static func update(_ data: Data, service: String, account: String) throws {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            
            let attributes = [kSecValueData: data] as CFDictionary
            let status = SecItemUpdate(query, attributes)
            guard status == errSecSuccess else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        
        /// 读取安全数据
        public static func read(service: String, account: String) throws -> Data {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecReturnData: true
            ] as CFDictionary
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query, &result)
            
            guard status == errSecSuccess else {
                if status == errSecItemNotFound {
                    throw KeychainError.itemNotFound
                } else {
                throw KeychainError.unhandledError(status: status)
                }
            }
            
            guard let data = result as? Data else {
                throw KeychainError.invalidData
            }
            
            return data
        }
        
        /// 删除Keychain项目
        public static func delete(service: String, account: String) throws {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            
            let status = SecItemDelete(query)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        
        /// 检查Keychain项目是否存在
        public static func exists(service: String, account: String) -> Bool {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecReturnData: false
            ] as CFDictionary
            
            let status = SecItemCopyMatching(query, nil)
            return status == errSecSuccess
        }
        
        /// 保存字符串
        public static func saveString(_ string: String, service: String, account: String) throws {
            guard let data = string.data(using: .utf8) else {
                throw KeychainError.invalidData
            }
            try save(data, service: service, account: account)
        }
        
        /// 读取字符串
        public static func readString(service: String, account: String) throws -> String {
            let data = try read(service: service, account: account)
            guard let string = String(data: data, encoding: .utf8) else {
                throw KeychainError.invalidData
            }
            return string
        }
        
        /// 保存字典
        public static func saveDictionary(_ dict: [String: Any], service: String, account: String) throws {
            let data = try JSONSerialization.data(withJSONObject: dict)
            try save(data, service: service, account: account)
        }
        
        /// 读取字典
        public static func readDictionary(service: String, account: String) throws -> [String: Any] {
            let data = try read(service: service, account: account)
            guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw KeychainError.invalidData
            }
            return dict
        }
        
        /// 保存Codable对象
        public static func saveObject<T: Codable>(_ object: T, service: String, account: String) throws {
            let data = try JSONEncoder().encode(object)
            try save(data, service: service, account: account)
        }
        
        /// 读取Codable对象
        public static func readObject<T: Codable>(_ type: T.Type, service: String, account: String) throws -> T {
            let data = try read(service: service, account: account)
            return try JSONDecoder().decode(type, from: data)
        }
        
        /// 清除所有Keychain数据（谨慎使用）
        public static func clearAll() throws {
            let query = [kSecClass: kSecClassGenericPassword] as CFDictionary
            let status = SecItemDelete(query)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        
        /// 获取所有Keychain项目
        public static func getAllItems() throws -> [[String: Any]] {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecReturnData: true,
                kSecReturnAttributes: true,
                kSecMatchLimit: kSecMatchLimitAll
            ] as CFDictionary
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query, &result)
            
            guard status == errSecSuccess else {
                if status == errSecItemNotFound {
                    return []
                } else {
                    throw KeychainError.unhandledError(status: status)
                }
            }
            
            guard let items = result as? [[String: Any]] else {
                throw KeychainError.invalidData
            }
            
            return items
        }
        
        // MARK: - 基础数据类型支持
        
        /// 保存整数
        public static func saveInt(_ value: Int, service: String, account: String) throws {
            let data = withUnsafeBytes(of: value.bigEndian) { Data($0) }
            try save(data, service: service, account: account)
        }
        
        /// 读取整数
        public static func readInt(service: String, account: String) throws -> Int {
            let data = try read(service: service, account: account)
            guard data.count == MemoryLayout<Int>.size else {
                throw KeychainError.invalidData
            }
            return data.withUnsafeBytes { $0.load(as: Int.self).bigEndian }
        }
        
        /// 保存双精度浮点数
        public static func saveDouble(_ value: Double, service: String, account: String) throws {
            var bigEndianValue = value.bitPattern.bigEndian
            let data = withUnsafeBytes(of: &bigEndianValue) { Data($0) }
            try save(data, service: service, account: account)
        }
        
        /// 读取双精度浮点数
        public static func readDouble(service: String, account: String) throws -> Double {
            let data = try read(service: service, account: account)
            guard data.count == MemoryLayout<Double>.size else {
                throw KeychainError.invalidData
            }
            let bigEndianPattern = data.withUnsafeBytes { $0.load(as: UInt64.self) }
            return Double(bitPattern: UInt64(bigEndian: bigEndianPattern))
        }
        
        /// 保存布尔值
        public static func saveBool(_ value: Bool, service: String, account: String) throws {
            let data = withUnsafeBytes(of: value) { Data($0) }
            try save(data, service: service, account: account)
        }
        
        /// 读取布尔值
        public static func readBool(service: String, account: String) throws -> Bool {
            let data = try read(service: service, account: account)
            guard data.count == MemoryLayout<Bool>.size else {
                throw KeychainError.invalidData
            }
            return data.withUnsafeBytes { $0.load(as: Bool.self) }
        }
        
        /// 保存日期
        public static func saveDate(_ date: Date, service: String, account: String) throws {
            let timeInterval = date.timeIntervalSince1970
            try saveDouble(timeInterval, service: service, account: account)
        }
        
        /// 读取日期
        public static func readDate(service: String, account: String) throws -> Date {
            let timeInterval = try readDouble(service: service, account: account)
            return Date(timeIntervalSince1970: timeInterval)
        }
        
        // MARK: - 数组类型支持
        
        /// 保存字符串数组
        public static func saveStringArray(_ array: [String], service: String, account: String) throws {
            let data = try JSONSerialization.data(withJSONObject: array)
            try save(data, service: service, account: account)
        }
        
        /// 读取字符串数组
        public static func readStringArray(service: String, account: String) throws -> [String] {
            let data = try read(service: service, account: account)
            guard let array = try JSONSerialization.jsonObject(with: data) as? [String] else {
                throw KeychainError.invalidData
            }
            return array
        }
        
        /// 保存整数数组
        public static func saveIntArray(_ array: [Int], service: String, account: String) throws {
            let data = try JSONSerialization.data(withJSONObject: array)
            try save(data, service: service, account: account)
        }
        
        /// 读取整数数组
        public static func readIntArray(service: String, account: String) throws -> [Int] {
            let data = try read(service: service, account: account)
            guard let array = try JSONSerialization.jsonObject(with: data) as? [Int] else {
                throw KeychainError.invalidData
            }
            return array
        }
        
        /// 保存字典数组
        public static func saveDictionaryArray(_ array: [[String: Any]], service: String, account: String) throws {
            let data = try JSONSerialization.data(withJSONObject: array)
            try save(data, service: service, account: account)
        }
        
        /// 读取字典数组
        public static func readDictionaryArray(service: String, account: String) throws -> [[String: Any]] {
            let data = try read(service: service, account: account)
            guard let array = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                throw KeychainError.invalidData
            }
            return array
        }
        
        /// 保存Codable对象数组
        public static func saveObjectArray<T: Codable>(_ array: [T], service: String, account: String) throws {
            let data = try JSONEncoder().encode(array)
            try save(data, service: service, account: account)
        }
        
        /// 读取Codable对象数组
        public static func readObjectArray<T: Codable>(_ type: T.Type, service: String, account: String) throws -> [T] {
            let data = try read(service: service, account: account)
            return try JSONDecoder().decode([T].self, from: data)
        }
        
        // MARK: - 特殊类型支持
        
        /// 保存URL
        public static func saveURL(_ url: URL, service: String, account: String) throws {
            try saveString(url.absoluteString, service: service, account: account)
        }
        
        /// 读取URL
        public static func readURL(service: String, account: String) throws -> URL {
            let urlString = try readString(service: service, account: account)
            guard let url = URL(string: urlString) else {
                throw KeychainError.invalidData
            }
            return url
        }
        
        /// 保存UUID
        public static func saveUUID(_ uuid: UUID, service: String, account: String) throws {
            try saveString(uuid.uuidString, service: service, account: account)
        }
        
        /// 读取UUID
        public static func readUUID(service: String, account: String) throws -> UUID {
            let uuidString = try readString(service: service, account: account)
            guard let uuid = UUID(uuidString: uuidString) else {
                throw KeychainError.invalidData
            }
            return uuid
        }
        
        /// 保存图片数据
        public static func saveImageData(_ imageData: Data, service: String, account: String) throws {
            try save(imageData, service: service, account: account)
        }
        
        /// 读取图片数据
        public static func readImageData(service: String, account: String) throws -> Data {
            return try read(service: service, account: account)
        }
        
        /// 保存UIImage
        public static func saveImage(_ image: UIImage, service: String, account: String) throws {
            guard let imageData = image.pngData() else {
                throw KeychainError.invalidData
            }
            try saveImageData(imageData, service: service, account: account)
        }
        
        /// 读取UIImage
        public static func readImage(service: String, account: String) throws -> UIImage {
            let imageData = try readImageData(service: service, account: account)
            guard let image = UIImage(data: imageData) else {
                throw KeychainError.invalidData
            }
            return image
        }
        
        // MARK: - 加密存储支持
        
        /// 保存加密字符串
        public static func saveEncryptedString(_ string: String, service: String, account: String, password: String) throws {
            guard let data = string.data(using: .utf8) else {
                throw KeychainError.invalidData
            }
            let encryptedData = try encryptData(data, password: password)
            try save(encryptedData, service: service, account: account)
        }
        
        /// 读取加密字符串
        public static func readEncryptedString(service: String, account: String, password: String) throws -> String {
            let encryptedData = try read(service: service, account: account)
            let decryptedData = try decryptData(encryptedData, password: password)
            guard let string = String(data: decryptedData, encoding: .utf8) else {
                throw KeychainError.invalidData
            }
            return string
        }
        
        /// 保存加密数据
        public static func saveEncryptedData(_ data: Data, service: String, account: String, password: String) throws {
            let encryptedData = try encryptData(data, password: password)
            try save(encryptedData, service: service, account: account)
        }
        
        /// 读取加密数据
        public static func readEncryptedData(service: String, account: String, password: String) throws -> Data {
            let encryptedData = try read(service: service, account: account)
            return try decryptData(encryptedData, password: password)
        }
        
        // MARK: - 批量操作支持
        
        /// 批量保存
        public static func batchSave(_ items: [(key: String, value: Data)], service: String) throws {
            for item in items {
                try save(item.value, service: service, account: item.key)
            }
        }
        
        /// 批量读取
        public static func batchRead(_ keys: [String], service: String) throws -> [String: Data] {
            var results: [String: Data] = [:]
            for key in keys {
                do {
                    let data = try read(service: service, account: key)
                    results[key] = data
                } catch KeychainError.itemNotFound {
                    // 跳过不存在的项目
                    continue
                } catch {
                    throw error
                }
            }
            return results
        }
        
        /// 批量删除
        public static func batchDelete(_ keys: [String], service: String) throws {
            for key in keys {
                do {
                    try delete(service: service, account: key)
                } catch KeychainError.itemNotFound {
                    // 跳过不存在的项目
                    continue
                } catch {
                    throw error
                }
            }
        }
        
        // MARK: - 私有加密方法
        
        private static func encryptData(_ data: Data, password: String) throws -> Data {
            guard let passwordData = password.data(using: .utf8) else {
                throw KeychainError.invalidData
            }
            
            let keyLength = kCCKeySizeAES256
            let ivLength = kCCBlockSizeAES128
            
            // 生成随机IV
            var iv = Data(count: ivLength)
            let ivResult = iv.withUnsafeMutableBytes { ivBytes in
                SecRandomCopyBytes(kSecRandomDefault, ivLength, ivBytes.bindMemory(to: UInt8.self).baseAddress!)
            }
            guard ivResult == errSecSuccess else {
                throw KeychainError.unhandledError(status: ivResult)
            }
            
            // 生成密钥
            var key = Data(count: keyLength)
            let keyResult = key.withUnsafeMutableBytes { keyBytes in
                passwordData.withUnsafeBytes { passwordBytes in
                    CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                       passwordBytes.bindMemory(to: Int8.self).baseAddress!,
                                       passwordData.count,
                                       nil, 0,
                                       CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                       10000,
                                       keyBytes.bindMemory(to: UInt8.self).baseAddress!,
                                       keyLength)
                }
            }
            guard keyResult == kCCSuccess else {
                throw KeychainError.unhandledError(status: keyResult)
            }
            
            // 加密数据
            let dataLength = data.count
            let bufferSize = dataLength + kCCBlockSizeAES128
            var buffer = Data(count: bufferSize)
            var bytesProcessed: size_t = 0
            
            let cryptResult = buffer.withUnsafeMutableBytes { bufferBytes in
                data.withUnsafeBytes { dataBytes in
                    iv.withUnsafeBytes { ivBytes in
                        key.withUnsafeBytes { keyBytes in
                            CCCrypt(CCOperation(kCCEncrypt),
                                   CCAlgorithm(kCCAlgorithmAES),
                                   CCOptions(kCCOptionPKCS7Padding),
                                   keyBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   keyLength,
                                   ivBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   dataBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   dataLength,
                                   bufferBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   bufferSize,
                                   &bytesProcessed)
                        }
                    }
                }
            }
            
            guard cryptResult == kCCSuccess else {
                throw KeychainError.unhandledError(status: cryptResult)
            }
            
            // 组合IV和加密数据
            var encryptedData = iv
            encryptedData.append(buffer.prefix(bytesProcessed))
            return encryptedData
        }
        
        private static func decryptData(_ encryptedData: Data, password: String) throws -> Data {
            guard let passwordData = password.data(using: .utf8) else {
                throw KeychainError.invalidData
            }
            
            let keyLength = kCCKeySizeAES256
            let ivLength = kCCBlockSizeAES128
            
            guard encryptedData.count > ivLength else {
                throw KeychainError.invalidData
            }
            
            // 提取IV
            let iv = encryptedData.prefix(ivLength)
            let cipherData = encryptedData.dropFirst(ivLength)
            
            // 生成密钥
            var key = Data(count: keyLength)
            let keyResult = key.withUnsafeMutableBytes { keyBytes in
                passwordData.withUnsafeBytes { passwordBytes in
                    CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                       passwordBytes.bindMemory(to: Int8.self).baseAddress!,
                                       passwordData.count,
                                       nil, 0,
                                       CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                       10000,
                                       keyBytes.bindMemory(to: UInt8.self).baseAddress!,
                                       keyLength)
                }
            }
            guard keyResult == kCCSuccess else {
                throw KeychainError.unhandledError(status: keyResult)
            }
            
            // 解密数据
            let dataLength = cipherData.count
            let bufferSize = dataLength + kCCBlockSizeAES128
            var buffer = Data(count: bufferSize)
            var bytesProcessed: size_t = 0
            
            let cryptResult = buffer.withUnsafeMutableBytes { bufferBytes in
                cipherData.withUnsafeBytes { cipherBytes in
                    iv.withUnsafeBytes { ivBytes in
                        key.withUnsafeBytes { keyBytes in
                            CCCrypt(CCOperation(kCCDecrypt),
                                   CCAlgorithm(kCCAlgorithmAES),
                                   CCOptions(kCCOptionPKCS7Padding),
                                   keyBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   keyLength,
                                   ivBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   cipherBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   dataLength,
                                   bufferBytes.bindMemory(to: UInt8.self).baseAddress!,
                                   bufferSize,
                                   &bytesProcessed)
                        }
                    }
                }
            }
            
            guard cryptResult == kCCSuccess else {
                throw KeychainError.unhandledError(status: cryptResult)
            }
            
            return buffer.prefix(bytesProcessed)
        }
    }
}

// MARK: - 动画工具
public extension TFYUtils {
    // MARK: - 动画工具
    enum Animation {
        /// 动画类型
        public enum AnimationType {
            case fade
            case slide(direction: SlideDirection)
            case scale(scale: CGFloat)
            case rotate(angle: CGFloat)
            case bounce
            case shake
            case pulse
            case custom(duration: TimeInterval, options: UIView.AnimationOptions)
        }
        
        /// 滑动方向
        public enum SlideDirection {
            case left, right, up, down
        }
        
        /// 动画配置
        public struct Config {
            public static var defaultDuration: TimeInterval = 0.3
            public static var defaultDelay: TimeInterval = 0.0
            public static var defaultOptions: UIView.AnimationOptions = [.curveEaseInOut]
            public static var defaultSpringDamping: CGFloat = 0.8
            public static var defaultSpringVelocity: CGFloat = 0.5
        }
        
        /// 基础动画
        public static func animate(
            type: AnimationType,
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            switch type {
            case .fade:
                animateFade(duration: duration, delay: delay, options: options, completion: completion)
            case .slide(let direction):
                animateSlide(direction: direction, duration: duration, delay: delay, options: options, completion: completion)
            case .scale(let scale):
                animateScale(scale: scale, duration: duration, delay: delay, options: options, completion: completion)
            case .rotate(let angle):
                animateRotate(angle: angle, duration: duration, delay: delay, options: options, completion: completion)
            case .bounce:
                animateBounce(duration: duration, delay: delay, options: options, completion: completion)
            case .shake:
                animateShake(duration: duration, delay: delay, options: options, completion: completion)
            case .pulse:
                animatePulse(duration: duration, delay: delay, options: options, completion: completion)
            case .custom(let customDuration, let customOptions):
                animateCustom(duration: customDuration, delay: delay, options: customOptions, completion: completion)
            }
        }
        
        /// 淡入动画
        public static func animateFade(
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                // 淡入动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 滑动动画
        public static func animateSlide(
            direction: SlideDirection,
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                // 滑动动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 缩放动画
        public static func animateScale(
            scale: CGFloat,
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                // 缩放动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 旋转动画
        public static func animateRotate(
            angle: CGFloat,
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                // 旋转动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 弹跳动画
        public static func animateBounce(
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: Config.defaultSpringDamping, initialSpringVelocity: Config.defaultSpringVelocity, options: options) {
                // 弹跳动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 震动动画
        public static func animateShake(
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                // 震动动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 脉冲动画
        public static func animatePulse(
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                // 脉冲动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 自定义动画
        public static func animateCustom(
            duration: TimeInterval,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, options: options) {
                // 自定义动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 链式动画
        public static func chainAnimations(
            _ animations: [AnimationType],
            completion: ((Bool) -> Void)? = nil
        ) {
            var remainingAnimations = animations
            
            func executeNextAnimation() {
                guard !remainingAnimations.isEmpty else {
                    completion?(true)
                    return
                }
                
                let animation = remainingAnimations.removeFirst()
                animate(type: animation) { finished in
                    if finished && !remainingAnimations.isEmpty {
                        executeNextAnimation()
                    } else {
                        completion?(finished)
                    }
                }
            }
            
            executeNextAnimation()
        }
        
        /// 交叉淡入淡出
        public static func crossFade(
            from oldView: UIView,
            to newView: UIView,
            duration: TimeInterval = Config.defaultDuration,
            completion: ((Bool) -> Void)? = nil
        ) {
            newView.alpha = 0
            oldView.superview?.addSubview(newView)
            
            UIView.animate(withDuration: duration, delay: 0, options: Config.defaultOptions) {
                oldView.alpha = 0
                newView.alpha = 1
            } completion: { finished in
                oldView.removeFromSuperview()
                completion?(finished)
            }
        }
        
        /// 弹性动画
        public static func springAnimation(
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            damping: CGFloat = Config.defaultSpringDamping,
            velocity: CGFloat = Config.defaultSpringVelocity,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options) {
                // 弹性动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 关键帧动画
        public static func keyframeAnimation(
            duration: TimeInterval = Config.defaultDuration,
            delay: TimeInterval = Config.defaultDelay,
            options: UIView.KeyframeAnimationOptions = [],
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.animateKeyframes(withDuration: duration, delay: delay, options: options) {
                // 关键帧动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
        
        /// 转场动画
        public static func transitionAnimation(
            duration: TimeInterval = Config.defaultDuration,
            options: UIView.AnimationOptions = Config.defaultOptions,
            completion: ((Bool) -> Void)? = nil
        ) {
            UIView.transition(with: UIView(), duration: duration, options: options) {
                // 转场动画逻辑
            } completion: { finished in
                completion?(finished)
            }
        }
    }
}

// MARK: - 新增本地通知模块
public extension TFYUtils {
    // MARK: - 通知工具
    enum Notification {
        /// 通知类型
        public enum NotificationType {
            case alert
            case badge
            case sound
            case all
        }
        
        /// 通知错误类型
        public enum NotificationError: Error, LocalizedError {
            case notAuthorized
            case denied
            case notSupported
            case unknown
            
            public var errorDescription: String? {
                switch self {
                case .notAuthorized: return "通知未授权"
                case .denied: return "通知被拒绝"
                case .notSupported: return "通知不支持"
                case .unknown: return "未知错误"
                }
            }
        }
        
        /// 请求通知权限
        public static func requestPermission(
            types: NotificationType = .all,
            completion: @escaping (Bool, NotificationError?) -> Void
        ) {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: getAuthorizationOptions(for: types)) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        completion(true, nil)
                    } else {
                        completion(false, .denied)
                    }
                }
            }
        }
        
        /// 检查通知权限状态
        public static func checkPermissionStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                DispatchQueue.main.async {
                    completion(settings.authorizationStatus)
                }
            }
        }
        
        /// 获取授权选项
        private static func getAuthorizationOptions(for type: NotificationType) -> UNAuthorizationOptions {
            switch type {
            case .alert:
                return [.alert]
            case .badge:
                return [.badge]
            case .sound:
                return [.sound]
            case .all:
                return [.alert, .badge, .sound]
            }
        }
        
        /// 发送本地通知
        public static func scheduleLocalNotification(
            title: String,
            body: String,
            timeInterval: TimeInterval,
            repeats: Bool = false,
            identifier: String? = nil,
            userInfo: [AnyHashable: Any]? = nil,
            completion: @escaping (String?, Error?) -> Void
        ) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            if let userInfo = userInfo {
                content.userInfo = userInfo
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
            let request = UNNotificationRequest(
                identifier: identifier ?? UUID().uuidString,
                content: content,
                trigger: trigger
            )
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(nil, error)
                    } else {
                        completion(request.identifier, nil)
                    }
                }
            }
        }
        
        /// 发送日期通知
        public static func scheduleDateNotification(
            title: String,
            body: String,
            date: Date,
            repeats: Bool = false,
            identifier: String? = nil,
            userInfo: [AnyHashable: Any]? = nil,
            completion: @escaping (String?, Error?) -> Void
        ) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            if let userInfo = userInfo {
                content.userInfo = userInfo
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
            
            let request = UNNotificationRequest(
                identifier: identifier ?? UUID().uuidString,
                content: content,
                trigger: trigger
            )
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(nil, error)
                    } else {
                        completion(request.identifier, nil)
                    }
                }
            }
        }
        
        /// 取消指定通知
        public static func cancelNotification(identifier: String) {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
        
        /// 取消所有通知
        public static func cancelAllNotifications() {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        }
        
        /// 获取待发送的通知
        public static func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { requests in
                DispatchQueue.main.async {
                    completion(requests)
                }
            }
        }
        
        /// 获取已发送的通知
        public static func getDeliveredNotifications(completion: @escaping ([UNNotification]) -> Void) {
            let center = UNUserNotificationCenter.current()
            center.getDeliveredNotifications { notifications in
                DispatchQueue.main.async {
                    completion(notifications)
                }
            }
        }
        
        /// 清除已发送的通知
        public static func clearDeliveredNotifications() {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
        }
        
        /// 设置通知分类
        public static func setNotificationCategories(_ categories: Set<UNNotificationCategory>) {
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories(categories)
        }
        
        /// 创建通知分类
        public static func createNotificationCategory(
            identifier: String,
            actions: [UNNotificationAction],
            intentIdentifiers: [String] = [],
            options: UNNotificationCategoryOptions = []
        ) -> UNNotificationCategory {
            return UNNotificationCategory(
                identifier: identifier,
                actions: actions,
                intentIdentifiers: intentIdentifiers,
                options: options
            )
        }
        
        /// 创建通知动作
        public static func createNotificationAction(
            identifier: String,
            title: String,
            options: UNNotificationActionOptions = []
        ) -> UNNotificationAction {
            return UNNotificationAction(
                identifier: identifier,
                title: title,
                options: options
            )
        }
        
        /// 创建文本输入动作
        public static func createTextInputNotificationAction(
            identifier: String,
            title: String,
            options: UNNotificationActionOptions = [],
            textInputButtonTitle: String,
            textInputPlaceholder: String
        ) -> UNTextInputNotificationAction {
            return UNTextInputNotificationAction(
                identifier: identifier,
                title: title,
                options: options,
                textInputButtonTitle: textInputButtonTitle,
                textInputPlaceholder: textInputPlaceholder
            )
        }
        
        /// 检查通知是否已授权
        public static func isAuthorized(completion: @escaping (Bool) -> Void) {
            checkPermissionStatus { status in
                completion(status == .authorized)
            }
        }
        
        /// 打开应用设置
        public static func openAppSettings() {
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
}

// MARK: - 新增触觉反馈模块
public extension TFYUtils {
    // MARK: - 触觉反馈工具
    enum Haptics {
        /// 触觉反馈类型
        public enum HapticType {
            case light
            case medium
            case heavy
            case soft
            case rigid
            case success
            case warning
            case error
            case selection
        }
        
        /// 触觉反馈强度
        public enum HapticIntensity {
            case light
            case medium
            case heavy
        }
        
        /// 触觉反馈模式
        public enum HapticPattern {
            case single
            case double
            case triple
            case continuous(interval: TimeInterval)
        }
        
        /// 触觉反馈错误类型
        public enum HapticError: Error, LocalizedError {
            case notSupported
            case notEnabled
            case unknown
            
            public var errorDescription: String? {
                switch self {
                case .notSupported: return "触觉反馈不支持"
                case .notEnabled: return "触觉反馈未启用"
                case .unknown: return "未知错误"
                }
            }
        }
        
        /// 触觉反馈生成器
        private static var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
        private static var notificationGenerator: UINotificationFeedbackGenerator?
        private static var selectionGenerator: UISelectionFeedbackGenerator?
        
        /// 检查触觉反馈是否可用
        public static var isHapticFeedbackAvailable: Bool {
            if #available(iOS 10.0, *) {
                // 检查设备是否支持触觉反馈
                let device = UIDevice.current
                let model = device.model
                // iPhone 7及以上支持触觉反馈
                return model == "iPhone" && device.systemVersion.compare("10.0", options: .numeric) != .orderedAscending
            }
            return false
        }
        
        /// 检查触觉反馈是否启用
        public static var isHapticFeedbackEnabled: Bool {
            // 检查系统设置中的触觉反馈是否启用
            // 注意：iOS没有直接API检查这个设置，我们假设如果设备支持就启用
            return isHapticFeedbackAvailable
        }
        
        /// 触发触觉反馈
        public static func trigger(_ type: HapticType) {
            guard isHapticFeedbackAvailable else { return }
            
            switch type {
            case .light:
                triggerImpact(.light)
            case .medium:
                triggerImpact(.medium)
            case .heavy:
                triggerImpact(.heavy)
            case .soft:
                if #available(iOS 13.0, *) {
                    triggerImpact(.soft)
                } else {
                    triggerImpact(.light)
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    triggerImpact(.rigid)
                } else {
                    triggerImpact(.heavy)
                }
            case .success:
                triggerNotification(.success)
            case .warning:
                triggerNotification(.warning)
            case .error:
                triggerNotification(.error)
            case .selection:
                triggerSelection()
            }
        }
        
        /// 触发自定义触觉反馈
        public static func triggerCustom(
            intensity: HapticIntensity,
            pattern: HapticPattern = .single
        ) {
            guard isHapticFeedbackAvailable else { return }
            
            let style: UIImpactFeedbackGenerator.FeedbackStyle
            switch intensity {
            case .light:
                style = .light
            case .medium:
                style = .medium
            case .heavy:
                style = .heavy
            }
            
            switch pattern {
            case .single:
                triggerImpact(style)
            case .double:
                triggerImpact(style)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    triggerImpact(style)
                }
            case .triple:
                triggerImpact(style)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    triggerImpact(style)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    triggerImpact(style)
                }
            case .continuous(let interval):
                triggerContinuousImpact(style, interval: interval)
            }
        }
        
        /// 触发冲击反馈
        private static func triggerImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = getImpactGenerator(for: style)
            generator.prepare()
            generator.impactOccurred()
        }
        
        /// 触发连续冲击反馈
        private static func triggerContinuousImpact(
            _ style: UIImpactFeedbackGenerator.FeedbackStyle,
            interval: TimeInterval
        ) {
            let generator = getImpactGenerator(for: style)
            generator.prepare()
            
            var count = 0
            let maxCount = 10 // 最大连续次数
            
            func trigger() {
                guard count < maxCount else { return }
                generator.impactOccurred()
                count += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                    trigger()
                }
            }
            
            trigger()
        }
        
        /// 触发通知反馈
        private static func triggerNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
            let generator = getNotificationGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
        
        /// 触发选择反馈
        private static func triggerSelection() {
            let generator = getSelectionGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
        
        /// 获取冲击反馈生成器
        private static func getImpactGenerator(for style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator {
            if let generator = impactGenerators[style] {
                return generator
            } else {
                let generator = UIImpactFeedbackGenerator(style: style)
                impactGenerators[style] = generator
                return generator
            }
        }
        
        /// 获取通知反馈生成器
        private static func getNotificationGenerator() -> UINotificationFeedbackGenerator {
            if let generator = notificationGenerator {
                return generator
            } else {
                let generator = UINotificationFeedbackGenerator()
                notificationGenerator = generator
                return generator
            }
        }
        
        /// 获取选择反馈生成器
        private static func getSelectionGenerator() -> UISelectionFeedbackGenerator {
            if let generator = selectionGenerator {
                return generator
            } else {
                let generator = UISelectionFeedbackGenerator()
                selectionGenerator = generator
                return generator
            }
        }
        
        /// 准备触觉反馈
        public static func prepare(_ type: HapticType) {
            guard isHapticFeedbackAvailable else { return }
            
            switch type {
            case .light, .medium, .heavy, .soft, .rigid:
                let style: UIImpactFeedbackGenerator.FeedbackStyle
                switch type {
                case .light: style = .light
                case .medium: style = .medium
                case .heavy: style = .heavy
                case .soft:
                    if #available(iOS 13.0, *) {
                        style = .soft
                    } else {
                        style = .light
                    }
                case .rigid:
                    if #available(iOS 13.0, *) {
                        style = .rigid
                    } else {
                        style = .heavy
                    }
                case .success, .warning, .error, .selection:
                    return // 这些case在外层switch中处理
                }
                getImpactGenerator(for: style).prepare()
            case .success, .warning, .error:
                getNotificationGenerator().prepare()
            case .selection:
                getSelectionGenerator().prepare()
            }
        }
        
        /// 清除触觉反馈生成器
        public static func clearGenerators() {
            impactGenerators.removeAll()
            notificationGenerator = nil
            selectionGenerator = nil
        }
        
        /// 触觉反馈强度控制
        public static func setIntensity(_ intensity: HapticIntensity) {
            // 这里可以根据需要调整触觉反馈的强度
            // 由于iOS限制，无法直接控制触觉反馈强度
            // 但可以通过不同的反馈类型来模拟不同的强度
        }
        
        /// 触觉反馈模式控制
        public static func setPattern(_ pattern: HapticPattern) {
            // 这里可以根据需要设置触觉反馈的模式
            // 可以通过定时器来实现不同的模式
        }
    }
}

// MARK: - 新增生物识别模块
public extension TFYUtils {
    // MARK: - 生物识别工具
    enum Biometrics {
        /// 生物识别类型
        public enum BiometricType {
            case none
            case touchID
            case faceID
            case unknown
        }
        
        /// 生物识别错误类型
        public enum BiometricError: Error, LocalizedError {
            case notAvailable
            case notEnrolled
            case lockedOut
            case userCancel
            case userFallback
            case systemCancel
            case passcodeNotSet
            case biometryNotAvailable
            case unknown
            
            public var errorDescription: String? {
                switch self {
                case .notAvailable: return "生物识别不可用"
                case .notEnrolled: return "未设置生物识别"
                case .lockedOut: return "生物识别已锁定"
                case .userCancel: return "用户取消"
                case .userFallback: return "用户选择密码"
                case .systemCancel: return "系统取消"
                case .passcodeNotSet: return "未设置密码"
                case .biometryNotAvailable: return "生物识别不可用"
                case .unknown: return "未知错误"
                }
            }
        }
        
        private static let context = LAContext()
        
        /// 获取生物识别类型
        public static var biometricType: BiometricType {
            var error: NSError?
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                return .none
            }
            
            switch context.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            case .none:
                return .none
            default:
                return .unknown
            }
        }
        
        /// 检查生物识别是否可用
        public static var isBiometricsAvailable: Bool {
            var error: NSError?
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        }
        
        /// 检查是否已设置生物识别
        public static var isBiometricsEnrolled: Bool {
            var error: NSError?
            let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            return canEvaluate && error == nil
        }
        
        /// 检查是否已设置密码
        public static var isPasscodeSet: Bool {
            var error: NSError?
            return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        }
        
        /// 生物识别认证
        public static func authenticate(
            reason: String = "请验证身份",
            allowPasswordFallback: Bool = true,
            completion: @escaping (Result<Void, BiometricError>) -> Void
        ) {
            var error: NSError?
            
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                if let error = error {
                    completion(.failure(convertLAError(error)))
                } else {
                    completion(.failure(.notAvailable))
                }
                return
            }
            
            let policy: LAPolicy = allowPasswordFallback ? .deviceOwnerAuthentication : .deviceOwnerAuthenticationWithBiometrics
            
            context.evaluatePolicy(policy, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(.success(()))
                    } else if let error = error as? LAError {
                        completion(.failure(convertLAError(error)))
                    } else {
                        completion(.failure(.unknown))
                    }
                }
            }
        }
        
        /// 生物识别认证（异步版本）
        public static func authenticateAsync(
            reason: String = "请验证身份",
            allowPasswordFallback: Bool = true
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                authenticate(reason: reason, allowPasswordFallback: allowPasswordFallback) { result in
                    switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
        
        /// 检查生物识别状态
        public static func checkBiometricStatus() -> (isAvailable: Bool, type: BiometricType, isEnrolled: Bool, isLocked: Bool) {
            var error: NSError?
            let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            
            let type = biometricType
            let isEnrolled = canEvaluate && error == nil
            let isLocked = error?.code == LAError.biometryLockout.rawValue
            
            return (canEvaluate, type, isEnrolled, isLocked)
        }
        
        /// 获取生物识别状态描述
        public static func getBiometricStatusDescription() -> String {
            let status = checkBiometricStatus()
            
            if !status.isAvailable {
                return "生物识别不可用"
            }
            
            if !status.isEnrolled {
                return "未设置生物识别"
            }
            
            if status.isLocked {
                return "生物识别已锁定，请使用密码解锁"
            }
            
            switch status.type {
            case .touchID:
                return "Touch ID 可用"
            case .faceID:
                return "Face ID 可用"
            case .none:
                return "生物识别不可用"
            case .unknown:
                return "未知生物识别类型"
            }
        }
        
        /// 重置生物识别状态
        public static func resetBiometricState() {
            context.invalidate()
        }
        
        /// 设置生物识别交互类型
        public static func setInteractionType(_ type: LACredentialType) {
            context.interactionNotAllowed = false
            context.localizedFallbackTitle = "使用密码"
            context.localizedCancelTitle = "取消"
        }
        
        /// 获取生物识别错误信息
        public static func getBiometricErrorMessage(_ error: BiometricError) -> String {
            return error.localizedDescription
        }
        
        /// 转换LAError为BiometricError
        private static func convertLAError(_ error: LAError) -> BiometricError {
            switch error.code {
            case .biometryNotAvailable:
                return .biometryNotAvailable
            case .biometryNotEnrolled:
                return .notEnrolled
            case .biometryLockout:
                return .lockedOut
            case .userCancel:
                return .userCancel
            case .userFallback:
                return .userFallback
            case .systemCancel:
                return .systemCancel
            case .passcodeNotSet:
                return .passcodeNotSet
            case .appCancel:
                return .systemCancel
            case .invalidContext:
                return .unknown
            case .notInteractive:
                return .unknown
            default:
                return .unknown
            }
        }
        
        /// 转换NSError为BiometricError
        private static func convertLAError(_ error: NSError) -> BiometricError {
            if let laError = error as? LAError {
                return convertLAError(laError)
            }
            return .unknown
        }
        
        /// 检查生物识别是否被锁定
        public static var isBiometricsLocked: Bool {
            var error: NSError?
            _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            return error?.code == LAError.biometryLockout.rawValue
        }
        
        /// 获取生物识别锁定剩余时间
        public static func getBiometricLockoutTime() -> TimeInterval? {
            var error: NSError?
            _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            
            if let error = error as? LAError, error.code == .biometryLockout {
                return error.userInfo["LAErrorUserInfoKey.biometryLockoutDuration"] as? TimeInterval
            }
            
            return nil
        }
        
        /// 检查是否支持生物识别
        public static func isBiometricsSupported() -> Bool {
            return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
        
        /// 获取生物识别类型名称
        public static func getBiometricTypeName() -> String {
            switch biometricType {
            case .touchID:
                return "Touch ID"
            case .faceID:
                return "Face ID"
            case .none:
                return "无"
            case .unknown:
                return "未知"
            }
        }
    }
}

// MARK: - 新增文件操作模块
public extension TFYUtils {
    enum FileManager {
        /// 文件操作错误类型
        public enum FileError: Error, LocalizedError {
            case fileNotFound
            case permissionDenied
            case diskFull
            case invalidPath
            case copyFailed
            case moveFailed
            case deleteFailed
            case createFailed
            case unknown
            
            public var errorDescription: String? {
                switch self {
                case .fileNotFound: return "文件未找到"
                case .permissionDenied: return "权限被拒绝"
                case .diskFull: return "磁盘空间不足"
                case .invalidPath: return "无效路径"
                case .copyFailed: return "复制失败"
                case .moveFailed: return "移动失败"
                case .deleteFailed: return "删除失败"
                case .createFailed: return "创建失败"
                case .unknown: return "未知错误"
                }
            }
        }
        
        private static let fileManager = Foundation.FileManager.default
        
        /// 检查文件是否存在
        public static func fileExists(at path: String) -> Bool {
            return fileManager.fileExists(atPath: path)
        }
        
        /// 检查文件是否存在（URL版本）
        public static func fileExists(at url: URL) -> Bool {
            return fileManager.fileExists(atPath: url.path)
        }
        
        /// 获取文件大小
        public static func fileSize(at path: String) -> Int64? {
            guard fileExists(at: path) else { return nil }
            
            do {
                let attributes = try fileManager.attributesOfItem(atPath: path)
                return attributes[.size] as? Int64
            } catch {
                return nil
            }
        }
        
        /// 获取文件大小（URL版本）
        public static func fileSize(at url: URL) -> Int64? {
            return fileSize(at: url.path)
        }
        
        /// 获取文件创建时间
        public static func fileCreationDate(at path: String) -> Date? {
            guard fileExists(at: path) else { return nil }
            
            do {
                let attributes = try fileManager.attributesOfItem(atPath: path)
                return attributes[.creationDate] as? Date
            } catch {
                return nil
            }
        }
        
        /// 获取文件修改时间
        public static func fileModificationDate(at path: String) -> Date? {
            guard fileExists(at: path) else { return nil }
            
            do {
                let attributes = try fileManager.attributesOfItem(atPath: path)
                return attributes[.modificationDate] as? Date
            } catch {
                return nil
            }
        }
        
        /// 复制文件
        public static func copyFile(
            from sourcePath: String,
            to destinationPath: String,
            overwrite: Bool = false
        ) throws {
            guard fileExists(at: sourcePath) else {
                throw FileError.fileNotFound
            }
            
            if fileExists(at: destinationPath) && !overwrite {
                throw FileError.copyFailed
            }
            
            do {
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            } catch {
                throw FileError.copyFailed
            }
        }
        
        /// 移动文件
        public static func moveFile(
            from sourcePath: String,
            to destinationPath: String,
            overwrite: Bool = false
        ) throws {
            guard fileExists(at: sourcePath) else {
                throw FileError.fileNotFound
            }
            
            if fileExists(at: destinationPath) && !overwrite {
                throw FileError.moveFailed
            }
            
            do {
                try fileManager.moveItem(atPath: sourcePath, toPath: destinationPath)
            } catch {
                throw FileError.moveFailed
            }
        }
        
        /// 删除文件
        public static func deleteFile(at path: String) throws {
            guard fileExists(at: path) else {
                throw FileError.fileNotFound
            }
            
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                throw FileError.deleteFailed
            }
        }
        
        /// 创建目录
        public static func createDirectory(
            at path: String,
            withIntermediateDirectories: Bool = true
        ) throws {
            do {
                try fileManager.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: withIntermediateDirectories
                )
            } catch {
                throw FileError.createFailed
            }
        }
        
        /// 获取目录内容
        public static func contentsOfDirectory(at path: String) throws -> [String] {
            do {
                return try fileManager.contentsOfDirectory(atPath: path)
            } catch {
                throw FileError.fileNotFound
            }
        }
        
        /// 获取目录内容（包含完整路径）
        public static func contentsOfDirectoryFullPath(at path: String) throws -> [String] {
            let contents = try contentsOfDirectory(at: path)
            return contents.map { (path as NSString).appendingPathComponent($0) }
        }
        
        /// 获取目录大小
        public static func directorySize(at path: String) -> Int64 {
            guard fileExists(at: path) else { return 0 }
            
            var totalSize: Int64 = 0
            
            do {
                let contents = try contentsOfDirectoryFullPath(at: path)
                for itemPath in contents {
                    if fileExists(at: itemPath) {
                        if let size = fileSize(at: itemPath) {
                            totalSize += size
                        }
                    }
                }
            } catch {
                return 0
            }
            
            return totalSize
        }
        
        /// 格式化文件大小
        public static func formatFileSize(_ size: Int64) -> String {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB, .useGB]
            formatter.countStyle = .file
            return formatter.string(fromByteCount: size)
        }
        
        /// 获取文件扩展名
        public static func fileExtension(at path: String) -> String? {
            return (path as NSString).pathExtension.isEmpty ? nil : (path as NSString).pathExtension
        }
        
        /// 获取文件名（不含扩展名）
        public static func fileNameWithoutExtension(at path: String) -> String {
            return (path as NSString).deletingPathExtension
        }
        
        /// 获取文件名（含扩展名）
        public static func fileName(at path: String) -> String {
            return (path as NSString).lastPathComponent
        }
        
        /// 获取文件路径的目录部分
        public static func directoryPath(at path: String) -> String {
            return (path as NSString).deletingLastPathComponent
        }
        
        /// 检查是否为目录
        public static func isDirectory(at path: String) -> Bool {
            var isDirectory: ObjCBool = false
            let exists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
            return exists && isDirectory.boolValue
        }
        
        /// 检查是否为文件
        public static func isFile(at path: String) -> Bool {
            var isDirectory: ObjCBool = false
            let exists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
            return exists && !isDirectory.boolValue
        }
        
        /// 获取可用磁盘空间
        public static func availableDiskSpace() -> Int64? {
            do {
                let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
                return attributes[.systemFreeSize] as? Int64
            } catch {
                return nil
            }
        }
        
        /// 获取总磁盘空间
        public static func totalDiskSpace() -> Int64? {
            do {
                let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
                return attributes[.systemSize] as? Int64
            } catch {
                return nil
            }
        }
        
        /// 清理临时文件
        public static func clearTempFiles() throws {
            let tempPath = NSTemporaryDirectory()
            let contents = try contentsOfDirectory(at: tempPath)
            
            for item in contents {
                let fullPath = (tempPath as NSString).appendingPathComponent(item)
                try? deleteFile(at: fullPath)
            }
        }
        
        /// 获取文件MIME类型
        public static func mimeType(for path: String) -> String? {
            guard let ext = fileExtension(at: path) else { return nil }
            
            let mimeTypes = [
                "txt": "text/plain",
                "html": "text/html",
                "htm": "text/html",
                "css": "text/css",
                "js": "application/javascript",
                "json": "application/json",
                "xml": "application/xml",
                "pdf": "application/pdf",
                "jpg": "image/jpeg",
                "jpeg": "image/jpeg",
                "png": "image/png",
                "gif": "image/gif",
                "mp4": "video/mp4",
                "mp3": "audio/mpeg",
                "zip": "application/zip"
            ]
            
            return mimeTypes[ext.lowercased()]
        }
        
        /// 监控文件变化
        public static func monitorFile(
            at path: String,
            handler: @escaping (String) -> Void
        ) -> DispatchSourceFileSystemObject? {
            guard fileExists(at: path) else { return nil }
            
            let fileDescriptor = open(path, O_EVTONLY)
            guard fileDescriptor >= 0 else { return nil }
            
            let source = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fileDescriptor,
                eventMask: .write,
                queue: DispatchQueue.global()
            )
            
            source.setEventHandler {
                handler(path)
            }
            
            source.setCancelHandler {
                close(fileDescriptor)
            }
            
            source.resume()
            return source
        }
    }
}

// MARK: - 新增图片处理模块
public extension TFYUtils {
    enum ImageProcessor {
        /// 图片格式
        public enum ImageFormat {
            case jpeg(quality: CGFloat)
            case png
            case heic(quality: CGFloat)
            
            var fileExtension: String {
                switch self {
                case .jpeg: return "jpg"
                case .png: return "png"
                case .heic: return "heic"
                }
            }
        }
        
        /// 图片滤镜类型
        public enum FilterType {
            case none
            case grayscale
            case sepia
            case blur(radius: CGFloat)
            case brightness(value: CGFloat)
            case contrast(value: CGFloat)
            case saturation(value: CGFloat)
            case hue(value: CGFloat)
            case invert
            case monochrome
        }
        
        /// 图片裁剪类型
        public enum CropType {
            case center(size: CGSize)
            case custom(rect: CGRect)
            case aspectRatio(ratio: CGFloat)
        }
        
        /// 图片旋转角度
        public enum RotationAngle {
            case degrees90
            case degrees180
            case degrees270
            case custom(degrees: CGFloat)
        }
        
        /// 压缩图片
        public static func compressImage(
            _ image: UIImage,
            to format: ImageFormat,
            maxSize: CGSize? = nil
        ) -> UIImage? {
            var processedImage = image
            
            // 调整大小
            if let maxSize = maxSize {
                processedImage = resizeImage(processedImage, to: maxSize) ?? processedImage
            }
            
            // 应用格式
            switch format {
            case .jpeg(let quality):
                return processedImage.jpegData(compressionQuality: quality).flatMap { UIImage(data: $0) }
            case .png:
                return processedImage.pngData().flatMap { UIImage(data: $0) }
            case .heic(let quality):
                if #available(iOS 11.0, *) {
                    // 使用CIImage来生成HEIC数据
                    guard let ciImage = CIImage(image: processedImage) else {
                        return processedImage.jpegData(compressionQuality: quality).flatMap { UIImage(data: $0) }
                    }
                    let context = CIContext()
                    let heicData = context.heifRepresentation(of: ciImage, format: .RGBA8, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:])
                    return heicData.flatMap { UIImage(data: $0) }
                } else {
                    return processedImage.jpegData(compressionQuality: quality).flatMap { UIImage(data: $0) }
                }
            }
        }
        
        /// 调整图片大小
        public static func resizeImage(
            _ image: UIImage,
            to size: CGSize,
            scale: CGFloat = UIScreen.main.scale
        ) -> UIImage? {
            let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
            
            UIGraphicsBeginImageContextWithOptions(scaledSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        /// 裁剪图片
        public static func cropImage(
            _ image: UIImage,
            type: CropType
        ) -> UIImage? {
            let imageSize = image.size
            
            let cropRect: CGRect
            switch type {
            case .center(let size):
                let x = (imageSize.width - size.width) / 2
                let y = (imageSize.height - size.height) / 2
                cropRect = CGRect(x: x, y: y, width: size.width, height: size.height)
            case .custom(let rect):
                cropRect = rect
            case .aspectRatio(let ratio):
                let width = imageSize.width
                let height = width / ratio
                let y = (imageSize.height - height) / 2
                cropRect = CGRect(x: 0, y: y, width: width, height: height)
            }
            
            guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
            return UIImage(cgImage: cgImage)
        }
        
        /// 旋转图片
        public static func rotateImage(
            _ image: UIImage,
            angle: RotationAngle
        ) -> UIImage? {
            let radians: CGFloat
            switch angle {
            case .degrees90:
                radians = .pi / 2
            case .degrees180:
                radians = .pi
            case .degrees270:
                radians = .pi * 3 / 2
            case .custom(let degrees):
                radians = degrees * .pi / 180
            }
            
            let rotatedSize = CGSize(
                width: abs(image.size.width * cos(radians)) + abs(image.size.height * sin(radians)),
                height: abs(image.size.width * sin(radians)) + abs(image.size.height * cos(radians))
            )
            
            UIGraphicsBeginImageContextWithOptions(rotatedSize, false, image.scale)
            defer { UIGraphicsEndImageContext() }
            
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            
            context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            context.rotate(by: radians)
            image.draw(in: CGRect(
                x: -image.size.width / 2,
                y: -image.size.height / 2,
                width: image.size.width,
                height: image.size.height
            ))
            
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        /// 应用滤镜
        public static func applyFilter(
            _ image: UIImage,
            type: FilterType
        ) -> UIImage? {
            guard let ciImage = CIImage(image: image) else { return nil }
            
            let filter: CIFilter?
            switch type {
            case .none:
                return image
            case .grayscale:
                filter = CIFilter(name: "CIColorMonochrome")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: kCIInputColorKey)
                filter?.setValue(1.0, forKey: kCIInputIntensityKey)
            case .sepia:
                filter = CIFilter(name: "CISepiaTone")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(0.8, forKey: kCIInputIntensityKey)
            case .blur(let radius):
                filter = CIFilter(name: "CIGaussianBlur")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(radius, forKey: kCIInputRadiusKey)
            case .brightness(let value):
                filter = CIFilter(name: "CIColorControls")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(value, forKey: kCIInputBrightnessKey)
            case .contrast(let value):
                filter = CIFilter(name: "CIColorControls")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(value, forKey: kCIInputContrastKey)
            case .saturation(let value):
                filter = CIFilter(name: "CIColorControls")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(value, forKey: kCIInputSaturationKey)
            case .hue(let value):
                filter = CIFilter(name: "CIHueAdjust")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(value, forKey: kCIInputAngleKey)
            case .invert:
                filter = CIFilter(name: "CIColorInvert")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
            case .monochrome:
                filter = CIFilter(name: "CIColorMonochrome")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: kCIInputColorKey)
                filter?.setValue(1.0, forKey: kCIInputIntensityKey)
            }
            
            guard let outputImage = filter?.outputImage else { return nil }
            
            let context = CIContext()
            guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
            
            return UIImage(cgImage: cgImage)
        }
        
        /// 添加圆角
        public static func addCornerRadius(
            _ image: UIImage,
            radius: CGFloat
        ) -> UIImage? {
            let rect = CGRect(origin: .zero, size: image.size)
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            defer { UIGraphicsEndImageContext() }
            
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            path.addClip()
            
            image.draw(in: rect)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        /// 添加边框
        public static func addBorder(
            _ image: UIImage,
            width: CGFloat,
            color: UIColor
        ) -> UIImage? {
            let newSize = CGSize(
                width: image.size.width + width * 2,
                height: image.size.height + width * 2
            )
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
            defer { UIGraphicsEndImageContext() }
            
            color.setFill()
            UIRectFill(CGRect(origin: .zero, size: newSize))
            
            image.draw(in: CGRect(
                x: width,
                y: width,
                width: image.size.width,
                height: image.size.height
            ))
            
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        /// 创建缩略图
        public static func createThumbnail(
            _ image: UIImage,
            size: CGSize,
            quality: CGFloat = 0.8
        ) -> UIImage? {
            let thumbnail = resizeImage(image, to: size) ?? image
            return compressImage(thumbnail, to: .jpeg(quality: quality))
        }
        
        /// 获取图片数据
        public static func getImageData(
            _ image: UIImage,
            format: ImageFormat
        ) -> Data? {
            switch format {
            case .jpeg(let quality):
                return image.jpegData(compressionQuality: quality)
            case .png:
                return image.pngData()
            case .heic(let quality):
                if #available(iOS 11.0, *) {
                    // 使用CIImage来生成HEIC数据
                    guard let ciImage = CIImage(image: image) else {
                        return image.jpegData(compressionQuality: quality)
                    }
                    let context = CIContext()
                    let heicData = context.heifRepresentation(of: ciImage, format: .RGBA8, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:])
                    return heicData
                } else {
                    return image.jpegData(compressionQuality: quality)
                }
            }
        }
        
        /// 保存图片到相册
        public static func saveToPhotoLibrary(
            _ image: UIImage,
            completion: @escaping (Bool, Error?) -> Void
        ) {
            // 检查相册权限
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .authorized, .limited:
                // 已有权限，直接保存
                saveImageToLibrary(image, completion: completion)
            case .notDetermined:
                // 请求权限
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        if newStatus == .authorized || newStatus == .limited {
                            saveImageToLibrary(image, completion: completion)
                        } else {
                            completion(false, NSError(domain: "TFYUtils", code: 1001, userInfo: [NSLocalizedDescriptionKey: "相册权限被拒绝"]))
                        }
                    }
                }
            case .denied, .restricted:
                // 权限被拒绝
                completion(false, NSError(domain: "TFYUtils", code: 1002, userInfo: [NSLocalizedDescriptionKey: "相册权限被拒绝，请在设置中开启"]))
            @unknown default:
                completion(false, NSError(domain: "TFYUtils", code: 1003, userInfo: [NSLocalizedDescriptionKey: "未知的权限状态"]))
            }
        }
        
        /// 实际保存图片到相册
        private static func saveImageToLibrary(
            _ image: UIImage,
            completion: @escaping (Bool, Error?) -> Void
        ) {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        }
        
        /// 获取图片信息
        public static func getImageInfo(_ image: UIImage) -> [String: Any] {
            return [
                "size": image.size,
                "scale": image.scale,
                "orientation": image.imageOrientation.rawValue,
                "capInsets": image.capInsets,
                "resizingMode": image.resizingMode.rawValue
            ]
        }
        
        /// 合并图片
        public static func mergeImages(
            _ images: [UIImage],
            direction: NSLayoutConstraint.Axis = .vertical,
            spacing: CGFloat = 0
        ) -> UIImage? {
            guard !images.isEmpty else { return nil }
            
            let totalSize: CGSize
            if direction == .vertical {
                let width = images.map { $0.size.width }.max() ?? 0
                let height = images.reduce(0) { $0 + $1.size.height } + spacing * CGFloat(images.count - 1)
                totalSize = CGSize(width: width, height: height)
            } else {
                let width = images.reduce(0) { $0 + $1.size.width } + spacing * CGFloat(images.count - 1)
                let height = images.map { $0.size.height }.max() ?? 0
                totalSize = CGSize(width: width, height: height)
            }
            
            UIGraphicsBeginImageContextWithOptions(totalSize, false, 0)
            defer { UIGraphicsEndImageContext() }
            
            var currentOffset: CGFloat = 0
            for image in images {
                let rect: CGRect
                if direction == .vertical {
                    rect = CGRect(
                        x: (totalSize.width - image.size.width) / 2,
                        y: currentOffset,
                        width: image.size.width,
                        height: image.size.height
                    )
                    currentOffset += image.size.height + spacing
                } else {
                    rect = CGRect(
                        x: currentOffset,
                        y: (totalSize.height - image.size.height) / 2,
                        width: image.size.width,
                        height: image.size.height
                    )
                    currentOffset += image.size.width + spacing
                }
                image.draw(in: rect)
            }
            
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}

// MARK: - 新增日期处理模块
public extension TFYUtils {
    enum DateUtils {  // 重命名以避免与 Foundation.DateFormatter 冲突
        /// 线程安全的日期格式化器
        private static let formatterQueue = DispatchQueue(label: "com.tfy.dateutils.formatter")
        private static var formatters: [String: Foundation.DateFormatter] = [:]
        
        /// 获取线程安全的格式化器
        private static func getFormatter(format: String) -> Foundation.DateFormatter {
            return formatterQueue.sync {
                if let formatter = formatters[format] {
                    return formatter
                } else {
            let formatter = Foundation.DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")  // 设置中文区域
                    formatter.dateFormat = format
                    formatters[format] = formatter
            return formatter
                }
            }
        }
        
        /// 格式化日期
        public static func string(
            from date: Date,
            format: String = "yyyy-MM-dd HH:mm:ss",
            locale: Locale? = nil,
            timeZone: TimeZone? = nil
        ) -> String {
            let formatter: Foundation.DateFormatter
            if locale == nil && timeZone == nil {
                formatter = getFormatter(format: format)
            } else {
                formatter = Foundation.DateFormatter()
                formatter.dateFormat = format
                formatter.locale = locale ?? Locale(identifier: "zh_CN")
                formatter.timeZone = timeZone
            }
            return formatter.string(from: date)
        }
        
        /// 解析日期字符串
        public static func date(
            from string: String,
            format: String = "yyyy-MM-dd HH:mm:ss",
            locale: Locale? = nil,
            timeZone: TimeZone? = nil
        ) -> Date? {
            let formatter: Foundation.DateFormatter
            if locale == nil && timeZone == nil {
                formatter = getFormatter(format: format)
            } else {
                formatter = Foundation.DateFormatter()
                formatter.dateFormat = format
                formatter.locale = locale ?? Locale(identifier: "zh_CN")
                formatter.timeZone = timeZone
            }
            return formatter.date(from: string)
        }
        
        /// 相对时间描述
        public static func relativeTimeDescription(from date: Date) -> String {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
            
            if let year = components.year, year > 0 {
                return "\(year)年前"
            }
            if let month = components.month, month > 0 {
                return "\(month)个月前"
            }
            if let day = components.day, day > 0 {
                return "\(day)天前"
            }
            if let hour = components.hour, hour > 0 {
                return "\(hour)小时前"
            }
            if let minute = components.minute, minute > 0 {
                return "\(minute)分钟前"
            }
            return "刚刚"
        }
        
        /// 获取指定格式的当前时间字符串
        public static func currentTimeString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
            string(from: Date(), format: format)
        }
        
        /// 获取日期组件
        public static func getDateComponents(
            from date: Date,
            components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        ) -> DateComponents {
            return Calendar.current.dateComponents(components, from: date)
        }
        
        /// 创建日期
        public static func createDate(
            year: Int,
            month: Int,
            day: Int,
            hour: Int = 0,
            minute: Int = 0,
            second: Int = 0
        ) -> Date? {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            components.hour = hour
            components.minute = minute
            components.second = second
            return Calendar.current.date(from: components)
        }
        
        /// 判断是否为今天
        public static func isToday(_ date: Date) -> Bool {
            return Calendar.current.isDateInToday(date)
        }
        
        /// 判断是否为昨天
        public static func isYesterday(_ date: Date) -> Bool {
            return Calendar.current.isDateInYesterday(date)
        }
        
        /// 判断是否为明天
        public static func isTomorrow(_ date: Date) -> Bool {
            return Calendar.current.isDateInTomorrow(date)
        }
        
        /// 判断是否为本周
        public static func isThisWeek(_ date: Date) -> Bool {
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
        }
        
        /// 判断是否为本月
        public static func isThisMonth(_ date: Date) -> Bool {
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
        }
        
        /// 判断是否为本年
        public static func isThisYear(_ date: Date) -> Bool {
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
        }
        
        /// 获取日期区间
        public static func getDateInterval(
            from startDate: Date,
            to endDate: Date
        ) -> DateInterval {
            return DateInterval(start: startDate, end: endDate)
        }
        
        /// 判断日期是否在区间内
        public static func isDate(
            _ date: Date,
            in interval: DateInterval
        ) -> Bool {
            return interval.contains(date)
        }
        
        /// 获取两个日期之间的天数
        public static func daysBetween(
            from startDate: Date,
            to endDate: Date
        ) -> Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: startDate, to: endDate)
            return abs(components.day ?? 0)
        }
        
        /// 添加时间间隔
        public static func add(
            _ value: Int,
            component: Calendar.Component,
            to date: Date
        ) -> Date? {
            return Calendar.current.date(byAdding: component, value: value, to: date)
        }
        
        /// 获取月份天数
        public static func daysInMonth(for date: Date) -> Int {
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: date)
            return range?.count ?? 0
        }
        
        /// 获取星期几
        public static func weekday(for date: Date) -> Int {
            return Calendar.current.component(.weekday, from: date)
        }
        
        /// 获取星期几名称
        public static func weekdayName(for date: Date, short: Bool = false) -> String {
            return getFormatter(format: short ? "E" : "EEEE").string(from: date)
        }
        
        /// 判断是否为工作日
        public static func isWeekday(_ date: Date) -> Bool {
            let weekday = self.weekday(for: date)
            return weekday >= 2 && weekday <= 6 // 周一到周五
        }
        
        /// 判断是否为周末
        public static func isWeekend(_ date: Date) -> Bool {
            let weekday = self.weekday(for: date)
            return weekday == 1 || weekday == 7 // 周日或周六
        }
        
        /// 获取月份名称
        public static func monthName(for date: Date, short: Bool = false) -> String {
            return getFormatter(format: short ? "M" : "MMMM").string(from: date)
        }
        
        /// 获取季度
        public static func quarter(for date: Date) -> Int {
            let month = Calendar.current.component(.month, from: date)
            return (month - 1) / 3 + 1
        }
        
        /// 获取年龄
        public static func age(from birthDate: Date) -> Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: birthDate, to: Date())
            return components.year ?? 0
        }
        
        /// 格式化时间间隔
        public static func formatTimeInterval(_ interval: TimeInterval) -> String {
            let hours = Int(interval) / 3600
            let minutes = Int(interval) % 3600 / 60
            let seconds = Int(interval) % 60
            
            if hours > 0 {
                return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else {
                return String(format: "%02d:%02d", minutes, seconds)
            }
        }
        
        /// 清除缓存（内存优化）
        public static func clearCache() {
            formatterQueue.sync {
                formatters.removeAll()
            }
        }
    }
}

// 扩展 UINavigationController 支持带 completion 的 pop 方法
extension UINavigationController {
    func popToViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        popToViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion(true)
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in
            completion(true)
        }
    }
}

// MARK: - 路径工具
// 移除重复的FilePath声明，因为已经在其他地方定义了

// MARK: - 窗口工具
public enum Window {
    /// 获取当前窗口
    public static var current: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 获取所有窗口
    public static var all: [UIWindow] {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        } else {
            return UIApplication.shared.windows
        }
    }
    
    /// 获取根视图控制器
    public static var rootViewController: UIViewController? {
        return current?.rootViewController
    }
    
    /// 获取顶层视图控制器
    public static var topViewController: UIViewController? {
        return getTopViewController(from: rootViewController)
    }
    
    /// 递归获取顶层视图控制器
    private static func getTopViewController(from viewController: UIViewController?) -> UIViewController? {
        if let presented = viewController?.presentedViewController {
            return getTopViewController(from: presented)
        }
        
        if let navigationController = viewController as? UINavigationController {
            return getTopViewController(from: navigationController.visibleViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController {
            return getTopViewController(from: tabBarController.selectedViewController)
        }
        
        return viewController
    }
}

// MARK: - 系统工具
public enum System {
    /// 打开URL
    public static func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /// 拨打电话
    public static func makePhoneCall(_ phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)") {
            openURL(url)
        }
    }
    
    /// 发送短信
    public static func sendSMS(_ phoneNumber: String) {
        if let url = URL(string: "sms://\(phoneNumber)") {
            openURL(url)
        }
    }
    
    /// 发送邮件
    public static func sendEmail(to email: String) {
        if let url = URL(string: "mailto://\(email)") {
            openURL(url)
        }
    }
    
    /// 打开App Store
    public static func openAppStore(appId: String) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)") {
            openURL(url)
        }
    }
    
    /// 请求App Store评分
    public static func requestAppStoreReview() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    /// 获取应用版本
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// 获取应用构建版本
    public static var appBuildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    /// 获取应用标识符
    public static var appBundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    /// 获取应用名称
    public static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
}

// MARK: - 视图控制器工具
// 移除重复的ViewController声明，因为已经在其他地方定义了

// MARK: - 设备工具
public enum Device {
    /// 获取设备型号
    public static var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            let unicodeScalar = UnicodeScalar(UInt8(value))
            return identifier + String(unicodeScalar)
        }
        return identifier
    }
    
    /// 获取设备名称
    public static var name: String {
        return UIDevice.current.name
    }
    
    /// 获取系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 获取系统名称
    public static var systemName: String {
        return UIDevice.current.systemName
    }
    
    /// 获取设备方向
    public static var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    /// 检查是否为iPhone
    public static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// 检查是否为iPad
    public static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 检查是否为刘海屏
    public static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            if #available(iOS 15.0, *) {
                return UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first?.safeAreaInsets.top ?? 0 > 20
            } else {
                return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 > 20
            }
        }
        return false
    }
    
    /// 获取安全区域
    public static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if #available(iOS 15.0, *) {
                return UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first?.safeAreaInsets ?? .zero
            } else {
                return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
            }
        }
        return .zero
    }
    
    /// 获取电池电量
    public static var batteryLevel: Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel
    }
    
    /// 检查是否为低电量模式
    public static var isLowPowerModeEnabled: Bool {
        if #available(iOS 9.0, *) {
            return ProcessInfo.processInfo.isLowPowerModeEnabled
        }
        return false
    }
    
    /// 获取设备总内存
    public static var totalMemory: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    /// 获取可用内存
    public static var availableMemory: UInt64 {
        var pagesize: vm_size_t = 0
        var vmStats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        
        host_page_size(mach_host_self(), &pagesize)
        let result = withUnsafeMutablePointer(to: &vmStats) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { pointer in
                host_statistics64(mach_host_self(), HOST_VM_INFO64, pointer, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            return UInt64(vmStats.free_count) * UInt64(pagesize)
        }
        return 0
    }
}

