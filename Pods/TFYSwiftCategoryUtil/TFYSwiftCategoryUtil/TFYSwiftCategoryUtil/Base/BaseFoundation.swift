//
//  BaseFoundation.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/4/29.
//

import Foundation
import UIKit

public struct TFY<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol TFYCompatible {}
public extension TFYCompatible {
    static var tfy: TFY<Self>.Type {
        set {}
        get { TFY<Self>.self }
    }
    
    var tfy: TFY<Self> {
        set {}
        get { TFY(self) }
    }
}

// MARK: - 具有泛型参数的类型的协议
public struct TFYGeneric<Base, T> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol TFYGenericCompatible {
    associatedtype T
}

public extension TFYGenericCompatible {
    static var tfy: TFYGeneric<Self, T>.Type {
        get { return TFYGeneric<Self, T>.self }
        set {}
    }
    var tfy: TFYGeneric<Self, T> {
        get { return TFYGeneric(self) }
        set {}
    }
}

// MARK: - 具有两个泛型参数的类型的协议2
public struct TFYGeneric2<Base, T1, T2> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol TFYGenericCompatible2 {
    associatedtype T1
    associatedtype T2
}

public extension TFYGenericCompatible2 {
    static var tfy: TFYGeneric2<Self, T1, T2>.Type {
        get { return TFYGeneric2<Self, T1, T2>.self }
        set {}
    }
    var tfy: TFYGeneric2<Self, T1, T2> {
        get { return TFYGeneric2(self) }
        set {}
    }
}


public protocol TFYNibLoadable: AnyObject {
  /// nib文件用于加载XIB中设计的视图的新实例
  static var nib: UINib { get }
}

// MARK: 默认实现
public extension TFYNibLoadable {
  /// 默认情况下，使用与类名相同的nib，
  /// 并位于那个类的包中
  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }
}

// MARK: 支持从NIB实例化
public extension TFYNibLoadable where Self: UIView {
  /// 返回一个从nib实例化的UIView对象
   static func loadFromNib() -> Self {
    guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
      fatalError("The nib \(nib) expected its root view to be of type \(self)")
    }
    return view
  }
}

public protocol TFYReusable: AnyObject {
  /// 他重用标识符，以便在注册一个可重用的单元并在随后退出队列时使用
  static var reuseIdentifier: String { get }
}

/// 让你的' UITableViewCell '和' UICollectionViewCell '子类
public typealias TFYNibReusable = TFYReusable & TFYNibLoadable

// MARK: - 默认实现
public extension TFYReusable {
  /// 默认情况下，使用类名作为其reuseIdentifier的String
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

/// 定义财产协议
internal protocol TFYSwiftPropertyCompatible {
    /// 扩展的类型
    associatedtype T
    /// 回调函数的别名
    typealias SwiftCallBack = ((T?) -> ())
    /// 定义闭包类型的计算属性
    var swiftCallBack: SwiftCallBack?  { get set }
}

/// 类型view
extension NSObject: TFYCompatible {}


