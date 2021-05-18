//
//  device+ITools.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/4/28.
//

import Foundation
import UIKit

public struct TFYDevice {
    
    public let description: String
    public let identifiers: [String]
    public init(identifiers: [String], description: String) {
        self.description = description
        self.identifiers = identifiers
    }
}


public enum TFYDeviceType {
    // iPhone
    case iPhone_12_Pro_Max
    case iPhone_12_Pro
    case iPhone_12
    case iPhone_12_mini
    case iPhone_SE_2nd_generation
    case iPhone_XS_Max
    case iPhone_XS
    case iPhone_XR
    case iPhone_X
    case iPhone_11
    case iPhone_11_Pro
    case iPhone_11_Pro_Max
    case iPhone_8_Plus
    case iPhone_8
    case iPhone_7_Plus
    case iPhone_7
    case iPhone_SE_1st_generation
    case iPhone_6s_Plus
    case iPhone_6s
    case iPhone_6_Plus
    case iPhone_6
    case iPhone_5s
    case iPhone_5c
    case iPhone_5
    case iPhone_4s
    case iPhone_4
    case iPhone_3GS
    case iPhone_3G
    case iPhone
    // iPod touch
    case iPod_touch_7th_generation
    case iPod_touch_6th_generation
    case iPod_touch_5th_generation
    case iPod_touch_4th_generation
    case iPod_touch_3rd_generation
    case iPod_touch_2nd_generation
    case iPod_touch
    // iPad
    case iPad
    case iPad_2
    case iPad_3rd_generation
    case iPad_4th_generation
    case iPad_5th_generation
    case iPad_6th_generation
    case iPad_7th_generation
    case iPad_8th_generation
    // iPad Air
    case iPad_Air
    case iPad_Air_2
    case iPad_Air_3rd_generation
    case iPad_Air_4th_generation
    // iPad Pro
    case iPad_Pro_9_7_inch
    case iPad_Pro_10_5_inch
    case iPad_Pro_11_inch
    case iPad_Pro_11_inch_2nd_generation
    case iPad_Pro_12_9_inch
    case iPad_Pro_12_9_inch_2nd_generation
    case iPad_Pro_12_9_inch_3rd_generation
    case iPad_Pro_12_9_inch_4th_generation
    // iPad mini
    case iPad_mini
    case iPad_mini_2
    case iPad_mini_3
    case iPad_mini_4
    case iPad_mini_5th_generation
    // AirPods
    case AirPods_1st_generation
    case AirPods_2nd_generation
    case AirPods_Pro
    // Apple TV
    case Apple_TV_1st_generation
    case Apple_TV_2nd_generation
    case Apple_TV_3rd_generation
    case Apple_TV_4th_generation
    case Apple_TV_4K
    // Apple Watch
    case Apple_Watch_1st_generation
    case Apple_Watch_Series_1
    case Apple_Watch_Series_2
    case Apple_Watch_Series_3
    case Apple_Watch_Series_4
    case Apple_Watch_Series_5
    case Apple_Watch_SE
    case Apple_Watch_Series_6
    // HomePod
    case HomePod
    // Simulator
    case simulator
}


// MARK: - AirPods
fileprivate let All_AirPods: [TFYDeviceType: TFYDevice] = [
    .AirPods_1st_generation: TFYDevice(identifiers: ["AirPods1,1"], description: "AirPods (1st generation)"),
    .AirPods_2nd_generation: TFYDevice(identifiers: ["AirPods2,1"], description: "AirPods (2nd generation)"),
    .AirPods_Pro: TFYDevice(identifiers: ["iProd8,1"], description: "AirPods Pro")
]

// MARK: - Apple TV
fileprivate let All_Apple_TV: [TFYDeviceType: TFYDevice] = [
    .Apple_TV_1st_generation: TFYDevice(identifiers: ["AppleTV1,1"], description: "Apple TV (1st generation)"),
    .Apple_TV_2nd_generation: TFYDevice(identifiers: ["AppleTV2,1"], description: "Apple TV (2nd generation)"),
    .Apple_TV_3rd_generation: TFYDevice(identifiers: ["AppleTV3,1", "AppleTV3,2"], description: "Apple TV (3rd generation)"),
    .Apple_TV_4th_generation: TFYDevice(identifiers: ["AppleTV5,3"], description: "Apple TV (4th generation)"),
    .Apple_TV_4K: TFYDevice(identifiers: ["AppleTV6,2"], description: "Apple TV 4K")
]


// MARK: - Apple Watch
fileprivate let All_Apple_Watch: [TFYDeviceType: TFYDevice] = [
    .Apple_Watch_1st_generation: TFYDevice(identifiers: ["Watch1,1", "Watch1,2"], description: "Apple Watch (1st generation)"),
    .Apple_Watch_Series_1: TFYDevice(identifiers: ["Watch2,6", "Watch2,7"], description: "Apple Watch Series 1"),
    .Apple_Watch_Series_2: TFYDevice(identifiers: ["Watch2,3", "Watch2,4"], description: "Apple Watch Series 2"),
    .Apple_Watch_Series_3: TFYDevice(identifiers: ["Watch3,1", "Watch3,2", "Watch3,3", "Watch3,4"], description: "Apple Watch Series 3"),
    .Apple_Watch_Series_4: TFYDevice(identifiers: ["Watch4,1", "Watch4,2", "Watch4,3", "Watch4,4"], description: "Apple Watch Series 4"),
    .Apple_Watch_Series_5: TFYDevice(identifiers: ["Watch5,1", "Watch5,2", "Watch5,3", "Watch5,4"], description: "Apple Watch Series 5"),
    .Apple_Watch_SE: TFYDevice(identifiers: ["Watch5,9", "Watch5,10", "Watch5,11", "Watch5,12"], description: "Apple Watch SE"),
    .Apple_Watch_Series_6: TFYDevice(identifiers: ["Watch6,1", "Watch6,2", "Watch6,3", "Watch6,4"], description: "Apple Watch Series 6")
]


// MARK: - HomePod
fileprivate let All_HomePod: [TFYDeviceType: TFYDevice] = [
    .HomePod: TFYDevice(identifiers: ["AudioAccessory1,1", "AudioAccessory1,2"], description: "HomePod")
]


// MARK: - iPad
fileprivate let All_iPad: [TFYDeviceType: TFYDevice] = [
    .iPad: TFYDevice(identifiers: ["iPad1,1"], description: "iPad"),
    .iPad_2: TFYDevice(identifiers: ["iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"], description: "iPad 2"),
    .iPad_3rd_generation: TFYDevice(identifiers: ["iPad3,1", "iPad3,2", "iPad3,3"], description: "iPad (3rd generation)"),
    .iPad_4th_generation: TFYDevice(identifiers: ["iPad3,4", "iPad3,5", "iPad3,6"], description: "iPad (4th generation)"),
    .iPad_5th_generation: TFYDevice(identifiers: ["iPad6,11", "iPad6,12"], description: "iPad (5th generation)"),
    .iPad_6th_generation: TFYDevice(identifiers: ["iPad7,5", "iPad7,6"], description: "iPad (6th generation)"),
    .iPad_7th_generation: TFYDevice(identifiers: ["iPad7,11", "iPad7,12"], description: "iPad (7th generation)"),
    .iPad_8th_generation: TFYDevice(identifiers: ["iPad11,6", "iPad11,7"], description: "iPad (8th generation)")
]


// MARK: - iPad Air
fileprivate let All_iPad_Air: [TFYDeviceType: TFYDevice] = [
    .iPad_Air: TFYDevice(identifiers: ["iPad4,1", "iPad4,2", "iPad4,3"], description: "iPad Air"),
    .iPad_Air_2: TFYDevice(identifiers: ["iPad5,3", "iPad5,4"], description: "iPad Air 2"),
    .iPad_Air_3rd_generation: TFYDevice(identifiers: ["iPad11,3", "iPad11,4"], description: "iPad Air (3rd generation)"),
    .iPad_Air_4th_generation: TFYDevice(identifiers: ["iPad13,1", "iPad13,2"], description: "iPad Air (4th generation)")
]


// MARK: - iPad Pro
fileprivate let All_iPad_Pro: [TFYDeviceType: TFYDevice] = [
    .iPad_Pro_12_9_inch: TFYDevice(identifiers: ["iPad6,7", "iPad6,8"], description: "iPad Pro (12.9-inch)"),
    .iPad_Pro_9_7_inch: TFYDevice(identifiers: ["iPad6,3", "iPad6,4"], description: "iPad Pro (9.7-inch)"),
    .iPad_Pro_12_9_inch_2nd_generation: TFYDevice(identifiers: ["iPad7,1", "iPad7,2"],  description: "iPad Pro (12.9-inch) (2nd generation)"),
    .iPad_Pro_10_5_inch: TFYDevice(identifiers: ["iPad7,3", "iPad7,4"], description: "iPad Pro (10.5-inch)"),
    .iPad_Pro_11_inch: TFYDevice(identifiers: ["iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4"], description: "iPad Pro (11-inch)"),
    .iPad_Pro_12_9_inch_3rd_generation: TFYDevice(identifiers: ["iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8"], description: "iPad Pro (12.9-inch) (3rd generation)"),
    .iPad_Pro_11_inch_2nd_generation: TFYDevice(identifiers: ["iPad8,9", "iPad8,10"], description: "iPad Pro (11-inch) (2nd generation)"),
    .iPad_Pro_12_9_inch_4th_generation: TFYDevice(identifiers: ["iPad8,11", "iPad8,12"], description: "iPad Pro (12.9-inch) (4th generation)")
]


// MARK: - iPad mini
fileprivate let All_iPad_mini: [TFYDeviceType: TFYDevice] = [
    .iPad_mini: TFYDevice(identifiers: ["iPad2,5", "iPad2,6", "iPad2,7"], description: "iPad mini"),
    .iPad_mini_2: TFYDevice(identifiers: ["iPad4,4", "iPad4,5", "iPad4,6"], description: "iPad mini 2"),
    .iPad_mini_3: TFYDevice(identifiers: ["iPad4,7", "iPad4,8", "iPad4,9"], description: "iPad mini 3"),
    .iPad_mini_4: TFYDevice(identifiers: ["iPad5,1", "iPad5,2"], description: "iPad mini 4"),
    .iPad_mini_5th_generation: TFYDevice(identifiers: ["iPad11,1", "iPad11,2"], description: "iPad mini (5th generation)")
]


// MARK: - iPod touch
fileprivate let All_iPod_touch: [TFYDeviceType: TFYDevice] = [
    .iPod_touch: TFYDevice(identifiers: ["iPod1,1"], description: "iPod touch"),
    .iPod_touch_2nd_generation: TFYDevice(identifiers: ["iPod2,1"], description: "iPod touch (2nd generation)"),
    .iPod_touch_3rd_generation: TFYDevice(identifiers: ["iPod3,1"], description: "iPod touch (3rd generation)"),
    .iPod_touch_4th_generation: TFYDevice(identifiers: ["iPod4,1"], description: "iPod touch (4th generation)"),
    .iPod_touch_5th_generation: TFYDevice(identifiers: ["iPod5,1"], description: "iPod touch (5th generation)"),
    .iPod_touch_6th_generation: TFYDevice(identifiers: ["iPod7,1"], description: "iPod touch (6th generation)"),
    .iPod_touch_7th_generation: TFYDevice(identifiers: ["iPod9,1"], description: "iPod touch (7th generation)")
]


// MARK: - iPhone
fileprivate let All_iPhone: [TFYDeviceType: TFYDevice] = [
    .iPhone: TFYDevice(identifiers: ["iPhone1,1"], description: "iPhone"),
    .iPhone_3G: TFYDevice(identifiers: ["iPhone1,2"], description: "iPhone 3G"),
    .iPhone_3GS: TFYDevice(identifiers: ["iPhone2,1"], description: "iPhone 3GS"),
    .iPhone_4: TFYDevice(identifiers: ["iPhone3,1", "iPhone3,2", "iPhone3,3"], description: "iPhone 4"),
    .iPhone_4s: TFYDevice(identifiers: ["iPhone4,1"], description: "iPhone 4S"),
    .iPhone_5: TFYDevice(identifiers: ["iPhone5,1", "iPhone5,2"], description: "iPhone 5"),
    .iPhone_5c: TFYDevice(identifiers: ["iPhone5,3", "iPhone5,4"], description: "iPhone 5c"),
    .iPhone_5s: TFYDevice(identifiers: ["iPhone6,1", "iPhone6,2"], description: "iPhone 5s"),
    .iPhone_6: TFYDevice(identifiers: ["iPhone7,2"], description: "iPhone 6"),
    .iPhone_6_Plus: TFYDevice(identifiers: ["iPhone7,1"], description: "iPhone 6 Plus"),
    .iPhone_6s: TFYDevice(identifiers: ["iPhone8,1"], description: "iPhone 6s"),
    .iPhone_6s_Plus: TFYDevice(identifiers: ["iPhone8,2"], description: "iPhone 6s Plus"),
    .iPhone_SE_1st_generation: TFYDevice(identifiers: ["iPhone8,4"], description: "iPhone SE (1st generation)"),
    .iPhone_7: TFYDevice(identifiers: ["iPhone9,1", "iPhone9,3"], description: "iPhone 7"),
    .iPhone_7_Plus: TFYDevice(identifiers: ["iPhone9,2", "iPhone9,4"], description: "iPhone 7 Plus"),
    .iPhone_8: TFYDevice(identifiers: ["iPhone10,1", "iPhone10,4"], description: "iPhone 8"),
    .iPhone_8_Plus: TFYDevice(identifiers: ["iPhone10,2", "iPhone10,5"], description: "iPhone 8 Plus"),
    .iPhone_X: TFYDevice(identifiers: ["iPhone10,3", "iPhone10,6"], description: "iPhone X"),
    .iPhone_XR: TFYDevice(identifiers: ["iPhone11,8"], description: "iPhone XR"),
    .iPhone_XS: TFYDevice(identifiers: ["iPhone11,2"], description: "iPhone XS"),
    .iPhone_XS_Max: TFYDevice(identifiers: ["iPhone11,6", "iPhone11,4"], description: "iPhone XS Max"),
    .iPhone_11: TFYDevice(identifiers: ["iPhone12,1"], description: "iPhone 11"),
    .iPhone_11_Pro: TFYDevice(identifiers: ["iPhone12,3"], description: "iPhone 11 Pro"),
    .iPhone_11_Pro_Max: TFYDevice(identifiers: ["iPhone12,5"], description: "iPhone 11 Pro Max"),
    .iPhone_SE_2nd_generation: TFYDevice(identifiers: ["iPhone12,8"], description: "iPhone SE (2nd generation)"),
    .iPhone_12_mini: TFYDevice(identifiers: ["iPhone13,1"], description: "iPhone 12 mini"),
    .iPhone_12: TFYDevice(identifiers: ["iPhone13,2"], description: "iPhone 12"),
    .iPhone_12_Pro: TFYDevice(identifiers: ["iPhone13,3"], description: "iPhone 12 Pro"),
    .iPhone_12_Pro_Max: TFYDevice(identifiers: ["iPhone13,4"], description: "iPhone 12 Pro Max")
]


// MARK: - Simulator
fileprivate let All_Simulator: [TFYDeviceType: TFYDevice] = [
    .simulator: TFYDevice(identifiers: ["i386", "x86_64"], description: "Simulator")
]

public let All_Devices: [TFYDeviceType: TFYDevice] = All_AirPods
    .merging(All_Apple_TV) { (current, _) in current }
    .merging(All_Apple_Watch) { (current, _) in current }
    .merging(All_HomePod) { (current, _) in current }
    .merging(All_iPad) { (current, _) in current }
    .merging(All_iPad_Air) { (current, _) in current }
    .merging(All_iPad_Pro) { (current, _) in current }
    .merging(All_iPad_mini) { (current, _) in current }
    .merging(All_iPod_touch) { (current, _) in current }
    .merging(All_iPhone) { (current, _) in current }
    .merging(All_Simulator) { (current, _) in current }


/// MARK ---------------------------------------------------------------  UIDevice ---------------------------------------------------------------
public extension TFY where Base == UIDevice {
    /// 判断是否是IphoneX
    func isPhoneX() -> Bool {
        var isMore:Bool = false
        if #available(iOS 11.0, *) {
            isMore = (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! > 0
        }
        return isMore
    }
    
    /// 屏幕宽
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕高
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    /// 设备机器名字，例如`iPhone 7 Plus`.
    static var machineName: String {
        let machine = UIDevice._machine
        var machineName = machine
        for (_, device) in All_Devices.map({ $1 }).enumerated() {
            if device.identifiers.contains(machine) {
                machineName = device.description
                break
            }
        }
        return machineName
    }
    
    /// 设备基本信息
    static var info: String {
        return
            "\n"
            +
            "*******************************************************************"
            + "\n"
            + "Sysname:          \(UIDevice._sysname)"
            + "\n"
            + "Release:          \(UIDevice._release)"
            + "\n"
            + "Version:          \(UIDevice._version)"
            + "\n"
            + "Machine:          \(UIDevice._machine)"
            + "\n"
            + "SystemVersion:    \(UIDevice.current.systemVersion)"
            + "\n"
            + "MachineName:      \(Base.tfy.machineName)"
            + "\n"
            + "DeviceName:       \(UIDevice.current.name)"
            + "\n"
            + "*******************************************************************"
    }
    
    /// 是否是模拟器
    static var isSimulator: Bool {
        let machine = UIDevice._machine
        var isSimulator: Bool = false
        for (_, device) in All_Devices.enumerated() {
            if device.key == .simulator && device.value.identifiers.contains(machine) {
                isSimulator = true
                break
            }
        }
        return isSimulator
    }
    
    /// 是否是刘海屏手机，兼容真机和模拟器
    static var isNotchiPhone: Bool {
        var isNotchiPhone: Bool = false
        if #available(iOS 11.0, *) {
            if let delegate = UIApplication.shared.delegate, let _window = delegate.window, let window = _window {
                isNotchiPhone = window.safeAreaInsets.bottom > 0
            }
        }
        return isNotchiPhone
    }
    
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 20.0
        if #available(iOS 13.0, *) {
            if let delegate = UIApplication.shared.delegate,
               let _window = delegate.window,
               let window = _window,
               let windowScene = window.windowScene,
               let statusBarManager = windowScene.statusBarManager {
                statusBarHeight = statusBarManager.statusBarFrame.height
            }
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    /// 是否隐藏了状态栏
    static var isStatusBarHidden: Bool {
        var isStatusBarHidden: Bool = false
        if #available(iOS 13.0, *) {
            if let delegate = UIApplication.shared.delegate,
               let _window = delegate.window,
               let window = _window,
               let windowScene = window.windowScene,
               let statusBarManager = windowScene.statusBarManager {
                isStatusBarHidden = statusBarManager.isStatusBarHidden
            }
        } else {
            isStatusBarHidden = UIApplication.shared.isStatusBarHidden
        }
        return isStatusBarHidden
    }
    
    /// 状态栏样式
    static var statusBarStyle: UIStatusBarStyle {
        var statusBarStyle: UIStatusBarStyle = .default
        if #available(iOS 13.0, *) {
            if let delegate = UIApplication.shared.delegate,
               let _window = delegate.window,
               let window = _window,
               let windowScene = window.windowScene,
               let statusBarManager = windowScene.statusBarManager {
                statusBarStyle = statusBarManager.statusBarStyle
            }
        } else {
            statusBarStyle = UIApplication.shared.statusBarStyle
        }
        return statusBarStyle
    }
    
    /// 虚拟Home键高度，兼容真机和模拟器
    static var homeIndicatorHeight: CGFloat {
        var homeIndicatorHeight: CGFloat = .zero
        if #available(iOS 11.0, *) {
            if let delegate = UIApplication.shared.delegate, let _window = delegate.window, let window = _window {
                homeIndicatorHeight = window.safeAreaInsets.bottom
            }
        }
        return homeIndicatorHeight
    }
}


extension UIDevice {
    
    fileprivate static var _sys: utsname {
        var sys: utsname = utsname()
        uname(&sys)
        return sys
    }
    
    fileprivate static var _machine: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _release: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _version: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _sysname: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _nodename: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
}
