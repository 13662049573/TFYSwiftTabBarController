//
//  Data+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/18.
//

import Foundation
import UIKit

extension Data: TFYCompatible {}

public extension TFY where Base == Data {
    
    // MARK: 1.1、base64编码成 Data
    /// 编码
    var encodeToData: Data? {
        return base.base64EncodedData()
    }
    
    // MARK: 1.2、base64解码成 Data
    /// 解码成 Data
    var decodeToDada: Data? {
        return Data(base64Encoded: base)
    }
    
    /// 转 string
    func toString(encoding: String.Encoding) -> String? {
        return String(data: base, encoding: encoding)
    }
    
    func toBytes()->[UInt8]{
        return [UInt8](base)
    }
    
    func toDict()->Dictionary<String, Any>? {
        do{
            return try JSONSerialization.jsonObject(with: base, options: .allowFragments) as? [String: Any]
        }catch{
            TFYLog(error.localizedDescription)
            return nil
        }
    }
    /// 从给定的JSON数据返回一个基础对象。
    func toObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: base, options: options)
    }
    /// 指定Model类型
    func toModel<T>(_ type:T.Type) -> T? where T:Decodable {
        do {
            return try JSONDecoder().decode(type, from: base)
        } catch  {
            TFYLog("data to model error")
            return nil
        }
    }
    
    func utf8String() -> String {
        if base.count > 0 {
            return String(data: base, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    func jsonValueDecoded() -> Any? {
        do {
            let value = try JSONSerialization.jsonObject(with: base, options: .allowFragments)
            return value
        } catch let error {
            print("jsonValueDecoded error:%@", error)
        }
        return nil
    }
}
