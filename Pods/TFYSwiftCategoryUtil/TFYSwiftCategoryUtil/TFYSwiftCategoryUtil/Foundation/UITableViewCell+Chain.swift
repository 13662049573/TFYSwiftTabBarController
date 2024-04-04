//
//  UITableViewCell+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation
import UIKit

public extension UITableViewCell {
    
    func getTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
    
    func getIndexPath() -> IndexPath? {
        return getTableView()?.indexPath(for: self)
    }
    
    func cellFromXibWithTableView(tableView:UITableView) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromXibTableView(tableView: tableView, xibName: className, identifer: className)
    }

    func cellFromXibWithTableView(tableView:UITableView,identifer:String) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromXibTableView(tableView: tableView, xibName: className, identifer: identifer)
    }

    func cellFromCodeWithTableView(tableView:UITableView) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromCodeWithTableView(tableView: tableView, identifier: className)
    }

    func cellFromXibTableView(tableView:UITableView,xibName:String,identifer:String) -> Self {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            let xibPath:String = Bundle.main.path(forResource: xibName, ofType: "nib") ?? ""
            if xibPath.isEmpty {
               cell = self.cellFromCodeWithTableView(tableView: tableView, identifier: identifer)
            }
            cell = Bundle.main.loadNibNamed(xibName, owner: nil, options: nil)?.last as? UITableViewCell
        }
        return self
    }

   func cellFromCodeWithTableView(tableView:UITableView,identifier:String) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            let anyClass = NSClassFromString(className) as! UITableViewCell.Type
            cell = anyClass.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
       return self
    }
}
