//
//  TFYSwiftTabBarItem.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit
import SnapKit

public enum TabbarType {
    /// 单张图片
    case singleImage
    /// 多张图片
    case gifImage
}

public enum TabbarItemType {
    /// 单张图片
    case local
    /// 多张图片
    case network
}

public class TFYSwiftTabBarItem: UIView {
    /// 沙盒的资源路径
    var sourceFliePath: String = ""
    /// item 类型
    var itemType: TabbarItemType = .local
    /// 角标数量
    public var badgeNumber: Int? {
        didSet {
            showBadgeNumber(badgeNumber)
        }
    }
    /// 是否显示小红点
    public var showRedPointView: Bool = false {
        didSet {
            redPointView.isHidden = !showRedPointView
        }
    }
    /// 选中状态
    public var selected: Bool = false {
        didSet {
            if isAnimated {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopAnimated), object: nil)
                stopAnimated()
            }
            let status = selected ? UIControl.State.selected : UIControl.State.normal
            iconImageView.image = savebutton.image(for: status)
            bottomTitle.textColor = savebutton.titleColor(for: status)
            if selected, !oldValue {
                showAnimated()
            }
        }
    }
    /// 角标
    private var badgeLabel: UILabel!
    /// 小红点
    private var redPointView: UIView!
    /// 每个Item的button
    private(set) var savebutton: UIButton = UIButton(type: .custom)
    /// 显示图标的UIImangeView
    private var iconImageView: UIImageView!
    /// 图片
    private var imageName: String
    /// 图片的数量
    private var imageCount: Int = 25
    /// 动画view
    private let animatedImageView: UIImageView = UIImageView()
    /// 底部的标题
    internal var bottomTitle: UILabel!
    /// 标题
    public var title: String
    /// 默认的颜色
    private var titleNormalColor: UIColor
    /// 选中的的颜色
    private var titleSelectedColor: UIColor
    /// Tbabar的类型：默认单张图片
    private var tabbarType: TabbarType = .singleImage
    /// gif 类型动画的时长
    private var animationDuration: TimeInterval = 0
    /// 是否要展示动画
    public var isShowAnimated: Bool = true
    /// 动画图片
    public var animatedImages: [UIImage] = []
    private var isAnimated: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 本地的Tbabar配置
    private init(type: TabbarType,duration: TimeInterval,localImageCount: Int, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.itemType = .local
        self.tabbarType = type
        self.imageName = defaultImageName
        self.title = title
        self.titleNormalColor = titleColor
        self.titleSelectedColor = selectedTitleColor
        self.animationDuration = duration
        super.init(frame: CGRect.zero)
        initUI()
        commonInit()
        updateTheme()
        
        bottomTitle.text = title
        savebutton.setTitleColor(titleColor, for: .normal)
        savebutton.setTitleColor(selectedTitleColor, for: .selected)
        
        // gif 动画才往下面走
        guard type == .gifImage else {
            return
        }
        
        imageCount = localImageCount
        animatedImages.reserveCapacity(imageCount)
        for i in 0..<imageCount {
            if let image = UIImage(named: (imageName + "_selected\(i)")) {
                animatedImages.append(image)
            }
        }
        animatedImageView.animationDuration = duration
    }
    
    // MARK: 网络下载的Tbabar配置
    private init(type: TabbarType, fliePath: String, netWorkImageCount: Int, duration: TimeInterval, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.sourceFliePath = fliePath
        self.itemType = .network
        self.imageName = defaultImageName
        self.title = title
        self.titleNormalColor = titleColor
        self.titleSelectedColor = selectedTitleColor
        self.animationDuration = duration
        super.init(frame: CGRect.zero)
        initUI()
        bottomTitle.text = title
        commonInit()
        
        redPointView.backgroundColor = UIColor.red
        badgeLabel.textColor = UIColor.white
        badgeLabel.backgroundColor =  UIColor.red
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        
        savebutton.setTitleColor(titleColor, for: .normal)
        savebutton.setTitleColor(selectedTitleColor, for: .selected)
        
        let normalImageFilePath = "\(fliePath)/\(defaultImageName).png"
        let selectedImageFilePath = "\(fliePath)/\(defaultImageName)_selected.png"
        
        if type == .gifImage, netWorkImageCount >= 2 {
            imageCount = netWorkImageCount
            animatedImages.reserveCapacity(netWorkImageCount)
            for i in 1...netWorkImageCount {
                let imageFilePath = "\(fliePath)/\(defaultImageName)_selected\(i).png"
                if let image = UIImage(contentsOfFile:imageFilePath) {
                    animatedImages.append(image)
                }
            }
        
            savebutton.setImage(UIImage(contentsOfFile:normalImageFilePath), for: .normal)
            savebutton.setImage(UIImage(contentsOfFile:selectedImageFilePath), for: .selected)
            
            animatedImageView.animationDuration = duration
        } else {
            imageCount = netWorkImageCount
            savebutton.setImage(UIImage(contentsOfFile:normalImageFilePath), for: .normal)
            savebutton.setImage(UIImage(contentsOfFile:selectedImageFilePath), for: .selected)
        }
        resetSelectedStatus()
    }
    
    // MARK: 展示动画
    private func showAnimated() {
        guard isShowAnimated, !isAnimated, !animatedImages.isEmpty else { return }
        iconImageView.isHidden = true
        animatedImageView.isHidden = false
        animatedImageView.animationImages = animatedImages
        animatedImageView.startAnimating()
        perform(#selector(stopAnimated), with: nil, afterDelay: self.animationDuration, inModes: [RunLoop.Mode.common])
    }

    // MARK: 停止动画
    @objc private func stopAnimated() {
        animatedImageView.stopAnimating()
        isAnimated = false
        animatedImageView.isHidden = true
        iconImageView.isHidden = false
    }
}

extension TFYSwiftTabBarItem {
    // MARK: 本地gif动画的Tabbar
    /// 本地gif动画的Tabbar
    /// - Parameters:
    ///   - localImageCount: 图片数量
    ///   - duration: 动画的时长
    ///   - title: 标题
    ///   - titleColor: 未选中的字体颜色
    ///   - selectedTitleColor: 选中的字体颜色
    ///   - defaultImageName: 默认的额图片
    public convenience init(localImageCount: Int, duration: TimeInterval, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .gifImage, duration: duration, localImageCount: localImageCount, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName : defaultImageName)
    }
    
    // MARK: 本地普通的Tabbar
    /// 本地普通的Tabbar
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 未选中的字体颜色
    ///   - selectedTitleColor: 选中的字体颜色
    ///   - defaultImageName: 默认的额图片
    public convenience init(title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .singleImage, duration: 0, localImageCount: 0, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName: defaultImageName)
    }
    
    // MARK: 网络gif动画的Tabbar
    /// 网络gif动画的Tabbar
    /// - Parameters:
    ///   - fliePath: 沙盒路径
    ///   - netWorkImageCount: 图片的数量
    ///   - duration: 动画的时长
    ///   - title: 标题
    ///   - titleColor: 普通的颜色
    ///   - selectedTitleColor: 选中的颜色
    ///   - defaultImageName: 默认的图片
    public convenience init(fliePath: String, netWorkImageCount: Int, duration: TimeInterval, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .gifImage, fliePath: fliePath, netWorkImageCount: netWorkImageCount, duration: duration, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName: defaultImageName)
    }
    
    // MARK: 网络普通的Tabbar
    /// 网络普通的Tabbar
    /// - Parameters:
    ///   - fliePath: 沙盒路径
    ///   - title: 标题
    ///   - titleColor: 普通的颜色
    ///   - selectedTitleColor: 选中的颜色
    ///   - defaultImageName: 默认的图片
    public convenience init(fliePath: String, title: String, titleColor: UIColor, selectedTitleColor: UIColor, defaultImageName: String) {
        self.init(type: .singleImage, fliePath: fliePath, netWorkImageCount: 0, duration: 0, title: title, titleColor: titleColor, selectedTitleColor: selectedTitleColor, defaultImageName: defaultImageName)
    }
}


extension TFYSwiftTabBarItem {
    /// 创建对应的控件
    private func initUI() {
        badgeLabel = UILabel(frame: CGRect.zero)
        badgeLabel.font = UIFont.systemFont(ofSize: 10)
        // badgeLabel.textInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
        badgeLabel.textAlignment = .center
        badgeLabel.isHidden = true
        badgeLabel.isUserInteractionEnabled = false
        badgeLabel.clipsToBounds = true
        badgeLabel.layer.cornerRadius = 15 / 2

        redPointView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        redPointView.layer.masksToBounds = true
        redPointView.layer.cornerRadius = 3
        redPointView.isHidden = true

        iconImageView = UIImageView()
        iconImageView.isUserInteractionEnabled = true

        animatedImageView.animationDuration = 1.0
        animatedImageView.animationRepeatCount = 1
        animatedImageView.isHidden = true

        bottomTitle = UILabel()
        bottomTitle.font = UIFont.systemFont(ofSize: 10)
        bottomTitle.textAlignment = .center
    }

    // MARK: 布局控件
    /// 布局控件
    private func commonInit() {
        badgeNumber = nil
        isExclusiveTouch = true
        backgroundColor = UIColor.clear
        addSubview(redPointView)
        addSubview(iconImageView)
        addSubview(animatedImageView)
        addSubview(bottomTitle)
        addSubview(badgeLabel)

        badgeLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        badgeLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        badgeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.width.greaterThanOrEqualTo(15)
            make.left.equalTo(iconImageView.snp.right).offset(-8)
            make.top.equalTo(self).offset(4)
        }
        redPointView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp.right)
            make.centerY.equalTo(iconImageView.snp.top)
            make.width.height.equalTo(6)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(6.5)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        animatedImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(iconImageView)
        }
        bottomTitle.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(3)
            make.centerX.equalTo(self)
        }
    }
    
    // MARK: 更新控件属性
    /// 更新控件属性
    private func updateTheme() {
        redPointView.backgroundColor = UIColor.red
        badgeLabel.textColor = UIColor.white
        badgeLabel.backgroundColor =  UIColor.red
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        setButtonDefaultStyle()
        resetSelectedStatus()
    }
    
    private func setButtonDefaultStyle() {
        savebutton.setTitleColor(self.titleNormalColor, for: .normal)
        savebutton.setTitleColor(self.titleSelectedColor, for: .selected)
        // 未选中图片没有黑夜效果
        if itemType == .local {
            savebutton.setImage(UIImage(named: imageName), for: .normal)
            savebutton.setImage(UIImage(named: "\(imageName)_selected"), for: .selected)
        } else {
            let normalImageFilePath = "\(self.sourceFliePath)/\(imageName).png"
            let selectedImageFilePath = "\(self.sourceFliePath)/\(imageName)_selected.png"
            savebutton.setImage(UIImage(contentsOfFile:normalImageFilePath), for: .normal)
            savebutton.setImage(UIImage(contentsOfFile:selectedImageFilePath), for: .selected)
        }
    }
    
    private func resetSelectedStatus() {
        let temp = selected
        selected = temp
    }
}


extension TFYSwiftTabBarItem {
    // MARK: 设置被选中按钮的图片
    /// 设置被选中按钮的图片
    /// - Parameter imageString: 图片的名字
    func newChangeImage(imageString: String) {
        imageName = imageString
        setButtonDefaultStyle()
        let status = selected ? UIControl.State.selected : UIControl.State.normal
        iconImageView.image = savebutton.image(for: status)
        bottomTitle.textColor = savebutton.titleColor(for: status)
    }
    
    // MARK: 改变底部的标题
    /// 改变底部的标题
    /// - Parameter titleString: 新的标题名字
    func newChangeTitle(titleString: String) {
        title = titleString
        setButtonDefaultStyle()
        let status = selected ? UIControl.State.selected : UIControl.State.normal
        bottomTitle.textColor = savebutton.titleColor(for: status)
        bottomTitle.text = titleString
    }
    
    // MARK: 设置角标
    /// 设置角标
    /// - Parameter number: 角标的数字
    func showBadgeNumber(_ number: Int?) {
        if let number = number {
            switch number {
            case 0:
                badgeLabel.isHidden = true
            default:
                badgeLabel.isHidden = false
            }
            let text = number <= 999 ? "\(number)" : "999+"
            badgeLabel.text = text
        } else {
            badgeLabel.isHidden = true
        }
    }
}


// MARK:- 自定义 tabbar
/// 自定义 tabbar
public class TFYSwiftTabBar: UITabBar {
    override public var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var temp = newValue
            if let superview = self.superview, temp.maxY != superview.frame.height {
                temp.origin.y = superview.frame.height - temp.height
            }
            super.frame = temp
        }
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            let bottomInset = safeAreaInsets.bottom
            if bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90) {
                size.height += bottomInset
            }
        }
        return size
    }
}
