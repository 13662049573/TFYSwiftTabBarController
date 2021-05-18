//
//  NavigationBase.swift
//  TFYSwiftNavigationKit
//
//  Created by 田风有 on 2021/5/15.
//

import Foundation
import UIKit

public struct Navigation<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol NavigationCompatible {}
public extension NavigationCompatible {
    static var navigation: Navigation<Self>.Type {
        set {}
        get { Navigation<Self>.self }
    }
    
    var navigation: Navigation<Self> {
        set {}
        get { Navigation(self) }
    }
}

public struct NavigationShadow {
    
    let color: CGColor?
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
    let path: CGPath?
    
    public static let none: NavigationShadow = .init()
    
    public init(
        color: CGColor? = nil,
        opacity: Float = 0,
        offset: CGSize = CGSize(width: 0, height: -3),
        radius: CGFloat = 3,
        path: CGPath? = nil
    ) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
        self.path = path
    }
}

extension CALayer {
    
    func apply(_ shadow: NavigationShadow) {
        shadowColor = shadow.color
        shadowOpacity = shadow.opacity
        shadowOffset = shadow.offset
        shadowRadius = shadow.radius
        shadowPath = shadow.path
    }
}

extension CGFloat {

    static let navigationBarHeight: CGFloat = 44.0
    
    static var statusBarMaxY: CGFloat {
        if #available(iOS 13, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            
            return keyWindow?.windowScene?.statusBarManager?.statusBarFrame.maxY ?? .zero
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath:"statusBarWindow.statusBar") as? UIView
            return (statusBar?.frame.maxY)!
        }
    }
}

extension UIEdgeInsets {
    
    static let barLayoutPaddings: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    
    static let barLayoutMargins: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
}

//MARK: 扩展UIApplication
extension UIApplication {
    
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245
            let keyWindow = UIApplication.shared.connectedScenes
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
     }
}
