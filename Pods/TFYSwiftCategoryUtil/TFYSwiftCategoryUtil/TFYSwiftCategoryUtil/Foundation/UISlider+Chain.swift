//
//  UISlider+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UISlider {
    
    @discardableResult
    func value(_ value: Float) -> TFY {
        base.value = value
        return self
    }
    
    @discardableResult
    func minimumValue(_ minimumValue: Float) -> TFY {
        base.minimumValue = minimumValue
        return self
    }
    
    @discardableResult
    func maximumValue(_ maximumValue: Float) -> TFY {
        base.maximumValue = maximumValue
        return self
    }
    
    @discardableResult
    func minimumValueImage(_ minimumValueImage: UIImage?) -> TFY {
        base.minimumValueImage = minimumValueImage
        return self
    }
    
    @discardableResult
    func maximumValueImage(_ maximumValueImage: UIImage?) -> TFY {
        base.maximumValueImage = maximumValueImage
        return self
    }
    
    @discardableResult
    func isContinuous(_ isContinuous: Bool) -> TFY {
        base.isContinuous = isContinuous
        return self
    }
    
    @discardableResult
    func minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> TFY {
        base.minimumTrackTintColor = minimumTrackTintColor
        return self
    }
    
    @discardableResult
    func maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> TFY {
        base.maximumTrackTintColor = maximumTrackTintColor
        return self
    }
    
    @discardableResult
    func thumbTintColor(_ thumbTintColor: UIColor?) -> TFY {
        base.thumbTintColor = thumbTintColor
        return self
    }
}
