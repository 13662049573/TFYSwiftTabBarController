//
//  TFYSwiftTabBarBadgeView.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/18.
//

import UIKit

// MARK: - TFYSwiftTabBarBadgeView
/*
 * TFYSwiftTabBarItemBadgeView
 * 这个类定义了item中使用的badge视图样式，默认为TFYSwiftTabBarItemBadgeView类对象。
 * 你可以设置TFYSwiftTabBarItemContentView的badgeView属性为自定义的TFYSwiftTabBarItemBadgeView子类，这样就可以轻松实现 自定义通知样式了。
 */
open class TFYSwiftTabBarBadgeView: UIView {
    
    // MARK: - Static Properties
    
    /// 默认颜色
    public static var defaultBadgeColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    
    // MARK: - Properties
    
    /// 徽章的颜色
    open var badgeColor: UIColor? = defaultBadgeColor {
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }
    
    /// 徽章值，支持nil，""，"1"，"someText"。隐藏在零。显示小点样式时""
    open var badgeValue: String? {
        didSet {
            badgeLabel.text = badgeValue
        }
    }
    
    /// 图像视图
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    /// 显示badgeValue的Label
    open lazy var badgeLabel: UILabel = {
        let badgeLabel = UILabel(frame: CGRect.zero)
        badgeLabel.backgroundColor = .clear
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 13.0)
        badgeLabel.textAlignment = .center
        return badgeLabel
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        self.addSubview(imageView)
        self.addSubview(badgeLabel)
        self.imageView.backgroundColor = badgeColor
    }
    
    // MARK: - Override Methods
    
    /*
     *  通过layoutSubviews()布局子视图，你可以通过重写此方法实现自定义布局。
     **/
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutBadgeView()
    }
    
    /*
     *  通过此方法计算badge视图需要占用父视图的frame大小，通过重写此方法可以自定义badge视图的大小。
     *  如果你需要自定义badge视图在Content中的位置，可以设置Content的badgeOffset属性。
     */
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let _ = badgeValue else {
            return CGSize(width: 18.0, height: 18.0)
        }
        let textSize = badgeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(18.0, textSize.width + 10.0), height: 18.0)
    }
    
    // MARK: - Private Methods
    
    private func layoutBadgeView() {
        guard let badgeValue = badgeValue else {
            imageView.isHidden = true
            badgeLabel.isHidden = true
            return
        }
        
        imageView.isHidden = false
        badgeLabel.isHidden = false
        
        if badgeValue == "" {
            imageView.frame = CGRect(origin: CGPoint(x: (bounds.size.width - 8.0) / 2.0,
                                                     y: (bounds.size.height - 8.0) / 2.0),
                                    size: CGSize(width: 8.0, height: 8.0))
        } else {
            imageView.frame = bounds
        }
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0
        badgeLabel.sizeToFit()
        badgeLabel.center = imageView.center
    }
}
