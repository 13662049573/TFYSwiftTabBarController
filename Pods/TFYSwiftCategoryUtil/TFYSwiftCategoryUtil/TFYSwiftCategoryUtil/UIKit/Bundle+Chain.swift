//
//  Bundle+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation
import UIKit

public enum BundleType {
    // 自己 module 下的 bundle 文件
    case currentBundle
    // 其他 module 下的 bundle 文件
    case otherBundle
}

public extension TFY where Base: Bundle {
    // MARK: 2.1、App命名空间
    /// App命名空间
    /// - Returns: 命名空间字符串，失败返回空字符串
    static var namespace: String {
        guard let namespace =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return "" }
        return  namespace
    }
    
    // MARK: 2.2、项目/app 的名字
    /// 项目/app 的名字
    /// - Returns: 名称字符串，失败返回空字符串
    static var bundleName: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? ""
    }
    
    // MARK: 2.4、获取app的 Build ID
    /// 获取app的 Build ID
    /// - Returns: Build ID字符串，失败返回空字符串
    static var appBuild: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? ""
    }
    
    // MARK: 2.5、获取app的 Bundle Identifier
    /// 获取app的 Bundle Identifier
    /// - Returns: Bundle Identifier字符串，失败返回空字符串
    static var appBundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    // MARK: 2.7、App 名称
    /// App 名称
    /// - Returns: App显示名称，失败返回空字符串
    static var appDisplayName: String {
        return (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
    }
    
    // MARK: 1.1、通过字符串地址从 Bundle 里面获取资源文件
    /// 从 Bundle 里面获取资源文件（支持当前的 Moudle下的Bundle和其他Moudle下的 Bundle）
    /// - Parameters:
    ///   - bundName: bundle 的名字，不能为空
    ///   - resourceName: 资源的名字，比如图片的名字，不能为空
    ///   - bundleType: 类型：默认 currentBundle是在自己 module 下的 bundle 文件
    /// - Returns: 资源路径，失败返回空字符串
    static func getBundlePathResource(bundName: String, resourceName: String, bundleType: BundleType = .currentBundle) -> String {
        guard !bundName.isEmpty, !resourceName.isEmpty else {
            TFYUtils.Logger.log("⚠️ Bundle: bundName或resourceName不能为空")
            return ""
        }
        if bundleType == .otherBundle {
            return "Frameworks/\(bundName).framework/\(bundName).bundle/\(resourceName)"
        }
        return "\(bundName).bundle/\(resourceName)"
    }
    
    // MARK: 1.2、通过 Bundle 里面获取资源文件
    /// 通过 Bundle 里面获取资源文件（支持当前的 Moudle下的Bundle和其他Moudle下的）
    /// - Parameters:
    ///   - bundName: bundle 的名字，不能为空
    ///   - resourceName: 资源的名字，比如图片的名字(需要写出完整的名字，如图片：icon@2x)，不能为空
    ///   - ext: 资源类型后缀
    ///   - bundleType: 类型：默认 currentBundle是在自己 module 下的 bundle 文件
    /// - Returns: 资源路径，失败返回nil
    static func getBundleResource(bundName: String, resourceName: String, ofType ext: String?, bundleType: BundleType = .currentBundle) -> String? {
        guard !bundName.isEmpty, !resourceName.isEmpty else {
            TFYUtils.Logger.log("⚠️ Bundle: bundName或resourceName不能为空")
            return nil
        }
        let resourcePath = bundleType == .otherBundle ? "Frameworks/\(bundName).framework/\(bundName)" : "\(bundName)"
        guard let bundlePath = Bundle.main.path(forResource: resourcePath, ofType: "bundle"), let bundle = Bundle(path: bundlePath) else {
            TFYUtils.Logger.log("⚠️ Bundle: 找不到bundle路径")
            return nil
        }
        let imageStr = bundle.path(forResource: resourceName, ofType: ext)
        return imageStr
    }
    
    // MARK: 1.3、读取项目本地文件数据
    /// 读取项目本地文件数据
    /// - Parameters:
    ///   - fileName: 文件名字，不能为空
    ///   - type: 资源类型，不能为空
    /// - Returns: 返回对应URL，失败返回nil
    static func readLocalData(_ fileName: String, _ type: String) -> URL? {
        guard !fileName.isEmpty, !type.isEmpty else {
            TFYUtils.Logger.log("⚠️ Bundle: fileName或type不能为空")
            return nil
        }
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else {
            TFYUtils.Logger.log("⚠️ Bundle: 找不到本地文件 \(fileName).\(type)")
            return nil
        }
        return URL(fileURLWithPath: path)
    }
}

public extension Bundle {
    /// 应用显示版本 (CFBundleShortVersionString)
    /// - Returns: 版本号字符串，失败返回nil
    static var appVersion: String? {
        return main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /// 应用构建版本 (CFBundleVersion)
    /// - Returns: 构建号字符串，失败返回nil
    static var buildVersion: String? {
        return main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    /// 完整版本信息 (格式：1.0.0.123)
    /// - Returns: 完整版本号字符串，失败返回nil
    static var fullVersion: String? {
        guard let version = appVersion, let build = buildVersion else { return nil }
        return "\(version).\(build)"
    }
}

public extension UIDevice {
    /// 便捷访问版本信息
    static var appVersion: String { Bundle.appVersion ?? "0.0.0" }
    static var buildVersion: String { Bundle.buildVersion ?? "0" }
    static var fullVersion: String { Bundle.fullVersion ?? "0.0.0.0" }
}

// 版本比较扩展
public extension String {
    /// 版本号字符串比较
    /// - Parameter otherVersion: 另一个版本号
    /// - Returns: 比较结果
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var versionComponents = self.components(separatedBy: versionDelimiter)
        var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)
        
        let zeroDiff = versionComponents.count - otherVersionComponents.count
        
        if zeroDiff > 0 {
            otherVersionComponents += Array(repeating: "0", count: zeroDiff)
        } else if zeroDiff < 0 {
            versionComponents += Array(repeating: "0", count: -zeroDiff)
        }
        
        for (v, ov) in zip(versionComponents, otherVersionComponents) {
            let vInt = Int(v) ?? 0
            let ovInt = Int(ov) ?? 0
            if vInt < ovInt {
                return .orderedAscending
            } else if vInt > ovInt {
                return .orderedDescending
            }
        }
        return .orderedSame
    }
}

// MARK: - 三、Bundle的便利方法扩展
public extension Bundle {
    
    // MARK: 3.1、获取Bundle中的所有资源文件
    /// 获取Bundle中的所有资源文件
    /// - Returns: 资源文件路径数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func allResourcePaths() -> [String] {
        return self.paths(forResourcesOfType: nil, inDirectory: nil)
    }
    
    // MARK: 3.2、获取Bundle中的图片资源
    /// 获取Bundle中的图片资源
    /// - Returns: 图片资源路径数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func imageResourcePaths() -> [String] {
        let imageExtensions = ["png", "jpg", "jpeg", "gif", "bmp", "tiff", "webp"]
        var paths: [String] = []
        for ext in imageExtensions {
            paths.append(contentsOf: self.paths(forResourcesOfType: ext, inDirectory: nil))
        }
        return paths
    }
    
    // MARK: 3.3、获取Bundle中的JSON文件
    /// 获取Bundle中的JSON文件
    /// - Returns: JSON文件路径数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func jsonResourcePaths() -> [String] {
        return self.paths(forResourcesOfType: "json", inDirectory: nil)
    }
    
    // MARK: 3.4、获取Bundle中的Plist文件
    /// 获取Bundle中的Plist文件
    /// - Returns: Plist文件路径数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func plistResourcePaths() -> [String] {
        return self.paths(forResourcesOfType: "plist", inDirectory: nil)
    }
    
    // MARK: 3.5、检查Bundle中是否包含指定资源
    /// 检查Bundle中是否包含指定资源
    /// - Parameters:
    ///   - name: 资源名称
    ///   - type: 资源类型
    /// - Returns: 如果包含返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func containsResource(named name: String, ofType type: String?) -> Bool {
        return self.path(forResource: name, ofType: type) != nil
    }
    
    // MARK: 3.6、获取Bundle的大小
    /// 获取Bundle的大小
    /// - Returns: Bundle大小（字节）
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func size() -> Int64 {
        let fileManager = FileManager.default
        let bundlePath = self.bundlePath
        
        var totalSize: Int64 = 0
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: bundlePath)
            for item in contents {
                let itemPath = (bundlePath as NSString).appendingPathComponent(item)
                let attributes = try fileManager.attributesOfItem(atPath: itemPath)
                if let fileSize = attributes[.size] as? Int64 {
                    totalSize += fileSize
                }
            }
        } catch {
            TFYUtils.Logger.log("计算Bundle大小失败: \(error.localizedDescription)")
        }
        
        return totalSize
    }
    
    // MARK: 3.7、获取Bundle的格式化大小
    /// 获取Bundle的格式化大小
    /// - Returns: 格式化的大小字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: self.size())
    }
    
    // MARK: 3.8、获取Bundle的创建时间
    /// 获取Bundle的创建时间
    /// - Returns: 创建时间，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func creationDate() -> Date? {
        let fileManager = FileManager.default
        let bundlePath = self.bundlePath
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: bundlePath)
            return attributes[.creationDate] as? Date
        } catch {
            TFYUtils.Logger.log("获取Bundle创建时间失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 3.9、获取Bundle的修改时间
    /// 获取Bundle的修改时间
    /// - Returns: 修改时间，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func modificationDate() -> Date? {
        let fileManager = FileManager.default
        let bundlePath = self.bundlePath
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: bundlePath)
            return attributes[.modificationDate] as? Date
        } catch {
            TFYUtils.Logger.log("获取Bundle修改时间失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 3.10、获取Bundle的信息字典
    /// 获取Bundle的信息字典
    /// - Returns: 信息字典，失败返回空字典
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func infoDictionary() -> [String: Any] {
        return self.infoDictionary ?? [:]
    }
    
    // MARK: 3.11、获取Bundle的本地化字符串
    /// 获取Bundle的本地化字符串
    /// - Parameters:
    ///   - key: 字符串键
    ///   - comment: 注释
    /// - Returns: 本地化字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func localizedString(forKey key: String, comment: String = "") -> String {
        return NSLocalizedString(key, bundle: self, comment: comment)
    }
    
    // MARK: 3.12、获取Bundle的本地化字符串（带默认值）
    /// 获取Bundle的本地化字符串（带默认值）
    /// - Parameters:
    ///   - key: 字符串键
    ///   - defaultValue: 默认值
    ///   - comment: 注释
    /// - Returns: 本地化字符串或默认值
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func localizedString(forKey key: String, defaultValue: String, comment: String = "") -> String {
        let localizedString = NSLocalizedString(key, bundle: self, comment: comment)
        return localizedString == key ? defaultValue : localizedString
    }
}
