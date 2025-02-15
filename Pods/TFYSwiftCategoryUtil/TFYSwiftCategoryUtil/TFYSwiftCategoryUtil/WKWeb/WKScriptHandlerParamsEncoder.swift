//
//  WKScriptHandlerParamsEncoder
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//
import Foundation

public class WKScriptHandlerParamsEncoder : Decoder {
    
    public enum ParamsType {
        case none
        case value
        case array
        case more
    }
    
    
    var type:ParamsType = .none
    var params:[String] = []
    var paramsCount:Int {
        switch type {
        case .none:     return 0
        case .array:    return 1
        case .value:    return 1
        case .more:     return params.count
        }
    }

    init(path:[CodingKey] = []) throws {
        codingPath = path
    }
    
    public func append(_ value:String) {
        if !codingPath.isEmpty { return }
        params.append(value)
    }
    
    
    ///在编码中到达这个点的编码键的路径。
    public let codingPath:[CodingKey]
    ///用户为编码设置的上下文信息。
    public var userInfo: [CodingUserInfoKey : Any] { return [:] }

    ///返回存储在该解码器中的数据，表示为适合保存无键值的容器。
    ///
    ///返回:一个非键容器视图到这个解码器。
    /// -抛出:' DecodingError. '如果遇到的存储值不是非键容器，则使用typeMismatch '。
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        type = .array
        return UnkeyedContainer(self, path: codingPath)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        type = .value
        return ValueContainer(self, path: codingPath)
    }
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer<Key>(KeyedContainer<Key>(self, path: codingPath))
    }
    
}


