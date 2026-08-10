//
//  URLRequest+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by Codex on 2026/5/24.
//  用途：URLRequest 链式编程扩展，支持 HTTP 方法、Header、JSON Body 等基础配置。
//

import Foundation

extension URLRequest: TFYCompatible {}

/// HTTP 请求方法
public enum TFYHTTPMethod: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}

// MARK: - 一、URLRequest 基础扩展
public extension TFY where Base == URLRequest {

    // MARK: 1.1、创建请求
    /// 创建请求
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - method: HTTP 方法
    ///   - queryItems: 查询参数
    ///   - headers: 请求头
    ///   - timeout: 超时时间
    /// - Returns: URLRequest
    static func request(url: URL,
                        method: TFYHTTPMethod = .get,
                        queryItems: [URLQueryItem] = [],
                        headers: [String: String] = [:],
                        timeout: TimeInterval = 60) -> URLRequest {
        let requestURL = url.tfy.appendingQueryItems(queryItems, replacingExisting: true)
        var request = URLRequest(url: requestURL, timeoutInterval: max(0.1, timeout))
        request.httpMethod = method.rawValue
        headers.forEach { key, value in
            guard !key.isEmpty else { return }
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }

    // MARK: 1.2、设置 HTTP 方法
    /// 设置 HTTP 方法
    /// - Parameter method: HTTP 方法
    /// - Returns: 链式包装器
    func method(_ method: TFYHTTPMethod) -> TFY<Base> {
        var request = base
        request.httpMethod = method.rawValue
        return TFY(request)
    }

    // MARK: 1.3、设置 Header
    /// 设置 Header
    /// - Parameters:
    ///   - value: Header 值
    ///   - field: Header 名
    /// - Returns: 链式包装器
    func header(_ value: String?, forHTTPHeaderField field: String) -> TFY<Base> {
        var request = base
        guard !field.isEmpty else { return TFY(request) }
        request.setValue(value, forHTTPHeaderField: field)
        return TFY(request)
    }

    // MARK: 1.4、批量设置 Header
    /// 批量设置 Header
    /// - Parameter headers: Header 字典
    /// - Returns: 链式包装器
    func headers(_ headers: [String: String]) -> TFY<Base> {
        var request = base
        headers.forEach { key, value in
            guard !key.isEmpty else { return }
            request.setValue(value, forHTTPHeaderField: key)
        }
        return TFY(request)
    }

    // MARK: 1.5、设置 JSON Content-Type
    /// 设置 JSON Content-Type
    /// - Returns: 链式包装器
    func contentTypeJSON() -> TFY<Base> {
        return header("application/json", forHTTPHeaderField: "Content-Type")
    }

    // MARK: 1.6、设置 JSON Accept
    /// 设置 JSON Accept
    /// - Returns: 链式包装器
    func acceptJSON() -> TFY<Base> {
        return header("application/json", forHTTPHeaderField: "Accept")
    }

    // MARK: 1.7、设置 Bearer Token
    /// 设置 Bearer Token
    /// - Parameter token: Token
    /// - Returns: 链式包装器
    func bearerToken(_ token: String?) -> TFY<Base> {
        guard let token = token?.trimmingCharacters(in: .whitespacesAndNewlines), !token.isEmpty else {
            return TFY(base)
        }
        return header("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    // MARK: 1.8、设置 JSON Body
    /// 设置 JSON Body
    /// - Parameters:
    ///   - object: JSON 对象
    ///   - options: 序列化选项
    /// - Returns: 链式包装器
    func jsonBody(_ object: Any, options: JSONSerialization.WritingOptions = []) -> TFY<Base> {
        var request = base
        guard JSONSerialization.isValidJSONObject(object),
              let data = try? JSONSerialization.data(withJSONObject: object, options: options) else {
            return TFY(request)
        }
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return TFY(request)
    }

    // MARK: 1.9、设置 Encodable JSON Body
    /// 设置 Encodable JSON Body
    /// - Parameters:
    ///   - value: 可编码对象
    ///   - encoder: JSONEncoder
    /// - Returns: 链式包装器
    func encodedJSONBody<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) throws -> TFY<Base> {
        var request = base
        request.httpBody = try encoder.encode(value)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return TFY(request)
    }

    // MARK: 1.10、设置超时时间
    /// 设置超时时间
    /// - Parameter timeout: 超时时间
    /// - Returns: 链式包装器
    func timeout(_ timeout: TimeInterval) -> TFY<Base> {
        var request = base
        request.timeoutInterval = max(0.1, timeout)
        return TFY(request)
    }
}

