//
//  device+ITools.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/4/28.
//

import Foundation
import UIKit

/// MARK ---------------------------------------------------------------  UIDevice ---------------------------------------------------------------
public extension TFY where Base == UIDevice {
    
    func isPhoneX() -> Bool {
        var isMore:Bool = false
        if #available(iOS 11.0, *) {
            isMore = (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! > 0
        }
        return isMore
    }
}

