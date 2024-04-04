//
//  Codable+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/19.
//

import Foundation
import UIKit

public protocol TFYCoadble: Codable{
    func toDict()->Dictionary<String, Any>?
    func toData()->Data?
    func toString()->String?
}

public extension TFYCoadble {
    
    func toData()->Data?{
        return try? JSONEncoder().encode(self)
    }
    
    func toDict()->Dictionary<String, Any>? {
        if let data = toData(){
            do{
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            }catch{
                 debugPrint(error.localizedDescription)
                return nil
            }
        }else{
            debugPrint("model to data error")
            return nil
        }
    }
    func toString()->String?{
        if let data = try? JSONEncoder().encode(self),let x = String.init(data: data, encoding: .utf8){
            return x
        }else{
            return nil
        }
    }
}

