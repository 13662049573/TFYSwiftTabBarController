//
//  FileManager+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//  用途：FileManager 链式编程扩展，支持文件操作、目录管理等功能。
//

import UIKit
import Foundation
import AVKit

public enum BasePath: String, CaseIterable {
    case directory = "Directory"
    case documents = "Documents"
    case library = "Library"
    case caches = "Caches"
    case preferences = "Preferences"
    case tmp = "Tmp"
}

public extension TFY where Base: FileManager {
    // MARK: 1.1、获取Home的完整路径名
    /// 获取Home的完整路径名
    /// - Returns: Home的完整路径名
    static func homeDirectory() -> String {
        //获取程序的Home目录
        return NSHomeDirectory()
    }
    
    // MARK: 1.2、获取Documents的完整路径名
    /// 获取Documents的完整路径名
    /// - Returns: Documents的完整路径名
    static func documentsDirectory() -> String {
        //获取程序的documentPaths目录
        //方法1
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documentPath = documentPaths.first else {
            //方法2
            return NSHomeDirectory() + "/Documents"
        }
        return documentPath
    }
    
    // MARK: 1.3、获取Library的完整路径名
    /**
     这个目录下有两个子目录：Caches 和 Preferences
     Library/Preferences目录，包含应用程序的偏好设置文件。不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好。
     Library/Caches目录，主要存放缓存文件，iTunes不会备份此目录，此目录下文件不会再应用退出时删除
     */
    /// 获取Library的完整路径名
    /// - Returns: Library的完整路径名
    static func libraryDirectory() -> String {
        //获取程序的Library目录
        //Library目录－方法1
        let libraryPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        guard let libraryPath = libraryPaths.first else {
            // Library目录－方法2
            return NSHomeDirectory() + "/Library"
        }
        return libraryPath
    }
    
    // MARK: 1.4、获取/Library/Caches的完整路径名
    /// 获取/Library/Caches的完整路径名
    /// - Returns: /Library/Caches的完整路径名
    static func cachesDirectory() -> String {
        //获取程序的/Library/Caches目录
        let cachesPaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        guard let cachesPath = cachesPaths.first else {
            return NSHomeDirectory() + "/Library/Caches"
        }
        return cachesPath
    }
    
    // MARK: 1.5、获取Library/Preferences的完整路径名
    /// 获取Library/Preferences的完整路径名
    /// - Returns: Library/Preferences的完整路径名
    static func preferencesDirectory() -> String {
        //Library/Preferences目录
        return libraryDirectory() + "/Preferences"
    }
    
    // MARK: 1.6、获取Tmp的完整路径名
    /// 获取Tmp的完整路径名，用于存放临时文件，保存应用程序再次启动过程中不需要的信息，重启后清空
    /// - Returns: Tmp的完整路径名
    static func tmpDirectory() -> String {
        //方法1
        let tmpDir = NSTemporaryDirectory()
        return tmpDir.isEmpty ? NSHomeDirectory() + "/tmp" : tmpDir
    }
    
    // MARK: 1.7、获取指定路径的完整路径名
    /// 获取指定路径的完整路径名
    /// - Parameter path: 路径类型
    /// - Returns: 完整路径名
    static func path(for path: BasePath) -> String {
        switch path {
        case .directory:
            return homeDirectory()
        case .documents:
            return documentsDirectory()
        case .library:
            return libraryDirectory()
        case .caches:
            return cachesDirectory()
        case .preferences:
            return preferencesDirectory()
        case .tmp:
            return tmpDirectory()
        }
    }
}

// MARK: - 二、文件以及文件夹的操作 扩展
public extension TFY where Base: FileManager {
    // MARK: 文件写入的类型
    /// 文件写入的类型
    enum FileWriteType: Int, CaseIterable {
        case textType
        case imageType
        case arrayType
        case dictionaryType
        case dataType
    }
    
    // MARK: 移动或者拷贝的类型
    /// 移动或者拷贝的类型
    enum MoveOrCopyType: Int, CaseIterable {
        case file
        case directory
    }
    
    /// 文件管理器
    static var fileManager: FileManager {
        return FileManager.default
    }

    // MARK: 2.1、创建文件夹(蓝色的，文件夹和文件是不一样的)
    /// 创建文件夹(蓝色的，文件夹和文件是不一样的)
    /// - Parameter folderPath: 文件夹的路径
    /// - Returns: 返回创建的 创建文件夹路径
    @discardableResult
    static func createFolder(folderPath: String) -> (isSuccess: Bool, error: String) {
        guard !folderPath.isEmpty else {
            return (false, "文件夹路径不能为空")
        }
        
        if judgeFileOrFolderExists(filePath: folderPath) {
            return (true, "")
        }
        
        // 不存在的路径才会创建
        do {
            // withIntermediateDirectories为true表示路径中间如果有不存在的文件夹都会创建
            try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            return (true, "")
        } catch {
            TFYUtils.Logger.log("创建文件夹失败: \(error.localizedDescription)")
            return (false, "创建失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: 2.2、删除文件夹
    /// 删除文件夹
    /// - Parameter folderPath: 文件夹的路径
    @discardableResult
    static func removeFolder(folderPath: String) -> (isSuccess: Bool, error: String) {
        guard !folderPath.isEmpty else {
            return (false, "文件夹路径不能为空")
        }
        
        guard judgeFileOrFolderExists(filePath: folderPath) else {
            // 不存在就不做什么操作了
            return (true, "")
        }
        
        // 文件存在进行删除
        do {
            try fileManager.removeItem(atPath: folderPath)
            return (true, "")
        } catch {
            TFYUtils.Logger.log("删除文件夹失败: \(error.localizedDescription)")
            return (false, "删除失败: \(error.localizedDescription)")
        }
    }

    // MARK: 2.3、创建文件
    /// 创建文件
    /// - Parameter filePath: 文件路径
    /// - Returns: 返回创建的结果 和 路径
    @discardableResult
    static func createFile(filePath: String) -> (isSuccess: Bool, error: String) {
        guard !filePath.isEmpty else {
            return (false, "文件路径不能为空")
        }
        
        guard !judgeFileOrFolderExists(filePath: filePath) else {
            return (true, "")
        }
        
        // 不存在的文件路径才会创建
        // 确保父目录存在
        let directory = directoryAtPath(path: filePath)
        if !judgeFileOrFolderExists(filePath: directory) {
            let createDirResult = createFolder(folderPath: directory)
            if !createDirResult.isSuccess {
                return createDirResult
            }
        }
        
        // withIntermediateDirectories 为 true 表示路径中间如果有不存在的文件夹都会创建
        let createSuccess = fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        return (createSuccess, createSuccess ? "" : "创建文件失败")
    }
    
    // MARK: 2.4、删除文件
    /// 删除文件
    /// - Parameter filePath: 文件路径
    @discardableResult
    static func removeFile(filePath: String) -> (isSuccess: Bool, error: String) {
        guard !filePath.isEmpty else {
            return (false, "文件路径不能为空")
        }
        
        guard judgeFileOrFolderExists(filePath: filePath) else {
            // 不存在的文件路径就不需要要移除
            return (true, "")
        }
        
        // 移除文件
        do {
            try fileManager.removeItem(atPath: filePath)
            return (true, "")
        } catch {
            TFYUtils.Logger.log("删除文件失败: \(error.localizedDescription)")
            return (false, "删除文件失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: 2.5、读取文件内容
    /// 读取文件内容
    /// - Parameter filePath: 文件路径
    /// - Returns: 文件内容
    @discardableResult
    static func readFile(filePath: String) -> String? {
        guard !filePath.isEmpty, judgeFileOrFolderExists(filePath: filePath) else {
            return nil
        }
        
        guard let data = fileManager.contents(atPath: filePath) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: 2.6、把文字，图片，数组，字典写入文件
    /// 把文字，图片，数组，字典写入文件
    /// - Parameters:
    ///   - writeType: 写入类型
    ///   - content: 写入内容
    ///   - writePath: 写入路径
    /// - Returns: 写入的结果
    @discardableResult
    static func writeToFile(writeType: FileWriteType, content: Any, writePath: String) -> (isSuccess: Bool, error: String) {
        guard !writePath.isEmpty else {
            return (false, "写入路径不能为空")
        }
        
        guard judgeFileOrFolderExists(filePath: directoryAtPath(path: writePath)) else {
            // 不存在的文件路径
            return (false, "父目录不存在")
        }
        
        // 1、文字，2、图片，3、数组，4、字典写入文件
        switch writeType {
        case .textType:
            let info = "\(content)"
            do {
                // 文件可以追加
                // let stringToWrite = "\n" + string
                // 找到末尾位置并添加
                // fileHandle.seekToEndOfFile()
                try info.write(toFile: writePath, atomically: true, encoding: .utf8)
                return (true, "")
            } catch {
                TFYUtils.Logger.log("写入文本失败: \(error.localizedDescription)")
                return (false, "写入失败: \(error.localizedDescription)")
            }
        case .imageType:
            guard let data = content as? Data else {
                return (false, "图片数据格式错误")
            }
            do {
                try data.write(to: URL(fileURLWithPath: writePath))
                return (true, "")
            } catch {
                TFYUtils.Logger.log("写入图片失败: \(error.localizedDescription)")
                return (false, "写入失败: \(error.localizedDescription)")
            }
        case .arrayType:
            guard let array = content as? NSArray else {
                return (false, "数组格式错误")
            }
            let result = array.write(toFile: writePath, atomically: true)
            return (result, result ? "" : "写入失败")
        case .dictionaryType:
            guard let dictionary = content as? NSDictionary else {
                return (false, "字典格式错误")
            }
            let result = dictionary.write(toFile: writePath, atomically: true)
            return (result, result ? "" : "写入失败")
        case .dataType:
            guard let data = content as? Data else {
                return (false, "数据格式错误")
            }
            do {
                try data.write(to: URL(fileURLWithPath: writePath))
                return (true, "")
            } catch {
                TFYUtils.Logger.log("写入数据失败: \(error.localizedDescription)")
                return (false, "写入失败: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 2.7、从文件 读取 文字，图片，数组，字典
    /// 从文件 读取 文字，图片，数组，字典
    /// - Parameters:
    ///   - readType: 读取的类型
    ///   - readPath: 读取文件路径
    /// - Returns: 返回读取的内容
    @discardableResult
    static func readFromFile(readType: FileWriteType, readPath: String) -> (isSuccess: Bool, content: Any?, error: String) {
        guard !readPath.isEmpty, judgeFileOrFolderExists(filePath: readPath) else {
            return (false, nil, "文件不存在")
        }
        
        guard let readHandler = FileHandle(forReadingAtPath: readPath) else {
            return (false, nil, "无法打开文件")
        }
        
        defer {
            readHandler.closeFile()
        }
        
        let data = readHandler.readDataToEndOfFile()
        
        // 1、文字，2、图片，3、数组，4、字典
        switch readType {
        case .textType:
            guard let readString = String(data: data, encoding: .utf8) else {
                return (false, nil, "文本编码错误")
            }
            return (true, readString, "")
        case .imageType:
            guard let image = UIImage(data: data) else {
                return (false, nil, "图片数据错误")
            }
            return (true, image, "")
        case .arrayType:
            guard let readString = String(data: data, encoding: .utf8) else {
                return (false, nil, "读取内容失败")
            }
            return (true, readString.tfy.jsonStringToArray(), "")
        case .dictionaryType:
            guard let readString = String(data: data, encoding: .utf8) else {
                return (false, nil, "读取内容失败")
            }
            return (true, readString.tfy.jsonStringToDictionary(), "")
        case .dataType:
            return (true, data, "")
        }
    }
    
    // MARK: 2.8、拷贝(文件夹/文件)的内容 到另外一个(文件夹/文件)，新的(文件夹/文件)如果存在就先删除再 拷贝
    /**
     几个小注意点：
     1、目标路径，要带上文件夹名称，而不能只写父路径
     2、如果是覆盖拷贝，就是说目标路径已存在此文件夹，我们必须先删除，否则提示make directory error（当然这里最好做一个容错处理，比如拷贝前先转移到其他路径，如果失败，再拿回来）
     */
    /// 拷贝(文件夹/文件)的内容 到另外一个(文件夹/文件)，新的(文件夹/文件)如果存在就先删除再 拷贝
    /// - Parameters:
    ///   - type: 拷贝类型
    ///   - fromFilePath: 拷贝的(文件夹/文件)路径
    ///   - toFilePath: 拷贝后的(文件夹/文件)路径
    ///   - isOverwrite: 当要拷贝到的(文件夹/文件)路径存在，会拷贝失败，这里传入是否覆盖
    /// - Returns: 拷贝的结果
    @discardableResult
    static func copyFile(type: MoveOrCopyType, fromFilePath: String, toFilePath: String, isOverwrite: Bool = true) -> (isSuccess: Bool, error: String) {
        guard !fromFilePath.isEmpty, !toFilePath.isEmpty else {
            return (false, "路径不能为空")
        }
        
        // 1、先判断被拷贝路径是否存在
        guard judgeFileOrFolderExists(filePath: fromFilePath) else {
            return (false, "被拷贝的(文件夹/文件)路径不存在")
        }
        
        // 2、判断拷贝后的文件路径的前一个文件夹路径是否存在，不存在就进行创建
        let toFileFolderPath = directoryAtPath(path: toFilePath)
        if !judgeFileOrFolderExists(filePath: toFileFolderPath) {
            let createResult = type == .file ? createFile(filePath: toFilePath) : createFolder(folderPath: toFileFolderPath)
            if !createResult.isSuccess {
                return (false, "拷贝后路径前一个文件夹不存在")
            }
        }
        
        // 3、如果被拷贝的(文件夹/文件)已存在，先删除，否则拷贝不了
        if isOverwrite, judgeFileOrFolderExists(filePath: toFilePath) {
            do {
                try fileManager.removeItem(atPath: toFilePath)
            } catch {
                TFYUtils.Logger.log("删除目标文件失败: \(error.localizedDescription)")
                return (false, "删除目标文件失败")
            }
        }
        
        // 4、拷贝(文件夹/文件)
        do {
            try fileManager.copyItem(atPath: fromFilePath, toPath: toFilePath)
            return (true, "success")
        } catch {
            TFYUtils.Logger.log("拷贝失败: \(error.localizedDescription)")
            return (false, "拷贝失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: 2.9、移动(文件夹/文件)的内容 到另外一个(文件夹/文件)，新的(文件夹/文件)如果存在就先删除再 移动
    /// 移动(文件夹/文件)的内容 到另外一个(文件夹/文件)，新的(文件夹/文件)如果存在就先删除再 移动
    /// - Parameters:
    ///   - type: 移动类型
    ///   - fromFilePath: 被移动的文件路径
    ///   - toFilePath: 移动后的文件路径
    ///   - isOverwrite: 是否覆盖
    @discardableResult
    static func moveFile(type: MoveOrCopyType, fromFilePath: String, toFilePath: String, isOverwrite: Bool = true) -> (isSuccess: Bool, error: String) {
        guard !fromFilePath.isEmpty, !toFilePath.isEmpty else {
            return (false, "路径不能为空")
        }
        
        // 1、先判断被移动路径是否存在
        guard judgeFileOrFolderExists(filePath: fromFilePath) else {
            return (false, "被移动的(文件夹/文件)路径不存在")
        }
        
        // 2、判断移动后的文件路径的前一个文件夹路径是否存在，不存在就进行创建
        let toFileFolderPath = directoryAtPath(path: toFilePath)
        if !judgeFileOrFolderExists(filePath: toFileFolderPath) {
            let createResult = type == .file ? createFile(filePath: toFilePath) : createFolder(folderPath: toFileFolderPath)
            if !createResult.isSuccess {
                return (false, "移动后路径前一个文件夹不存在")
            }
        }
        
        // 3、如果被移动的(文件夹/文件)已存在，先删除，否则移动不了
        if isOverwrite, judgeFileOrFolderExists(filePath: toFilePath) {
            do {
                try fileManager.removeItem(atPath: toFilePath)
            } catch {
                TFYUtils.Logger.log("删除目标文件失败: \(error.localizedDescription)")
                return (false, "删除目标文件失败")
            }
        }
        
        // 4、移动(文件夹/文件)
        do {
            try fileManager.moveItem(atPath: fromFilePath, toPath: toFilePath)
            return (true, "success")
        } catch {
            TFYUtils.Logger.log("移动失败: \(error.localizedDescription)")
            return (false, "移动失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: 2.10、判断 (文件夹/文件) 是否存在
    /// 判断文件或文件夹是否存在
    /// - Parameter filePath: 文件路径
    /// - Returns: 是否存在
    static func judgeFileOrFolderExists(filePath: String) -> Bool {
        guard !filePath.isEmpty else { return false }
        return fileManager.fileExists(atPath: filePath)
    }
    
    // MARK: 2.11、获取 (文件夹/文件) 的前一个路径
    /// 获取 (文件夹/文件) 的前一个路径
    /// - Parameter path: (文件夹/文件) 的路径
    /// - Returns: (文件夹/文件) 的前一个路径
    static func directoryAtPath(path: String) -> String {
        guard !path.isEmpty else { return "" }
        return (path as NSString).deletingLastPathComponent
    }
    
    // MARK: 2.12、判断目录是否可读
    /// 判断目录是否可读
    /// - Parameter path: 路径
    /// - Returns: 是否可读
    static func judgeIsReadableFile(path: String) -> Bool {
        guard !path.isEmpty else { return false }
        return fileManager.isReadableFile(atPath: path)
    }
    
    // MARK: 2.13、判断目录是否可写
    /// 判断目录是否可写
    /// - Parameter path: 路径
    /// - Returns: 是否可写
    static func judgeIsWritableFile(path: String) -> Bool {
        guard !path.isEmpty else { return false }
        return fileManager.isWritableFile(atPath: path)
    }
    
    // MARK: 2.14、判断目录是否可执行
    /// 判断目录是否可执行
    /// - Parameter path: 路径
    /// - Returns: 是否可执行
    static func judgeIsExecutableFile(path: String) -> Bool {
        guard !path.isEmpty else { return false }
        return fileManager.isExecutableFile(atPath: path)
    }
    
    // MARK: 2.15、判断目录是否可删除
    /// 判断目录是否可删除
    /// - Parameter path: 路径
    /// - Returns: 是否可删除
    static func judgeIsDeletableFile(path: String) -> Bool {
        guard !path.isEmpty else { return false }
        return fileManager.isDeletableFile(atPath: path)
    }
    
    // MARK: 2.16、根据文件路径获取文件扩展类型
    /// 根据文件路径获取文件扩展类型
    /// - Parameter path: 文件路径
    /// - Returns: 文件扩展类型
    static func fileSuffixAtPath(path: String) -> String {
        guard !path.isEmpty else { return "" }
        return (path as NSString).pathExtension
    }
    
    // MARK: 2.17、根据文件路径获取文件名称，是否需要后缀
    /// 根据文件路径获取文件名称，是否需要后缀
    /// - Parameters:
    ///   - path: 文件路径
    ///   - suffix: 是否需要后缀，默认需要
    /// - Returns: 文件名称
    static func fileName(path: String, suffix: Bool = true) -> String {
        guard !path.isEmpty else { return "" }
        let fileName = (path as NSString).lastPathComponent
        guard suffix else {
            // 删除后缀
            return (fileName as NSString).deletingPathExtension
        }
        return fileName
    }
    
    // MARK: 2.18、对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表(只寻找一层)
    /// 对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表(只寻找一层)
    /// - Parameter folderPath: 搜索的路径
    /// - Returns: 指定目录路径下的文件、子目录及符号链接的列表
    static func shallowSearchAllFiles(folderPath: String) -> [String]? {
        guard !folderPath.isEmpty, judgeFileOrFolderExists(filePath: folderPath) else {
            return nil
        }
        
        do {
            let contentsOfDirectoryArray = try fileManager.contentsOfDirectory(atPath: folderPath)
            return contentsOfDirectoryArray
        } catch {
            TFYUtils.Logger.log("浅搜索失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 2.19、深度遍历，会递归遍历子文件夹（包括符号链接，所以要求性能的话用enumeratorAtPath）
    /// 深度遍历，会递归遍历子文件夹（包括符号链接，所以要求性能的话用enumeratorAtPath）
    /// - Parameter folderPath: 文件夹路径
    /// - Returns: 所有文件路径数组
    static func getAllFileNames(folderPath: String) -> [String]? {
        guard !folderPath.isEmpty, judgeFileOrFolderExists(filePath: folderPath) else {
            return nil
        }
        
        guard let subPaths = fileManager.subpaths(atPath: folderPath) else {
            return nil
        }
        return subPaths
    }
    
    // MARK: 2.20、深度遍历，会递归遍历子文件夹（但不会递归符号链接）
    /// 对指定路径深度遍历，会递归遍历子文件夹（但不会递归符号链接）
    /// - Parameter folderPath: 文件夹路径
    /// - Returns: 所有文件路径数组
    static func deepSearchAllFiles(folderPath: String) -> [Any]? {
        guard !folderPath.isEmpty, judgeFileOrFolderExists(filePath: folderPath) else {
            return nil
        }
        
        guard let contentsOfPathArray = fileManager.enumerator(atPath: folderPath) else {
            return nil
        }
        return contentsOfPathArray.allObjects
    }
    
    // MARK: 2.21、计算单个 (文件夹/文件) 的大小，单位为字节(bytes) （没有进行转换的）
    /// 计算单个 (文件夹/文件) 的大小，单位为字节 （没有进行转换的）
    /// - Parameter filePath: (文件夹/文件) 路径
    /// - Returns: 单个文件或文件夹的大小
    static func fileOrDirectorySingleSize(filePath: String) -> UInt64 {
        guard !filePath.isEmpty, judgeFileOrFolderExists(filePath: filePath) else {
            return 0
        }
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: filePath)
            guard let fileSizeValue = fileAttributes[.size] as? UInt64 else {
                return 0
            }
            return fileSizeValue
        } catch {
            TFYUtils.Logger.log("获取文件大小失败: \(error.localizedDescription)")
            return 0
        }
    }
    
    //MARK: 2.22、计算 (文件夹/文件) 的大小（转换过的）
    /// 计算 (文件夹/文件) 的大小
    /// - Parameter path: (文件夹/文件) 的路径
    /// - Returns: (文件夹/文件) 的大小
    static func fileOrDirectorySize(path: String) -> String {
        guard !path.isEmpty, fileManager.fileExists(atPath: path) else {
            return "0MB"
        }
        
        // (文件夹/文件) 的实际大小
        var fileSize: UInt64 = 0
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files {
                let filePath = path + "/\(file)"
                fileSize += fileOrDirectorySingleSize(filePath: filePath)
            }
        } catch {
            fileSize += fileOrDirectorySingleSize(filePath: path)
        }
        
        // 转换后的大小 ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        return covertUInt64ToString(with: fileSize)
    }

    // MARK: 2.23、获取(文件夹/文件)属性集合
    ///  获取(文件夹/文件)属性集合
    /// - Parameter path: (文件夹/文件)路径
    /// - Returns: (文件夹/文件)属性集合
    @discardableResult
    static func fileAttributes(path: String) -> [FileAttributeKey : Any]? {
        guard !path.isEmpty, judgeFileOrFolderExists(filePath: path) else {
            return nil
        }
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            return attributes
        } catch {
            TFYUtils.Logger.log("获取文件属性失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 2.24、文件/文件夹比较 是否一样
    /// 文件/文件夹比较 是否一样
    /// - Parameters:
    ///   - filePath1: 文件路径1
    ///   - filePath2: 文件路径2
    /// - Returns: 是否相同
    static func isEqual(filePath1: String, filePath2: String) -> Bool {
        guard !filePath1.isEmpty, !filePath2.isEmpty else {
            return false
        }
        
        // 先判断是否存在路径
        guard judgeFileOrFolderExists(filePath: filePath1), judgeFileOrFolderExists(filePath: filePath2) else {
            return false
        }
        
        // 下面比较用户文档中前面两个文件是否内容相同（该方法也可以用来比较目录）
        return fileManager.contentsEqual(atPath: filePath1, andPath: filePath2)
    }
    
    // MARK: 2.25、获取文件创建时间
    /// 获取文件创建时间
    /// - Parameter path: 文件路径
    /// - Returns: 创建时间
    static func fileCreationDate(path: String) -> Date? {
        guard let attributes = fileAttributes(path: path) else {
            return nil
        }
        return attributes[.creationDate] as? Date
    }
    
    // MARK: 2.26、获取文件修改时间
    /// 获取文件修改时间
    /// - Parameter path: 文件路径
    /// - Returns: 修改时间
    static func fileModificationDate(path: String) -> Date? {
        guard let attributes = fileAttributes(path: path) else {
            return nil
        }
        return attributes[.modificationDate] as? Date
    }
    
    // MARK: 2.27、获取文件所有者
    /// 获取文件所有者
    /// - Parameter path: 文件路径
    /// - Returns: 所有者名称
    static func fileOwnerAccountName(path: String) -> String? {
        guard let attributes = fileAttributes(path: path) else {
            return nil
        }
        return attributes[.ownerAccountName] as? String
    }
    
    // MARK: 2.28、获取文件权限
    /// 获取文件权限
    /// - Parameter path: 文件路径
    /// - Returns: 权限值
    static func filePosixPermissions(path: String) -> Int? {
        guard let attributes = fileAttributes(path: path) else {
            return nil
        }
        return attributes[.posixPermissions] as? Int
    }
}

// MARK: fileprivate
public extension TFY where Base: FileManager {
    
    // MARK: 计算文件大小：UInt64 -> String
    /// 计算文件大小：UInt64 -> String
    /// - Parameter size: 文件的大小
    /// - Returns: 转换后的文件大小
    static func covertUInt64ToString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        
        while convertedValue > 1024 && multiplyFactor < tokens.count - 1 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
}

// MARK: - 三、有关视频缩略图获取的扩展
// 视频URL的类型
enum TFYVideoUrlType: Int, CaseIterable {
    // 本地
    case local
    // 服务器
    case server
}

public extension TFY where Base: FileManager {
    
    // MARK: 3.1、通过本地(沙盒)视频文件路径获取截图
    /// 通过本地(沙盒)视频文件路径获取截图
    /// - Parameters:
    ///   - videoPath: 视频在沙盒的路径
    ///   - preferredTrackTransform: 缩略图的方向
    /// - Returns: 视频的缩略图
    static func getLocalVideoImage(videoPath: String, preferredTrackTransform: Bool = true) -> UIImage? {
        guard !videoPath.isEmpty, judgeFileOrFolderExists(filePath: videoPath) else {
            return nil
        }
        
        //  获取截图
        let videoImage = getVideoImage(videoUrlSouceType: .local, path: videoPath, seconds: 1, preferredTimescale: 10, maximumSize: nil, preferredTrackTransform: preferredTrackTransform)
        return videoImage
    }
    
    // MARK: 3.2、通过本地(沙盒)视频文件路径数组获取截图数组
    /// 通过本地(沙盒)视频文件路径数组获取截图数组
    /// - Parameters:
    ///   - videoPaths: 视频在沙盒的路径数组
    ///   - preferredTrackTransform: 缩略图的方向
    /// - Returns: 视频的缩略图数组
    static func getLocalVideoImages(videoPaths: [String], preferredTrackTransform: Bool = true) -> [UIImage?] {
        guard !videoPaths.isEmpty else {
            return []
        }
        
        //  获取截图
        var allImageArray: [UIImage?] = []
        for path in videoPaths {
            let videoImage = getVideoImage(videoUrlSouceType: .local, path: path, seconds: 1, preferredTimescale: 10, maximumSize: nil, preferredTrackTransform: preferredTrackTransform)
            allImageArray.append(videoImage)
        }
        return allImageArray
    }
    
    // MARK: 3.3、通过网络视频文件路径获取截图
    /// 通过网络视频文件路径获取截图
    /// - Parameters:
    ///   - videoPath: 视频在沙盒的路径
    ///   - videoImage: 回调图片
    ///   - preferredTrackTransform: 缩略图的方向
    static func getServerVideoImage(videoPath: String, videoImage: @escaping (UIImage?) -> Void, preferredTrackTransform: Bool = true) {
        guard !videoPath.isEmpty else {
            videoImage(nil)
            return
        }
        
        //异步获取网络视频缩略图，由于网络请求比较耗时，所以我们把获取在线视频的相关代码写在异步线程里
        DispatchQueue.global().async {
            //  获取截图
            let image = getVideoImage(videoUrlSouceType: .server, path: videoPath, seconds: 1, preferredTimescale: 10, maximumSize: nil, preferredTrackTransform: preferredTrackTransform)
            DispatchQueue.main.async {
                videoImage(image)
            }
        }
    }
    
    // MARK: 3.4、通过网络视频文件路径数组获取截图数组
    /// 通过网络视频文件路径数组获取截图数组
    /// - Parameters:
    ///   - videoPaths: 视频在沙盒的路径数组
    ///   - videoImages: 回调图片数组
    ///   - preferredTrackTransform: 缩略图的方向
    static func getServerVideoImages(videoPaths: [String], videoImages: @escaping ([UIImage?]) -> Void, preferredTrackTransform: Bool = true) {
        guard !videoPaths.isEmpty else {
            videoImages([])
            return
        }
        
        //异步获取网络视频缩略图，由于网络请求比较耗时，所以我们把获取在线视频的相关代码写在异步线程里
        DispatchQueue.global().async {
            //  获取截图
            var allImageArray: [UIImage?] = []
            for path in videoPaths {
                let videoImage = getVideoImage(videoUrlSouceType: .server, path: path, seconds: 1, preferredTimescale: 10, maximumSize: nil, preferredTrackTransform: preferredTrackTransform)
                allImageArray.append(videoImage)
            }
            DispatchQueue.main.async {
                videoImages(allImageArray)
            }
        }
    }
   
    // MARK: 获取视频缩略图的共有方法
    /// 获取视频缩略图的共有方法
    /// - Parameters:
    ///   - videoUrlSouceType: 视频来源类型
    ///   - path: 本地路径或者网络视频连接
    ///   - seconds: 取第几秒
    ///   - preferredTimescale: 一秒钟几帧
    ///   - maximumSize: 设置图片的最大size(分辨率)
    ///   - preferredTrackTransform: 设定缩略图的方向，如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
    /// - Returns: 返回获取的图片
    private static func getVideoImage(videoUrlSouceType: TFYVideoUrlType = .local, path: String, seconds: Double = 1, preferredTimescale: CMTimeScale = 10, maximumSize: CGSize?, preferredTrackTransform: Bool = true) -> UIImage? {
        guard !path.isEmpty else {
            return nil
        }
        
        var videoURL: URL?
        
        if videoUrlSouceType == .local {
            videoURL = URL(fileURLWithPath: path)
        } else {
            guard let url = URL(string: path) else {
                return nil
            }
            videoURL = url
        }
        
        guard let weakVideoURL = videoURL else {
            return nil
        }
        
        let videoAsset = AVURLAsset(url: weakVideoURL)
        let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
        
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        imageGenerator.appliesPreferredTrackTransform = preferredTrackTransform
        
        // 设置图片的最大size(分辨率)
        if let size = maximumSize {
            imageGenerator.maximumSize = size
        }
        
        // 取第几秒，一秒钟几帧
        let cmTime = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
        
        do {
            let cgImg = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
            let img = UIImage(cgImage: cgImg)
            return img
        } catch {
            TFYUtils.Logger.log("获取缩略图失败: \(error.localizedDescription)")
            return nil
        }
    }
}

