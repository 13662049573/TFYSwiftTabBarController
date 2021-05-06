//
//  TFYSwiftTabBarView.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit
import SnapKit

// MARK:- 渐变层
public enum TabbarGradientDirection {
    /// 水平从左到右
    case horizontal
    ///  垂直从上到下
    case vertical
    /// 左上到右下
    case leftOblique
    /// 右上到左下
    case rightOblique
    /// 请他情况
    case other(CGPoint, CGPoint)
    
    public func point() -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .rightOblique:
            return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
        case .other(let stat, let end):
            return (stat, end)
        }
    }
}

public class TFYSwiftTabBarView: UIView {

    /// item的contentView
    private var contentView: UIView = UIView()
    /// 这条横线是为了 遮挡系统底部的横线
    private var topLine: UIView = UIView()
    /// tabbar 背景色 图片
    private var blurImageView: UIImageView = UIImageView()
    /// tabbar 渐变色背景色 view
    private lazy var gradientView: TabBarGradientView = {
        return TabBarGradientView()
    }()
    /// 保存首页的 item
    public var tabBarItem: TFYSwiftTabBarItem?
    /// 是否要回到顶部
    var isScrollTop: Bool = false
    /// 上次选中的位置
    private var oldIndex: Int = 0
    
    // MARK: 设置底部的 tabbar 按钮
    /// 设置底部的 tabbar 按钮
    public var barButtonItems: [TFYSwiftTabBarItem] = [] {
        didSet {
            for item in oldValue {
                item.removeFromSuperview()
            }
            var lastItem: UIView? = nil
            for (index, item) in barButtonItems.enumerated() {
                contentView.addSubview(item)
                item.snp.makeConstraints({ (make) in
                    if let lastItem = lastItem {
                        make.left.equalTo(lastItem.snp.right)
                        make.width.equalTo(lastItem)
                    } else {
                        make.left.equalTo(contentView)
                    }
                    make.top.bottom.equalTo(contentView)
                })
                if index == self.oldSelectedIndex {
                    item.selected = true
                }
                lastItem = item
            }
            if let lastItem = lastItem {
                lastItem.snp.makeConstraints({ (make) in
                    make.right.equalTo(contentView.snp.right)
                })
            }
        }
    }
    
    // MARK: 选中的item (上次选中的item)
    /// 选中的 item (上次选中的item)
    @objc dynamic var selectedIndex: Int = 0 {
        didSet {
            if oldSelectedIndex >= barButtonItems.count && selectedIndex >= barButtonItems.count {
                return
            }
            if selectedIndex == oldSelectedIndex {
                return
            }
            let oldItem = barButtonItems[oldSelectedIndex]
            oldItem.selected = false
            let newItem = barButtonItems[selectedIndex]
            newItem.selected = true
            oldSelectedIndex = selectedIndex
        }
    }
    
    // MARK: 上次选中的item
    /// 选中的 item (上次选中的item)
    @objc dynamic var oldSelectedIndex: Int = 0
    
    // MARK: - LifeCycle
    init() {
        super.init(frame: CGRect.zero)

        addSubview(gradientView)
        addSubview(blurImageView)
        addSubview(contentView)
        addSubview(topLine)
        
        gradientView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        blurImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(-1)
            make.height.equalTo(1)
        }
        updateTheme()
    }
    
    private func updateTheme() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        topLine.backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TFYSwiftTabBarView {
    /// 设置默认的颜色背景
    func restDefaultBGColor() {
        blurImageView.image = tabbar_color(UIColor.white)
        gradientView.isHidden = true
        blurImageView.isHidden = false
    }
    
    // MARK: 获取一个纯色的图片
    /// 获取一个纯色的图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    /// - Returns: 返回纯色图片
    func tabbar_color(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        
        let scale = UIScreen.main.scale
        let fillRect = CGRect(x: 0, y: 0, width: size.width / scale, height: size.height / scale)
        UIGraphicsBeginImageContextWithOptions(fillRect.size, false, scale)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color.cgColor)
        graphicsContext?.fill(fillRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

extension TFYSwiftTabBarView {
    // MARK: 设置选中按钮图片
    /// 设置选中按钮图片
    /// - Parameters:
    ///   - imageString: 图片名称
    ///   - index: 位置
    ///   - animated: 是否要动画
    func setUpbarItemImage(_ imageString: String, index: Int, animated: Bool = true) {
        if barButtonItems.count <= index { return }
        let barItem = barButtonItems[index]
        barItem.isShowAnimated = animated
        barItem.newChangeImage(imageString: imageString)
    }
    
    // MARK: 改变选中的标题
    /// 改变选中的标题
    /// - Parameters:
    ///   - titleString: 标题名字
    ///   - index: 位置
    ///   - animated: 是否要动画
    func setUpbarItemTitle(_ titleString: String, index: Int, animated: Bool = true) {
        if barButtonItems.count <= index { return }
        let barItem = barButtonItems[index]
        barItem.isShowAnimated = animated
        barItem.newChangeTitle(titleString: titleString)
    }
    
    // MARK: 设置提醒数，位置
    ///  设置提醒数，位置
    /// - Parameters:
    ///   - number: 数字
    ///   - index: 位置
    func showBadgeNumber(_ number: Int?, index: Int) {
        if barButtonItems.count <= index { return }
        let item = barButtonItems[index]
        item.badgeNumber = number
    }
    
    // MARK: 设置小红点
    /// 设置小红点
    /// - Parameters:
    ///   - index: 位置
    ///   - isShow: 是否显示
    func setRedPoint(at index: Int, isShow: Bool) {
        if barButtonItems.count <= index { return }
        let item = barButtonItems[index]
        item.showRedPointView = isShow
    }
    
    // MARK: 更换背景颜色/图片
    /// 更换背景颜色/图片
    /// - Parameter image: 背景图片(可以是纯颜色的背景图)
    public func setBackgroundImage(image: UIImage) {
        blurImageView.image = image
        gradientView.isHidden = true
        blurImageView.isHidden = false
    }
    
    // MARK: 设置tabbar底部渐变色
    /// 设置tabbar底部渐变色
    /// - Parameters:
    ///   - beginColor: 开始的颜色
    ///   - endColor: 结束的颜色
    public func setBackgroundColors(direction: TabbarGradientDirection = .horizontal, gradientColors: [Any], _ gradientLocations: [NSNumber]? = nil) {
        gradientView.resetColor(direction, gradientColors, gradientLocations)
        gradientView.isHidden = false
        blurImageView.isHidden = true
    }
    
    /// 改变底部首页的内容
    /// - Parameters:
    ///   - value: 1 显示小火箭 ，其他值显示异行图
    ///   - topImage: 小火箭的图片
    ///   - homeSelectImage: 正常选中的图片
    public func changeHomeTabbarIcon(value: String?, topImage: String = "new_tabbar_home_rocket", homeSelectImage: String = "new_tabbar_home_selected") {
        guard value != nil else {
            return
        }
        guard let _ = tabBarItem else {
            return
        }
    }
    
    /// 点击tabar的反应
    /// - Parameters:
    ///   - index: 点击的第几个
    ///   - topImage: 小火箭的图片
    ///   - homeSelectImage: 正常选中的图片
    public func clickOtherTabbarIcon(index: Int?, topImage: String = "new_tabbar_home_rocket", homeSelectImage: String = "new_tabbar_home_selected") {
        
        guard let index = index else {
            return
        }
        if oldIndex > 0 && index > 0 { return }
        // 如果上次和这次点击的一样就返回
        if oldIndex == index { return }
        // 记录上次点击的位置
        oldIndex = index
    }
}

fileprivate class TabBarGradientView: UIView {
    
    override class var layerClass: Swift.AnyClass { return CAGradientLayer.self }
    
    // MARK: - LiefCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        changeTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let gradient = layer as! CAGradientLayer
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    }
    
    private func changeTheme() {
        let gradient = layer as! CAGradientLayer
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
    }
    
    // MARK: 设置底部tabbarView渐变
    /// 设置渐变层
    /// - Parameters:
    ///   - direction: 渐变方向
    ///   - gradientColors: 渐变的颜色数组（颜色的数组）
    ///   - gradientLocations: 设置渐变颜色的终止位置，这些值必须是递增的，数组的长度和 colors 的长度最好一致
    func resetColor(_ direction: TabbarGradientDirection = .horizontal, _ gradientColors: [Any], _ gradientLocations: [NSNumber]? = nil) {
        let gradient = layer as! CAGradientLayer
        gradient.colors = gradientColors
        // 设置渐变颜色的终止位置，这些值必须是递增的，数组的长度和 colors 的长度最好一致
        gradient.locations = gradientLocations
        // 设置渲染的起始结束位置（渐变方向设置）
        gradient.startPoint = direction.point().0
        gradient.endPoint = direction.point().1
    }
}

