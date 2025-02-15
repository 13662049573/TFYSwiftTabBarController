# TFYSwiftTabBarKit

<p align="center">
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/logo.png" width="200" alt="TFYSwiftTabBarKit"/>
</p>

<p align="center">
    <a href="https://cocoapods.org/pods/TFYSwiftTabbarKit">
        <img src="https://img.shields.io/cocoapods/v/TFYSwiftTabbarKit.svg?style=flat" alt="Version"/>
    </a>
    <a href="https://cocoapods.org/pods/TFYSwiftTabbarKit">
        <img src="https://img.shields.io/cocoapods/l/TFYSwiftTabbarKit.svg?style=flat" alt="License"/>
    </a>
    <a href="https://cocoapods.org/pods/TFYSwiftTabbarKit">
        <img src="https://img.shields.io/cocoapods/p/TFYSwiftTabbarKit.svg?style=flat" alt="Platform"/>
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" alt="Swift 5.0"/>
    </a>
</p>

TFYSwiftTabBarKit 是一个优雅且功能丰富的 Swift TabBar 框架。它提供了完全自定义的 TabBar 样式、丰富的动画效果以及灵活的配置选项，让你能够轻松打造出独具特色的 TabBar 界面。

## ✨ 特性亮点

- 🎨 **完全自定义** - 支持自定义 TabBar 样式、布局、颜色等
- 🔔 **灵活的角标** - 支持数字角标、小红点、自定义角标样式
- 📱 **多种布局** - 提供填充、居中、分隔等多种布局方式
- 🎯 **事件拦截** - 支持 TabBar 点击事件的拦截和自定义处理
- 💫 **丰富动画** - 内置多种切换动画，支持自定义动画
- 📐 **自适应布局** - 完美支持横竖屏切换
- 🔄 **More 模式** - 支持原生 "更多" 导航模式
- ⚡️ **高性能** - 采用高效的渲染方式，确保流畅体验

## 📱 预览

<p align="center">
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/preview1.gif" width="200"/>
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/preview2.gif" width="200"/>
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/preview3.gif" width="200"/>
</p>

## 🔧 要求

- iOS 15.0+
- Swift 5.0+
- Xcode 13.0+

## 📦 安装

### CocoaPods

```ruby
pod 'TFYSwiftTabbarKit'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYSwiftTabBarController.git", .upToNextMajor(from: "2.0.6"))
]
```

## 🚀 快速开始

### 基础使用

```swift
import TFYSwiftTabbarKit

class TabBarController: TFYSwiftTabbarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建视图控制器和 TabBarItems
        let homeVC = HomeViewController()
        let profileVC = ProfileViewController()
        
        // 配置 TabBarItems
        let homeItem = TFYSwiftTabBarItem(
            title: "首页", 
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home_selected")
        )
        
        let profileItem = TFYSwiftTabBarItem(
            title: "我的", 
            image: UIImage(named: "profile"),
            selectedImage: UIImage(named: "profile_selected")
        )
        
        // 设置控制器
        homeVC.tabBarItem = homeItem
        profileVC.tabBarItem = profileItem
        
        viewControllers = [homeVC, profileVC]
    }
}
```

### 🎨 自定义样式

```swift
// 创建自定义样式的 TabBarItem
class CustomTabBarItemView: TFYSwiftTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置样式
        textColor = .systemGray
        iconColor = .systemGray
        highlightTextColor = .systemBlue
        highlightIconColor = .systemBlue
        
        // 自定义布局
        titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
    }
}

// 使用自定义样式
let item = TFYSwiftTabBarItem(CustomTabBarItemView())
```

### 🔔 角标设置

```swift
// 数字角标
item.badgeValue = "99+"

// 小红点
item.badgeValue = ""

// 自定义角标样式
item.badgeColor = .systemRed
```

## 📖 详细文档

查看我们的 [完整文档](https://github.com/13662049573/TFYSwiftTabBarController/wiki) 了解更多用法。

## 🎯 使用案例

<details>
<summary>点击展开案例列表</summary>

- [案例 1: 自定义动画 TabBar](https://github.com/13662049573/TFYSwiftTabBarController/wiki/Example1)
- [案例 2: 渐变色 TabBar](https://github.com/13662049573/TFYSwiftTabBarController/wiki/Example2)
- [案例 3: 不规则 TabBar](https://github.com/13662049573/TFYSwiftTabBarController/wiki/Example3)

</details>

## 👨‍💻 作者

田风有 

- Email: 420144542@qq.com
- 微信: 13662049573
- 博客: [掘金主页](https://juejin.cn/user/你的掘金ID)

## 📄 许可证

TFYSwiftTabBarKit 基于 MIT 许可证开源。详细内容请查看 [LICENSE](LICENSE) 文件。

## ⭐️ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=13662049573/TFYSwiftTabBarController&type=Date)](https://star-history.com/#13662049573/TFYSwiftTabBarController&Date)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本项目
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的改动 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request
