# TFYSwiftTabBarController

<div align="center">
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/logo.png" width="200" alt="TFYSwiftTabBarController"/>
    <br>
    <h3>🚀 高度自定义的 iOS TabBar 控制器</h3>
    <p>一个优雅、强大且功能丰富的 Swift TabBar 框架，让你的应用拥有独特的 TabBar 体验</p>
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
    <a href="https://github.com/13662049573/TFYSwiftTabBarController/network">
        <img src="https://img.shields.io/github/forks/13662049573/TFYSwiftTabBarController.svg?style=flat-square" alt="Forks"/>
    </a>
</div>

---

## ✨ 核心特性

<div align="center">
    <table>
        <tr>
            <td align="center">
                <b>🎨 完全自定义</b><br>
                <small>支持自定义样式、布局、颜色等</small>
            </td>
            <td align="center">
                <b>🔔 灵活角标</b><br>
                <small>支持数字角标、小红点、自定义样式</small>
            </td>
            <td align="center">
                <b>📱 多种布局</b><br>
                <small>提供填充、居中、分隔等多种布局</small>
            </td>
        </tr>
        <tr>
            <td align="center">
                <b>🎯 事件拦截</b><br>
                <small>支持点击事件拦截和自定义处理</small>
            </td>
            <td align="center">
                <b>💫 丰富动画</b><br>
                <small>内置多种切换动画，支持自定义</small>
            </td>
            <td align="center">
                <b>📐 自适应布局</b><br>
                <small>完美支持横竖屏切换</small>
            </td>
        </tr>
        <tr>
            <td align="center">
                <b>🔄 More 模式</b><br>
                <small>支持原生"更多"导航模式</small>
            </td>
            <td align="center">
                <b>⚡️ 高性能</b><br>
                <small>采用高效渲染，确保流畅体验</small>
            </td>
            <td align="center">
                <b>♿ 可访问性</b><br>
                <small>完整的 VoiceOver 支持</small>
            </td>
        </tr>
    </table>
</div>

## 📱 效果预览

<div align="center">
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/preview1.gif" width="200" alt="预览1"/>
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/preview2.gif" width="200" alt="预览2"/>
    <img src="https://raw.githubusercontent.com/13662049573/TFYSwiftTabBarController/master/Assets/preview3.gif" width="200" alt="预览3"/>
</div>

## 🚀 快速开始

### 📋 系统要求

- **iOS 15.0+**
- **Swift 5.0+**
- **Xcode 13.0+**

### 📦 安装方式

#### CocoaPods

```ruby
# Podfile
pod 'TFYSwiftTabbarKit'
```

```bash
# 终端执行
pod install
```

#### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYSwiftTabBarController.git", .upToNextMajor(from: "2.0.6"))
]
```

### 🎯 基础使用

```swift
import TFYSwiftTabbarKit

class TabBarController: TFYSwiftTabbarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建视图控制器
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

## 🎨 高级功能

### 自定义样式

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

### 角标设置

```swift
// 数字角标
item.badgeValue = "99+"

// 小红点
item.badgeValue = ""

// 自定义角标样式
item.badgeColor = .systemRed
```

### 事件拦截

```swift
// 设置事件拦截
tabBarController.shouldHijackHandler = { tabBarController, viewController, index in
    // 拦截特定 Tab 的点击
    return index == 1
}

tabBarController.didHijackHandler = { tabBarController, viewController, index in
    // 处理被拦截的事件
    print("Tab \(index) 被拦截了！")
}
```

### 动画效果

```swift
class AnimatedTabBarItemView: TFYSwiftTabBarItemContentView {
    override func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform.identity
                }) { _ in
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }
}
```

## 📚 功能演示

我们提供了完整的功能演示，包括：

- 🏠 **基础TabBar** - 展示基础的TabBar功能
- 🎨 **自定义TabBar** - 展示自定义样式的TabBar
- 🔔 **徽章功能** - 展示徽章显示和管理功能
- 💫 **动画效果** - 展示丰富的动画和交互效果
- 🎯 **事件劫持** - 展示自定义点击事件处理
- 🔄 **More按钮** - 展示自定义More按钮样式
- 📐 **响应式布局** - 展示不同屏幕尺寸和方向的适配

## 🛠️ 最新优化 (2024年)

### 🚀 代码质量优化

- ✅ **添加MARK注释** - 为所有类添加清晰的MARK注释分组
- ✅ **方法重构** - 将复杂方法拆分为更小、更专注的方法
- ✅ **命名规范** - 统一命名规范，提高代码可读性
- ✅ **注释完善** - 为所有公共API添加详细注释

### ⚡ 性能优化

- ✅ **懒加载** - 使用`lazy var`优化内存使用
- ✅ **方法优化** - 减少重复计算和不必要的对象创建
- ✅ **布局优化** - 优化布局计算逻辑，提高渲染性能
- ✅ **内存管理** - 改进内存管理，避免循环引用

### 🔧 可维护性提升

- ✅ **模块化设计** - 将复杂功能拆分为独立模块
- ✅ **单一职责** - 每个类和方法只负责单一功能
- ✅ **依赖注入** - 改进组件间的依赖关系
- ✅ **错误处理** - 增强错误处理和边界条件检查

## 📊 优化效果对比

| 指标 | 优化前 | 优化后 | 改进 |
|------|--------|--------|------|
| 代码可读性 | 一般 | 优秀 | 大幅提升 |
| 方法复杂度 | 高 | 低 | 显著降低 |
| 内存使用 | 一般 | 优化 | 更高效 |
| 可维护性 | 一般 | 优秀 | 大幅提升 |
| 性能 | 一般 | 优化 | 更流畅 |

## 🤝 社区贡献

我们欢迎所有形式的贡献！

### 贡献方式

1. **⭐ Star 项目** - 如果这个项目对你有帮助，请给我们一个 Star
2. **🐛 报告 Bug** - 在 [Issues](https://github.com/13662049573/TFYSwiftTabBarController/issues) 中报告问题
3. **💡 提出建议** - 在 [Discussions](https://github.com/13662049573/TFYSwiftTabBarController/discussions) 中分享想法
4. **🔧 提交代码** - 通过 Pull Request 贡献代码

### 贡献指南

1. Fork 本项目
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的改动 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 👨‍💻 作者信息

**田风有** - iOS 开发工程师

- 📧 **Email**: 420144542@qq.com
- 💬 **微信**: 13662049573
- 📱 **博客**: [掘金主页](https://juejin.cn/user/你的掘金ID)
- 🐦 **GitHub**: [@13662049573](https://github.com/13662049573)

## 📄 开源协议

TFYSwiftTabBarController 基于 **MIT 许可证** 开源。

详细内容请查看 [LICENSE](LICENSE) 文件。

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=13662049573/TFYSwiftTabBarController&type=Date)](https://star-history.com/#13662049573/TFYSwiftTabBarController&Date)

## 📞 联系我们

如果你有任何问题或建议，欢迎通过以下方式联系我们：

- 📧 **邮箱**: 420144542@qq.com
- 💬 **微信**: 13662049573
- 🐛 **Issues**: [GitHub Issues](https://github.com/13662049573/TFYSwiftTabBarController/issues)

---

<div align="center">
    <p>如果这个项目对你有帮助，请给我们一个 ⭐ Star</p>
    <p>Made with ❤️ by 田风有</p>
</div>
