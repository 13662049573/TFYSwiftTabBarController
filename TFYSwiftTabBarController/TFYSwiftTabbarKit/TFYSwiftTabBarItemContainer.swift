//
//  TFYSwiftTabBarItemContainer.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2022/5/4.
//

import UIKit

internal class TFYSwiftTabBarItemContainer: UIControl {

    internal init(_ target: AnyObject?, tag: Int) {
        super.init(frame: CGRect.zero)
        self.tag = tag
        self.addTarget(target, action: #selector(TFYSwiftTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(TFYSwiftTabBar.highlightAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(TFYSwiftTabBar.highlightAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(TFYSwiftTabBar.dehighlightAction(_:)), for: .touchDragExit)
        self.backgroundColor = .clear
        self.isAccessibilityElement = true
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        for subview in self.subviews {
            if let subview = subview as? TFYSwiftTabBarItemContentView {
                subview.frame = CGRect.init(x: subview.insets.left, y: subview.insets.top, width: bounds.size.width - subview.insets.left - subview.insets.right, height: bounds.size.height - subview.insets.top - subview.insets.bottom)
                subview.updateLayout()
            }
        }
    }

    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subview in self.subviews {
                if subview.point(inside: CGPoint.init(x: point.x - subview.frame.origin.x, y: point.y - subview.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }

}
