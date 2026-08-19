//
//  UIColor+TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from UIColor+CYLTabBarControllerExtention.h/.m
//

import UIKit

extension UIColor {

    // MARK: - System Colors

    static var tfy_systemRedColor: UIColor { tfy_systemColor(.systemRed, fallback: tfy_rgba(255, 59, 48, 1)) }
    static var tfy_systemGreenColor: UIColor { tfy_systemColor(.systemGreen, fallback: tfy_rgba(52, 199, 89, 1)) }
    static var tfy_systemBlueColor: UIColor { tfy_systemColor(.systemBlue, fallback: tfy_rgba(0, 122, 255, 1)) }
    static var tfy_systemOrangeColor: UIColor { tfy_systemColor(.systemOrange, fallback: tfy_rgba(255, 149, 0, 1)) }
    static var tfy_systemYellowColor: UIColor { tfy_systemColor(.systemYellow, fallback: tfy_rgba(255, 204, 0, 1)) }
    static var tfy_systemPinkColor: UIColor { tfy_systemColor(.systemPink, fallback: tfy_rgba(255, 45, 85, 1)) }
    static var tfy_systemPurpleColor: UIColor { tfy_systemColor(.systemPurple, fallback: tfy_rgba(175, 82, 222, 1)) }
    static var tfy_systemTealColor: UIColor { tfy_systemColor(.systemTeal, fallback: tfy_rgba(90, 200, 250, 1)) }
    static var tfy_systemIndigoColor: UIColor { tfy_systemColor(.systemIndigo, fallback: tfy_rgba(88, 86, 214, 1)) }

    static var tfy_systemGrayColor: UIColor { tfy_systemColor(.systemGray, fallback: tfy_rgba(142, 142, 147, 1)) }
    static var tfy_systemGray2Color: UIColor { tfy_systemColor(.systemGray2, fallback: tfy_rgba(174, 174, 178, 1)) }
    static var tfy_systemGray3Color: UIColor { tfy_systemColor(.systemGray3, fallback: tfy_rgba(199, 199, 204, 1)) }
    static var tfy_systemGray4Color: UIColor { tfy_systemColor(.systemGray4, fallback: tfy_rgba(209, 209, 214, 1)) }
    static var tfy_systemGray5Color: UIColor { tfy_systemColor(.systemGray5, fallback: tfy_rgba(229, 229, 234, 1)) }
    static var tfy_systemGray6Color: UIColor { tfy_systemColor(.systemGray6, fallback: tfy_rgba(242, 242, 247, 1)) }

    // MARK: - Foreground

    static var tfy_labelColor: UIColor { tfy_systemColor(.label, fallback: tfy_rgba(0, 0, 0, 1)) }
    static var tfy_secondaryLabelColor: UIColor { tfy_systemColor(.secondaryLabel, fallback: tfy_rgba(60, 60, 67, 0.6)) }
    static var tfy_tertiaryLabelColor: UIColor { tfy_systemColor(.tertiaryLabel, fallback: tfy_rgba(60, 60, 67, 0.3)) }
    static var tfy_quaternaryLabelColor: UIColor { tfy_systemColor(.quaternaryLabel, fallback: tfy_rgba(60, 60, 67, 0.18)) }
    static var tfy_linkColor: UIColor { tfy_systemColor(.link, fallback: tfy_rgba(0, 122, 255, 1)) }
    static var tfy_placeholderTextColor: UIColor { tfy_systemColor(.placeholderText, fallback: tfy_rgba(60, 60, 67, 0.3)) }
    static var tfy_separatorColor: UIColor { tfy_systemColor(.separator, fallback: tfy_rgba(60, 60, 67, 0.29)) }
    static var tfy_opaqueSeparatorColor: UIColor { tfy_systemColor(.opaqueSeparator, fallback: tfy_rgba(198, 198, 200, 1)) }

    // MARK: - Background

    static var tfy_systemBackgroundColor: UIColor { tfy_systemColor(.systemBackground, fallback: .white) }
    static var tfy_secondarySystemBackgroundColor: UIColor { tfy_systemColor(.secondarySystemBackground, fallback: tfy_rgba(242, 242, 247, 1)) }
    static var tfy_tertiarySystemBackgroundColor: UIColor { tfy_systemColor(.tertiarySystemBackground, fallback: .white) }
    static var tfy_systemGroupedBackgroundColor: UIColor { tfy_systemColor(.systemGroupedBackground, fallback: tfy_rgba(242, 242, 247, 1)) }
    static var tfy_secondarySystemGroupedBackgroundColor: UIColor { tfy_systemColor(.secondarySystemGroupedBackground, fallback: .white) }
    static var tfy_tertiarySystemGroupedBackgroundColor: UIColor { tfy_systemColor(.tertiarySystemGroupedBackground, fallback: tfy_rgba(242, 242, 247, 1)) }

    // MARK: - Fill

    static var tfy_systemFillColor: UIColor { tfy_systemColor(.systemFill, fallback: tfy_rgba(120, 120, 128, 0.2)) }
    static var tfy_secondarySystemFillColor: UIColor { tfy_systemColor(.secondarySystemFill, fallback: tfy_rgba(120, 120, 128, 0.16)) }
    static var tfy_tertiarySystemFillColor: UIColor { tfy_systemColor(.tertiarySystemFill, fallback: tfy_rgba(118, 118, 128, 0.12)) }
    static var tfy_quaternarySystemFillColor: UIColor { tfy_systemColor(.quaternarySystemFill, fallback: tfy_rgba(116, 116, 128, 0.08)) }

    // MARK: - Other

    static var tfy_lightTextColor: UIColor { tfy_rgba(255, 255, 255, 0.6) }
    static var tfy_darkTextColor: UIColor { tfy_rgba(0, 0, 0, 1) }

    /// Deprecated in CYL 1.27.5; kept for API parity.
    static var tfy_systemBrownColor: UIColor? { nil }

    // MARK: - Private

    private static func tfy_systemColor(_ selector: TFYSystemColorSelector, fallback: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return selector.color()
        }
        return fallback
    }

    private enum TFYSystemColorSelector {
        case systemRed, systemGreen, systemBlue, systemOrange, systemYellow
        case systemPink, systemPurple, systemTeal, systemIndigo
        case systemGray, systemGray2, systemGray3, systemGray4, systemGray5, systemGray6
        case label, secondaryLabel, tertiaryLabel, quaternaryLabel
        case link, placeholderText, separator, opaqueSeparator
        case systemBackground, secondarySystemBackground, tertiarySystemBackground
        case systemGroupedBackground, secondarySystemGroupedBackground, tertiarySystemGroupedBackground
        case systemFill, secondarySystemFill, tertiarySystemFill, quaternarySystemFill

        @available(iOS 13.0, *)
        func color() -> UIColor {
            switch self {
            case .systemRed: return .systemRed
            case .systemGreen: return .systemGreen
            case .systemBlue: return .systemBlue
            case .systemOrange: return .systemOrange
            case .systemYellow: return .systemYellow
            case .systemPink: return .systemPink
            case .systemPurple: return .systemPurple
            case .systemTeal: return .systemTeal
            case .systemIndigo: return .systemIndigo
            case .systemGray: return .systemGray
            case .systemGray2: return .systemGray2
            case .systemGray3: return .systemGray3
            case .systemGray4: return .systemGray4
            case .systemGray5: return .systemGray5
            case .systemGray6: return .systemGray6
            case .label: return .label
            case .secondaryLabel: return .secondaryLabel
            case .tertiaryLabel: return .tertiaryLabel
            case .quaternaryLabel: return .quaternaryLabel
            case .link: return .link
            case .placeholderText: return .placeholderText
            case .separator: return .separator
            case .opaqueSeparator: return .opaqueSeparator
            case .systemBackground: return .systemBackground
            case .secondarySystemBackground: return .secondarySystemBackground
            case .tertiarySystemBackground: return .tertiarySystemBackground
            case .systemGroupedBackground: return .systemGroupedBackground
            case .secondarySystemGroupedBackground: return .secondarySystemGroupedBackground
            case .tertiarySystemGroupedBackground: return .tertiarySystemGroupedBackground
            case .systemFill: return .systemFill
            case .secondarySystemFill: return .secondarySystemFill
            case .tertiarySystemFill: return .tertiarySystemFill
            case .quaternarySystemFill: return .quaternarySystemFill
            }
        }
    }
}

private func tfy_rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
}
