//
//  UITableViewCell+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit

public extension UITableViewCell {
    /// 获取Cell所在的TableView
    func getTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
    /// 获取Cell的IndexPath
    func getIndexPath() -> IndexPath? {
        return getTableView()?.indexPath(for: self)
    }
    /// 从Xib创建Cell（使用类名作为标识符）
    func cellFromXibWithTableView(tableView:UITableView) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromXibTableView(tableView: tableView, xibName: className, identifer: className)
    }
    /// 从Xib创建Cell（指定标识符）
    func cellFromXibWithTableView(tableView:UITableView,identifer:String) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromXibTableView(tableView: tableView, xibName: className, identifer: identifer)
    }
    /// 从代码创建Cell（使用类名作为标识符）
    func cellFromCodeWithTableView(tableView:UITableView) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromCodeWithTableView(tableView: tableView, identifier: className)
    }
    /// 从Xib创建Cell（指定Xib名称和标识符）
    func cellFromXibTableView(tableView:UITableView,xibName:String,identifer:String) -> Self {
        guard !xibName.isEmpty, !identifer.isEmpty else { return self }
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            let xibPath:String = Bundle.main.path(forResource: xibName, ofType: "nib") ?? ""
            if xibPath.isEmpty {
               cell = self.cellFromCodeWithTableView(tableView: tableView, identifier: identifer)
            } else {
                cell = Bundle.main.loadNibNamed(xibName, owner: nil, options: nil)?.last as? UITableViewCell
            }
        }
        return self
    }
    /// 从代码创建Cell（指定标识符）
    func cellFromCodeWithTableView(tableView:UITableView,identifier:String) -> Self {
        guard !identifier.isEmpty else { return self }
        let className:String = NSStringFromClass(self.classForCoder)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            guard let anyClass = NSClassFromString(className) as? UITableViewCell.Type else { return self }
            cell = anyClass.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        return self
    }
}
