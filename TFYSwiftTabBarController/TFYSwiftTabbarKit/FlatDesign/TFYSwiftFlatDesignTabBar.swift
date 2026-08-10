//
//  TFYSwiftFlatDesignTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLFlatDesignTabBar
//

import UIKit

@objc public protocol TFYSwiftFlatDesignTabBarDelegate: AnyObject {
    @objc optional func tabBar(_ tabBar: TFYSwiftFlatDesignTabBar, didSelect item: TFYSwiftFlatDesignTabBarItem)
}

@objc open class TFYSwiftFlatDesignTabBar: UIView {

    @objc public weak var delegate: TFYSwiftFlatDesignTabBarDelegate? {
        didSet {
            if oldValue != nil, tabBarController != nil {
                #if DEBUG
                assertionFailure("Cannot change delegate managed by tabBarController")
                #endif
                if tabBarController != nil { return }
            }
        }
    }

    @objc public var items: [TFYSwiftFlatDesignTabBarItem]? {
        didSet {
            if let selected = selectedItem, items?.contains(where: { $0 === selected }) != true {
                selectedItemIndex = -1
            }
            reloadItems()
        }
    }

    @objc public var tabBarItems: [TFYSwiftFlatDesignTabBarButton]? {
        get { tabBarButtons }
        set {
            if let items = newValue?.compactMap({ $0.tabBarItem }) {
                self.items = items
            }
        }
    }

    @objc public private(set) var selectedItem: TFYSwiftFlatDesignTabBarItem? {
        get {
            guard selectedItemIndex >= 0, let items, selectedItemIndex < items.count else { return nil }
            return items[selectedItemIndex]
        }
        set {
            if let newValue, let items, let index = items.firstIndex(where: { $0 === newValue }) {
                setSelectedIndex(index)
            } else if selectedItem != nil, selectedItemIndex >= 0, selectedItemIndex < buttons.count {
                buttons[selectedItemIndex].isSelected = false
                selectedItemIndex = -1
            }
        }
    }

    @objc public var selectedIndex: UInt {
        get { UInt(max(selectedItemIndex, 0)) }
        set { setSelectedIndex(Int(newValue)) }
    }

    @objc public var tabBarButtons: [TFYSwiftFlatDesignTabBarButton] { buttons }

    @objc public override var tintColor: UIColor! {
        get { _tintColor ?? super.tintColor ?? .systemBlue }
        set {
            _tintColor = newValue
            super.tintColor = newValue
            buttons.forEach { $0.tintColor = newValue }
        }
    }

    @objc public var barTintColor: UIColor? {
        didSet { applyBarTintOrBackground() }
    }

    @objc public var backgroundImage: UIImage? {
        didSet { applyBarTintOrBackground() }
    }

    @objc public var shadowImage: UIImage? {
        didSet {
            if let shadowImage {
                if shadowImageView == nil {
                    shadowImageView = UIImageView()
                    backgroundView.addSubview(shadowImageView!)
                }
                shadowImageView?.image = shadowImage
            } else {
                shadowImageView?.removeFromSuperview()
                shadowImageView = nil
            }
            setNeedsLayout()
        }
    }

    @objc public var useLayoutSafeAreaInsets = false {
        didSet { setNeedsLayout() }
    }

    @objc public var context: String? {
        didSet { tfy_context = context ?? "" }
    }

    private var _tintColor: UIColor?
    private var selectedItemIndex = -1
    private var buttons: [TFYSwiftFlatDesignTabBarButton] = []
    private let backgroundView = UIView()
    private var backgroundEffectView: UIVisualEffectView?
    private let backgroundImageView = UIImageView()
    private var shadowImageView: UIImageView?
    private let contentView = UIView()
    private weak var plusButton: TFYSwiftPlusButton?

    private var tabBarController: UITabBarController? {
        delegate as? UITabBarController
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        UINavigationController.tfy_navigationBarActionHook()
        commonInit()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDidChange(_:)),
            name: .TFYSwiftFlatDesignTabBarItemDidChange,
            object: nil
        )
        NotificationCenter.default.addObserver(
            forName: .TFYSwiftTabBarItemLottieAnimationPlaying,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.stopAnimationOfAllLottieView()
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var fitted = super.sizeThatFits(size)
        let height = contentView.frame.size.height
        if height > 0 { fitted.height = height }
        return fitted
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    @objc public func addItem(
        withTitle title: String,
        tabBarItemImage: Any?,
        tabBarItemSelectedImage: Any?,
        index: Int,
        titlePositionAdjustment: UIOffset,
        imageInsets: UIEdgeInsets,
        lottieFilePath: String?,
        lottieSizeValue: NSValue?
    ) -> TFYSwiftFlatDesignTabBarItem {
        TFYSwiftFlatDesignTabBarItem(
            title: title,
            image: tabBarItemImage,
            selectedImage: tabBarItemSelectedImage,
            index: index,
            titlePositionAdjustment: titlePositionAdjustment,
            imagePositionAdjustment: .zero,
            imageInsets: imageInsets,
            lottieFilePath: lottieFilePath,
            lottieSizeValue: lottieSizeValue
        )
    }

    @objc public func hasPlusButton() -> Bool {
        TFYSwiftPlusButton.hasPlusButton(forTabBarContext: tfy_context)
    }

    @objc public func hasPlusChildViewController() -> Bool {
        TFYSwiftPlusButton.hasPlusChildViewController(forTabBarContext: tfy_context)
    }

    // MARK: - Hit Test

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if tfy_canNotResponseEvent() {
            return super.hitTest(point, with: event)
        }
        if clipsToBounds, !self.point(inside: point, with: event) {
            return super.hitTest(point, with: event)
        }
        if let plus = plusButton {
            let frame = plus.convert(plus.touchableRect(), to: self)
            if frame.contains(point), !hasPlusChildViewController() {
                return plus
            }
            if let superview = plus.superview,
               superview.frame.contains(point),
               superview.tfy_isPlaceholder,
               superview.tfy_canNotResponseEvent(),
               !plus.tfy_canNotResponseEvent() {
                return plus
            }
        }
        for button in tabBarButtons {
            let imageRect = button.actualBadgeSuperView().convert(button.imageView.bounds, to: self)
            if (button.frame.contains(point) || imageRect.contains(point)),
               !button.tfy_canNotResponseEvent() {
                return button
            }
        }
        if let result = super.hitTest(point, with: event) { return result }
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) { return result }
        }
        return super.hitTest(point, with: event)
    }

    // MARK: - Private

    private func commonInit() {
        selectedItemIndex = -1
        backgroundView.clipsToBounds = false
        addSubview(backgroundView)
        backgroundView.addSubview(backgroundImageView)
        contentView.clipsToBounds = false
        addSubview(contentView)
        barTintColor = .clear
        tintColor = .systemBlue
        useLayoutSafeAreaInsets = false
    }

    @objc private func tabBarItemDidChange(_ note: Notification) {
        guard let items, !items.isEmpty,
              let changed = note.object as? TFYSwiftFlatDesignTabBarItem,
              let index = items.firstIndex(where: { $0 === changed }),
              index < buttons.count else { return }
        buttons[index].tabBarItem = changed
    }

    @objc private func tabBarDidSelectButton(_ tabBarButton: TFYSwiftFlatDesignTabBarButton) {
        guard let selectedIndex = buttons.firstIndex(of: tabBarButton),
              let items, selectedIndex < items.count else { return }
        let item = items[selectedIndex]
        guard item.isEnabled else { return }
        delegate?.tabBar?(self, didSelect: item)
        if let tabBarController {
            let sel = NSSelectorFromString(["_", "tab", "BarItem", "Clicked"].joined())
            if tabBarController.responds(to: sel),
               let systemItem = tabBarController.tabBar.items?[safe: selectedIndex] {
                _ = tabBarController.perform(sel, with: systemItem)
            } else {
                let custom = NSSelectorFromString("_tfytabBarItemClicked:")
                if tabBarController.responds(to: custom) {
                    _ = tabBarController.perform(custom, with: item)
                } else {
                    setSelectedIndex(selectedIndex)
                }
            }
        } else {
            setSelectedIndex(selectedIndex)
        }
    }

    private func reloadItems() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        guard let items else { return }
        for item in items {
            let button = TFYSwiftFlatDesignTabBarButton(tabBarItem: item)
            button.tintColor = tintColor
            button.isSelected = (item === selectedItem)
            button.addTarget(self, action: #selector(tabBarDidSelectButton(_:)), for: .touchUpInside)
            button.clipsToBounds = false
            contentView.insertSubview(button, at: 0)
            buttons.append(button)
        }
        setNeedsLayout()
    }

    private func setSelectedIndex(_ selectedIndex: Int) {
        guard selectedItemIndex != selectedIndex else { return }
        selectedItemIndex = selectedIndex
        for (i, button) in buttons.enumerated() {
            button.isSelected = (i == selectedIndex)
        }
    }

    private func applyBarTintOrBackground() {
        backgroundImageView.image = backgroundImage
        if backgroundImage != nil {
            backgroundEffectView?.removeFromSuperview()
            backgroundEffectView = nil
            backgroundImageView.backgroundColor = .clear
        } else {
            backgroundImageView.backgroundColor = barTintColor
            if backgroundEffectView == nil {
                backgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
            }
            if let effect = backgroundEffectView {
                backgroundView.insertSubview(effect, at: 0)
            }
        }
        setNeedsLayout()
    }

    private func updateLayout() {
        guard bounds != .zero else { return }
        backgroundView.frame = bounds
        backgroundImageView.frame = backgroundView.bounds
        backgroundEffectView?.frame = backgroundView.bounds
        if let shadowImageView {
            let h = 1.0 / UIScreen.main.scale
            shadowImageView.frame = CGRect(x: 0, y: -h, width: backgroundView.bounds.width, height: h)
        }
        let contentHeight = bounds.height - safeAreaInsets.bottom
        contentView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: contentHeight)
        guard let items, !items.isEmpty, buttons.count == items.count else { return }

        var contentWidth = contentView.bounds.width
        if useLayoutSafeAreaInsets {
            contentWidth -= (safeAreaInsets.left + safeAreaInsets.right)
        }
        let buttonWidth = items.count == 1
            ? contentWidth
            : contentWidth / CGFloat(items.count)
        let buttonHeight = contentView.bounds.height

        for (i, button) in buttons.enumerated() {
            button.tabBarItem = items[i]
            var x = CGFloat(i) * buttonWidth
            if useLayoutSafeAreaInsets { x += safeAreaInsets.left }
            button.frame = CGRect(x: x, y: 0, width: buttonWidth, height: buttonHeight)
        }

        layoutPlusButtonIfNeeded()
    }

    private func layoutPlusButtonIfNeeded() {
        guard hasPlusButton(),
              let plus = TFYSwiftExternPlusButton,
              Int(TFYSwiftPlusButtonIndex) < buttons.count else { return }
        plus.layer.contentsGravity = .center
        if #available(iOS 13.0, *) {
            plus.layer.contentsScale = tfy_getRootWindow()?.windowScene?.screen.scale ?? UIScreen.main.scale
        }
        plusButton = plus
        let placeholder = buttons[Int(TFYSwiftPlusButtonIndex)]
        guard placeholder.tabBarItem != nil else { return }
        let offset = UIOffset(horizontal: 0, vertical: plus.constantOfPlusButtonCenterYOffsetForTabBarHeight())
        plus.translatesAutoresizingMaskIntoConstraints = false
        placeholder.tfy_coverVisiableTabImageViewOrTabButton(
            true,
            contentNewView: plus,
            seclectContentNewView: plus,
            offset: offset,
            show: true,
            delayIfNeededForSeconds: 0.1
        ) { _, tabBarButton, _ in
            tabBarButton.tfy_isPlaceholder = true
        }
    }

    private func stopAnimationOfAllLottieView() {
        tabBarButtons.forEach { $0.tfy_stopAnimationOfLottieView() }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
