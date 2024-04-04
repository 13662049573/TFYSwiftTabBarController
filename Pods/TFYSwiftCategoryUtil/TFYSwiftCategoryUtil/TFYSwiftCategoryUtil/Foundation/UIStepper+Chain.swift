//
//  UIStepper+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UIStepper {
    
    @discardableResult
    func isContinuous(_ isContinuous: Bool) -> TFY {
        base.isContinuous = isContinuous
        return self
    }
    
    @discardableResult
    func autorepeat(_ autorepeat: Bool) -> TFY {
        base.autorepeat = autorepeat
        return self
    }
    
    @discardableResult
    func wraps(_ wraps: Bool) -> TFY {
        base.wraps = wraps
        return self
    }
    
    @discardableResult
    func value(_ value: Double) -> TFY {
        base.value = value
        return self
    }
    
    @discardableResult
    func minimumValue(_ minimumValue: Double) -> TFY {
        base.minimumValue = minimumValue
        return self
    }
    
    @discardableResult
    func maximumValue(_ maximumValue: Double) -> TFY {
        base.maximumValue = maximumValue
        return self
    }
    
    @discardableResult
    func stepValue(_ stepValue: Double) -> TFY {
        base.stepValue = stepValue
        return self
    }
    
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State...) -> TFY {
        state.forEach { base.setBackgroundImage(image, for: $0) }
        return self
    }
    
    @discardableResult
    func dividerImage(_ image: UIImage?,
                      forLeftSegmentState leftState: UIControl.State,
                      rightSegmentState rightState: UIControl.State) -> TFY {
        base.setDividerImage(image, forLeftSegmentState: leftState, rightSegmentState: rightState)
        return self
    }
    
    @discardableResult
    func incrementImage(_ image: UIImage?, for state: UIControl.State) -> TFY {
        base.setIncrementImage(image, for: state)
        return self
    }
    
    @discardableResult
    func decrementImage(_ image: UIImage?, for state: UIControl.State) -> TFY {
        base.setDecrementImage(image, for: state)
        return self
    }
}
