//
//  UICollectionView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升、iOS15+特性支持
//

import UIKit

public extension TFY where Base: UICollectionView {
    /// 设置背景视图
    @discardableResult
    func backgroundView(_ backgroundView: UIView?) -> Self {
        base.backgroundView = backgroundView
        return self
    }
    
    /// 设置数据源
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        base.dataSource = dataSource
        return self
    }
    
    /// 设置代理
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    
    /// 设置预取数据源（iOS 10.0+）
    @available(iOS 10.0, *)
    @discardableResult
    func prefetchDataSource(_ prefetchDataSource: UICollectionViewDataSourcePrefetching?) -> Self {
        base.prefetchDataSource = prefetchDataSource
        return self
    }
    
    /// 设置拖拽代理（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func dragDelegate(_ dragDelegate: UICollectionViewDragDelegate?) -> Self {
        base.dragDelegate = dragDelegate
        return self
    }
    
    /// 设置放置代理（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func dropDelegate(_ dropDelegate: UICollectionViewDropDelegate?) -> Self {
        base.dropDelegate = dropDelegate
        return self
    }
    
    /// 设置是否启用拖拽（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func dragInteractionEnabled(_ enabled: Bool) -> Self {
        base.dragInteractionEnabled = enabled
        return self
    }
    
    /// 设置重新排序手势（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func reorderingCadence(_ cadence: UICollectionView.ReorderingCadence) -> Self {
        base.reorderingCadence = cadence
        return self
    }
    
    /// 设置是否启用重新排序（iOS 14.0+）
    @available(iOS 14.0, *)
    @discardableResult
    func allowsSelection(_ allowsSelection: Bool) -> Self {
        base.allowsSelection = allowsSelection
        return self
    }
    
    /// 设置是否允许多选（iOS 14.0+）
    @available(iOS 14.0, *)
    @discardableResult
    func allowsMultipleSelection(_ allowsMultipleSelection: Bool) -> Self {
        base.allowsMultipleSelection = allowsMultipleSelection
        return self
    }
    
    /// 设置选择模式（iOS 15.0+）
    @available(iOS 15.0, *)
    @discardableResult
    func selectionFollowsFocus(_ selectionFollowsFocus: Bool) -> Self {
        base.selectionFollowsFocus = selectionFollowsFocus
        return self
    }
    
    /// 设置是否启用焦点（iOS 15.0+）
    @available(iOS 15.0, *)
    @discardableResult
    func allowsFocus(_ allowsFocus: Bool) -> Self {
        base.allowsFocus = allowsFocus
        return self
    }
    
    /// 设置焦点组（iOS 15.0+）
    @available(iOS 15.0, *)
    @discardableResult
    func focusGroupIdentifier(_ identifier: String?) -> Self {
        base.focusGroupIdentifier = identifier
        return self
    }
    
    /// 注册Cell类
    @discardableResult
    func registerCell(_ cellClass: UICollectionViewCell.Type) -> Self {
        base.register(cell: cellClass)
        return self
    }
    
    /// 注册Nib Cell
    @discardableResult
    func registerNibCell(_ nibCell: UICollectionViewCell.Type) -> Self {
        base.register(nibCell: nibCell)
        return self
    }
    
    /// 注册Header类
    @discardableResult
    func registerHeader(_ viewClass: UICollectionReusableView.Type) -> Self {
        base.register(header: viewClass)
        return self
    }
    
    /// 注册Footer类
    @discardableResult
    func registerFooter(_ viewClass: UICollectionReusableView.Type) -> Self {
        base.register(footer: viewClass)
        return self
    }
    
    /// 注册Nib Header
    @discardableResult
    func registerNibHeader(_ nibHeader: UICollectionReusableView.Type) -> Self {
        base.register(nibHeader: nibHeader)
        return self
    }
    
    /// 注册Nib Footer
    @discardableResult
    func registerNibFooter(_ nibFooter: UICollectionReusableView.Type) -> Self {
        base.register(nibFooter: nibFooter)
        return self
    }
    
    /// 设置布局
    @discardableResult
    func collectionViewLayout(_ layout: UICollectionViewLayout) -> Self {
        base.setCollectionViewLayout(layout, animated: false)
        return self
    }
    
    /// 设置布局（带动画）
    @discardableResult
    func collectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool) -> Self {
        base.setCollectionViewLayout(layout, animated: animated)
        return self
    }
    
    /// 设置是否显示滚动指示器
    @discardableResult
    func showsVerticalScrollIndicator(_ shows: Bool) -> Self {
        base.showsVerticalScrollIndicator = shows
        return self
    }
    
    /// 设置是否显示水平滚动指示器
    @discardableResult
    func showsHorizontalScrollIndicator(_ shows: Bool) -> Self {
        base.showsHorizontalScrollIndicator = shows
        return self
    }
    
    /// 设置滚动指示器样式
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        base.indicatorStyle = style
        return self
    }
    
    /// 设置是否分页
    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        base.isPagingEnabled = enabled
        return self
    }
    
    /// 设置是否滚动到顶部
    @discardableResult
    func scrollsToTop(_ scrolls: Bool) -> Self {
        base.scrollsToTop = scrolls
        return self
    }
    
    /// 设置键盘消失模式
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        base.keyboardDismissMode = mode
        return self
    }
}

extension UICollectionView {
    // MARK: - 安全注册方法
    
    /// 安全获取标识符
    private func safeIdentifier<C>(for clz: C.Type) -> String {
        let fullName = String(describing: clz)
        guard let validIdentifier = fullName.components(separatedBy: ".").last else {
            fatalError("⚠️ 无效的类名格式: \(fullName)")
        }
        return validIdentifier
    }
    
    /// 验证Nib是否存在
    private func validateNibExists(_ nibName: String) -> Bool {
        return Bundle.main.path(forResource: nibName, ofType: "nib") != nil
    }

    // MARK: - Cell注册
    public func register<C: UICollectionViewCell>(cell clz: C.Type) {
        let identifier = safeIdentifier(for: clz)
        register(clz, forCellWithReuseIdentifier: identifier)
    }
    
    public func register<C: UICollectionViewCell>(nibCell clz: C.Type) {
        let identifier = safeIdentifier(for: clz)
        guard validateNibExists(identifier) else {
            fatalError("⚠️ Nib文件不存在: \(identifier).nib")
        }
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    /// 注册Cell（指定Bundle）
    public func register<C: UICollectionViewCell>(nibCell clz: C.Type, bundle: Bundle) {
        let identifier = safeIdentifier(for: clz)
        guard bundle.path(forResource: identifier, ofType: "nib") != nil else {
            fatalError("⚠️ Nib文件不存在于指定Bundle: \(identifier).nib")
        }
        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    // MARK: - 补充视图注册
    public func register<C: UICollectionReusableView>(
        header clz: C.Type,
        kind: String = UICollectionView.elementKindSectionHeader
    ) {
        let identifier = safeIdentifier(for: clz)
        register(clz, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    public func register<C: UICollectionReusableView>(
        footer clz: C.Type,
        kind: String = UICollectionView.elementKindSectionFooter
    ) {
        let identifier = safeIdentifier(for: clz)
        register(clz, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    public func register<C: UICollectionReusableView>(
        nibHeader clz: C.Type,
        kind: String = UICollectionView.elementKindSectionHeader
    ) {
        let identifier = safeIdentifier(for: clz)
        guard validateNibExists(identifier) else {
            fatalError("⚠️ Nib文件不存在: \(identifier).nib")
        }
        register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    public func register<C: UICollectionReusableView>(
        nibFooter clz: C.Type,
        kind: String = UICollectionView.elementKindSectionFooter
    ) {
        let identifier = safeIdentifier(for: clz)
        guard validateNibExists(identifier) else {
            fatalError("⚠️ Nib文件不存在: \(identifier).nib")
        }
        register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    /// 注册补充视图（指定Bundle）
    public func register<C: UICollectionReusableView>(
        nibHeader clz: C.Type,
        bundle: Bundle,
        kind: String = UICollectionView.elementKindSectionHeader
    ) {
        let identifier = safeIdentifier(for: clz)
        guard bundle.path(forResource: identifier, ofType: "nib") != nil else {
            fatalError("⚠️ Nib文件不存在于指定Bundle: \(identifier).nib")
        }
        register(UINib(nibName: identifier, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    public func register<C: UICollectionReusableView>(
        nibFooter clz: C.Type,
        bundle: Bundle,
        kind: String = UICollectionView.elementKindSectionFooter
    ) {
        let identifier = safeIdentifier(for: clz)
        guard bundle.path(forResource: identifier, ofType: "nib") != nil else {
            fatalError("⚠️ Nib文件不存在于指定Bundle: \(identifier).nib")
        }
        register(UINib(nibName: identifier, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    // MARK: - 安全获取方法
    public func dequeueReusable<C: UICollectionViewCell>(cell clz: C.Type, for indexPath: IndexPath) -> C {
        let identifier = safeIdentifier(for: clz)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? C else {
            fatalError("⚠️ 未注册的Cell类型: \(identifier)")
        }
        return cell
    }

    public func dequeueReusable<C: UICollectionReusableView>(
        header clz: C.Type,
        for indexPath: IndexPath,
        kind: String = UICollectionView.elementKindSectionHeader
    ) -> C {
        let identifier = safeIdentifier(for: clz)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? C else {
            fatalError("⚠️ 未注册的Header类型: \(identifier)")
        }
        return view
    }
    
    public func dequeueReusable<C: UICollectionReusableView>(
        footer clz: C.Type,
        for indexPath: IndexPath,
        kind: String = UICollectionView.elementKindSectionFooter
    ) -> C {
        let identifier = safeIdentifier(for: clz)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? C else {
            fatalError("⚠️ 未注册的Footer类型: \(identifier)")
        }
        return view
    }
    
    // MARK: - iOS 15+ 新增方法
    
    /// 安全获取Cell（iOS 15+，支持配置）
    @available(iOS 15.0, *)
    public func dequeueReusable<C: UICollectionViewCell>(
        cell clz: C.Type,
        for indexPath: IndexPath,
        configuration: @escaping (C) -> Void
    ) -> C {
        let cell = dequeueReusable(cell: clz, for: indexPath)
        configuration(cell)
        return cell
    }
    
    /// 安全获取Header（iOS 15+，支持配置）
    @available(iOS 15.0, *)
    public func dequeueReusable<C: UICollectionReusableView>(
        header clz: C.Type,
        for indexPath: IndexPath,
        configuration: @escaping (C) -> Void,
        kind: String = UICollectionView.elementKindSectionHeader
    ) -> C {
        let view = dequeueReusable(header: clz, for: indexPath, kind: kind)
        configuration(view)
        return view
    }
    
    /// 安全获取Footer（iOS 15+，支持配置）
    @available(iOS 15.0, *)
    public func dequeueReusable<C: UICollectionReusableView>(
        footer clz: C.Type,
        for indexPath: IndexPath,
        configuration: @escaping (C) -> Void,
        kind: String = UICollectionView.elementKindSectionFooter
    ) -> C {
        let view = dequeueReusable(footer: clz, for: indexPath, kind: kind)
        configuration(view)
        return view
    }
    
    // MARK: - 批量注册方法
    
    /// 批量注册Cell类
    public func registerCells(_ cellClasses: [UICollectionViewCell.Type]) {
        cellClasses.forEach { register(cell: $0) }
    }
    
    /// 批量注册Nib Cell
    public func registerNibCells(_ nibCellClasses: [UICollectionViewCell.Type]) {
        nibCellClasses.forEach { register(nibCell: $0) }
    }
    
    /// 批量注册Header类
    public func registerHeaders(_ headerClasses: [UICollectionReusableView.Type]) {
        headerClasses.forEach { register(header: $0) }
    }
    
    /// 批量注册Footer类
    public func registerFooters(_ footerClasses: [UICollectionReusableView.Type]) {
        footerClasses.forEach { register(footer: $0) }
    }
    
    /// 批量注册Nib Header
    public func registerNibHeaders(_ nibHeaderClasses: [UICollectionReusableView.Type]) {
        nibHeaderClasses.forEach { register(nibHeader: $0) }
    }
    
    /// 批量注册Nib Footer
    public func registerNibFooters(_ nibFooterClasses: [UICollectionReusableView.Type]) {
        nibFooterClasses.forEach { register(nibFooter: $0) }
    }
    
    /// 预加载Cell（iOS 15+）
    @available(iOS 15.0, *)
    public func prefetchItems(at indexPaths: [IndexPath]) {
        // iOS 15+ 的预加载功能
        if let prefetchDataSource = prefetchDataSource {
            prefetchDataSource.collectionView(self, prefetchItemsAt: indexPaths)
        }
    }
    
    /// 取消预加载Cell（iOS 15+）
    @available(iOS 15.0, *)
    public func cancelPrefetching(forItemsAt indexPaths: [IndexPath]) {
        if let prefetchDataSource = prefetchDataSource {
            prefetchDataSource.collectionView?(self, cancelPrefetchingForItemsAt: indexPaths)
        }
    }
    
    /// 安全批量更新（带错误处理）
    public func safePerformBatchUpdates(
        _ updates: @escaping () -> Void,
        completion: @escaping (Bool) -> Void = { _ in }
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion(true)
        }
        
        performBatchUpdates(updates) { finished in
            if !finished {
                completion(false)
            }
        }
        
        CATransaction.commit()
    }
}

// MARK: - UICollectionView 自适应扩展
public extension UICollectionView {
    
    // MARK: - 自适应布局配置
    
    /// 配置CollectionView为自适应布局
    /// - Parameters:
    ///   - estimatedSize: 预估尺寸，默认CGSize(width: 100, height: 100)
    ///   - scrollDirection: 滚动方向，默认垂直
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    func configureAutoSizing(
        estimatedSize: CGSize = CGSize(width: 100, height: 100),
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = estimatedSize
            flowLayout.scrollDirection = scrollDirection
            flowLayout.minimumLineSpacing = minimumLineSpacing
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.sectionInset = sectionInset
        }
    }
    
    /// 配置CollectionView为完全自适应布局（iOS 10+推荐）
    func configureFullAutoSizing(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = scrollDirection
            flowLayout.minimumLineSpacing = minimumLineSpacing
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.sectionInset = sectionInset
        }
    }
    
    /// 配置CollectionView为高性能自适应布局（iOS 15+推荐）
    @available(iOS 15.0, *)
    func configureHighPerformanceAutoSizing(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        prefetchingEnabled: Bool = true,
        reorderingEnabled: Bool = false
    ) {
        // 使用CompositionalLayout获得更好的性能
        let layout = UICollectionView.createHighPerformanceCompositionalLayout(
            scrollDirection: scrollDirection,
            minimumLineSpacing: minimumLineSpacing,
            minimumInteritemSpacing: minimumInteritemSpacing,
            sectionInset: NSDirectionalEdgeInsets(
                top: sectionInset.top,
                leading: sectionInset.left,
                bottom: sectionInset.bottom,
                trailing: sectionInset.right
            )
        )
        
        setCollectionViewLayout(layout, animated: false)
        
        // 启用重新排序
        if reorderingEnabled {
            dragInteractionEnabled = true
            reorderingCadence = .immediate
        }
    }
    
    // MARK: - CompositionalLayout 自适应配置（iOS 13+）
    
    /// 创建自适应CompositionalLayout
    /// - Parameters:
    ///   - estimatedHeight: 预估高度，默认80
    ///   - widthFraction: 宽度比例，默认1.0（占满宽度）
    ///   - scrollDirection: 滚动方向，默认垂直
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    /// - Returns: 配置好的UICollectionViewCompositionalLayout
    static func createAutoSizingCompositionalLayout(
        estimatedHeight: CGFloat = 80,
        widthFraction: CGFloat = 1.0,
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(widthFraction),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        
        let group: NSCollectionLayoutGroup
        if scrollDirection == .vertical {
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        }
        
        group.interItemSpacing = .fixed(minimumInteritemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = minimumLineSpacing
        section.contentInsets = sectionInset
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    /// 创建高性能CompositionalLayout（iOS 15+）
    @available(iOS 15.0, *)
    static func createHighPerformanceCompositionalLayout(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        
        let group: NSCollectionLayoutGroup
        if scrollDirection == .vertical {
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        }
        
        group.interItemSpacing = .fixed(minimumInteritemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = minimumLineSpacing
        section.contentInsets = sectionInset
        
        // iOS 15+ 新增的优化配置
        section.orthogonalScrollingBehavior = .none
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            // 可以在这里添加可见性处理逻辑
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        // 设置布局配置
        layout.configuration.scrollDirection = scrollDirection
        layout.configuration.interSectionSpacing = minimumLineSpacing
        
        return layout
    }
    
    /// 创建网格布局CompositionalLayout
    @available(iOS 13.0, *)
    static func createGridCompositionalLayout(
        columns: Int = 2,
        estimatedHeight: CGFloat = 120,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(minimumInteritemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = minimumLineSpacing
        section.contentInsets = sectionInset
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    /// 创建瀑布流布局CompositionalLayout（iOS 15+）
    @available(iOS 15.0, *)
    static func createWaterfallCompositionalLayout(
        columns: Int = 2,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(minimumInteritemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = minimumLineSpacing
        section.contentInsets = sectionInset
        
        // 瀑布流效果通过自定义布局实现
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            // 这里可以实现瀑布流的高度计算逻辑
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    /// 应用自适应CompositionalLayout
    /// - Parameters:
    ///   - estimatedHeight: 预估高度，默认80
    ///   - widthFraction: 宽度比例，默认1.0
    ///   - scrollDirection: 滚动方向，默认垂直
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    func applyAutoSizingCompositionalLayout(
        estimatedHeight: CGFloat = 80,
        widthFraction: CGFloat = 1.0,
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) {
        let layout = UICollectionView.createAutoSizingCompositionalLayout(
            estimatedHeight: estimatedHeight,
            widthFraction: widthFraction,
            scrollDirection: scrollDirection,
            minimumLineSpacing: minimumLineSpacing,
            minimumInteritemSpacing: minimumInteritemSpacing,
            sectionInset: sectionInset
        )
        setCollectionViewLayout(layout, animated: false)
    }
    
    /// 应用网格布局
    @available(iOS 13.0, *)
    func applyGridLayout(
        columns: Int = 2,
        estimatedHeight: CGFloat = 120,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) {
        let layout = UICollectionView.createGridCompositionalLayout(
            columns: columns,
            estimatedHeight: estimatedHeight,
            minimumLineSpacing: minimumLineSpacing,
            minimumInteritemSpacing: minimumInteritemSpacing,
            sectionInset: sectionInset
        )
        setCollectionViewLayout(layout, animated: false)
    }
    
    /// 应用瀑布流布局（iOS 15+）
    @available(iOS 15.0, *)
    func applyWaterfallLayout(
        columns: Int = 2,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) {
        let layout = UICollectionView.createWaterfallCompositionalLayout(
            columns: columns,
            minimumLineSpacing: minimumLineSpacing,
            minimumInteritemSpacing: minimumInteritemSpacing,
            sectionInset: sectionInset
        )
        setCollectionViewLayout(layout, animated: false)
    }
    
    // MARK: - 自适应刷新方法
    
    /// 自适应刷新数据（带完成回调）
    /// - Parameter completion: 刷新完成回调
    func reloadDataWithAutoSizing(completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        reloadData()
        CATransaction.commit()
    }
    
    /// 自适应刷新指定区域
    /// - Parameters:
    ///   - sections: 要刷新的区域索引
    ///   - completion: 刷新完成回调
    func reloadSectionsWithAutoSizing(_ sections: IndexSet, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        reloadSections(sections)
        CATransaction.commit()
    }
    
    /// 自适应刷新指定项目
    /// - Parameters:
    ///   - indexPaths: 要刷新的项目索引路径
    ///   - completion: 刷新完成回调
    func reloadItemsWithAutoSizing(at indexPaths: [IndexPath], completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        reloadItems(at: indexPaths)
        CATransaction.commit()
    }
    
    /// 高性能刷新（iOS 15+）
    @available(iOS 15.0, *)
    func reloadDataWithHighPerformance(completion: @escaping () -> Void = {}) {
        // iOS 15+ 的优化刷新方法
        performBatchUpdates({
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// 智能刷新（根据数据变化自动选择最佳刷新方式）
    func smartReload(
        sections: IndexSet? = nil,
        indexPaths: [IndexPath]? = nil,
        completion: @escaping () -> Void = {}
    ) {
        if let sections = sections, !sections.isEmpty {
            reloadSectionsWithAutoSizing(sections, completion: completion)
        } else if let indexPaths = indexPaths, !indexPaths.isEmpty {
            reloadItemsWithAutoSizing(at: indexPaths, completion: completion)
        } else {
            reloadDataWithAutoSizing(completion: completion)
        }
    }
    
    // MARK: - 自适应布局验证
    
    /// 检查是否已配置自适应布局
    var isAutoSizingConfigured: Bool {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.estimatedItemSize != .zero
        }
        return collectionViewLayout is UICollectionViewCompositionalLayout
    }
    
    /// 获取当前布局的预估尺寸
    var currentEstimatedSize: CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.estimatedItemSize
        }
        return .zero
    }
    
    /// 检查是否使用CompositionalLayout
    var isUsingCompositionalLayout: Bool {
        return collectionViewLayout is UICollectionViewCompositionalLayout
    }
    
    /// 验证布局配置是否有效
    var isLayoutConfigurationValid: Bool {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.estimatedItemSize != .zero &&
                   flowLayout.minimumLineSpacing >= 0 &&
                   flowLayout.minimumInteritemSpacing >= 0
        } else {
            return isUsingCompositionalLayout
        }
    }
    
    // MARK: - 性能监控方法
    
    /// 获取可见Cell数量
    var visibleCellsCount: Int {
        return visibleCells.count
    }
    
    /// 获取可见区域
    var visibleRect: CGRect {
        return bounds
    }
    
    /// 检查是否在滚动
    var isScrolling: Bool {
        return isDecelerating || isDragging || isTracking
    }
    
}

// MARK: - UICollectionViewCell 自适应扩展

public extension UICollectionViewCell {
    
    /// 重写此方法以实现自适应布局（推荐在子类中重写）
    /// - Parameter layoutAttributes: 布局属性
    /// - Returns: 调整后的布局属性
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(
            layoutAttributes.size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
    // MARK: - 自适应布局辅助方法
    
    /// 计算内容视图的合适尺寸
    /// - Parameters:
    ///   - targetSize: 目标尺寸
    ///   - horizontalPriority: 水平优先级，默认required
    ///   - verticalPriority: 垂直优先级，默认fittingSizeLevel
    /// - Returns: 计算出的合适尺寸
    func calculateFittingSize(
        targetSize: CGSize,
        horizontalPriority: UILayoutPriority = .required,
        verticalPriority: UILayoutPriority = .fittingSizeLevel
    ) -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        
        return contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalPriority,
            verticalFittingPriority: verticalPriority
        )
    }
    
    /// 高性能计算合适尺寸（iOS 15+）
    @available(iOS 15.0, *)
    func calculateFittingSizeWithHighPerformance(
        targetSize: CGSize,
        horizontalPriority: UILayoutPriority = .required,
        verticalPriority: UILayoutPriority = .fittingSizeLevel
    ) -> CGSize {
        // iOS 15+ 的优化尺寸计算
        return contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalPriority,
            verticalFittingPriority: verticalPriority
        )
    }
    
    /// 获取Cell所在的CollectionView
    func getCollectionView() -> UICollectionView? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
    
    /// 获取Cell的IndexPath
    func getIndexPath() -> IndexPath? {
        return getCollectionView()?.indexPath(for: self)
    }
    
    /// 获取Cell的Section
    func getSection() -> Int? {
        return getIndexPath()?.section
    }
    
    /// 获取Cell的Item
    func getItem() -> Int? {
        return getIndexPath()?.item
    }
    
    /// 检查Cell是否可见
    var isVisible: Bool {
        guard let collectionView = getCollectionView() else { return false }
        return collectionView.visibleCells.contains(self)
    }
    
    /// 检查Cell是否在屏幕中心
    var isInCenter: Bool {
        guard let collectionView = getCollectionView() else { return false }
        let centerPoint = collectionView.convert(center, to: collectionView.superview)
        let collectionViewCenter = collectionView.center
        let distance = sqrt(pow(centerPoint.x - collectionViewCenter.x, 2) + pow(centerPoint.y - collectionViewCenter.y, 2))
        return distance < 50 // 50pt内的容差
    }
    
    // MARK: - 自适应布局验证
    
    /// 检查Cell是否使用AutoLayout
    var isUsingAutoLayout: Bool {
        return translatesAutoresizingMaskIntoConstraints == false
    }
    
    /// 验证AutoLayout约束是否完整
    var hasValidAutoLayoutConstraints: Bool {
        // 检查是否有基本的约束
        let hasWidthConstraint = contentView.constraints.contains { constraint in
            constraint.firstAttribute == .width || constraint.secondAttribute == .width
        }
        
        let hasHeightConstraint = contentView.constraints.contains { constraint in
            constraint.firstAttribute == .height || constraint.secondAttribute == .height
        }
        
        return hasWidthConstraint && hasHeightConstraint
    }
    
    /// 验证约束是否冲突
    var hasConstraintConflicts: Bool {
        let conflictingConstraints = contentView.constraints.filter { constraint in
            constraint.priority == .required && constraint.isActive && constraint.constant < 0
        }
        return !conflictingConstraints.isEmpty
    }
    
    /// 获取约束冲突信息
    var constraintConflictInfo: [String] {
        let conflictingConstraints = contentView.constraints.filter { constraint in
            constraint.priority == .required && constraint.isActive && constraint.constant < 0
        }
        return conflictingConstraints.map { constraint in
            "约束冲突: \(constraint.description)"
        }
    }
    
    // MARK: - iOS 15+ 新增特性
    
    /// 设置背景配置（iOS 14.0+）
    @available(iOS 14.0, *)
    func configureBackground(_ configuration: UIBackgroundConfiguration?) {
        backgroundConfiguration = configuration
    }
    
    /// 设置选中状态背景配置（iOS 14.0+）
    @available(iOS 14.0, *)
    func configureSelectedBackgroundConfiguration() -> UIBackgroundConfiguration {
        var configuration = UIBackgroundConfiguration.listPlainCell()
        configuration.cornerRadius = 8
        configuration.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        return configuration
    }
    
    /// 设置高亮状态背景配置（iOS 14.0+）
    @available(iOS 14.0, *)
    func configureHighlightedBackgroundConfiguration() -> UIBackgroundConfiguration {
        var configuration = UIBackgroundConfiguration.listPlainCell()
        configuration.cornerRadius = 8
        configuration.backgroundColor = .systemGray.withAlphaComponent(0.1)
        return configuration
    }

    /// 设置焦点组标识符（iOS 15.0+）
    @available(iOS 15.0, *)
    func setFocusGroupIdentifier(_ identifier: String?) {
        self.focusGroupIdentifier = identifier
    }
    /// 优化Cell重用（iOS 15+）
    @available(iOS 15.0, *)
    func optimizeForReuse() {
        // 清理不需要的资源
        contentView.subviews.forEach { subview in
            if let imageView = subview as? UIImageView {
                imageView.image = nil
            }
            if let label = subview as? UILabel {
                label.text = nil
            }
        }
    }
    
    /// 添加选中动画
    func addSelectionAnimation(duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
                self.transform = .identity
            }
        }
    }
    
    /// 添加高亮动画
    func addHighlightAnimation(duration: TimeInterval = 0.1) {
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.alpha = 0.7
        } completion: { _ in
            UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
                self.alpha = 1.0
            }
        }
    }
    
    /// 添加出现动画
    func addAppearanceAnimation(delay: TimeInterval = 0, duration: TimeInterval = 0.3) {
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction, .curveEaseOut]) {
            self.alpha = 1.0
            self.transform = .identity
        }
    }
    
    /// 添加消失动画
    func addDisappearanceAnimation(duration: TimeInterval = 0.3, completion: @escaping () -> Void = {}) {
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseIn]) {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -20)
        } completion: { _ in
            completion()
        }
    }
}

// MARK: - UICollectionViewFlowLayout 自适应扩展
public extension UICollectionViewFlowLayout {
    
    /// 配置为自适应布局
    /// - Parameters:
    ///   - estimatedSize: 预估尺寸，默认CGSize(width: 100, height: 100)
    ///   - scrollDirection: 滚动方向，默认垂直
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    func configureAutoSizing(
        estimatedSize: CGSize = CGSize(width: 100, height: 100),
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        self.estimatedItemSize = estimatedSize
        self.scrollDirection = scrollDirection
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
    }
    
    /// 配置为完全自适应布局
    /// - Parameters:
    ///   - scrollDirection: 滚动方向，默认垂直
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    func configureFullAutoSizing(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.scrollDirection = scrollDirection
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
    }
    
    /// 配置为高性能自适应布局（iOS 15+）
    @available(iOS 15.0, *)
    func configureHighPerformanceAutoSizing(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.scrollDirection = scrollDirection
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        
        // iOS 15+ 的优化设置
        self.itemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    /// 配置为网格布局
    /// - Parameters:
    ///   - columns: 列数，默认2
    ///   - itemHeight: 项目高度，默认120
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    func configureGridLayout(
        columns: Int = 2,
        itemHeight: CGFloat = 120,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        let availableWidth = UIScreen.main.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(columns - 1)
        let itemWidth = availableWidth / CGFloat(columns)
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = .vertical
    }
    
    /// 配置为瀑布流布局
    /// - Parameters:
    ///   - columns: 列数，默认2
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    func configureWaterfallLayout(
        columns: Int = 2,
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        let availableWidth = UIScreen.main.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(columns - 1)
        let itemWidth = availableWidth / CGFloat(columns)
        
        // 瀑布流需要动态计算高度，这里设置一个基础高度
        self.estimatedItemSize = CGSize(width: itemWidth, height: 100)
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = .vertical
    }
    
    /// 配置为水平滚动布局
    /// - Parameters:
    ///   - itemSize: 项目尺寸，默认CGSize(width: 200, height: 150)
    ///   - minimumLineSpacing: 最小行间距，默认10
    ///   - minimumInteritemSpacing: 最小项目间距，默认10
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    func configureHorizontalLayout(
        itemSize: CGSize = CGSize(width: 200, height: 150),
        minimumLineSpacing: CGFloat = 10,
        minimumInteritemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) {
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = .horizontal
    }
    
    /// 配置为卡片布局
    /// - Parameters:
    ///   - cardWidth: 卡片宽度，默认300
    ///   - cardHeight: 卡片高度，默认200
    ///   - minimumLineSpacing: 最小行间距，默认20
    ///   - minimumInteritemSpacing: 最小项目间距，默认20
    ///   - sectionInset: 区域边距，默认UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    func configureCardLayout(
        cardWidth: CGFloat = 300,
        cardHeight: CGFloat = 200,
        minimumLineSpacing: CGFloat = 20,
        minimumInteritemSpacing: CGFloat = 20,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    ) {
        self.itemSize = CGSize(width: cardWidth, height: cardHeight)
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = .vertical
    }
    
    // MARK: - 性能优化方法
    
    /// 优化布局性能
    func optimizePerformance() {
        // 设置合理的预估尺寸
        if estimatedItemSize == .zero {
            estimatedItemSize = CGSize(width: 100, height: 100)
        }
        
        // 设置合理的间距
        if minimumLineSpacing < 0 {
            minimumLineSpacing = 10
        }
        if minimumInteritemSpacing < 0 {
            minimumInteritemSpacing = 10
        }
    }
    
    /// 验证布局配置
    var isConfigurationValid: Bool {
        return estimatedItemSize != .zero &&
               minimumLineSpacing >= 0 &&
               minimumInteritemSpacing >= 0 &&
               itemSize.width > 0 &&
               itemSize.height > 0
    }
    /// 动态调整项目尺寸
    func adjustItemSize(_ newSize: CGSize, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.itemSize = newSize
                self.invalidateLayout()
            }
        } else {
            self.itemSize = newSize
            self.invalidateLayout()
        }
    }
    
    /// 动态调整间距
    func adjustSpacing(
        lineSpacing: CGFloat? = nil,
        interitemSpacing: CGFloat? = nil,
        animated: Bool = true
    ) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                if let lineSpacing = lineSpacing {
                    self.minimumLineSpacing = lineSpacing
                }
                if let interitemSpacing = interitemSpacing {
                    self.minimumInteritemSpacing = interitemSpacing
                }
                self.invalidateLayout()
            }
        } else {
            if let lineSpacing = lineSpacing {
                self.minimumLineSpacing = lineSpacing
            }
            if let interitemSpacing = interitemSpacing {
                self.minimumInteritemSpacing = interitemSpacing
            }
            self.invalidateLayout()
        }
    }
    
    /// 动态调整区域边距
    func adjustSectionInset(_ newInset: UIEdgeInsets, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.sectionInset = newInset
                self.invalidateLayout()
            }
        } else {
            self.sectionInset = newInset
            self.invalidateLayout()
        }
    }
}

/// 自适应CollectionViewCell基类
open class TFYSwiftAutoSizingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 属性
    
    /// 数据模型
    public var dataModel: Any?
    
    /// 配置完成回调
    public var configurationCompletion: (() -> Void)?
    
    /// 是否已配置
    public var isConfigured: Bool = false

    /// 内存使用量
    public var memoryUsage: Int {
        return calculateMemoryUsage()
    }
    
    // MARK: - 初始化
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoSizing()
        setupDefaultConfiguration()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAutoSizing()
        setupDefaultConfiguration()
    }
    
    // MARK: - 设置方法
    
    /// 设置自适应布局（子类可重写）
    open func setupAutoSizing() {
        // 确保使用AutoLayout
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置默认约束
        setupDefaultConstraints()
    }
    
    /// 设置默认配置
    open func setupDefaultConfiguration() {
        // 设置默认背景
        if #available(iOS 14.0, *) {
            backgroundConfiguration = createDefaultBackgroundConfiguration()
        }
        
        // 设置默认动画
        setupDefaultAnimations()
    }
    
    /// 设置默认约束
    open func setupDefaultConstraints() {
        // 子类可以重写此方法来设置默认约束
        // 例如：设置contentView的边距约束
    }
    
    /// 设置默认动画
    open func setupDefaultAnimations() {
        // 子类可以重写此方法来设置默认动画
    }
    
    /// 创建默认背景配置
    @available(iOS 14.0, *)
    open func createDefaultBackgroundConfiguration() -> UIBackgroundConfiguration {
        var configuration = UIBackgroundConfiguration.listPlainCell()
        configuration.cornerRadius = 8
        configuration.backgroundColor = UIColor.systemBackground
        return configuration
    }
    
    // MARK: - 重写方法
    
    /// 重写自适应布局方法
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(
            layoutAttributes.size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
    /// 重写准备重用方法
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        // 清理数据
        dataModel = nil
        isConfigured = false
        configurationCompletion = nil
        
        // 优化重用
        if #available(iOS 15.0, *) {
            optimizeForReuse()
        }
        
        // 重置状态
        resetToDefaultState()
    }
    
    /// 重写设置高亮状态方法
    open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if animated {
            if highlighted {
                addHighlightAnimation()
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 1.0
                }
            }
        }
    }
    
    /// 重写设置选中状态方法
    open func setSelected(_ selected: Bool, animated: Bool) {
        if animated {
            if selected {
                addSelectionAnimation()
            }
        }
    }
    
    // MARK: - 配置方法
    
    /// 配置Cell（主要配置方法）
    /// - Parameter data: 数据模型
    open func configure(with data: Any) {
        dataModel = data
        configureUI()
        bindData(data)
        isConfigured = true
        configurationCompletion?()
    }
    
    /// 子类重写此方法进行UI设置
    open func configureUI() {
        // 子类实现具体UI配置
    }
    
    /// 子类重写此方法进行数据绑定
    open func bindData(_ data: Any) {
        // 子类实现具体数据绑定
    }
    
    /// 更新背景配置
    @available(iOS 14.0, *)
    open func updateBackgroundConfiguration(for state: UICellConfigurationState) {
        var configuration = backgroundConfiguration ?? createDefaultBackgroundConfiguration()
        
        // UICellConfigurationState没有selected和highlighted状态，使用默认背景
        configuration.backgroundColor = UIColor.systemBackground
        
        backgroundConfiguration = configuration
    }
    
    /// 重置到默认状态
    open func resetToDefaultState() {
        alpha = 1.0
        transform = .identity
        
        if #available(iOS 14.0, *) {
            backgroundConfiguration = createDefaultBackgroundConfiguration()
        }
    }
    
    // MARK: - 性能优化方法
    
    /// 计算内存使用量
    open func calculateMemoryUsage() -> Int {
        var usage = 0
        
        // 计算图片内存
        contentView.subviews.forEach { subview in
            if let imageView = subview as? UIImageView, let image = imageView.image {
                usage += Int(image.size.width * image.size.height * 4) // 4 bytes per pixel
            }
        }
        
        // 计算文本内存
        contentView.subviews.forEach { subview in
            if let label = subview as? UILabel, let text = label.text {
                usage += text.count * 2 // 估算每个字符2字节
            }
        }
        
        return usage
    }
    
    /// 预加载内容
    @available(iOS 15.0, *)
    open func preloadContent() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    /// 清理资源
    open func cleanupResources() {
        contentView.subviews.forEach { subview in
            if let imageView = subview as? UIImageView {
                imageView.image = nil
            }
            if let label = subview as? UILabel {
                label.text = nil
            }
        }
    }
}

// MARK: - 扩展方法

public extension TFYSwiftAutoSizingCollectionViewCell {
    
    /// 快速配置方法
    func quickConfigure<T>(
        with data: T,
        uiConfig: ((TFYSwiftAutoSizingCollectionViewCell) -> Void)? = nil,
        dataConfig: ((TFYSwiftAutoSizingCollectionViewCell, T) -> Void)? = nil
    ) {
        dataModel = data
        uiConfig?(self)
        dataConfig?(self, data)
        isConfigured = true
        configurationCompletion?()
    }
    
    /// 链式配置方法
    @discardableResult
    func configureChain<T>(
        with data: T,
        uiConfig: ((TFYSwiftAutoSizingCollectionViewCell) -> Void)? = nil,
        dataConfig: ((TFYSwiftAutoSizingCollectionViewCell, T) -> Void)? = nil
    ) -> Self {
        quickConfigure(with: data, uiConfig: uiConfig, dataConfig: dataConfig)
        return self
    }
    
    /// 设置配置完成回调
    @discardableResult
    func onConfigurationComplete(_ completion: @escaping () -> Void) -> Self {
        configurationCompletion = completion
        return self
    }

}
