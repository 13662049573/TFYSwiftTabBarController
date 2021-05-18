//
//  Bundle+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/16.
//

import UIKit

public enum BundleType {
    // 自己 module 下的 bundle 文件
    case currentBundle
    // 其他 module 下的 bundle 文件
    case otherBundle
}

public extension TFY where Base == Bundle {
    
    ///过 通过字符串地址 从 Bundle 里面获取资源文件（支持当前的 Moudle下的Bundle和其他Moudle下的 Bundle）
    static func getBundlePathResource(bundName: String, resourceName: String, bundleType: BundleType = .currentBundle) -> String {
        if bundleType == .otherBundle {
            return "Frameworks/\(bundName).framework/\(bundName).bundle/\(resourceName)"
        }
        return "\(bundName).bundle/" + "\(resourceName)"
    }
    
    ///通过 Bundle 里面获取资源文件（支持当前的 Moudle下的Bundle和其他Moudle下的
    static func getBundleResource(bundName: String, resourceName: String, ofType ext: String?, bundleType: BundleType = .currentBundle) -> String? {
        let resourcePath = bundleType == .otherBundle ? "Frameworks/\(bundName).framework/\(bundName)" : "\(bundName)"
        guard let bundlePath = Bundle.main.path(forResource: resourcePath, ofType: "bundle"), let bundle = Bundle.init(path: bundlePath) else {
            return nil
        }
        let imageStr = bundle.path(forResource: resourceName, ofType: ext)
        return imageStr
    }
    
    /// App命名空间
    static var namespace: String {
        guard let namespace =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return "" }
        return  namespace
    }
    
    /// 项目/app 的名字
    static var bundleName: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? ""
    }
    
    /// 获取app的版本号
    static var appVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }
    
    /// 获取app的 Build ID
    static var appBuild: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? ""
    }
    
    /// 获取app的 Bundle Identifier
    static var appBundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    /// Info.plist
    static var infoDictionary: [String : Any]? {
        return Bundle.main.infoDictionary
    }
    
    /// App 名称
    static var appDisplayName: String {
        return (Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String) ?? ""
    }
    
}
