//
//  UIDevice+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit
import CoreTelephony

// MARK: - 二、设备的基本信息

public extension TFY where Base: UIDevice {
    
    // MARK: 2.1、当前设备的系统版本
    /// 当前设备的系统版本
    static var currentSystemVersion : String {
        get {
            return Base.current.systemVersion
        }
    }
    
    // MARK: 1.10、当前设备是不是模拟器
    /// 当前设备是不是模拟器
    static func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
    
    // MARK: 2.2、当前系统更新时间
    /// 当前系统更新时间
    static var systemUptime: Date {
        let time = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: 0 - time)
    }
    
    // MARK: 2.3、当前设备的类型，如 iPhone、iPad 等等
    /// 当前设备的类型
    static var deviceType: String {
        return UIDevice.current.model
    }
    
    // MARK: 2.4、当前系统的名称
    /// 当前系统的名称
    static var currentSystemName : String {
        get {
            return UIDevice.current.systemName
        }
    }
    
    // MARK: 2.5、当前设备的名称
    /// 当前设备的名称
    static var currentDeviceName : String {
        get {
            return UIDevice.current.name
        }
    }
    
    // MARK: 2.6、当前设备是否越狱
    /// 当前设备是否越狱
    static var isJailbroken: Bool {
        if self.isSimulator() { return false }
        let paths = ["/Applications/Cydia.app", "/private/var/lib/apt/",
                     "/private/var/lib/cydia", "/private/var/stash"]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }
        let path = String(format: "/private/%@", String.tfy.stringWithUUID() ?? "")
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            NSLog(error.localizedDescription)
        }
        return false
    }
    
    // MARK: 2.7、当前硬盘的空间
    /// 当前硬盘的空间
    static var diskSpace: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }
    
    // MARK: 2.8、当前硬盘可用空间
    /// 当前硬盘可用空间
    static var diskSpaceFree: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemFreeSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }
    
    // MARK: 2.9、当前硬盘已经使用的空间
    /// 当前硬盘已经使用的空间
    static var diskSpaceUsed: Int64 {
        let total = self.diskSpace
        let free = self.diskSpaceFree
        guard total > 0 && free > 0 else { return -1 }
        let used = total - free
        guard used > 0 else { return -1 }
        
        return used
    }
    
    // MARK: 2.10、获取总内存大小
    /// 获取总内存大小
    static var memoryTotal: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    // MARK: 2.11、当前设备能否打电话
    /// 当前设备能否打电话
    /// - Returns: 结果
    static func isCanCallTel() -> Bool {
        if let url = URL(string: "tel://") {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    //MARK: 2.12、当前设备语言
    /// 当前设备语言
    static var deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    //MARK: 2.13、设备区域化型号
    /// 设备区域化型号
    static var localizedModel: String {
        return UIDevice.current.localizedModel
    }
}

// MARK: - 三、有关设备运营商的信息
public extension TFY where Base: UIDevice {
    
    // MARK: 3.1、sim卡信息
    static func simCardInfos() -> [CTCarrier]? {
        return getCarriers()
    }
    
    // MARK: 3.2、数据业务对应的通信技术
    /// 数据业务对应的通信技术
    /// - Returns: 通信技术
    static func currentRadioAccessTechnologys() -> [String]? {
        guard !isSimulator() else {
            return nil
        }
        // 获取并输出运营商信息
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let currentRadioTechs = info.serviceCurrentRadioAccessTechnology else {
                return nil
            }
            return currentRadioTechs.allValues()
        } else {
            guard let currentRadioTech = info.currentRadioAccessTechnology else {
                return nil
            }
            return [currentRadioTech]
        }
    }
    
    // MARK: 3.3、设备网络制式
    /// 设备网络制式
    /// - Returns: 网络
    static func networkTypes() -> [String]? {
        // 获取并输出运营商信息
        guard let currentRadioTechs = currentRadioAccessTechnologys() else {
            return nil
        }
        return currentRadioTechs.compactMap { getNetworkType(currentRadioTech: $0) }
    }
    
    // MARK: 3.4、运营商名字
    /// 运营商名字
    /// - Returns: 运营商名字
    static func carrierNames() -> [String]? {
        // 获取并输出运营商信息
        guard  let carriers = getCarriers(), carriers.count > 0 else {
            return nil
        }
        return carriers.map{ $0.carrierName!}
    }
    
    // MARK: 3.5、移动国家码(MCC)
    /// 移动国家码(MCC)
    /// - Returns: 移动国家码(MCC)
    static func mobileCountryCodes() -> [String]? {
        // 获取并输出运营商信息
        guard  let carriers = getCarriers(), carriers.count > 0 else {
            return nil
        }
        return carriers.map{ $0.mobileCountryCode!}
    }
    
    // MARK: 3.6、移动网络码(MNC)
    /// 移动网络码(MNC)
    /// - Returns: 移动网络码(MNC)
    static func mobileNetworkCodes() -> [String]? {
        // 获取并输出运营商信息
        guard  let carriers = getCarriers(), carriers.count > 0 else {
            return nil
        }
        return carriers.map{ $0.mobileNetworkCode!}
    }
    
    // MARK: 3.7、ISO国家代码
    /// ISO国家代码
    /// - Returns: ISO国家代码
    static func isoCountryCodes() -> [String]? {
        // 获取并输出运营商信息
        guard  let carriers = getCarriers(), carriers.count > 0 else {
            return nil
        }
        return carriers.map{ $0.isoCountryCode!}
    }
    
    // MARK: 3.8、是否允许VoIP
    /// 是否允许VoIP
    /// - Returns: 是否允许VoIP
    static func isAllowsVOIPs() -> [Bool]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), carriers.count > 0 else {
            return nil
        }
        return carriers.map{ $0.allowsVOIP}
    }
    
    /// 获取并输出运营商信息
    /// - Returns: 运营商信息
    private static func getCarriers() -> [CTCarrier]? {
        guard !isSimulator() else {
            return nil
        }
        // 获取并输出运营商信息
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let providers = info.serviceSubscriberCellularProviders else {
                return []
            }
            return providers.filter { $0.value.carrierName != nil }.allValues()
        } else {
            guard let carrier = info.subscriberCellularProvider, carrier.carrierName != nil else {
                return []
            }
            return [carrier]
        }
    }
    
    /// 根据数据业务信息获取对应的网络类型
    /// - Parameter currentRadioTech: 当前的无线电接入技术信息
    /// - Returns: 网络类型
    private static func getNetworkType(currentRadioTech: String) -> String {
        /**
         手机的数据业务对应的通信技术
         CTRadioAccessTechnologyGPRS：2G（有时又叫2.5G，介于2G和3G之间的过度技术）
         CTRadioAccessTechnologyEdge：2G （有时又叫2.75G，是GPRS到第三代移动通信的过渡)
         CTRadioAccessTechnologyWCDMA：3G
         CTRadioAccessTechnologyHSDPA：3G (有时又叫 3.5G)
         CTRadioAccessTechnologyHSUPA：3G (有时又叫 3.75G)
         CTRadioAccessTechnologyCDMA1x ：2G
         CTRadioAccessTechnologyCDMAEVDORev0：3G
         CTRadioAccessTechnologyCDMAEVDORevA：3G
         CTRadioAccessTechnologyCDMAEVDORevB：3G
         CTRadioAccessTechnologyeHRPD：3G (有时又叫 3.75G，是电信使用的一种3G到4G的演进技术)
         CTRadioAccessTechnologyLTE：4G (或者说接近4G)
         // 5G：NR是New Radio的缩写，新无线(5G)的意思，NRNSA表示5G NR的非独立组网（NSA）模式。
         CTRadioAccessTechnologyNRNSA：5G NSA
         CTRadioAccessTechnologyNR：5G
         */
        if #available(iOS 14.1, *), currentRadioTech == CTRadioAccessTechnologyNRNSA || currentRadioTech == CTRadioAccessTechnologyNR {
            return "5G"
        }
    
        var networkType = ""
        switch currentRadioTech {
        case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
            networkType = "2G"
        case CTRadioAccessTechnologyeHRPD, CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyHSUPA:
            networkType = "3G"
        case CTRadioAccessTechnologyLTE:
            networkType = "4G"
        default:
            break
        }
        return networkType
    }
}

