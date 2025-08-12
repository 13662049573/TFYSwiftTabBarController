//
//  UIScreen+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/12/8.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit

public struct Screen {
    /// 主屏幕宽度
    public static let width = UIScreen.main.bounds.width
    
    /// 主屏幕高度
    public static let height = UIScreen.main.bounds.height
    
    /// 主屏幕边界
    public static let bounds = UIScreen.main.bounds
    
    /// 主屏幕原点
    public static let origin = UIScreen.main.bounds.origin
    
    /// 主屏幕尺寸
    public static let size = UIScreen.main.bounds.size
    
    /// 主屏幕中心点
    public static let center = CGPoint(x: width / 2, y: height / 2)
    
    /// 是否为iPhone
    public static var isiPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// 是否为iPad
    public static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 是否为横屏
    public static var isLandscape: Bool {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    /// 是否为竖屏
    public static var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
}
