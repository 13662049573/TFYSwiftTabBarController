//
//  TFYSwiftTabBarControllerUITests.swift
//  TFYSwiftTabBarControllerUITests
//
//  Demo 入口：DemoRootNavigationController → MainTabBarController
//

import XCTest

final class TFYSwiftTabBarControllerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunchShowsMainTabs() throws {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        XCTAssertTrue(tabBar.buttons["首页"].waitForExistence(timeout: 2))
        XCTAssertTrue(tabBar.buttons["同城"].exists)
        XCTAssertTrue(tabBar.buttons["消息"].exists)
        XCTAssertTrue(tabBar.buttons["我的"].exists)
    }

    func testSwitchingTabsDoesNotCrash() throws {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        for title in ["同城", "消息", "我的", "首页"] {
            let button = tabBar.buttons[title]
            XCTAssertTrue(button.waitForExistence(timeout: 2), "缺少 Tab：\(title)")
            button.tap()
        }
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
