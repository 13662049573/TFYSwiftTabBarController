//
//  TFYStitchImage.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/7/27.
//  用途：图片拼接工具，支持网格、横向、纵向、瀑布流等多种布局。
//  功能：提供高性能的图片拼接功能，支持多种布局类型和自定义配置。
//

import UIKit
import Foundation
import CoreImage
import CommonCrypto

/// 图片拼接布局类型
@frozen public enum TFYStitchLayoutType {
    /// 网格布局（自动计算行列数，保持正方形）
    case grid
    /// 固定列数的网格布局
    case fixedGrid(columns: Int)
    /// 横向布局（从左到右排列）
    case horizontal
    /// 纵向布局（从上到下排列）
    case vertical
    /// 瀑布流布局（多列不等高）
    case waterfall(columns: Int)
    /// 圆形布局（图片排列成圆形）
    case circular(radius: CGFloat)
    /// 螺旋布局（图片排列成螺旋形）
    case spiral
    /// 随机布局（随机位置排列）
    case random
    /// 自定义布局（通过闭包自定义位置）
    case custom(layout: (Int, CGSize, CGFloat) -> [CGRect])
    
    /// 获取布局类型的描述
    public var description: String {
        switch self {
        case .grid:
            return "网格布局"
        case .fixedGrid(let columns):
            return "固定\(columns)列网格布局"
        case .horizontal:
            return "横向布局"
        case .vertical:
            return "纵向布局"
        case .waterfall(let columns):
            return "\(columns)列瀑布流布局"
        case .circular(let radius):
            return "圆形布局(半径:\(radius))"
        case .spiral:
            return "螺旋布局"
        case .random:
            return "随机布局"
        case .custom:
            return "自定义布局"
        }
    }
}

/// 图片拼接配置
public struct TFYStitchConfig {
    /// 图片间距
    public var gap: CGFloat = 4
    /// 背景颜色
    public var backgroundColor: UIColor = .white
    /// 布局类型
    public var layoutType: TFYStitchLayoutType = .grid
    /// 是否保持图片原始比例
    public var keepAspectRatio: Bool = true
    /// 最大图片数量（0表示无限制）
    public var maxImageCount: Int = 0
    /// 圆角大小
    public var cornerRadius: CGFloat = 0
    /// 边距
    public var contentInsets: UIEdgeInsets = .zero
    /// 每页最大数量（分页显示时使用）
    public var itemsPerPage: Int = 0
    /// 图片质量（0.0-1.0）
    public var imageQuality: CGFloat = 1.0
    /// 是否启用缓存
    public var enableCache: Bool = true
    /// 缓存过期时间（秒）
    public var cacheExpirationTime: TimeInterval = 3600
    /// 是否启用异步处理
    public var enableAsync: Bool = false
    /// 图片缩放模式
    public var contentMode: UIView.ContentMode = .scaleAspectFill
    /// 是否添加阴影
    public var enableShadow: Bool = false
    /// 阴影配置
    public var shadowConfig: ShadowConfig = ShadowConfig()
    /// 是否添加边框
    public var enableBorder: Bool = false
    /// 边框配置
    public var borderConfig: BorderConfig = BorderConfig()
    
    /// 阴影配置
    public struct ShadowConfig {
        public var color: UIColor = .black
        public var offset: CGSize = CGSize(width: 0, height: 2)
        public var radius: CGFloat = 4
        public var opacity: Float = 0.3
        
        public init() {}
    }
    
    /// 边框配置
    public struct BorderConfig {
        public var color: UIColor = .clear
        public var width: CGFloat = 1
        public var style: BorderStyle = .solid
        
        public enum BorderStyle: Hashable {
            case solid
            case dashed
            case dotted
        }
        
        public init() {}
    }
    
    public init() {}
    
    /// 创建默认配置
    public static func `default`() -> TFYStitchConfig {
        return TFYStitchConfig()
    }
    
    /// 创建九宫格配置
    public static func nineGrid(gap: CGFloat = 4, cornerRadius: CGFloat = 0) -> TFYStitchConfig {
        var config = TFYStitchConfig()
        config.layoutType = .fixedGrid(columns: 3)
        config.gap = gap
        config.cornerRadius = cornerRadius
        config.maxImageCount = 9
        return config
    }
    
    /// 创建瀑布流配置
    public static func waterfall(columns: Int = 2, gap: CGFloat = 4) -> TFYStitchConfig {
        var config = TFYStitchConfig()
        config.layoutType = .waterfall(columns: columns)
        config.gap = gap
        config.keepAspectRatio = true
        return config
    }
    
    /// 创建横向布局配置
    public static func horizontal(gap: CGFloat = 4, keepAspectRatio: Bool = true) -> TFYStitchConfig {
        var config = TFYStitchConfig()
        config.layoutType = .horizontal
        config.gap = gap
        config.keepAspectRatio = keepAspectRatio
        return config
    }
    
    /// 创建纵向布局配置
    public static func vertical(gap: CGFloat = 4, keepAspectRatio: Bool = true) -> TFYStitchConfig {
        var config = TFYStitchConfig()
        config.layoutType = .vertical
        config.gap = gap
        config.keepAspectRatio = keepAspectRatio
        return config
    }
}

/// 图片拼接结果
public struct TFYStitchResult {
    /// 拼接后的图片数组
    public let images: [UIImage]
    /// 是否成功
    public let isSuccess: Bool
    /// 错误信息
    public let error: Error?
    /// 处理时间
    public let processingTime: TimeInterval
    /// 缓存键（如果启用缓存）
    public let cacheKey: String?
    
    public init(images: [UIImage], isSuccess: Bool, error: Error? = nil, processingTime: TimeInterval = 0, cacheKey: String? = nil) {
        self.images = images
        self.isSuccess = isSuccess
        self.error = error
        self.processingTime = processingTime
        self.cacheKey = cacheKey
    }
}

/// 图片拼接错误类型
public enum TFYStitchError: LocalizedError {
    case emptyImages
    case invalidSize
    case invalidConfig
    case processingFailed
    case cacheError
    case memoryError
    
    public var errorDescription: String? {
        switch self {
        case .emptyImages:
            return "图片数组为空"
        case .invalidSize:
            return "无效的尺寸参数"
        case .invalidConfig:
            return "无效的配置参数"
        case .processingFailed:
            return "图片处理失败"
        case .cacheError:
            return "缓存操作失败"
        case .memoryError:
            return "内存不足"
        }
    }
}

/// 图片拼接工具类
public class TFYStitchImage: NSObject {
    
    // MARK: - 私有属性
    
    /// 图片缓存
    private static let imageCache = NSCache<NSString, UIImage>()
    /// 缓存队列
    private static let cacheQueue = DispatchQueue(label: "com.tfy.stitchimage.cache", qos: .utility)
    /// 处理队列
    private static let processingQueue = DispatchQueue(label: "com.tfy.stitchimage.processing", qos: .userInitiated)
    
    // MARK: - 公共方法
    
    /// 拼接图片（支持分页）
    /// - Parameters:
    ///   - images: 待拼接的图片数组
    ///   - size: 最终图片尺寸
    ///   - config: 拼接配置
    ///   - completion: 完成回调
    public class func stitchImages(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig = TFYStitchConfig(),
        completion: @escaping (TFYStitchResult) -> Void
    ) {
        // 参数验证
        guard validateParameters(images: images, size: size, config: config) else {
            let error = TFYStitchError.invalidConfig
            completion(TFYStitchResult(images: [], isSuccess: false, error: error))
            return
        }
        
        // 检查缓存
        if config.enableCache {
            let cacheKey = generateCacheKey(images: images, size: size, config: config)
            if let cachedImage = getCachedImage(for: cacheKey) {
                completion(TFYStitchResult(images: [cachedImage], isSuccess: true, cacheKey: cacheKey))
                return
            }
        }
        
        // 异步处理
        if config.enableAsync {
            processingQueue.async {
                let result = performStitchImages(images: images, size: size, config: config)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        } else {
            let result = performStitchImages(images: images, size: size, config: config)
            completion(result)
        }
    }
    
    /// 同步拼接图片
    /// - Parameters:
    ///   - images: 待拼接的图片数组
    ///   - size: 最终图片尺寸
    ///   - config: 拼接配置
    /// - Returns: 拼接结果
    @discardableResult
    public class func stitchImagesSync(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig = TFYStitchConfig()
    ) -> TFYStitchResult {
        // 参数验证
        guard validateParameters(images: images, size: size, config: config) else {
            return TFYStitchResult(images: [], isSuccess: false, error: TFYStitchError.invalidConfig)
        }
        
        return performStitchImages(images: images, size: size, config: config)
    }
    
    // MARK: - 私有方法
    
    /// 参数验证
    private class func validateParameters(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig
    ) -> Bool {
        // 检查图片数组
        guard !images.isEmpty else {
            print("TFYStitchImage: 图片数组为空")
            return false
        }
        
        // 检查尺寸
        guard size.width > 0, size.height > 0 else {
            print("TFYStitchImage: 无效的尺寸参数")
            return false
        }
        
        // 检查配置
        guard config.gap >= 0,
              config.maxImageCount >= 0,
              config.itemsPerPage >= 0,
              config.imageQuality >= 0 && config.imageQuality <= 1 else {
            print("TFYStitchImage: 无效的配置参数")
            return false
        }
        
        return true
    }
    
    /// 生成缓存键
    private class func generateCacheKey(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig
    ) -> String {
        let imageHashes = images.map { $0.hashValue }.description
        let sizeString = "\(size.width)x\(size.height)"
        let configHash = config.hashValue
        
        return "stitch_\(imageHashes)_\(sizeString)_\(configHash)".sha256
    }
    
    /// 获取缓存的图片
    private class func getCachedImage(for key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    /// 缓存图片
    private class func cacheImage(_ image: UIImage, for key: String, expirationTime: TimeInterval) {
        cacheQueue.async {
            imageCache.setObject(image, forKey: key as NSString)
            
            // 设置过期时间
            DispatchQueue.main.asyncAfter(deadline: .now() + expirationTime) {
                imageCache.removeObject(forKey: key as NSString)
            }
        }
    }
    
    /// 执行图片拼接
    private class func performStitchImages(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig
    ) -> TFYStitchResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        do {
            // 处理图片数量限制
            let validImages = config.maxImageCount > 0 ? 
                Array(images.prefix(config.maxImageCount)) : images
            if config.maxImageCount > 0 && images.count > config.maxImageCount {
                print("TFYStitchImage: 图片数量超出最大限制，已截断到\(config.maxImageCount)张")
            }
            
            // 是否需要分页
            let resultImages: [UIImage]
            if config.itemsPerPage > 0 {
                resultImages = try splitAndStitchImages(
                    images: validImages,
                    size: size,
                    config: config
                )
            } else {
                if let image = try stitchImage(
                    images: validImages,
                    size: size,
                    config: config
                ) {
                    resultImages = [image]
                } else {
                    throw TFYStitchError.processingFailed
                }
            }
            
            let processingTime = CFAbsoluteTimeGetCurrent() - startTime
            
            // 缓存结果
            if config.enableCache && resultImages.count == 1 {
                let cacheKey = generateCacheKey(images: images, size: size, config: config)
                cacheImage(resultImages[0], for: cacheKey, expirationTime: config.cacheExpirationTime)
            }
            
            return TFYStitchResult(
                images: resultImages,
                isSuccess: true,
                processingTime: processingTime
            )
            
        } catch {
            let processingTime = CFAbsoluteTimeGetCurrent() - startTime
            return TFYStitchResult(
                images: [],
                isSuccess: false,
                error: error,
                processingTime: processingTime
            )
        }
    }
    
    /// 分页拼接图片
    private class func splitAndStitchImages(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig
    ) throws -> [UIImage] {
        var result: [UIImage] = []
        
        let pageSize = config.itemsPerPage
        let totalImages = images.count
        
        var currentIndex = 0
        while currentIndex < totalImages {
            let endIndex = min(currentIndex + pageSize, totalImages)
            let chunk = Array(images[currentIndex..<endIndex])
            
            if let image = try stitchImage(
                images: chunk,
                size: size,
                config: config
            ) {
                result.append(image)
            } else {
                throw TFYStitchError.processingFailed
            }
            
            currentIndex = endIndex
        }
        
        return result
    }
    
    /// 单页拼接图片
    private class func stitchImage(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig
    ) throws -> UIImage? {
        // 创建图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            throw TFYStitchError.processingFailed
        }
        
        // 绘制背景
        config.backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        // 获取图片位置
        let frames = getImageFrames(
            images: images,
            size: size,
            config: config
        )
        
        // 绘制图片
        print("TFYStitchImage: 开始绘制 \(images.count) 张图片")
        for (index, image) in images.enumerated() {
            guard index < frames.count else { 
                print("TFYStitchImage: 图片索引 \(index) 超出帧数组范围 \(frames.count)")
                break 
            }
            let frame = frames[index]
            print("TFYStitchImage: 绘制第 \(index + 1) 张图片，帧: \(frame)")
            
            // 绘制阴影
            if config.enableShadow {
                drawShadow(
                    in: frame,
                    config: config.shadowConfig,
                    context: context
                )
            }
            
            // 绘制图片
            if config.cornerRadius > 0 {
                drawImageWithCornerRadius(
                    image,
                    in: frame,
                    cornerRadius: config.cornerRadius,
                    contentMode: config.contentMode
                )
            } else {
                drawImage(
                    image,
                    in: frame,
                    keepAspectRatio: config.keepAspectRatio,
                    contentMode: config.contentMode
                )
            }
            
            // 绘制边框
            if config.enableBorder {
                drawBorder(
                    in: frame,
                    config: config.borderConfig,
                    context: context
                )
            }
        }
        print("TFYStitchImage: 图片绘制完成")
        
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw TFYStitchError.processingFailed
        }
        
        return resultImage
    }
    
    /// 获取图片位置数组
    private class func getImageFrames(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig
    ) -> [CGRect] {
        // 计算可用区域
        let availableSize = CGSize(
            width: size.width - config.contentInsets.left - config.contentInsets.right,
            height: size.height - config.contentInsets.top - config.contentInsets.bottom
        )
        
        // 验证可用区域
        guard availableSize.width > 0, availableSize.height > 0 else {
            print("TFYStitchImage: 可用区域无效，返回空数组")
            return []
        }
        
        // 根据布局类型计算位置
        var frames = [CGRect]()
        switch config.layoutType {
        case .grid:
            frames = calculateGridLayout(
                count: images.count,
                size: availableSize,
                gap: config.gap
            )
            
        case .fixedGrid(let columns):
            frames = calculateFixedGridLayout(
                count: images.count,
                columns: columns,
                size: availableSize,
                gap: config.gap
            )
            
        case .horizontal:
            frames = calculateHorizontalLayout(
                images: images,
                size: availableSize,
                gap: config.gap,
                keepAspectRatio: config.keepAspectRatio
            )
            
        case .vertical:
            frames = calculateVerticalLayout(
                images: images,
                size: availableSize,
                gap: config.gap,
                keepAspectRatio: config.keepAspectRatio
            )
            
        case .waterfall(let columns):
            frames = calculateWaterfallLayout(
                images: images,
                columns: columns,
                size: availableSize,
                gap: config.gap
            )
            
        case .circular(let radius):
            frames = calculateCircularLayout(
                images: images,
                radius: radius,
                size: availableSize,
                gap: config.gap
            )
            
        case .spiral:
            frames = calculateSpiralLayout(
                images: images,
                size: availableSize,
                gap: config.gap
            )
            
        case .random:
            frames = calculateRandomLayout(
                images: images,
                size: availableSize,
                gap: config.gap
            )
            
        case .custom(let layout):
            frames = layout(images.count, availableSize, config.gap)
        }
        
        // 验证并修正边界
        frames = validateAndFixFrames(frames, in: availableSize, config: config)
        
        // 应用边距
        return frames.map { frame in
            CGRect(
                x: frame.minX + config.contentInsets.left,
                y: frame.minY + config.contentInsets.top,
                width: frame.width,
                height: frame.height
            )
        }
    }
    
    /// 验证并修正帧边界
    private class func validateAndFixFrames(_ frames: [CGRect], in size: CGSize, config: TFYStitchConfig) -> [CGRect] {
        return frames.map { frame in
            var correctedFrame = frame
            
            // 确保不超出左边界
            if correctedFrame.minX < 0 {
                correctedFrame.origin.x = 0
            }
            
            // 确保不超出右边界
            if correctedFrame.maxX > size.width {
                correctedFrame.origin.x = size.width - correctedFrame.width
            }
            
            // 确保不超出上边界
            if correctedFrame.minY < 0 {
                correctedFrame.origin.y = 0
            }
            
            // 确保不超出下边界
            if correctedFrame.maxY > size.height {
                correctedFrame.origin.y = size.height - correctedFrame.height
            }
            
            return correctedFrame
        }
    }
    
    // MARK: - 私有方法
    
    /// 计算网格布局（自动计算行列数）
    private class func calculateGridLayout(
        count: Int,
        size: CGSize,
        gap: CGFloat
    ) -> [CGRect] {
        // 计算合适的列数
        let columns = Int(ceil(sqrt(Double(count))))
        let rows = Int(ceil(Double(count) / Double(columns)))
        
        // 计算单个item的尺寸
        let itemWidth = (size.width - gap * CGFloat(columns + 1)) / CGFloat(columns)
        let itemHeight = (size.height - gap * CGFloat(rows + 1)) / CGFloat(rows)
        
        var frames: [CGRect] = []
        for index in 0..<count {
            let row = index / columns
            let column = index % columns
            let frame = CGRect(
                x: gap + (itemWidth + gap) * CGFloat(column),
                y: gap + (itemHeight + gap) * CGFloat(row),
                width: itemWidth,
                height: itemHeight
            )
            frames.append(frame)
        }
        return frames
    }
    
    /// 计算横向布局
    private class func calculateHorizontalLayout(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat,
        keepAspectRatio: Bool
    ) -> [CGRect] {
        var frames: [CGRect] = []
        var xOffset: CGFloat = 0 // 从0开始，因为size已经是可用区域
        
        // 计算可用宽度（size已经是可用区域，不需要再减去gap）
        let availableWidth = size.width
        let totalGaps = CGFloat(max(0, images.count - 1)) * gap
        let totalImageWidth = availableWidth - totalGaps
        
        for image in images {
            var itemWidth: CGFloat
            if keepAspectRatio {
                let aspectRatio = image.size.width / image.size.height
                let maxWidth = totalImageWidth / CGFloat(images.count)
                let calculatedWidth = size.height * aspectRatio
                itemWidth = min(calculatedWidth, maxWidth)
            } else {
                itemWidth = totalImageWidth / CGFloat(images.count)
            }
            
            let frame = CGRect(
                x: xOffset,
                y: 0,
                width: itemWidth,
                height: size.height
            )
            frames.append(frame)
            
            xOffset += itemWidth + gap
        }
        return frames
    }
    
    /// 计算纵向布局
    private class func calculateVerticalLayout(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat,
        keepAspectRatio: Bool
    ) -> [CGRect] {
        var frames: [CGRect] = []
        var yOffset: CGFloat = 0 // 从0开始，因为size已经是可用区域
        
        // 计算可用高度（size已经是可用区域，不需要再减去gap）
        let availableHeight = size.height
        let totalGaps = CGFloat(max(0, images.count - 1)) * gap
        let totalImageHeight = availableHeight - totalGaps
        
        for image in images {
            var itemHeight: CGFloat
            if keepAspectRatio {
                let aspectRatio = image.size.width / image.size.height
                let maxHeight = totalImageHeight / CGFloat(images.count)
                let calculatedHeight = size.width / aspectRatio
                itemHeight = min(calculatedHeight, maxHeight)
            } else {
                itemHeight = totalImageHeight / CGFloat(images.count)
            }
            
            let frame = CGRect(
                x: 0,
                y: yOffset,
                width: size.width,
                height: itemHeight
            )
            frames.append(frame)
            
            yOffset += itemHeight + gap
        }
        return frames
    }
    
    /// 计算固定列数的网格布局
    private class func calculateFixedGridLayout(
        count: Int,
        columns: Int,
        size: CGSize,
        gap: CGFloat
    ) -> [CGRect] {
        let rows = Int(ceil(Double(count) / Double(columns)))
        let itemWidth = (size.width - gap * CGFloat(columns + 1)) / CGFloat(columns)
        let itemHeight = (size.height - gap * CGFloat(rows + 1)) / CGFloat(rows)
        
        var frames: [CGRect] = []
        for index in 0..<count {
            let row = index / columns
            let column = index % columns
            let frame = CGRect(
                x: gap + (itemWidth + gap) * CGFloat(column),
                y: gap + (itemHeight + gap) * CGFloat(row),
                width: itemWidth,
                height: itemHeight
            )
            frames.append(frame)
        }
        return frames
    }
    
    /// 计算瀑布流布局
    private class func calculateWaterfallLayout(
        images: [UIImage],
        columns: Int,
        size: CGSize,
        gap: CGFloat
    ) -> [CGRect] {
        let itemWidth = (size.width - gap * CGFloat(columns + 1)) / CGFloat(columns)
        var columnHeights = Array(repeating: gap, count: columns)
        var frames: [CGRect] = []
        
        for image in images {
            // 找到最短的列
            let minHeight = columnHeights.min() ?? gap
            let columnIndex = columnHeights.firstIndex(of: minHeight) ?? 0
            
            // 计算图片高度
            let aspectRatio = image.size.width / image.size.height
            let itemHeight = itemWidth / aspectRatio
            
            // 创建frame
            let frame = CGRect(
                x: gap + (itemWidth + gap) * CGFloat(columnIndex),
                y: minHeight,
                width: itemWidth,
                height: itemHeight
            )
            frames.append(frame)
            
            // 更新列高度
            columnHeights[columnIndex] = frame.maxY + gap
        }
        
        return frames
    }
    
    /// 计算圆形布局
    private class func calculateCircularLayout(
        images: [UIImage],
        radius: CGFloat,
        size: CGSize,
        gap: CGFloat
    ) -> [CGRect] {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let angleIncrement = CGFloat.pi * 2 / CGFloat(max(images.count, 1))
        var frames: [CGRect] = []
        
        // 计算安全半径（size已经是可用区域）
        let safeRadius = min(radius, min(size.width, size.height) / 2)
        
        // 计算每个图片的最大尺寸
        let maxImageSize = min(safeRadius * 0.8, min(size.width, size.height) / 4)
        
        for (index, image) in images.enumerated() {
            let angle = angleIncrement * CGFloat(index)
            
            // 计算图片在圆上的位置
            let circleX = center.x + cos(angle) * safeRadius
            let circleY = center.y + sin(angle) * safeRadius
            
            // 限制图片尺寸
            let imageWidth = min(image.size.width, maxImageSize)
            let imageHeight = min(image.size.height, maxImageSize)
            
            let frame = CGRect(
                x: circleX - imageWidth / 2,
                y: circleY - imageHeight / 2,
                width: imageWidth,
                height: imageHeight
            )
            frames.append(frame)
        }
        return frames
    }
    
    /// 计算螺旋布局
    private class func calculateSpiralLayout(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat
    ) -> [CGRect] {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radiusIncrement = (size.width + size.height) / 2 / CGFloat(max(images.count, 1))
        var currentRadius: CGFloat = radiusIncrement
        var currentAngle: CGFloat = 0
        var frames: [CGRect] = []
        
        // 计算最大安全半径（size已经是可用区域）
        let maxSafeRadius = min(size.width, size.height) / 2
        
        // 计算每个图片的最大尺寸
        let maxImageSize = min(maxSafeRadius * 0.6, min(size.width, size.height) / 6)
        
        for (_, image) in images.enumerated() {
            // 确保半径不会超出边界
            let safeRadius = min(currentRadius, maxSafeRadius)
            let x = center.x + cos(currentAngle) * safeRadius
            let y = center.y + sin(currentAngle) * safeRadius
            
            // 限制图片尺寸
            let imageWidth = min(image.size.width, maxImageSize)
            let imageHeight = min(image.size.height, maxImageSize)
            
            let frame = CGRect(
                x: x - imageWidth / 2,
                y: y - imageHeight / 2,
                width: imageWidth,
                height: imageHeight
            )
            frames.append(frame)
            
            currentRadius += radiusIncrement
            currentAngle += CGFloat.pi / 2 // 每次旋转90度
        }
        return frames
    }
    
    /// 计算随机布局
    private class func calculateRandomLayout(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat
    ) -> [CGRect] {
        var frames: [CGRect] = []
        let availableWidth = size.width
        let availableHeight = size.height
        
        // 计算每个图片的最大尺寸
        let maxImageSize = min(availableWidth, availableHeight) / 4
        
        for image in images {
            // 限制图片尺寸
            let imageWidth = min(image.size.width, maxImageSize)
            let imageHeight = min(image.size.height, maxImageSize)
            
            // 确保随机范围有效
            let maxX = max(0, availableWidth - imageWidth)
            let maxY = max(0, availableHeight - imageHeight)
            
            // 尝试找到不重叠的位置
            var attempts = 0
            var frame: CGRect
            var foundPosition = false
            
            repeat {
                let x = CGFloat.random(in: 0...maxX)
                let y = CGFloat.random(in: 0...maxY)
                
                frame = CGRect(
                    x: x,
                    y: y,
                    width: imageWidth,
                    height: imageHeight
                )
                
                // 检查是否与现有图片重叠
                let hasOverlap = frames.contains { existingFrame in
                    frame.intersects(existingFrame.insetBy(dx: -gap, dy: -gap))
                }
                
                if !hasOverlap {
                    foundPosition = true
                }
                
                attempts += 1
            } while !foundPosition && attempts < 50 // 最多尝试50次
            
            frames.append(frame)
        }
        return frames
    }
}

// MARK: - 便利方法
public extension TFYStitchImage {
    
    /// 创建九宫格布局
    class func createNineGrid(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat = 4,
        cornerRadius: CGFloat = 0
    ) -> UIImage? {
        let config = TFYStitchConfig.nineGrid(gap: gap, cornerRadius: cornerRadius)
        let result = stitchImagesSync(images: images, size: size, config: config)
        return result.images.first
    }
    
    /// 创建瀑布流布局
    class func createWaterfall(
        images: [UIImage],
        size: CGSize,
        columns: Int = 2,
        gap: CGFloat = 4
    ) -> UIImage? {
        let config = TFYStitchConfig.waterfall(columns: columns, gap: gap)
        let result = stitchImagesSync(images: images, size: size, config: config)
        return result.images.first
    }
    
    /// 创建横向布局
    class func createHorizontal(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat = 4,
        keepAspectRatio: Bool = true
    ) -> UIImage? {
        let config = TFYStitchConfig.horizontal(gap: gap, keepAspectRatio: keepAspectRatio)
        let result = stitchImagesSync(images: images, size: size, config: config)
        return result.images.first
    }
    
    /// 创建纵向布局
    class func createVertical(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat = 4,
        keepAspectRatio: Bool = true
    ) -> UIImage? {
        let config = TFYStitchConfig.vertical(gap: gap, keepAspectRatio: keepAspectRatio)
        let result = stitchImagesSync(images: images, size: size, config: config)
        return result.images.first
    }
    
    /// 创建圆形布局
    class func createCircular(
        images: [UIImage],
        size: CGSize,
        radius: CGFloat,
        gap: CGFloat = 4
    ) -> UIImage? {
        var config = TFYStitchConfig()
        config.layoutType = .circular(radius: radius)
        config.gap = gap
        config.keepAspectRatio = false // 改为false，确保图片能完整显示
        config.contentMode = .scaleToFill
        let result = stitchImagesSync(images: images, size: size, config: config)
        return result.images.first
    }
    
    /// 创建螺旋布局
    class func createSpiral(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat = 4
    ) -> UIImage? {
        var config = TFYStitchConfig()
        config.layoutType = .spiral
        config.gap = gap
        config.keepAspectRatio = false // 改为false，确保图片能完整显示
        config.contentMode = .scaleToFill
        let result = stitchImagesSync(images: images, size: size, config: config)
        return result.images.first
    }
    
    /// 创建随机布局
    class func createRandom(
        images: [UIImage],
        size: CGSize,
        gap: CGFloat = 4
    ) -> UIImage? {
        var config = TFYStitchConfig()
        config.layoutType = .random
        config.gap = gap
        config.keepAspectRatio = false // 改为false，确保图片能完整显示
        config.contentMode = .scaleToFill
        let result = stitchImagesSync(images: images, size: size, config: config)
        return result.images.first
    }
    
    /// 创建带阴影的拼接图片
    class func createWithShadow(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig,
        shadowColor: UIColor = .black,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowRadius: CGFloat = 4,
        shadowOpacity: Float = 0.3
    ) -> UIImage? {
        var newConfig = config
        newConfig.enableShadow = true
        newConfig.shadowConfig.color = shadowColor
        newConfig.shadowConfig.offset = shadowOffset
        newConfig.shadowConfig.radius = shadowRadius
        newConfig.shadowConfig.opacity = shadowOpacity
        let result = stitchImagesSync(images: images, size: size, config: newConfig)
        return result.images.first
    }
    
    /// 创建带边框的拼接图片
    class func createWithBorder(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig,
        borderColor: UIColor = .black,
        borderWidth: CGFloat = 1,
        borderStyle: TFYStitchConfig.BorderConfig.BorderStyle = .solid
    ) -> UIImage? {
        var newConfig = config
        newConfig.enableBorder = true
        newConfig.borderConfig.color = borderColor
        newConfig.borderConfig.width = borderWidth
        newConfig.borderConfig.style = borderStyle
        let result = stitchImagesSync(images: images, size: size, config: newConfig)
        return result.images.first
    }
    
    /// 清除缓存
    class func clearCache() {
        imageCache.removeAllObjects()
    }
    
    /// 获取缓存大小
    class func getCacheSize() -> Int {
        return imageCache.totalCostLimit
    }
    
    /// 设置缓存大小限制
    class func setCacheSizeLimit(_ limit: Int) {
        imageCache.totalCostLimit = limit
    }
}

// MARK: - 图片绘制方法
private extension TFYStitchImage {
    
    /// 绘制图片
    class func drawImage(
        _ image: UIImage,
        in rect: CGRect,
        keepAspectRatio: Bool,
        contentMode: UIView.ContentMode
    ) {
        let drawRect: CGRect
        
        if keepAspectRatio {
            drawRect = calculateAspectFitRect(image: image, in: rect, contentMode: contentMode)
        } else {
            drawRect = rect
        }
        
        image.draw(in: drawRect)
    }
    
    /// 绘制带圆角的图片
    class func drawImageWithCornerRadius(
        _ image: UIImage,
        in rect: CGRect,
        cornerRadius: CGFloat,
        contentMode: UIView.ContentMode
    ) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        // 创建圆角路径
        let path = UIBezierPath(
            roundedRect: rect,
            cornerRadius: cornerRadius
        )
        path.addClip()
        
        // 计算绘制区域
        let drawRect = calculateAspectFitRect(image: image, in: rect, contentMode: contentMode)
        image.draw(in: drawRect)
        
        context?.restoreGState()
    }
    
    /// 计算保持宽高比的绘制区域
    class func calculateAspectFitRect(
        image: UIImage,
        in rect: CGRect,
        contentMode: UIView.ContentMode
    ) -> CGRect {
        let imageRatio = image.size.width / image.size.height
        let rectRatio = rect.width / rect.height
        
        switch contentMode {
        case .scaleAspectFit:
            // 保持宽高比，完整显示
            if imageRatio > rectRatio {
                // 图片较宽，以宽度为准
                let height = rect.width / imageRatio
                return CGRect(
                    x: rect.minX,
                    y: rect.minY + (rect.height - height) / 2,
                    width: rect.width,
                    height: height
                )
            } else {
                // 图片较高，以高度为准
                let width = rect.height * imageRatio
                return CGRect(
                    x: rect.minX + (rect.width - width) / 2,
                    y: rect.minY,
                    width: width,
                    height: rect.height
                )
            }
            
        case .scaleAspectFill:
            // 保持宽高比，填充整个区域
            if imageRatio > rectRatio {
                // 图片较宽，以高度为准
                let width = rect.height * imageRatio
                return CGRect(
                    x: rect.minX + (rect.width - width) / 2,
                    y: rect.minY,
                    width: width,
                    height: rect.height
                )
            } else {
                // 图片较高，以宽度为准
                let height = rect.width / imageRatio
                return CGRect(
                    x: rect.minX,
                    y: rect.minY + (rect.height - height) / 2,
                    width: rect.width,
                    height: height
                )
            }
            
        case .scaleToFill:
            // 拉伸填充
            return rect
            
        case .center:
            // 居中显示，不缩放
            return CGRect(
                x: rect.minX + (rect.width - image.size.width) / 2,
                y: rect.minY + (rect.height - image.size.height) / 2,
                width: image.size.width,
                height: image.size.height
            )
            
        default:
            return rect
        }
    }
    
    /// 绘制阴影
    class func drawShadow(
        in rect: CGRect,
        config: TFYStitchConfig.ShadowConfig,
        context: CGContext
    ) {
        context.saveGState()
        
        // 设置阴影
        context.setShadow(
            offset: config.offset,
            blur: config.radius,
            color: config.color.cgColor
        )
        
        // 绘制阴影路径
        let shadowPath = UIBezierPath(rect: rect)
        shadowPath.fill()
        
        context.restoreGState()
    }
    
    /// 绘制边框
    class func drawBorder(
        in rect: CGRect,
        config: TFYStitchConfig.BorderConfig,
        context: CGContext
    ) {
        context.saveGState()
        
        // 设置边框颜色
        context.setStrokeColor(config.color.cgColor)
        context.setLineWidth(config.width)
        
        // 设置边框样式
        switch config.style {
        case .solid:
            context.setLineDash(phase: 0, lengths: [])
        case .dashed:
            context.setLineDash(phase: 0, lengths: [6, 3])
        case .dotted:
            context.setLineDash(phase: 0, lengths: [2, 2])
        }
        
        // 绘制边框
        context.stroke(rect)
        
        context.restoreGState()
    }
}

// MARK: - 扩展方法
private extension String {
    /// SHA256哈希（替代MD5）
    var sha256: String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// 快速哈希（用于缓存键，不用于安全目的）
    var quickHash: String {
        var hash = 0
        for char in self.unicodeScalars {
            hash = 31 &* hash &+ Int(char.value)
        }
        return String(format: "%x", abs(hash))
    }
}

// MARK: - 高级功能扩展
public extension TFYStitchImage {
    
    /// 创建带动画效果的拼接图片
    class func createAnimatedStitch(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig,
        animationDuration: TimeInterval = 0.3,
        animationOptions: UIView.AnimationOptions = [.curveEaseInOut]
    ) -> UIImage? {
        // 这里可以实现动画效果，暂时返回静态图片
        return stitchImagesSync(images: images, size: size, config: config).images.first
    }
    
    /// 创建带滤镜效果的拼接图片
    class func createWithFilter(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig,
        filter: CIFilter
    ) -> UIImage? {
        guard let result = stitchImagesSync(images: images, size: size, config: config).images.first else {
            return nil
        }
        
        // 应用滤镜
        return applyFilter(to: result, filter: filter)
    }
    
    /// 创建带模糊效果的拼接图片
    class func createWithBlur(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig,
        blurRadius: CGFloat = 10
    ) -> UIImage? {
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        return createWithFilter(images: images, size: size, config: config, filter: blurFilter!)
    }
    
    /// 创建带黑白效果的拼接图片
    class func createWithGrayscale(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig
    ) -> UIImage? {
        let grayscaleFilter = CIFilter(name: "CIColorControls")
        grayscaleFilter?.setValue(0.0, forKey: kCIInputSaturationKey)
        
        return createWithFilter(images: images, size: size, config: config, filter: grayscaleFilter!)
    }
    
    /// 批量处理图片拼接
    class func batchStitch(
        imageGroups: [[UIImage]],
        size: CGSize,
        config: TFYStitchConfig,
        completion: @escaping ([TFYStitchResult]) -> Void
    ) {
        let group = DispatchGroup()
        var results: [TFYStitchResult] = []
        let queue = DispatchQueue(label: "com.tfy.stitchimage.batch", qos: .userInitiated, attributes: .concurrent)
        
        for (_, images) in imageGroups.enumerated() {
            group.enter()
            queue.async {
                let result = stitchImagesSync(images: images, size: size, config: config)
                results.append(result)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
    
    /// 预加载图片拼接
    class func preloadStitch(
        images: [UIImage],
        size: CGSize,
        config: TFYStitchConfig,
        completion: @escaping (Bool) -> Void
    ) {
        processingQueue.async {
            let result = performStitchImages(images: images, size: size, config: config)
            DispatchQueue.main.async {
                completion(result.isSuccess)
            }
        }
    }
    
    /// 获取拼接统计信息
    class func getStatistics() -> StitchStatistics {
        return StitchStatistics(
            cacheSize: imageCache.totalCostLimit,
            cacheCount: imageCache.countLimit,
            processingQueueLabel: processingQueue.label,
            cacheQueueLabel: cacheQueue.label
        )
    }
}

// MARK: - 统计信息结构体
public struct StitchStatistics {
    public let cacheSize: Int
    public let cacheCount: Int
    public let processingQueueLabel: String
    public let cacheQueueLabel: String
    
    public init(cacheSize: Int, cacheCount: Int, processingQueueLabel: String, cacheQueueLabel: String) {
        self.cacheSize = cacheSize
        self.cacheCount = cacheCount
        self.processingQueueLabel = processingQueueLabel
        self.cacheQueueLabel = cacheQueueLabel
    }
}

// MARK: - 私有扩展方法
private extension TFYStitchImage {
    
    /// 应用滤镜
    class func applyFilter(to image: UIImage, filter: CIFilter) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// 优化图片尺寸
    class func optimizeImageSize(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    /// 压缩图片质量
    class func compressImage(_ image: UIImage, quality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: quality)
    }
}

// MARK: - 配置扩展
public extension TFYStitchConfig {
    
    /// 哈希值计算
    var hashValue: Int {
        var hasher = Hasher()
        hasher.combine(gap)
        hasher.combine(backgroundColor.hashValue)
        hasher.combine(keepAspectRatio)
        hasher.combine(maxImageCount)
        hasher.combine(cornerRadius)
        hasher.combine(contentInsets.top)
        hasher.combine(contentInsets.left)
        hasher.combine(contentInsets.bottom)
        hasher.combine(contentInsets.right)
        hasher.combine(itemsPerPage)
        hasher.combine(imageQuality)
        hasher.combine(enableCache)
        hasher.combine(cacheExpirationTime)
        hasher.combine(enableAsync)
        hasher.combine(contentMode.rawValue)
        hasher.combine(enableShadow)
        hasher.combine(enableBorder)
        
        // 添加阴影配置哈希
        if enableShadow {
            hasher.combine(shadowConfig.color.hashValue)
            hasher.combine(shadowConfig.offset.width)
            hasher.combine(shadowConfig.offset.height)
            hasher.combine(shadowConfig.radius)
            hasher.combine(shadowConfig.opacity)
        }
        
        // 添加边框配置哈希
        if enableBorder {
            hasher.combine(borderConfig.color.hashValue)
            hasher.combine(borderConfig.width)
            hasher.combine(borderConfig.style)
        }
        
        return hasher.finalize()
    }
    
    /// 复制配置
    func copy() -> TFYStitchConfig {
        var newConfig = TFYStitchConfig()
        newConfig.gap = self.gap
        newConfig.backgroundColor = self.backgroundColor
        newConfig.layoutType = self.layoutType
        newConfig.keepAspectRatio = self.keepAspectRatio
        newConfig.maxImageCount = self.maxImageCount
        newConfig.cornerRadius = self.cornerRadius
        newConfig.contentInsets = self.contentInsets
        newConfig.itemsPerPage = self.itemsPerPage
        newConfig.imageQuality = self.imageQuality
        newConfig.enableCache = self.enableCache
        newConfig.cacheExpirationTime = self.cacheExpirationTime
        newConfig.enableAsync = self.enableAsync
        newConfig.contentMode = self.contentMode
        newConfig.enableShadow = self.enableShadow
        newConfig.shadowConfig = self.shadowConfig
        newConfig.enableBorder = self.enableBorder
        newConfig.borderConfig = self.borderConfig
        return newConfig
    }
}

// MARK: - 布局类型扩展
public extension TFYStitchLayoutType {
    
    /// 获取布局类型的参数描述
    var parameters: String {
        switch self {
        case .grid:
            return "自动网格"
        case .fixedGrid(let columns):
            return "固定\(columns)列"
        case .horizontal:
            return "横向排列"
        case .vertical:
            return "纵向排列"
        case .waterfall(let columns):
            return "\(columns)列瀑布流"
        case .circular(let radius):
            return "圆形(半径:\(radius))"
        case .spiral:
            return "螺旋排列"
        case .random:
            return "随机排列"
        case .custom:
            return "自定义布局"
        }
    }
    
    /// 检查布局类型是否支持指定数量的图片
    func supportsImageCount(_ count: Int) -> Bool {
        switch self {
        case .grid, .horizontal, .vertical, .spiral, .random, .custom:
            return count > 0
        case .fixedGrid(let columns):
            return count > 0 && columns > 0
        case .waterfall(let columns):
            return count > 0 && columns > 0
        case .circular:
            return count > 0
        }
    }
}

// MARK: - 错误处理扩展
public extension TFYStitchError {
    
    /// 获取错误代码
    var errorCode: Int {
        switch self {
        case .emptyImages:
            return 1001
        case .invalidSize:
            return 1002
        case .invalidConfig:
            return 1003
        case .processingFailed:
            return 1004
        case .cacheError:
            return 1005
        case .memoryError:
            return 1006
        }
    }
    
    /// 获取错误建议
    var suggestion: String {
        switch self {
        case .emptyImages:
            return "请确保图片数组不为空"
        case .invalidSize:
            return "请检查尺寸参数是否大于0"
        case .invalidConfig:
            return "请检查配置参数是否有效"
        case .processingFailed:
            return "图片处理失败，请重试"
        case .cacheError:
            return "缓存操作失败，请检查内存"
        case .memoryError:
            return "内存不足，请释放一些内存后重试"
        }
    }
}

// MARK: - 性能监控
public extension TFYStitchImage {
    
    /// 性能监控配置
    struct PerformanceConfig {
        public var enableMonitoring: Bool = false
        public var logThreshold: TimeInterval = 1.0
        public var memoryThreshold: Int = 100 * 1024 * 1024 // 100MB
        
        public init() {}
    }
    
    /// 性能监控
    private static var performanceConfig = PerformanceConfig()
    
    /// 设置性能监控配置
    class func setPerformanceConfig(_ config: PerformanceConfig) {
        performanceConfig = config
    }
    
    /// 记录性能日志
    private class func logPerformance(_ message: String, time: TimeInterval) {
        guard performanceConfig.enableMonitoring else { return }
        
        if time > performanceConfig.logThreshold {
            print("TFYStitchImage Performance: \(message) - \(String(format: "%.3f", time))s")
        }
    }
    
    /// 检查内存使用
    private class func checkMemoryUsage() -> Bool {
        guard performanceConfig.enableMonitoring else { return true }
        
        let memoryUsage = getMemoryUsage()
        if memoryUsage > performanceConfig.memoryThreshold {
            print("TFYStitchImage Memory Warning: \(memoryUsage / 1024 / 1024)MB")
            return false
        }
        return true
    }
    
    /// 获取内存使用量
    private class func getMemoryUsage() -> Int {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Int(info.resident_size)
        } else {
            return 0
        }
    }
}
