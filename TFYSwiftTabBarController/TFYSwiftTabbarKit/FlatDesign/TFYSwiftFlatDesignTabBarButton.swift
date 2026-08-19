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
        view.contentMode = .scaleAspectFit
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
        if tfy_isPlaceholder {
            imageView.image = nil
            imageView.isHidden = true
            titleLabel.text = nil
            titleLabel.isHidden = true
            backgroundColor = item.backgroundColor
            return
        }
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
        let isPlaceholder = tfy_isPlaceholder || ((item.title?.isEmpty ?? true) && item.image == nil)
        titleLabel.isHidden = isPlaceholder || (item.title?.isEmpty ?? true)
        imageView.isHidden = isPlaceholder
        backgroundColor = isSelected
            ? (item.selectedBackgroundColor ?? item.backgroundColor)
            : item.backgroundColor
        updateLottie()
        setNeedsLayout()
    }

    private func updateLayout() {
        guard bounds != .zero else { return }
        if tfy_isPlaceholder {
            imageView.isHidden = true
            titleLabel.isHidden = true
            return
        }
        guard let item = tabBarItem else { return }

        let isShowTitle = !(titleLabel.text?.isEmpty ?? true)
        let font = titleLabel.font ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        let titleSize: CGSize
        if isShowTitle {
            titleSize = ((titleLabel.text ?? "") as NSString).boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            ).size
        } else {
            titleSize = .zero
        }

        var titleX = (bounds.width - titleSize.width) / 2
        var titleY = bounds.height - titleSize.height - 2
        if !isShowTitle && item.layoutCentered {
            titleY = (bounds.height - titleSize.height) / 2
        }
        titleX += item.titlePositionAdjustment.horizontal
        titleY += item.titlePositionAdjustment.vertical
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleSize.width, height: titleSize.height)
        titleLabel.isHidden = !isShowTitle

        let isShowImage = imageView.image != nil
        if isShowImage {
            let raw = imageView.image?.size ?? CGSize(width: 22, height: 22)
            let side = min(22, max(raw.width, raw.height, 1))
            var imageX = (bounds.width - side) / 2
            var imageY = isShowTitle
                ? max(0, (titleLabel.frame.minY - side) / 2)
                : (bounds.height - side) / 2
            if !isShowTitle && item.layoutCentered {
                imageY = (bounds.height - side) / 2
            }
            imageX += item.imagePositionAdjustment.horizontal
            imageY += item.imagePositionAdjustment.vertical
            imageView.frame = CGRect(x: imageX, y: imageY, width: side, height: side)
            imageView.isHidden = tfy_lottieAnimationView() != nil
        } else {
            imageView.frame = .zero
            imageView.isHidden = true
        }
        initLottie()
        if let lottie = tfy_lottieAnimationView() {
            lottie.translatesAutoresizingMaskIntoConstraints = true
            lottie.frame = imageView.frame == .zero
                ? CGRect(x: (bounds.width - 22) / 2, y: max(0, (titleLabel.frame.minY - 22) / 2), width: 22, height: 22)
                : imageView.frame
        }
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
        guard !tfy_isPlaceholder else { return }
        guard let path = tabBarItem?.lottieFilePath,
              let url = TFYSwiftConstants.tfy_getURL(from: path) else { return }
        let size = tabBarItem?.lottieSizeValue?.cgSizeValue ?? CGSize(width: 22, height: 22)
        let resolved = size == .zero ? CGSize(width: 22, height: 22) : size
        let mode = tfy_tabBarController?.lottieAnimationViewContentMode() ?? .scaleAspectFit
        tfy_addLottieImage(withLottieURL: url, size: resolved, contentMode: mode)
        titleLabel.isHidden = titleLabel.text?.isEmpty ?? true
        if let lottie = tfy_lottieAnimationView() {
            lottie.translatesAutoresizingMaskIntoConstraints = true
            lottie.frame = imageView.frame == .zero
                ? CGRect(x: (bounds.width - 22) / 2, y: max(0, (titleLabel.frame.minY - 22) / 2), width: 22, height: 22)
                : imageView.frame
        }
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
