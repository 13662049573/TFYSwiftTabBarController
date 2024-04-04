//
//  UIGestureRecognizer+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UIGestureRecognizer {
    
    @discardableResult
    func addTarget(_ target: Any, action: Selector) -> TFY {
        base.addTarget(target, action: action)
        return self
    }
    
    @discardableResult
    func delegate(_ delegate: UIGestureRecognizerDelegate?) -> TFY {
        base.delegate = delegate
        return self
    }
    
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> TFY {
        base.isEnabled = isEnabled
        return self
    }
}

public extension TFY where Base: UITapGestureRecognizer {
    
    @discardableResult
    func numberOfTapsRequired(_ numberOfTapsRequired: Int) -> TFY {
        base.numberOfTapsRequired = numberOfTapsRequired
        return self
    }
    
    @discardableResult
    func numberOfTouchesRequired(_ numberOfTouchesRequired: Int) -> TFY {
        base.numberOfTouchesRequired = numberOfTouchesRequired
        return self
    }
}

public extension TFY where Base: UIPanGestureRecognizer {
    
    @discardableResult
    func minimumNumberOfTouches(_ minimumNumberOfTouches: Int) -> TFY {
        base.minimumNumberOfTouches = minimumNumberOfTouches
        return self
    }
    
    @discardableResult
    func maximumNumberOfTouches(_ maximumNumberOfTouches: Int) -> TFY {
        base.maximumNumberOfTouches = maximumNumberOfTouches
        return self
    }
}

public extension TFY where Base: UISwipeGestureRecognizer {
    
    @discardableResult
    func numberOfTouchesRequired(_ numberOfTouchesRequired: Int) -> TFY {
        base.numberOfTouchesRequired = numberOfTouchesRequired
        return self
    }
    
    @discardableResult
    func direction(_ direction: UISwipeGestureRecognizer.Direction) -> TFY {
        base.direction = direction
        return self
    }
}

public extension TFY where Base: UIPinchGestureRecognizer {
    
    @discardableResult
    func scale(_ scale: CGFloat) -> TFY {
        base.scale = scale
        return self
    }
}

public extension TFY where Base: UILongPressGestureRecognizer {
    
    @discardableResult
    func numberOfTapsRequired(_ numberOfTapsRequired: Int) -> TFY {
        base.numberOfTapsRequired = numberOfTapsRequired
        return self
    }
    
    @discardableResult
    func numberOfTouchesRequired(_ numberOfTouchesRequired: Int) -> TFY {
        base.numberOfTouchesRequired = numberOfTouchesRequired
        return self
    }
    
    @discardableResult
    func minimumPressDuration(_ minimumPressDuration: CFTimeInterval) -> TFY {
        base.minimumPressDuration = minimumPressDuration
        return self
    }
    
    @discardableResult
    func allowableMovement(_ allowableMovement: CGFloat) -> TFY {
        base.allowableMovement = allowableMovement
        return self
    }
}

public extension TFY where Base: UIRotationGestureRecognizer {
    
    @discardableResult
    func rotation(_ rotation: CGFloat) -> TFY {
        base.rotation = rotation
        return self
    }
}
