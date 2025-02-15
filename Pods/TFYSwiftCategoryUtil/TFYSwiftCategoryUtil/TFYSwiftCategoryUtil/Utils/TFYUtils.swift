//
//  TFYUtils.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/12.
//

import Foundation
import UIKit
import StoreKit
import SystemConfiguration.CaptiveNetwork

public let TFYSwiftWidth = UIScreen.main.bounds.width
public let TFYSwiftHeight = UIScreen.main.bounds.height

/// 文档目录
public let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString

/// 缓存目录
public let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString

/// 临时目录
public let tempPath = NSTemporaryDirectory() as NSString

// MARK: 读取本地json文件
public func getJSON(name:String) -> NSDictionary {
    let path = Bundle.main.path(forResource: name, ofType: "json")
    let url = URL(fileURLWithPath: path!)
    do {
        let data = try Data(contentsOf: url)
        let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        return jsonData as! NSDictionary
    } catch _ as Error? {
        print("读取本地数据出现错误!")
        return NSDictionary()
    }
}

/// 强制关闭暗黑色
public func closedLight() {
    if #available(iOS 13, *) {
       UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = .light
    }
}

/// 自定义打印
/// - Parameter msg: 打印的内容
/// - Parameter file: 文件路径
/// - Parameter line: 打印内容所在的 行
/// - Parameter column: 打印内容所在的 列
/// - Parameter fn: 打印内容的函数名
public func TFYLog(_ msg: Any...,
                    file: NSString = #file,
                    line: Int = #line,
                    column: Int = #column,
                    fn: String = #function) {
    #if DEBUG
    var msgStr = ""
    for element in msg {
        msgStr += "\(element)\n"
    }
    let prefix = "----------------######################----begin🚀----##################----------------\n当前时间：\(NSDate())\n当前文件完整的路径是：\(file)\n当前文件是：\(file.lastPathComponent)\n第 \(line) 行 \n第 \(column) 列 \n函数名：\(fn)\n打印内容如下：\n\(msgStr)----------------######################----end😊----##################----------------"
    print(prefix)
    // 将内容同步写到文件中去（Caches文件夹下）
    let cachePath  = CachesDirectory()
    let logURL = cachePath + "/log.txt"
    appendText(fileURL: URL(string: logURL)!, string: "\(prefix)")
    #endif
}

private func CachesDirectory() -> String {
    //获取程序的/Library/Caches目录
    let cachesPath = NSHomeDirectory() + "/Library/Caches"
    return cachesPath
}

// 在文件末尾追加新内容
private func appendText(fileURL: URL, string: String) {
    do {
        // 如果文件不存在则新建一个
        createFile(filePath: fileURL.path)
        let fileHandle = try FileHandle(forWritingTo: fileURL)
        let stringToWrite = "\n" + string
        // 找到末尾位置并添加
        fileHandle.seekToEndOfFile()
        fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
        
    } catch let error as NSError {
        print("failed to append: \(error)")
    }
}

private func judgeFileOrFolderExists(filePath: String) -> Bool {
    let exist = FileManager.default.fileExists(atPath: filePath)
    // 查看文件夹是否存在，如果存在就直接读取，不存在就直接反空
    guard exist else {
        return false
    }
    return true
}

@discardableResult
private func createFile(filePath: String) -> (isSuccess: Bool, error: String) {
    guard judgeFileOrFolderExists(filePath: filePath) else {
        // 不存在的文件路径才会创建
        // withIntermediateDirectories 为 ture 表示路径中间如果有不存在的文件夹都会创建
        let createSuccess = FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        return (createSuccess, "")
    }
    return (true, "")
}


// MARK: - 一、基本的工具
public struct TFYUtils {
    
    // MARK: 1.1、拨打电话
    /// 拨打电话的才处理
    /// - Parameter phoneNumber: 电话号码
    public static func callPhone(phoneNumber: String, complete: @escaping ((Bool) -> Void)) {
        // 注意: 跳转之前, 可以使用 canOpenURL: 判断是否可以跳转
        guard let phoneNumberEncoding = ("tel://" + phoneNumber).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: phoneNumberEncoding), UIApplication.shared.canOpenURL(url) else {
            // 不能跳转就不要往下执行了
            complete(false)
            return
        }
        openUrl(url: url, complete: complete)
    }
    
    // MARK: 1.2、应用跳转
    /// 应用跳转
    /// - Parameters:
    ///   - vc: 跳转时所在控制器
    ///   - appId: app的id(开发者账号里面：应用注册后生成的)
    public static func updateApp(vc: UIViewController, appId: String)  {
        guard appId.count > 0 else {
            return
        }
        let productView = SKStoreProductViewController()
        // productView.delegate = (vc as! SKStoreProductViewControllerDelegate)
        productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : appId], completionBlock: { (result, error) in
            if !result {
                //点击取消
                productView.dismiss(animated: true, completion: nil)
            }
        })
        vc.showDetailViewController(productView, sender: vc)
    }
    
    // MARK: 1.3、从 storyboard 中唤醒 viewcontroller
    /// 从 storyboard 中唤醒 viewcontroller
    /// - Parameters:
    ///   - storyboardID: viewcontroller 在 storyboard 中的 id
    ///   - fromStoryboard: storyboard 名称
    ///   - bundle: Bundle  默认为 main
    /// - Returns: UIviewcontroller
    public static func getViewController(storyboardID: String, fromStoryboard: String, bundle: Bundle? = nil) -> UIViewController {
        let sBundle = bundle ?? Bundle.main
        let story = UIStoryboard(name: fromStoryboard, bundle: sBundle)
        return story.instantiateViewController(withIdentifier: storyboardID)
    }
    
    // MARK: 1.5、获取本机IP
    /// 获取本机IP
    public static func getIPAddress() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    // MARK: 1.6、前往App Store进行评价
    /// 前往App Store进行评价
    /// - Parameter appid: App的 ID，在app创建的时候生成的
    public static func evaluationInAppStore(appid: String) {
        let urlString = "https://itunes.apple.com/cn/app/id" + appid + "?mt=12"
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            // 不能跳转就不要往下执行了
            return
        }
        openUrl(url: url) { (result) in
        }
    }
    
    // MARK: 1.7、跳转URL
    public static func openUrl(url: URL, complete: @escaping ((Bool) -> Void)) {
        // iOS 10.0 以前
        guard #available(iOS 10.0, *) else {
            let success = UIApplication.shared.openURL(url)
            if (success) {
                TFYLog("10以前可以跳转")
                complete(true)
            } else {
                TFYLog("10以前不能完成跳转")
                complete(false)
            }
            return
        }
        // iOS 10.0 以后
        UIApplication.shared.open(url, options: [:]) { (success) in
            if (success) {
                TFYLog("10以后可以跳转url")
                complete(true)
            } else {
                TFYLog("10以后不能完成跳转")
                complete(false)
            }
        }
    }
    
    // MARK: 1.7、获取连接wifi的ip地址, 需要定位权限和添加Access WiFi information
    /// 获取连接wifi的ip地址, 需要定位权限和添加Access WiFi information
    public static func getWiFiIP() -> String? {
        var address: String?
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0,
              let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    // MARK: 1.8、获取连接wifi的名字和mac地址, 需要定位权限和添加Access WiFi information
    /// 获取连接wifi的名字和mac地址, 需要定位权限和添加Access WiFi information
    public static func getWifiNameWithMac() -> (wifiName: String?, macIP: String?) {
        guard let interfaces: NSArray = CNCopySupportedInterfaces() else {
            return (nil, nil)
        }
        var ssid: String?
        var mac: String?
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
                mac = dict["BSSID"] as? String
            }
        }
        return (ssid, mac)
    }
    
    // MARK: 1.9、打开设置界面
    /// 打开设置界面
    public static func openSetting() {
        // 设置
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        openUrl(url: url) { (result) in
        }
    }
    
    // MARK: 1.10、退出app（类似点击home键盘）
    /// 退出app（类似点击home键盘）
    public static func exitApp() {
        DispatchQueue.main.async {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }
    }
}
