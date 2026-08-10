//
//  UIButton+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  用途：UIButton 链式编程扩展，支持图片文字布局、活动指示器、倒计时等功能。
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

/// 按钮图片方向枚举
public enum ButtonImageDirection: Int {
    // 基础模式（内容整体居中）
    case centerImageTop = 1     // 图片在上，文字在下，内容居中
    case centerImageLeft = 2    // 图片在左，文字在右，内容居中
    case centerImageRight = 3   // 图片在右，文字在左，内容居中
    case centerImageBottom = 4  // 图片在下，文字在上，内容居中
    case leftImageLeft = 5      // 图片在左，文字在右，内容整体靠左
    case leftImageRight = 6     // 图片在右，文字在左，内容整体靠左
    case rightImageLeft = 7     // 图片在左，文字在右，内容整体靠右
    case rightImageRight = 8    // 图片在右，文字在左，内容整体靠右

    // 固定间距模式（显式设置 imagePadding 固定图文间距）
    case centerImageTopFixedSpace = 9     // 图片在上，文字在下，内容居中，固定间距
    case centerImageLeftFixedSpace = 10   // 图片在左，文字在右，内容居中，固定间距
    case centerImageRightFixedSpace = 11  // 图片在右，文字在左，内容居中，固定间距
    case centerImageBottomFixedSpace = 12 // 图片在下，文字在上，内容居中，固定间距

    // 顶部/底部对齐模式（水平居中，标题按 leading/trailing 对齐）
    case topImageTop = 13       // 图片在上，文字在下，标题左对齐
    case topImageBottom = 14    // 图片在下，文字在上，标题左对齐
    case bottomImageTop = 15    // 图片在上，文字在下，标题右对齐
    case bottomImageBottom = 16 // 图片在下，文字在上，标题右对齐

    // 文字换行模式
    case centerImageTopTextBelow = 17 // 图片在上，文字在下，文字换行
    case centerImageLeftTextRight = 18 // 图片在左，文字在右，文字换行
    case centerImageRightTextLeft = 19 // 图片在右，文字在左，文字换行
    case centerImageBottomTextAbove = 20 // 图片在下，文字在上，文字换行

    // 更多新增模式
    case imageOnly = 21 // 仅显示图片
    case textOnly = 22 // 仅显示文字
    case imageTopTextBelowFixedHeight = 23 // 图片在上，文字在下，固定高度
    case imageLeftTextRightFixedWidth = 24 // 图片在左，文字在右，固定宽度
    case imageRightTextLeftFixedWidth = 25 // 图片在右，文字在左，固定宽度
    case imageBottomTextAboveFixedHeight = 26 // 图片在下，文字在上，固定高度

    // 文字压缩不换行模式（单行显示，宽度不足时自动缩小字号，最多缩至 50%）
    case imageTopTextCompress = 27    // 图片在上，文字在下，文字压缩不换行
    case imageLeftTextCompress = 28   // 图片在左，文字在右，文字压缩不换行
    case imageRightTextCompress = 29  // 图片在右，文字在左，文字压缩不换行
    case imageBottomTextCompress = 30 // 图片在下，文字在上，文字压缩不换行

    /// 是否为「文字压缩不换行」模式（需在设置 configuration 之后再刷新 titleLabel 才能生效）
    var isCompressTitle: Bool {
        switch self {
        case .imageTopTextCompress, .imageLeftTextCompress, .imageRightTextCompress, .imageBottomTextCompress:
            return true
        default:
            return false
        }
    }
}

/// 按钮链式编程扩展
public extension TFY where Base: UIButton {
    
    /// 设置按钮标题
    @discardableResult
    func title(_ title: String?, for state: UIControl.State...) -> Self {
        guard !state.isEmpty else { return self }
        state.forEach { base.setTitle(title, for: $0) }
        return self
    }
    
    /// 设置按钮标题颜色
    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State...) -> Self {
        guard !state.isEmpty else { return self }
        state.forEach { base.setTitleColor(color, for: $0) }
        return self
    }
    
    /// 设置按钮图片
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State...) -> Self {
        guard !state.isEmpty else { return self }
        state.forEach { base.setImage(image, for: $0) }
        return self
    }
    
    /// 设置按钮背景图片
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State...) -> Self {
        guard !state.isEmpty else { return self }
        state.forEach { base.setBackgroundImage(image, for: $0) }
        return self
    }
    
    /// 设置按钮富文本标题
    @discardableResult
    func attributedTitle(_ attributedTitle: NSAttributedString?, for state: UIControl.State...) -> Self {
        guard !state.isEmpty else { return self }
        state.forEach { base.setAttributedTitle(attributedTitle, for: $0) }
        return self
    }
    
    /// 设置标题内边距
    @discardableResult
    func titleEdgeInsets(_ edgeInsets: UIEdgeInsets) -> Self {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: max(0, edgeInsets.top),
                leading: max(0, edgeInsets.left),
                bottom: max(0, edgeInsets.bottom),
                trailing: max(0, edgeInsets.right)
            )
            configuration.titlePadding = max(0, edgeInsets.left)
            base.configuration = configuration
        } else {
            base.titleEdgeInsets = edgeInsets
        }
        return self
    }
    
    /// 设置标题内边距（分开设置）
    @discardableResult
    func titleEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: max(0, top),
                leading: max(0, left),
                bottom: max(0, bottom),
                trailing: max(0, right)
            )
            configuration.titlePadding = max(0, left)
            base.configuration = configuration
        } else {
            base.titleEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
        return self
    }
    
    /// 设置图片内边距
    @discardableResult
    func imageEdgeInsets(_ edgeInsets: UIEdgeInsets) -> Self {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: max(0, edgeInsets.top),
                leading: max(0, edgeInsets.left),
                bottom: max(0, edgeInsets.bottom),
                trailing: max(0, edgeInsets.right)
            )
            configuration.imagePadding = max(0, edgeInsets.left)
            base.configuration = configuration
        } else {
            base.imageEdgeInsets = edgeInsets
        }
        return self
    }
    
    /// 设置图片内边距（分开设置）
    @discardableResult
    func imageEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: max(0, top),
                leading: max(0, left),
                bottom: max(0, bottom),
                trailing: max(0, right)
            )
            configuration.imagePadding = max(0, left)
            base.configuration = configuration
        } else {
            base.imageEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
        return self
    }
    
    /// 设置内容水平对齐方式
    @discardableResult
    func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        base.contentHorizontalAlignment = alignment
        return self
    }
    
    /// 设置是否将自动调整大小掩码转换为约束
    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ transl: Bool) -> Self {
        base.translatesAutoresizingMaskIntoConstraints = transl
        return self
    }
    
    /// 设置标题是否自适应字体大小
    @discardableResult
    func adjustsFontSizeToFitWidth(_ fontbool: Bool) -> Self {
        base.titleLabel?.adjustsFontSizeToFitWidth = fontbool
        return self
    }
    
    /// 设置图片方向和间距
    @discardableResult
    func imageDirection(_ direction: ButtonImageDirection, _ space: CGFloat) -> Self {
        base.imageDirection(direction, max(0, space))
        return self
    }
    
    /// 设置不同状态下的背景色
    @discardableResult
    func backgroundStateColor(_ color: UIColor, for state: UIControl.State...) -> Self {
        guard !state.isEmpty else { return self }
        state.forEach { base.setBackgroundColor(color, for: $0) }
        return self
    }
}

extension UIButton {
    // MARK: - Public Methods

    /// 设置图片和文字的相对位置
    /// - Parameters:
    ///   - type: 图片位置类型
    ///   - space: 图片和文字之间的间距
    @available(iOS 15.0, *)
    public func imageDirection(_ type: ButtonImageDirection, _ space: CGFloat) {
        applyModernConfiguration(type: type, space: space, contentInsets: .zero, honorContentInsets: false)
    }
    
    func setContentEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        let preservedFont: UIFont = titleLabel?.font ?? .systemFont(ofSize: 14)
        let preservedNormalColor: UIColor = titleColor(for: .normal) ?? .black
        let preservedHighlightedColor: UIColor? = titleColor(for: .highlighted)
        let preservedSelectedColor: UIColor? = titleColor(for: .selected)
        let preservedDisabledColor: UIColor? = titleColor(for: .disabled)

        var config = self.configuration ?? UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: top,
            leading: left,
            bottom: bottom,
            trailing: right
        )

        if let title = title(for: .normal), !title.isEmpty {
            var container = AttributeContainer()
            container.font = preservedFont
            container.foregroundColor = preservedNormalColor
            config.attributedTitle = AttributedString(title, attributes: container)
        }

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = preservedFont
            outgoing.foregroundColor = preservedNormalColor
            return outgoing
        }

        self.configuration = config

        self.configurationUpdateHandler = { button in
            var updated = button.configuration
            let stateColor: UIColor = {
                switch button.state {
                case .highlighted: return preservedHighlightedColor ?? preservedNormalColor
                case .selected:    return preservedSelectedColor    ?? preservedNormalColor
                case .disabled:    return preservedDisabledColor    ?? preservedNormalColor
                default:           return preservedNormalColor
                }
            }()
            updated?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = preservedFont
                outgoing.foregroundColor = stateColor
                return outgoing
            }
            button.configuration = updated
        }
    }

    /// 设置图片和文字的相对位置（自定义内容边距）
    /// - Parameters:
    ///   - type: 图片位置类型
    ///   - space: 图片和文字之间的间距
    ///   - contentInsets: 自定义内容边距
    @available(iOS 15.0, *)
    public func imageDirectionCustomize(_ type: ButtonImageDirection, _ space: CGFloat, _ contentInsets: NSDirectionalEdgeInsets) {
        applyModernConfiguration(type: type, space: space, contentInsets: contentInsets, honorContentInsets: true)
    }

    // MARK: - Private Methods

    /// - Parameter honorContentInsets: 是否完全按传入的 contentInsets 生效。
    ///   为 true（自定义内边距）时，布局方法写入某条边的 `space` 会被最终覆盖，
    ///   图文间距改由 `imagePadding` 保证，避免 space 覆盖用户设置的左右/上下间距；
    ///   为 false（简单调用）时保持既有行为不变。
    @available(iOS 15.0, *)
    private func applyModernConfiguration(type: ButtonImageDirection, space: CGFloat, contentInsets: NSDirectionalEdgeInsets, honorContentInsets: Bool) {
        var configuration = createBaseConfiguration(space: space)

        // 配置布局
        configureLayout(for: type, space: space, contentInsets: contentInsets, in: &configuration)

        // 自定义内边距：图文间距由 imagePadding 承载，四边内边距完全按用户传入值生效
        if honorContentInsets {
            configuration.contentInsets = contentInsets
        }

        // 应用配置
        self.configuration = configuration

        // 「文字压缩不换行」的字号自适应：必须在设置 configuration 之后再配置 titleLabel，
        // 否则赋值 configuration 会重置系统托管的 titleLabel，导致 adjustsFontSizeToFitWidth 失效（表现为截断而非缩小）。
        let compressScaleFactor: CGFloat? = type.isCompressTitle ? 0.5 : nil

        // 设置配置更新处理器（compress 模式下每次配置刷新后重新应用字号自适应）
        setupConfigurationUpdateHandler(buttonFont: configuration.attributedTitle?.font ?? UIFont.systemFont(ofSize: 14),
                                        buttonColor: configuration.attributedTitle?.foregroundColor ?? .black,
                                        compressMinimumScaleFactor: compressScaleFactor)

        if let scaleFactor = compressScaleFactor {
            applyCompressSingleLine(minimumScaleFactor: scaleFactor)
        }
    }

    @available(iOS 15.0, *)
    private func createBaseConfiguration(space: CGFloat) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()

        // 保留现有背景图片
        if let backgroundImage = backgroundImage(for: .normal) {
            configuration.background.image = backgroundImage
        }

        // 配置基础属性
        configuration.imagePadding = space
        configuration.titleLineBreakMode = .byWordWrapping

        // 配置标题
        if let title = title(for: .normal) {
            let buttonFont = titleLabel?.font ?? UIFont.systemFont(ofSize: 14)
            let buttonColor = titleColor(for: .normal) ?? .black

            var attributeContainer = AttributeContainer()
            attributeContainer.font = buttonFont
            attributeContainer.foregroundColor = buttonColor
            configuration.attributedTitle = AttributedString(title, attributes: attributeContainer)
        }

        return configuration
    }

    @available(iOS 15.0, *)
    private func configureLayout(for type: ButtonImageDirection, space: CGFloat, contentInsets: NSDirectionalEdgeInsets, in configuration: inout UIButton.Configuration) {
        switch type {
        case .centerImageTop:
            configureCenterImageTop(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageLeft:
            configureCenterImageLeft(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageRight:
            configureCenterImageRight(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageBottom:
            configureCenterImageBottom(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .leftImageLeft:
            configureLeftImageLeft(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .leftImageRight:
            configureLeftImageRight(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .rightImageLeft:
            configureRightImageLeft(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .rightImageRight:
            configureRightImageRight(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageTopFixedSpace:
            configureCenterImageTopFixedSpace(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageLeftFixedSpace:
            configureCenterImageLeftFixedSpace(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageRightFixedSpace:
            configureCenterImageRightFixedSpace(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageBottomFixedSpace:
            configureCenterImageBottomFixedSpace(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .topImageTop:
            configureTopImageTop(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .topImageBottom:
            configureTopImageBottom(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .bottomImageTop:
            configureBottomImageTop(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .bottomImageBottom:
            configureBottomImageBottom(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageTopTextBelow:
            configureCenterImageTopTextBelow(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageLeftTextRight:
            configureCenterImageLeftTextRight(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageRightTextLeft:
            configureCenterImageRightTextLeft(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .centerImageBottomTextAbove:
            configureCenterImageBottomTextAbove(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageOnly:
            configureImageOnly(configuration: &configuration)

        case .textOnly:
            configureTextOnly(configuration: &configuration)

        case .imageTopTextBelowFixedHeight:
            configureImageTopTextBelowFixedHeight(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageLeftTextRightFixedWidth:
            configureImageLeftTextRightFixedWidth(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageRightTextLeftFixedWidth:
            configureImageRightTextLeftFixedWidth(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageBottomTextAboveFixedHeight:
            configureImageBottomTextAboveFixedHeight(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageTopTextCompress:
            configureImageTopTextCompress(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageLeftTextCompress:
            configureImageLeftTextCompress(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageRightTextCompress:
            configureImageRightTextCompress(configuration: &configuration, space: space, contentInsets: contentInsets)

        case .imageBottomTextCompress:
            configureImageBottomTextCompress(configuration: &configuration, space: space, contentInsets: contentInsets)
        }
    }

    @available(iOS 15.0, *)
    private func setupConfigurationUpdateHandler(buttonFont: UIFont, buttonColor: UIColor, compressMinimumScaleFactor: CGFloat? = nil) {
        configurationUpdateHandler = { button in
            var updatedConfig = button.configuration

            // 保持背景图片，只清除背景颜色和描边颜色
            if let backgroundImage = button.backgroundImage(for: .normal) {
                updatedConfig?.background.image = backgroundImage
            }
            updatedConfig?.background.backgroundColor = .clear
            updatedConfig?.background.strokeColor = .clear

            updatedConfig?.background.cornerRadius = button.layer.cornerRadius
            // 更新字体和颜色：
            // Configuration 模式下 titleLabel?.font 会被系统接管，读到的可能是默认字体，
            // 因此字体固定用进入配置前快照的 buttonFont；颜色可通过 setTitleColor 动态刷新，故保留读取。
            let newColor = button.titleColor(for: .normal) ?? buttonColor

            var newAttributes = AttributeContainer()
            newAttributes.font = buttonFont
            newAttributes.foregroundColor = newColor

            if let title = button.title(for: .normal) {
                updatedConfig?.attributedTitle = AttributedString(title, attributes: newAttributes)
            }

            button.configuration = updatedConfig

            // compress 模式：配置刷新会重置 titleLabel，需在此重新开启字号自适应，保证缩小而非截断
            if let scaleFactor = compressMinimumScaleFactor {
                button.applyCompressSingleLine(minimumScaleFactor: scaleFactor)
            }
        }
    }

    // MARK: - Configuration Helper Methods

    @available(iOS 15.0, *)
    private func configureCenterImageTop(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .top
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: space,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageLeft(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: space
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageRight(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: space,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageBottom(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .bottom
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: space,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureLeftImageLeft(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: space
        )
        contentHorizontalAlignment = .leading
    }

    @available(iOS 15.0, *)
    private func configureLeftImageRight(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: space
        )
        contentHorizontalAlignment = .leading
    }

    @available(iOS 15.0, *)
    private func configureRightImageLeft(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: space,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
        contentHorizontalAlignment = .trailing
    }

    @available(iOS 15.0, *)
    private func configureRightImageRight(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: space,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
        contentHorizontalAlignment = .trailing
    }

    @available(iOS 15.0, *)
    private func configureCenterImageTopFixedSpace(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .top
        configuration.titleAlignment = .center
        configuration.imagePadding = space
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: space,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageLeftFixedSpace(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .center
        configuration.imagePadding = space
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: space
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageRightFixedSpace(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .center
        configuration.imagePadding = space
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: space,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageBottomFixedSpace(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .bottom
        configuration.titleAlignment = .center
        configuration.imagePadding = space
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: space,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureTopImageTop(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .top
        configuration.titleAlignment = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: space,
            trailing: contentInsets.trailing
        )
        contentHorizontalAlignment = .center
    }

    @available(iOS 15.0, *)
    private func configureTopImageBottom(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .bottom
        configuration.titleAlignment = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: space,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
        contentHorizontalAlignment = .center
    }

    @available(iOS 15.0, *)
    private func configureBottomImageTop(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .top
        configuration.titleAlignment = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: space,
            trailing: contentInsets.trailing
        )
        contentHorizontalAlignment = .center
    }

    @available(iOS 15.0, *)
    private func configureBottomImageBottom(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .bottom
        configuration.titleAlignment = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: space,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
        contentHorizontalAlignment = .center
    }

    @available(iOS 15.0, *)
    private func configureCenterImageTopTextBelow(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .top
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: space,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageLeftTextRight(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: space
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageRightTextLeft(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .trailing
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: space,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureCenterImageBottomTextAbove(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .bottom
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: space,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureImageOnly(configuration: inout UIButton.Configuration) {
        configuration.image = image(for: .normal)
        configuration.title = nil
    }

    @available(iOS 15.0, *)
    private func configureTextOnly(configuration: inout UIButton.Configuration) {
        configuration.image = nil
        configuration.title = title(for: .normal)
    }

    @available(iOS 15.0, *)
    private func configureImageTopTextBelowFixedHeight(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .top
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: space,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureImageLeftTextRightFixedWidth(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: space
        )
    }

    @available(iOS 15.0, *)
    private func configureImageRightTextLeftFixedWidth(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .trailing
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: space,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureImageBottomTextAboveFixedHeight(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .bottom
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: space,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    // MARK: - 文字压缩不换行

    /// 让标题单行显示、宽度不足时自动缩小字号（不换行）
    /// - Parameter minimumScaleFactor: 最小缩放比例，默认 0.5
    @available(iOS 15.0, *)
    private func applyCompressSingleLine(minimumScaleFactor: CGFloat = 0.5) {
        titleLabel?.numberOfLines = 1
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = minimumScaleFactor
        titleLabel?.lineBreakMode = .byTruncatingTail
    }

    @available(iOS 15.0, *)
    private func configureImageTopTextCompress(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .top
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byTruncatingTail
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: space,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureImageLeftTextCompress(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.titleLineBreakMode = .byTruncatingTail
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: space
        )
    }

    @available(iOS 15.0, *)
    private func configureImageRightTextCompress(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .trailing
        configuration.titleLineBreakMode = .byTruncatingTail
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsets.top,
            leading: space,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }

    @available(iOS 15.0, *)
    private func configureImageBottomTextCompress(configuration: inout UIButton.Configuration, space: CGFloat, contentInsets: NSDirectionalEdgeInsets) {
        configuration.imagePlacement = .bottom
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byTruncatingTail
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: space,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }
}

// MARK: - 活动指示器相关扩展
public extension UIButton {
    /// 关联键
    private struct AssociatedKeys {
        static var activityIndicatorViewKey = UnsafeRawPointer(bitPattern: "activityIndicatorViewKey".hashValue)!
        static var activityIndicatorEnabledKey = UnsafeRawPointer(bitPattern: "activityIndicatorEnabledKey".hashValue)!
        static var activityIndicatorColorKey = UnsafeRawPointer(bitPattern: "activityIndicatorColorKey".hashValue)!
        /// 定义关联键，用于存储URL相关信息
        static let kTimerKey = UnsafeRawPointer(bitPattern: "timerKey".hashValue)!
        static let kTimeKey = UnsafeRawPointer(bitPattern: "timeKey".hashValue)!
        static let kStartTitleKey = UnsafeRawPointer(bitPattern: "startTitleKey".hashValue)!
        static let kEndTitleKey = UnsafeRawPointer(bitPattern: "endTitleKey".hashValue)!
        static let kIsRunningKey = UnsafeRawPointer(bitPattern: "isRunningKey".hashValue)!
    }
    
    /// 活动指示器视图
    private(set) var activityIndicatorView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.activityIndicatorViewKey) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.activityIndicatorViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 活动指示器启用状态
    var activityIndicatorEnabled: Bool {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.activityIndicatorEnabledKey) as? Bool ?? false
        }
        set {
            ensureActivityIndicator()
            objc_setAssociatedObject(self, AssociatedKeys.activityIndicatorEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            toggleActivityIndicator()
        }
    }
    
    /// 活动指示器颜色
    @objc dynamic var activityIndicatorColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.activityIndicatorColorKey) as? UIColor ?? titleColor(for: .normal)
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.activityIndicatorColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if activityIndicatorEnabled {
                activityIndicatorView?.color = newValue
            }
        }
    }
    
    /// 确保活动指示器已创建
    private func ensureActivityIndicator() {
        guard activityIndicatorView == nil else { return }
        
        let activityIndicatorView: UIActivityIndicatorView
        if #available(iOS 13, *) {
            activityIndicatorView = UIActivityIndicatorView(style: .medium)
        } else {
            activityIndicatorView = UIActivityIndicatorView(style: .white)
        }
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        self.activityIndicatorView = activityIndicatorView
    }
    
    /// 切换活动指示器状态
    private func toggleActivityIndicator() {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = !self.activityIndicatorEnabled
            
            if !self.activityIndicatorEnabled {
                self.activityIndicatorView?.stopAnimating()
            } else {
                self.activityIndicatorView?.color = self.activityIndicatorColor
            }
            
            UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseInOut, animations: {
                self.titleLabel?.alpha = self.activityIndicatorEnabled ? 0.0 : 1.0
            }, completion: { _ in
                if self.activityIndicatorEnabled {
                    self.activityIndicatorView?.startAnimating()
                }
            })
        }
    }
}

// MARK: - 背景色相关扩展
public extension UIButton {
    /// 普通状态背景色
    @IBInspectable var normalStateBackgroundColor: UIColor? {
        get { return nil }
        set {
            if let color = newValue {
                setBackgroundColor(color, for: .normal)
            }
        }
    }
    
    /// 禁用状态背景色
    @IBInspectable var disabledStateBackgroundColor: UIColor? {
        get { return nil }
        set {
            if let color = newValue {
                setBackgroundColor(color, for: .disabled)
            }
        }
    }
    
    /// 高亮状态背景色
    @IBInspectable var highlightedStateBackgroundColor: UIColor? {
        get { return nil }
        set {
            if let color = newValue {
                setBackgroundColor(color, for: .highlighted)
            }
        }
    }
    
    /// 选中状态背景色
    @IBInspectable var selectedStateBackgroundColor: UIColor? {
        get { return nil }
        set {
            if let color = newValue {
                setBackgroundColor(color, for: .selected)
            }
        }
    }
    
    /// 设置指定状态的背景色
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 按钮状态
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        if let image = UIImage.image(withPureColor: color, for: rect, rounded: false) {
            setBackgroundImage(image, for: state)
        }
    }
}

// MARK: - 实用工具扩展
public extension UIButton {
    /// 标题图片位置是否反转
    var isTitleImagePositionReversed: Bool {
        get {
            return transform == .identity
        }
        set {
            let reversingTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = reversingTransform
            titleLabel?.transform = reversingTransform
            imageView?.transform = reversingTransform
        }
    }
    
    /// 背景图片视图
    var backgroundImageView: UIImageView? {
        return subviews.first {
            if let backgroundImageView = $0 as? UIImageView, backgroundImageView != imageView {
                return true
            }
            return false
        } as? UIImageView
    }
    
    /// 闭包包装器
    private class ButtonClosureWrapper {
        let closure: () -> Void
        
        init (_ closure: @escaping () -> Void) {
            self.closure = closure
        }
        
        @objc func invoke() {
            closure()
        }
    }
    
    /// 添加按钮事件
    /// - Parameters:
    ///   - controlEvent: 控制事件
    ///   - closure: 闭包回调
    func addAction(for controlEvent: UIControl.Event, closure: @escaping () -> Void) {
        let wrapper = ButtonClosureWrapper(closure)
        addTarget(wrapper, action: #selector(ButtonClosureWrapper.invoke), for: controlEvent)
        
        var possibleKey = "hessekit_ClosureWrapper_\(arc4random())"
        while objc_getAssociatedObject(self, (possibleKey)) != nil {
            possibleKey = "hessekit_ClosureWrapper_\(arc4random())"
        }
        
        objc_setAssociatedObject(self, (possibleKey), wrapper, .OBJC_ASSOCIATION_RETAIN)
    }
    // MARK: - 计时器状态属性
    
    /// 计时器是否正在运行
    private var isTimerRunning: Bool {
        get {
            objc_getAssociatedObject(self, AssociatedKeys.kIsRunningKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.kIsRunningKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 当前剩余时间
    private var currentTime: Int {
        get {
            objc_getAssociatedObject(self, AssociatedKeys.kTimeKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.kTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 开始标题
    private var startTitle: String {
        get {
            objc_getAssociatedObject(self, AssociatedKeys.kStartTitleKey) as? String ?? "剩余"
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.kStartTitleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 结束标题
    private var endTitle: String {
        get {
            objc_getAssociatedObject(self, AssociatedKeys.kEndTitleKey) as? String ?? "重新获取"
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.kEndTitleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 验证码倒计时显示
    /// - Parameters:
    ///   - interval: 倒计时时间（秒）
    ///   - startTitle: 倒计时前缀
    ///   - endTitle: 结束时标题
    ///   - completion: 倒计时完成回调
    func timerStart(
        _ interval: Int = 60,
        startTitle: String = "剩余",
        endTitle: String = "重新获取",
        completion: (() -> Void)? = nil
    ) {
        // 防止重复启动计时器
        if isTimerRunning {
            return
        }
        
        // 验证参数
        guard interval > 0 else {
            print("⚠️ 倒计时时间必须大于0")
            return
        }
        
        // 保存参数
        self.startTitle = startTitle
        self.endTitle = endTitle
        currentTime = interval
        isTimerRunning = true
        
        // 使用主队列，避免UI更新问题
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)

        // 保存计时器引用，防止内存泄漏
        objc_setAssociatedObject(self, AssociatedKeys.kTimerKey, codeTimer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        // 立即设置初始状态
        isEnabled = false
        setTitle("\(startTitle)\(currentTime)s", for: .normal)

        codeTimer.schedule(deadline: .now(), repeating: 1.0)
        codeTimer.setEventHandler { [weak self] in
            guard let strongSelf = self else {
                codeTimer.cancel()
                return
            }
            
            strongSelf.currentTime -= 1
            
            if strongSelf.currentTime > 0 {
                strongSelf.setTitle("\(strongSelf.startTitle)\(strongSelf.currentTime)s", for: .normal)
                strongSelf.isEnabled = false
            } else {
                strongSelf.timerStop()
                strongSelf.setTitle(strongSelf.endTitle, for: .normal)
                strongSelf.isEnabled = true
                completion?()
            }
        }
        codeTimer.resume()
    }

    /// 停止倒计时
    func timerStop() {
        guard isTimerRunning else { return }
        
        if let timer = objc_getAssociatedObject(self, AssociatedKeys.kTimerKey) as? DispatchSourceTimer {
            timer.cancel()
            objc_setAssociatedObject(self, AssociatedKeys.kTimerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        // 清理所有关联对象
        objc_setAssociatedObject(self, AssociatedKeys.kTimeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, AssociatedKeys.kStartTitleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, AssociatedKeys.kEndTitleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, AssociatedKeys.kIsRunningKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        isTimerRunning = false
    }
    
    /// 暂停倒计时
    func timerPause() {
        guard isTimerRunning else { return }
        
        if let timer = objc_getAssociatedObject(self, AssociatedKeys.kTimerKey) as? DispatchSourceTimer {
            timer.suspend()
        }
    }
    
    /// 恢复倒计时
    func timerResume() {
        guard isTimerRunning else { return }
        
        if let timer = objc_getAssociatedObject(self, AssociatedKeys.kTimerKey) as? DispatchSourceTimer {
            timer.resume()
        }
    }
    
    /// 重置倒计时到指定时间
    /// - Parameter interval: 新的倒计时时间
    func timerReset(_ interval: Int) {
        guard interval > 0 else { return }
        
        timerStop()
        timerStart(interval, startTitle: startTitle, endTitle: endTitle)
    }
    
    /// 获取剩余时间
    var remainingTime: Int {
        return currentTime
    }
    
    /// 检查计时器状态
    var timerStatus: TimerStatus {
        if isTimerRunning {
            return .running(remainingTime: currentTime)
        } else {
            return .stopped
        }
    }
}


public enum TimerStatus {
    case running(remainingTime: Int)
    case stopped
}

public extension UIButton {
    /// 快速启动验证码倒计时
    /// - Parameters:
    ///   - seconds: 倒计时秒数
    ///   - completion: 完成回调
    func startVerificationCodeTimer(seconds: Int = 60, completion: (() -> Void)? = nil) {
        timerStart(seconds, startTitle: "剩余", endTitle: "重新获取", completion: completion)
    }
    
    /// 启动自定义倒计时
    /// - Parameters:
    ///   - seconds: 倒计时秒数
    ///   - format: 时间格式，支持 %d 占位符
    ///   - completion: 完成回调
    func startCustomTimer(
        seconds: Int,
        format: String = "剩余%d秒",
        completion: (() -> Void)? = nil
    ) {
        let startTitle = String(format: format, seconds)
        let endTitle = "完成"
        timerStart(seconds, startTitle: startTitle, endTitle: endTitle, completion: completion)
    }
}
