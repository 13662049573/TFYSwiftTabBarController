//
//  WKOperatorLayout.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//

import Foundation
import UIKit

#if swift(>=5.1)
public protocol LayoutConstraintElements {
    var list:[NSLayoutConstraint] { get }
}

extension NSLayoutConstraint: LayoutConstraintElements {
    public var list:[NSLayoutConstraint] { return [self] }
}

extension Array : LayoutConstraintElements where Element : NSLayoutConstraint {
    public var list:[NSLayoutConstraint] { return self }
}

@resultBuilder public struct LayoutBuilder {
    ///传递可变的布局约束写为子布局约束(例如..G， ' {a.anchor.top == b.anchor.top…}”)通过
    public static func buildBlock(_ constraints: LayoutConstraintElements?...) -> [NSLayoutConstraint] {
        return constraints
            .compactMap { $0?.list }
            .reduce([], +)
    }
}

extension LayoutBuilder {
    ///在多语句闭包中支持“if”语句，生成一个“Optional”视图
    ///只有当if条件为true时才可见。
    public static func buildIf(_ content: [NSLayoutConstraint]?) -> [NSLayoutConstraint]? {
        return content
    }
    
    ///在多语句闭包中支持"if"语句，生成
    /// [NSLayoutConstraint]用于"then"分支。
    public static func buildEither(first: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return first
    }
    
    ///在多语句闭包中支持"if-else"语句，生成
    /// [NSLayoutConstraint]用于"else"分支。
    public static func buildEither(second: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return second
    }
}

extension UIView {
    public func layoutConstraints(@LayoutBuilder _ layouts: () -> [NSLayoutConstraint]) {
        addConstraints(layouts())
    }
}

#endif

public struct NSViewLayoutAttribute {
    public var attributed:NSLayoutConstraint.Attribute
    public var view:NSObjectProtocol
    public var constant:CGFloat = 0
    public var multiplier:CGFloat? = nil
    
    public init(_ view:UIView, _ attributed:NSLayoutConstraint.Attribute) {
        self.attributed = attributed
        self.view = view
    }
    
    public init<T>(_ view:T, _ attributed:NSLayoutConstraint.Attribute) where T : UILayoutSupport {
        self.attributed = attributed
        self.view = view
    }
    
    @available(iOS 9.0, *)
    public init(_ grade:UILayoutGuide, _ attributed:NSLayoutConstraint.Attribute) {
        self.attributed = attributed
        self.view = grade
    }
}

extension UILayoutPriority : @retroactive ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Float(exactly: value) ?? UILayoutPriority.defaultHigh.rawValue)
    }
}

extension UILayoutPriority : @retroactive ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Float
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension UILayoutPriority {
    public static let levelRequired = UILayoutPriority.required
    public static let levelHigh = UILayoutPriority.defaultHigh
    public static let levelLow = UILayoutPriority.defaultLow
    public static let levelFittingSize = UILayoutPriority.fittingSizeLevel
    
    public static func +(lhs:UILayoutPriority, rhs:Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue + rhs)
    }
    public static func -(lhs:UILayoutPriority, rhs:Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue - rhs)
    }
    public static func *(lhs:UILayoutPriority, rhs:Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue * rhs)
    }
    public static func /(lhs:UILayoutPriority, rhs:Float) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue / rhs)
    }
    
    public static func +(lhs:UILayoutPriority, rhs:Int) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue + Float(rhs))
    }
    public static func -(lhs:UILayoutPriority, rhs:Int) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue - Float(rhs))
    }
    public static func *(lhs:UILayoutPriority, rhs:Int) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue * Float(rhs))
    }
    public static func /(lhs:UILayoutPriority, rhs:Int) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue / Float(rhs))
    }
}

extension NSLayoutConstraint {
    @inline(__always)
    public static func &&(lhs:NSLayoutConstraint, rhs:UILayoutPriority) -> NSLayoutConstraint {
        lhs.priority = rhs
        return lhs
    }
    
    @inline(__always)
    public static func &&(lhs:NSLayoutConstraint, rhs:Float) -> NSLayoutConstraint {
        lhs.priority = UILayoutPriority(rawValue: rhs)
        return lhs
    }
    
    @inline(__always)
    public static func &&(lhs:NSLayoutConstraint, rhs:Int) -> NSLayoutConstraint {
        lhs.priority = UILayoutPriority(rawValue: Float(rhs))
        return lhs
    }
    
    
    @inline(__always)
    public static func *(lhs:NSLayoutConstraint, rhs:CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: lhs.firstItem!, attribute: lhs.firstAttribute, relatedBy: lhs.relation, toItem: lhs.secondItem, attribute: lhs.secondAttribute, multiplier: rhs, constant: lhs.constant)
    }
    @inline(__always)
    public static func *(lhs:NSLayoutConstraint, rhs:Double) -> NSLayoutConstraint {
        return lhs * CGFloat(rhs)
    }
    @inline(__always)
    public static func *(lhs:NSLayoutConstraint, rhs:Float) -> NSLayoutConstraint {
        return lhs * CGFloat(rhs)
    }
    @inline(__always)
    public static func *(lhs:NSLayoutConstraint, rhs:Int) -> NSLayoutConstraint {
        return lhs * CGFloat(rhs)
    }

}

extension NSViewLayoutAttribute {
    @inline(__always)
    public static func *(lhs:NSViewLayoutAttribute, rhs:CGFloat) -> NSViewLayoutAttribute {
        var result = lhs
        if let multiplier = result.multiplier {
            result.multiplier = multiplier * rhs
        } else {
            result.multiplier = rhs
        }
        return result
    }
    
    @inline(__always)
    public static func *(lhs:NSViewLayoutAttribute, rhs:Double) -> NSViewLayoutAttribute {
        return lhs * CGFloat(rhs)
    }
    @inline(__always)
    public static func *(lhs:NSViewLayoutAttribute, rhs:Float) -> NSViewLayoutAttribute {
        return lhs * CGFloat(rhs)
    }
    @inline(__always)
    public static func *(lhs:NSViewLayoutAttribute, rhs:Int) -> NSViewLayoutAttribute {
        return lhs * CGFloat(rhs)
    }
    
    @inline(__always)
    public static func +(lhs:NSViewLayoutAttribute, rhs:CGFloat) -> NSViewLayoutAttribute {
        var result = lhs
        result.constant += rhs
        return result
    }
    @inline(__always)
    public static func -(lhs:NSViewLayoutAttribute, rhs:CGFloat) -> NSViewLayoutAttribute {
        return lhs + -rhs
    }
    @inline(__always)
    public static func +(lhs:NSViewLayoutAttribute, rhs:Double) -> NSViewLayoutAttribute {
        return lhs + CGFloat(rhs)
    }
    @inline(__always)
    public static func -(lhs:NSViewLayoutAttribute, rhs:Double) -> NSViewLayoutAttribute {
        return lhs - CGFloat(rhs)
    }
    @inline(__always)
    public static func +(lhs:NSViewLayoutAttribute, rhs:Float) -> NSViewLayoutAttribute {
        return lhs + CGFloat(rhs)
    }
    @inline(__always)
    public static func -(lhs:NSViewLayoutAttribute, rhs:Float) -> NSViewLayoutAttribute {
        return lhs - CGFloat(rhs)
    }
    @inline(__always)
    public static func +(lhs:NSViewLayoutAttribute, rhs:Int) -> NSViewLayoutAttribute {
        return lhs + CGFloat(rhs)
    }
    @inline(__always)
    public static func -(lhs:NSViewLayoutAttribute, rhs:Int) -> NSViewLayoutAttribute {
        return lhs - CGFloat(rhs)
    }
    
    @inline(__always)
    private static func compare(_ lhs:NSViewLayoutAttribute, _ rhs:NSViewLayoutAttribute, relatedBy relation:NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let value = rhs.multiplier ?? lhs.multiplier ?? 1
        return NSLayoutConstraint(item: lhs.view, attribute: lhs.attributed, relatedBy: relation, toItem: rhs.view, attribute: rhs.attributed, multiplier: value, constant: rhs.constant - lhs.constant)
    }
    
    @inline(__always)
    private static func compare(_ lhs:NSViewLayoutAttribute, _ rhs:CGFloat, relatedBy relation:NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let value = lhs.multiplier ?? 1
        return NSLayoutConstraint(item: lhs.view, attribute: lhs.attributed, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: value, constant: rhs)
    }
    
    public static func ==(lhs:NSViewLayoutAttribute, rhs:NSViewLayoutAttribute) -> NSLayoutConstraint {
        return compare(lhs, rhs, relatedBy: .equal)
    }
    
    public static func <=(lhs:NSViewLayoutAttribute, rhs:NSViewLayoutAttribute) -> NSLayoutConstraint {
        return compare(lhs, rhs, relatedBy: .lessThanOrEqual)
    }
    
    public static func >=(lhs:NSViewLayoutAttribute, rhs:NSViewLayoutAttribute) -> NSLayoutConstraint {
        return compare(lhs, rhs, relatedBy: .greaterThanOrEqual)
    }
    
    
    public static func ==(lhs:NSViewLayoutAttribute, rhs:CGFloat) -> NSLayoutConstraint {
        return compare(lhs, rhs, relatedBy: .equal)
    }
    public static func <=(lhs:NSViewLayoutAttribute, rhs:CGFloat) -> NSLayoutConstraint {
        return compare(lhs, rhs, relatedBy: .lessThanOrEqual)
    }
    public static func >=(lhs:NSViewLayoutAttribute, rhs:CGFloat) -> NSLayoutConstraint {
        return compare(lhs, rhs, relatedBy: .greaterThanOrEqual)
    }
    
    @inline(__always)
    public static func ==(lhs:NSViewLayoutAttribute, rhs:Double) -> NSLayoutConstraint {
        return lhs == CGFloat(rhs)
    }
    @inline(__always)
    public static func <=(lhs:NSViewLayoutAttribute, rhs:Double) -> NSLayoutConstraint {
        return lhs <= CGFloat(rhs)
    }
    @inline(__always)
    public static func >=(lhs:NSViewLayoutAttribute, rhs:Double) -> NSLayoutConstraint {
        return lhs >= CGFloat(rhs)
    }
    @inline(__always)
    public static func ==(lhs:NSViewLayoutAttribute, rhs:Float) -> NSLayoutConstraint {
        return lhs == CGFloat(rhs)
    }
    @inline(__always)
    public static func <=(lhs:NSViewLayoutAttribute, rhs:Float) -> NSLayoutConstraint {
        return lhs <= CGFloat(rhs)
    }
    @inline(__always)
    public static func >=(lhs:NSViewLayoutAttribute, rhs:Float) -> NSLayoutConstraint {
        return lhs >= CGFloat(rhs)
    }
    @inline(__always)
    public static func ==(lhs:NSViewLayoutAttribute, rhs:Int) -> NSLayoutConstraint {
        return lhs == CGFloat(rhs)
    }
    @inline(__always)
    public static func <=(lhs:NSViewLayoutAttribute, rhs:Int) -> NSLayoutConstraint {
        return lhs <= CGFloat(rhs)
    }
    @inline(__always)
    public static func >=(lhs:NSViewLayoutAttribute, rhs:Int) -> NSLayoutConstraint {
        return lhs >= CGFloat(rhs)
    }
}

@available(iOS 7.0, *)
public struct NSSafeAreaLayout {
    
    public var view:UIView
    public init(_ view:UIView) {
        self.view = view
    }
    
    public var left     :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .left)
        } else {
            return NSViewLayoutAttribute(view, .left)
        }
    }
    public var right    :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .right)
        } else {
            return NSViewLayoutAttribute(view, .right)
        }
    }
    public var top      :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .top)
        } else if let vc = view.viewController, vc.view === view {
            return NSViewLayoutAttribute(vc.topLayoutGuide, .bottom)
        } else {
            return NSViewLayoutAttribute(view, .top)
        }
    }
    public var bottom   :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .bottom)
        } else if let vc = view.viewController, vc.view === view {
            return NSViewLayoutAttribute(vc.bottomLayoutGuide, .top)
        } else {
            return NSViewLayoutAttribute(view, .bottom)
        }
    }
    public var leading  :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .leading)
        } else {
            return NSViewLayoutAttribute(view, .leading)
        }
    }
    public var trailing :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .trailing)
        } else {
            return NSViewLayoutAttribute(view, .trailing)
        }
    }
    public var centerX  :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .centerX)
        } else {
            return NSViewLayoutAttribute(view, .centerX)
        }
    }
    public var centerY  :NSViewLayoutAttribute {
        if #available(iOS 11.0, *) {
            return NSViewLayoutAttribute(view.safeAreaLayoutGuide, .centerY)
        } else {
            return NSViewLayoutAttribute(view, .centerY)
        }
    }


}

@available(iOS 8.0, *)
public struct NSMarginLayout {
    public var view:UIView
    public init(_ view:UIView) {
        self.view = view
    }
    
    public var left     :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .leftMargin) }
    public var right    :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .rightMargin) }
    public var top      :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .topMargin) }
    public var bottom   :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .bottomMargin) }
    public var leading  :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .leadingMargin) }
    public var trailing :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .trailingMargin) }
    public var centerX  :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .centerXWithinMargins) }
    public var centerY  :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .centerYWithinMargins) }
    public var baseline :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .firstBaseline) }
}


@available(iOS 8.0, *)
public struct NSAnchorLayout {
    public var view:UIView
    public init(_ view:UIView) {
        self.view = view
    }
    public var width    :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .width) }
    public var height   :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .height) }
    
    public var left     :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .left) }
    public var right    :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .right) }
    public var top      :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .top) }
    public var bottom   :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .bottom) }
    public var leading  :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .leading) }
    public var trailing :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .trailing) }
    public var centerX  :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .centerX) }
    public var centerY  :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .centerY) }
    public var baseline :NSViewLayoutAttribute { return NSViewLayoutAttribute(view, .lastBaseline) }

}

extension UILayoutSupport {
    public var top      :NSViewLayoutAttribute { return NSViewLayoutAttribute(self, .top) }
    public var bottom   :NSViewLayoutAttribute { return NSViewLayoutAttribute(self, .bottom) }
}

public struct UILayoutContainer {
    public var view:UIView
    
    @discardableResult
    public func constraint(_ constraint:@autoclosure () -> NSLayoutConstraint) -> UILayoutContainer {
        view.addConstraint(constraint())
        return self
    }
    
    @discardableResult
    public func removeConstraints(`where` constraint:(NSLayoutConstraint) throws -> Bool) rethrows -> UILayoutContainer {
        let constraints = try view.constraints.filter(constraint)
        if !constraints.isEmpty {
            view.removeConstraints(constraints)
        }
        return self
    }
}

extension UIView {
    public var viewController:UIViewController? {
        var responder:UIResponder! = next
        while responder != nil {
            if responder is UIViewController {
                return responder as? UIViewController
            }
            responder = responder.next
        }
        return nil
    }
    
    @available(iOS 8.0, *)
    public var safeArea :NSSafeAreaLayout { return NSSafeAreaLayout(self) }
    
    @available(iOS 8.0, *)
    public var margin   :NSMarginLayout { return NSMarginLayout(self) }
    @available(iOS 8.0, *)
    public var anchor   :NSAnchorLayout { return NSAnchorLayout(self) }

    public func remove(view:UIView) {
        removeConstraints(by: view)
        view.translatesAutoresizingMaskIntoConstraints = true
        view.removeFromSuperview()
    }
    
    public func remove(view:UIView, andConstraints:@convention(block) () -> [NSLayoutConstraint]) {
        removeConstraints(andConstraints())
        view.translatesAutoresizingMaskIntoConstraints = true
        view.removeFromSuperview()
    }
    
    public func removeConstraints(by view:UIView) {
        removeConstraints(constraints.filter({ $0.firstItem === view || $0.secondItem === view }))
    }
    
    public func removeConstraints(by view:UIView, layout:NSLayoutConstraint.Attribute) {
        removeConstraints(constraints.filter({ ($0.firstItem === view && $0.firstAttribute == layout) || ($0.secondItem === view && $0.secondAttribute == layout) }))
    }
    
    public func layoutSubview(_ view:UIView) -> UILayoutContainer {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return UILayoutContainer(view: self)
    }
    public func layoutSubview(_ view:UIView, at index: Int) -> UILayoutContainer {
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, at: index)
        return UILayoutContainer(view: self)
    }
    public func layoutSubview(_ view:UIView, aboveSubview siblingSubview: UIView) -> UILayoutContainer {
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, aboveSubview: siblingSubview)
        return UILayoutContainer(view: self)
    }
    public func layoutSubview(_ view:UIView, belowSubview siblingSubview: UIView) -> UILayoutContainer {
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, belowSubview: siblingSubview)
        return UILayoutContainer(view: self)
    }
    public func layout() -> UILayoutContainer {
        return UILayoutContainer(view: self)
    }
    
    public func addSubview(_ view:UIView, layouts: @convention(block) () -> [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraints(layouts())
    }
    
    public func addConstraints(_ layouts: @convention(block) (UIView) -> Void ) {
        layouts(self)
    }
    
    public func addSubview(_ view:UIView, layouts: @convention(block) (UIView) -> Void) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        layouts(self)
    }
    
    public func addSubviews(_ views:[UIView], layouts: @convention(block) () -> [NSLayoutConstraint]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        addConstraints(layouts())
    }
    public func addSubviews(_ views:[UIView], layouts: @convention(block) (UIView) -> Void) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        layouts(self)
    }
    
    public func layout(to view:UIView, insets:UIEdgeInsets) {
        view.layoutSubview(self)
            .constraint(self.anchor.leading     == view.anchor.leading + insets.left)
            .constraint(self.anchor.trailing    == view.anchor.trailing - insets.right)
            .constraint(self.anchor.top         == view.anchor.top + insets.top)
            .constraint(self.anchor.bottom      == view.anchor.bottom - insets.bottom)
    }
    
    public func layout(toMargin view:UIView, insets:UIEdgeInsets) {
        view.layoutMargins = insets
        view.layoutSubview(self)
            .constraint(self.anchor.leading     == view.margin.leading)
            .constraint(self.anchor.trailing    == view.margin.trailing)
            .constraint(self.anchor.top         == view.margin.top)
            .constraint(self.anchor.bottom      == view.margin.bottom)
    }
    
    public static func +=(lhs:UIView, rhs:NSLayoutConstraint) {
        lhs.addConstraint(rhs)
    }
    public static func -=(lhs:UIView, rhs:NSLayoutConstraint) {
        lhs.removeConstraint(rhs)
    }
    
}
