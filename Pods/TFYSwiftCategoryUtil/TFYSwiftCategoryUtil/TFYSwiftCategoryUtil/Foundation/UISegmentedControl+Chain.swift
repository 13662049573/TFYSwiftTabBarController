//
//  UISegmentedControl+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UISegmentedControl {
    
    @discardableResult
    func title(_ title: String?, forSegmentAt segment: Int) -> TFY {
        base.setTitle(title, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage?, forSegmentAt segment: Int) -> TFY {
        base.setImage(image, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, forSegmentAt segment: Int) -> TFY {
        base.setWidth(width, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func contentOffset(_ offset: CGSize, forSegmentAt segment: Int) -> TFY {
        base.setContentOffset(offset, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func enabled(_ enabled: Bool, forSegmentAt segment: Int) -> TFY {
        base.setEnabled(enabled, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func selectedSegmentIndex(_ selectedSegmentIndex: Int) -> TFY {
        base.selectedSegmentIndex = selectedSegmentIndex
        return self
    }
    
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State..., barMetrics: UIBarMetrics) -> TFY {
        state.forEach { base.setBackgroundImage(backgroundImage, for: $0, barMetrics: barMetrics) }
        return self
    }
    
    @discardableResult
    func dividerImage(_ dividerImage: UIImage?,
                      forLeftSegmentState leftState: UIControl.State,
                      rightSegmentState rightState: UIControl.State,
                      barMetrics: UIBarMetrics) -> TFY {
        base.setDividerImage(dividerImage, forLeftSegmentState: leftState, rightSegmentState: rightState, barMetrics: barMetrics)
        return self
    }
    
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State...) -> TFY {
        state.forEach { base.setTitleTextAttributes(attributes, for: $0) }
        return self
    }
    
    @discardableResult
    func contentPositionAdjustment(_ adjustment: UIOffset,
                                   forSegmentType leftCenterRightOrAlone: UISegmentedControl.Segment,
                                   barMetrics: UIBarMetrics) -> TFY {
        base.setContentPositionAdjustment(adjustment, forSegmentType: leftCenterRightOrAlone, barMetrics: barMetrics)
        return self
    }
}
