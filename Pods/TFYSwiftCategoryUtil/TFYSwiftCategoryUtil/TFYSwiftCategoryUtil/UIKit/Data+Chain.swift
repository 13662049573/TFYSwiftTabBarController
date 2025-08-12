//
//  Data+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit
import CommonCrypto

public extension Data {
    
    // MARK: 1.1、base64编码成 Data
    /// base64编码成Data
    /// - Returns: base64编码后的Data，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var encodeToData: Data? {
        return self.base64EncodedData()
    }
    
    // MARK: 1.2、base64解码成 Data
    /// base64解码成Data
    /// - Returns: base64解码后的Data，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var decodeToData: Data? {
        return Data(base64Encoded: self)
    }
    
    // MARK: 1.3、转换为字符串
    /// 转换为字符串
    /// - Parameter encoding: 字符串编码
    /// - Returns: 转换后的字符串，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toString(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    // MARK: 1.4、转换为字节数组
    /// 转换为字节数组
    /// - Returns: 字节数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toBytes() -> [UInt8] {
        return [UInt8](self)
    }
    
    // MARK: 1.5、转换为字典
    /// 转换为字典
    /// - Returns: 字典，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toDict() -> Dictionary<String, Any>? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        } catch {
            TFYUtils.Logger.log("Data toDict error: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 1.6、从给定的JSON数据返回一个基础对象
    /// 从给定的JSON数据返回一个基础对象
    /// - Parameter options: 读取选项
    /// - Throws: 解析失败抛出异常
    /// - Returns: 解析后的对象
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    
    // MARK: 1.7、指定Model类型
    /// 指定Model类型
    /// - Parameter type: 解码的类型
    /// - Returns: 解码后的模型，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toModel<T>(_ type: T.Type) -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            TFYUtils.Logger.log("Data to model error: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 1.8、转换为UTF8字符串
    /// 转换为UTF8字符串
    /// - Returns: UTF8字符串，失败返回空字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func utf8String() -> String {
        if self.count > 0 {
            return String(data: self, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    // MARK: 1.9、JSON解码为对象
    /// JSON解码为对象
    /// - Returns: 解码后的对象，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func jsonValueDecoded() -> Any? {
        do {
            let value = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            return value
        } catch let error {
            TFYUtils.Logger.log("jsonValueDecoded error: \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: 1.10、压缩数据
    /// 压缩数据
    /// - Returns: 压缩后的数据，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func compress() -> Data? {
        guard !self.isEmpty else { return nil }
        
        do {
            let compressedData = try (self as NSData).compressed(using: .lzfse)
            return compressedData as Data
        } catch {
            TFYUtils.Logger.log("Data compression error: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 1.11、解压数据
    /// 解压数据
    /// - Returns: 解压后的数据，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func decompress() -> Data? {
        guard !self.isEmpty else { return nil }
        
        do {
            let decompressedData = try (self as NSData).decompressed(using: .lzfse)
            return decompressedData as Data
        } catch {
            TFYUtils.Logger.log("Data decompression error: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: 1.13、计算SHA256哈希
    /// 计算SHA256哈希
    /// - Returns: SHA256哈希字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func sha256() -> String {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        _ = self.withUnsafeBytes { body -> String in
            CC_SHA256(body.baseAddress, CC_LONG(self.count), &digest)
            return ""
        }
        
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    // MARK: 1.14、转换为图片
    /// 转换为图片
    /// - Returns: UIImage对象，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toImage() -> UIImage? {
        return UIImage(data: self)
    }
    
    // MARK: 1.15、获取文件大小描述
    /// 获取文件大小描述
    /// - Returns: 格式化的大小字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func sizeDescription() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(self.count))
    }
    
    // MARK: 1.16、检查是否为图片数据
    /// 检查是否为图片数据
    /// - Returns: 如果是图片数据返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isImageData: Bool {
        return UIImage(data: self) != nil
    }
    
    // MARK: 1.17、检查是否为JSON数据
    /// 检查是否为JSON数据
    /// - Returns: 如果是有效的JSON数据返回true
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var isJSONData: Bool {
        do {
            _ = try JSONSerialization.jsonObject(with: self, options: [])
            return true
        } catch {
            return false
        }
    }
    
    // MARK: 1.18、转换为十六进制字符串
    /// 转换为十六进制字符串
    /// - Returns: 十六进制字符串
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func toHexString() -> String {
        return self.map { String(format: "%02x", $0) }.joined()
    }
    
    // MARK: 1.19、从十六进制字符串创建Data
    /// 从十六进制字符串创建Data
    /// - Parameter hexString: 十六进制字符串
    /// - Returns: Data对象，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func fromHexString(_ hexString: String) -> Data? {
        guard hexString.count % 2 == 0 else { return nil }
        
        var data = Data()
        var index = hexString.startIndex
        
        while index < hexString.endIndex {
            let nextIndex = hexString.index(index, offsetBy: 2)
            let byteString = String(hexString[index..<nextIndex])
            
            guard let byte = UInt8(byteString, radix: 16) else { return nil }
            data.append(byte)
            
            index = nextIndex
        }
        
        return data
    }
    
    // MARK: 1.20、安全的数据切片
    /// 安全的数据切片
    /// - Parameters:
    ///   - start: 起始位置
    ///   - end: 结束位置
    /// - Returns: 切片后的数据，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func safeSubdata(from start: Int, to end: Int) -> Data? {
        guard start >= 0, end <= self.count, start < end else { return nil }
        return self.subdata(in: start..<end)
    }
}

// MARK: - 二、Data扩展的便利方法
public extension Data {
    
    // MARK: 2.1、追加数据
    /// 追加数据
    /// - Parameter data: 要追加的数据
    /// - Returns: 追加后的数据
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func appending(_ data: Data) -> Data {
        var result = self
        result.append(data)
        return result
    }
    
    // MARK: 2.2、插入数据
    /// 插入数据
    /// - Parameters:
    ///   - data: 要插入的数据
    ///   - at: 插入位置
    /// - Returns: 插入后的数据，失败返回原数据
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func inserting(_ data: Data, at index: Int) -> Data {
        guard index >= 0, index <= self.count else { return self }
        
        var result = self
        result.insert(contentsOf: data, at: index)
        return result
    }
    
    // MARK: 2.3、替换数据
    /// 替换数据
    /// - Parameters:
    ///   - data: 要替换的数据
    ///   - range: 替换范围
    /// - Returns: 替换后的数据，失败返回原数据
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func replacing(with data: Data, in range: Range<Int>) -> Data {
        guard range.lowerBound >= 0, range.upperBound <= self.count else { return self }
        
        var result = self
        result.replaceSubrange(range, with: data)
        return result
    }
}

// MARK: - 三、Data的加密扩展
public extension Data {
    
    // MARK: 3.1、AES加密
    /// AES加密
    /// - Parameters:
    ///   - key: 密钥
    ///   - iv: 初始化向量
    /// - Returns: 加密后的数据，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func aesEncrypt(key: Data, iv: Data) -> Data? {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES192 || key.count == kCCKeySizeAES256,
              iv.count == kCCBlockSizeAES128 else {
            TFYUtils.Logger.log("AES加密参数错误")
            return nil
        }
        
        let dataLength = self.count
        let cryptLength = size_t(dataLength + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        
        let keyLength = size_t(key.count)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            self.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    iv.withUnsafeBytes { ivBytes in
                        CCCrypt(CCOperation(kCCEncrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes.baseAddress,
                                keyLength,
                                ivBytes.baseAddress,
                                dataBytes.baseAddress,
                                dataLength,
                                cryptBytes.baseAddress,
                                cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else {
            TFYUtils.Logger.log("AES加密失败: \(cryptStatus)")
            return nil
        }
        
        cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        return cryptData
    }
    
    // MARK: 3.2、AES解密
    /// AES解密
    /// - Parameters:
    ///   - key: 密钥
    ///   - iv: 初始化向量
    /// - Returns: 解密后的数据，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func aesDecrypt(key: Data, iv: Data) -> Data? {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES192 || key.count == kCCKeySizeAES256,
              iv.count == kCCBlockSizeAES128 else {
            TFYUtils.Logger.log("AES解密参数错误")
            return nil
        }
        
        let dataLength = self.count
        let cryptLength = size_t(dataLength + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        
        let keyLength = size_t(key.count)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            self.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    iv.withUnsafeBytes { ivBytes in
                        CCCrypt(CCOperation(kCCDecrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes.baseAddress,
                                keyLength,
                                ivBytes.baseAddress,
                                dataBytes.baseAddress,
                                dataLength,
                                cryptBytes.baseAddress,
                                cryptLength,
                                &numBytesDecrypted)
                    }
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else {
            TFYUtils.Logger.log("AES解密失败: \(cryptStatus)")
            return nil
        }
        
        cryptData.removeSubrange(numBytesDecrypted..<cryptData.count)
        return cryptData
    }
}
