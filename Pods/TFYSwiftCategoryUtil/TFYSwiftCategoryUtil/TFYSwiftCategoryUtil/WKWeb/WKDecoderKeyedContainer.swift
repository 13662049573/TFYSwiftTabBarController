//
//  WKScriptHandlerParamsDecoder
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation

extension CodingKey {
    
    public static func ==(lhs:Self, rhs:Self) -> Bool {
        return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
    }
}


extension WKScriptHandlerParamsDecoder {
    
    struct KeyedUnknowContainer <K> : KeyedDecodingContainerProtocol where K : CodingKey {
        typealias Key = K
        
        let body:Any
        /// The path of coding keys taken to get to this point in decoding.
        let codingPath:[CodingKey]
        
        init(_ value:Any, key:CodingKey? = nil, path:[CodingKey] = []) {
            var pathList:[CodingKey] = path
            if let last = key { pathList.append(last) }
            codingPath = pathList
            body = value
        }
        
        /// ' Decoder '中包含的这个容器的所有键。
        ///
        ///来自相同' Decoder '的不同键值容器可能会返回不同的键值;可以使用多个不能相互转换的键类型进行编码。这应该报告所有可转换为请求类型的键。
        var allKeys: [K] { return [] }
        
        
        ///返回一个布尔值，指示解码器是否包含与给定键相关的值。
        ///
        ///与' key '相关联的值可能是一个空值，以适合的数据格式。
        ///
        /// - parameter key:要搜索的键。
        /// -返回:' Decoder '是否有给定键的条目。
        func contains(_ key: K) -> Bool { return true }
        
        ///为给定的键解码空值。
        ///
        /// - parameter key:被解码的值所关联的键。
        /// -返回:遇到的值是否为空。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        func decodeNil(forKey key: K) throws -> Bool { return true }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
            let container = ValueContainer(body, key: key, path: codingPath)
            return try container.decode(type)
        }
        
        func decode<Number>(_ type: Number.Type, forKey key: K) throws -> NSNumber {
            let container = ValueContainer(body, key: key, path: codingPath)
            return try container.decode(type)
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int.Type, forKey key: K) throws -> Int {
            return try decode(NSNumber.self, forKey: key).intValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
            return try decode(NSNumber.self, forKey: key).int8Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
            return try decode(NSNumber.self, forKey: key).int16Value
        }
        
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
            return try decode(NSNumber.self, forKey: key).int32Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
            return try decode(NSNumber.self, forKey: key).int64Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
            return try decode(NSNumber.self, forKey: key).uintValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
            return try decode(NSNumber.self, forKey: key).uint8Value
        }
        
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
            return try decode(NSNumber.self, forKey: key).uint16Value
        }
        
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
            return try decode(NSNumber.self, forKey: key).uint32Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
            return try decode(NSNumber.self, forKey: key).uint64Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Float.Type, forKey key: K) throws -> Float {
            return try decode(NSNumber.self, forKey: key).floatValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Double.Type, forKey key: K) throws -> Double {
            return try decode(NSNumber.self, forKey: key).doubleValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: String.Type, forKey key: K) throws -> String {
            let container = ValueContainer(body, key: key, path: codingPath)
            return try container.decode(type)
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
            let decoder = try WKScriptHandlerParamsDecoder(body, key: key, path: codingPath)
            return try T(from: decoder)
        }
        
        ///返回存储在给定键类型的容器中的数据。
        ///
        /// - parameter type:用于容器的键类型。
        /// - parameter key:嵌套容器所关联的键。
        /// -返回:一个键控解码的容器视图到' self '。
        /// -抛出:' DecodingError. '如果遇到的存储值不是一个带键的容器，则使用typeMismatch '。
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let container = KeyedUnknowContainer<NestedKey>(body, key:key, path: codingPath)
            return KeyedDecodingContainer<NestedKey>(container)
        }
        
        ///返回为给定键存储的数据，在一个非键容器中表示。
        ///
        /// - parameter key:嵌套容器所关联的键。
        /// -返回:一个非键解码的容器视图到' self '。
        /// -抛出:' DecodingError. '如果遇到的存储值不是非键容器，则使用typeMismatch '。
        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            switch body {
            case let list as NSArray:
                return try UnkeyedContainer(list, key: key, path: codingPath)
            default: break
            }
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "nil not contains \(key.stringValue)")
            throw DecodingError.typeMismatch(NSArray.self, context)
        }
        
        ///返回一个' Decoder '实例，用于从与默认' super '键关联的容器中解码' super '。
        ///
        ///等效于使用“Key(stringValue: "super"， intValue: 0)”调用“superDecoder(forKey:)”。
        ///
        /// -返回:一个新的' Decoder '传递给' super.init(from:) '。
        /// -抛出:' DecodingError. '如果“self”没有默认的“super”键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为默认的' super '键。
        func superDecoder(forKey key: K) throws -> Decoder {
            return try WKScriptHandlerParamsDecoder(body, key: key, path: codingPath)
        }
        
        ///返回一个' Decoder '实例，用于从与给定键关联的容器中解码' super '。
        ///
        /// - parameter key:为super解码的密钥。
        /// -返回:一个新的' Decoder '传递给' super.init(from:) '。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func superDecoder() throws -> Decoder {
            return try WKScriptHandlerParamsDecoder(body, path: codingPath)
        }
    }
    
    struct KeyedContainer<K> : KeyedDecodingContainerProtocol where K : CodingKey {

        typealias Key = K
        
        let obj:NSDictionary
        /// The path of coding keys taken to get to this point in decoding.
        public let codingPath:[CodingKey]
        
        init(_ value:NSDictionary, key:CodingKey? = nil, path:[CodingKey] = []) {
            var pathList:[CodingKey] = path
            if let last = key {
                pathList.append(last)
            }
            codingPath = pathList
            obj = value
        }
        
        func getValue(forKey key: Key) throws -> Any {
            guard let value = obj[key.stringValue] else {
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: "not contains \(key.stringValue)")
                throw DecodingError.keyNotFound(key, context)
            }
            return value

        }
        
        /// ' Decoder '中包含的这个容器的所有键。
        ///
        ///来自相同' Decoder '的不同键值容器可能会返回不同的键值;可以使用多个不能相互转换的键类型进行编码。这应该报告所有可转换为请求类型的键。
        var allKeys: [K] {
            return obj.allKeys.compactMap { K(stringValue: String(describing: $0)) }
        }
        
        
        ///返回一个布尔值，指示解码器是否包含与给定键相关的值。
        ///
        ///与' key '相关联的值可能是一个空值，以适合的数据格式。
        ///
        /// - parameter key:要搜索的键。
        /// -返回:' Decoder '是否有给定键的条目。
        func contains(_ key: K) -> Bool {
            return obj.allKeys.contains(where: { String(describing: $0) == key.stringValue })
        }
        
        ///为给定的键解码空值。
        ///
        /// - parameter key:被解码的值所关联的键。
        /// -返回:遇到的值是否为空。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        func decodeNil(forKey key: K) throws -> Bool {
            if obj.allKeys.contains(where: { String(describing: $0) == key.stringValue }) {
                let body = obj[key.stringValue]
                switch body {
                case _ as NSNull: return true
                default: return false
                }
            }
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "nil not contains \(key.stringValue)")
            throw DecodingError.keyNotFound(key, context)
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
            let body = try getValue(forKey: key)
            let container = ValueContainer(body, key: key, path: codingPath)
            return try container.decode(type)
        }
        
        func decode<Number>(_ type: Number.Type, forKey key: K) throws -> NSNumber {
            let body = try getValue(forKey: key)
            let container = ValueContainer(body, key: key, path: codingPath)
            return try container.decode(type)
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int.Type, forKey key: K) throws -> Int {
            return try decode(NSNumber.self, forKey: key).intValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
            return try decode(NSNumber.self, forKey: key).int8Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
            return try decode(NSNumber.self, forKey: key).int16Value
        }
        
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
            return try decode(NSNumber.self, forKey: key).int32Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
            return try decode(NSNumber.self, forKey: key).int64Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
            return try decode(NSNumber.self, forKey: key).uintValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
            return try decode(NSNumber.self, forKey: key).uint8Value
        }
        
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
            return try decode(NSNumber.self, forKey: key).uint16Value
        }
        
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
            return try decode(NSNumber.self, forKey: key).uint32Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
            return try decode(NSNumber.self, forKey: key).uint64Value
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Float.Type, forKey key: K) throws -> Float {
            return try decode(NSNumber.self, forKey: key).floatValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: Double.Type, forKey key: K) throws -> Double {
            return try decode(NSNumber.self, forKey: key).doubleValue
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode(_ type: String.Type, forKey key: K) throws -> String {
            let body = try getValue(forKey: key)
            let container = ValueContainer(body, key: key, path: codingPath)
            return try container.decode(type)
        }
        
        ///为给定的键解码给定类型的值。
        ///
        /// -参数类型:值的类型解码。
        /// - parameter key:被解码的值所关联的键。
        /// -返回:请求类型的值，如果给定的键存在，并且可转换为请求类型。
        /// -抛出:' DecodingError. ''，如果遇到的编码值不能转换为请求的类型。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
            let body = try getValue(forKey: key)
            let decoder = try WKScriptHandlerParamsDecoder(body, key: key, path: codingPath)
            return try T(from: decoder)
        }
        
        ///返回存储在给定键类型的容器中的数据。
        ///
        /// - parameter type:用于容器的键类型。
        /// - parameter key:嵌套容器所关联的键。
        /// -返回:一个键控解码的容器视图到' self '。
        /// -抛出:' DecodingError. '如果遇到的存储值不是一个带键的容器，则使用typeMismatch '。
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let body = try getValue(forKey: key)
            switch body {
            case let obj as NSDictionary:
                let container = KeyedContainer<NestedKey>(obj, key:key, path: codingPath)
                return KeyedDecodingContainer<NestedKey>(container)
            default:
                let container = KeyedUnknowContainer<NestedKey>(body, key:key, path: codingPath)
                return KeyedDecodingContainer<NestedKey>(container)
            }
        }
        
        ///返回为给定键存储的数据，在一个非键容器中表示。
        ///
        /// - parameter key:嵌套容器所关联的键。
        /// -返回:一个非键解码的容器视图到' self '。
        /// -抛出:' DecodingError. '如果遇到的存储值不是非键容器，则使用typeMismatch '。
        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            let body = try getValue(forKey: key)
            switch body {
            case let list as NSArray:
                return try UnkeyedContainer(list, key: key, path: codingPath)
            default: break
            }
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "nil not contains \(key.stringValue)")
            throw DecodingError.typeMismatch(NSArray.self, context)
        }
        
        ///返回一个' Decoder '实例，用于从与默认' super '键关联的容器中解码' super '。
        ///
        ///等效于使用“Key(stringValue: "super"， intValue: 0)”调用“superDecoder(forKey:)”。
        ///
        /// -返回:一个新的' Decoder '传递给' super.init(from:) '。
        /// -抛出:' DecodingError. '如果“self”没有默认的“super”键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为默认的' super '键。
        func superDecoder(forKey key: K) throws -> Decoder {
            let body = try getValue(forKey: key)
            return try WKScriptHandlerParamsDecoder(body, key: key, path: codingPath)
        }
        
        ///返回一个' Decoder '实例，用于从与给定键关联的容器中解码' super '。
        ///
        /// - parameter key:为super解码的密钥。
        /// -返回:一个新的' Decoder '传递给' super.init(from:) '。
        /// -抛出:' DecodingError. '如果“self”没有给定键的条目。
        /// -抛出:' DecodingError. 'valueNotFound '如果' self '有一个空条目为给定的键。
        func superDecoder() throws -> Decoder {
            return try WKScriptHandlerParamsDecoder(obj, path: codingPath)
        }
        
    }
}

