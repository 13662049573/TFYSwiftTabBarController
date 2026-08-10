//
//  UITableView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UITableView {
    /// 设置背景视图
    @discardableResult
    func backgroundView(_ backgroundView: UIView?) -> Self {
        base.backgroundView = backgroundView
        return self
    }
    /// 设置数据源
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        base.dataSource = dataSource
        return self
    }
    /// 设置代理
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    /// 设置行高
    @discardableResult
    func rowHeight(_ rowHeight: CGFloat) -> Self {
        base.rowHeight = max(0, rowHeight)
        return self
    }
    /// 设置Section头部高度
    @discardableResult
    func sectionHeaderHeight(_ sectionHeaderHeight: CGFloat) -> Self {
        base.sectionHeaderHeight = max(0, sectionHeaderHeight)
        return self
    }
    /// 设置Section底部高度
    @discardableResult
    func sectionFooterHeight(_ sectionFooterHeight: CGFloat) -> Self {
        base.sectionFooterHeight = max(0, sectionFooterHeight)
        return self
    }
    /// 设置预估行高
    @discardableResult
    func estimatedRowHeight(_ estimatedRowHeight: CGFloat) -> Self {
        base.estimatedRowHeight = max(0, estimatedRowHeight)
        return self
    }
    /// 设置预估Section头部高度
    @discardableResult
    func estimatedSectionHeaderHeight(_ estimatedSectionHeaderHeight: CGFloat) -> Self {
        base.estimatedSectionHeaderHeight = max(0, estimatedSectionHeaderHeight)
        return self
    }
    /// 设置预估Section底部高度
    @discardableResult
    func estimatedSectionFooterHeight(_ estimatedSectionFooterHeight: CGFloat) -> Self {
        base.estimatedSectionFooterHeight = max(0, estimatedSectionFooterHeight)
        return self
    }
    /// 设置索引颜色
    @discardableResult
    func sectionIndexColor(_ sectionIndexColor: UIColor?) -> Self {
        base.sectionIndexColor = sectionIndexColor
        return self
    }
    /// 设置索引背景颜色
    @discardableResult
    func sectionIndexBackgroundColor(_ sectionIndexBackgroundColor: UIColor?) -> Self {
        base.sectionIndexBackgroundColor = sectionIndexBackgroundColor
        return self
    }
    /// 设置索引跟踪背景颜色
    @discardableResult
    func sectionIndexTrackingBackgroundColor(_ sectionIndexTrackingBackgroundColor: UIColor?) -> Self {
        base.sectionIndexTrackingBackgroundColor = sectionIndexTrackingBackgroundColor
        return self
    }
    /// 设置索引最小显示行数
    @discardableResult
    func sectionIndexMinimumDisplayRowCount(_ sectionIndexMinimumDisplayRowCount: Int) -> Self {
        base.sectionIndexMinimumDisplayRowCount = max(0, sectionIndexMinimumDisplayRowCount)
        return self
    }
    /// 设置分割线样式
    @discardableResult
    func separatorStyle(_ separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        base.separatorStyle = separatorStyle
        return self
    }
    /// 设置分割线颜色
    @discardableResult
    func separatorColor(_ separatorColor: UIColor?) -> Self {
        base.separatorColor = separatorColor
        return self
    }
    /// 设置分割线内边距
    @discardableResult
    func separatorInset(_ separatorInset: UIEdgeInsets) -> Self {
        base.separatorInset = separatorInset
        return self
    }
    /// 设置分割线内边距（分开设置）
    @discardableResult
    func separatorInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        base.separatorInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    /// 设置表格头部视图
    @discardableResult
    func tableHeaderView(_ tableHeaderView: UIView?) -> Self {
        base.tableHeaderView = tableHeaderView
        return self
    }
    /// 设置表格底部视图
    @discardableResult
    func tableFooterView(_ tableFooterView: UIView?) -> Self {
        base.tableFooterView = tableFooterView
        return self
    }
    /// 注册Nib Cell
    @discardableResult
    func registerNibCell(_ nib: UITableViewCell.Type) -> Self {
        base.register(nibCell: nib)
        return self
    }
    /// 注册Cell类
    @discardableResult
    func registerCell(_ cellClass: UITableViewCell.Type) -> Self {
        base.register(cell: cellClass)
        return self
    }
    /// 注册Nib头部或底部视图
    @discardableResult
    func registerNibHeaderOrFooter(_ nib: UITableViewHeaderFooterView.Type) -> Self {
        base.register(nibHeaderOrFooter: nib)
        return self
    }
    /// 注册头部或底部视图类
    @discardableResult
    func registerHeaderOrFooter(_ aClass: UITableViewHeaderFooterView.Type) -> Self {
        base.register(headerOrFooter: aClass)
        return self
    }
    /// 设置所有预估高度
    @discardableResult
    func estimatedAll(_ height:CGFloat = CGFloat.leastNormalMagnitude) -> Self {
        if #available(iOS 11.0, *) {
            base.contentInsetAdjustmentBehavior = .never
            base.estimatedRowHeight = height
            base.estimatedSectionHeaderHeight = height
            base.estimatedSectionFooterHeight = height
        }else{
            let height = height >= 2 ? height : 2
            base.estimatedRowHeight = height
            base.estimatedSectionHeaderHeight = height
            base.estimatedSectionFooterHeight = height
        }
        base.rowHeight = UITableView.automaticDimension
        base.sectionHeaderHeight = UITableView.automaticDimension
        base.sectionFooterHeight = UITableView.automaticDimension
        return self
    }
    /// 设置预取数据源（iOS 10.0+）
    @available(iOS 10.0, *)
    @discardableResult
    func prefetchDataSource(dataSource d: UITableViewDataSourcePrefetching?) -> Self {
        base.prefetchDataSource = d
        return self
    }
    /// 设置拖拽代理（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func dropDelegate(delegate d: UITableViewDropDelegate?) -> Self {
        base.dropDelegate = d
        return self
    }
    /// 设置分割线内边距参考（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func separatorInsetReference(insetReference i: UITableView.SeparatorInsetReference) -> Self {
        base.separatorInsetReference = i
        return self
    }
}

extension UITableView {
    // MARK: - 注册方法
    public func register<C: RawRepresentable>(nibHeaderOrFooter reused: C) where C.RawValue == String {
        register(reused.nib(), forHeaderFooterViewReuseIdentifier: reused.rawValue)
    }
    
    public func register<C: UITableViewHeaderFooterView>(headerOrFooter clz: C.Type) {
        register(clz, forHeaderFooterViewReuseIdentifier: identifier(for: clz))
    }
    
    public func register<C: UITableViewHeaderFooterView>(nibHeaderOrFooter clz: C.Type) {
        register(identifier(for: clz).nib(), forHeaderFooterViewReuseIdentifier: identifier(for: clz))
    }
    
    public func register<C: RawRepresentable>(nibCell reused: C) where C.RawValue == String {
        register(reused.nib(), forCellReuseIdentifier: reused.rawValue)
    }
    
    public func register<C: UITableViewCell>(cell clz: C.Type) {
        register(clz, forCellReuseIdentifier: identifier(for: clz))
    }
    
    public func register<C: UITableViewCell>(nibCell clz: C.Type) {
        register(identifier(for: clz).nib(), forCellReuseIdentifier: identifier(for: clz))
    }
    
    // MARK: - 复用方法
    public func dequeueReusable<C: RawRepresentable>(cell reused: C, for indexPath: IndexPath) -> UITableViewCell where C.RawValue == String {
        dequeueReusableCell(withIdentifier: reused.rawValue, for: indexPath)
    }
    
    public func dequeueReusable<C: UITableViewCell>(cell clz: C.Type, for indexPath: IndexPath) -> C {
        guard let cell = dequeueReusableCell(withIdentifier: identifier(for: clz), for: indexPath) as? C else {
            fatalError("Failed to dequeue cell with identifier: \(identifier(for: clz))")
        }
        return cell
    }
    
    public func dequeueReusable<C: RawRepresentable>(headerOrFooter reused: C) -> UITableViewHeaderFooterView? where C.RawValue == String {
        dequeueReusableHeaderFooterView(withIdentifier: reused.rawValue)
    }
    
    public func dequeueReusable<C: UITableViewHeaderFooterView>(headerOrFooter clz: C.Type) -> C? {
        dequeueReusableHeaderFooterView(withIdentifier: identifier(for: clz)) as? C
    }
    
    // MARK: - 更新操作
    public func update(with block: (_ tableView: UITableView) -> Void) {
        beginUpdates()
        block(self)
        endUpdates()
    }
    
    // MARK: - 滚动操作
    public func scrollTo(row: Int, in section: Int, at position: UITableView.ScrollPosition, animated: Bool) {
        guard isValidIndexPath(row: row, section: section) else { return }
        let indexPath = IndexPath(row: row, section: section)
        scrollToRow(at: indexPath, at: position, animated: animated)
    }
    
    /// 滚动到指定行，并居中显示
    /// - Parameters:
    ///   - row: 目标行数
    ///   - section: 目标组数
    ///   - animated: 是否使用动画
    public func scrollToMiddle(row: Int, in section: Int, animated: Bool = true) {
        guard isValidIndexPath(row: row, section: section) else { return }
        let indexPath = IndexPath(row: row, section: section)
        scrollToRow(at: indexPath, at: .middle, animated: animated)
    }

    /// 滚动到指定行，并居中显示（使用IndexPath）
    /// - Parameters:
    ///   - indexPath: 目标位置
    ///   - animated: 是否使用动画
    public func scrollToMiddle(at indexPath: IndexPath, animated: Bool = true) {
        guard isValid(indexPath: indexPath) else { return }
        scrollToRow(at: indexPath, at: .middle, animated: animated)
    }

    /// 滚动到指定行，并居中显示（使用cell）
    /// - Parameters:
    ///   - cell: 目标cell
    ///   - animated: 是否使用动画
    public func scrollToMiddle(cell: UITableViewCell, animated: Bool = true) {
        guard let indexPath = indexPath(for: cell) else { return }
        scrollToRow(at: indexPath, at: .middle, animated: animated)
    }
    
    // MARK: - 增删改操作
    public func insert(row: Int, in section: Int, with rowAnimation: UITableView.RowAnimation) {
        guard isValidIndexPath(row: row, section: section, allowEqual: true) else { return }
        insert(at: IndexPath(row: row, section: section), with: rowAnimation)
    }
    
    func reload(row: Int, in section: Int, with rowAnimation: UITableView.RowAnimation) {
        guard isValidIndexPath(row: row, section: section) else { return }
        reload(at: IndexPath(row: row, section: section), with: rowAnimation)
    }

    func delete(row: Int, in section: Int, with rowAnimation: UITableView.RowAnimation) {
        guard isValidIndexPath(row: row, section: section) else { return }
        delete(at: IndexPath(row: row, section: section), with: rowAnimation)
    }

    func insert(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        guard isValid(indexPath: indexPath) else { return }
        insertRows(at: [indexPath], with: rowAnimation)
    }

    func reload(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        guard isValid(indexPath: indexPath) else { return }
        reloadRows(at: [indexPath], with: rowAnimation)
    }

    func delete(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        guard isValid(indexPath: indexPath) else { return }
        deleteRows(at: [indexPath], with: rowAnimation)
    }

    func reload(section: Int, with rowAnimation: UITableView.RowAnimation) {
        guard section >= 0, section < numberOfSections else { return }
        reloadSections(IndexSet(integer: section), with: rowAnimation)
    }
    
    // MARK: - 选择操作
    public func clearSelectedRows(animated: Bool) {
        indexPathsForSelectedRows?.forEach { deselectRow(at: $0, animated: animated) }
    }
    
    // MARK: - 辅助方法
    public func reloadCell(_ cell: UITableViewCell, with animation: UITableView.RowAnimation) {
        guard let indexPath = indexPath(for: cell) else { return }
        reloadRows(at: [indexPath], with: animation)
    }
    
    public func scrollToBottom(position: UITableView.ScrollPosition = .bottom, animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        
        let lastSection = numberOfSections - 1
        guard numberOfRows(inSection: lastSection) > 0 else { return }
        
        let lastRow = numberOfRows(inSection: lastSection) - 1
        let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
        scrollToRow(at: lastIndexPath, at: position, animated: animated)
    }
    
    // MARK: - 新增实用方法
    public func reloadData(completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        reloadData()
        CATransaction.commit()
    }
    
    public func isValid(indexPath: IndexPath) -> Bool {
        indexPath.section >= 0 && indexPath.section < numberOfSections && indexPath.row >= 0 && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    // MARK: - 私有方法
    private func identifier(for clz: AnyClass) -> String {
        String(describing: clz).components(separatedBy: ".").last ?? String(describing: clz)
    }
    
    private func isValidIndexPath(row: Int, section: Int, allowEqual: Bool = false) -> Bool {
        guard section >= 0, section < numberOfSections else { return false }
        let rowCount = numberOfRows(inSection: section)
        return allowEqual ? row >= 0 && row <= rowCount : row >= 0 && row < rowCount
    }
}
