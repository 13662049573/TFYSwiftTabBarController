//
//  TFYSwiftTabBarItemContainer.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2022/5/4.
//

import UIKit

// MARK: - TFYSwiftTabBarItemContainer
/// TabBarItem的容器视图
internal class TFYSwiftTabBarItemContainer: UIControl {
    
    // MARK: - Initialization
    
    internal init(_ target: AnyObject?, tag: Int) {
        super.init(frame: CGRect.zero)
        self.tag = tag
        setupTargetActions(target: target)
        setupView()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Methods
    
    private func setupTargetActions(target: AnyObject?) {
        self.addTarget(target, action: #selector(TFYSwiftTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(TFYSwiftTabBar.highlightAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(TFYSwiftTabBar.highlightAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(TFYSwiftTabBar.dehighlightAction(_:)), for: .touchDragExit)
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.isAccessibilityElement = true
    }
    
    // MARK: - Override Methods
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentView()
    }
    
    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subview in self.subviews {
                let subviewPoint = CGPoint(x: point.x - subview.frame.origin.x,
                                          y: point.y - subview.frame.origin.y)
                if subview.point(inside: subviewPoint, with: event) {
                    b = true
                    break
                }
            }
        }
        return b
    }
    
    // MARK: - Private Methods
    
    private func layoutContentView() {
        for subview in self.subviews {
            if let subview = subview as? TFYSwiftTabBarItemContentView {
                subview.frame = CGRect(x: subview.insets.left,
                                      y: subview.insets.top,
                                      width: bounds.size.width - subview.insets.left - subview.insets.right,
                                      height: bounds.size.height - subview.insets.top - subview.insets.bottom)
                subview.updateLayout()
            }
        }
    }
}
