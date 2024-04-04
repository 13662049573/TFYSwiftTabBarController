//
//  UITableView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UITableView {
    
    @discardableResult
    func backgroundView(_ backgroundView: UIView?) -> TFY {
        base.backgroundView = backgroundView
        return self
    }

    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource?) -> TFY {
        base.dataSource = dataSource
        return self
    }
    
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate?) -> TFY {
        base.delegate = delegate
        return self
    }
    
    @discardableResult
    func rowHeight(_ rowHeight: CGFloat) -> TFY {
        base.rowHeight = rowHeight
        return self
    }
    
    @discardableResult
    func sectionHeaderHeight(_ sectionHeaderHeight: CGFloat) -> TFY {
        base.sectionHeaderHeight = sectionHeaderHeight
        return self
    }
    
    @discardableResult
    func sectionFooterHeight(_ sectionFooterHeight: CGFloat) -> TFY {
        base.sectionFooterHeight = sectionFooterHeight
        return self
    }
    
    @discardableResult
    func estimatedRowHeight(_ estimatedRowHeight: CGFloat) -> TFY {
        base.estimatedRowHeight = estimatedRowHeight
        return self
    }
    
    @discardableResult
    func estimatedSectionHeaderHeight(_ estimatedSectionHeaderHeight: CGFloat) -> TFY {
        base.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
        return self
    }
    
    @discardableResult
    func estimatedSectionFooterHeight(_ estimatedSectionFooterHeight: CGFloat) -> TFY {
        base.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        return self
    }
    
    @discardableResult
    func sectionIndexColor(_ sectionIndexColor: UIColor?) -> TFY {
        base.sectionIndexColor = sectionIndexColor
        return self
    }
    
    @discardableResult
    func sectionIndexBackgroundColor(_ sectionIndexBackgroundColor: UIColor?) -> TFY {
        base.sectionIndexBackgroundColor = sectionIndexBackgroundColor
        return self
    }
    
    @discardableResult
    func sectionIndexTrackingBackgroundColor(_ sectionIndexTrackingBackgroundColor: UIColor?) -> TFY {
        base.sectionIndexTrackingBackgroundColor = sectionIndexTrackingBackgroundColor
        return self
    }
    
    @discardableResult
    func sectionIndexMinimumDisplayRowCount(_ sectionIndexMinimumDisplayRowCount: Int) -> TFY {
        base.sectionIndexMinimumDisplayRowCount = sectionIndexMinimumDisplayRowCount
        return self
    }
    
    @discardableResult
    func separatorStyle(_ separatorStyle: UITableViewCell.SeparatorStyle) -> TFY {
        base.separatorStyle = separatorStyle
        return self
    }

    @discardableResult
    func separatorColor(_ separatorColor: UIColor?) -> TFY {
        base.separatorColor = separatorColor
        return self
    }
    
    @discardableResult
    func separatorInset(_ separatorInset: UIEdgeInsets) -> TFY {
        base.separatorInset = separatorInset
        return self
    }
    
    @discardableResult
    func separatorInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> TFY {
        base.separatorInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    @discardableResult
    func tableHeaderView(_ tableHeaderView: UIView?) -> TFY {
        base.tableHeaderView = tableHeaderView
        return self
    }
    
    @discardableResult
    func tableFooterView(_ tableFooterView: UIView?) -> TFY {
        base.tableFooterView = tableFooterView
        return self
    }
    
    @discardableResult
    func registerNibCell(_ nib: UITableViewCell.Type) -> TFY {
        base.register(nibCell: nib)
        return self
    }
    
    @discardableResult
    func registerCell(_ cellClass: UITableViewCell.Type) -> TFY {
        base.register(cell: cellClass)
        return self
    }
    
    @discardableResult
    func registerNibHeaderOrFooter(_ nib: UITableViewHeaderFooterView.Type) -> TFY {
        base.register(nibHeaderOrFooter: nib)
        return self
    }
    
    @discardableResult
    func registerHeaderOrFooter(_ aClass: UITableViewHeaderFooterView.Type) -> TFY {
        base.register(headerOrFooter: aClass)
        return self
    }
    
    @discardableResult
    func estimatedAll(_ height:CGFloat = CGFloat.leastNormalMagnitude) -> TFY {
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
    
    @available(iOS 10.0, *)
    @discardableResult
    func prefetchDataSource(dataSource d: UITableViewDataSourcePrefetching?) -> TFY {
        base.prefetchDataSource = d
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    func dropDelegate(delegate d: UITableViewDropDelegate?) -> TFY {
        base.dropDelegate = d
        return self
    }

    @available(iOS 11.0, *)
    @discardableResult
    func separatorInsetReference(insetReference i: UITableView.SeparatorInsetReference) -> TFY {
        base.separatorInsetReference = i
        return self
    }
    
}

extension UITableView {

    public func register<C>(nibHeaderOrFooter reused:C) where C : RawRepresentable, C.RawValue == String {
        register(reused.nib(), forHeaderFooterViewReuseIdentifier: reused.rawValue)
    }
    public func register<C>(headerOrFooter clz:C.Type) where C : UITableViewHeaderFooterView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    public func register<C>(nibHeaderOrFooter clz:C.Type) where C : UITableViewHeaderFooterView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func register<C>(nibCell reused:C) where C : RawRepresentable, C.RawValue == String {
        register(reused.nib(), forCellReuseIdentifier: reused.rawValue)
    }
    public func register<C>(cell clz:C.Type) where C : UITableViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forCellReuseIdentifier: identifier)
    }
    public func register<C>(nibCell clz:C.Type) where C : UITableViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forCellReuseIdentifier: identifier)
    }
    
    public func dequeueReusable<C>(cell reused: C, for indexPath: IndexPath) -> UITableViewCell where C : RawRepresentable, C.RawValue == String {
        return dequeueReusableCell(withIdentifier: reused.rawValue, for: indexPath)
    }
    public func dequeueReusable<C>(cell clz: C.Type, for indexPath: IndexPath) -> C where C : UITableViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! C
    }
    
    public func dequeueReusable<C>(headerOrFooter reused: C) -> UITableViewHeaderFooterView? where C : RawRepresentable, C.RawValue == String {
        return dequeueReusableHeaderFooterView(withIdentifier: reused.rawValue)
    }
    public func dequeueReusable<C>(headerOrFooter clz: C.Type) -> C? where C : UITableViewHeaderFooterView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as? C
    }
    
    public func update(with block: (_ tableView: UITableView) -> ()) {
        self.beginUpdates()
        block(self)
        self.endUpdates()
    }
    
    public func scrollTo(row: NSInteger, in section: NSInteger, at ScrollPosition: UITableView.ScrollPosition, animated: Bool){
        let indexPath = IndexPath(row: row, section: section)
        self.scrollToRow(at: indexPath, at: ScrollPosition, animated: animated)
    }
    
    public func insert(row: NSInteger, in section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        self.insertRows(at: [indexPath], with: rowAnimation)
    }
    
    public func reload(row: NSInteger, in section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        self.reloadRows(at: [indexPath], with: rowAnimation)
    }
    
    public func delete(row: NSInteger, in section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        self.deleteRows(at: [indexPath], with: rowAnimation)
    }
    
    public func insert(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        self.insertRows(at: [indexPath], with: rowAnimation)
    }
    
    public func reload(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        self.reloadRows(at: [indexPath], with: rowAnimation)
    }
    
    public func delete(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        self.deleteRows(at: [indexPath], with: rowAnimation)
    }
    
    public func reload(section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        self.reloadSections([section], with: rowAnimation)
    }
    
    public func clearSelectedRows(animated: Bool) {
        guard let indexs = self.indexPathsForSelectedRows else { return }
        for path in indexs {
            self.deselectRow(at: path, animated: animated)
        }
    }

    /// Reload cell  at index path
    /// - Parameters:
    ///   - cell: cell
    ///   - animation: animation
    func reloadCell(_ cell: UITableViewCell, with animation: UITableView.RowAnimation) {
        if let indexPath = indexPath(for: cell) {
            reloadRows(at: [indexPath], with: animation)
        }
    }
    
    /// Scroll to last index in last section
    /// - Parameters:
    ///   - position: position
    ///   - animated: animated
    func scrollToBottom(position: UITableView.ScrollPosition = .bottom, animated: Bool = true) {
        if let lastSection = (0 ..< numberOfSections).reversed().first(where: { numberOfRows(inSection: $0) > 0 }) {
            let lastRow = numberOfRows(inSection: lastSection) - 1
            let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
            scrollToRow(at: lastIndexPath, at: position, animated: animated)
        }
    }
}
