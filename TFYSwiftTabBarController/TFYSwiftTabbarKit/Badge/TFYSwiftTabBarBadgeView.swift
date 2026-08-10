//
//  TFYSwiftTabBarBadgeView.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLTabBarBadgeView
//

import UIKit

public let TFYSwiftBadgeDefaultFont = UIFont.boldSystemFont(ofSize: 9)

open class TFYSwiftTabBarBadgeView: UIView {

    public var badgeContentInset: UIEdgeInsets = .zero

    public var textAlignment: NSTextAlignment = .center {
        didSet { badgeLabel.textAlignment = textAlignment }
    }

    public var textColor: UIColor! {
        get { _textColor ?? .white }
        set {
            _textColor = newValue
            if let newValue { badgeLabel.textColor = newValue }
        }
    }

    public var text: String? {
        didSet {
            if badgeLabel.text != text {
                badgeLabel.text = text
            }
        }
    }

    public var font: UIFont! {
        get { _font ?? UIFont.systemFont(ofSize: 17) }
        set {
            _font = newValue
            if let newValue { badgeLabel.font = newValue }
        }
    }

    private var _textColor: UIColor?
    private var _font: UIFont?
    private lazy var badgeLabel: UILabel = {
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        bringSubviewToFront(label)
        label.layer.zPosition = .greatestFiniteMagnitude
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        _ = badgeLabel
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.masksToBounds = true
        _ = badgeLabel
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds != .zero, badgeLabel.frame != bounds else { return }
        badgeLabel.frame = bounds
    }

    open override var frame: CGRect {
        didSet {
            guard frame != .zero, frame.size != .zero else { return }
            badgeLabel.frame = CGRect(origin: .zero, size: frame.size)
        }
    }

    open override var center: CGPoint {
        didSet {
            guard center != .zero else { return }
            badgeLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let text, !text.isEmpty else { return .zero }
        let badgeSize = (text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: [],
            attributes: [.font: badgeLabel.font as Any],
            context: nil
        ).size
        var width = badgeSize.width + badgeContentInset.left + badgeContentInset.right
        var height = badgeSize.height + badgeContentInset.top + badgeContentInset.bottom
        height = max(height, 18)
        width = max(width, height)
        return CGSize(width: width, height: height)
    }
}
