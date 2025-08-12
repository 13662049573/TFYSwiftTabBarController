//
//  TFYNetstatManager.swift
//  SocialItem
//
//  Created by 田风有 on 2024/4/16.
//  用途：网络状态检测工具，支持 WiFi/蜂窝/无网络等类型判断。
//

import UIKit
import CoreTelephony
import SystemConfiguration

public class TFYNetstatManager {
    
    // MARK: - 网络类型枚举
    public enum NetworkType: String {
        case wifi = "WiFi"
        case cellular5G = "5G"
        case cellular4G = "4G"
        case cellular3G = "3G"
        case cellular2G = "2G"
        case notReachable = "notReachable"
    }
    
    // MARK: - 单例
    public static let shared = TFYNetstatManager()
    private init() {}
    
    // MARK: - 私有属性
    private let reachability: SCNetworkReachability? = {
        var zeroAddress = sockaddr_storage()
        bzero(&zeroAddress, MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_len = __uint8_t(MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }
    }()
    
    private let cellularInfo = CTTelephonyNetworkInfo()
    
    /// 网络状态变化回调
    public typealias NetworkStatusCallback = (NetworkType) -> Void
    
    /// 网络状态变化监听器
    private var statusCallbacks: [NetworkStatusCallback] = []
    
    /// 当前网络类型
    private var currentNetworkType: NetworkType = .notReachable
    
    /// 网络状态监听定时器
    private var statusTimer: Timer?
}

// MARK: - 公共方法
public extension TFYNetstatManager {
    /// 获取当前网络类型
    func getCurrentNetworkType() -> NetworkType {
        guard let reachability = reachability else {
            return .notReachable
        }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(reachability, &flags),
              flags.contains(.reachable),
              !flags.contains(.connectionRequired) else {
            return .notReachable
        }
        
        if flags.contains(.isWWAN) {
            return getCellularType()
        } else {
            return .wifi
        }
    }
    
    /// 检查是否有网络连接
    var isConnected: Bool {
        return getCurrentNetworkType() != .notReachable
    }
    
    /// 检查是否是WiFi连接
    var isWiFi: Bool {
        return getCurrentNetworkType() == .wifi
    }
    
    /// 检查是否是蜂窝网络连接
    var isCellular: Bool {
        let type = getCurrentNetworkType()
        return type == .cellular5G || type == .cellular4G || 
               type == .cellular3G || type == .cellular2G
    }
    
    /// 获取网络连接质量
    var connectionQuality: ConnectionQuality {
        let type = getCurrentNetworkType()
        switch type {
        case .wifi:
            return .excellent
        case .cellular5G:
            return .excellent
        case .cellular4G:
            return .good
        case .cellular3G:
            return .fair
        case .cellular2G:
            return .poor
        case .notReachable:
            return .none
        }
    }
    
    /// 添加网络状态变化监听
    func addNetworkStatusObserver(_ callback: @escaping NetworkStatusCallback) {
        statusCallbacks.append(callback)
        startMonitoring()
    }
    
    /// 移除网络状态变化监听
    func removeNetworkStatusObserver(_ callback: @escaping NetworkStatusCallback) {
        statusCallbacks.removeAll { $0 as AnyObject === callback as AnyObject }
        if statusCallbacks.isEmpty {
            stopMonitoring()
        }
    }
    
    /// 开始监听网络状态变化
    func startMonitoring() {
        guard statusTimer == nil else { return }
        
        // 初始检查
        currentNetworkType = getCurrentNetworkType()
        
        // 设置定时器监听
        statusTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkNetworkStatusChange()
        }
    }
    
    /// 停止监听网络状态变化
    func stopMonitoring() {
        statusTimer?.invalidate()
        statusTimer = nil
    }
    
    /// 检查网络状态变化
    private func checkNetworkStatusChange() {
        let newType = getCurrentNetworkType()
        if newType != currentNetworkType {
            currentNetworkType = newType
            notifyNetworkStatusChange(newType)
        }
    }
    
    /// 通知网络状态变化
    private func notifyNetworkStatusChange(_ type: NetworkType) {
        DispatchQueue.main.async { [weak self] in
            self?.statusCallbacks.forEach { callback in
                callback(type)
            }
        }
    }
    
    /// 获取网络速度估算
    func getEstimatedSpeed() -> NetworkSpeed {
        let type = getCurrentNetworkType()
        switch type {
        case .wifi:
            return .fast // 通常 50-1000 Mbps
        case .cellular5G:
            return .veryFast // 通常 100-1000+ Mbps
        case .cellular4G:
            return .fast // 通常 10-100 Mbps
        case .cellular3G:
            return .medium // 通常 1-10 Mbps
        case .cellular2G:
            return .slow // 通常 < 1 Mbps
        case .notReachable:
            return .none
        }
    }
}

// MARK: - 网络质量枚举
public extension TFYNetstatManager {
    enum ConnectionQuality: String, CaseIterable {
        case excellent = "优秀"
        case good = "良好"
        case fair = "一般"
        case poor = "较差"
        case none = "无连接"
    }
    
    enum NetworkSpeed: String, CaseIterable {
        case veryFast = "极快"
        case fast = "快速"
        case medium = "中等"
        case slow = "缓慢"
        case none = "无连接"
    }
}

// MARK: - 私有方法
private extension TFYNetstatManager {
    /// 获取蜂窝网络类型
    func getCellularType() -> NetworkType {
        let radioTechnology: String? = {
            if #available(iOS 12.0, *) {
                return cellularInfo.serviceCurrentRadioAccessTechnology?.values.first
            } else {
                return cellularInfo.currentRadioAccessTechnology
            }
        }()
        
        guard let technology = radioTechnology else {
            return .notReachable
        }
        
        if #available(iOS 14.1, *) {
            if technology == CTRadioAccessTechnologyNR || 
               technology == CTRadioAccessTechnologyNRNSA {
                return .cellular5G
            }
        }
        
        switch technology {
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            return .cellular2G
            
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyeHRPD,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB:
            return .cellular3G
            
        case CTRadioAccessTechnologyLTE:
            return .cellular4G
            
        default:
            print("TFYNetstatManager: 未知蜂窝网络类型\(technology)")
            return .notReachable
        }
    }
}

// MARK: - TFYNetstatManager 用法示例
/*
// 1. 基本网络状态检测
let networkManager = TFYNetstatManager.shared
let currentType = networkManager.getCurrentNetworkType()
print("当前网络类型: \(currentType.rawValue)")

// 检查网络连接状态
if networkManager.isConnected {
    print("网络已连接")
    if networkManager.isWiFi {
        print("当前使用WiFi网络")
    } else if networkManager.isCellular {
        print("当前使用蜂窝网络")
    }
} else {
    print("网络未连接")
}

// 2. 网络质量评估
let quality = networkManager.connectionQuality
print("网络连接质量: \(quality.rawValue)")

let speed = networkManager.getEstimatedSpeed()
print("网络速度估算: \(speed.rawValue)")

// 3. 网络状态变化监听
class NetworkMonitor {
    private var observer: ((TFYNetstatManager.NetworkType) -> Void)?
    
    func startMonitoring() {
        observer = { [weak self] networkType in
            self?.handleNetworkChange(networkType)
        }
        TFYNetstatManager.shared.addNetworkStatusObserver(observer!)
    }
    
    func stopMonitoring() {
        if let observer = observer {
            TFYNetstatManager.shared.removeNetworkStatusObserver(observer)
            self.observer = nil
        }
    }
    
    private func handleNetworkChange(_ type: TFYNetstatManager.NetworkType) {
        switch type {
        case .wifi:
            print("网络切换到WiFi")
        case .cellular5G:
            print("网络切换到5G")
        case .cellular4G:
            print("网络切换到4G")
        case .cellular3G:
            print("网络切换到3G")
        case .cellular2G:
            print("网络切换到2G")
        case .notReachable:
            print("网络断开")
        }
    }
}

// 4. 实际应用场景
class NetworkAwareViewController: UIViewController {
    private let networkMonitor = NetworkMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkMonitoring()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkMonitor.startMonitoring()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkMonitor.stopMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        // 根据网络状态调整UI
        updateUIForNetworkStatus(TFYNetstatManager.shared.getCurrentNetworkType())
    }
    
    private func updateUIForNetworkStatus(_ type: TFYNetstatManager.NetworkType) {
        switch type {
        case .wifi:
            // 显示WiFi图标，允许大文件下载
            showWiFiIndicator()
            enableLargeFileDownload()
        case .cellular5G, .cellular4G:
            // 显示4G/5G图标，允许中等文件下载
            showCellularIndicator()
            enableMediumFileDownload()
        case .cellular3G:
            // 显示3G图标，限制文件大小
            showCellularIndicator()
            limitFileDownloadSize()
        case .cellular2G:
            // 显示2G图标，禁用下载
            showCellularIndicator()
            disableFileDownload()
        case .notReachable:
            // 显示无网络图标
            showNoNetworkIndicator()
            disableAllDownloads()
        }
    }
    
    // UI更新方法（示例）
    private func showWiFiIndicator() { /* 显示WiFi图标 */ }
    private func showCellularIndicator() { /* 显示蜂窝图标 */ }
    private func showNoNetworkIndicator() { /* 显示无网络图标 */ }
    private func enableLargeFileDownload() { /* 允许大文件下载 */ }
    private func enableMediumFileDownload() { /* 允许中等文件下载 */ }
    private func limitFileDownloadSize() { /* 限制文件大小 */ }
    private func disableFileDownload() { /* 禁用文件下载 */ }
    private func disableAllDownloads() { /* 禁用所有下载 */ }
}

// 5. 网络质量监控
class NetworkQualityMonitor {
    func monitorNetworkQuality() {
        let manager = TFYNetstatManager.shared
        
        // 定期检查网络质量
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            let quality = manager.connectionQuality
            let speed = manager.getEstimatedSpeed()
            
            switch (quality, speed) {
            case (.excellent, .veryFast), (.excellent, .fast):
                print("网络质量优秀，适合高清视频播放")
            case (.good, .fast), (.good, .medium):
                print("网络质量良好，适合普通视频播放")
            case (.fair, .medium):
                print("网络质量一般，适合图片浏览")
            case (.poor, .slow):
                print("网络质量较差，建议等待网络改善")
            case (.none, .none):
                print("无网络连接")
            default:
                print("网络状态异常")
            }
        }
    }
}
*/
