//
//  UINavigationBar+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UINavigationBar {
    
    @discardableResult
    func barStyle(_ barStyle: UIBarStyle) -> TFY {
        base.barStyle = barStyle
        return self
    }
    
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> TFY {
        base.isTranslucent = isTranslucent
        return self
    }
    
    @discardableResult
    func barTintColor(_ barTintColor: UIColor?) -> TFY {
        base.barTintColor = barTintColor
        return self
    }
    
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for barPosition: UIBarPosition = .any, barMetrics: UIBarMetrics = .default) -> TFY {
        base.setBackgroundImage(backgroundImage, for: barPosition, barMetrics: barMetrics)
        return self
    }
    
    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> TFY {
        base.shadowImage = shadowImage
        return self
    }
    
    @discardableResult
    func titleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key : Any]?) -> TFY {
        base.titleTextAttributes = titleTextAttributes
        return self
    }
    
    @discardableResult
    func prefersLargeTitles(_ prefersLargeTitles: Bool) -> TFY {
        if #available(iOS 11.0, *) {
            base.prefersLargeTitles = prefersLargeTitles
        }
        return self
    }
    
    @discardableResult
    func largeTitleTextAttributes(_ largeTitleTextAttributes: [NSAttributedString.Key : Any]?) -> TFY {
        if #available(iOS 11.0, *) {
            base.largeTitleTextAttributes = largeTitleTextAttributes
        }
        return self
    }
}
