//
//  TFYSwiftTabBarItem.swift
//  TFYSwiftTabBarController
//
//  全新的现代化TabBarItem实现
//  支持iOS 15+，适配iOS 26特性
//

import UIKit

// MARK: - 自定义TabBarItem
@available(iOS 15.0, *)
open class TFYSwiftTabBarItem: UITabBarItem {
    
    // MARK: - 公开属性
    
    /// 自定义内容视图
    public let contentView: TFYSwiftTabBarItemContentView
    
    /// 是否启用动画
    public var enableAnimation: Bool = true
    
    /// 动画持续时间
    public var animationDuration: TimeInterval = 0.25
    
    /// 动画类型
    public var animationType: TFYSwiftTabBarItemAnimationType = .scale
    
    // MARK: - 初始化
    
    public init(contentView: TFYSwiftTabBarItemContentView, title: String?, image: UIImage?, selectedImage: UIImage? = nil) {
        self.contentView = contentView
        super.init()
        
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        
        setupContentView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置方法
    
    private func setupContentView() {
        contentView.titleLabel.text = title
        contentView.imageView.image = image
        contentView.highlightImage = selectedImage
    }
    
    // MARK: - 动画方法
    
    public func select(animated: Bool, completion: (() -> Void)? = nil) {
        if animated && enableAnimation {
            contentView.selectAnimation(animated: true, completion: completion)
        } else {
            contentView.selectAnimation(animated: false, completion: completion)
        }
    }
    
    public func deselect(animated: Bool, completion: (() -> Void)? = nil) {
        if animated && enableAnimation {
            contentView.deselectAnimation(animated: true, completion: completion)
        } else {
            contentView.deselectAnimation(animated: false, completion: completion)
        }
    }
}

// MARK: - 动画类型枚举
@available(iOS 15.0, *)
public enum TFYSwiftTabBarItemAnimationType {
    case scale
    case bounce
    case fade
    case slide
    case rotation
    case custom((TFYSwiftTabBarItemContentView) -> Void)
}
