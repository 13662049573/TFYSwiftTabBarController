//
//  TFYSwiftTabBarItemWrapView.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/18.
//

import UIKit

private let _clearColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

internal class TFYSwiftTabBarItemWrapView: UIControl {

    @available(iOS, unavailable)
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    init(target: AnyObject?) {
        super.init(frame: .zero)
        self.backgroundColor = _clearColor
        self.addTarget(target, action: #selector(TFYSwiftTabBar.selectAction(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for subView in subviews {
            if let subView = subView as? TFYSwiftTabBarItemContainerView {
                let inset = subView.insets
                // 设置frame，将触发`TFYSwiftTabBarItemContainerView`的`layoutSubviews`方法
                subView.frame = CGRect(x: inset.left,
                                       y: inset.top,
                                       width: bounds.size.width - inset.left - inset.right,
                                       height: bounds.size.height - inset.top - inset.bottom)
            }
        }
    }
    
    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subView in subviews {
                if subView.point(inside: CGPoint(x: point.x - subView.frame.origin.x, y: point.y - subView.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }

}
