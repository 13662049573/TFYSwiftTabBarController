//
//  TFYSwiftFlatDesignTabBarButton.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLFlatDesignTabBarButton
//

import UIKit

@objc open class TFYSwiftFlatDesignTabBarButton: UIControl {

    @objc public private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = false
        addSubview(view)
        return view
    }()

    @objc public private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = false
        addSubview(label)
        return label
    }()

    private var _selected = false
    open override var isSelected: Bool {
        get { _selected }
        set {
            guard _selected != newValue else { return }
            super.isSelected = newValue
            _selected = newValue
            updateTabBarButton()
        }
    }

    @objc public var tabBarItem: TFYSwiftFlatDesignTabBarItem? {
        didSet {
            updateTabBarButton()
            if let item = tabBarItem, item.tabBarButton == nil {
                item.tfy_setValue(self, forKey: "tabBarButton")
            }
        }
    }

    @objc public convenience init(tabBarItem: TFYSwiftFlatDesignTabBarItem) {
        self.init(frame: .zero)
        self.tabBarItem = tabBarItem
        clipsToBounds = false
        updateTabBarButton()
        tabBarItem.tfy_setValue(self, forKey: "tabBarButton")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _ = imageView
        _ = titleLabel
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _ = imageView
        _ = titleLabel
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        if isSelected {
            titleLabel.textColor = titleTextAttributesForState()[.foregroundColor] as? UIColor
            imageView.tintColor = tintColor
        }
    }

    private func updateTabBarButton() {
        guard let item = tabBarItem else { return }
        isEnabled = item.isEnabled
        var image = item.image
        if isSelected, let selected = item.selectedImage {
            image = selected
        }
        imageView.image = image
        imageView.tintColor = isSelected ? tintColor : .systemGray
        titleLabel.text = item.title
        let attrs = titleTextAttributesForState()
        titleLabel.textColor = attrs[.foregroundColor] as? UIColor
        titleLabel.font = attrs[.font] as? UIFont
        backgroundColor = isSelected
            ? (item.selectedBackgroundColor ?? item.backgroundColor)
            : item.backgroundColor
        updateLottie()
        setNeedsLayout()
    }

    private func updateLayout() {
        guard bounds != .zero, let item = tabBarItem else { return }
        let isShowImage = imageView.image != nil
        let isShowTitle = !(titleLabel.text?.isEmpty ?? true)
        if isShowImage { imageView.sizeToFit() }

        let title = isShowTitle ? (titleLabel.text ?? "") : "height"
        let font = titleLabel.font ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        let titleSize = (title as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).size

        var titleX = (bounds.width - titleSize.width) / 2
        var titleY = bounds.height - titleSize.height - 2
        if !isShowImage && item.layoutCentered {
            titleY = (bounds.height - titleSize.height) / 2
        }
        titleX += item.titlePositionAdjustment.horizontal
        titleY += item.titlePositionAdjustment.vertical
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleSize.width, height: titleSize.height)

        if isShowImage {
            let imageW = imageView.frame.width
            let imageH = imageView.frame.height
            var imageX = (bounds.width - imageW) / 2
            var imageY = (titleLabel.frame.minY - imageH) / 2
            if !isShowTitle && item.layoutCentered {
                imageY = (bounds.height - imageH) / 2
            }
            imageX += item.imagePositionAdjustment.horizontal
            imageY += item.imagePositionAdjustment.vertical
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
            let insets = item.imageInsets
            if insets != .zero {
                imageView.frame.size.width -= (insets.left + insets.right)
                imageView.frame.size.height -= (insets.top + insets.bottom)
            }
        } else {
            imageView.frame = .zero
        }
        initLottie()
    }

    private func titleTextAttributesForState() -> [NSAttributedString.Key: Any] {
        let state = currentState()
        var attrs = tabBarItem?.titleTextAttributes(for: state)
            ?? tabBarItem?.titleTextAttributes(for: .normal)
            ?? [:]
        if attrs[.font] == nil {
            attrs[.font] = UIFont.systemFont(ofSize: 10, weight: .medium)
        }
        if attrs[.foregroundColor] == nil {
            attrs[.foregroundColor] = state == .selected ? tintColor : UIColor.systemGray
        }
        return attrs
    }

    private func currentState() -> UIControl.State {
        if state.contains(.disabled) { return .disabled }
        if state.contains(.selected) { return .selected }
        return .normal
    }

    private func initLottie() {
        guard let path = tabBarItem?.lottieFilePath,
              let url = TFYSwiftConstants.tfy_getURL(from: path) else { return }
        let size = tabBarItem?.lottieSizeValue?.cgSizeValue ?? .zero
        let mode = tfy_tabBarController?.lottieAnimationViewContentMode() ?? .scaleAspectFit
        tfy_addLottieImage(withLottieURL: url, size: size, contentMode: mode)
    }

    private func updateLottie() {
        guard isSelected,
              let path = tabBarItem?.lottieFilePath,
              let url = TFYSwiftConstants.tfy_getURL(from: path) else { return }
        let size = tabBarItem?.lottieSizeValue?.cgSizeValue ?? .zero
        let mode = tfy_tabBarController?.lottieAnimationViewContentMode() ?? .scaleAspectFit
        tfy_animationLottieImage(withLottieURL: url, size: size, defaultSelected: false, contentMode: mode)
    }

    @objc public func actualBadgeSuperView() -> UIView {
        tfy_getActualBadgeSuperView() as? UIView ?? self
    }
}
