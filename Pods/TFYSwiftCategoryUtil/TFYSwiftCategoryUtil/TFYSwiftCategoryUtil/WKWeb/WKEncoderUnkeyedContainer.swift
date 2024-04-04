//
//  WKScriptHandlerParamsEncoder
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation

extension WKScriptHandlerParamsEncoder {
    public struct UnkeyedContainer : UnkeyedDecodingContainer {
        
        private var encoder:WKScriptHandlerParamsEncoder
        public init(_ decoder:WKScriptHandlerParamsEncoder, path:[CodingKey]) {
            encoder = decoder
            encoder.type = .array
            codingPath = path
        }
        
        public var codingPath: [CodingKey]
        
        public var count: Int? { return 0 }
        
        public var isAtEnd: Bool { return true }
        
        public var currentIndex: Int { return 0 }
        
        public mutating func decodeNil() throws -> Bool {
            return true
        }
        
        public mutating func decode(_ type: Bool.Type) throws -> Bool {
            return false
        }
        
        public mutating func decode(_ type: String.Type) throws -> String {
            return ""
        }
        
        public mutating func decode(_ type: Double.Type) throws -> Double {
            return 0
        }
        
        public mutating func decode(_ type: Float.Type) throws -> Float {
            return 0
        }
        
        public mutating func decode(_ type: Int.Type) throws -> Int {
            return 0
        }
        
        public mutating func decode(_ type: Int8.Type) throws -> Int8 {
            return 0
        }
        
        public mutating func decode(_ type: Int16.Type) throws -> Int16 {
            return 0
        }
        
        public mutating func decode(_ type: Int32.Type) throws -> Int32 {
            return 0
        }
        
        public mutating func decode(_ type: Int64.Type) throws -> Int64 {
            return 0
        }
        
        public mutating func decode(_ type: UInt.Type) throws -> UInt {
            return 0
        }
        
        public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            return 0
        }
        
        public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            return 0
        }
        
        public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            return 0
        }
        
        public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            return 0
        }
        
        public mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            return try T(from: encoder)
        }
        
        public mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let key:IndexKey = 0
            return KeyedDecodingContainer(KeyedContainer<NestedKey>.init(encoder, path: codingPath + [key]))
        }
        
        public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let key:IndexKey = 0
            return UnkeyedContainer(encoder, path: codingPath + [key])
        }
        
        public mutating func superDecoder() throws -> Decoder {
            return encoder
        }
        
        
        
    }
}

struct IndexKey : CodingKey, ExpressibleByIntegerLiteral, RawRepresentable {
    typealias IntegerLiteralType = Int
    typealias RawValue = Int
    
    init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    let rawValue:IntegerLiteralType
    init(integerLiteral value: IntegerLiteralType) {
        rawValue = value
    }
 
    init?(stringValue: String) {
        let start = stringValue.index(stringValue.startIndex, offsetBy: 6)
        if  stringValue.hasPrefix("Index "),
            let value = Int(stringValue[start...]) {
            rawValue = value
        } else if let value = Int(stringValue) {
            rawValue = value
        } else {
            return nil
        }
    }
    
    init(intValue: Int) {
        rawValue = intValue
    }
    
    var stringValue: String {
        return "Index \(rawValue)"
    }
    
    var intValue: Int? {
        return rawValue
    }
}
