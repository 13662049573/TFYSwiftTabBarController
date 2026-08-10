//
//  URL+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by Codex on 2026/5/24.
//  用途：URL 链式编程扩展，支持安全创建、查询参数处理、路径拼接等基础能力。
//

import Foundation

extension URL: TFYCompatible {}

// MARK: - 一、URL 基础扩展
public extension TFY where Base == URL {

    // MARK: 1.1、安全创建 URL
    /// 安全创建 URL，会自动裁剪首尾空白
    /// - Parameter string: URL 字符串
    /// - Returns: URL，失败返回 nil
    static func safe(_ string: String) -> URL? {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedString.isEmpty else { return nil }
        return URL(string: trimmedString)
    }

    // MARK: 1.2、是否为 HTTP/HTTPS URL
    /// 是否为 HTTP/HTTPS URL
    var isHTTPURL: Bool {
        guard let scheme = base.scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }

    // MARK: 1.3、查询参数字典
    /// 查询参数字典
    var queryParameters: [String: String] {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }

        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value ?? ""
        }
    }

    // MARK: 1.4、读取指定查询参数
    /// 读取指定查询参数
    /// - Parameter name: 参数名
    /// - Returns: 参数值
    func value(forQueryItem name: String) -> String? {
        guard !name.isEmpty else { return nil }
        return queryParameters[name]
    }

    // MARK: 1.5、追加查询参数
    /// 追加查询参数
    /// - Parameters:
    ///   - items: 查询参数
    ///   - replacingExisting: 是否替换同名参数
    /// - Returns: 新 URL
    func appendingQueryItems(_ items: [URLQueryItem], replacingExisting: Bool = false) -> URL {
        guard !items.isEmpty,
              var components = URLComponents(url: base, resolvingAgainstBaseURL: false) else {
            return base
        }

        let safeItems = items.filter { !$0.name.isEmpty }
        guard !safeItems.isEmpty else { return base }

        var queryItems = components.queryItems ?? []
        if replacingExisting {
            let replacingNames = Set(safeItems.map(\.name))
            queryItems.removeAll { replacingNames.contains($0.name) }
        }
        queryItems.append(contentsOf: safeItems)
        components.queryItems = queryItems
        return components.url ?? base
    }

    // MARK: 1.6、移除所有查询参数
    /// 移除所有查询参数
    /// - Returns: 新 URL
    func deletingAllQueryItems() -> URL {
        guard var components = URLComponents(url: base, resolvingAgainstBaseURL: false) else {
            return base
        }
        components.queryItems = nil
        return components.url ?? base
    }

    // MARK: 1.7、追加多个路径
    /// 追加多个路径
    /// - Parameter components: 路径组件
    /// - Returns: 新 URL
    func appendingPathComponents(_ components: [String]) -> URL {
        return components.reduce(base) { partialURL, component in
            let trimmedComponent = component.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !trimmedComponent.isEmpty else { return partialURL }
            return partialURL.appendingPathComponent(trimmedComponent)
        }
    }
}

