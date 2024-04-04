//
//  UIStackView+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public extension TFY where Base: UIStackView {
    
    @discardableResult
    func addArranged(subview view: UIView) -> TFY {
        base.addArrangedSubview(view)
        return self
    }
    
    @discardableResult
    func removeArranged(subview view: UIView) -> TFY {
        base.removeArrangedSubview(view)
        return self
    }
    
    @discardableResult
    func insertArranged(subview view: UIView, at:Int) -> TFY {
        base.insertArrangedSubview(view, at: at)
        return self
    }
    
    @discardableResult
    func axis(_ a: NSLayoutConstraint.Axis) -> TFY {
        base.axis = a
        return self
    }
    
    @discardableResult
    func distribution(_ a: UIStackView.Distribution) -> TFY {
        base.distribution = a
        return self
    }
    
    @discardableResult
    func alignment(_ a: UIStackView.Alignment) -> TFY {
        base.alignment = a
        return self
    }

    @discardableResult
    func spacing(_ a: CGFloat) -> TFY {
        base.spacing = a
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func custom(_ spacing: CGFloat, after arrangedSubview: UIView) -> TFY {
        base.setCustomSpacing(spacing, after: arrangedSubview)
        return self
    }
    
    @discardableResult
    func isBaselineRelativeArrangement(_ a: Bool) -> TFY {
        base.isBaselineRelativeArrangement = a
        return self
    }
    
    @discardableResult
    func isLayoutMarginsRelativeArrangement(_ a: Bool) -> TFY {
        base.isLayoutMarginsRelativeArrangement = a
        return self
    }
}
