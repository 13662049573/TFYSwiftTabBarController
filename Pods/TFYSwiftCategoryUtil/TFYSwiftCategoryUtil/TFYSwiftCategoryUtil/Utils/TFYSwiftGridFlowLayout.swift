//
//  TFYSwiftGridFlowLayout.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2025/2/14.
//  用途：自定义 UICollectionView 网格流式布局，支持动态列数、间距、补充视图等。
//

import UIKit

// MARK: - 网格流式布局代理协议
@objc public protocol TFYSwiftGridFlowLayoutDelegateFlowLayout: UICollectionViewDelegate {
    
    /// 获取指定section的列数
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - layout: 布局对象
    ///   - section: section索引
    /// - Returns: 列数
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        columnsCountForSection section: Int) -> Int
    
    /// 获取指定section的边距
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - layout: 布局对象
    ///   - section: section索引
    /// - Returns: 边距
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        insetForSection section: Int) -> UIEdgeInsets
    
    /// 获取指定section的行间距
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - layout: 布局对象
    ///   - section: section索引
    /// - Returns: 行间距
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        lineSpacingForSection section: Int) -> CGFloat
    
    /// 获取指定section的列间距
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - layout: 布局对象
    ///   - section: section索引
    /// - Returns: 列间距
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        interitemSpacingForSection section: Int) -> CGFloat
    
    /// 获取指定section的section间距
    /// - Parameters:
    ///   - collectionView: 集合视图
    ///   - layout: 布局对象
    ///   - section: section索引
    /// - Returns: section间距
    @objc optional func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        sectionSpacingForSection section: Int) -> CGFloat
}

// MARK: - 协议默认实现
public extension TFYSwiftGridFlowLayoutDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        columnsCountForSection section: Int) -> Int {
        return layout.columnsCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        insetForSection section: Int) -> UIEdgeInsets {
        return layout.edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        lineSpacingForSection section: Int) -> CGFloat {
        return layout.rowSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        interitemSpacingForSection section: Int) -> CGFloat {
        return layout.columnSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        sectionSpacingForSection section: Int) -> CGFloat {
        return layout.sectionSpacing
    }
}

public class TFYSwiftGridFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - 配置属性
    /// 默认列数
    public var columnsCount: Int = 2 {
        didSet { 
            guard oldValue != columnsCount else { return }
            invalidateLayout() 
        }
    }
    
    /// 行间距
    public var rowSpacing: CGFloat = 10 {
        didSet { 
            guard oldValue != rowSpacing else { return }
            invalidateLayout() 
        }
    }
    
    /// 列间距
    public var columnSpacing: CGFloat = 10 {
        didSet { 
            guard oldValue != columnSpacing else { return }
            invalidateLayout() 
        }
    }
    
    /// 边距
    public var edgeInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10) {
        didSet { 
            guard oldValue != edgeInsets else { return }
            invalidateLayout() 
        }
    }
    
    /// 是否等高模式
    public var isEqualHeight: Bool = true {
        didSet { 
            guard oldValue != isEqualHeight else { return }
            invalidateLayout() 
        }
    }
    
    /// 最大项目高度限制
    public var maxItemHeight: CGFloat? {
        didSet { 
            guard oldValue != maxItemHeight else { return }
            invalidateLayout() 
        }
    }
    
    /// Section间距
    public var sectionSpacing: CGFloat = 0 {
        didSet { 
            guard oldValue != sectionSpacing else { return }
            invalidateLayout() 
        }
    }
    
    /// 是否启用动画
    public var enableAnimation: Bool = true {
        didSet { 
            guard oldValue != enableAnimation else { return }
            invalidateLayout() 
        }
    }
    
    /// 是否启用拖拽排序
    public var enableDragSort: Bool = false {
        didSet { 
            guard oldValue != enableDragSort else { return }
            invalidateLayout() 
        }
    }
    
    /// 是否启用分页
    public var enablePaging: Bool = false {
        didSet { 
            guard oldValue != enablePaging else { return }
            invalidateLayout() 
        }
    }
    
    /// 缓存大小限制
    public var cacheSizeLimit: Int = 1000 {
        didSet { 
            guard oldValue != cacheSizeLimit else { return }
            cleanCacheIfNeeded() 
        }
    }
    
    // MARK: - 布局属性
    /// 布局属性缓存
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    /// 各section各列的高度
    private var sectionColumnsHeights: [[CGFloat]] = []
    
    /// 内容总高度
    private var contentHeight: CGFloat = 0
    
    /// 布局是否已准备
    private var isLayoutPrepared: Bool = false
    
    /// 上次的bounds
    private var lastBounds: CGRect = .zero
    
    /// 代理对象
    private weak var gridDelegate: TFYSwiftGridFlowLayoutDelegateFlowLayout? {
        return collectionView?.delegate as? TFYSwiftGridFlowLayoutDelegateFlowLayout
    }
    
    // MARK: - 布局计算
    public override func prepare() {
        guard let collectionView = collectionView else { 
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: collectionView为空", level: .warning)
            return 
        }
        
        // 检查是否需要重新布局
        let currentBounds = collectionView.bounds
        let needsFullRelayout = !isLayoutPrepared || 
                               currentBounds.width != lastBounds.width ||
                               currentBounds.height != lastBounds.height
        
        if needsFullRelayout {
            resetLayoutState()
            lastBounds = currentBounds
        }
        
        let sectionsCount = collectionView.numberOfSections
        for section in 0..<sectionsCount {
            prepareSectionLayout(section: section, collectionView: collectionView)
        }
        
        isLayoutPrepared = true
        cleanCacheIfNeeded()
    }
    
    /// 重置布局状态
    private func resetLayoutState() {
        cache.removeAll()
        sectionColumnsHeights.removeAll()
        contentHeight = 0
        isLayoutPrepared = false
    }
    
    /// 清理缓存（如果超过限制）
    private func cleanCacheIfNeeded() {
        guard cache.count > cacheSizeLimit else { return }
        
        // 保留最近的布局属性
        let sortedCache = cache.sorted { $0.indexPath.section < $1.indexPath.section || 
                                       ($0.indexPath.section == $1.indexPath.section && $0.indexPath.item < $1.indexPath.item) }
        
        let keepCount = min(cacheSizeLimit / 2, sortedCache.count)
        cache = Array(sortedCache.suffix(keepCount))
        
        TFYUtils.Logger.log("TFYSwiftGridFlowLayout: 缓存已清理，保留\(keepCount)个属性", level: .info)
    }
    
    /// 准备section布局
    private func prepareSectionLayout(section: Int, collectionView: UICollectionView) {
        guard section >= 0 else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: section索引无效: \(section)", level: .error)
            return
        }
        
        // 添加section间距（除了第一个section）
        if section > 0 {
            let sectionSpacing = getSectionSpacing(for: section - 1)
            contentHeight += sectionSpacing
        }
        
        // Header处理
        let headerIndexPath = IndexPath(item: 0, section: section)
        if let headerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath),
           headerAttributes.frame.height > 0 {
            cache.append(headerAttributes)
            contentHeight = headerAttributes.frame.maxY
        }
        
        // Items布局
        let columnsCount = getColumnsCount(for: section)
        guard columnsCount > 0 else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: section \(section) 的列数无效: \(columnsCount)", level: .error)
            return
        }
        
        let sectionInset = getSectionInset(for: section)
        let lineSpacing = getLineSpacing(for: section)
        let interitemSpacing = getInteritemSpacing(for: section)
        
        let contentWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        guard contentWidth > 0 else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: section \(section) 的内容宽度无效: \(contentWidth)", level: .error)
            return
        }
        
        let itemWidth = (contentWidth - CGFloat(columnsCount - 1) * interitemSpacing) / CGFloat(columnsCount)
        guard itemWidth > 0 else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: section \(section) 的项目宽度无效: \(itemWidth)", level: .error)
            return
        }
        
        // 初始化section列高度
        if section >= sectionColumnsHeights.count {
            let initialHeight = contentHeight + sectionInset.top
            sectionColumnsHeights.append(Array(repeating: initialHeight, count: columnsCount))
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: 初始化section \(section) 的列高度", level: .debug)
        }
        
        let itemsCount = collectionView.numberOfItems(inSection: section)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: section)
            if let attributes = layoutAttributesForItem(at: indexPath,
                                                      itemWidth: itemWidth,
                                                      sectionInset: sectionInset,
                                                      lineSpacing: lineSpacing,
                                                      interitemSpacing: interitemSpacing) {
                cache.append(attributes)
            }
        }
        
        // Footer处理
        let footerIndexPath = IndexPath(item: 0, section: section)
        if let footerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: footerIndexPath),
           footerAttributes.frame.height > 0 {
            cache.append(footerAttributes)
            contentHeight = footerAttributes.frame.maxY
        } else {
            let maxColumnHeight = sectionColumnsHeights[safe: section]?.max() ?? 0
            contentHeight = maxColumnHeight + sectionInset.bottom
        }
    }
    
    // MARK: - 补充视图布局
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                            at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: collectionView为空，无法创建补充视图属性", level: .warning)
            return nil
        }
        
        let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
                          ?? UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        let section = indexPath.section
        guard section >= 0 else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: section索引无效: \(section)", level: .error)
            return nil
        }
        
        let sectionInset = getSectionInset(for: section)
        var yPosition: CGFloat = 0
        var size: CGSize = .zero
        
        // 尺寸优先级：1.布局属性设置 2.代理方法 3.默认值
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            size = self.headerReferenceSize
            if size == .zero {
                // 尝试从UICollectionViewDelegateFlowLayout获取尺寸
                if let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                    size = flowLayoutDelegate.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? .zero
                }
            }
            yPosition = section == 0 ? contentHeight : contentHeight + sectionInset.top
            
        case UICollectionView.elementKindSectionFooter:
            size = self.footerReferenceSize
            if size == .zero {
                // 尝试从UICollectionViewDelegateFlowLayout获取尺寸
                if let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                    size = flowLayoutDelegate.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? .zero
                }
            }
            let maxColumnHeight = sectionColumnsHeights[safe: section]?.max() ?? 0
            yPosition = maxColumnHeight + sectionInset.bottom
            
        default:
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: 不支持的补充视图类型: \(elementKind)", level: .warning)
            return nil
        }
        
        // 安全尺寸处理
        let safeContentWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let validWidth = max(safeContentWidth, 0)
        let validHeight = max(size.height, 0)
        
        // 仅当有有效尺寸时返回属性
        guard validWidth > 0 && validHeight > 0 else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: 补充视图尺寸无效: width=\(validWidth), height=\(validHeight)", level: .debug)
            return nil
        }
        
        attributes.frame = CGRect(
            x: sectionInset.left,
            y: yPosition,
            width: validWidth,
            height: validHeight
        )
        
        // 更新全局内容高度
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            contentHeight = attributes.frame.maxY
        case UICollectionView.elementKindSectionFooter:
            contentHeight = attributes.frame.maxY
        default: break
        }
        
        return attributes
    }
    
    // MARK: - 单元格布局
    private func layoutAttributesForItem(at indexPath: IndexPath,
                                       itemWidth: CGFloat,
                                       sectionInset: UIEdgeInsets,
                                       lineSpacing: CGFloat,
                                       interitemSpacing: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section >= 0 && indexPath.section < sectionColumnsHeights.count else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: section索引越界: \(indexPath.section)", level: .error)
            return nil
        }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var columnHeights = sectionColumnsHeights[indexPath.section]
        
        guard let minHeight = columnHeights.min(),
              let minColumn = columnHeights.firstIndex(of: minHeight) else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: 无法找到最小高度列，section: \(indexPath.section)", level: .error)
            return nil
        }
        
        let x = sectionInset.left + CGFloat(minColumn) * (itemWidth + interitemSpacing)
        let y = minHeight
        
        var itemHeight = calculateItemHeight(at: indexPath, itemWidth: itemWidth)
        
        // 应用最大高度限制
        if let maxHeight = maxItemHeight {
            itemHeight = min(itemHeight, maxHeight)
        }
        
        // 应用可用高度限制
        if let collectionView = collectionView {
            let availableHeight = collectionView.bounds.height - y - sectionInset.bottom
            itemHeight = min(itemHeight, availableHeight)
        }
        
        // 确保高度为正数
        itemHeight = max(itemHeight, 1.0)
        
        attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        
        // 更新列高度
        columnHeights[minColumn] = y + itemHeight + lineSpacing
        sectionColumnsHeights[indexPath.section] = columnHeights
        
        return attributes
    }
    
    /// 计算项目高度
    private func calculateItemHeight(at indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        guard itemWidth > 0 else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: Item宽度必须大于0，当前值：\(itemWidth)，请检查列数和边距设置", level: .error)
            return 44.0 // 返回默认高度
        }
        
        if isEqualHeight {
            return itemWidth
        }
        
        guard let collectionView = collectionView else {
            TFYUtils.Logger.log("TFYSwiftGridFlowLayout: collectionView为空，使用默认高度", level: .warning)
            return itemWidth
        }
        
        // 尝试从UICollectionViewDelegateFlowLayout获取尺寸
        if let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            let size = flowLayoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? CGSize(width: itemWidth, height: itemWidth)
            return size.height
        }
        
        // 如果没有实现UICollectionViewDelegateFlowLayout，使用默认尺寸
        return itemWidth
    }
    
    // MARK: - 代理方法封装
    /// 获取指定section的列数
    private func getColumnsCount(for section: Int) -> Int {
        guard let collectionView = collectionView else { return columnsCount }
        return gridDelegate?.collectionView?(collectionView, layout: self, columnsCountForSection: section) ?? columnsCount
    }
    
    /// 获取指定section的边距
    private func getSectionInset(for section: Int) -> UIEdgeInsets {
        guard let collectionView = collectionView else { return edgeInsets }
        return gridDelegate?.collectionView?(collectionView, layout: self, insetForSection: section) ?? edgeInsets
    }
    
    /// 获取指定section的行间距
    private func getLineSpacing(for section: Int) -> CGFloat {
        guard let collectionView = collectionView else { return rowSpacing }
        return gridDelegate?.collectionView?(collectionView, layout: self, lineSpacingForSection: section) ?? rowSpacing
    }
    
    /// 获取指定section的列间距
    private func getInteritemSpacing(for section: Int) -> CGFloat {
        guard let collectionView = collectionView else { return columnSpacing }
        return gridDelegate?.collectionView?(collectionView, layout: self, interitemSpacingForSection: section) ?? columnSpacing
    }
    
    /// 获取指定section的section间距
    private func getSectionSpacing(for section: Int) -> CGFloat {
        guard let collectionView = collectionView else { return sectionSpacing }
        return gridDelegate?.collectionView?(collectionView, layout: self, sectionSpacingForSection: section) ?? sectionSpacing
    }
    
    // MARK: - 布局系统重写
    public override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: contentHeight)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.width != collectionView.bounds.width
    }
    
    // MARK: - 动画支持
    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard enableAnimation else { return nil }
        
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) ?? 
                        UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
        
        // 设置初始动画状态
        attributes.alpha = 0.0
        attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return attributes
    }
    
    public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard enableAnimation else { return nil }
        
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) ?? 
                        UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
        
        // 设置消失动画状态
        attributes.alpha = 0.0
        attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return attributes
    }
    
    // MARK: - 拖拽排序支持
    public override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        guard enableDragSort else { 
            return super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        }
        
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        
        // 设置拖拽时的视觉效果
        attributes.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        attributes.zIndex = 1000
        
        return attributes
    }
    
    // MARK: - 分页支持
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard enablePaging else { return proposedContentOffset }
        
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let targetOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        // 实现分页逻辑
        let pageHeight = collectionView.bounds.height
        let currentPage = round(targetOffset.y / pageHeight)
        let targetY = currentPage * pageHeight
        
        return CGPoint(x: targetOffset.x, y: targetY)
    }
    
    // MARK: - 实用方法
    /// 滚动到指定项目
    public func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard let collectionView = collectionView else { return }
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    /// 获取指定项目的frame
    public func frameForItem(at indexPath: IndexPath) -> CGRect? {
        return layoutAttributesForItem(at: indexPath)?.frame
    }
    
    /// 获取指定section的frame
    public func frameForSection(_ section: Int) -> CGRect? {
        guard section >= 0 && section < sectionColumnsHeights.count else { return nil }
        
        let sectionInset = getSectionInset(for: section)
        let minY = section == 0 ? 0 : (sectionColumnsHeights[safe: section - 1]?.max() ?? 0)
        let maxY = sectionColumnsHeights[safe: section]?.max() ?? 0
        
        guard let collectionView = collectionView else { return nil }
        
        // 考虑section的边距
        let frameX = sectionInset.left
        let frameY = minY
        let frameWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let frameHeight = maxY - minY + sectionInset.top + sectionInset.bottom
        
        return CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
    }
    
    /// 清除所有缓存
    public func clearCache() {
        cache.removeAll()
        sectionColumnsHeights.removeAll()
        contentHeight = 0
        isLayoutPrepared = false
        invalidateLayout()
    }
    
    /// 获取缓存统计信息
    public func getCacheStats() -> [String: Any] {
        return [
            "cacheCount": cache.count,
            "sectionsCount": sectionColumnsHeights.count,
            "contentHeight": contentHeight,
            "isLayoutPrepared": isLayoutPrepared
        ]
    }
    
    // MARK: - 调试支持
    @objc public func debugQuickLookObject() -> AnyObject? {
        var debugInfo = """
        === TFYSwiftGridFlowLayout 调试信息 ===
        配置信息:
        - 列数: \(columnsCount)
        - 行间距: \(rowSpacing)
        - 列间距: \(columnSpacing)
        - 边距: \(edgeInsets)
        - Section间距: \(sectionSpacing)
        - 等高模式: \(isEqualHeight)
        - 最大高度限制: \(maxItemHeight?.description ?? "无")
        - 启用动画: \(enableAnimation)
        - 启用拖拽排序: \(enableDragSort)
        - 启用分页: \(enablePaging)
        
        布局状态:
        - 缓存元素数量: \(cache.count)
        - Section数量: \(sectionColumnsHeights.count)
        - 内容高度: \(contentHeight)
        - 布局已准备: \(isLayoutPrepared)
        - 缓存大小限制: \(cacheSizeLimit)
        """
        
        if let collectionView = collectionView {
            debugInfo += "\n容器信息:\n- 容器尺寸: \(collectionView.bounds.size)\n- 代理类型: \(type(of: collectionView.delegate))"
        }
        
        // 添加各section的列高度信息
        debugInfo += "\n\n各Section列高度:"
        for (index, heights) in sectionColumnsHeights.enumerated() {
            debugInfo += "\n- Section \(index): \(heights)"
        }
        
        return debugInfo as NSString
    }
}

// 安全访问扩展
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 详细使用示例和示范

/*
 
 ========================================
 TFYSwiftGridFlowLayout 完整使用指南
 ========================================
 
 1. 基本设置和初始化
 ========================================
 
 // 创建布局对象
 let layout = TFYSwiftGridFlowLayout()
 
 // 基础配置
 layout.columnsCount = 3                    // 默认列数
 layout.rowSpacing = 10                     // 行间距
 layout.columnSpacing = 10                  // 列间距
 layout.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)  // 边距
 layout.isEqualHeight = true                // 等高模式
 layout.maxItemHeight = 200                 // 最大高度限制
 layout.sectionSpacing = 20                 // Section间距
 
 // 高级功能开关
 layout.enableAnimation = true              // 启用动画
 layout.enableDragSort = true               // 启用拖拽排序
 layout.enablePaging = false                // 启用分页
 layout.cacheSizeLimit = 500                // 缓存大小限制
 
 // 应用到CollectionView
 collectionView.setCollectionViewLayout(layout, animated: false)
 
 2. 代理协议实现
 ========================================
 
 // 实现自定义网格布局代理
 extension ViewController: TFYSwiftGridFlowLayoutDelegateFlowLayout {
     
     // 动态设置每个section的列数
     func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        columnsCountForSection section: Int) -> Int {
         switch section {
         case 0: return 2    // 第一个section显示2列
         case 1: return 3    // 第二个section显示3列
         default: return 4   // 其他section显示4列
         }
     }
     
     // 动态设置每个section的边距
     func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        insetForSection section: Int) -> UIEdgeInsets {
         switch section {
         case 0:
             return UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
         case 1:
             return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         default:
             return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
         }
     }
     
     // 动态设置每个section的行间距
     func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        lineSpacingForSection section: Int) -> CGFloat {
         return section == 0 ? 15 : 10
     }
     
     // 动态设置每个section的列间距
     func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        interitemSpacingForSection section: Int) -> CGFloat {
         return section == 0 ? 12 : 8
     }
     
     // 动态设置每个section的section间距
     func collectionView(_ collectionView: UICollectionView,
                        layout: TFYSwiftGridFlowLayout,
                        sectionSpacingForSection section: Int) -> CGFloat {
         return section == 0 ? 30 : 20
     }
 }
 
 // 实现标准UICollectionViewDelegateFlowLayout（用于项目尺寸和补充视图）
 extension ViewController: UICollectionViewDelegateFlowLayout {
     
     // 设置项目尺寸
     func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
         
         let layout = collectionViewLayout as! TFYSwiftGridFlowLayout
         
         // 如果启用等高模式，宽度由布局自动计算
         if layout.isEqualHeight {
             return CGSize(width: 0, height: 0) // 布局会自动处理
         }
         
         // 自定义尺寸逻辑
         switch indexPath.section {
         case 0:
             return CGSize(width: 150, height: 200)
         case 1:
             return CGSize(width: 120, height: 180)
         default:
             return CGSize(width: 100, height: 150)
         }
     }
     
     // 设置Header尺寸
     func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
         return CGSize(width: collectionView.bounds.width, height: 50)
     }
     
     // 设置Footer尺寸
     func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
         return CGSize(width: collectionView.bounds.width, height: 30)
     }
 }
 
 3. 实用方法调用示例
 ========================================
 
 // 获取指定项目的frame
 if let itemFrame = layout.frameForItem(at: IndexPath(item: 0, section: 0)) {
     print("项目frame: \(itemFrame)")
 }
 
 // 获取指定section的frame
 if let sectionFrame = layout.frameForSection(0) {
     print("Section frame: \(sectionFrame)")
 }
 
 // 滚动到指定项目
 layout.scrollToItem(at: IndexPath(item: 5, section: 1), 
                    at: .centeredVertically, 
                    animated: true)
 
 // 获取缓存统计信息
 let stats = layout.getCacheStats()
 print("缓存统计: \(stats)")
 
 // 清除缓存
 layout.clearCache()
 
 4. 高级功能使用
 ========================================
 
 // 拖拽排序实现
 extension ViewController {
     
     func setupDragSort() {
         // 启用拖拽排序
         layout.enableDragSort = true
         
         // 添加长按手势
         let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
         collectionView.addGestureRecognizer(longPress)
     }
     
     @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
         switch gesture.state {
         case .began:
             guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
             collectionView.beginInteractiveMovementForItem(at: indexPath)
         case .changed:
             collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
         case .ended:
             collectionView.endInteractiveMovement()
         default:
             collectionView.cancelInteractiveMovement()
         }
     }
 }
 
 // 分页功能使用
 extension ViewController {
     
     func setupPaging() {
         // 启用分页
         layout.enablePaging = true
         
         // 设置分页相关属性
         collectionView.isPagingEnabled = false // 让布局处理分页
         collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
     }
 }
 
 5. 调试和监控
 ========================================
 
 // 打印调试信息
 print(layout.debugQuickLookObject() ?? "")
 
 // 监控布局性能
 func monitorLayoutPerformance() {
     let stats = layout.getCacheStats()
     print("缓存项目数: \(stats["cacheCount"] ?? 0)")
     print("Section数量: \(stats["sectionsCount"] ?? 0)")
     print("内容高度: \(stats["contentHeight"] ?? 0)")
     print("布局已准备: \(stats["isLayoutPrepared"] ?? false)")
 }
 
 6. 常见使用场景
 ========================================
 
 // 场景1: 照片网格
 func setupPhotoGrid() {
     let layout = TFYSwiftGridFlowLayout()
     layout.columnsCount = 3
     layout.rowSpacing = 2
     layout.columnSpacing = 2
     layout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
     layout.isEqualHeight = true
     layout.enableAnimation = true
     
     collectionView.setCollectionViewLayout(layout, animated: false)
 }
 
 // 场景2: 商品列表
 func setupProductList() {
     let layout = TFYSwiftGridFlowLayout()
     layout.columnsCount = 2
     layout.rowSpacing = 15
     layout.columnSpacing = 10
     layout.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
     layout.isEqualHeight = false
     layout.maxItemHeight = 300
     layout.enableDragSort = true
     
     collectionView.setCollectionViewLayout(layout, animated: false)
 }
 
 // 场景3: 瀑布流布局
 func setupWaterfallLayout() {
     let layout = TFYSwiftGridFlowLayout()
     layout.columnsCount = 2
     layout.rowSpacing = 8
     layout.columnSpacing = 8
     layout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
     layout.isEqualHeight = false
     layout.enableAnimation = true
     
     collectionView.setCollectionViewLayout(layout, animated: false)
 }
 
 7. 性能优化建议
 ========================================
 
 // 1. 合理设置缓存大小
 layout.cacheSizeLimit = 1000 // 根据实际需求调整
 
 // 2. 避免频繁的布局失效
 // 批量更新时使用 performBatchUpdates
 collectionView.performBatchUpdates({
     // 批量操作
 }, completion: nil)
 
 // 3. 使用预估尺寸提高性能
 collectionView.estimatedItemSize = CGSize(width: 100, height: 100)
 
 // 4. 合理使用动画开关
 layout.enableAnimation = false // 大量数据时关闭动画
 
 8. 注意事项
 ========================================
 
 // 1. 确保代理方法正确实现
 // 2. 注意内存管理，及时清理缓存
 // 3. 大量数据时考虑分页加载
 // 4. 拖拽排序需要实现相应的数据源方法
 // 5. 分页功能与系统分页冲突时优先使用布局分页
 
 */
