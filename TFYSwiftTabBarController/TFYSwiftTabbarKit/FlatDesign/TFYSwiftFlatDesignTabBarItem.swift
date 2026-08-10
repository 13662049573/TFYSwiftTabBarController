//
//  TFYSwiftFlatDesignTabBarItem.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLFlatDesignTabBarItem
//

import UIKit

public extension Notification.Name {
    static let TFYSwiftFlatDesignTabBarItemDidChange = Notification.Name("TFYSwiftFlatDesignTabBarItemDidChange")
}

@objc open class TFYSwiftFlatDesignTabBarItem: NSObject {

    @objc public weak var tabBarButton: TFYSwiftFlatDesignTabBarButton?
    @objc public var isEnabled: Bool = true {
        didSet { if oldValue != isEnabled { notifyChange() } }
    }
    @objc public var index: UInt = 0
    @objc public var title: String? {
        didSet { if oldValue != title { notifyChange() } }
    }
    @objc public var image: UIImage? {
        didSet { if oldValue !== image { notifyChange() } }
    }
    @objc public var selectedImage: UIImage? {
        didSet { if oldValue !== selectedImage { notifyChange() } }
    }
    @objc public var childViewController: UIViewController? {
        didSet { childViewController?.tfyflatdesign_tabBarController = tfyflatdesign_tabBarController }
    }
    @objc public var badgeValue: String? {
        didSet { if oldValue != badgeValue { notifyChange() } }
    }
    @objc public var badgeColor: UIColor? = .systemRed {
        didSet { if oldValue !== badgeColor { notifyChange() } }
    }
    @objc public weak var tfyflatdesign_tabBarController: UIViewController?
    @objc public var titlePositionAdjustment: UIOffset = .zero {
        didSet { if oldValue != titlePositionAdjustment { notifyChange() } }
    }
    @objc public var badgeSize: CGSize = .zero {
        didSet { if oldValue != badgeSize { notifyChange() } }
    }
    @objc public var badgeContentInset: UIEdgeInsets = UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6) {
        didSet { if oldValue != badgeContentInset { notifyChange() } }
    }
    @objc public var badgePositionAdjustment: UIOffset = .zero {
        didSet { if oldValue != badgePositionAdjustment { notifyChange() } }
    }
    @objc public var imagePositionAdjustment: UIOffset = .zero {
        didSet { if oldValue != imagePositionAdjustment { notifyChange() } }
    }
    @objc public var layoutCentered: Bool = false {
        didSet { if oldValue != layoutCentered { notifyChange() } }
    }
    @objc public var backgroundColor: UIColor? {
        didSet { if oldValue !== backgroundColor { notifyChange() } }
    }
    @objc public var selectedBackgroundColor: UIColor? {
        didSet { if oldValue !== selectedBackgroundColor { notifyChange() } }
    }
    @objc public var imageInsets: UIEdgeInsets = .zero {
        didSet { if oldValue != imageInsets { notifyChange() } }
    }
    @objc public var lottieURL: URL?
    @objc public var lottieFilePath: String?
    @objc public var lottieSizeValue: NSValue?

    private var titleTextAttributesForState: [UInt: [NSAttributedString.Key: Any]] = [:]
    private var badgeTextAttributesForState: [UInt: [NSAttributedString.Key: Any]] = [:]

    public override init() {
        super.init()
    }

    @objc public convenience init(title: String?, image: UIImage?) {
        self.init(title: title, image: image, selectedImage: nil)
    }

    @objc public convenience init(title: String?, image: UIImage?, selectedImage: UIImage?) {
        self.init(
            title: title ?? "",
            image: image as Any?,
            selectedImage: selectedImage as Any?,
            index: 0,
            titlePositionAdjustment: .zero,
            imagePositionAdjustment: .zero,
            imageInsets: .zero,
            lottieFilePath: nil,
            lottieSizeValue: nil
        )
    }

    @objc public init(
        title: String,
        image: Any?,
        selectedImage: Any?,
        index: Int,
        titlePositionAdjustment: UIOffset,
        imagePositionAdjustment: UIOffset,
        imageInsets: UIEdgeInsets,
        lottieFilePath: String?,
        lottieSizeValue: NSValue?
    ) {
        super.init()
        self.title = title
        self.image = UIImage.tfy_getImageFromImageInfo(image)
        self.selectedImage = UIImage.tfy_getImageFromImageInfo(selectedImage)
        self.index = UInt(index)
        self.titlePositionAdjustment = titlePositionAdjustment
        self.imagePositionAdjustment = imagePositionAdjustment
        self.imageInsets = imageInsets
        self.lottieFilePath = lottieFilePath
        self.lottieSizeValue = lottieSizeValue
    }

    @objc public func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) {
        titleTextAttributesForState[state.rawValue] = attributes
        notifyChange()
    }

    @objc public func titleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any]? {
        titleTextAttributesForState[state.rawValue]
    }

    @objc public func setBadgeTextAttributes(_ textAttributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) {
        badgeTextAttributesForState[state.rawValue] = textAttributes
        notifyChange()
    }

    @objc public func badgeTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any]? {
        badgeTextAttributesForState[state.rawValue]
    }

    @objc public func actualBadgeSuperView() -> UIView? {
        tabBarButton?.actualBadgeSuperView()
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: .TFYSwiftFlatDesignTabBarItemDidChange, object: self)
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? TFYSwiftFlatDesignTabBarItem else { return false }
        if self === other { return true }
        return isEnabled == other.isEnabled
            && title == other.title
            && image === other.image
            && selectedImage === other.selectedImage
            && badgeColor === other.badgeColor
            && badgeValue == other.badgeValue
            && badgeSize == other.badgeSize
            && badgePositionAdjustment == other.badgePositionAdjustment
            && badgeContentInset == other.badgeContentInset
            && titlePositionAdjustment == other.titlePositionAdjustment
            && imagePositionAdjustment == other.imagePositionAdjustment
            && imageInsets == other.imageInsets
            && layoutCentered == other.layoutCentered
            && backgroundColor === other.backgroundColor
            && selectedBackgroundColor === other.selectedBackgroundColor
    }
}
