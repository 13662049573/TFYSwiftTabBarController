//
//  WKScriptHandlerParamsDecoder
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation

public struct WKScriptHandlerParamsDecoder : Decoder {
    
    let body:Any
    
    ///在编码中到达这个点的编码键的路径。
    public let codingPath:[CodingKey]
    
    init(_ value:Any, key:CodingKey? = nil, path:[CodingKey] = []) throws {
        var list:[CodingKey] = path
        if let last = key { list.append(last) }
        codingPath = list
        body = value
    }
    
    ///用户为编码设置的上下文信息。
    public var userInfo: [CodingUserInfoKey : Any] { return [:] }
    
    ///返回存储在该解码器中的数据，表示为适合保存无键值的容器。
    ///
    ///返回:一个非键容器视图到这个解码器。
    /// -抛出:' DecodingError. '如果遇到的存储值不是非键容器，则使用typeMismatch '。
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch body {
        case let list as NSArray: return try UnkeyedContainer(list, path: codingPath)
        default:
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "value not array")
            throw DecodingError.typeMismatch(NSArray.self, context)
        }
        
    }
    
    ///返回存储在该解码器中的数据，表示为适合保存单个原语值的容器。
    ///
    ///返回:一个单值容器视图到这个解码器。
    /// -抛出:' DecodingError. '如果遇到的存储值不是单个值容器，则使用typeMismatch '。
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return ValueContainer(body, path: codingPath)
    }
    
    ///返回存储在该解码器中的数据，该数据在给定键类型的容器中表示。
    ///
    /// - parameter type:用于容器的键类型。
    ///返回:一个键控解码容器视图到这个解码器。
    /// -抛出:' DecodingError. '如果遇到的存储值不是一个带键的容器，则使用typeMismatch '。
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        switch body {
        case let obj as NSDictionary:
            return KeyedDecodingContainer<Key>(KeyedContainer<Key>(obj, path: codingPath))
        default:
            return KeyedDecodingContainer<Key>(KeyedUnknowContainer<Key>(body, path: codingPath))
        }
    }
    
}
