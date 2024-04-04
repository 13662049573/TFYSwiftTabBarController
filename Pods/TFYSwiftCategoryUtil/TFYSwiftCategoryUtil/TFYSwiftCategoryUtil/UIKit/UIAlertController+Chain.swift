//
//  UIAlertController+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public extension UIAlertController {
    @discardableResult
    static func tfy_init(title: String? = nil, message: String? = nil, style : UIAlertController.Style = .alert) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: style)
    }
}

public extension TFY where Base: UIAlertController {
    
    @discardableResult
    func show(_ vc:UIViewController?, block:(()->Void)? = nil) -> TFY {
        if base.title == nil && base.message == nil && base.actions.count == 0 {
            assertionFailure("👻💀大哥！你别什么东西都不放💀👻")
            return self
        }
        vc?.present(base, animated: true, completion: block)
        return self
    }
    
    @discardableResult
    func hidden(_ time:TimeInterval, block:(()->Void)? = nil) -> TFY {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak base] in
            base?.dismiss(animated: true, completion: block)
        }
        return self
    }
    
    @discardableResult
    func title(_ a:String) -> TFY {
        base.title = a
        return self
    }
    @discardableResult
    func title(_ font:UIFont) -> TFY {
        let attributed:NSAttributedString = base.value(forKey: "attributedTitle") as? NSAttributedString ?? NSMutableAttributedString(string: base.title ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedTitle")
        return self
    }
    @discardableResult
    func title(_ color:UIColor) -> TFY {
        let attributed:NSAttributedString = base.value(forKey: "attributedTitle") as? NSAttributedString ?? NSMutableAttributedString(string: base.title ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedTitle")
        return self
    }
    @discardableResult
    func title(_ attributed:NSAttributedString) -> TFY {
        base.setValue(attributed, forKey: "attributedTitle")
        return self
    }
    @discardableResult
    func message(_ a:String) -> TFY {
        base.message = a
        return self
    }
    @discardableResult
    func message(_ font:UIFont) -> TFY {
        let attributed:NSAttributedString = base.value(forKey: "attributedMessage") as? NSAttributedString ?? NSMutableAttributedString(string: base.message ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedMessage")
        return self
    }
    @discardableResult
    func message(_ color:UIColor) -> TFY {
        let attributed:NSAttributedString = base.value(forKey: "attributedMessage") as? NSAttributedString ?? NSMutableAttributedString(string: base.message ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedMessage")
        return self
    }
    @discardableResult
    func message(_ attributed:NSAttributedString) -> TFY {
        base.setValue(attributed, forKey: "attributedMessage")
        return self
    }
    
    @discardableResult
    func action(_ title:String = "",
                style:UIAlertAction.Style = .default,
                custom:((UIAlertAction) -> Void)? = nil,
                handler:((UIAlertAction) -> Void)? = nil) -> TFY {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        custom?(action)
        base.addAction(action)
        return self
    }
}

public extension TFY where Base: UIAlertAction {
    @discardableResult
    func title(_ a:String) -> TFY {
        base.setValue(a, forKey: "title")
        return self
    }
    @discardableResult
    func title(_ color:UIColor) -> TFY {
        base.setValue(color, forKey: "titleTextColor")
        return self
    }
    @discardableResult
    func style(_ a:UIAlertAction.Style) -> TFY {
        base.setValue(a, forKey: "style")
        return self
    }
    @discardableResult
    func handler(_ a:((UIAlertAction) -> Void)? = nil) -> TFY {
        base.setValue(a, forKey: "handler")
        return self
    }
}


