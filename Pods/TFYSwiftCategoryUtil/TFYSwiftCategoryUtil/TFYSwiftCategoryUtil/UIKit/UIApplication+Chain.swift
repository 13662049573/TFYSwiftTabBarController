//
//  UIApplication+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit

public extension TFY where Base: UIApplication {
    
    // MARK: 1.1、当前AppDelegate
    /// 当前AppDelegate
    /// - Returns: AppDelegate实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appDelegate: UIApplicationDelegate {
        return UIApplication.shared.delegate!
    }
    
    // MARK: 1.2、当前视图控制器
    /// 当前视图控制器
    /// - Returns: 当前显示的视图控制器
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var currentViewController: UIViewController {
        let window = self.appDelegate.window
        var viewController = window!!.rootViewController
        while ((viewController?.presentedViewController) != nil) {
            viewController = viewController?.presentedViewController
            if ((viewController?.isKind(of: UINavigationController.classForCoder())) == true) {
                viewController = (viewController as! UINavigationController).visibleViewController
            } else if ((viewController?.isKind(of: UITabBarController.classForCoder())) == true) {
                viewController = (viewController as! UITabBarController).selectedViewController
            }
        }
        return viewController!
    }
}

// MARK: - 二、应用版本相关
public extension TFY where Base: UIApplication {
    // MARK: 2.1、Documents文件夹URL
    /// Documents文件夹URL
    /// - Returns: Documents文件夹的URL
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var documentsURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    
    // MARK: 2.2、Documents文件夹路径
    /// Documents文件夹路径
    /// - Returns: Documents文件夹的路径字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var documentsPath: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    // MARK: 2.3、Caches文件夹URL
    /// Caches文件夹URL
    /// - Returns: Caches文件夹的URL
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var cachesURL: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
    }
    
    // MARK: 2.4、Caches文件夹路径
    /// Caches文件夹路径
    /// - Returns: Caches文件夹的路径字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var cachesPath: String? {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    
    // MARK: 2.5、Library文件夹URL
    /// Library文件夹URL
    /// - Returns: Library文件夹的URL
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var libraryURL: URL? {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
    }
    
    // MARK: 2.6、Library文件夹路径
    /// Library文件夹路径
    /// - Returns: Library文件夹的路径字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var libraryPath: String? {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    }
    
    // MARK: 2.7、应用Bundle名称
    /// 应用Bundle名称
    /// - Returns: Bundle名称
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appBundleName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    // MARK: 2.8、应用Bundle ID
    /// 应用Bundle ID，例如 'com.yamex.app'
    /// - Returns: Bundle ID
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appBundleID: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }
    
    // MARK: 2.9、应用版本号
    /// 应用版本号，例如 '1.0.0'
    /// - Returns: 版本号
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    // MARK: 2.10、应用构建版本号
    /// 应用构建版本号，例如 '12'
    /// - Returns: 构建版本号
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appBuildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
}


// MARK: - 三、截图和URL相关
public extension UIApplication {
    
    // MARK: 3.1、截图
    /// 截图
    /// - Parameter inView: 要截图的视图
    /// - Returns: 截图图片
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func snapShot(_ inView: UIView) -> UIImage {
        UIGraphicsBeginImageContext(inView.bounds.size)
        inView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapShot
    }
    
    // MARK: 3.2、App Store链接
    /// App Store链接
    /// - Parameter appStoreID: App Store ID
    /// - Returns: App Store链接字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func appUrlWithID(_ appStoreID: String) -> String {
        let appStoreUrl = "itms-apps://itunes.apple.com/app/id\(appStoreID)?mt=8"
        return appStoreUrl
    }
    
    // MARK: 3.3、App详情链接
    /// App详情链接
    /// - Parameter appStoreID: App Store ID
    /// - Returns: App详情链接字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func appDetailUrlWithID(_ appStoreID: String) -> String {
        let detailUrl = "http://itunes.apple.com/cn/lookup?id=\(appStoreID)"
        return detailUrl
    }
    
    // MARK: 3.4、检查版本升级
    /// 检查版本升级
    /// - Parameters:
    ///   - appStoreID: App Store ID
    ///   - block: 回调，返回应用信息、版本号、更新说明、是否需要更新
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func updateVersion(appStoreID: String, block:@escaping (([String: Any], String, String, Bool)->Void)) {
//        let path = "http://itunes.apple.com/cn/lookup?id=\(appStoreID)"
        let path =  UIApplication.appDetailUrlWithID(appStoreID)
        let request = URLRequest(url:NSURL(string: path)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 6)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, respone, error) in
            guard let data = data,
                  let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                print("字典不能为空")
                return
            }
            
            guard let resultCount = dic["resultCount"] as? NSNumber,
                  resultCount.intValue == 1 else {
                print("resultCount错误")
                return
            }
            
            guard let list = dic["results"] as? NSArray,
                let dicInfo = list[0] as? [String: Any],
                let appStoreVer = dicInfo["version"] as? String
            else {
                print("dicInfo错误")
                return
            }
                        
            let releaseNotes: String = (dicInfo["releaseNotes"] as? String) ?? ""
            let isUpdate = appStoreVer.compare(UIApplication.appVer, options: .numeric, range: nil, locale: nil) == .orderedDescending
            block(dicInfo, appStoreVer, releaseNotes, isUpdate)
        }
        dataTask.resume()
    }
    
    // MARK: 3.5、当前应用版本号
    /// 当前应用版本号
    /// - Returns: 版本号字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appVer: String {
        guard let infoDic = Bundle.main.infoDictionary,
            let version = infoDic["CFBundleShortVersionString"] as? String
        else { return "" }
        return version
    }
    
    // MARK: 3.6、打开网络链接
    /// 打开网络链接
    /// - Parameters:
    ///   - string: 链接字符串
    ///   - prefix: 前缀，默认空字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func openURLString(_ string: String, prefix: String = "") {

        var tmp = string
        if string.hasPrefix(prefix) == false {
            tmp = prefix + string
        }
        if tmp.hasPrefix("tel") {
            tmp = tmp.replacingOccurrences(of: "-", with: "")
        }
        guard let url = URL(string: tmp) as URL? else {
            TFYUtils.Logger.log("\(#function):链接无法打开!!!\n\(string)")
            return
        }

        if UIApplication.shared.canOpenURL(url) == false {
            TFYUtils.Logger.log("\(#function):链接无法打开!!!\n\(string)")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: 3.7、显示版本升级弹窗
    /// 显示版本升级弹窗
    /// - Parameters:
    ///   - appStoreID: App Store ID
    ///   - isForce: 是否强制升级
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func updateVersionShow(appStoreID: String, isForce: Bool = false) {
        UIApplication.updateVersion(appStoreID: appStoreID) { (dic, appStoreVer, releaseNotes, isUpdate) in
            if isUpdate == false {
                return
            }
            DispatchQueue.main.async {
                let titles = isForce == false ? ["立即升级", "取消"] : ["立即升级"]
                //富文本效果
                let paraStyle = NSMutableParagraphStyle()
                    .tfy
                    .lineBreakModeChain(.byCharWrapping)
                    .lineSpacingChain(5)
                    .alignmentChain(.left)
                    .build
                
                let title = "新版本 v\(appStoreVer)"
                let message = "\n\(releaseNotes)"
                UIAlertController(title: title, message: message, preferredStyle: .alert)
                    .addActionTitles(titles) { (alertVC, action) in
                        if action.title == "立即升级" {
                            //去升级
                            UIApplication.openURLString(UIApplication.appUrlWithID(appStoreID))
                        }
                    }
                    .setTitleColor(UIColor.black)
                    .setMessageParaStyle(paraStyle)
                    .present()
            }
        }
    }
    
    // MARK: 3.11、获取应用状态栏高度
    /// 获取应用状态栏高度
    /// - Returns: 状态栏高度
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static  var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    // MARK: 3.12、获取安全区域顶部高度
    /// 获取安全区域顶部高度
    /// - Returns: 安全区域顶部高度
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var safeAreaTopHeight: CGFloat {
        if #available(iOS 15.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return windowScene?.windows.first?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        }
    }
    
    // MARK: 3.13、获取安全区域底部高度
    /// 获取安全区域底部高度
    /// - Returns: 安全区域底部高度
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var safeAreaBottomHeight: CGFloat {
        if #available(iOS 15.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        }
    }
    
    // MARK: 3.14、检查网络连接状态
    /// 检查网络连接状态
    /// - Returns: 是否有网络连接
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var isNetworkAvailable: Bool {
        let reachability = Reachability()
        return reachability.connection != .unavailable
    }
    
    // MARK: 3.15、获取设备方向
    /// 获取设备方向
    /// - Returns: 设备方向
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    // MARK: 3.16、检查是否为iPad
    /// 检查是否为iPad
    /// - Returns: 是否为iPad
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // MARK: 3.17、检查是否为iPhone
    /// 检查是否为iPhone
    /// - Returns: 是否为iPhone
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    // MARK: 3.18、获取应用启动时间
    /// 获取应用启动时间
    /// - Returns: 启动时间
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appLaunchTime: Date {
        return Date(timeIntervalSince1970: ProcessInfo.processInfo.systemUptime)
    }
    
    // MARK: 3.19、获取应用运行时间
    /// 获取应用运行时间
    /// - Returns: 运行时间（秒）
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var appRunTime: TimeInterval {
        return ProcessInfo.processInfo.systemUptime
    }
    
    // MARK: 3.20、获取设备总内存
    /// 获取设备总内存
    /// - Returns: 总内存（字节）
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static var deviceTotalMemory: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    // MARK: 3.5、远程推送deviceToken处理
    /// 远程推送deviceToken处理
    /// - Parameter deviceToken: 设备令牌数据
    /// - Returns: 设备令牌字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func deviceTokenString(_ deviceToken: NSData) -> String{
        var deviceTokenString = String()
        if #available(iOS 13.0, *) {
            let bytes = [UInt8](deviceToken)
            for item in bytes {
                deviceTokenString += String(format:"%02x", item&0x000000FF)
            }
            
        } else {
            deviceTokenString = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<> "))
        }
#if DEBUG
        print("deviceToken：\(deviceTokenString)")
#endif
        return deviceTokenString
    }
    
    // MARK: 3.6、后台任务执行
    /// 后台任务执行(block为空可填入AppDelegate.m方法 applicationDidEnterBackground中)
    /// - Parameter block: 后台执行的任务块
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func didEnterBackground(_ block: (()->Void)? = nil) {
        let application: UIApplication = UIApplication.shared
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
        //注册一个后台任务，并提供一个在时间耗尽时执行的代码块
        bgTask = application.beginBackgroundTask(expirationHandler: {
            if bgTask != UIBackgroundTaskIdentifier.invalid {
                //当时间耗尽时调用这个代码块
                //如果在这个代码块返回之前没有调用endBackgroundTask
                //应用程序将被终止
                application.endBackgroundTask(bgTask)
                bgTask = UIBackgroundTaskIdentifier.invalid
            }
        })
        
        let backgroundQueue = OperationQueue()
        backgroundQueue.addOperation() {
            //完成一些工作。我们有几分钟的时间来完成它
            //在结束时，必须调用endBackgroundTask
            NSLog("Doing some background work!")
            block?()
            application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskIdentifier.invalid
        }
    }
    // MARK: 3.7、配置应用图标
    /// 配置应用图标(传 nil 恢复默认)
    /// - Parameter name: 图标名称
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func setAppIcon(name: String?) {
        //判断是否支持替换图标, false: 不支持
        if #available(iOS 10.3, *) {
            //判断是否支持替换图标, false: 不支持
            guard UIApplication.shared.supportsAlternateIcons else { return }
            
            //如果支持, 替换icon
            UIApplication.shared.setAlternateIconName(name) { (error) in
                //点击弹框的确认按钮后的回调
                if error != nil {
                    TFYUtils.Logger.log("更换icon发生错误")
                }
            }
        }
    }
}

