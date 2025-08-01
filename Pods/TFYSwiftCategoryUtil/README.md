# TFYSwiftCategoryUtil

[![Platforms](https://img.shields.io/badge/Platforms-iOS-orange.svg)](https://github.com/13662049573/TFYSwiftCategoryUtil)
[![Version](https://img.shields.io/cocoapods/v/TFYSwiftCategoryUtil.svg)](https://cocoapods.org/pods/TFYSwiftCategoryUtil)
[![License](https://img.shields.io/cocoapods/l/TFYSwiftCategoryUtil.svg)](https://github.com/13662049573/TFYSwiftCategoryUtil/blob/master/LICENSE)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-14.0+-blue.svg)](https://developer.apple.com/xcode)
[![iOS](https://img.shields.io/badge/iOS-15.0+-green.svg)](https://ios.com)

TFYSwiftCategoryUtil 是一个功能丰富的 Swift 工具库，提供了大量实用的扩展和工具类，帮助开发者更高效地进行 iOS 开发。采用链式编程风格，让代码更简洁优雅。支持 iPhone 和 iPad 适配，最低支持 iOS 15.0+。

## ✨ 特性

- 🔗 优雅的链式编程支持
- 📱 丰富的 UIKit 组件扩展
- 🎨 完整的屏幕适配方案（iPhone/iPad）
- 🛠 实用的工具类集合
- 🌐 WKWebView 相关功能增强
- 👆 手势识别相关扩展
- 📚 完整的文档和示例
- 🎭 强大的弹窗系统
- 📍 位置服务工具
- 🔄 响应式编程支持

## 📦 安装

### CocoaPods

```ruby
pod 'TFYSwiftCategoryUtil'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYSwiftCategoryUtil.git", .upToNextMajor(from: "2.1.9.5"))
]
```

## 🌟 主要模块

### 基础模块 (Base)
- **Chain** - 链式编程核心结构，支持动态成员查找和链式调用
- **HasFont** - 字体相关协议，支持 UILabel、UIButton、UITextField、UITextView 等控件统一设置字体
- **HasText** - 文本处理协议，支持文本、颜色、对齐、行距等统一设置

### UI 扩展 (UIKit)
- **UIView+Chain** - 视图基础扩展
  - frame 设置和布局
  - 圆角、阴影、边框
  - 渐变背景
  - 动画效果
  - 手势识别
- **UIButton+Chain** - 按钮扩展
  - 图文布局（24种布局模式）
  - 点击事件处理
  - 倒计时功能
  - 点击区域扩展
  - 状态管理
- **UILabel+Chain** - 标签扩展
  - 富文本设置
  - 行间距调整
  - 文本渐变
  - 描边效果
  - 链接点击
- **UITextField+Chain** - 输入框扩展
  - 输入限制
  - 格式化输入
  - 占位符样式
  - 键盘处理
- **UITextView+Chain** - 文本视图扩展
  - 富文本编辑
  - 占位符支持
  - 输入限制
- **UITableView+Chain** - 表格视图扩展
  - 注册复用
  - 空数据展示
  - 刷新控件
  - 分组管理
- **UICollectionView+Chain** - 集合视图扩展
  - 布局管理
  - 注册复用
  - 空数据展示
- **UIImage+Chain** - 图片处理扩展
  - 缩放、裁剪
  - 滤镜效果
  - 水印添加
  - 格式转换
  - 压缩优化
- **UIColor+Chain** - 颜色扩展
  - 渐变颜色
  - 十六进制转换
  - 随机颜色
  - 透明度调整
- **UIFont+Chain** - 字体扩展
  - 动态字体
  - 字体特征
  - 自定义字体
- **UIViewController+Chain** - 控制器扩展
  - 导航管理
  - 转场动画
  - 生命周期
  - 内存管理

### Foundation 扩展 (Foundation)
- **String+Chain** - 字符串扩展
  - 正则验证
  - 格式化
  - 编码转换
  - 加密解密
- **Array+Chain** - 数组扩展
  - 安全访问
  - 批量操作
  - JSON 转换
- **Dictionary+Chain** - 字典扩展
  - 安全访问
  - 合并操作
  - JSON 转换
- **Data+Chain** - 数据扩展
  - 加密解密
  - 压缩解压
  - 格式转换
- **Date+Chain** - 日期扩展
  - 格式化
  - 时间计算
  - 时区处理
- **FileManager+Chain** - 文件管理扩展
  - 文件操作
  - 目录管理
  - 权限处理
  - 缓存管理

### 手势识别 (Gesture)
- **UITapGestureRecognizer+ITools** - 点击手势
  - 单点、多点
  - 长按识别
  - 自定义区域
- **UIPanGestureRecognizer+ITools** - 拖拽手势
  - 方向识别
  - 速度计算
  - 边界限制
- **UIPinchGestureRecognizer+ITools** - 缩放手势
  - 缩放比例
  - 边界限制
- **UIRotationGestureRecognizer+ITools** - 旋转手势
  - 角度计算
  - 边界限制
- **UISwipeGestureRecognizer+ITools** - 滑动手势
  - 方向识别
  - 多点支持
- **UILongPressGestureRecognizer+ITools** - 长按手势
  - 时间配置
  - 移动容忍

### 工具类 (Utils)
- **TFYSwiftAdaptiveKit** - 屏幕适配工具
  - iPhone/iPad 自动适配
  - 分屏模式支持
  - 方向切换处理
  - 安全区域适配
- **TFYSwiftPopupView** - 弹窗系统
  - 多种动画效果
  - 手势交互
  - 键盘适配
  - 自定义配置
- **TFYUtils** - 核心工具类
  - 窗口管理
  - 日志系统
  - 内购管理
  - 网络检测
  - 设备信息
- **TFYSwiftJsonKit** - JSON 处理
  - 模型转换
  - 编码解码
  - 验证工具
- **TFYStitchImage** - 图片拼接
  - 多图拼接
  - 布局控制
  - 质量优化
- **TFYSwiftGridFlowLayout** - 网格布局
  - 瀑布流
  - 动态高度
  - 间距控制
- **TFYRuntime** - 运行时工具
  - 方法交换
  - 属性访问
  - 关联对象
- **TFYRegexHelper** - 正则表达式
  - 常用验证
  - 自定义规则
  - 性能优化
- **TFYNetstatManager** - 网络状态
  - 连接检测
  - 类型识别
  - 状态监听
- **TFYTimer** - 定时器
  - 精确控制
  - 内存管理
  - 暂停恢复
- **TFYAsynce** - 异步操作
  - 线程管理
  - 任务调度
  - 错误处理

### WKWebView 增强 (WKWeb)
- **WKWebManager** - Web 管理器
  - 页面管理
  - 导航控制
  - 进度监听
- **WKWebController** - Web 控制器
  - 生命周期
  - 配置管理
  - 代理封装
- **WKWebHandler** - 脚本处理
  - 消息传递
  - 参数处理
  - 错误处理
- **WKOperatorLayout** - 布局控制
  - 响应式布局
  - 适配处理
  - 交互优化
- **WKDecoder/WKEncoder** - 编解码器
  - 参数编解码
  - 类型转换
  - 错误处理

### 核心工具 (CoreUiit)
- **Publisher/Subscriber** - 发布订阅模式
  - 事件分发
  - 数据绑定
  - 内存管理
- **CLLocationManager** - 位置服务
  - 定位功能
  - 权限管理
  - 精度控制
- **LocationPublisher** - 位置发布
  - 实时位置
  - 地理编码
  - 反地理编码
- **AuthorizationPublisher** - 权限管理
  - 权限请求
  - 状态监听
  - 引导处理
- **CGRect/CGPoint** - 几何扩展
  - 计算工具
  - 转换方法
  - 适配处理
- **UserDefault** - 用户默认设置
  - 数据存储
  - 类型安全
  - 同步处理
- **Operators** - 操作符扩展
  - 自定义操作符
  - 链式调用
  - 类型转换

## 📝 使用示例

### 链式编程

```swift
// UILabel 示例
let label = UILabel()
    .tfy
    .text("Hello World")
    .textColor(.label)
    .font(.systemFont(ofSize: 16.adap, weight: .medium))
    .textAlignment(.center)
    .numberOfLines(0)
    .backgroundColor(.systemBackground)
    .cornerRadius(8.adap)
    .borderWidth(1.adap)
    .borderColor(.systemGray4)
    .build

// UIButton 示例
let button = UIButton(type: .custom)
    .tfy
    .title("点击我", for: .normal)
    .titleColor(.white, for: .normal)
    .backgroundColor(.systemBlue)
    .cornerRadius(10.adap)
    .imageDirection(.centerImageLeft, 8.adap)
    .image(UIImage(systemName: "star.fill"), for: .normal)
    .addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    .build

// UIView 渐变示例
let gradientView = UIView()
    .tfy
    .frame(CGRect(x: 0, y: 0, width: 200.adap, height: 50.adap))
    .backgroundColor(UIColor.colorGradientChangeWithSize(
        size: CGSize(width: 200.adap, height: 50.adap),
        direction: .GradientChangeDirectionLevel,
        colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
    ))
    .cornerRadius(25.adap)
    .build
```

### 屏幕适配

```swift
// 初始化适配工具
TFYSwiftAdaptiveKit.Config.referenceWidth = 375.0
TFYSwiftAdaptiveKit.Config.referenceHeight = 812.0
TFYSwiftAdaptiveKit.Config.iPadFitMultiple = 1.2
TFYSwiftAdaptiveKit.setupAuto()

// 使用适配值
let width = 100.adap        // 默认适配
let height = 200.adap_width // 宽度适配
let fontSize = 16.adap      // 字体适配

// 设备检测
if TFYSwiftAdaptiveKit.Device.isIPad {
    // iPad 特定逻辑
    if TFYSwiftAdaptiveKit.Device.isSplitScreen {
        // 分屏模式
    }
}
```

### 弹窗系统

```swift
// 创建弹窗内容
let contentView = CustomViewTipsView()
contentView.dataBlock = { data in
    // 处理弹窗交互
}

// 配置弹窗
var config = TFYSwiftPopupViewConfiguration()
config.isDismissible = true
config.backgroundStyle = .blur
config.containerConfiguration.width = .fixed(300.adap)
config.containerConfiguration.height = .automatic

// 显示弹窗
let popupView = TFYSwiftPopupView.show(
    contentView: contentView,
    configuration: config,
    animator: TFYSwiftFadeInOutAnimator()
)
```

### 工具类使用

```swift
// 异步操作
TFYAsynce.async {
    // 后台任务
    let result = heavyTask()
} mainBlock: {
    // 主线程更新 UI
    self.updateUI(with: result)
}

// 正则验证
let isEmail = "test@example.com".tfy.isValidEmail
let isPhone = "13800138000".tfy.isValidPhone
let isIDCard = "123456789012345678".tfy.isValidIDCard

// JSON 解析
let model: YourModel = try TFYSwiftJsonKit.model(from: jsonData)
let jsonString = try TFYSwiftJsonKit.jsonString(from: model)

// 图片处理
let image = UIImage(named: "original")
let processed = image?.tfy
    .resize(to: CGSize(width: 100.adap, height: 100.adap))
    .cornerRadius(10.adap)
    .addWatermark(text: "TFY")
    .build

// 定时器
let timer = TFYTimer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
    // 定时执行的代码
}

// 日志系统
TFYUtils.Logger.log("应用启动", level: .info)
TFYUtils.Logger.log("错误信息", level: .error)
```

### 手势识别

```swift
// 点击手势
label.addGestureTap { gesture in
    gesture.didTapLabelAttributedText(linkDictionary) { text, url in
        // 处理链接点击
    }
}

// 拖拽手势
view.addGesturePan { gesture in
    let translation = gesture.translation(in: view)
    view.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
}
```

### WKWebView 使用

```swift
// 创建 Web 管理器
let webManager = WKWebManager()
webManager.load(url: URL(string: "https://example.com")!)

// 注册脚本处理器
webManager.registerHandler(name: "nativeMethod") { params in
    // 处理来自 JavaScript 的消息
    return ["result": "success"]
}

// 调用 JavaScript
webManager.evaluateJavaScript("window.showMessage('Hello')") { result, error in
    // 处理结果
}
```

## 🔧 系统要求

- **iOS 15.0+**
- **Swift 5.0+**
- **Xcode 14.0+**
- **支持 iPhone 和 iPad**

## 📱 设备支持

- ✅ iPhone (所有型号)
- ✅ iPad (所有型号)
- ✅ 分屏模式 (iPad)
- ✅ 横竖屏切换
- ✅ 刘海屏适配
- ✅ 动态字体
- ✅ 深色模式

## 🚀 性能特性

- 内存优化
- 延迟加载
- 缓存机制
- 异步处理
- 线程安全

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📞 联系方式

- 作者：田风有
- 邮箱：420144542@qq.com
- GitHub：[https://github.com/13662049573/TFYSwiftCategoryUtil](https://github.com/13662049573/TFYSwiftCategoryUtil)

---

⭐ 如果这个项目对你有帮助，请给它一个星标！

