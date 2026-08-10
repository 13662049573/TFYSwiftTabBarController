//
//  DemoPlusButtons.swift
//  TFYSwiftTabBarController
//
//  Plus 中间按钮示范：纯动作 / 带 Child VC
//

import UIKit

/// 仅中间动作（弹窗），不占用 Tab 子控制器
@available(iOS 15.0, *)
final class DemoActionPlusButton: TFYSwiftPlusButton, TFYSwiftPlusButtonSubclassing {

    static let contextKey = "DemoActionPlus"

    static func plusButton() -> Any {
        let button = DemoActionPlusButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        button.accessibilityIdentifier = "demo.plus.action"
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemOrange)
        button.setImage(image, for: .normal)
        button.addTarget(button, action: #selector(onTap), for: .touchUpInside)
        return button
    }

    static func tabBarContext() -> String { contextKey }

    static func multiplierOfTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat { 0.35 }

    static func constantOfPlusButtonCenterYOffsetForTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat { -8 }

    @objc private func onTap() {
        let alert = UIAlertController(title: "Plus", message: "中间按钮动作（无 Child VC）", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好的", style: .default))
        tfy_tabBarController?.present(alert, animated: true)
    }
}

/// 中间按钮对应一个真实 Tab 子控制器
@available(iOS 15.0, *)
final class DemoChildPlusButton: TFYSwiftPlusButton, TFYSwiftPlusButtonSubclassing {

    static let contextKey = "DemoChildPlus"

    static func plusButton() -> Any {
        let button = DemoChildPlusButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        button.accessibilityIdentifier = "demo.plus.child"
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        let image = UIImage(systemName: "camera.circle.fill", withConfiguration: config)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemPink)
        button.setImage(image, for: .normal)
        return button
    }

    static func indexOfPlusButtonInTabBar() -> UInt { 2 }

    static func plusChildViewController() -> UIViewController {
        let page = DemoInfoViewController(
            titleText: "发布",
            detail: "这是 PlusChildViewController，点击中间按钮会选中本页。\n实现：plusChildViewController + indexOfPlusButtonInTabBar。"
        )
        return TFYSwiftBaseNavigationController(rootViewController: page)
    }

    static func shouldSelectPlusChildViewController() -> Bool { true }

    static func tabBarContext() -> String { contextKey }

    static func multiplierOfTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat { 0.35 }

    static func constantOfPlusButtonCenterYOffsetForTabBarHeight(_ tabBarHeight: CGFloat) -> CGFloat { -10 }
}
