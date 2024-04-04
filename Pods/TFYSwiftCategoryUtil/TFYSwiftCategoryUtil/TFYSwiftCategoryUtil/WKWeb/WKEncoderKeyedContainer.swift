//
//  WKScriptHandlerParamsEncoder
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation

extension WKScriptHandlerParamsEncoder {
    
    public struct KeyedContainer<Key> : KeyedDecodingContainerProtocol where Key : CodingKey {
                
        public var codingPath: [CodingKey]
        
        private var encoder:WKScriptHandlerParamsEncoder
        public init(_ decoder:WKScriptHandlerParamsEncoder, path:[CodingKey]) {
            codingPath = path
            encoder = decoder
            encoder.type = .more
        }
        
        public var allKeys: [Key] { return [] }
        
        public func contains(_ key: Key) -> Bool {
            return true
        }
        
        public func decodeNil(forKey key: Key) throws -> Bool {
            encoder.append(key.stringValue)
            return true
        }
        
        public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            encoder.append(key.stringValue)
            return true
        }
        
        public func decode(_ type: String.Type, forKey key: Key) throws -> String {
            encoder.append(key.stringValue)
            return ""
        }
        
        public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            encoder.append(key.stringValue)
            return 0
        }
        
        public func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            encoder.append(key.stringValue)
            let decoder = try WKScriptHandlerParamsEncoder(path: codingPath + [key])
            return try T(from: decoder)
        }
        
        public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            encoder.append(key.stringValue)
            let container = KeyedContainer<NestedKey>(encoder, path: codingPath + [key])
            return KeyedDecodingContainer<NestedKey>(container)
        }
        
        public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            encoder.append(key.stringValue)
            return UnkeyedContainer(encoder, path: codingPath + [key])
        }
        
        public func superDecoder() throws -> Decoder {
            return encoder
        }
        
        public func superDecoder(forKey key: Key) throws -> Decoder {
            return try WKScriptHandlerParamsEncoder(path: codingPath + [key])
        }
    }
    
}
