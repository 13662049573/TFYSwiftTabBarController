//
//  UIScrollView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UIScrollView {
    
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate?) -> TFY {
        base.delegate = delegate
        return self
    }
    
    @discardableResult
    func contentOffset(_ contentOffset: CGPoint) -> TFY {
        base.contentOffset = contentOffset
        return self
    }
    
    @discardableResult
    func contentOffset(x: CGFloat, y: CGFloat) -> TFY {
        base.contentOffset = CGPoint(x: x, y: y)
        return self
    }
    
    @discardableResult
    func contentSize(_ contentSize: CGSize) -> TFY {
        base.contentSize = contentSize
        return self
    }
    
    @discardableResult
    func contentSize(width: CGFloat, height: CGFloat) -> TFY {
        base.contentSize = CGSize(width: width, height: height)
        return self
    }
    
    @discardableResult
    func contentInset(_ contentInset: UIEdgeInsets) -> TFY {
        base.contentInset = contentInset
        return self
    }
    
    @discardableResult
    func contentInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> TFY {
        base.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    func contentInsetAdjustmentBehavior(_ contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior) -> TFY {
        base.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        return self
    }
    
    @discardableResult
    func isDirectionalLockEnabled(_ isDirectionalLockEnabled: Bool) -> TFY {
        base.isDirectionalLockEnabled = isDirectionalLockEnabled
        return self
    }
    
    @discardableResult
    func bounces(_ bounces: Bool) -> TFY {
        base.bounces = bounces
        return self
    }
    
    @discardableResult
    func alwaysBounceVertical(_ alwaysBounceVertical: Bool) -> TFY {
        base.alwaysBounceVertical = alwaysBounceVertical
        return self
    }
    
    @discardableResult
    func alwaysBounceHorizontal(_ alwaysBounceHorizontal: Bool) -> TFY {
        base.alwaysBounceHorizontal = alwaysBounceHorizontal
        return self
    }
    
    @discardableResult
    func isPagingEnabled(_ isPagingEnabled: Bool) -> TFY {
        base.isPagingEnabled = isPagingEnabled
        return self
    }
    
    @discardableResult
    func isScrollEnabled(_ isScrollEnabled: Bool) -> TFY {
        base.isScrollEnabled = isScrollEnabled
        return self
    }
    
    @discardableResult
    func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> TFY {
        base.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }
    
    @discardableResult
    func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> TFY {
        base.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }
    
    @discardableResult
    func scrollIndicatorInsets(_ scrollIndicatorInsets: UIEdgeInsets) -> TFY {
        base.scrollIndicatorInsets = scrollIndicatorInsets
        return self
    }
    
    @discardableResult
    func scrollIndicatorInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> TFY {
        base.scrollIndicatorInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    @discardableResult
    func bounces(bounces b: Bool) -> TFY {
        base.bounces = b
        return self
    }
    
    @discardableResult
    func indicatorStyle(style s: UIScrollView.IndicatorStyle) -> TFY {
        base.indicatorStyle = s
        return self
    }
    
    @discardableResult
    func decelerationRate(rate r: UIScrollView.DecelerationRate) -> TFY {
        base.decelerationRate = r
        return self
    }
    
    @discardableResult
    func indexDisplayMode(displayMode m: UIScrollView.IndexDisplayMode) -> TFY {
        base.indexDisplayMode = m
        return self
    }
    
    @discardableResult
    func setContentOffset(contentOffset p:CGPoint, _ animated:Bool = true) -> TFY {
        base.setContentOffset(p, animated: animated)
        return self
    }
    
    @discardableResult
    func scrollRectToVisible(rectToVisible r:CGRect, _ animated:Bool = true) -> TFY {
        base.scrollRectToVisible(r, animated: animated)
        return self
    }
    
    @discardableResult
    func flashScrollIndicators() -> TFY {
        base.flashScrollIndicators()
        return self
    }
    
    @discardableResult
    func delaysContentTouches(contentTouches b:Bool) -> TFY {
        base.delaysContentTouches = b
        return self
    }
    
    @discardableResult
    func canCancelContentTouches(contentTouches b:Bool) -> TFY {
        base.canCancelContentTouches = b
        return self
    }
    
    @discardableResult
    func bouncesZoom(zoom b:Bool) -> TFY {
        base.bouncesZoom = b
        return self
    }
    @discardableResult
    func scrollsToTop(_ b:Bool = true) -> TFY {
        base.scrollsToTop = b
        return self
    }
    
    @discardableResult
    func minimumZoomScale(imumZoomScale a:CGFloat) -> TFY {
        base.minimumZoomScale = a
        return self
    }
    
    @discardableResult
    func maximumZoomScale(scale a:CGFloat) -> TFY {
        base.maximumZoomScale = a
        return self
    }
    
    @discardableResult
    func setZoomScale(zoomScale a:CGFloat, _ animated:Bool = true) -> TFY {
        base.setZoomScale(a, animated: animated)
        return self
    }
    
    @discardableResult
    func zoom(toRect a:CGRect, _ animated:Bool = true) -> TFY {
        base.zoom(to: a, animated: animated)
        return self
    }
    
    @discardableResult
    func keyboardDismissMode(dismissMode a:UIScrollView.KeyboardDismissMode) -> TFY {
        base.keyboardDismissMode = a
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    func refreshControl(control a:UIRefreshControl?) -> TFY {
        base.refreshControl = a
        return self
    }
    
    /// 右滑返回
    @discardableResult
    func panBack(_ gesture: UIGestureRecognizer, otherGesture:UIGestureRecognizer) -> Bool {
        if base.contentOffset.x <= 0,
            let delegate = otherGesture.delegate,
            let fdFulls = NSClassFromString("_FDFullscreenPopGestureRecognizerDelegate").self,
            delegate.isKind(of: fdFulls) {
            return true
        }
        else if gesture == base.panGestureRecognizer,
            let pan:UIPanGestureRecognizer = gesture as? UIPanGestureRecognizer {
            let point = pan.translation(in: base)
            let state = pan.state
            if state == .began || state == .possible {
                let location = pan.location(in: base)
                if point.x >= 0 && location.x < 60 && base.contentOffset.x <= 0 {
                    return true
                }
            }
        }
        return false
    }
}

public extension UIScrollView {
    
    func scrollToTop(isAnimated: Bool) {
        var off = self.contentOffset
        off.y = 0 - self.contentInset.top
        self.setContentOffset(off, animated: isAnimated)
    }
    
    func scrollToLeft(isAnimated: Bool) {
        var off = self.contentOffset
        off.x = 0 - self.contentInset.left
        self.setContentOffset(off, animated: isAnimated)
    }
    
    func scrollToBottom(isAnimated: Bool) {
        var off = self.contentOffset
        off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
        self.setContentOffset(off, animated: isAnimated)
    }
    
    func scrollToRight(isAnimated: Bool) {
        var off = self.contentOffset
        off.x = self.contentSize.width - self.bounds.width + self.contentInset.right
        self.setContentOffset(off, animated: isAnimated)
    }
    
    func scrollToTop() {
        scrollToTop(isAnimated: true)
    }
    
    func scrollToLeft() {
        scrollToLeft(isAnimated: true)
    }
    
    func scrollToBottom() {
        scrollToBottom(isAnimated: true)
    }
    
    func scrollToRight() {
        scrollToRight(isAnimated: true)
    }
}
