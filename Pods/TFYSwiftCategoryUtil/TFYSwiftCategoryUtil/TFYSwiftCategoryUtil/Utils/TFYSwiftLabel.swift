//
//  TFYSwiftLabel.swift
//  TFYSwiftCategoryUtil
//
//  Created by TFY on 2024
//
//  TFYSwiftLabel - 支持多语言点击检测的独立Label类
//
//  功能特性：
//  - 支持多语言文本点击检测（中文、英文、阿拉伯语、泰语、韩语、日语、俄语、法语、德语）
//  - 智能文本匹配算法，支持精确匹配、模糊匹配和部分匹配
//  - 支持RTL（从右到左）语言的正确显示和点击检测
//  - 可自定义点击高亮效果和样式
//  - 提供链式调用API，使用便捷
//  - 内置调试模式，便于开发和测试
//  - 支持富文本样式和颜色设置
//  - 智能缓存机制，提升性能
//  - 内存管理优化，支持内存警告处理
//  - 性能监控功能，便于性能分析
//  - 完善的错误处理和边界条件检查
//
//  使用示例：
//  ```swift
//  let label = TFYSwiftLabel()
//  label.text = "点击这里查看详情"
//  try label.setClickableTexts(
//      ["点击这里": "detail_url"],
//      textColors: [.systemBlue],
//      callback: { text, link in
//          print("点击了: \(text), 链接: \(link ?? "")")
//      }
//  )
//  ```
//
//  性能优化：
//  - 使用智能缓存减少重复计算
//  - 内存警告时自动清理缓存
//  - 支持性能监控和统计
//  - 优化的文本匹配算法
//
//  注意事项：
//  - 确保在设置可点击文本前设置text属性
//  - 颜色数组长度应与可点击文本数量匹配
//  - 建议在不需要时及时清理可点击文本以释放内存
//

import UIKit
import CoreText

/// 点击回调类型
public typealias TFYSwiftLabelClickCallback = (String, String?) -> Void

/// 文本匹配策略枚举
public enum TFYSwiftLabelMatchStrategy {
    case exact        // 精确匹配
    case insensitive  // 忽略大小写匹配
    case partial      // 部分匹配
    case smart        // 智能匹配（默认）
}

/// 点击高亮样式枚举
public enum TFYSwiftLabelHighlightStyle {
    case backgroundColor(UIColor)  // 背景色高亮
    case textColor(UIColor)       // 文字颜色高亮
    case underline(UIColor)       // 下划线高亮
    case border(UIColor, CGFloat) // 边框高亮
}

/// 错误类型枚举
public enum TFYSwiftLabelError: Error, LocalizedError {
    case invalidText
    case invalidColorCount
    case invalidRange
    case cacheError
    case memoryWarning
    
    public var errorDescription: String? {
        switch self {
        case .invalidText:
            return "无效的文本内容"
        case .invalidColorCount:
            return "颜色数量与文本数量不匹配"
        case .invalidRange:
            return "无效的文本范围"
        case .cacheError:
            return "缓存操作失败"
        case .memoryWarning:
            return "内存不足，已清理缓存"
        }
    }
}

public class TFYSwiftLabel: UILabel {
    
    // MARK: - 常量定义
    
    /// 默认字体大小
    private static let defaultFontSize: CGFloat = 16.0
    
    /// 默认高亮持续时间
    private static let defaultHighlightDuration: TimeInterval = 0.2
    
    /// 默认高亮透明度
    private static let defaultHighlightAlpha: CGFloat = 0.3
    
    /// 智能匹配的最大距离（字符数）
    private static let maxMatchDistance: Int = 50
    
    /// 最小匹配词长度
    private static let minWordLength: Int = 2
    
    /// 重要词的最小长度
    private static let minImportantWordLength: Int = 3
    
    // MARK: - 核心属性
    
    /// 可点击文本字典 [文本: 链接]
    private var clickableTexts: [String: String] = [:]
    
    /// 点击回调
    private var clickCallback: TFYSwiftLabelClickCallback?
    
    /// 是否启用点击检测
    public var isClickDetectionEnabled: Bool = true
    
    /// 点击高亮样式
    public var highlightStyle: TFYSwiftLabelHighlightStyle = .backgroundColor(UIColor.systemBlue.withAlphaComponent(0.3))
    
    /// 点击高亮持续时间
    public var clickHighlightDuration: TimeInterval = 0.2
    
    /// 文本匹配策略
    public var matchStrategy: TFYSwiftLabelMatchStrategy = .smart
    
    /// 防止死循环的标志
    private var isUpdatingAttributedText: Bool = false
    
    /// 调试模式 - 是否输出匹配过程
    public var debugMode: Bool = false
    
    /// 富文本属性缓存
    private var cachedAttributedString: NSAttributedString?
    
    /// 文本颜色映射 [文本: 颜色]
    private var textColorMap: [String: UIColor] = [:]
    
    /// 可点击文本的顺序（用于颜色与文本一一对应，保持外部传入顺序）
    private var clickableTextOrder: [String] = []
    
    /// 文本匹配结果缓存 [搜索文本: [完整文本: 范围数组]]
    private var textMatchCache: [String: [String: [NSRange]]] = [:]
    
    /// 缓存最大大小
    private static let maxCacheSize: Int = 100
    
    /// 性能监控 - 匹配次数统计
    private var matchCount: Int = 0
    
    /// 性能监控 - 缓存命中次数
    private var cacheHitCount: Int = 0
    
    /// 性能监控 - 是否启用性能监控
    public var isPerformanceMonitoringEnabled: Bool = false
    
    // MARK: - 初始化
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        isUserInteractionEnabled = true
        setupTapGesture()
        setupMemoryWarningObserver()
    }
    
    /// 设置内存警告观察者
    private func setupMemoryWarningObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    /// 处理内存警告
    @objc private func handleMemoryWarning() {
        if debugMode {
            print("⚠️ 收到内存警告，清理缓存")
        }
        
        // 清理文本匹配缓存
        clearTextMatchCache()
        
        // 清理富文本缓存
        cachedAttributedString = nil
        
        // 强制重新创建富文本
        if let text = text, !text.isEmpty {
            updateAttributedText()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 公开方法
    
    /// 设置可点击文本
    /// - Parameters:
    ///   - texts: 可点击文本字典 [文本: 链接]
    ///   - textColors: 文本颜色数组
    ///   - callback: 点击回调
    /// - Throws: TFYSwiftLabelError 当参数无效时抛出错误
    public func setClickableTexts(_ texts: [String: String], textColors: [UIColor], callback: @escaping TFYSwiftLabelClickCallback) throws {
        // 验证输入参数
        guard !texts.isEmpty else {
            throw TFYSwiftLabelError.invalidText
        }
        
        // 验证颜色数量
        if textColors.isEmpty {
            throw TFYSwiftLabelError.invalidColorCount
        }
        
        clickableTexts = texts
        // 记录外部传入的键顺序
        clickableTextOrder = texts.map { $0.key }
        
        do {
            try changeTextLabelColors(textColors)
        } catch {
            throw error
        }
        
        clickCallback = callback
    }
    
    /// 清除所有可点击文本
    public func clearClickableTexts() {
        clickableTexts.removeAll()
        clickCallback = nil
        textColorMap.removeAll()
        clickableTextOrder.removeAll()
        clearTextMatchCache()
        text = text // 重置为普通文本
    }
    
    /// 设置点击高亮样式
    /// - Parameters:
    ///   - color: 高亮颜色
    ///   - duration: 高亮持续时间
    public func setClickHighlight(color: UIColor, duration: TimeInterval = 0.2) {
        highlightStyle = .backgroundColor(color)
        clickHighlightDuration = duration
    }
    
    /// 设置点击高亮样式
    /// - Parameters:
    ///   - style: 高亮样式
    ///   - duration: 高亮持续时间
    public func setClickHighlight(style: TFYSwiftLabelHighlightStyle, duration: TimeInterval = 0.2) {
        highlightStyle = style
        clickHighlightDuration = duration
    }
    
    /// 设置文本颜色 - 为可点击文本设置颜色
    /// - Parameter colors: 颜色数组
    /// - Throws: TFYSwiftLabelError 当参数无效时抛出错误
    private func changeTextLabelColors(_ colors: [UIColor]) throws {
        // 清除之前的颜色映射
        textColorMap.removeAll()
        
        // 验证输入参数
        guard !colors.isEmpty else {
            throw TFYSwiftLabelError.invalidColorCount
        }
        
        // 获取可点击文本的键数组（保持外部传入顺序）
        let clickableTextKeys = clickableTextOrder.isEmpty ? Array(clickableTexts.keys) : clickableTextOrder
        
        // 如果可点击文本为空，直接返回
        guard !clickableTextKeys.isEmpty else {
            updateAttributedText()
            return
        }
        
        // 检查当前显示文本
        guard let currentText = text, !currentText.isEmpty else {
            updateAttributedText()
            return
        }
        
        // 验证文本范围
        for textKey in clickableTextKeys {
            guard !textKey.isEmpty else {
                throw TFYSwiftLabelError.invalidText
            }
        }
        
        // 根据颜色数量进行不同的处理（严格按照顺序一一对应）
        if colors.count == 1 {
            // 如果只有一个颜色，所有可点击文本都使用这个颜色
            let singleColor = colors[0]
            for textKey in clickableTextKeys {
                textColorMap[textKey] = singleColor
            }
        } else if colors.count > 1 {
            // 如果有多个颜色，按顺序一一对应
            // 取颜色数量和可点击文本数量的较小值
            let pairCount = min(colors.count, clickableTextKeys.count)
            
            for index in 0..<pairCount {
                let textKey = clickableTextKeys[index]
                let color = colors[index]
                textColorMap[textKey] = color
            }
        }
        
        // 更新富文本
        updateAttributedText()
    }
    
    /// 清除所有文本颜色设置
    private func clearTextLabelColors() {
        textColorMap.removeAll()
        clearTextMatchCache()
        updateAttributedText()
    }
    
    /// 更新富文本
    private func updateAttributedText() {
        guard let text = text, !text.isEmpty else { return }
        
        isUpdatingAttributedText = true
        
        let attributedString = createAttributedString(from: text, applyColors: true)
        
        attributedText = attributedString
        cachedAttributedString = attributedString
        
        isUpdatingAttributedText = false
        
        if debugMode {
            print("📝 富文本已更新，文本长度: \(text.count)")
        }
    }
    
    /// 查找文本在字符串中的所有范围
    /// - Parameters:
    ///   - searchText: 搜索文本
    ///   - fullText: 完整文本
    ///   - exactMatch: 是否使用精确匹配，默认为true
    /// - Returns: 所有匹配的范围数组
    private func findTextRanges(_ searchText: String, in fullText: String, exactMatch: Bool = true) -> [NSRange] {
        // 验证输入参数
        guard !searchText.isEmpty, !fullText.isEmpty else {
            if debugMode {
                print("❌ 搜索文本或完整文本为空")
            }
            return []
        }
        
        var ranges: [NSRange] = []
        var searchRange = NSRange(location: 0, length: fullText.count)
        
        while searchRange.location < fullText.count {
            let range: NSRange
            if exactMatch {
                // 使用精确匹配
                range = (fullText as NSString).range(of: searchText, options: [], range: searchRange)
            } else {
                // 使用智能匹配策略
                range = findTextRangeInString(searchText, in: fullText, searchRange: searchRange)
            }
            
            if range.location != NSNotFound {
                ranges.append(range)
                searchRange.location = range.location + range.length
                searchRange.length = fullText.count - searchRange.location
            } else {
                break
            }
        }
        
        return ranges
    }
    
    /// 查找文本在字符串中的所有范围 - 精确匹配版本（保持向后兼容）
    /// - Parameters:
    ///   - searchText: 搜索文本
    ///   - fullText: 完整文本
    /// - Returns: 所有精确匹配的范围数组
    private func findExactTextRanges(_ searchText: String, in fullText: String) -> [NSRange] {
        return findTextRanges(searchText, in: fullText, exactMatch: true)
    }
    
    /// 带缓存的文本范围查找
    /// - Parameters:
    ///   - searchText: 搜索文本
    ///   - fullText: 完整文本
    ///   - exactMatch: 是否使用精确匹配
    /// - Returns: 所有匹配的范围数组
    private func findTextRangesWithCache(_ searchText: String, in fullText: String, exactMatch: Bool = true) -> [NSRange] {
        // 记录匹配操作
        recordMatchOperation()
        
        let cacheKey = "\(searchText)_\(exactMatch)"
        
        // 检查缓存
        if let cachedRanges = textMatchCache[cacheKey]?[fullText] {
            // 记录缓存命中
            recordCacheHit()
            
            if debugMode {
                print("📦 使用缓存的匹配结果: \(cachedRanges.count) 个范围")
            }
            return cachedRanges
        }
        
        // 执行匹配
        let ranges = findTextRanges(searchText, in: fullText, exactMatch: exactMatch)
        
        // 更新缓存
        updateTextMatchCache(key: cacheKey, fullText: fullText, ranges: ranges)
        
        return ranges
    }
    
    /// 更新文本匹配缓存
    /// - Parameters:
    ///   - key: 缓存键
    ///   - fullText: 完整文本
    ///   - ranges: 匹配范围数组
    private func updateTextMatchCache(key: String, fullText: String, ranges: [NSRange]) {
        // 检查缓存大小，如果超过限制则清理
        if textMatchCache.count >= 100 {
            // 清理最旧的缓存项（简单的FIFO策略）
            let oldestKey = textMatchCache.keys.first
            if let oldestKey = oldestKey {
                textMatchCache.removeValue(forKey: oldestKey)
            }
        }
        
        // 添加新的缓存项
        if textMatchCache[key] == nil {
            textMatchCache[key] = [:]
        }
        textMatchCache[key]?[fullText] = ranges
        
        if debugMode {
            print("📦 缓存更新: \(key), 当前缓存大小: \(textMatchCache.count)")
        }
    }
    
    /// 智能清理缓存
    private func smartClearCache() {
        // 清理富文本缓存
        cachedAttributedString = nil
        
        // 清理文本匹配缓存
        clearTextMatchCache()
        
        if debugMode {
            print("🧹 智能清理缓存完成")
        }
    }
    
    /// 清理文本匹配缓存
    private func clearTextMatchCache() {
        textMatchCache.removeAll()
    }
    
    /// 性能监控 - 记录匹配操作
    private func recordMatchOperation() {
        if isPerformanceMonitoringEnabled {
            matchCount += 1
            if debugMode {
                print("📊 性能监控 - 匹配操作次数: \(matchCount)")
            }
        }
    }
    
    /// 性能监控 - 记录缓存命中
    private func recordCacheHit() {
        if isPerformanceMonitoringEnabled {
            cacheHitCount += 1
            if debugMode {
                print("📊 性能监控 - 缓存命中次数: \(cacheHitCount)")
            }
        }
    }
    
    /// 性能监控 - 获取性能统计
    public func getPerformanceStats() -> (matchCount: Int, cacheHitCount: Int, cacheHitRate: Double) {
        let cacheHitRate = matchCount > 0 ? Double(cacheHitCount) / Double(matchCount) : 0.0
        return (matchCount, cacheHitCount, cacheHitRate)
    }
    
    /// 性能监控 - 重置统计
    public func resetPerformanceStats() {
        matchCount = 0
        cacheHitCount = 0
        if debugMode {
            print("📊 性能监控 - 统计已重置")
        }
    }
    
    // MARK: - 私有方法
    
    /// 创建富文本字符串
    /// - Parameters:
    ///   - text: 原始文本
    ///   - applyColors: 是否应用文本颜色
    /// - Returns: 富文本字符串
    private func createAttributedString(from text: String, applyColors: Bool = true) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        // 设置基础属性
        let range = NSRange(location: 0, length: text.count)
        attributedString.addAttribute(.font, value: font ?? UIFont.systemFont(ofSize: 16.0), range: range)
        attributedString.addAttribute(.foregroundColor, value: textColor ?? .label, range: range)
        
        // 应用文本颜色
        if applyColors {
            let orderedKeys = clickableTextOrder.isEmpty ? Array(textColorMap.keys) : clickableTextOrder
            for searchText in orderedKeys {
                guard let color = textColorMap[searchText] else { continue }
                let ranges = findTextRangesWithCache(searchText, in: text, exactMatch: true)
                for range in ranges {
                    attributedString.addAttribute(.foregroundColor, value: color, range: range)
                }
            }
        }
        
        return attributedString
    }
    
    /// 应用高亮效果到指定文本
    /// - Parameters:
    ///   - attributedString: 富文本字符串
    ///   - clickedText: 被点击的文本
    ///   - highlightStyle: 高亮样式
    /// - Returns: 保存的原始属性字典
    private func applyHighlightEffect(to attributedString: NSMutableAttributedString, 
                                    for clickedText: String, 
                                    style: TFYSwiftLabelHighlightStyle) -> [String: [NSRange: Any]] {
        guard let text = text, !text.isEmpty else { return [:] }
        
        let ranges = findTextRangesWithCache(clickedText, in: text, exactMatch: true)
        var originalAttributes: [String: [NSRange: Any]] = [:]
        
        for range in ranges {
            switch style {
            case .backgroundColor(let color):
                // 保存原始背景色
                if let originalColor = attributedString.attribute(.backgroundColor, at: range.location, effectiveRange: nil) as? UIColor {
                    if originalAttributes["backgroundColor"] == nil {
                        originalAttributes["backgroundColor"] = [:]
                    }
                    originalAttributes["backgroundColor"]?[range] = originalColor
                }
                // 设置高亮背景色
                attributedString.addAttribute(.backgroundColor, value: color, range: range)
                
            case .textColor(let color):
                // 保存原始文字颜色
                if let originalColor = attributedString.attribute(.foregroundColor, at: range.location, effectiveRange: nil) as? UIColor {
                    if originalAttributes["foregroundColor"] == nil {
                        originalAttributes["foregroundColor"] = [:]
                    }
                    originalAttributes["foregroundColor"]?[range] = originalColor
                }
                // 设置高亮文字颜色
                attributedString.addAttribute(.foregroundColor, value: color, range: range)
                
            case .underline(let color):
                // 保存原始下划线样式
                if let originalStyle = attributedString.attribute(.underlineStyle, at: range.location, effectiveRange: nil) {
                    if originalAttributes["underlineStyle"] == nil {
                        originalAttributes["underlineStyle"] = [:]
                    }
                    originalAttributes["underlineStyle"]?[range] = originalStyle
                }
                if let originalColor = attributedString.attribute(.underlineColor, at: range.location, effectiveRange: nil) as? UIColor {
                    if originalAttributes["underlineColor"] == nil {
                        originalAttributes["underlineColor"] = [:]
                    }
                    originalAttributes["underlineColor"]?[range] = originalColor
                }
                // 设置下划线高亮
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
                attributedString.addAttribute(.underlineColor, value: color, range: range)
                
            case .border(let color, let width):
                // 保存原始描边样式
                if let originalColor = attributedString.attribute(.strokeColor, at: range.location, effectiveRange: nil) as? UIColor {
                    if originalAttributes["strokeColor"] == nil {
                        originalAttributes["strokeColor"] = [:]
                    }
                    originalAttributes["strokeColor"]?[range] = originalColor
                }
                if let originalWidth = attributedString.attribute(.strokeWidth, at: range.location, effectiveRange: nil) as? NSNumber {
                    if originalAttributes["strokeWidth"] == nil {
                        originalAttributes["strokeWidth"] = [:]
                    }
                    originalAttributes["strokeWidth"]?[range] = originalWidth
                }
                // 设置描边高亮
                attributedString.addAttribute(.strokeColor, value: color, range: range)
                attributedString.addAttribute(.strokeWidth, value: width, range: range)
            }
        }
        
        return originalAttributes
    }
    
    /// 恢复原始属性
    /// - Parameters:
    ///   - attributedString: 富文本字符串
    ///   - originalAttributes: 原始属性字典
    ///   - ranges: 需要恢复的范围数组
    private func restoreOriginalAttributes(to attributedString: NSMutableAttributedString, 
                                        originalAttributes: [String: [NSRange: Any]], 
                                        ranges: [NSRange]) {
        // 验证范围有效性
        let textLength = attributedString.length
        let validRanges = ranges.filter { range in
            range.location != NSNotFound && 
            range.location >= 0 && 
            range.location + range.length <= textLength
        }
        
        if debugMode {
            print("🔄 开始恢复属性，有效范围数量: \(validRanges.count)/\(ranges.count)")
        }
        
        for range in validRanges {
            // 恢复背景色
            if let backgroundColorMap = originalAttributes["backgroundColor"],
               let originalColor = backgroundColorMap[range] as? UIColor {
                attributedString.addAttribute(.backgroundColor, value: originalColor, range: range)
            } else if originalAttributes["backgroundColor"] != nil {
                attributedString.removeAttribute(.backgroundColor, range: range)
            }
            
            // 恢复文字颜色
            if let foregroundColorMap = originalAttributes["foregroundColor"],
               let originalColor = foregroundColorMap[range] as? UIColor {
                attributedString.addAttribute(.foregroundColor, value: originalColor, range: range)
            } else if originalAttributes["foregroundColor"] != nil {
                attributedString.addAttribute(.foregroundColor, value: textColor ?? .label, range: range)
            }
            
            // 恢复下划线样式
            if let underlineStyleMap = originalAttributes["underlineStyle"],
               let originalStyle = underlineStyleMap[range] {
                attributedString.addAttribute(.underlineStyle, value: originalStyle, range: range)
            } else if originalAttributes["underlineStyle"] != nil {
                attributedString.removeAttribute(.underlineStyle, range: range)
            }
            
            if let underlineColorMap = originalAttributes["underlineColor"],
               let originalColor = underlineColorMap[range] as? UIColor {
                attributedString.addAttribute(.underlineColor, value: originalColor, range: range)
            } else if originalAttributes["underlineColor"] != nil {
                attributedString.removeAttribute(.underlineColor, range: range)
            }
            
            // 恢复描边样式
            if let strokeColorMap = originalAttributes["strokeColor"],
               let originalColor = strokeColorMap[range] as? UIColor {
                attributedString.addAttribute(.strokeColor, value: originalColor, range: range)
            } else if originalAttributes["strokeColor"] != nil {
                attributedString.removeAttribute(.strokeColor, range: range)
            }
            
            if let strokeWidthMap = originalAttributes["strokeWidth"],
               let originalWidth = strokeWidthMap[range] as? NSNumber {
                attributedString.addAttribute(.strokeWidth, value: originalWidth, range: range)
            } else if originalAttributes["strokeWidth"] != nil {
                attributedString.removeAttribute(.strokeWidth, range: range)
            }
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard isClickDetectionEnabled, !clickableTexts.isEmpty else { 
            if debugMode {
                print("❌ 点击检测未启用或没有可点击文本")
            }
            return 
        }
        
        let location = gesture.location(in: self)
        if debugMode {
            print("👆 点击位置: \(location)")
            print("📋 可点击文本: \(Array(clickableTexts.keys))")
        }
        
        // 在主线程执行点击检测
        if let (clickedText, link) = detectClickedText(at: location) {
            if debugMode {
                print("✅ 检测到点击: '\(clickedText)' -> '\(link ?? "无链接")'")
            }
            showClickHighlight(at: location)
            clickCallback?(clickedText, link)
        } else {
            if debugMode {
                print("❌ 未检测到有效点击")
            }
        }
    }
    
    private func detectClickedText(at location: CGPoint) -> (String, String?)? {
        // 验证文本内容
        guard let text = text, !text.isEmpty else {
            if debugMode {
                print("❌ 文本内容为空")
            }
            return nil
        }
        
        // 验证点击位置
        guard bounds.contains(location) else {
            if debugMode {
                print("❌ 点击位置超出标签范围: \(location), bounds: \(bounds)")
            }
            return nil
        }
        
        // 验证可点击文本
        guard !clickableTexts.isEmpty else {
            if debugMode {
                print("❌ 没有可点击文本")
            }
            return nil
        }
        
        // 使用缓存的富文本或创建新的
        let attributedText: NSAttributedString
        if let cached = cachedAttributedString {
            attributedText = cached
        } else {
            attributedText = createAttributedString(from: text, applyColors: false)
        }
        
        // 创建文本布局管理器
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bounds.size)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        // 配置布局
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 配置文本容器
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        
        // 强制布局计算
        textContainer.size = bounds.size
        layoutManager.ensureLayout(for: textContainer)
        
        // 计算点击位置的字符索引 - 改进版本
        var characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // 如果字符索引无效，尝试使用字形索引
        if characterIndex == NSNotFound {
            let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer, fractionOfDistanceThroughGlyph: nil)
            if glyphIndex != NSNotFound {
                characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            }
        }
        
        // 确保字符索引在有效范围内
        let safeCharacterIndex = min(max(characterIndex, 0), text.count - 1)
        
        if debugMode {
            print("📍 点击位置: \(location)")
            print("📏 Label bounds: \(bounds)")
            print("📦 文本容器大小: \(textContainer.size)")
            print("🔢 原始字符索引: \(characterIndex)")
            print("🔢 安全字符索引: \(safeCharacterIndex)")
            print("📝 文本总长度: \(text.count)")
            
            // 检查文本容器的行数
            let glyphRange = layoutManager.glyphRange(for: textContainer)
            print("🔤 字形范围: \(glyphRange)")
            
            // 检查点击位置是否在有效范围内
            if characterIndex != NSNotFound {
                let textRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: min(characterIndex, text.count)), in: textContainer)
                print("📐 文本矩形: \(textRect)")
            }
        }
        
        // 使用改进的点击检测方法
        if characterIndex != NSNotFound {
            // 检查点击位置是否在可点击文本范围内
            for (clickableText, link) in clickableTexts {
                let range = findTextRangeInString(clickableText, in: text)
                if debugMode {
                    print("🔍 检查文本: '\(clickableText)'")
                    print("📊 匹配范围: \(range)")
                    print("🎯 原始字符索引在范围内: \(NSLocationInRange(characterIndex, range))")
                    print("🎯 安全字符索引在范围内: \(NSLocationInRange(safeCharacterIndex, range))")
                }
                
                if range.location != NSNotFound && (NSLocationInRange(characterIndex, range) || NSLocationInRange(safeCharacterIndex, range)) {
                    if debugMode {
                        print("✅ 找到匹配的点击文本: '\(clickableText)'")
                    }
                    return (clickableText, link)
                }
            }
        }
        
        // 如果字符索引方法失败，使用备用方法：检查点击位置是否在文本范围内
        if characterIndex == NSNotFound || !isClickInAnyTextRange(location: location, layoutManager: layoutManager, textContainer: textContainer) {
            if debugMode {
                print("❌ 无法计算字符索引或点击位置不在文本范围内")
            }
            return nil
        }
        
        // 备用检测方法：使用文本范围检查
        if let result = detectClickedTextByRange(location: location, layoutManager: layoutManager, textContainer: textContainer) {
            return result
        }
        
        return nil
    }
    
    /// 检查点击位置是否在任何文本范围内
    private func isClickInAnyTextRange(location: CGPoint, layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> Bool {
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        if glyphRange.location != NSNotFound && glyphRange.length > 0 {
            let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
            return boundingRect.contains(location)
        }
        return false
    }
    
    /// 备用检测方法：使用文本范围检查
    private func detectClickedTextByRange(location: CGPoint, layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> (String, String?)? {
        guard let text = text, !text.isEmpty else { return nil }
        
        // 遍历所有可点击文本，检查点击位置是否在其范围内
        for (clickableText, link) in clickableTexts {
            let ranges = findTextRangesWithCache(clickableText, in: text, exactMatch: true)
            
            for range in ranges {
                // 获取文本范围的边界矩形
                let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                if glyphRange.location != NSNotFound && glyphRange.length > 0 {
                    let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                    
                    if debugMode {
                        print("🔍 备用检测 - 文本: '\(clickableText)', 范围: \(range), 边界: \(boundingRect)")
                        print("🎯 点击位置: \(location), 边界包含: \(boundingRect.contains(location))")
                    }
                    
                    // 使用更宽松的点击检测，考虑文本的点击区域
                    if isClickInTextRange(location: location, boundingRect: boundingRect, text: clickableText) {
                        if debugMode {
                            print("✅ 备用检测成功 - 找到匹配的点击文本: '\(clickableText)'")
                        }
                        return (clickableText, link)
                    }
                }
            }
        }
        
        // 如果精确匹配失败，尝试智能匹配
        if let result = detectClickedTextBySmartMatch(location: location, layoutManager: layoutManager, textContainer: textContainer) {
            return result
        }
        
        // 最后尝试：使用多语言兼容的检测方法
        return detectClickedTextByMultilingualSupport(location: location, layoutManager: layoutManager, textContainer: textContainer)
    }
    
    /// 检查点击位置是否在文本范围内（改进版本）
    private func isClickInTextRange(location: CGPoint, boundingRect: CGRect, text: String) -> Bool {
        // 添加点击容错区域
        let clickTolerance: CGFloat = 10.0
        let expandedRect = boundingRect.insetBy(dx: -clickTolerance, dy: -clickTolerance)
        
        // 检查点击位置是否在扩展的矩形内
        let isInExpandedRect = expandedRect.contains(location)
        
        if debugMode {
            print("🎯 点击检测 - 文本: '\(text)'")
            print("📐 原始边界: \(boundingRect)")
            print("📐 扩展边界: \(expandedRect)")
            print("📍 点击位置: \(location)")
            print("✅ 在扩展边界内: \(isInExpandedRect)")
        }
        
        return isInExpandedRect
    }
    
    /// 智能匹配检测方法
    private func detectClickedTextBySmartMatch(location: CGPoint, layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> (String, String?)? {
        guard let text = text, !text.isEmpty else { return nil }
        
        // 获取点击位置附近的文本
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex == NSNotFound { return nil }
        
        if debugMode {
            print("🔍 智能匹配 - 点击位置: \(location), 字符索引: \(characterIndex)")
        }
        
        // 方法1: 在点击位置附近搜索可点击文本
        let searchRadius = 100 // 增加搜索半径
        let searchStart = max(0, characterIndex - searchRadius)
        let searchLength = min(searchRadius * 2, text.count - searchStart)
        let searchRange = NSRange(location: searchStart, length: searchLength)
        
        if debugMode {
            print("🔍 智能匹配 - 搜索范围: \(searchRange)")
        }
        
        for (clickableText, link) in clickableTexts {
            // 在搜索范围内查找文本
            let foundRange = (text as NSString).range(of: clickableText, options: [], range: searchRange)
            if foundRange.location != NSNotFound {
                // 检查点击位置是否在找到的范围内
                if NSLocationInRange(characterIndex, foundRange) {
                    if debugMode {
                        print("✅ 智能匹配成功 - 找到匹配的点击文本: '\(clickableText)'")
                    }
                    return (clickableText, link)
                }
            }
        }
        
        // 方法2: 使用距离最近的文本
        return findNearestClickableText(location: location, layoutManager: layoutManager, textContainer: textContainer)
    }
    
    /// 查找距离点击位置最近的可点击文本
    private func findNearestClickableText(location: CGPoint, layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> (String, String?)? {
        guard let text = text, !text.isEmpty else { return nil }
        
        var nearestText: String?
        var nearestLink: String?
        var minDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        
        for (clickableText, link) in clickableTexts {
            let ranges = findTextRangesWithCache(clickableText, in: text, exactMatch: true)
            
            for range in ranges {
                let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                if glyphRange.location != NSNotFound && glyphRange.length > 0 {
                    let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                    
                    // 计算点击位置到文本中心的距离
                    let textCenter = CGPoint(x: boundingRect.midX, y: boundingRect.midY)
                    let distance = sqrt(pow(location.x - textCenter.x, 2) + pow(location.y - textCenter.y, 2))
                    
                    if debugMode {
                        print("🔍 距离检测 - 文本: '\(clickableText)', 中心: \(textCenter), 距离: \(distance)")
                    }
                    
                    // 如果距离小于阈值，认为是有效点击
                    let maxDistance: CGFloat = 50.0
                    if distance < maxDistance && distance < minDistance {
                        minDistance = distance
                        nearestText = clickableText
                        nearestLink = link
                    }
                }
            }
        }
        
        if let nearestText = nearestText {
            if debugMode {
                print("✅ 距离匹配成功 - 最近文本: '\(nearestText)', 距离: \(minDistance)")
            }
            return (nearestText, nearestLink)
        }
        
        if debugMode {
            print("❌ 智能匹配失败 - 未找到匹配的文本")
        }
        return nil
    }
    
    /// 多语言兼容的点击检测方法
    private func detectClickedTextByMultilingualSupport(location: CGPoint, layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> (String, String?)? {
        guard let text = text, !text.isEmpty else { return nil }
        
        if debugMode {
            print("🌍 多语言检测 - 点击位置: \(location)")
        }
        
        // 获取点击位置的行信息
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex == NSNotFound { return nil }
        
        // 获取点击位置所在的行
        let lineRange = layoutManager.lineFragmentRect(forGlyphAt: characterIndex, effectiveRange: nil)
        
        if debugMode {
            print("📏 点击行范围: \(lineRange)")
        }
        
        // 在该行中查找可点击文本
        for (clickableText, link) in clickableTexts {
            let ranges = findTextRangesWithCache(clickableText, in: text, exactMatch: true)
            
            for range in ranges {
                // 检查文本是否在点击行附近
                if range.location <= characterIndex && characterIndex <= range.location + range.length {
                    if debugMode {
                        print("✅ 多语言检测成功 - 找到匹配的点击文本: '\(clickableText)'")
                    }
                    return (clickableText, link)
                }
            }
        }
        
        // 如果行内检测失败，使用更宽松的检测
        return detectClickedTextByLooseMatch(location: location, characterIndex: characterIndex, layoutManager: layoutManager, textContainer: textContainer)
    }
    
    /// 宽松匹配检测方法
    private func detectClickedTextByLooseMatch(location: CGPoint, characterIndex: Int, layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> (String, String?)? {
        guard let text = text, !text.isEmpty else { return nil }
        
        if debugMode {
            print("🔍 宽松匹配 - 字符索引: \(characterIndex)")
        }
        
        // 在点击位置前后搜索可点击文本
        let searchRadius = 200 // 更大的搜索半径
        let searchStart = max(0, characterIndex - searchRadius)
        let searchLength = min(searchRadius * 2, text.count - searchStart)
        let searchRange = NSRange(location: searchStart, length: searchLength)
        
        for (clickableText, link) in clickableTexts {
            let foundRange = (text as NSString).range(of: clickableText, options: [], range: searchRange)
            if foundRange.location != NSNotFound {
                // 检查点击位置是否在文本范围内或附近
                let textStart = foundRange.location
                let textEnd = foundRange.location + foundRange.length
                let clickPosition = characterIndex
                
                // 允许一定的容错范围
                let tolerance = 20
                if clickPosition >= textStart - tolerance && clickPosition <= textEnd + tolerance {
                    if debugMode {
                        print("✅ 宽松匹配成功 - 找到匹配的点击文本: '\(clickableText)'")
                    }
                    return (clickableText, link)
                }
            }
        }
        
        if debugMode {
            print("❌ 宽松匹配失败 - 未找到匹配的文本")
        }
        return nil
    }
    
    private func findTextRangeInString(_ searchText: String, in fullText: String, searchRange: NSRange = NSRange(location: 0, length: 0)) -> NSRange {
        let actualSearchRange = searchRange.length == 0 ? NSRange(location: 0, length: fullText.count) : searchRange
        
        if debugMode {
            print("🔍 TFYSwiftLabel 搜索: '\(searchText)'")
            print("📝 在文本中: '\(fullText.prefix(100))...'")
            print("🎯 搜索范围: \(actualSearchRange)")
        }
        
        // 根据匹配策略选择不同的匹配方式
        switch matchStrategy {
        case .exact:
            return findExactMatch(searchText: searchText, in: fullText, searchRange: actualSearchRange)
        case .insensitive:
            return findInsensitiveMatch(searchText: searchText, in: fullText, searchRange: actualSearchRange)
        case .partial:
            return findPartialMatch(searchText: searchText, in: fullText, searchRange: actualSearchRange)
        case .smart:
            return findSmartMatch(searchText: searchText, in: fullText, searchRange: actualSearchRange)
        }
    }
    
    /// 精确匹配
    private func findExactMatch(searchText: String, in fullText: String, searchRange: NSRange) -> NSRange {
        let range = (fullText as NSString).range(of: searchText, options: [], range: searchRange)
        if debugMode && range.location != NSNotFound {
            print("✅ 精确匹配成功: 位置 \(range.location), 长度 \(range.length)")
        }
        return range
    }
    
    /// 忽略大小写匹配
    private func findInsensitiveMatch(searchText: String, in fullText: String, searchRange: NSRange) -> NSRange {
        let searchOptions: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]
        let range = (fullText as NSString).range(of: searchText, options: searchOptions, range: searchRange)
        if debugMode && range.location != NSNotFound {
            print("✅ 忽略大小写匹配成功: 位置 \(range.location), 长度 \(range.length)")
        }
        return range
    }
    
    /// 部分匹配
    private func findPartialMatch(searchText: String, in fullText: String, searchRange: NSRange) -> NSRange {
        let partialOptions: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]
        
        // 尝试匹配搜索文本的主要部分（去除空格）
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedSearchText.isEmpty {
            let range = (fullText as NSString).range(of: trimmedSearchText, options: partialOptions, range: searchRange)
            if range.location != NSNotFound {
        if debugMode {
                    print("✅ 部分匹配成功: 位置 \(range.location), 长度 \(range.length)")
                }
                return range
            }
        }
        
        return NSRange(location: NSNotFound, length: 0)
    }
    
    /// 智能匹配
    private func findSmartMatch(searchText: String, in fullText: String, searchRange: NSRange) -> NSRange {
        // 1. 首先尝试精确匹配
        let exactRange = findExactMatch(searchText: searchText, in: fullText, searchRange: searchRange)
        if exactRange.location != NSNotFound {
            return exactRange
        }
        
        // 2. 尝试忽略大小写和变音符号的匹配
        let insensitiveRange = findInsensitiveMatch(searchText: searchText, in: fullText, searchRange: searchRange)
        if insensitiveRange.location != NSNotFound {
            return insensitiveRange
        }
        
        // 3. 对于阿拉伯语等RTL语言，尝试反向搜索
        let reverseOptions: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive, .backwards]
        let reverseRange = (fullText as NSString).range(of: searchText, options: reverseOptions, range: searchRange)
        if reverseRange.location != NSNotFound {
            if debugMode {
                print("✅ 反向搜索匹配成功: 位置 \(reverseRange.location), 长度 \(reverseRange.length)")
            }
            return reverseRange
        }
        
        // 4. 智能部分匹配 - 处理复杂语言
        let partialResult = findAdvancedPartialMatch(searchText: searchText, in: fullText, searchRange: searchRange)
        if debugMode {
            if partialResult.location != NSNotFound {
                print("✅ 智能部分匹配成功: 位置 \(partialResult.location), 长度 \(partialResult.length)")
            } else {
                print("❌ 所有匹配方式都失败")
            }
        }
        return partialResult
    }
    
    /// 高级智能部分匹配算法，支持多语言
    private func findAdvancedPartialMatch(searchText: String, in fullText: String, searchRange: NSRange) -> NSRange {
        let partialOptions: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]
        
        // 1. 尝试匹配搜索文本的主要部分（去除空格）
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedSearchText.isEmpty {
            let trimmedRange = (fullText as NSString).range(of: trimmedSearchText, options: partialOptions, range: searchRange)
            if trimmedRange.location != NSNotFound {
                return trimmedRange
            }
        }
        
        // 2. 按单词分割进行智能匹配
        let words = searchText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        // 如果只有一个词，直接匹配
        if words.count == 1 {
            let word = words[0]
            if word.count > 2 { // 至少指定长度的字符
                let wordRange = (fullText as NSString).range(of: word, options: partialOptions, range: searchRange)
                if wordRange.location != NSNotFound {
                    return wordRange
                }
            }
            return NSRange(location: NSNotFound, length: 0)
        }
        
        // 3. 多词匹配 - 寻找最长的连续匹配
        var bestMatch = NSRange(location: NSNotFound, length: 0)
        var maxMatchedWords = 0
        
        for i in 0..<words.count {
            let word = words[i]
            if word.count <= 2 { continue } // 跳过过短的词
            
            let wordRange = (fullText as NSString).range(of: word, options: partialOptions, range: searchRange)
            if wordRange.location != NSNotFound {
                // 检查后续词是否也匹配（连续匹配）
                var matchedWords = 1
                var currentRange = wordRange
                
                for j in (i+1)..<words.count {
                    let nextWord = words[j]
                    if nextWord.count <= 2 { continue }
                    
                    // 在当前位置附近查找下一个词
                    let searchStart = currentRange.location + currentRange.length
                    let remainingText = (fullText as NSString).substring(from: searchStart)
                    let nextWordRange = (remainingText as NSString).range(of: nextWord, options: partialOptions)
                    
                    if nextWordRange.location != NSNotFound {
                        // 检查是否在合理距离内（避免跨段落匹配）
                        let actualLocation = searchStart + nextWordRange.location
                        let distance = actualLocation - (currentRange.location + currentRange.length)
                        
                        if distance <= 50 { // 在指定距离内认为是连续的
                            matchedWords += 1
                            currentRange = NSRange(location: currentRange.location, 
                                                length: actualLocation + nextWordRange.length - currentRange.location)
                        } else {
                            break
                        }
                    } else {
                        break
                    }
                }
                
                // 如果找到更长的匹配，更新最佳匹配
                if matchedWords > maxMatchedWords {
                    maxMatchedWords = matchedWords
                    bestMatch = currentRange
                }
            }
        }
        
        // 4. 如果找到了至少2个词的匹配，返回结果
        if maxMatchedWords >= 2 {
            return bestMatch
        }
        
        // 5. 最后尝试：匹配最重要的词（通常是第一个或最长的词）
        let importantWords = words.sorted { $0.count > $1.count }
        for word in importantWords {
            if word.count > 3 {
                let wordRange = (fullText as NSString).range(of: word, options: partialOptions, range: searchRange)
                if wordRange.location != NSNotFound {
                    return wordRange
                }
            }
        }
        
        return NSRange(location: NSNotFound, length: 0)
    }
    
    private func showClickHighlight(at location: CGPoint) {
        // 检测被点击的具体文字
        guard let (clickedText, _) = detectClickedText(at: location) else { return }
        
        guard let text = text, !text.isEmpty else { return }
        
        // 创建富文本
        let attributedString = NSMutableAttributedString(attributedString: self.attributedText ?? NSAttributedString(string: text))
        
        // 应用高亮效果
        let _ = applyHighlightEffect(to: attributedString, for: clickedText, style: highlightStyle)
        
        // 更新显示
        self.attributedText = attributedString
        
        // 延迟恢复 - 直接重新创建富文本，这样更可靠
        DispatchQueue.main.asyncAfter(deadline: .now() + clickHighlightDuration) { [weak self] in
            guard let self = self else { return }
            
            // 重新获取当前文本，确保一致性
            guard let currentText = self.text, !currentText.isEmpty else { return }
            
            // 直接重新创建富文本，这样会自动恢复原始样式
            self.updateAttributedText()
            
            if self.debugMode {
                print("🔄 高亮效果已恢复")
            }
        }
    }
    
}

// MARK: - 便捷方法扩展

public extension TFYSwiftLabel {
    
    /// 便捷设置方法 - 链式调用
    @discardableResult
    func clickableTexts(_ texts: [String: String], textColors: [UIColor], callback: @escaping TFYSwiftLabelClickCallback) -> Self {
        do {
            try setClickableTexts(texts, textColors: textColors, callback: callback)
        } catch {
            if debugMode {
                print("❌ 设置可点击文本失败: \(error.localizedDescription)")
            }
        }
        return self
    }
    
    /// 便捷设置方法 - 启用点击检测
    @discardableResult
    func enableClickDetection(_ enabled: Bool = true) -> Self {
        isClickDetectionEnabled = enabled
        return self
    }
    
    /// 便捷设置方法 - 点击高亮样式（颜色）
    @discardableResult
    func clickHighlight(color: UIColor, duration: TimeInterval = 0.2) -> Self {
        setClickHighlight(color: color, duration: duration)
        return self
    }
    
    /// 便捷设置方法 - 点击高亮样式（样式）
    @discardableResult
    func clickHighlight(style: TFYSwiftLabelHighlightStyle, duration: TimeInterval = 0.2) -> Self {
        setClickHighlight(style: style, duration: duration)
        return self
    }
    
    /// 便捷设置方法 - 调试模式
    @discardableResult
    func debugMode(_ enabled: Bool = true) -> Self {
        debugMode = enabled
        return self
    }
    
    /// 便捷设置方法 - 匹配策略
    @discardableResult
    func matchStrategy(_ strategy: TFYSwiftLabelMatchStrategy) -> Self {
        matchStrategy = strategy
        return self
    }
    
    /// 便捷设置方法 - 清除所有可点击文本
    @discardableResult
    func clearClickableTexts() -> Self {
        clearTextLabelColors()
        return self
    }
    
    /// 便捷设置方法 - 重置所有设置
    @discardableResult
    func reset() -> Self {
        clearTextLabelColors()
        isClickDetectionEnabled = true
        highlightStyle = .backgroundColor(UIColor.systemBlue.withAlphaComponent(0.3))
        clickHighlightDuration = 0.2
        matchStrategy = .smart
        debugMode = false
        isPerformanceMonitoringEnabled = false
        resetPerformanceStats()
        return self
    }
    
    /// 便捷设置方法 - 启用性能监控
    @discardableResult
    func enablePerformanceMonitoring(_ enabled: Bool = true) -> Self {
        isPerformanceMonitoringEnabled = enabled
        return self
    }
    
    /// 便捷设置方法 - 获取性能统计
    func getPerformanceStatistics() -> (matchCount: Int, cacheHitCount: Int, cacheHitRate: Double) {
        return getPerformanceStats()
    }
    
    /// 便捷设置方法 - 重置性能统计
    @discardableResult
    func resetPerformanceStatistics() -> Self {
        resetPerformanceStats()
        return self
    }
}

