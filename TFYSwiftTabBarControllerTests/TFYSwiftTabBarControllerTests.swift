//
//  TFYSwiftTabBarControllerTests.swift
//  TFYSwiftTabBarControllerTests
//
//  核心逻辑自检：风格判断、控制器组装、徽章 API、示范工厂
//

import XCTest
@testable import TFYSwiftTabBarController

@available(iOS 15.0, *)
final class TFYSwiftTabBarControllerTests: XCTestCase {

    override func tearDown() {
        TFYSwiftPlusButton.removePlusButton()
        super.tearDown()
    }

    @MainActor
    func testStyleHelpersDoNotRecurse() {
        let tab = DemoSupport.makeTab(style: .default, detail: "test")
        XCTAssertTrue(tab.tfy_isSystemStyleTabBar())
        XCTAssertFalse(tab.tfy_isFlatDesignStyleTabBar())

        let flat = DemoSupport.makeTab(style: .flatDesign, detail: "flat")
        XCTAssertFalse(flat.tfy_isSystemStyleTabBar())
        XCTAssertTrue(flat.tfy_isFlatDesignStyleTabBar())
    }

    @MainActor
    func testBasicTabHasFourChildren() {
        TFYSwiftPlusButton.removePlusButton()
        XCTAssertEqual(DemoSupport.standardFourAttrs().count, 4)
        let tab = DemoFactories.basicDefault() as! TFYSwiftTabBarController
        tab.loadViewIfNeeded()
        // 子控制器与 attributes 始终对齐；Liquid Glass / Plus 路径可能插入占位项
        XCTAssertEqual(tab.viewControllers?.count, tab.tabBarItemsAttributes.count)
        XCTAssertGreaterThanOrEqual(tab.viewControllers?.count ?? 0, 4)
        XCTAssertEqual(tab.tabBarStyleType, .default)
    }

    @MainActor
    func testBadgeAPIsOnViewController() {
        let tab = DemoSupport.makeTab(style: .default, detail: "badge")
        tab.loadViewIfNeeded()
        let host = tab.viewControllers![0].tfy_getViewControllerInsteadOfNavigationController()
        host.tfy_showBadge()
        host.tfy_showBadgeValue("5", animationType: .bounce)
        host.tfy_clearBadge()
        host.tfy_resumeBadge()
        XCTAssertNotNil(host.tabBarItem)
    }

    @MainActor
    func testPlusActionRegistration() {
        DemoActionPlusButton.registerPlusButton()
        XCTAssertNotNil(TFYSwiftExternPlusButton)
        XCTAssertNil(TFYSwiftPlusChildViewController)
        TFYSwiftPlusButton.removePlusButton()
        XCTAssertNil(TFYSwiftExternPlusButton)
    }

    @MainActor
    func testPlusChildRegistration() {
        DemoChildPlusButton.registerPlusButton()
        XCTAssertNotNil(TFYSwiftExternPlusButton)
        XCTAssertNotNil(TFYSwiftPlusChildViewController)
        XCTAssertEqual(TFYSwiftPlusButtonIndex, 2)
    }

    @MainActor
    func testPlusFactoriesActuallyAttachTheirRegisteredButton() {
        let actionTab = DemoFactories.plusActionOnly() as! TFYSwiftTabBarController
        actionTab.loadViewIfNeeded()
        XCTAssertTrue(actionTab.hasPlusButton())
        XCTAssertNotNil((actionTab.tfy_cylTabBar as? TFYSwiftTabBar)?.plusButton)

        TFYSwiftPlusButton.removePlusButton()
        let childTab = DemoFactories.plusWithChild() as! TFYSwiftTabBarController
        childTab.loadViewIfNeeded()
        XCTAssertTrue(childTab.hasPlusButton())
        XCTAssertNotNil(TFYSwiftPlusChildViewController)
        XCTAssertEqual(childTab.allItemsInTabBarCount(), 5)
    }

    @MainActor
    func testDemoRootKeepsCloseBarButton() {
        let tab = DemoFactories.basicDefault()
        DemoSupport.injectCloseButton(into: tab)
        XCTAssertNotNil(tab.navigationItem.leftBarButtonItem)
        let nav = UINavigationController(rootViewController: tab)
        nav.loadViewIfNeeded()
        XCTAssertNotNil(nav.topViewController?.navigationItem.leftBarButtonItem)
    }

    @MainActor
    func testAttributeKeysRoundTrip() {
        let attrs = DemoSupport.attrs(title: "首页", image: "home", selectedImage: "home_1")
        XCTAssertEqual(attrs[TFYSwiftTabBarItemTitle] as? String, "首页")
        XCTAssertEqual(attrs[TFYSwiftTabBarItemImage] as? String, "home")
        XCTAssertEqual(attrs[TFYSwiftTabBarItemSelectedImage] as? String, "home_1")
    }

    func testEveryLottieDemoResourceExists() {
        XCTAssertEqual(DemoSupport.lottieResourceNames.count, 11)
        DemoSupport.lottieResourceNames.forEach { name in
            XCTAssertNotNil(Bundle.main.path(forResource: name, ofType: "json"), "缺少 \(name).json")
        }
        XCTAssertEqual(DemoSupport.lottieImageResourceNames.count, 7)
        DemoSupport.lottieImageResourceNames.forEach { name in
            XCTAssertNotNil(Bundle.main.path(forResource: name, ofType: "png"), "缺少 \(name).png")
        }
        let paths = DemoSupport.standardFourAttrs(lottie: true).compactMap {
            $0[TFYSwiftTabBarLottieFilePath] as? String
        }
        XCTAssertEqual(paths.count, 4)
        XCTAssertEqual(Set(paths).count, 4)
    }

    @MainActor
    func testLottieTabCreatesOneAnimationViewPerItem() async throws {
        let factories: [() -> UIViewController] = [
            DemoFactories.grayLottieTabs,
            DemoFactories.lottieTabs,
            DemoFactories.colorLottieTabs
        ]
        for factory in factories {
            let tab = factory() as! TFYSwiftTabBarController
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = tab
            window.makeKeyAndVisible()
            tab.loadViewIfNeeded()
            tab.view.layoutIfNeeded()
            try await Task.sleep(nanoseconds: 300_000_000)

            let controls = tab.viewControllers?.compactMap(\.tfy_tabButton) ?? []
            XCTAssertEqual(controls.compactMap { $0.tfy_lottieAnimationView() }.count, controls.count)
        }
    }

    @MainActor
    func testPartiallyConfiguredLottieTabsDoNotMisalignOrCrash() async throws {
        let attrs = [
            DemoSupport.attrs(title: "无动画", image: "home", selectedImage: "home_1"),
            DemoSupport.attrs(title: "有动画", image: "me", selectedImage: "me_1", lottieName: "tab_me_animate")
        ]
        let children = [
            DemoSupport.makeChild(title: "无动画", detail: ""),
            DemoSupport.makeChild(title: "有动画", detail: "")
        ]
        let tab = TFYSwiftTabBarController(viewControllers: children, tabBarItemsAttributes: attrs)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = tab
        window.makeKeyAndVisible()
        tab.loadViewIfNeeded()
        tab.view.layoutIfNeeded()
        try await Task.sleep(nanoseconds: 300_000_000)

        let controls = tab.viewControllers?.compactMap(\.tfy_tabButton) ?? []
        XCTAssertNil(controls[0].tfy_lottieAnimationView())
        XCTAssertNotNil(controls[1].tfy_lottieAnimationView())
    }

    @MainActor
    func testFlatDesignBarCreatesItems() {
        let bar = TFYSwiftFlatDesignTabBar(frame: CGRect(x: 0, y: 0, width: 375, height: 49))
        let item = bar.addItem(
            withTitle: "首页",
            tabBarItemImage: "home",
            tabBarItemSelectedImage: "home_1",
            index: 0,
            titlePositionAdjustment: .zero,
            imageInsets: .zero,
            lottieFilePath: nil,
            lottieSizeValue: nil
        )
        bar.items = [item]
        XCTAssertEqual(bar.items?.count, 1)
        XCTAssertEqual(item.title, "首页")
    }

    @MainActor
    func testEachTabBarKeepsItsOwnItemCount() {
        let first = DemoFactories.basicDefault() as! TFYSwiftTabBarController
        first.loadViewIfNeeded()
        let firstBar = first.tfy_cylTabBar as! TFYSwiftTabBar

        let children = [DemoSupport.makeChild(title: "A", detail: ""), DemoSupport.makeChild(title: "B", detail: "")]
        let attrs = [
            DemoSupport.attrs(title: "A", image: "home", selectedImage: "home_1"),
            DemoSupport.attrs(title: "B", image: "me", selectedImage: "me_1")
        ]
        let second = TFYSwiftTabBarController(viewControllers: children, tabBarItemsAttributes: attrs)
        second.loadViewIfNeeded()

        XCTAssertEqual(firstBar.tabBarItemsCount, 4)
        XCTAssertEqual((second.tfy_cylTabBar as? TFYSwiftTabBar)?.tabBarItemsCount, 2)
        XCTAssertEqual(first.allItemsInTabBarCount(), 4)
        XCTAssertEqual(second.allItemsInTabBarCount(), 2)
    }

    @MainActor
    func testUnknownUIKitViewDoesNotUseUnsafeImageViewKVC() {
        XCTAssertNil(UIView().tfy_imageViewInTabBarButton())
    }

    @MainActor
    func testHitTestingConvertsNestedImageCoordinatesIntoTabBarSpace() {
        let tabBar = TFYSwiftTabBar(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
        tabBar.clipsToBounds = false
        let container = UIView(frame: tabBar.bounds)
        container.addSubview(tabBar)
        let button = UIControl(frame: CGRect(x: 100, y: 0, width: 20, height: 49))
        let animationView = TFYSwiftCompatibleLOTAnimationView(frame: CGRect(x: 30, y: 10, width: 10, height: 10))
        button.addSubview(animationView)
        tabBar.addSubview(button)
        tabBar.tabBarButtonArray = [button]

        XCTAssertTrue(tabBar.hitTest(CGPoint(x: 135, y: 15), with: nil) === button)
    }

    @MainActor
    func testCustomHeightDoesNotLeakIntoAnotherController() {
        let originalGlobalHeight = TFYSwiftTabBarHeight
        defer { TFYSwiftTabBarHeight = originalGlobalHeight }
        TFYSwiftTabBarHeight = 0

        let custom = DemoFactories.customAppearance() as! TFYSwiftTabBarController
        XCTAssertEqual(custom.tabBarHeight, 54)
        XCTAssertEqual(TFYSwiftTabBarHeight, 0)
        let normal = DemoFactories.basicDefault() as! TFYSwiftTabBarController
        XCTAssertEqual(normal.tabBarHeight, 0)
    }

    @MainActor
    func testItemLayoutDemoAppliesAllAdjustmentKeys() {
        let tab = DemoFactories.itemLayoutAdjustments() as! TFYSwiftTabBarController
        let attributes = tab.tabBarItemsAttributes

        XCTAssertNotNil(attributes[0][TFYSwiftTabBarItemImageInsets] as? NSValue)
        XCTAssertNotNil(attributes[1][TFYSwiftTabBarItemTitlePositionAdjustment] as? NSValue)
        XCTAssertNotNil(attributes[2][TFYSwiftTabBarItemImagePositionAdjustment] as? NSValue)
    }

    @MainActor
    func testFlatStyleCanLoadAndSelectWithoutUIKitException() {
        let flat = DemoFactories.flatDesignStyleController() as! TFYSwiftTabBarController
        flat.loadViewIfNeeded()
        flat.beginAppearanceTransition(true, animated: false)
        flat.endAppearanceTransition()
        XCTAssertEqual(flat.tabBar.items?.count, 4)
        XCTAssertEqual(flat.children.count, 4)
        XCTAssertNotEqual(flat.selectedIndex, NSNotFound)
    }
}
