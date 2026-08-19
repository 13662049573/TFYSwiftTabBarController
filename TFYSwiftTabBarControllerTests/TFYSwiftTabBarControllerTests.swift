//
//  TFYSwiftTabBarControllerTests.swift
//  TFYSwiftTabBarControllerTests
//
//  核心逻辑自检：风格枚举、属性键、Lottie 开关、控制器组装
//

import XCTest
@testable import TFYSwiftTabBarController

@available(iOS 15.0, *)
final class TFYSwiftTabBarControllerTests: XCTestCase {

    func testTabBarStyleTypeRawValues() {
        XCTAssertEqual(TFYSwiftTabBarStyleType.default.rawValue, 0)
        XCTAssertEqual(TFYSwiftTabBarStyleType.system.rawValue, 1)
        XCTAssertEqual(TFYSwiftTabBarStyleType.flatDesign.rawValue, 2)
        XCTAssertEqual(TFYSwiftTabBarStyleType.liquidGlass.rawValue, 3)
    }

    func testAttributeKeys() {
        XCTAssertEqual(TFYSwiftTabBarItemTitle, "TFYSwiftTabBarItemTitle")
        XCTAssertEqual(TFYSwiftTabBarItemImage, "TFYSwiftTabBarItemImage")
        XCTAssertEqual(TFYSwiftTabBarItemSelectedImage, "TFYSwiftTabBarItemSelectedImage")
        XCTAssertEqual(TFYSwiftTabBarLottieFilePath, "TFYSwiftTabBarLottieFilePath")
        XCTAssertEqual(TFYSwiftTabBarLottieURL, "TFYSwiftTabBarLottieURL")
    }

    func testIsLottieEnabled() {
        XCTAssertFalse(TFYSwiftConstants.isLottieEnabled(fromLottieURLs: nil, tabBarItemsAttributes: nil))
        XCTAssertFalse(TFYSwiftConstants.isLottieEnabled(fromLottieURLs: nil, tabBarItemsAttributes: [[:]]))
        XCTAssertTrue(
            TFYSwiftConstants.isLottieEnabled(
                fromLottieURLs: nil,
                tabBarItemsAttributes: [[TFYSwiftTabBarLottieFilePath: "/tmp/tab.json"]]
            )
        )
        XCTAssertTrue(
            TFYSwiftConstants.isLottieEnabled(
                fromLottieURLs: NSMutableArray(object: "https://example.com/a.json"),
                tabBarItemsAttributes: nil
            )
        )
    }

    func testBadgeAnimationTypeRawValues() {
        XCTAssertEqual(TFYSwiftBadgeAnimationType.none.rawValue, 0)
        XCTAssertEqual(TFYSwiftBadgeAnimationType.scale.rawValue, 1)
        XCTAssertEqual(TFYSwiftBadgeAnimationType.shake.rawValue, 2)
        XCTAssertEqual(TFYSwiftBadgeAnimationType.bounce.rawValue, 3)
        XCTAssertEqual(TFYSwiftBadgeAnimationType.scaleOnce.rawValue, 8)
    }

    func testTabBarControllerKeepsAttributes() {
        let first = UIViewController()
        let second = UIViewController()
        let attributes: [[AnyHashable: Any]] = [
            [TFYSwiftTabBarItemTitle: "A"],
            [TFYSwiftTabBarItemTitle: "B"],
        ]
        let tab = TFYSwiftTabBarController(
            viewControllers: [first, second],
            tabBarItemsAttributes: attributes
        )
        XCTAssertEqual(tab.tabBarItemsAttributes.count, 2)
        XCTAssertEqual(tab.tabBarItemsAttributes[0][TFYSwiftTabBarItemTitle] as? String, "A")
        XCTAssertGreaterThanOrEqual(tab.viewControllers?.count ?? 0, 2)
    }
}
