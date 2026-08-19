import TFYSwiftTabBarController
import UIKit

final class PlusButtonSubclass: TFYSwiftPlusButton, TFYSwiftPlusButtonSubclassing {

    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 15.0, *) {
            configuration = nil
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if #available(iOS 15.0, *) {
            configuration = nil
        }
    }

    static func plusButton() -> Any {
        let button = PlusButtonSubclass(type: .custom)
        if #available(iOS 15.0, *) {
            button.configuration = nil
        }
        button.setImage(contentImage(), for: .normal)
        button.setImage(selectedContentImage(), for: [.highlighted, .selected])
        button.setTitle("发布", for: .normal)
        button.setTitle("发布", for: [.selected, .highlighted])
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.systemGreen, for: [.selected, .highlighted])
        button.titleLabel?.font = .systemFont(ofSize: 9.5)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .center
        button.tintAdjustmentMode = .normal
        button.contentMode = .center
        button.backgroundColor = .clear
        button.isOpaque = false
        button.clipsToBounds = false
        button.bounds = CGRect(x: 0, y: 0, width: 55, height: 80)

        if TFYSwiftPlusChildViewController != nil, button.isLayoutCentered() {
            button.tfy_userInteractionDisabled = false
        } else {
            button.tfy_userInteractionDisabled = true
        }
        return button
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView, let titleLabel else { return }
        titleLabel.sizeToFit()
        let imageSize = imageView.image?.size ?? CGSize(width: 56, height: 56)
        imageView.frame = CGRect(
            x: (bounds.width - imageSize.width) / 2,
            y: 0,
            width: imageSize.width,
            height: imageSize.height
        )
        titleLabel.frame = CGRect(
            x: (bounds.width - titleLabel.bounds.width) / 2,
            y: imageView.frame.maxY,
            width: titleLabel.bounds.width,
            height: titleLabel.bounds.height
        )
    }

    static func indexOfPlusButtonInTabBar() -> UInt { 2 }

    static func constantOfPlusButtonCenterYOffsetForTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat { -14 }

    static func plusChildViewController() -> UIViewController {
        TFYSwiftBaseNavigationController(rootViewController: PublishViewController())
    }

    static func shouldSelectPlusChildViewController() -> Bool { true }

    override class func contentImage() -> UIImage? {
        originalImage(named: "post_normal")
    }

    override class func selectedContentImage() -> UIImage? {
        originalImage(named: "post_highlight")
    }

    private static func originalImage(named: String) -> UIImage? {
        UIImage(named: named)?.withRenderingMode(.alwaysOriginal)
    }
}
