//
//  URLSession+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by Codex on 2026/5/24.
//  用途：URLSession 链式编程扩展，支持状态码校验与 Result/async 基础请求封装。
//

import Foundation

/// URLSession 请求错误
public enum TFYURLSessionError: Error, LocalizedError {
    case invalidResponse
    case unacceptableStatusCode(Int, Data)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid URL response."
        case .unacceptableStatusCode(let statusCode, _):
            return "Unacceptable HTTP status code: \(statusCode)."
        }
    }
}

// MARK: - 一、URLSession 基础扩展
public extension TFY where Base: URLSession {

    // MARK: 1.1、发起带状态码校验的数据请求
    /// 发起带状态码校验的数据请求
    /// - Parameters:
    ///   - request: 请求
    ///   - validStatusCodes: 有效状态码范围
    ///   - completion: 请求结果
    /// - Returns: URLSessionDataTask
    @discardableResult
    func dataTask(with request: URLRequest,
                  validStatusCodes: Range<Int> = 200..<300,
                  completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
        let task = base.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(TFYURLSessionError.invalidResponse))
                return
            }

            let responseData = data ?? Data()
            guard validStatusCodes.contains(httpResponse.statusCode) else {
                completion(.failure(TFYURLSessionError.unacceptableStatusCode(httpResponse.statusCode, responseData)))
                return
            }

            completion(.success((responseData, httpResponse)))
        }
        task.resume()
        return task
    }

    // MARK: 1.2、async/await 数据请求
    /// async/await 数据请求
    /// - Parameters:
    ///   - request: 请求
    ///   - validStatusCodes: 有效状态码范围
    /// - Returns: 数据和 HTTP 响应
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func data(for request: URLRequest,
              validStatusCodes: Range<Int> = 200..<300) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await base.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TFYURLSessionError.invalidResponse
        }
        guard validStatusCodes.contains(httpResponse.statusCode) else {
            throw TFYURLSessionError.unacceptableStatusCode(httpResponse.statusCode, data)
        }
        return (data, httpResponse)
    }
}
