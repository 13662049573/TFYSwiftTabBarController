//
//  TFYLog.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit

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
