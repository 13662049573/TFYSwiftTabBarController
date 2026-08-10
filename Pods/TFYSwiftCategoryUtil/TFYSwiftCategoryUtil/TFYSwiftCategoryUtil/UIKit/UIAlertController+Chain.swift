//
//  UIAlertController+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public struct AlertKeys {
    public static let attributedTitle = "attributedTitle"
    public static let attributedMessage = "attributedMessage"
    public static let contentViewController = "contentViewController"
    public static let actionColor = "titleTextColor"
    public static let actionImage = "image"
    public static let actionImageTintColor = "imageTintColor"
    public static let actionChecked = "checked"
}

public extension UIAlertController {
    // MARK: 1.1、创建 UIAlertController
    /// 创建 UIAlertController
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - style: 样式
    /// - Returns: UIAlertController实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func create(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: style)
    }
    
    private var subView5: UIView? {
        guard let subView1: UIView = self.view.subviews.first,
              let subView2: UIView = subView1.subviews.first,
              let subView3: UIView = subView2.subviews.first,
              let subView4: UIView = subView3.subviews.first,
              let subView5: UIView = subView4.subviews.first
              else { return nil }
        return subView5
    }
    
    // MARK: 1.2、获取标题 UILabel
    /// 获取标题 UILabel
    /// - Returns: 标题标签，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var titleLabel: UILabel? {
        guard let subView5 = subView5, subView5.subviews.count > 2 else { return nil }
        return subView5.subviews[1] as? UILabel
    }
    
    // MARK: 1.3、获取消息 UILabel
    /// 获取消息 UILabel
    /// - Returns: 消息标签，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var messageLabel: UILabel? {
        guard let subView5 = subView5 else { return nil }
        let messageLabelIndex = title == nil ? 1 : 2
        guard subView5.subviews.indices.contains(messageLabelIndex) else { return nil }
        return subView5.subviews[messageLabelIndex] as? UILabel
    }
    
    // MARK: 1.4、创建 ActionSheet
    /// 创建 ActionSheet
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - items: 选项数组
    ///   - handler: 处理回调
    /// - Returns: UIAlertController实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    static func createSheet(title: String?, message: String? = nil, items: [String]? = nil, handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> Self {
        let alertVC = self.init(title: title, message: message, preferredStyle: .actionSheet)
        items?.forEach { title in
            let style: UIAlertAction.Style = title == "取消" ? .cancel : .default
            let action = UIAlertAction(title: title, style: style) { action in
                alertVC.actions.forEach {
                    if action.title != "取消" {
                        $0.setValue(NSNumber(booleanLiteral: $0 == action), forKey: AlertKeys.actionChecked)
                    }
                }
                alertVC.dismiss(animated: true) {
                    handler?(alertVC, action)
                }
            }
            alertVC.addAction(action)
        }
        return alertVC
    }
    
    // MARK: 1.5、展示提示框
    /// 展示提示框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - items: 选项数组
    ///   - handler: 处理回调
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func showSheet(_ title: String?,
                          message: String? = nil,
                          items: [String]? = nil,
                          handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) {
        UIAlertController.createSheet(title: title, message:message, items: items, handler: handler)
            .present()
    }

    
    // MARK: 1.6、[便利方法]提示信息
    /// [便利方法]提示信息
    /// - Parameters:
    ///   - title: 标题，默认"提示"
    ///   - message: 消息
    ///   - actionTitles: 按钮标题数组，默认["确定"]
    ///   - block: 段落样式设置块
    ///   - handler: 处理回调
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func showAlert(_ title: String? = "提示",
                          message: String?,
                          actionTitles: [String]? = ["确定"],
                          block: ((NSMutableParagraphStyle) -> Void)? = nil,
                          handler: ((UIAlertController, UIAlertAction) -> Void)? = nil){
        //富文本效果
        let paraStyle = NSMutableParagraphStyle()
            .tfy
            .lineBreakModeChain(.byCharWrapping)
            .lineSpacingChain(5)
            .alignmentChain(.center)
            .build
        block?(paraStyle)
        
        UIAlertController(title: title, message: message, preferredStyle: .alert)
            .addActionTitles(actionTitles, handler: handler)
            .setMessageParaStyle(paraStyle)
            .present()
    }
    
    // MARK: 1.7、[便利方法1]提示信息(兼容 OC)
    /// [便利方法1]提示信息(兼容 OC)
    /// - Parameters:
    ///   - title: 标题，默认"提示"
    ///   - message: 消息
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func showAlert(_ title: String? = "提示", message: String?) {
        //富文本效果
        UIAlertController(title: title, message: message, preferredStyle: .alert)
            .addActionTitles(["确定"], handler: nil)
            .present()
    }

    // MARK: 1.8、根据时间间隔控制是否显示
    /// 根据时间间隔控制是否显示
    /// - Parameter interval: 时间间隔（秒），默认604800秒（7天）
    /// - Returns: 是否可以显示
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    static func canShow(_ interval: Int = Int(604800)) -> Bool {
        let nowTimestamp = Date().timeIntervalSince1970
        
        if let lastTimestamp = UserDefaults.standard.integer(forKey: "lastShowAlert") as Int?,
           (Int(nowTimestamp) - lastTimestamp) < Int(interval) {
            TFYUtils.Logger.log("一个 fmt 只能提醒一次")
            return false
        }
        UserDefaults.standard.set(nowTimestamp, forKey: "lastShowAlert")
        UserDefaults.standard.synchronize()
        return true
    }
    
    // MARK: 1.9、添加多个 UIAlertAction
    /// 添加多个 UIAlertAction
    /// - Parameters:
    ///   - titles: 按钮标题数组，默认["取消","确定"]
    ///   - handler: 处理回调
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func addActionTitles(_ titles: [String]? = ["取消","确定"], handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> Self {
        titles?.forEach({ (string) in
            let style: UIAlertAction.Style = string == "取消" ? .cancel : .default
            self.addAction(UIAlertAction(title: string, style: style, handler: { (action) in
                handler?(self, action)
            }))
        })
        return self
    }
    // MARK: 1.10、添加多个 textField
    /// 添加多个 textField
    /// - Parameters:
    ///   - placeholders: 占位符数组
    ///   - handler: 文本框配置回调
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func addTextFieldPlaceholders(_ placeholders: [String]?, handler: ((UITextField) -> Void)? = nil) -> Self {
        if self.preferredStyle != .alert {
            return self
        }
        placeholders?.forEach({ (string) in
            self.addTextField { (textField: UITextField) in
                textField.placeholder = string
                handler?(textField)
            }
        })
        return self
    }
        
    // MARK: 1.11、设置标题颜色
    /// 设置标题颜色
    /// - Parameter color: 颜色，默认白色
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setTitleColor(_ color: UIColor = .white) -> Self {
        guard let title = title else {
            return self
        }
        
        let attrTitle = NSMutableAttributedString(string: title)
        attrTitle.addAttributes([NSAttributedString.Key.foregroundColor: color], range: NSRange(location: 0, length: title.count))
        setValue(attrTitle, forKey: AlertKeys.attributedTitle)
        return self
    }
    
    // MARK: 1.12、设置Message文本换行,对齐方式
    /// 设置Message文本换行,对齐方式
    /// - Parameter paraStyle: 段落样式
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setMessageParaStyle(_ paraStyle: NSMutableParagraphStyle) -> Self {
        guard let message = message else {
            return self
        }

        let attrMsg = NSMutableAttributedString(string: message)
        let attDic = [NSAttributedString.Key.paragraphStyle: paraStyle,
                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),]
        attrMsg.addAttributes(attDic, range: NSRange(location: 0, length: message.count))
        setValue(attrMsg, forKey: AlertKeys.attributedMessage)
        return self
    }
    
    // MARK: 1.13、设置 Message 样式
    /// 设置 Message 样式
    /// - Parameters:
    ///   - font: 字体
    ///   - textColor: 文字颜色
    ///   - alignment: 对齐方式，默认左对齐
    ///   - lineBreakMode: 换行模式，默认按字符换行
    ///   - lineSpacing: 行间距，默认5.0
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setMessageStyle(_ font: UIFont,
                         textColor: UIColor,
                         alignment: NSTextAlignment = .left,
                         lineBreakMode: NSLineBreakMode = .byCharWrapping,
                         lineSpacing: CGFloat = 5.0) -> Self {
        let paraStyle = NSMutableParagraphStyle()
            .tfy
            .lineBreakModeChain(lineBreakMode)
            .lineSpacingChain(lineSpacing)
            .alignmentChain(alignment)
            .build
        
        return setMessageParaStyle(paraStyle)
    }
    
    // MARK: 1.14、设置内容视图控制器
    /// 设置内容视图控制器
    /// - Parameters:
    ///   - vc: 视图控制器
    ///   - height: 高度
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setContent(vc: UIViewController, height: CGFloat) -> Self {
        let safeHeight = max(0, height)
        setValue(vc, forKey: AlertKeys.contentViewController)
        vc.preferredContentSize.height = safeHeight
        preferredContentSize.height = safeHeight
        return self
    }
    
    // MARK: 1.15、改变宽度
    /// 改变宽度
    /// - Parameter newWidth: 新宽度，默认屏幕宽度的80%
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func changeWidth(_ newWidth: CGFloat = UIScreen.main.bounds.width * 0.8) -> Self {
        if preferredStyle != .alert {
            return self
        }
        let safeWidth = max(1, newWidth)
        let widthConstraints = view.constraints.filter({ return $0.firstAttribute == .width})
        view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
//        let newWidth = UIScreen.main.bounds.width * 0.90
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: view as Any,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: safeWidth)
        view.addConstraint(widthConstraint)
        guard let firstContainer = view.subviews.first else { return self }
        // Finding first child width constraint
        let constraint = firstContainer.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        firstContainer.removeConstraints(constraint)
        // And replacing with new constraint equal to view width constraint that we setup earlier
        view.addConstraint(NSLayoutConstraint(item: firstContainer,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .width,
                                                    multiplier: 1.0,
                                                    constant: 0))
        // Same for the second child with width constraint with 998 priority
        guard let innerBackground = firstContainer.subviews.first else { return self }
        let innerConstraints = innerBackground.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        innerBackground.removeConstraints(innerConstraints)
        firstContainer.addConstraint(NSLayoutConstraint(item: innerBackground,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: firstContainer,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0))
        return self
    }
    
    // MARK: 1.16、设置弹窗样式
    /// 设置弹窗样式
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - backgroundColor: 背景色
    ///   - tintColor: 着色
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setAlertStyle(cornerRadius: CGFloat = 8.0, backgroundColor: UIColor = .white, tintColor: UIColor? = nil) -> Self {
        if let alertView = view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.subviews.first {
            alertView.layer.cornerRadius = max(0, cornerRadius)
            alertView.backgroundColor = backgroundColor
        }
        if let tintColor = tintColor {
            self.view.tintColor = tintColor
        }
        return self
    }
    
    // MARK: 1.17、添加输入框
    /// 添加输入框
    /// - Parameters:
    ///   - placeholder: 占位符
    ///   - text: 默认文本
    ///   - keyboardType: 键盘类型
    ///   - isSecure: 是否安全输入
    ///   - configurationHandler: 配置回调
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func addTextField(placeholder: String? = nil, text: String? = nil, keyboardType: UIKeyboardType = .default, isSecure: Bool = false, configurationHandler: ((UITextField) -> Void)? = nil) -> Self {
        addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
            textField.keyboardType = keyboardType
            textField.isSecureTextEntry = isSecure
            configurationHandler?(textField)
        }
        return self
    }
    
    // MARK: 1.18、获取所有输入框
    /// 获取所有输入框
    /// - Returns: 输入框数组
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    var allTextFields: [UITextField] {
        return self.textFields ?? []
    }
    
    // MARK: 1.19、获取指定索引的输入框
    /// 获取指定索引的输入框
    /// - Parameter index: 索引
    /// - Returns: 输入框，失败返回nil
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    func textField(at index: Int) -> UITextField? {
        guard let textFields = self.textFields, index >= 0, index < textFields.count else { return nil }
        return textFields[index]
    }
    
    // MARK: 1.20、设置弹窗优先级
    /// 设置弹窗优先级
    /// - Parameter priority: 优先级
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setModalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle = style
        return self
    }
}

// MARK: - 二、TFY扩展
public extension TFY where Base: UIAlertController {
    // MARK: 2.1、显示弹窗
    /// 显示弹窗
    /// - Parameters:
    ///   - viewController: 展示的视图控制器
    ///   - completion: 完成回调
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func show(in viewController: UIViewController?, completion: (() -> Void)? = nil) -> Self {
        guard let viewController = viewController else {
            assertionFailure("👻💀 viewController 不能为空 💀👻")
            return self
        }
        viewController.present(base, animated: true, completion: completion)
        return self
    }
    
    // MARK: 2.2、延迟关闭弹窗
    /// 延迟关闭弹窗
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - completion: 完成回调
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func dismiss(after delay: TimeInterval, completion: (() -> Void)? = nil) -> Self {
        let safeDelay = delay.isFinite ? max(0, delay) : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + safeDelay) { [weak base] in
            base?.dismiss(animated: true, completion: completion)
        }
        return self
    }
    
    // MARK: 2.3、设置标题
    /// 设置标题
    /// - Parameter a: 标题文本
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func title(_ a:String) -> Self {
        base.title = a
        return self
    }
    // MARK: 2.4、设置标题字体
    /// 设置标题字体
    /// - Parameter font: 字体
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func title(_ font:UIFont) -> Self {
        let attributed:NSAttributedString = base.value(forKey: AlertKeys.attributedTitle) as? NSAttributedString ?? NSMutableAttributedString(string: base.title ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: AlertKeys.attributedTitle)
        return self
    }
    // MARK: 2.5、设置标题颜色
    /// 设置标题颜色
    /// - Parameter color: 颜色
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func title(_ color:UIColor) -> Self {
        let attributed:NSAttributedString = base.value(forKey: AlertKeys.attributedTitle) as? NSAttributedString ?? NSMutableAttributedString(string: base.title ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: AlertKeys.attributedTitle)
        return self
    }
    // MARK: 2.6、设置标题富文本
    /// 设置标题富文本
    /// - Parameter attributed: 富文本
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func title(_ attributed:NSAttributedString) -> Self {
        base.setValue(attributed, forKey: AlertKeys.attributedTitle)
        return self
    }
    // MARK: 2.7、设置消息
    /// 设置消息
    /// - Parameter a: 消息文本
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func message(_ a:String) -> Self {
        base.message = a
        return self
    }
    // MARK: 2.8、设置消息字体
    /// 设置消息字体
    /// - Parameter font: 字体
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func message(_ font:UIFont) -> Self {
        let attributed:NSAttributedString = base.value(forKey: AlertKeys.attributedMessage) as? NSAttributedString ?? NSMutableAttributedString(string: base.message ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: AlertKeys.attributedMessage)
        return self
    }
    // MARK: 2.9、设置消息颜色
    /// 设置消息颜色
    /// - Parameter color: 颜色
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func message(_ color:UIColor) -> Self {
        let attributed:NSAttributedString = base.value(forKey: AlertKeys.attributedMessage) as? NSAttributedString ?? NSMutableAttributedString(string: base.message ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: AlertKeys.attributedMessage)
        return self
    }
    // MARK: 2.10、设置消息富文本
    /// 设置消息富文本
    /// - Parameter attributed: 富文本
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func message(_ attributed:NSAttributedString) -> Self {
        base.setValue(attributed, forKey: AlertKeys.attributedMessage)
        return self
    }
    
    // MARK: 2.11、添加操作按钮
    /// 添加操作按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - style: 按钮样式，默认default
    ///   - custom: 自定义配置回调
    ///   - handler: 点击处理回调
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func action(_ title:String,
                style:UIAlertAction.Style = .default,
                custom:((_ action:UIAlertAction) -> Void)? = nil,
                handler:((_ action:UIAlertAction) -> Void)?) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        custom?(action)
        base.addAction(action)
        return self
    }
}

// MARK: - 三、UIAlertAction扩展
public extension TFY where Base: UIAlertAction {
    // MARK: 3.1、设置标题
    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setTitle(_ title: String) -> Self {
        base.setValue(title, forKey: "title")
        return self
    }
    
    // MARK: 3.2、设置标题颜色
    /// 设置标题颜色
    /// - Parameter color: 颜色
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setTitleColor(_ color: UIColor) -> Self {
        base.setValue(color, forKey: AlertKeys.actionColor)
        return self
    }
    
    // MARK: 3.3、设置样式
    /// 设置样式
    /// - Parameter style: 样式
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func setStyle(_ style: UIAlertAction.Style) -> Self {
        base.setValue(style, forKey: "style")
        return self
    }
    
    // MARK: 3.4、设置处理回调
    /// 设置处理回调
    /// - Parameter a: 处理回调
    /// - Returns: 自身实例
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    @discardableResult
    func handler(_ a:((UIAlertAction) -> Void)? = nil) -> Self {
        base.setValue(a, forKey: "handler")
        return self
    }
}

