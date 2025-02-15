//
//  WKScriptHandlerParamsDecoder
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation

extension WKScriptHandlerParamsDecoder {
    
    struct UnkeyedContainer : UnkeyedDecodingContainer {
        
        let list:NSArray
        ///在编码中到达这个点的编码键的路径。
        public let codingPath:[CodingKey]
        
        init(_ value:NSArray, key:CodingKey? = nil, path:[CodingKey] = []) throws {
            var pathList:[CodingKey] = path
            if let last = key {
                pathList.append(last)
            }
            list = value
            codingPath = pathList
        }
        
        var index:Int = 0
        
        mutating func next() throws -> (CodingKey, Any) {
            if index >= list.count {
                throw DecodingError.dataCorruptedError(in: self, debugDescription: "index: \(index) out of range 0..<\(list.count)")
            }
            defer { index += 1 }
            return (IndexKey(intValue: index), list[index])
        }
        
        // MARK: - UnkeyedDecodingContainer

        ///容器中包含的元素的数量。
        ///
        ///如果元素的数量未知，则值为' nil '。
        public var count: Int? { return list.count }
        
        ///一个布尔值，指示容器中是否没有其他需要解码的元素。
        public var isAtEnd: Bool { return index >= list.count }
        
        ///容器的当前解码索引(即下一个要解码的元素的索引)。
        ///每次成功解码后递增。
        public var currentIndex: Int { return index }
        
        mutating func decode<Number>(_ type: Number.Type) throws -> NSNumber {
            let (key, body) = try next()
            let container = ValueContainer(body, path: codingPath + [key])
            return try container.decode(type)
        }
        
        ///解码空值。
        ///
        ///如果不为null，则不增加currentIndex的值。
        ///
        /// -返回:遇到的值是否为空。
        /// -抛出:' DecodingError. 'valueNotFound '，如果没有更多的值要解码。
        public mutating func decodeNil() throws -> Bool {
            let (_, body) = try next()
            switch body {
            case _ as NSNull:   return true
            default:            break
            }
            index -= 1
            return false
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Bool.Type) throws -> Bool {
            let (key, body) = try next()
            
            let container = ValueContainer(body, path: codingPath + [key])
            return try container.decode(type)
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Int.Type) throws -> Int {
            return try decode(type).intValue
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Int8.Type) throws -> Int8 {
            return try decode(type).int8Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Int16.Type) throws -> Int16 {
            return try decode(type).int16Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Int32.Type) throws -> Int32 {
            return try decode(type).int32Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Int64.Type) throws -> Int64 {
            return try decode(type).int64Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: UInt.Type) throws -> UInt {
            return try decode(type).uintValue
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try decode(type).uint8Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try decode(type).uint16Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try decode(type).uint32Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try decode(type).uint64Value
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Float.Type) throws -> Float {
            return try decode(type).floatValue
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: Double.Type) throws -> Double {
            return try decode(type).doubleValue
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode(_ type: String.Type) throws -> String {
            let (key, body) = try next()
            
            let container = ValueContainer(body, path: codingPath + [key])
            return try container.decode(type)
        }
        
        ///解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let (key, body) = try next()
            let decoder = try WKScriptHandlerParamsDecoder(body, path: codingPath + [key])
            return try T(from: decoder)
        }
        
        ///解码指定类型的嵌套容器。
        ///
        /// - parameter type:用于容器的键类型。
        /// -返回:一个键控解码的容器视图到' self '。
        /// -抛出:' DecodingError. '如果遇到的存储值不是一个带键的容器，则使用typeMismatch '。
        public mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let (key, body) = try next()
            switch body {
            case let obj as NSDictionary:
                let container = KeyedContainer<NestedKey>(obj, key:key, path: codingPath)
                return KeyedDecodingContainer<NestedKey>(container)
            default: break
            }
            let context = DecodingError.Context(codingPath: codingPath + [key], debugDescription: "not dictionary")
            throw DecodingError.typeMismatch(type, context)
        }
        
        ///解码非键嵌套容器。
        ///
        /// -返回:一个非键解码的容器视图到' self '。
        /// -抛出:' DecodingError. '如果遇到的存储值不是非键容器，则使用typeMismatch '。
        public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let (key, body) = try next()
            switch body {
            case let value as NSArray: return try UnkeyedContainer(value, path: codingPath + [key])
            default: break
            }
            let context = DecodingError.Context(codingPath: codingPath + [key], debugDescription: "not array")
            throw DecodingError.typeMismatch(NSArray.self, context)

        }
        
        ///解码嵌套容器并返回一个' Decoder '实例，用于解码该容器中的' super '。
        ///
        /// -返回:一个新的' Decoder '传递给' super.init(from:) '。
        /// -抛出:' DecodingError. 'valueNotFound '，如果遇到的编码值为空，或没有更多的值要解码。
        public mutating func superDecoder() throws -> Decoder {
            let (key, body) = try next()
            return try WKScriptHandlerParamsDecoder(body, path: codingPath + [key])
        }
    }
}
