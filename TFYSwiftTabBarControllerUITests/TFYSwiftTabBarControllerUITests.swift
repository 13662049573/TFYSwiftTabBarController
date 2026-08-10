//
//  TFYSwiftTabBarControllerUITests.swift
//  TFYSwiftTabBarControllerUITests
//
//  Created by 田风有 on 2021/5/5.
//

import XCTest

class TFYSwiftTabBarControllerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["TFYSwiftTabbarKit"].waitForExistence(timeout: 3))
    }

    func testBasicDemoCanOpenAndClose() throws {
        let app = XCUIApplication()
        app.launch()

        app.staticTexts["基础四 Tab"].tap()
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["demo.close"].waitForExistence(timeout: 3))
        app.buttons["demo.close"].tap()
        XCTAssertTrue(app.navigationBars["TFYSwiftTabbarKit"].waitForExistence(timeout: 3))
    }

    func testEveryDemoCanOpenWithoutCrashing() throws {
        let app = XCUIApplication()
        app.launch()
        let titles = [
            "基础四 Tab", "System 风格", "Liquid Glass", "代理与动态配置", "Item 布局偏移", "外观定制",
            "Plus 仅动作", "Plus + Child VC", "徽章全能力",
            "Lottie Tab · 灰色图片型", "Lottie Tab · 绿色", "Lottie Tab · 彩色", "Lottie 资源实验室",
            "Flat 独立组件", "Flat styleType", "Push 隐藏 TabBar", "高级组合"
        ]

        for title in titles {
            let row = app.staticTexts[title]
            while !row.isHittable { app.tables.firstMatch.swipeUp() }
            row.tap()
            XCTAssertTrue(app.buttons["demo.close"].waitForExistence(timeout: 3), "无法打开或关闭：\(title)")
            app.buttons["demo.close"].tap()
            XCTAssertTrue(app.navigationBars["TFYSwiftTabbarKit"].waitForExistence(timeout: 3))
        }
    }

    func testLottieResourceLabControls() throws {
        let app = XCUIApplication()
        app.launch()
        let row = app.staticTexts["Lottie 资源实验室"]
        while !row.isHittable { app.tables.firstMatch.swipeUp() }
        row.tap()

        XCTAssertTrue(app.buttons["lottie.resource"].waitForExistence(timeout: 3))
        app.buttons["lottie.resource"].tap()
        let lastResource = app.buttons["tab_me_animate"]
        XCTAssertTrue(lastResource.waitForExistence(timeout: 3))
        lastResource.tap()
        app.buttons["lottie.pause"].tap()
        app.sliders["lottie.progress"].adjust(toNormalizedSliderPosition: 0.5)
        app.buttons["lottie.play"].tap()
        app.buttons["lottie.stop"].tap()
    }

    func testEveryLottieTabUsesRealAnimationsAndCanSwitchTabs() throws {
        let app = XCUIApplication()
        app.launch()
        let demos: [(String, [String])] = [
            ("Lottie Tab · 灰色图片型", ["首页", "消息", "我的"]),
            ("Lottie Tab · 绿色", ["首页", "发现", "资讯", "我的"]),
            ("Lottie Tab · 彩色", ["首页", "搜索", "消息", "我的"])
        ]

        for (demoTitle, tabTitles) in demos {
            let row = app.staticTexts[demoTitle]
            while !row.isHittable { app.tables.firstMatch.swipeUp() }
            row.tap()

            let animation = app.descendants(matching: .any)
                .matching(identifier: "tfy.tabbar.lottie")
                .firstMatch
            XCTAssertTrue(animation.waitForExistence(timeout: 3), "未加载真实 Lottie Tab：\(demoTitle)")
            let tabBar = app.tabBars.firstMatch
            for title in tabTitles {
                let button = tabBar.buttons[title]
                XCTAssertTrue(button.waitForExistence(timeout: 2), "缺少 Tab：\(title)")
                button.tap()
            }

            app.buttons["demo.close"].tap()
            XCTAssertTrue(app.navigationBars["TFYSwiftTabbarKit"].waitForExistence(timeout: 3))
        }
    }

    func testBothPlusModesAreVisibleAndClickable() throws {
        let app = XCUIApplication()
        app.launch()

        app.staticTexts["Plus 仅动作"].tap()
        let actionPlus = app.buttons["demo.plus.action"]
        XCTAssertTrue(actionPlus.waitForExistence(timeout: 3))
        actionPlus.tap()
        XCTAssertTrue(app.alerts["Plus"].waitForExistence(timeout: 2))
        app.alerts["Plus"].buttons["好的"].tap()
        app.buttons["demo.close"].tap()

        app.staticTexts["Plus + Child VC"].tap()
        let childPlus = app.buttons["demo.plus.child"]
        XCTAssertTrue(childPlus.waitForExistence(timeout: 3))
        childPlus.tap()
        XCTAssertTrue(app.navigationBars["发布"].waitForExistence(timeout: 2))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
