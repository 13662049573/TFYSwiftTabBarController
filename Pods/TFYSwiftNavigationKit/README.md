# TFYSwiftNavigationKit

[![Version](https://img.shields.io/cocoapods/v/TFYSwiftNavigationKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftNavigationKit)
[![License](https://img.shields.io/cocoapods/l/TFYSwiftNavigationKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftNavigationKit)
[![Platform](https://img.shields.io/cocoapods/p/TFYSwiftNavigationKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftNavigationKit)

TFYSwiftNavigationKit 是一个强大的 Swift 导航栏管理库，让你能够轻松实现各种自定义导航栏效果。支持 iOS 15+ 和 Swift 5。

## 特性

- [x] 完全自定义导航栏样式
- [x] 支持渐变色导航栏
- [x] 支持导航栏背景图片
- [x] 支持导航栏透明度调节
- [x] 支持修改导航栏标题样式
- [x] 支持自定义返回按钮
- [x] 支持控制手势返回
- [x] 支持导航栏阴影设置
- [x] 支持每个页面独立设置导航栏样式
- [x] 完美支持 Push/Pop 过渡动画
- [x] 支持 UINavigationBar.appearance() 全局设置

## 要求

- iOS 15.0+
- Swift 5.0+
- Xcode 13.0+

## 安装

### CocoaPods

```ruby
pod 'TFYSwiftNavigationKit'
```

## 使用方法

### 基本设置

1. 首先继承 TFYSwiftNavigationController：

```swift
class NavigationController: TFYSwiftNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

### 自定义导航栏样式

```swift
// 设置导航栏背景色
viewController.tfy_backgroundColor = .white

// 设置导航栏透明度
viewController.tfy_barAlpha = 0.5

// 设置标题颜色
viewController.tfy_titleColor = .black

// 设置标题字体
viewController.tfy_titleFont = .boldSystemFont(ofSize: 18)

// 设置导航栏按钮颜色
viewController.tfy_tintColor = .blue

// 隐藏导航栏底部分割线
viewController.tfy_shadowHidden = true

// 设置导航栏背景图片
viewController.tfy_backgroundImage = UIImage(named: "nav_bg")

// 控制手势返回
viewController.tfy_enablePopGesture = true
```

### 动态更新导航栏

```swift
// 更新所有导航栏属性
viewController.tfy_setNeedsNavigationBarUpdate()

// 仅更新导航栏颜色
viewController.tfy_setNeedsNavigationBarTintUpdate()

// 仅更新导航栏背景
viewController.tfy_setNeedsNavigationBarBackgroundUpdate()

// 仅更新导航栏阴影
viewController.tfy_setNeedsNavigationBarShadowUpdate()
```

## 高级特性

### 全局设置

```swift
let navBar = UINavigationBar.appearance()
navBar.tintColor = .black
navBar.barTintColor = .white
navBar.titleTextAttributes = [
    .foregroundColor: UIColor.black,
    .font: UIFont.boldSystemFont(ofSize: 17)
]
```

### 渐变导航栏

支持在页面切换时平滑过渡导航栏样式，包括背景色、透明度等属性。

## 示例

查看示例项目，了解如何使用 TFYSwiftNavigationKit 的所有特性。克隆仓库并运行 `pod install`。

## 作者

田风有 (13662049573)，420144542@qq.com

## 许可证

TFYSwiftNavigationKit 基于 MIT 许可证开源。详见 LICENSE 文件。
