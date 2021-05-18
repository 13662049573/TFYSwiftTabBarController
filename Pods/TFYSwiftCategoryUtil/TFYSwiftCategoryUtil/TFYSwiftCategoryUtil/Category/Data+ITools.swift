//
//  Data+ITools.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/16.
//

import UIKit

extension Data: TFYCompatible {}
// MARK:- 一、基本的扩展
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
    
}
