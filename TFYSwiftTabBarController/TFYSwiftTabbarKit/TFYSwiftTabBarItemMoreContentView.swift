//
//  TFYSwiftTabBarItemMoreContentView.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2022/5/4.
//

import UIKit

// MARK: - TFYSwiftTabBarItemMoreContentView
/// More按钮的内容视图
open class TFYSwiftTabBarItemMoreContentView: TFYSwiftTabBarItemContentView {
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupMoreContentView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupMoreContentView() {
        self.tabbarTitle = NSLocalizedString("More_TabBarItem", bundle: Bundle(for: TFYSwiftTabbarController.self), comment: "")
        self.image = systemMore(highlighted: false)
        self.selectedImage = systemMore(highlighted: true)
    }
    
    // MARK: - Public Methods
    
    /// 生成系统More按钮图标
    public func systemMore(highlighted isHighlighted: Bool) -> UIImage? {
        let image = UIImage()
        let circleDiameter = isHighlighted ? 5.0 : 4.0
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 32, height: 32), false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.setLineWidth(1.0)
        
        for index in 0...2 {
            let tmpRect = CGRect(x: 5.0 + 9.0 * Double(index),
                                y: 14.0,
                                width: circleDiameter,
                                height: circleDiameter)
            context.addEllipse(in: tmpRect)
            image.draw(in: tmpRect)
        }
        
        if isHighlighted {
            context.setFillColor(UIColor.blue.cgColor)
            context.fillPath()
        } else {
            context.strokePath()
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
