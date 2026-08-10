//
//  TFYSwiftRTLAlignedFlowLayout.swift
//  TFYSwiftShortPlay
//
//  Created by cchen on 2025/9/29.
//

import Foundation
import UIKit

// MARK: - Delegate
public protocol TFYSwiftRTLAlignedFlowLayoutDelegate: AnyObject {
    // 全局 Header 视图（类似 UITableView.tableHeaderView），返回 nil 表示不使用全局 Header
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionHeaderViewIn collectionView: UICollectionView) -> UIView?
    // 全局 Header 高度（类似 UITableView.tableHeaderView），返回 nil 表示不使用全局 Header
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionHeaderHeightIn collectionView: UICollectionView) -> CGFloat?
    // 全局 Footer 视图（类似 UITableView.tableFooterView），返回 nil 表示不使用全局 Footer
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionFooterViewIn collectionView: UICollectionView) -> UIView?
    // 全局 Footer 高度（类似 UITableView.tableFooterView），返回 nil 表示不使用全局 Footer
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionFooterHeightIn collectionView: UICollectionView) -> CGFloat?
    // 每组是否为瀑布流（优先级：全局layoutMode/enableWaterfall > delegate）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, isWaterfallFor section: Int) -> Bool?
    // 每组列数（若返回 nil 且提供了 minimumItemWidth，将按最小宽度自适应列数）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, columnsFor section: Int, availableWidth: CGFloat) -> Int?
    // 每组最小单元宽度，用于自适应列数
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, minimumItemWidthFor section: Int, availableWidth: CGFloat) -> CGFloat?
    // 每组间距与内边距
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, interitemSpacingFor section: Int) -> CGFloat?
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, lineSpacingFor section: Int) -> CGFloat?
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, sectionInsetFor section: Int) -> UIEdgeInsets?
    // Header/Footer 尺寸（仅高度，宽度为集合视图宽度减去 inset）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, headerHeightFor section: Int, width: CGFloat) -> CGFloat?
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, footerHeightFor section: Int, width: CGFloat) -> CGFloat?
    // 每组是否使用「有框」insetGrouped 样式（由 layout 绘制整组圆角背景，可单独控制）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedFor section: Int) -> Bool?
    // 有框样式下，组相对 collectionView 的外边距（默认左右 16，上下 12）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedGroupInsetsFor section: Int) -> UIEdgeInsets?
    // 有框样式下，组的圆角半径（默认 10）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedCornerRadiusFor section: Int) -> CGFloat?
    // 有框样式下，组的背景色（返回 nil 则使用 layout.sectionGroupedBackgroundColor）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBackgroundColorFor section: Int) -> UIColor?
    // 有框样式下，组的边框宽度（返回 nil 则使用 layout.sectionGroupedBorderWidth，0 表示无边框）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderWidthFor section: Int) -> CGFloat?
    // 有框样式下，组的边框颜色（返回 nil 则使用 layout.sectionGroupedBorderColor 或按 section 的 sectionGroupedBorderColors）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderColorFor section: Int) -> UIColor?
    // 有框样式下，组的边框渐变色数组（返回非空且 count >= 2 时使用渐变边框，覆盖纯色边框）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderGradientColorsFor section: Int) -> [UIColor]?
    // 有框样式下，边框渐变方向（仅在边框渐变有效时使用，默认与 defaultGradientDirection 一致）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderGradientDirectionFor section: Int) -> TFYSwiftRTLAlignedFlowLayout.GradientDirection?
    // 有框样式下，圆角容器包含的范围：
    //   .full = 组头+内容+组尾；.itemsOnly = 仅内容区；
    //   .headerAndItems = 组头+内容（不含组尾）；.itemsAndFooter = 内容+组尾（不含组头）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedContentModeFor section: Int) -> TFYSwiftRTLAlignedFlowLayout.InsetGroupedContentMode?
    // 有框样式下，组背景的渐变色数组（返回 nil 则不使用渐变，沿用纯色背景）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedGradientColorsFor section: Int) -> [UIColor]?
    // 有框样式下，渐变方向（默认由 layout.defaultGradientDirection 决定）
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedGradientDirectionFor section: Int) -> TFYSwiftRTLAlignedFlowLayout.GradientDirection?
}

public extension TFYSwiftRTLAlignedFlowLayoutDelegate {
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionHeaderViewIn collectionView: UICollectionView) -> UIView? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionHeaderHeightIn collectionView: UICollectionView) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionFooterViewIn collectionView: UICollectionView) -> UIView? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, collectionFooterHeightIn collectionView: UICollectionView) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, isWaterfallFor section: Int) -> Bool? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, columnsFor section: Int, availableWidth: CGFloat) -> Int? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, minimumItemWidthFor section: Int, availableWidth: CGFloat) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, interitemSpacingFor section: Int) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, lineSpacingFor section: Int) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, sectionInsetFor section: Int) -> UIEdgeInsets? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, headerHeightFor section: Int, width: CGFloat) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, footerHeightFor section: Int, width: CGFloat) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedFor section: Int) -> Bool? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedGroupInsetsFor section: Int) -> UIEdgeInsets? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedCornerRadiusFor section: Int) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBackgroundColorFor section: Int) -> UIColor? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderWidthFor section: Int) -> CGFloat? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderColorFor section: Int) -> UIColor? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderGradientColorsFor section: Int) -> [UIColor]? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedBorderGradientDirectionFor section: Int) -> TFYSwiftRTLAlignedFlowLayout.GradientDirection? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedContentModeFor section: Int) -> TFYSwiftRTLAlignedFlowLayout.InsetGroupedContentMode? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedGradientColorsFor section: Int) -> [UIColor]? { nil }
    func layout(_ layout: TFYSwiftRTLAlignedFlowLayout, insetGroupedGradientDirectionFor section: Int) -> TFYSwiftRTLAlignedFlowLayout.GradientDirection? { nil }
}

// MARK: - Main Layout Class
public class TFYSwiftRTLAlignedFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Constants
    
    /// 用于浮点数比较的最小差值阈值（避免精度问题）
    private static let floatComparisonThreshold: CGFloat = 0.1
    /// 宽度匹配的误差范围
    private static let widthMatchTolerance: CGFloat = 0.5
    /// Header 视图的 zIndex
    private static let headerZIndex: Int = 1000
    /// Footer 视图的 zIndex
    private static let footerZIndex: Int = 500
    /// 有框（insetGrouped）背景 Decoration 的 kind
    public static let sectionBackgroundDecorationKind = "TFYSwiftRTLAlignedFlowLayout.SectionBackground"
    /// 有框样式默认组外边距（与 UITableView insetGrouped 接近）
    private static let defaultInsetGroupedInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    /// 有框样式默认圆角
    private static let defaultInsetGroupedCornerRadius: CGFloat = 10
    /// 默认高宽比（当无法获取 item 高度时使用）
    private static let defaultAspectRatio: CGFloat = 1.2
    
    // MARK: - Public Configurable Properties
    
    /// 有框（insetGrouped）样式的全局默认组背景色；未在 delegate 或 sectionGroupedBackgroundColors 中指定时使用
    public var sectionGroupedBackgroundColor: UIColor = .secondarySystemGroupedBackground
    
    /// 有框样式中「每个分组独立」的背景色：key 为 section 索引，value 为该组的背景色。优先级高于 sectionGroupedBackgroundColor，低于 delegate 的 insetGroupedBackgroundColorFor
    public var sectionGroupedBackgroundColors: [Int: UIColor] = [:]
    
    /// 有框样式中「每个分组独立」的渐变色数组：key 为 section 索引，value 为该组的颜色数组。优先级高于 sectionGroupedBackgroundColor，低于 delegate 的 insetGroupedGradientColorsFor
    public var sectionGroupedGradientColors: [Int: [UIColor]] = [:]
    
    /// 相邻两个有框（insetGrouped）组之间的垂直间隙，避免圆角组贴在一起。默认 12pt
    public var spacingBetweenGroupedSections: CGFloat = 10
    
    /// 有框样式的边框宽度，0 表示无边框。可由 delegate 的 insetGroupedBorderWidthFor 按 section 覆盖
    public var sectionGroupedBorderWidth: CGFloat = 0
    /// 有框样式的默认边框颜色；未在 delegate 或 sectionGroupedBorderColors 中指定时使用，nil 表示使用系统分隔色
    public var sectionGroupedBorderColor: UIColor?
    /// 有框样式中按 section 的边框颜色，优先级高于 sectionGroupedBorderColor，低于 delegate 的 insetGroupedBorderColorFor
    public var sectionGroupedBorderColors: [Int: UIColor] = [:]
    /// 有框样式中按 section 的边框渐变色数组；非空且 count >= 2 时使用渐变边框，优先级低于 delegate 的 insetGroupedBorderGradientColorsFor
    public var sectionGroupedBorderGradientColors: [Int: [UIColor]] = [:]
    
    /// 有框样式下圆角容器的默认包含范围；未在 delegate 的 insetGroupedContentModeFor 中指定时使用
    public var defaultInsetGroupedContentMode: InsetGroupedContentMode = .full
    
    /// 有框样式下渐变方向的默认值；未在 delegate 的 insetGroupedGradientDirectionFor 中指定时使用
    public var defaultGradientDirection: GradientDirection = .vertical
    
    /// 当系统代理设置了header/footer宽度时，是否限制宽度不超过可用宽度减去inset
    /// 默认值为 false，完全使用系统代理设置的宽度，不减去inset
    /// 设置为 true 时，限制宽度不超过可用宽度减去inset
    public var shouldLimitHeaderFooterWidthByInset: Bool = false
    
    /// 内部缓存的全局 Header 高度（类似 UITableView.tableHeaderView），由自定义代理提供。
    /// 仅影响布局的起始 Y 偏移，不会干扰各 section 的 Header/Footer 逻辑。
    private var globalHeaderHeight: CGFloat = 0 {
        didSet {
            if abs(oldValue - globalHeaderHeight) > Self.floatComparisonThreshold {
                invalidateLayout()
            }
        }
    }
    
    /// 内部缓存的全局 Header 视图（类似 UITableView.tableHeaderView），由自定义代理提供。
    private var collectionHeaderView: UIView?
    
    /// 内部缓存的全局 Footer 高度（类似 UITableView.tableFooterView），由自定义代理提供。
    /// 仅影响内容总高度，不会干扰各 section 的 Footer 逻辑。
    private var globalFooterHeight: CGFloat = 0 {
        didSet {
            if abs(oldValue - globalFooterHeight) > Self.floatComparisonThreshold {
                invalidateLayout()
            }
        }
    }
    
    /// 内部缓存的全局 Footer 视图（类似 UITableView.tableFooterView），由自定义代理提供。
    private var collectionFooterView: UIView?
    
    // MARK: - Enums
    
    public enum HorizontalAlignment { case leading, center, trailing }
    public enum LayoutMode { case flow, waterfall }

    /// 有框（insetGrouped）圆角容器的包含范围，可按 section 独立控制
    public enum InsetGroupedContentMode {
        /// 圆角容器包含：组头 + 内容区 + 组尾（与原有行为一致）
        case full
        /// 圆角容器仅包含内容区（不包含组头、组尾）；无组头组尾时与 full 效果相同
        case itemsOnly
        /// 圆角容器包含组头 + 内容区，不包含组尾
        case headerAndItems
        /// 圆角容器包含内容区 + 组尾，不包含组头
        case itemsAndFooter
    }
    
    /// 渐变方向
    public enum GradientDirection {
        /// 从上到下
        case vertical
        /// 从左到右
        case horizontal
    }
    
    // MARK: - Section Configuration Cache
    
    /// 缓存每个 section 的布局配置，避免在同一次 prepare 中重复调用 delegate
    private struct SectionConfig {
        let baseSectionInset: UIEdgeInsets
        let useInsetGrouped: Bool
        let groupInsets: UIEdgeInsets
        let effectiveSectionInset: UIEdgeInsets
        let interitemSpacing: CGFloat
        let lineSpacing: CGFloat
        let headerHeight: CGFloat
        let footerHeight: CGFloat
        let isWaterfall: Bool
    }
    
    // MARK: - Private Properties
    
    /// 缓存的布局属性
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    /// 缓存的最大 Y 值（避免 collectionViewContentSize 每次遍历）
    private var cachedMaxY: CGFloat = 0
    /// 上次的内容尺寸（用于检测变化）
    private var lastContentSize = CGSize.zero
    /// 上次的集合视图宽度（用于检测旋转等变化）
    private var lastCollectionViewWidth: CGFloat = 0
    /// 上次的item数量（用于检测数据变化）
    private var lastItemCounts: [Int: Int] = [:]
    
    // 瀑布流相关属性
    /// 当前各列的高度
    private var columnHeights: [CGFloat] = []
    /// 默认列数（可通过初始化参数或delegate修改）
    public private(set) var columnCount: Int = 2
    /// 缓存的item高度和对应的宽度
    private var itemHeights: [IndexPath: (height: CGFloat, width: CGFloat)] = [:]
    /// 启用瀑布流的section集合
    private var waterfallSections: Set<Int> = []
    
    /// 水平对齐方式
    private(set) var horizontalAlignment: HorizontalAlignment
    /// 集合视图宽度（会在prepare中同步）
    private(set) var collectionViewWidth: CGFloat
    /// 是否为RTL布局
    private(set) var isRTL: Bool = false
    /// 布局模式
    private(set) var layoutMode: LayoutMode = .flow
    
    /// 自定义delegate（用于按section配置布局）
    public weak var sectionDelegate: TFYSwiftRTLAlignedFlowLayoutDelegate?

    // MARK: - Initialization
    
    public init(horizontalAlignment: HorizontalAlignment = .leading,
                collectionViewWidth: CGFloat = UIScreen.main.bounds.width,
                layoutMode: LayoutMode = .flow,
                columnCount: Int = 2) {
        self.horizontalAlignment = horizontalAlignment
        self.collectionViewWidth = collectionViewWidth
        self.layoutMode = layoutMode
        self.columnCount = max(1, columnCount)
        super.init()
        register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: Self.sectionBackgroundDecorationKind)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Section Property Resolution
    
    /// 判断指定 section 是否使用瀑布流布局（统一判断逻辑，消除重复）
    private func isSectionWaterfall(_ section: Int) -> Bool {
        if layoutMode == .waterfall || waterfallSections.contains(section) { return true }
        return sectionDelegate?.layout(self, isWaterfallFor: section) ?? false
    }
    
    /// 解析某 section 的有框背景色：delegate > sectionGroupedBackgroundColors[section] > sectionGroupedBackgroundColor
    private func resolvedGroupedBackgroundColor(for section: Int) -> UIColor {
        if let c = sectionDelegate?.layout(self, insetGroupedBackgroundColorFor: section) { return c }
        if let c = sectionGroupedBackgroundColors[section] { return c }
        return sectionGroupedBackgroundColor
    }
    
    private func resolvedGroupedBorderWidth(for section: Int) -> CGFloat {
        sectionDelegate?.layout(self, insetGroupedBorderWidthFor: section) ?? sectionGroupedBorderWidth
    }
    
    private func resolvedGroupedBorderColor(for section: Int) -> UIColor? {
        if let c = sectionDelegate?.layout(self, insetGroupedBorderColorFor: section) { return c }
        if let c = sectionGroupedBorderColors[section] { return c }
        return sectionGroupedBorderColor
    }
    
    /// 返回某 section 的边框渐变颜色数组：delegate > sectionGroupedBorderGradientColors[section] > nil
    private func resolvedGroupedBorderGradientColors(for section: Int) -> [UIColor]? {
        if let colors = sectionDelegate?.layout(self, insetGroupedBorderGradientColorsFor: section) {
            return colors
        }
        return sectionGroupedBorderGradientColors[section]
    }
    
    /// 返回某 section 的边框渐变方向：delegate > defaultGradientDirection
    private func resolvedGroupedBorderGradientDirection(for section: Int) -> GradientDirection {
        sectionDelegate?.layout(self, insetGroupedBorderGradientDirectionFor: section) ?? defaultGradientDirection
    }
    
    /// 返回某 section 的圆角容器包含范围：delegate > defaultInsetGroupedContentMode
    private func resolvedInsetGroupedContentMode(for section: Int) -> InsetGroupedContentMode {
        sectionDelegate?.layout(self, insetGroupedContentModeFor: section) ?? defaultInsetGroupedContentMode
    }
    
    /// 返回某 section 的渐变颜色数组：delegate > sectionGroupedGradientColors[section] > nil（不使用渐变）
    private func resolvedGradientColors(for section: Int) -> [UIColor]? {
        if let colors = sectionDelegate?.layout(self, insetGroupedGradientColorsFor: section) {
            return colors
        }
        return sectionGroupedGradientColors[section]
    }
    
    /// 返回某 section 的渐变方向：delegate > defaultGradientDirection
    private func resolvedGradientDirection(for section: Int) -> GradientDirection {
        sectionDelegate?.layout(self, insetGroupedGradientDirectionFor: section) ?? defaultGradientDirection
    }
    
    /// 返回某 section 的「有效」内边距：若该 section 启用有框（insetGrouped）则为基础 sectionInset + 组外边距，否则为基础 sectionInset。
    /// 用于与系统 UICollectionViewDelegateFlowLayout 的 insetForSectionAt / sizeForItemAt 保持一致，避免 cell 宽度按小 inset 算导致溢出。
    public func effectiveSectionInset(for section: Int) -> UIEdgeInsets {
        let base = sectionDelegate?.layout(self, sectionInsetFor: section) ?? sectionInset
        let useInsetGrouped = sectionDelegate?.layout(self, insetGroupedFor: section) ?? false
        guard useInsetGrouped else { return base }
        let groupInsets = sectionDelegate?.layout(self, insetGroupedGroupInsetsFor: section) ?? Self.defaultInsetGroupedInsets
        return combinedInsets(base: base, extra: groupInsets)
    }
    
    /// 合并基础内边距与额外内边距
    private func combinedInsets(base: UIEdgeInsets, extra: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(
            top: base.top + extra.top,
            left: base.left + extra.left,
            bottom: base.bottom + extra.bottom,
            right: base.right + extra.right
        )
    }
    
    /// 构建指定 section 的布局配置（一次性解析所有 delegate 属性，避免重复调用）
    private func buildSectionConfig(for section: Int,
                                    collectionView: UICollectionView,
                                    systemDelegate: UICollectionViewDelegateFlowLayout?) -> SectionConfig {
        let availableWidth = collectionView.bounds.width
        
        let baseSectionInset = sectionDelegate?.layout(self, sectionInsetFor: section) ?? sectionInset
        let useInsetGrouped = sectionDelegate?.layout(self, insetGroupedFor: section) ?? false
        let groupInsets: UIEdgeInsets = useInsetGrouped
            ? (sectionDelegate?.layout(self, insetGroupedGroupInsetsFor: section) ?? Self.defaultInsetGroupedInsets)
            : .zero
        
        let effectiveInset: UIEdgeInsets
        if useInsetGrouped {
            effectiveInset = combinedInsets(base: baseSectionInset, extra: groupInsets)
        } else {
            effectiveInset = systemDelegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? baseSectionInset
        }
        
        let interitem: CGFloat = systemDelegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section)
            ?? sectionDelegate?.layout(self, interitemSpacingFor: section)
            ?? minimumInteritemSpacing
        
        let lineSpacing: CGFloat = systemDelegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section)
            ?? sectionDelegate?.layout(self, lineSpacingFor: section)
            ?? minimumLineSpacing
        
        let headerH: CGFloat = {
            if let headerSize = systemDelegate?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section),
               headerSize.height > 0 {
                return headerSize.height
            }
            return sectionDelegate?.layout(self, headerHeightFor: section, width: availableWidth) ?? 0
        }()
        
        let footerH: CGFloat = {
            if let footerSize = systemDelegate?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section),
               footerSize.height > 0 {
                return footerSize.height
            }
            return sectionDelegate?.layout(self, footerHeightFor: section, width: availableWidth) ?? 0
        }()
        
        return SectionConfig(
            baseSectionInset: baseSectionInset,
            useInsetGrouped: useInsetGrouped,
            groupInsets: groupInsets,
            effectiveSectionInset: effectiveInset,
            interitemSpacing: interitem,
            lineSpacing: lineSpacing,
            headerHeight: headerH,
            footerHeight: footerH,
            isWaterfall: isSectionWaterfall(section)
        )
    }
    
    // MARK: - Layout Lifecycle
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        // 仅在 size 变化（如旋转、布局尺寸变更）时重新计算布局；
        // 纯滚动（bounds.origin 改变）不触发布局失效，避免 Decoration 视图在滚动过程中频繁重建导致闪烁。
        return newBounds.size != collectionView.bounds.size
    }
    
    /// 当外部调用 `reloadData` 或数据源计数整体失效时，强制清空内部缓存，
    /// 使下一次 `prepare()` 必然重建所有布局属性（包括 section 背景的颜色与渐变）。
    override public func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        if context.invalidateEverything || context.invalidateDataSourceCounts {
            cachedAttributes.removeAll(keepingCapacity: false)
            cachedMaxY = 0
            lastContentSize = .zero
            lastCollectionViewWidth = 0
            lastItemCounts.removeAll(keepingCapacity: false)
            columnHeights.removeAll(keepingCapacity: false)
        }
    }
    
    override public func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        collectionViewWidth = collectionView.bounds.width
        
        isRTL = UIView.userInterfaceLayoutDirection(
            for: collectionView.semanticContentAttribute
        ) == .rightToLeft
        
        // 根据自定义代理更新全局 Header / Footer（tableHeaderView / tableFooterView 风格）
        let desiredGlobalHeaderHeight = max(0, sectionDelegate?.layout(self, collectionHeaderHeightIn: collectionView) ?? 0)
        let headerFromDelegate = sectionDelegate?.layout(self, collectionHeaderViewIn: collectionView)
        
        if headerFromDelegate !== collectionHeaderView {
            collectionHeaderView?.removeFromSuperview()
            collectionHeaderView = headerFromDelegate
        }
        
        if let headerView = collectionHeaderView {
            let width = collectionView.bounds.width
            headerView.frame = CGRect(x: 0, y: 0, width: width, height: desiredGlobalHeaderHeight)
            if headerView.superview !== collectionView {
                collectionView.addSubview(headerView)
            }
            collectionView.bringSubviewToFront(headerView)
        }
        
        globalHeaderHeight = desiredGlobalHeaderHeight
        
        let desiredGlobalFooterHeight = max(0, sectionDelegate?.layout(self, collectionFooterHeightIn: collectionView) ?? 0)
        let footerFromDelegate = sectionDelegate?.layout(self, collectionFooterViewIn: collectionView)
        
        if footerFromDelegate !== collectionFooterView {
            collectionFooterView?.removeFromSuperview()
            collectionFooterView = footerFromDelegate
        }
        
        // 检测数据变化
        let totalSections = collectionView.numberOfSections
        var currentItemCounts = [Int: Int](minimumCapacity: totalSections)
        var hasDataChanged = lastItemCounts.count != totalSections
        
        for section in 0..<totalSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            currentItemCounts[section] = itemCount
            if !hasDataChanged {
                if lastItemCounts[section] != itemCount {
                    hasDataChanged = true
                }
            }
        }
        
        let baseContentSize = super.collectionViewContentSize
        let currentWidth = collectionView.bounds.width
        let needUpdate = cachedAttributes.isEmpty
            || lastCollectionViewWidth != currentWidth
            || lastContentSize != baseContentSize
            || hasDataChanged
        
        if needUpdate {
            if hasDataChanged {
                cleanupInvalidItemHeightCache(totalSections: totalSections, collectionView: collectionView)
                clearWaterfallSectionCaches(totalSections: totalSections, collectionView: collectionView)
            }
            
            cachedAttributes.removeAll(keepingCapacity: true)
            cachedMaxY = 0
            
            prepareMixedLayout()
            
            // 在所有 section 内容之后布局全局 Footer
            if let footerView = collectionFooterView, desiredGlobalFooterHeight > 0 {
                let width = collectionView.bounds.width
                footerView.frame = CGRect(x: 0, y: cachedMaxY, width: width, height: desiredGlobalFooterHeight)
                if footerView.superview !== collectionView {
                    collectionView.addSubview(footerView)
                }
                collectionView.bringSubviewToFront(footerView)
                cachedMaxY += desiredGlobalFooterHeight
            }
            globalFooterHeight = desiredGlobalFooterHeight
            
            lastContentSize = baseContentSize
            lastCollectionViewWidth = currentWidth
            lastItemCounts = currentItemCounts
        }
    }
    
    // MARK: - Override Methods
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cachedAttributes.filter { rect.intersects($0.frame) }
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes.first {
            $0.representedElementKind == elementKind && $0.indexPath == indexPath
        }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes.first {
            $0.representedElementCategory == .cell && $0.indexPath == indexPath
        }
    }
    
    override public func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == Self.sectionBackgroundDecorationKind else { return nil }
        return cachedAttributes.first {
            $0.representedElementKind == elementKind && $0.indexPath == indexPath
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: cachedMaxY)
    }
    
    // MARK: - Private Cache Cleanup
    
    /// 清理无效的item高度缓存（移除不存在的indexPath）
    private func cleanupInvalidItemHeightCache(totalSections: Int, collectionView: UICollectionView) {
        // 直接遍历缓存字典并移除无效项，避免创建大型 Set
        itemHeights = itemHeights.filter { (indexPath, _) in
            let section = indexPath.section
            guard section >= 0, section < totalSections else { return false }
            return indexPath.item >= 0 && indexPath.item < collectionView.numberOfItems(inSection: section)
        }
    }
    
    /// 清空所有瀑布流section的item高度缓存，强制重新计算
    private func clearWaterfallSectionCaches(totalSections: Int, collectionView: UICollectionView) {
        // 只遍历缓存字典中的 key，避免为每个 section 创建临时数组
        itemHeights = itemHeights.filter { (indexPath, _) in
            let section = indexPath.section
            guard section >= 0, section < totalSections else { return false }
            return !isSectionWaterfall(section)
        }
    }
    
    // MARK: - Row Alignment
    
    /// 对一行中的 items 进行水平对齐与 RTL 处理
    private func arrangeRow(_ attributes: [UICollectionViewLayoutAttributes],
                           sectionInset: UIEdgeInsets,
                           interitemSpacing: CGFloat) {
        guard !attributes.isEmpty else { return }
        
        let totalWidth = attributes.reduce(CGFloat(0)) { $0 + $1.frame.width }
            + interitemSpacing * CGFloat(attributes.count - 1)
        
        var xOffset: CGFloat
        switch (horizontalAlignment, isRTL) {
        case (.leading, false), (.trailing, true):
            xOffset = sectionInset.left
        case (.leading, true):
            xOffset = collectionViewWidth - sectionInset.right
        case (.center, _):
            xOffset = (collectionViewWidth - totalWidth) / 2
        case (.trailing, false):
            xOffset = collectionViewWidth - totalWidth - sectionInset.right
        }
        
        // 按 indexPath.item 排序，确保顺序正确
        let sortedAttributes = attributes.sorted { $0.indexPath.item < $1.indexPath.item }
        
        for attribute in sortedAttributes {
            let itemWidth = attribute.frame.width
            attribute.frame.origin.x = isRTL ? (xOffset - itemWidth) : xOffset
            xOffset += isRTL ? -(itemWidth + interitemSpacing) : (itemWidth + interitemSpacing)
        }
    }
    
    // MARK: - Column Count Calculation
    
    /// 计算指定 section 的列数
    private func calculateColumnCount(for section: Int,
                                     availableWidth: CGFloat,
                                     interitemSpacing: CGFloat) -> Int {
        if let cols = sectionDelegate?.layout(self, columnsFor: section, availableWidth: availableWidth), cols > 0 {
            return cols
        }
        if let minW = sectionDelegate?.layout(self, minimumItemWidthFor: section, availableWidth: availableWidth), minW > 0 {
            return max(1, Int(floor((availableWidth + interitemSpacing) / (minW + interitemSpacing))))
        }
        return max(1, columnCount)
    }
    
    // MARK: - Supplementary View Helpers
    
    /// 计算补充视图（Header/Footer）的宽度
    /// - Parameters:
    ///   - kind: 补充视图类型（header 或 footer）
    ///   - section: section 索引
    ///   - availableWidth: 集合视图可用宽度
    ///   - effectiveSectionInset: 有效内边距
    ///   - systemDelegate: 系统代理（已缓存）
    ///   - collectionView: 集合视图
    /// - Returns: 计算后的宽度
    private func calculateSupplementaryViewWidth(
        kind: String,
        section: Int,
        availableWidth: CGFloat,
        effectiveSectionInset: UIEdgeInsets,
        systemDelegate: UICollectionViewDelegateFlowLayout?,
        collectionView: UICollectionView
    ) -> CGFloat {
        let systemSize: CGSize?
        if kind == UICollectionView.elementKindSectionHeader {
            systemSize = systemDelegate?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section)
        } else {
            systemSize = systemDelegate?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section)
        }
        
        let contentWidth = availableWidth - effectiveSectionInset.left - effectiveSectionInset.right
        
        if let size = systemSize, size.width > 0 {
            return shouldLimitHeaderFooterWidthByInset ? min(size.width, contentWidth) : size.width
        }
        return contentWidth
    }
    
    /// 创建补充视图（Header/Footer）的布局属性
    private func createSupplementaryViewAttributes(
        kind: String,
        section: Int,
        yOffset: CGFloat,
        height: CGFloat,
        availableWidth: CGFloat,
        effectiveSectionInset: UIEdgeInsets,
        systemDelegate: UICollectionViewDelegateFlowLayout?,
        collectionView: UICollectionView
    ) -> UICollectionViewLayoutAttributes {
        let indexPath = IndexPath(item: 0, section: section)
        let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        
        let width = calculateSupplementaryViewWidth(
            kind: kind,
            section: section,
            availableWidth: availableWidth,
            effectiveSectionInset: effectiveSectionInset,
            systemDelegate: systemDelegate,
            collectionView: collectionView
        )
        
        let xOrigin = shouldLimitHeaderFooterWidthByInset ? effectiveSectionInset.left : 0
        attr.frame = CGRect(x: xOrigin, y: yOffset, width: max(0, width), height: height)
        attr.zIndex = (kind == UICollectionView.elementKindSectionHeader) ? Self.headerZIndex : Self.footerZIndex
        return attr
    }
    
    // MARK: - InsetGrouped Decoration Helpers
    
    /// 为 section 创建有框（insetGrouped）背景 Decoration 属性
    private func createSectionBackgroundDecoration(
        section: Int,
        sectionMinY: CGFloat,
        itemsStartY: CGFloat,
        itemsEndY: CGFloat,
        currentYOffset: CGFloat,
        groupInsets: UIEdgeInsets,
        collectionViewBoundsWidth: CGFloat
    ) -> SectionBackgroundLayoutAttributes {
        let attrs = SectionBackgroundLayoutAttributes(
            forDecorationViewOfKind: Self.sectionBackgroundDecorationKind,
            with: IndexPath(item: 0, section: section)
        )
        
        let contentMode = resolvedInsetGroupedContentMode(for: section)
        let (decY, decH): (CGFloat, CGFloat) = {
            switch contentMode {
            case .full:
                // 组头 + 内容区 + 组尾
                return (sectionMinY, currentYOffset - sectionMinY)
            case .itemsOnly:
                // 仅内容区（不含组头、组尾）
                return (itemsStartY, itemsEndY - itemsStartY)
            case .headerAndItems:
                // 组头 + 内容区，不含组尾
                return (sectionMinY, itemsEndY - sectionMinY)
            case .itemsAndFooter:
                // 内容区 + 组尾，不含组头
                return (itemsStartY, currentYOffset - itemsStartY)
            }
        }()
        
        attrs.frame = CGRect(
            x: groupInsets.left,
            y: decY,
            width: collectionViewBoundsWidth - groupInsets.left - groupInsets.right,
            height: decH
        )
        attrs.zIndex = -1
        attrs.cornerRadius = sectionDelegate?.layout(self, insetGroupedCornerRadiusFor: section) ?? Self.defaultInsetGroupedCornerRadius
        attrs.backgroundColor = resolvedGroupedBackgroundColor(for: section)
        attrs.borderWidth = resolvedGroupedBorderWidth(for: section)
        attrs.borderColor = resolvedGroupedBorderColor(for: section)
        attrs.borderGradientColors = resolvedGroupedBorderGradientColors(for: section)
        attrs.borderGradientDirection = resolvedGroupedBorderGradientDirection(for: section)
        attrs.gradientColors = resolvedGradientColors(for: section)
        attrs.gradientDirection = resolvedGradientDirection(for: section)
        return attrs
    }
    
    /// 若当前组与下一组均为有框，添加组间垂直间隙
    private func addGroupedSectionSpacingIfNeeded(
        currentSection section: Int,
        useInsetGrouped: Bool,
        totalSections: Int,
        yOffset: inout CGFloat
    ) {
        guard useInsetGrouped, spacingBetweenGroupedSections > 0, section + 1 < totalSections else { return }
        let nextInsetGrouped = sectionDelegate?.layout(self, insetGroupedFor: section + 1) ?? false
        if nextInsetGrouped {
            yOffset += spacingBetweenGroupedSections
        }
    }
    
    // MARK: - Mixed Layout (Flow + Waterfall)
    
    /// 准备混合布局（支持每个 section 独立配置流式或瀑布流）
    private func prepareMixedLayout() {
        guard let collectionView = collectionView else { return }
        
        let totalSections = collectionView.numberOfSections
        guard totalSections > 0 else { return }
        
        let boundsWidth = collectionView.bounds.width
        let systemDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
        // 预留全局 Header 区域（类似 UITableView.tableHeaderView）
        var yOffset: CGFloat = globalHeaderHeight

        // 判断是否有非瀑布流 section，决定是否需要获取系统布局
        let needsSystemLayout = (0..<totalSections).contains { !isSectionWaterfall($0) }
        
        // 按需计算系统流式布局的基础属性（仅复制一次）
        let baseAttributesAllSections: [UICollectionViewLayoutAttributes]
        if needsSystemLayout {
            baseAttributesAllSections = (
                super.layoutAttributesForElements(
                    in: CGRect(origin: .zero, size: super.collectionViewContentSize)
                )?.compactMap { $0.copy() as? UICollectionViewLayoutAttributes }
            ) ?? []
        } else {
            baseAttributesAllSections = []
        }
        
        for section in 0..<totalSections {
            let config = buildSectionConfig(for: section, collectionView: collectionView, systemDelegate: systemDelegate)
            
            let sectionMinY = yOffset
            var itemsStartY: CGFloat = yOffset
            var itemsEndY: CGFloat = yOffset
            
            // Header
            if config.headerHeight > 0 {
                let headerAttr = createSupplementaryViewAttributes(
                    kind: UICollectionView.elementKindSectionHeader,
                    section: section,
                    yOffset: yOffset,
                    height: config.headerHeight,
                    availableWidth: boundsWidth,
                    effectiveSectionInset: config.effectiveSectionInset,
                    systemDelegate: systemDelegate,
                    collectionView: collectionView
                )
                cachedAttributes.append(headerAttr)
                yOffset = headerAttr.frame.maxY
            }
            itemsStartY = yOffset

            // Items
            if config.isWaterfall {
                yOffset = prepareWaterfallLayoutForSection(
                    section,
                    startY: yOffset,
                    sectionInset: config.effectiveSectionInset,
                    interitemSpacing: config.interitemSpacing,
                    lineSpacing: config.lineSpacing
                )
                itemsEndY = yOffset
            } else {
                yOffset = prepareFlowSectionItems(
                    section: section,
                    startY: yOffset,
                    config: config,
                    baseAttributes: baseAttributesAllSections,
                    collectionView: collectionView
                )
                itemsEndY = yOffset
            }

            // Footer
            if config.footerHeight > 0 {
                let footerAttr = createSupplementaryViewAttributes(
                    kind: UICollectionView.elementKindSectionFooter,
                    section: section,
                    yOffset: yOffset,
                    height: config.footerHeight,
                    availableWidth: boundsWidth,
                    effectiveSectionInset: config.effectiveSectionInset,
                    systemDelegate: systemDelegate,
                    collectionView: collectionView
                )
                cachedAttributes.append(footerAttr)
                yOffset = footerAttr.frame.maxY
            }
            
            // InsetGrouped 背景 Decoration
            if config.useInsetGrouped {
                let decoration = createSectionBackgroundDecoration(
                    section: section,
                    sectionMinY: sectionMinY,
                    itemsStartY: itemsStartY,
                    itemsEndY: itemsEndY,
                    currentYOffset: yOffset,
                    groupInsets: config.groupInsets,
                    collectionViewBoundsWidth: boundsWidth
                )
                cachedAttributes.append(decoration)
            }
            
            // 相邻有框组间距
            addGroupedSectionSpacingIfNeeded(
                currentSection: section,
                useInsetGrouped: config.useInsetGrouped,
                totalSections: totalSections,
                yOffset: &yOffset
            )
        }

        // 缓存最大 Y 值，供 collectionViewContentSize 直接使用
        cachedMaxY = yOffset
    }
    
    // MARK: - Flow Layout
    
    /// 处理流式 section 的 items 布局（使用系统属性或手动计算）
    /// - Returns: 布局结束后的 y 坐标
    private func prepareFlowSectionItems(
        section: Int,
        startY: CGFloat,
        config: SectionConfig,
        baseAttributes: [UICollectionViewLayoutAttributes],
        collectionView: UICollectionView
    ) -> CGFloat {
        // 从系统布局中筛选当前 section 的 cell 属性
        let sectionAttrs = baseAttributes.filter {
            $0.representedElementCategory == .cell && $0.indexPath.section == section
        }
        // 系统属性不可用时，使用手动流式布局
        guard !sectionAttrs.isEmpty else {
            return prepareFlowLayoutForSection(
                section,
                startY: startY,
                config: config,
                collectionView: collectionView
            )
        }

        // 调整 section 内所有 item 的 y 坐标
        let minY = sectionAttrs.reduce(CGFloat.greatestFiniteMagnitude) { min($0, $1.frame.minY) }
        let delta = (startY + config.effectiveSectionInset.top) - minY
        var maxY = startY
        for attr in sectionAttrs {
            attr.frame = attr.frame.offsetBy(dx: 0, dy: delta)
            if attr.frame.maxY > maxY { maxY = attr.frame.maxY }
        }
        
        // 按行分组并进行水平对齐
        alignFlowRows(sectionAttrs, sectionInset: config.effectiveSectionInset, interitemSpacing: config.interitemSpacing)
        
        cachedAttributes.append(contentsOf: sectionAttrs)
        return maxY + config.effectiveSectionInset.bottom
    }
    
    /// 将 section 的属性按行分组并逐行对齐
    private func alignFlowRows(
        _ attributes: [UICollectionViewLayoutAttributes],
        sectionInset: UIEdgeInsets,
        interitemSpacing: CGFloat
    ) {
        let sorted = attributes.sorted { (a, b) in
            if abs(a.frame.minY - b.frame.minY) > Self.floatComparisonThreshold {
                return a.frame.minY < b.frame.minY
            }
            return a.indexPath.item < b.indexPath.item
        }
        
        var currentRow: [UICollectionViewLayoutAttributes] = []
        var currentYForRow: CGFloat = -.greatestFiniteMagnitude
        
        for attr in sorted {
            if currentRow.isEmpty || abs(attr.frame.minY - currentYForRow) <= Self.floatComparisonThreshold {
                if currentRow.isEmpty { currentYForRow = attr.frame.minY }
                currentRow.append(attr)
            } else {
                arrangeRow(currentRow, sectionInset: sectionInset, interitemSpacing: interitemSpacing)
                currentRow = [attr]
                currentYForRow = attr.frame.minY
            }
        }
        if !currentRow.isEmpty {
            arrangeRow(currentRow, sectionInset: sectionInset, interitemSpacing: interitemSpacing)
        }
    }
    
    /// 为指定 section 准备流式布局（当系统布局不可用时手动创建）
    /// - Returns: 布局结束后的 y 坐标
    private func prepareFlowLayoutForSection(_ section: Int,
                                             startY: CGFloat,
                                             config: SectionConfig,
                                             collectionView: UICollectionView) -> CGFloat {
        prepareFlowLayoutVerticalAxis(
            section: section,
            startY: startY,
            sectionInset: config.effectiveSectionInset,
            interitemSpacing: config.interitemSpacing,
            lineSpacing: config.lineSpacing,
            collectionView: collectionView
        )
    }

    /// 纵向布局（行优先）：先填满一行再下一行
    private func prepareFlowLayoutVerticalAxis(
        section: Int,
        startY: CGFloat,
        sectionInset: UIEdgeInsets,
        interitemSpacing: CGFloat,
        lineSpacing: CGFloat,
        collectionView: UICollectionView
    ) -> CGFloat {
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        if numberOfItems == 0 {
            return startY + sectionInset.top + sectionInset.bottom
        }

        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let rightBoundary = collectionView.bounds.width - sectionInset.right + Self.widthMatchTolerance
        var currentY = startY + sectionInset.top
        var currentX = sectionInset.left
        var currentRowAttributes: [UICollectionViewLayoutAttributes] = []
        var lastItemHeightInRow: CGFloat = 0
        var sectionMaxY = currentY

        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: section)
            let size = getItemSize(for: indexPath, availableWidth: availableWidth)

            if !currentRowAttributes.isEmpty && currentX + size.width > rightBoundary {
                arrangeRow(currentRowAttributes, sectionInset: sectionInset, interitemSpacing: interitemSpacing)
                currentRowAttributes.removeAll(keepingCapacity: true)
                currentX = sectionInset.left
                currentY += lastItemHeightInRow + lineSpacing
            }

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: currentX, y: currentY, width: size.width, height: size.height)
            cachedAttributes.append(attributes)
            currentRowAttributes.append(attributes)

            let bottomY = currentY + size.height
            if bottomY > sectionMaxY { sectionMaxY = bottomY }

            lastItemHeightInRow = size.height
            currentX += size.width + interitemSpacing
        }

        if !currentRowAttributes.isEmpty {
            arrangeRow(currentRowAttributes, sectionInset: sectionInset, interitemSpacing: interitemSpacing)
        }

        return sectionMaxY + sectionInset.bottom
    }

    /// 获取 item 的尺寸（优先从 delegate 获取，否则使用默认值）
    private func getItemSize(for indexPath: IndexPath, availableWidth: CGFloat) -> CGSize {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
           let size = delegate.collectionView?(collectionView!, layout: self, sizeForItemAt: indexPath) {
            return size
        }
        let defaultWidth = min(availableWidth * 0.3, 120)
        let defaultHeight = defaultWidth * Self.defaultAspectRatio
        return CGSize(width: defaultWidth, height: defaultHeight)
    }
    
    // MARK: - Waterfall Layout
    
    /// 为指定 section 准备瀑布流布局
    /// - Returns: 布局结束后的 y 坐标
    @discardableResult
    private func prepareWaterfallLayoutForSection(_ section: Int,
                                                 startY: CGFloat,
                                                 sectionInset: UIEdgeInsets,
                                                 interitemSpacing: CGFloat,
                                                 lineSpacing: CGFloat) -> CGFloat {
        guard let collectionView = collectionView else { return startY }
        
        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let columns = calculateColumnCount(for: section, availableWidth: availableWidth, interitemSpacing: interitemSpacing)
        
        columnHeights = Array(repeating: startY + sectionInset.top, count: columns)
        
        let itemWidth = (availableWidth - CGFloat(columns - 1) * interitemSpacing) / CGFloat(columns)
        
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        if numberOfItems == 0 {
            return startY + sectionInset.top + sectionInset.bottom
        }
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let itemHeight = getItemHeight(for: indexPath, itemWidth: itemWidth)
            let shortestColumnIndex = findShortestColumn()
            
            let x = calculateXPosition(
                for: shortestColumnIndex,
                itemWidth: itemWidth,
                sectionInset: sectionInset,
                interitemSpacing: interitemSpacing
            )
            let y = columnHeights[shortestColumnIndex]
            
            attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            columnHeights[shortestColumnIndex] += itemHeight + lineSpacing
            
            cachedAttributes.append(attributes)
        }
        
        let endY = (columnHeights.max() ?? (startY + sectionInset.top)) - lineSpacing + sectionInset.bottom
        return endY
    }
    
    /// 获取 item 的高度（带缓存机制）
    /// 当 enableCacheHeightValidation 为 true 时，会与 delegate 返回的最新高度按组对比，不一致则更新缓存并采用最新高度。
    private func getItemHeight(for indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        guard let collectionView = collectionView,
              indexPath.section >= 0,
              indexPath.section < collectionView.numberOfSections,
              indexPath.item >= 0,
              indexPath.item < collectionView.numberOfItems(inSection: indexPath.section) else {
            return itemWidth * Self.defaultAspectRatio
        }
        
        // 获取最新高度（delegate 或默认值）
        let latestHeight: CGFloat = {
            if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
               let size = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) {
                return size.height > 0 ? size.height : itemWidth * Self.defaultAspectRatio
            }
            return itemWidth * Self.defaultAspectRatio
        }()
        
        // 未开启「缓存高度对比更新」：沿用原有逻辑，命中缓存且宽度匹配则直接返回
        if !enableCacheHeightValidation {
            if let cached = itemHeights[indexPath], abs(cached.width - itemWidth) < Self.widthMatchTolerance {
                return cached.height
            }
            itemHeights[indexPath] = (height: latestHeight, width: itemWidth)
            return latestHeight
        }
        
        // 开启「缓存高度对比更新」：按组对比，缓存与最新高度不一致则更新缓存并采用最新高度
        if let cached = itemHeights[indexPath], abs(cached.width - itemWidth) < Self.widthMatchTolerance {
            if abs(cached.height - latestHeight) > Self.floatComparisonThreshold {
                itemHeights[indexPath] = (height: latestHeight, width: itemWidth)
                return latestHeight
            }
            return cached.height
        }
        
        itemHeights[indexPath] = (height: latestHeight, width: itemWidth)
        return latestHeight
    }
    
    /// 找到瀑布流中最短的列
    private func findShortestColumn() -> Int {
        guard !columnHeights.isEmpty else { return 0 }
        var shortestIndex = 0
        var shortestHeight = columnHeights[0]
        for (index, height) in columnHeights.enumerated() where height < shortestHeight {
            shortestHeight = height
            shortestIndex = index
        }
        return shortestIndex
    }
    
    /// 计算瀑布流中指定列的 x 坐标
    private func calculateXPosition(for columnIndex: Int,
                                    itemWidth: CGFloat,
                                    sectionInset: UIEdgeInsets? = nil,
                                    interitemSpacing: CGFloat? = nil) -> CGFloat {
        let inset = sectionInset ?? self.sectionInset
        let spacing = interitemSpacing ?? self.minimumInteritemSpacing
        let baseX = inset.left + CGFloat(columnIndex) * (itemWidth + spacing)
        return isRTL ? (collectionViewWidth - baseX - itemWidth) : baseX
    }
    
    // MARK: - Public API
    
    /// 设置布局模式
    /// - Parameters:
    ///   - mode: 布局模式（flow 或 waterfall）
    ///   - columnCount: 瀑布流列数（默认2列）
    public func setLayoutMode(_ mode: LayoutMode, columnCount: Int = 2) {
        self.layoutMode = mode
        self.columnCount = max(1, columnCount)
        invalidateLayout()
    }
    
    /// 为指定 section 启用瀑布流布局
    public func enableWaterfallForSection(_ section: Int) {
        waterfallSections.insert(section)
        invalidateLayout()
    }
    
    /// 为指定 section 禁用瀑布流布局
    public func disableWaterfallForSection(_ section: Int) {
        waterfallSections.remove(section)
        invalidateLayout()
    }
    
    /// 为多个 section 启用瀑布流布局
    public func enableWaterfallForSections(_ sections: [Int]) {
        waterfallSections.formUnion(sections)
        invalidateLayout()
    }
    
    /// 清除所有瀑布流 section 设置
    public func clearWaterfallSections() {
        waterfallSections.removeAll()
        invalidateLayout()
    }
    
    /// 检查指定 section 是否使用瀑布流布局
    public func isWaterfallEnabledForSection(_ section: Int) -> Bool {
        waterfallSections.contains(section) || layoutMode == .waterfall
    }
    
    /// 是否启用「缓存高度与最新高度对比更新」：开启时，在瀑布流布局中会按组对比缓存高度与 delegate 返回的最新高度，
    /// 若某组内存在缓存高度与最新高度不一致的 item，则更新该 item 的缓存并采用最新高度；关闭时不进行对比，保持原有缓存逻辑。
    /// 默认值为 false，不进行对比。
    public var enableCacheHeightValidation: Bool = false

    /// 清除 item 高度缓存（当 item 高度可能变化或列数/宽度变化时调用）
    public func clearItemHeightCache() {
        itemHeights.removeAll()
        lastItemCounts.removeAll()
        invalidateLayout()
    }
    
    /// 为特定 indexPath 设置 item 高度和宽度
    public func setItemHeight(_ height: CGFloat, for indexPath: IndexPath, width: CGFloat) {
        itemHeights[indexPath] = (height: height, width: width)
    }
    
}

// MARK: - InsetGrouped 有框样式：Section 背景 Decoration

/// 用于有框样式的 Decoration 布局属性，携带圆角半径、背景色与边框（可由 layout 或 delegate 控制）
public final class SectionBackgroundLayoutAttributes: UICollectionViewLayoutAttributes {
    public var cornerRadius: CGFloat = 10
    public var backgroundColor: UIColor = .secondarySystemGroupedBackground
    /// 边框宽度，0 表示无边框
    public var borderWidth: CGFloat = 0
    /// 边框颜色，nil 时若 borderWidth > 0 则使用系统分隔色
    public var borderColor: UIColor?
    /// 边框渐变颜色数组（可选，非空且 count >= 2 时使用渐变边框，覆盖纯色边框）
    public var borderGradientColors: [UIColor]?
    /// 边框渐变方向（仅在 borderGradientColors 有效时使用）
    public var borderGradientDirection: TFYSwiftRTLAlignedFlowLayout.GradientDirection = .vertical
    /// 渐变颜色数组（可选，nil 或少于两种颜色则不使用渐变）
    public var gradientColors: [UIColor]?
    /// 渐变方向（仅在 gradientColors 有效时使用）
    public var gradientDirection: TFYSwiftRTLAlignedFlowLayout.GradientDirection = .vertical
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SectionBackgroundLayoutAttributes
        copy.cornerRadius = cornerRadius
        copy.backgroundColor = backgroundColor
        copy.borderWidth = borderWidth
        copy.borderColor = borderColor
        copy.borderGradientColors = borderGradientColors
        copy.borderGradientDirection = borderGradientDirection
        copy.gradientColors = gradientColors
        copy.gradientDirection = gradientDirection
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SectionBackgroundLayoutAttributes else { return false }
        let colorEqual = (borderColor == nil && other.borderColor == nil) || (borderColor?.isEqual(other.borderColor) == true)
        let borderGradientEqual: Bool
        if let g1 = borderGradientColors, let g2 = other.borderGradientColors {
            borderGradientEqual = g1.elementsEqual(g2, by: { $0.isEqual($1) }) && borderGradientDirection == other.borderGradientDirection
        } else {
            borderGradientEqual = (borderGradientColors == nil && other.borderGradientColors == nil)
        }
        let gradientEqual: Bool
        if let g1 = gradientColors, let g2 = other.gradientColors {
            gradientEqual = g1.elementsEqual(g2, by: { $0.isEqual($1) })
        } else {
            gradientEqual = (gradientColors == nil && other.gradientColors == nil)
        }
        return super.isEqual(other)
            && cornerRadius == other.cornerRadius
            && backgroundColor.isEqual(other.backgroundColor)
            && borderWidth == other.borderWidth
            && colorEqual
            && borderGradientEqual
            && gradientEqual
    }
}

/// 有框（insetGrouped）样式的 section 背景视图，由 layout 在 section 级别添加，无需在 cell 上做样式
public final class SectionBackgroundDecorationView: UICollectionReusableView {
    private var gradientLayer: CAGradientLayer?
    private var borderGradientLayer: CAGradientLayer?
    private var borderGradientMaskLayer: CAShapeLayer?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attrs = layoutAttributes as? SectionBackgroundLayoutAttributes else { return }
        
        // 关闭隐式动画，避免在滚动或频繁 apply 布局属性时出现闪烁
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        layer.cornerRadius = attrs.cornerRadius
        
        let useBorderGradient = attrs.borderWidth > 0
            && (attrs.borderGradientColors?.count ?? 0) >= 2
        
        if useBorderGradient {
            layer.borderWidth = 0
            layer.borderColor = nil
            applyBorderGradient(attrs: attrs)
        } else {
            removeBorderGradient()
            layer.borderWidth = attrs.borderWidth
            layer.borderColor = attrs.borderWidth > 0 ? (attrs.borderColor ?? .separator).cgColor : nil
        }
        
        // 渐变背景优先；若未配置渐变，则退回纯色背景
        if let colors = attrs.gradientColors, colors.count >= 2 {
            let gradient: CAGradientLayer
            if let existing = gradientLayer {
                gradient = existing
            } else {
                gradient = CAGradientLayer()
                gradientLayer = gradient
                layer.insertSublayer(gradient, at: 0)
            }
            gradient.frame = bounds
            gradient.colors = colors.map { $0.cgColor }
            switch attrs.gradientDirection {
            case .vertical:
                gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .horizontal:
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            }
            backgroundColor = .clear
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
            backgroundColor = attrs.backgroundColor
        }
        
        CATransaction.commit()
    }
    
    /// 使用环形 path 作为 mask，在边框区域绘制渐变
    private func applyBorderGradient(attrs: SectionBackgroundLayoutAttributes) {
        guard let colors = attrs.borderGradientColors, colors.count >= 2 else { return }
        let borderWidth = attrs.borderWidth
        let cornerRadius = attrs.cornerRadius
        let rect = bounds
        
        let gradient: CAGradientLayer
        if let existing = borderGradientLayer {
            gradient = existing
        } else {
            gradient = CAGradientLayer()
            borderGradientLayer = gradient
            borderGradientMaskLayer = CAShapeLayer()
            gradient.mask = borderGradientMaskLayer
            layer.addSublayer(gradient)
        }
        
        gradient.frame = rect
        gradient.colors = colors.map { $0.cgColor }
        switch attrs.borderGradientDirection {
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        let outerPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        let innerRect = rect.insetBy(dx: borderWidth, dy: borderWidth)
        let innerRadius = max(0, cornerRadius - borderWidth)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: innerRadius)
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        
        guard let maskLayer = borderGradientMaskLayer else { return }
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = .evenOdd
        maskLayer.frame = rect
    }
    
    private func removeBorderGradient() {
        borderGradientLayer?.removeFromSuperlayer()
        borderGradientLayer = nil
        borderGradientMaskLayer = nil
    }
}

// MARK: - 使用示例（仅示意，建议复制到业务 VC 中）
//
// 示例一：基础流式布局 + RTL 支持
//
// final class DemoFlowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TFYSwiftRTLAlignedFlowLayoutDelegate {
//
//     private lazy var collectionView: UICollectionView = {
//         let layout = TFYSwiftRTLAlignedFlowLayout(horizontalAlignment: .leading)
//         layout.scrollDirection = .vertical
//         layout.sectionDelegate = self
//         // 可选：相邻 insetGrouped 组之间的垂直间距
//         layout.spacingBetweenGroupedSections = 12
//         // 可选：限制 Header/Footer 宽度不超过内容区域
//         layout.shouldLimitHeaderFooterWidthByInset = true
//
//         let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//         // 若需要强制 RTL 布局：
//         // view.semanticContentAttribute = .forceRightToLeft
//         view.delegate = self
//         view.dataSource = self
//         return view
//     }()
//
//     // MARK: - TFYSwiftRTLAlignedFlowLayoutDelegate 基础实现
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 sectionInsetFor section: Int) -> UIEdgeInsets? {
//         // 所有分区统一左右 10 间距
//         return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 interitemSpacingFor section: Int) -> CGFloat? {
//         return 8
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 lineSpacingFor section: Int) -> CGFloat? {
//         return 12
//     }
//
//     // 使用 effectiveSectionInset 计算 sizeForItemAt，避免与布局内边距不一致
//     func collectionView(_ collectionView: UICollectionView,
//                         layout collectionViewLayout: UICollectionViewLayout,
//                         sizeForItemAt indexPath: IndexPath) -> CGSize {
//         guard let flowLayout = collectionViewLayout as? TFYSwiftRTLAlignedFlowLayout else { return .zero }
//         let inset = flowLayout.effectiveSectionInset(for: indexPath.section)
//         let cols = 2
//         let spacing = flowLayout.sectionDelegate?.layout(flowLayout, interitemSpacingFor: indexPath.section) ?? flowLayout.minimumInteritemSpacing
//         let totalSpacing = CGFloat(cols - 1) * spacing
//         let availableWidth = collectionView.bounds.width - inset.left - inset.right - totalSpacing
//         let width = floor(availableWidth / CGFloat(cols))
//         let height = width * 1.33
//         return CGSize(width: width, height: height)
//     }
// }
//
// 示例二：按分区开启瀑布流 + 动态更新
//
// final class DemoWaterfallViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TFYSwiftRTLAlignedFlowLayoutDelegate {
//
//     private var models: [SectionModel] = [] {
//         didSet {
//             // 根据业务模型决定哪些分区使用瀑布流
//             let waterfallSections = models.enumerated().compactMap { index, model in
//                 return model.isWaterfall ? index : nil
//             }
//             if let layout = collectionView.collectionViewLayout as? TFYSwiftRTLAlignedFlowLayout {
//                 layout.clearWaterfallSections()
//                 if !waterfallSections.isEmpty {
//                     layout.enableWaterfallForSections(waterfallSections)
//                     // 数据变更后清空高度缓存，保证最新高度生效
//                     layout.clearItemHeightCache()
//                 }
//             }
//             collectionView.reloadData()
//         }
//     }
//
//     private lazy var collectionView: UICollectionView = {
//         let layout = TFYSwiftRTLAlignedFlowLayout(horizontalAlignment: .leading,
//                                             layoutMode: .flow,
//                                             columnCount: 2)
//         layout.sectionDelegate = self
//         let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//         view.delegate = self
//         view.dataSource = self
//         return view
//     }()
//
//     // 也可以整体切换为全局瀑布流
//     private func switchToGlobalWaterfall() {
//         if let layout = collectionView.collectionViewLayout as? TFYSwiftRTLAlignedFlowLayout {
//             layout.setLayoutMode(.waterfall, columnCount: 3)
//             layout.clearItemHeightCache()
//         }
//     }
//
//     // MARK: - 为瀑布流提供 item 高度（可选，优先使用系统 sizeForItemAt）
//
//     func collectionView(_ collectionView: UICollectionView,
//                         layout collectionViewLayout: UICollectionViewLayout,
//                         sizeForItemAt indexPath: IndexPath) -> CGSize {
//         guard let layout = collectionViewLayout as? TFYSwiftRTLAlignedFlowLayout else { return .zero }
//         let inset = layout.effectiveSectionInset(for: indexPath.section)
//         let interitem = layout.sectionDelegate?.layout(layout, interitemSpacingFor: indexPath.section) ?? layout.minimumInteritemSpacing
//         let columns = 2
//         let totalSpacing = CGFloat(columns - 1) * interitem
//         let availableWidth = collectionView.bounds.width - inset.left - inset.right - totalSpacing
//         let width = floor(availableWidth / CGFloat(columns))
//         let height = models[indexPath.section].items[indexPath.item].preferredHeight(for: width)
//         return CGSize(width: width, height: height)
//     }
// }
//
// 示例三：insetGrouped 有框样式 + 全局 Header
//
// final class DemoInsetGroupedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TFYSwiftRTLAlignedFlowLayoutDelegate {
//
//     private lazy var collectionView: UICollectionView = {
//         let layout = TFYSwiftRTLAlignedFlowLayout(horizontalAlignment: .leading)
//         layout.sectionDelegate = self
//         layout.sectionGroupedBackgroundColor = .secondarySystemBackground
//         layout.sectionGroupedBorderWidth = 1
//         layout.sectionGroupedBorderColor = .separator
//         let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//         view.delegate = self
//         view.dataSource = self
//         return view
//     }()
//
//     // 启用 insetGrouped，有些分区可返回 true，有些返回 nil 使用默认
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 insetGroupedFor section: Int) -> Bool? {
//         return true
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 insetGroupedContentModeFor section: Int) -> TFYSwiftRTLAlignedFlowLayout.InsetGroupedContentMode? {
//         // 只包住内容区，不含组头/组尾
//         return .itemsOnly
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 insetGroupedGroupInsetsFor section: Int) -> UIEdgeInsets? {
//         // 与系统 insetGrouped 风格接近的组外边距
//         return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 insetGroupedCornerRadiusFor section: Int) -> CGFloat? {
//         return 12
//     }
//
//     // 渐变背景与渐变边框示例
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 insetGroupedGradientColorsFor section: Int) -> [UIColor]? {
//         return [UIColor.systemPink, UIColor.systemOrange]
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 insetGroupedBorderGradientColorsFor section: Int) -> [UIColor]? {
//         return [UIColor.systemRed, UIColor.systemYellow]
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 insetGroupedBorderWidthFor section: Int) -> CGFloat? {
//         return 1
//     }
//
//     // 全局 Header 视图 & 高度（类似 UITableView.tableHeaderView）
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 collectionHeaderViewIn collectionView: UICollectionView) -> UIView? {
//         let header = UIView()
//         header.backgroundColor = .clear
//         // 在此添加子视图，例如 banner / 顶部轮播等
//         return header
//     }
//
//     func layout(_ layout: TFYSwiftRTLAlignedFlowLayout,
//                 collectionHeaderHeightIn collectionView: UICollectionView) -> CGFloat? {
//         return 300
//     }
// }
//
