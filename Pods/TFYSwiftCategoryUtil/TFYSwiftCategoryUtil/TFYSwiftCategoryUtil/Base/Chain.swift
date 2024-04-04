//
//  Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public struct TFY<Base> {
    
    public let base: Base
    
    public var build: Base {
        return base
    }
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol TFYCompatible {}

public extension TFYCompatible {
    
    static var tfy: TFY<Self>.Type {
        get{ TFY<Self>.self }
        set {}
    }
    
    var tfy: TFY<Self> {
        get { TFY(self) }
        set {}
    }
}

/// Define Property protocol
internal protocol TFYSwiftPropertyCompatible {
    /// Extended type
    associatedtype T
    ///Alias for callback function
    typealias SwiftCallBack = ((T?) -> ())
    ///Define the calculated properties of the closure type
    var swiftCallBack: SwiftCallBack?  { get set }
}

extension NSObject: TFYCompatible {}

public protocol UINibCreater {
    func nib(in bundle:Bundle?) -> UINib
    func storyboard(in bundle:Bundle?) -> UIStoryboard
}

extension String : UINibCreater {
    
    public func nib(in bundle:Bundle? = nil) -> UINib {
        return UINib(nibName: self, bundle: bundle)
    }
    
    public func storyboard(in bundle:Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: self, bundle: bundle)
    }
    
}

public protocol UINibInstantiable: AnyObject {
    
    static func instantiate(atNib index:Int, withOwner owner: Any?) -> Self
}

extension UINibInstantiable where Self : UIView {
    
    public static func instantiate(atNib index:Int, withOwner owner: Any? = nil) -> Self {
        
        let identifier = NSStringFromClass(classForCoder()).split(separator: ".").last!.description
        
        return identifier.nib().instantiate(withOwner: owner, options: nil)[index] as! Self
    }
}

extension UINibInstantiable where Self : NSObject {
    
    public static func instantiate(atNib index:Int, withOwner owner: Any? = nil) -> Self {
        
        let identifier = NSStringFromClass(classForCoder()).split(separator: ".").last!.description
        
        return identifier.nib().instantiate(withOwner: owner, options: nil)[index] as! Self
    }
}

extension RawRepresentable where RawValue == String {
    
    public func nib(in bundle:Bundle? = nil) -> UINib {
        return UINib(nibName: rawValue, bundle: bundle)
    }
    
    public func storyboard(in bundle:Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: bundle)
    }
    
}
