//
//  UIView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public func adaptWidth(designWidth: CGFloat = 375.0, _ vaule: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.size.width / designWidth * vaule
}

extension CGColor {
    var uiColor:UIColor { return UIColor(cgColor: self) }
}

public extension UIView {
    /// 加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    ///x轴坐标
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.origin.x = newValue
            self.frame = tmpFrame
        }
    }
    
    ///y轴坐标
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.origin.y = newValue
            self.frame = tmpFrame
        }
    }
    
    ///宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.size.width = newValue
            self.frame = tmpFrame
        }
    }
    
    ///高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.size.height = newValue
            self.frame = tmpFrame
        }
    }
    
    /// 最右边约束x值
    var maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var tmpFrame = self.frame;
            tmpFrame.origin.x = newValue - tmpFrame.size.width;
            self.frame = tmpFrame;
        }
    }
    
    /// 最下边约束y值
    var maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var tmpFrame = self.frame;
            tmpFrame.origin.y = newValue - tmpFrame.size.height;
            self.frame = tmpFrame;
        }
    }
    
    /// 设置x轴中心点
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y);
        }
    }
    
    /// 设置y轴中心点
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue);
        }
        
    }
    
    /// 设置size
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue.width, height: newValue.height)
        }
    }
    
    /// 设置orgin
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame = CGRect(x: newValue.x, y: newValue.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }

    /// 移除所有子视图
    func removeAllSubviews() {
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    
    /// 屏幕适配
    func adaptSubViews() {
        // 约束
        for cons in constraints {
            cons.constant = adaptWidth(cons.constant)
        }
        // 圆角
        layer.cornerRadius = adaptWidth(layer.cornerRadius)

        // 字体大小
        if isKind(of: UILabel.self) == true {
            let lbl = self as! UILabel
            lbl.font = UIFont(name: lbl.font.fontName, size: adaptWidth(lbl.font.pointSize))
        }
        if isKind(of: UITextField.self) == true {
            let tf = self as! UITextField
            guard let f = tf.font else {
                return
            }
            tf.font = UIFont(name: f.fontName, size: adaptWidth(f.pointSize))
        }

        if isKind(of: UITextView.self) == true {
            let tf = self as! UITextView
            guard let f = tf.font else {
                return
            }
            tf.font = UIFont(name: f.fontName, size: adaptWidth(f.pointSize))
        }

        if isKind(of: UIButton.self) == true {
            let btn = self as! UIButton
            if let f = btn.titleLabel?.font {
                btn.titleLabel?.font = UIFont(name: f.fontName, size: adaptWidth(f.pointSize))
            }
        }

        for v in subviews {
            v.adaptSubViews()
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    /// 添加圆角
    func cornerCut(radius:CGFloat,corner:UIRectCorner){
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return UIColor.clear
            }
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @objc @IBInspectable var shadowOffset:CGSize {
        set { layer.shadowOffset = newValue }
        get { return layer.shadowOffset }
    }
    
    @objc @IBInspectable var shadowColor:UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get { return layer.shadowColor?.uiColor }
    }
    
    @objc @IBInspectable var shadowRadius:CGFloat {
        set { layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
    
    @objc @IBInspectable var shadowOpacity:Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }
    
    /// 添加阴影
    func shadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.2) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    /// 添加阴影图层
    func shadowLayer(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5,cornerRadius:CGFloat,bounds:CGRect) {
        
        let layer = CALayer()
        layer.frame = bounds
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.white.cgColor
        self.layer.insertSublayer(layer, at: 0)
        self.layer.addSublayer(layer)
    }
    
    func navigationController() -> UIViewController? {
        if let view = self.superview {
            let nextResponder = view.next
            if (nextResponder?.isKind(of: UIViewController.self))! {
                return nextResponder as? UIViewController
            }
        }
        return nil
    }
    
    /// 是否是某 View 的子 view，不止判断一层，会递归所有层级
    ///
    /// - Parameter view: 某 View
    /// - Returns: 是或不是
    func isRecursiveSubView(of view: UIView) -> Bool {
        if superview == nil {
            return self == view
        } else if superview == view {
            return true
        }
        return superview!.isRecursiveSubView(of: view)
    }

    /// 递归查找子类 UIView
    ///
    /// - Parameter name: UIView 的类名称
    /// - Returns: 找到的 UIView
    func recursiveFindSubview(of name: String) -> UIView? {
        for view in subviews {
            if view.isKind(of: NSClassFromString(name)!) {
                return view
            }
        }
        for view in subviews {
            if let tempView = view.recursiveFindSubview(of: name) {
                return tempView
            }
        }
        return nil
    }

    /// 递归查找父类 UIView
    ///
    /// - Parameter name: UIView 的类名称
    /// - Returns: 找到的 UIView
    func recursiveFindSuperView(of name: String) -> UIView? {
        guard let superview = superview else { return nil }
        if superview.isKind(of: NSClassFromString(name)!) {
            return superview
        }
        return superview.recursiveFindSuperView(of: name)
    }

    /// 递归寻找所有 subviews
    func getAllSubview<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    
    func renderViewToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}


public extension TFY where Base: UIView {
    
    @discardableResult
    func tag(_ tag: Int) -> Self {
        base.tag = tag
        return self
    }
    
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        base.frame = frame
        return self
    }
    
    @discardableResult
    func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Self {
        base.frame = CGRect(x: x, y: y, width: width, height: height)
        return self
    }
    
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        base.bounds = bounds
        return self
    }
    
    @discardableResult
    func center(_ center: CGPoint) -> Self {
        base.center = center
        return self
    }
    
    @discardableResult
    func center(x: CGFloat, y: CGFloat) -> Self {
        base.center = CGPoint(x: x, y: y)
        return self
    }
    
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> Self {
        base.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        base.contentMode = contentMode
        return self
    }
    
    @discardableResult
    func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        base.clipsToBounds = clipsToBounds
        return self
    }
    
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
    
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        base.isHidden = isHidden
        return self
    }
    
    @discardableResult
    func isOpaque(_ isOpaque: Bool) -> Self {
        base.isOpaque = isOpaque
        return self
    }
    
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        base.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    @discardableResult
    func tintColor(_ tintColor: UIColor) -> Self {
        base.tintColor = tintColor
        return self
    }
    
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        base.cornerRadius = cornerRadius
        return self
    }
    
    @discardableResult
    func borderWidth(_ borderWidth: CGFloat) -> Self {
        base.borderWidth = borderWidth
        return self
    }
    
    @discardableResult
    func borderColor(_ borderColor: UIColor) -> Self {
        base.borderColor = borderColor
        return self
    }
    
    @discardableResult
    func shadowColor(_ shadowColor: UIColor?) -> Self {
        base.shadowColor = shadowColor
        return self
    }
    
    @discardableResult
    func shadowOpacity(_ shadowOpacity: Float) -> Self {
        base.shadowOpacity = shadowOpacity
        return self
    }
    
    @discardableResult
    func shadowOffset(_ shadowOffset: CGSize) -> Self {
        base.shadowOffset = shadowOffset
        return self
    }
    
    @discardableResult
    func shadowRadius(_ shadowRadius: CGFloat) -> Self {
        base.shadowRadius = shadowRadius
        return self
    }
    
    @discardableResult
    func shadowPath(_ shadowPath: CGPath?) -> Self {
        base.layer.shadowPath = shadowPath
        return self
    }
    
    @discardableResult
    func addToSuperView(_ view: UIView) -> Self {
        view.addSubview(base)
        return self
    }
    
    @discardableResult
    func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        base.addGestureRecognizer(gestureRecognizer)
        return self
    }
    
    @discardableResult
    func addConstraint(_ constraint: NSLayoutConstraint) -> Self {
        base.addConstraint(constraint)
        return self
    }
    
    @discardableResult
    func addConstraints(_ constraints: [NSLayoutConstraint]) -> Self {
        base.addConstraints(constraints)
        return self
    }
    
    @discardableResult
    func addRadius(direction: UIRectCorner = .allCorners, vaule: CGFloat) -> Self {
        base.cornerCut(radius: vaule, corner: direction)
        return self
    }
    
    /// 变形属性(平移\缩放\旋转)
    @discardableResult
    func transform(_ a: CGAffineTransform) -> Self {
        base.transform = a
        return self
    }
    /// 自动调整子视图尺寸，默认YES则会根据autoresizingMask属性自动调整子视图尺寸
    @discardableResult
    func autoresizesSubviews(_ subviews: Bool) -> Self {
        base.autoresizesSubviews = subviews
        return self
    }
    /// 自动调整子视图与父视图的位置，默认UIViewAutoresizingNone
    @discardableResult
    func autoresizingMask(_ mask: UIView.AutoresizingMask) -> Self {
        base.autoresizingMask = mask
        return self
    }
    
    /// 毛玻璃效果 view.blurEffect(UIColor.red.withAlphaComponent(0.5))
    @discardableResult
    func blurEffect(_ color:UIColor = UIColor.clear,  style:UIBlurEffect.Style = .light, block:((UIVisualEffectView) -> Void)? = nil) -> Self {
        base.layoutIfNeeded()
        base.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = color
        blurEffectView.frame = base.bounds
        base.addSubview(blurEffectView)
        base.sendSubviewToBack(blurEffectView)
        block?(blurEffectView)
        return self
    }
    
    @discardableResult
    func insertSubview(_ subview:UIView, at index:Int = 0) -> Self {
        base.insertSubview(subview, at: index)
        return self
    }
    
    @discardableResult
    func insertSubview(_ subview:UIView, below view:UIView) -> Self {
        base.insertSubview(subview, belowSubview: view)
        return self
    }
    
    @discardableResult
    func insertSubview(_ subview:UIView, above view:UIView) -> Self {
        base.insertSubview(subview, aboveSubview: view)
        return self
    }
    
    @discardableResult
    func exchangeSubview(_ subview1:Int, _ subview2:Int) -> Self {
        base.exchangeSubview(at: subview1, withSubviewAt: subview2)
        return self
    }
    
    @discardableResult
    func bringSubviewToFront(subviewToFront view:UIView) -> Self {
        base.bringSubviewToFront(view)
        return self
    }
    
    @discardableResult
    func sendSubviewToBack(subviewToBack view:UIView) -> Self {
        base.sendSubviewToBack(view)
        return self
    }
    
    @discardableResult
    func insertSubview(toSuperview superview:UIView, below view:UIView) -> Self {
        superview.insertSubview(base, belowSubview: view)
        return self
    }
    @discardableResult
    func insertSubview(toSuperview superview:UIView, above view:UIView) -> Self {
        superview.insertSubview(base, aboveSubview: view)
        return self
    }
    
    @discardableResult
    func exchangeSubview(_ view:UIView) -> Self {
        guard let idx1 = base.superview?.subviews.firstIndex(of: base),
            let idx2 = base.superview?.subviews.firstIndex(of: view) else {
            return self
        }
        base.superview?.exchangeSubview(at: idx1, withSubviewAt: idx2)
        return self
    }
    
    @discardableResult
    func bringSubviewToFront() -> Self {
        base.superview?.bringSubviewToFront(base)
        return self
    }
    
    @discardableResult
    func sendSubviewToBack() -> Self {
        base.superview?.sendSubviewToBack(base)
        return self
    }
    
    @discardableResult
    func addArrangedSubview(toSuperstack stack:UIStackView) -> Self {
        stack.addArrangedSubview(base)
        return self
    }
    @discardableResult
    func insertArrangedSubview(toSuperstack stack:UIStackView, at index:Int) -> Self {
        stack.insertArrangedSubview(base, at: index)
        return self
    }
    
    @discardableResult
    func removeFromSuperview() -> Self {
        base.removeFromSuperview()
        return self
    }
    
    @discardableResult
    func remove(subview view:UIView) -> Self {
        base.subviews
            .filter{ $0 == view }
            .forEach{ $0.removeFromSuperview() }
        return self
    }
    
    @discardableResult
    func remove(subviews views:[UIView]) -> Self {
        base.subviews
            .filter{ views.contains($0)}
            .forEach{ $0.removeFromSuperview() }
        return self
    }
    
    @discardableResult
    func contents(contents:Any?) -> Self {
        base.layer.contents = contents
        return self
    }
    
    /// 设置是否启用自动布局
    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ translates: Bool) -> Self {
        base.translatesAutoresizingMaskIntoConstraints = translates
        return self
    }
    
    /// 设置边框颜色
    @discardableResult
    func borderColor(_ color: UIColor?) -> Self {
        base.layer.borderColor = color?.cgColor
        return self
    }
    
    /// 设置背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        base.backgroundColor = color
        return self
    }
    
    /// 设置是否启用辅助功能
    @discardableResult
    func isAccessibilityElement(_ isElement: Bool) -> Self {
        base.isAccessibilityElement = isElement
        return self
    }
    
    /// 设置辅助功能标签
    @discardableResult
    func accessibilityLabel(_ label: String?) -> Self {
        base.accessibilityLabel = label
        return self
    }
    
    /// 设置辅助功能提示
    @discardableResult
    func accessibilityHint(_ hint: String?) -> Self {
        base.accessibilityHint = hint
        return self
    }
    
    /// 设置辅助功能值
    @discardableResult
    func accessibilityValue(_ value: String?) -> Self {
        base.accessibilityValue = value
        return self
    }
    
    /// 设置辅助功能特征
    @discardableResult
    func accessibilityTraits(_ traits: UIAccessibilityTraits) -> Self {
        base.accessibilityTraits = traits
        return self
    }
    
    /// 设置辅助功能标识符
    @discardableResult
    func accessibilityIdentifier(_ identifier: String?) -> Self {
        base.accessibilityIdentifier = identifier
        return self
    }
}

public extension UIView {
    
    var keyWindow: UIWindow? {
        var keyWindow:UIWindow?
        keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        return keyWindow
    }

    ///手势 - 轻点 UITapGestureRecognizer
    @discardableResult
    func addGestureTap(_ target: Any?, action: Selector?) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: target, action: action)
        obj.numberOfTapsRequired = 1  //轻点次数
        obj.numberOfTouchesRequired = 1  //手指个数

        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
        return obj
    }
    
    ///手势 - 轻点 UITapGestureRecognizer
    @discardableResult
    func addGestureTap(_ action: @escaping ((UITapGestureRecognizer) ->Void)) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: nil, action: nil)
        obj.numberOfTapsRequired = 1  //轻点次数
        obj.numberOfTouchesRequired = 1  //手指个数

        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
        obj.addAction(action)
        return obj
    }
    
    ///手势 - 长按 UILongPressGestureRecognizer
    @discardableResult
    func addGestureLongPress(_ target: Any?, action: Selector?, for minimumPressDuration: TimeInterval = 0.5) -> UILongPressGestureRecognizer {
        let obj = UILongPressGestureRecognizer(target: target, action: action)
        obj.minimumPressDuration = minimumPressDuration
      
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
        return obj
    }
    
    ///手势 - 长按 UILongPressGestureRecognizer
    @discardableResult
    func addGestureLongPress(_ action: @escaping ((UILongPressGestureRecognizer) ->Void), for minimumPressDuration: TimeInterval = 0.5) -> UILongPressGestureRecognizer {
        let obj = UILongPressGestureRecognizer(target: nil, action: nil)
        obj.minimumPressDuration = minimumPressDuration
      
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            action(recognizer as! UILongPressGestureRecognizer)
        }
        return obj
    }
      
    ///手势 - 拖拽 UIPanGestureRecognizer
    @discardableResult
    func addGesturePan(_ action: @escaping ((UIPanGestureRecognizer) ->Void)) -> UIPanGestureRecognizer {
        let obj = UIPanGestureRecognizer(target: nil, action: nil)
          //最大最小的手势触摸次数
        obj.minimumNumberOfTouches = 1
        obj.maximumNumberOfTouches = 3
          
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
          
        obj.addAction { (recognizer) in
            if let gesture = recognizer as? UIPanGestureRecognizer {
                let translate: CGPoint = gesture.translation(in: gesture.view?.superview)
                gesture.view!.center = CGPoint(x: gesture.view!.center.x + translate.x, y: gesture.view!.center.y + translate.y)
                gesture.setTranslation( .zero, in: gesture.view!.superview)
                             
                action(gesture)
            }
        }
        return obj
    }
      
    ///手势 - 屏幕边缘 UIScreenEdgePanGestureRecognizer
    @discardableResult
    func addGestureEdgPan(_ target: Any?, action: Selector?, for edgs: UIRectEdge) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: target, action: action)
        obj.edges = edgs
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
        return obj
    }
    
    ///手势 - 屏幕边缘 UIScreenEdgePanGestureRecognizer
    @discardableResult
    func addGestureEdgPan(_ action: @escaping ((UIScreenEdgePanGestureRecognizer) ->Void), for edgs: UIRectEdge) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        obj.edges = edgs
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
       
        obj.addAction { (recognizer) in
            action(recognizer as! UIScreenEdgePanGestureRecognizer)
        }
        return obj
    }
      
    ///手势 - 清扫 UISwipeGestureRecognizer
    @discardableResult
    func addGestureSwip(_ target: Any?, action: Selector?, for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: target, action: action)
        obj.direction = direction
      
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
        return obj
    }
    
    ///手势 - 清扫 UISwipeGestureRecognizer
    @discardableResult
    func addGestureSwip(_ action: @escaping ((UISwipeGestureRecognizer) ->Void), for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: nil, action: nil)
        obj.direction = direction
      
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            action(recognizer as! UISwipeGestureRecognizer)
        }
        return obj
    }
      
    ///手势 - 捏合 UIPinchGestureRecognizer
    @discardableResult
    func addGesturePinch(_ action: @escaping ((UIPinchGestureRecognizer) ->Void)) -> UIPinchGestureRecognizer {
        let obj = UIPinchGestureRecognizer(target: nil, action: nil)
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            if let gesture = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: gesture.view!.superview)
                gesture.view!.center = location
                gesture.view!.transform = gesture.view!.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1.0
                action(gesture)
            }
        }
        return obj
    }
    
    ///手势 - 旋转 UIRotationGestureRecognizer
    @discardableResult
    func addGestureRotation(_ action: @escaping ((UIRotationGestureRecognizer) ->Void)) -> UIRotationGestureRecognizer {
        let obj = UIRotationGestureRecognizer(target: nil, action: nil)
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            if let gesture = recognizer as? UIRotationGestureRecognizer {
                gesture.view!.transform = gesture.view!.transform.rotated(by: gesture.rotation)
                gesture.rotation = 0.0
                          
                action(gesture)
            }
        }
        return obj
    }

    ///呈现到 UIApplication.shared.keyWindow 上
    func show(_ animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let keyWindow = keyWindow else { return }
        if keyWindow.subviews.contains(self) {
            self.dismiss()
        }
        
        if self.frame.equalTo(.zero) {
            self.frame = UIScreen.main.bounds
        }
        
        keyWindow.endEditing(true)
        keyWindow.addSubview(self)

        let duration = animated ? 0.15 : 0
        UIView.animate(withDuration: duration, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
        }, completion: completion)
    }
    ///从 UIApplication.shared.keyWindow 上移除
    func dismiss(_ animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        let duration = animated ? 0.15 : 0
        UIView.animate(withDuration: duration, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)

        }) { (isFinished) in
            completion?(isFinished)
            self.removeFromSuperview()
        }
    }
    
    /// 获取特定类型父视图
    func findSupView(_ type: UIView.Type) -> UIView? {
        var supView = superview
        while supView != nil {
            if supView!.isKind(of: type) {
                return supView
            }
            supView = supView?.superview
        }
        return nil
    }
        
    /// 获取特定类型子视图
    func findSubView(_ type: UIView.Type) -> UIView? {
        for e in self.subviews.enumerated() {
            if e.element.isKind(of: type) {
                return e.element
            }
        }
        return nil
    }

    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    ///往复动画
    func animationCycle(_ transformBlock: @escaping ((CGAffineTransform) -> Void), animated: Bool, completion: ((Bool) -> Void)? = nil) {
        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration, animations: {
            if self.transform.isIdentity == true {
                transformBlock(self.transform)
            } else {
                self.transform = CGAffineTransform.identity
            }
        }, completion: completion)
    }
    
    ///移动动画
    func move(_ x: CGFloat, y: CGFloat, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration, animations: {
            if self.transform.isIdentity == true {
                self.transform = self.transform.translatedBy(x: x, y: y)
            } else {
                self.transform = CGAffineTransform.identity
            }
        }, completion: completion)
    }
    
    ///旋转动画
    func rotate(_ angle: CGFloat, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration, animations: {
            if self.transform.isIdentity == true {
                self.transform = self.transform.rotated(by: angle)
            } else {
                self.transform = CGAffineTransform.identity
            }

        }, completion: completion)
    }
    ///转为图像
    func convertToImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        self.layer.render(in: ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    func snapshotImage() -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 截图:实际是把layer上面的东西绘制到上下文中
        layer.render(in: ctx)
//        self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        // 保存相册
        // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // 注释掉，因为参数不正确
        return image
    }
    
    func snapshotImageAfterScreenUpdates(_ afterUpdates: Bool) -> UIImage?{
        if !self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            return self.snapshotImage()
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterUpdates)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
        
    /// 插入模糊背景
    @discardableResult
    func insertVisualEffectView(style: UIBlurEffect.Style = .light) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurView, at: 0)
        return blurView
    }
}


public extension UIView{
    
    /// 获取特定类型父视图
    final func supView<T: UIView>(_ type: T.Type) -> T? {
        var supView = superview
        while supView?.isKind(of: type.self) == false {
            supView = supView?.superview
        }
        return supView.self as? T
    }
        
    /// 获取特定类型子视图
    final func subView<T: UIView>(_ type: T.Type) -> T? {
        for e in self.subviews.enumerated() {
            if e.element.isKind(of: type) {
                return (e.element.self as! T)
            }
        }
        return nil
    }
}

public extension Array where Element : UIView {
    ///手势 - 轻点 UITapGestureRecognizer
    @discardableResult
    func addGestureTap(_ action: @escaping ((UIGestureRecognizer) ->Void)) -> [UITapGestureRecognizer] {
        
        var list = [UITapGestureRecognizer]()
        forEach {
            let obj = $0.addGestureTap(action)
            list.append(obj)
        }
        return list
    }
}



@objc public extension UIView{

    /// 原生 inset 布局
    func equalToSuperview(_ inset: UIEdgeInsets) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -inset.right).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: inset.left).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom).isActive = true
    }
    
    func heightEqualTo(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func widthEqualTo(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

}
