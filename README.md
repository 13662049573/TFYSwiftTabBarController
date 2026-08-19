# TFYSwiftTabBarController

<div align="center">
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/logo.png" width="200" alt="TFYSwiftTabBarController"/>
    <br>
    <h3>Swift TabBar 控制器</h3>
    <p>中间 Plus、角标、扁平自定义栏、Lottie、iOS 26 Liquid Glass</p>
</div>

<div align="center">
    <a href="https://cocoapods.org/pods/TFYSwiftTabbarKit">
        <img src="https://img.shields.io/cocoapods/v/TFYSwiftTabbarKit.svg?style=flat-square" alt="Version"/>
    </a>
    <a href="https://cocoapods.org/pods/TFYSwiftTabbarKit">
        <img src="https://img.shields.io/cocoapods/l/TFYSwiftTabbarKit.svg?style=flat-square" alt="License"/>
    </a>
    <a href="https://cocoapods.org/pods/TFYSwiftTabbarKit">
        <img src="https://img.shields.io/cocoapods/p/TFYSwiftTabbarKit.svg?style=flat-square" alt="Platform"/>
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/Swift-5.0+-orange.svg?style=flat-square" alt="Swift 5.0+"/>
    </a>
    <a href="https://developer.apple.com/ios/">
        <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg?style=flat-square" alt="iOS 15.0+"/>
    </a>
    <a href="https://github.com/13662049573/TFYSwiftTabBarController/stargazers">
        <img src="https://img.shields.io/github/stars/13662049573/TFYSwiftTabBarController.svg?style=flat-square" alt="Stars"/>
    </a>
</div>

---

## 核心能力

- **四种栏样式**：`default` / `system` / `flatDesign` / `liquidGlass`（iOS 26）
- **中间 Plus 按钮**：凸起按钮、可挂 Child VC，或只做动作
- **角标**：数字、红点、文字；呼吸 / 抖动 / 弹跳等动画；Tab、UIView、UIBarButtonItem 通用
- **扁平自定义 TabBar**：独立 `TFYSwiftFlatDesignTabBar`，可与系统 UITabBar 对照
- **Lottie Tab 动画**：属性字典里带 `TFYSwiftTabBarLottieFilePath` 即可
- **导航辅助**：Push 隐藏栏、禁侧滑、隐藏导航分隔线

库模块名是 **`TFYSwiftTabbarKit`**。本仓库的 Example App 把 Kit 编进 App target，所以 Demo 里写的是 `import TFYSwiftTabBarController`。

## 系统要求

- iOS 15.0+
- Swift 5.0+
- Xcode 16.0+（含 iOS 26 SDK 才能编 Liquid Glass / `UIScrollEdgeElementContainerInteraction`）
- 依赖 [lottie-ios](https://github.com/airbnb/lottie-ios) 4.0+

## 安装

### CocoaPods

```ruby
pod 'TFYSwiftTabbarKit', '~> 2.0.7'
```

```bash
pod install
```

### Swift Package Manager

Xcode：File → Add Package Dependencies，填：

`https://github.com/13662049573/TFYSwiftTabBarController.git`

或在 `Package.swift` 里：

```swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYSwiftTabBarController.git", .upToNextMajor(from: "2.0.7"))
]
```

然后把 `TFYSwiftTabbarKit` 加到 target 的 `dependencies`。

## 基础用法

```swift
import TFYSwiftTabbarKit
import UIKit

final class MainTabBarController: TFYSwiftTabBarController {

    convenience init() {
        let home = TFYSwiftBaseNavigationController(rootViewController: HomeViewController())
        let mine = TFYSwiftBaseNavigationController(rootViewController: MineViewController())
        self.init(
            viewControllers: [home, mine],
            tabBarItemsAttributes: [
                [
                    TFYSwiftTabBarItemTitle: "首页",
                    TFYSwiftTabBarItemImage: UIImage(systemName: "house") as Any,
                    TFYSwiftTabBarItemSelectedImage: UIImage(systemName: "house.fill") as Any,
                ],
                [
                    TFYSwiftTabBarItemTitle: "我的",
                    TFYSwiftTabBarItemImage: UIImage(systemName: "person") as Any,
                    TFYSwiftTabBarItemSelectedImage: UIImage(systemName: "person.fill") as Any,
                ],
            ],
            imageInsets: .zero,
            titlePositionAdjustment: UIOffset(horizontal: 0, vertical: -3.5),
            styleType: .default,
            context: nil
        )
    }
}
```

`AppDelegate` 里如果要用 Lottie Tab，先注册运行时工厂：

```swift
TFYSwiftCompatibleLOTAnimation.loadRuntime()
```

启动时把 `MainTabBarController` 设成窗口根控制器（或包一层导航）。

### 属性字典键

| 键 | 含义 |
| --- | --- |
| `TFYSwiftTabBarItemTitle` | 标题 |
| `TFYSwiftTabBarItemImage` | 普通图（`UIImage` 或图片名 `String`） |
| `TFYSwiftTabBarItemSelectedImage` | 选中图 |
| `TFYSwiftTabBarLottieFilePath` | 本地 Lottie JSON 路径 |
| `TFYSwiftTabBarLottieURL` | Lottie 资源 URL |
| `TFYSwiftTabBarLottieSize` | Lottie 尺寸 `NSValue(cgSize:)` |

## 中间 Plus 按钮

子类化 `TFYSwiftPlusButton` 并实现 `TFYSwiftPlusButtonSubclassing`，在启动时注册：

```swift
final class PlusButtonSubclass: TFYSwiftPlusButton, TFYSwiftPlusButtonSubclassing {
    static func plusButton() -> Any { /* 配置按钮 */ }
    static func indexOfPlusButtonInTabBar() -> UInt { 2 }
    static func plusChildViewController() -> UIViewController {
        TFYSwiftBaseNavigationController(rootViewController: PublishViewController())
    }
    static func shouldSelectPlusChildViewController() -> Bool { true }
}

PlusButtonSubclass.registerPlusButton()
```

不提供 `plusChildViewController` 时，Plus 只占位，点击走 `didSelectControl`。

## 角标

```swift
child.tfy_showBadgeValue("99", animationType: .bounce)
child.tfy_showBadgeValue("", animationType: .shake)   // 红点
child.tfy_clearBadge()
child.tfy_resumeBadge()

navigationItem.rightBarButtonItem?.tfy_showBadgeValue("5", animationType: .scaleOnce)
```

常用外观：`tfy_badgeBackgroundColor`、`tfy_badgeTextColor`、`tfy_badgeCenterOffset`、`tfy_badgeRadius`、`tfy_badgeMaximumBadgeNumber`。

## 样式切换

```swift
tab.tabBarStyleType = .flatDesign   // 或 .liquidGlass / .system / .default
tab.tabBarHeight = 49
tab.setTabBarHidden(true, animated: true)
tab.hideTabBarShadowImageView()
```

扁平栏下 Item 用 `TFYSwiftFlatDesignTabBarItem`（`layoutCentered`、`backgroundColor` 等）。也可单独用 `TFYSwiftFlatDesignTabBar` 当普通视图。

## 点击与跳转

```swift
func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    updateSelectionStatusIfNeeded(for: tabBarController, shouldSelectViewController: viewController)
    return true
}

func tabBarController(_ tabBarController: TFYSwiftTabBarController, didSelectControl control: UIControl) {
    // Plus 按钮也会走到这里
}

_ = tfy_popSelectTabBarChildViewController(for: MineViewController.self)
_ = tfy_popSelectTabBarChildViewController(at: 0, animated: true)
```

Push 时：

```swift
detail.tfy_hidesBottomBarWhenPushed = true
detail.tfy_navigationBarHidden = true
detail.tfy_disablePopGestureRecognizer = true
navigationController?.pushViewController(detail, animated: true)
```

## Example

打开 `TFYSwiftTabBarController.xcworkspace`（不要只开 `.xcodeproj`，Demo 依赖 CocoaPods 的 Lottie / NavigationKit）。

Demo 入口是 `DemoRootNavigationController` → `MainTabBarController`：首页是全量 API 目录，同城 / 消息 / 我的 / 中间 Plus「发布」对照原版 CYL 动作。摇一摇给当前 Tab 打角标。

## 目录

```
TFYSwiftTabBarController/TFYSwiftTabbarKit/
  Core/          控制器、自定义 UITabBar、Plus、常量
  Badge/         角标
  FlatDesign/    扁平栏
  Lottie/        Compatible Lottie 包装
  Extensions/    UIKit 扩展、KVC 辅助
  include/       ObjC KVC catch 头文件（Swift 捕不到 NSException）
  TFYSwiftKVCCatch.m
```

## 许可

MIT。作者 田风有 · 420144542@qq.com · [GitHub](https://github.com/13662049573)
