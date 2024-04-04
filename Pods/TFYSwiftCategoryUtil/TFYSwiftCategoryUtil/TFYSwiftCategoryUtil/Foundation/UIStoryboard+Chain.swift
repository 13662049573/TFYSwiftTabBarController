//
//  UIStoryboard+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation
import UIKit

public extension UIStoryboard {
    
    func instantiateViewController<C>(with clz:C.Type) -> C where C : UIViewController {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        return instantiateViewController(withIdentifier: identifier) as! C
    }
    
}
