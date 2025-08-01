//
//  UIStoryboard+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit

public extension UIStoryboard {
    /// 根据类型实例化视图控制器
    func instantiateViewController<C>(with clz:C.Type) -> C where C : UIViewController {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last?.description ?? ""
        guard !identifier.isEmpty else {
            fatalError("⚠️ 无效的类名格式: \(NSStringFromClass(clz as AnyClass))")
        }
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? C else {
            fatalError("⚠️ 无法实例化视图控制器: \(identifier)")
        }
        return viewController
    }
}
