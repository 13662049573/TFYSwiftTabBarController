//
//  UIScrollView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UIScrollView {
    /// 设置代理
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    /// 设置内容偏移
    @discardableResult
    func contentOffset(_ contentOffset: CGPoint) -> Self {
        base.contentOffset = contentOffset
        return self
    }
    /// 设置内容偏移（分开设置）
    @discardableResult
    func contentOffset(x: CGFloat, y: CGFloat) -> Self {
        base.contentOffset = CGPoint(x: x, y: y)
        return self
    }
    /// 设置内容大小
    @discardableResult
    func contentSize(_ contentSize: CGSize) -> Self {
        base.contentSize = contentSize
        return self
    }
    /// 设置内容大小（分开设置）
    @discardableResult
    func contentSize(width: CGFloat, height: CGFloat) -> Self {
        base.contentSize = CGSize(width: max(0, width), height: max(0, height))
        return self
    }
    /// 设置内容内边距
    @discardableResult
    func contentInset(_ contentInset: UIEdgeInsets) -> Self {
        base.contentInset = contentInset
        return self
    }
    /// 设置内容内边距（分开设置）
    @discardableResult
    func contentInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        base.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    /// 设置内容内边距调整行为（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func contentInsetAdjustmentBehavior(_ contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        base.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        return self
    }
    /// 设置是否启用方向锁定
    @discardableResult
    func isDirectionalLockEnabled(_ isDirectionalLockEnabled: Bool) -> Self {
        base.isDirectionalLockEnabled = isDirectionalLockEnabled
        return self
    }
    /// 设置是否弹性滚动
    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        base.bounces = bounces
        return self
    }
    /// 设置是否总是垂直弹性滚动
    @discardableResult
    func alwaysBounceVertical(_ alwaysBounceVertical: Bool) -> Self {
        base.alwaysBounceVertical = alwaysBounceVertical
        return self
    }
    /// 设置是否总是水平弹性滚动
    @discardableResult
    func alwaysBounceHorizontal(_ alwaysBounceHorizontal: Bool) -> Self {
        base.alwaysBounceHorizontal = alwaysBounceHorizontal
        return self
    }
    /// 设置是否启用分页
    @discardableResult
    func isPagingEnabled(_ isPagingEnabled: Bool) -> Self {
        base.isPagingEnabled = isPagingEnabled
        return self
    }
    /// 设置是否启用滚动
    @discardableResult
    func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        base.isScrollEnabled = isScrollEnabled
        return self
    }
    /// 设置是否显示水平滚动指示器
    @discardableResult
    func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> Self {
        base.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }
    /// 设置是否显示垂直滚动指示器
    @discardableResult
    func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> Self {
        base.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }
    /// 设置滚动指示器内边距
    @discardableResult
    func scrollIndicatorInsets(_ scrollIndicatorInsets: UIEdgeInsets) -> Self {
        base.scrollIndicatorInsets = scrollIndicatorInsets
        return self
    }
    /// 设置滚动指示器内边距（分开设置）
    @discardableResult
    func scrollIndicatorInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        base.scrollIndicatorInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    /// 设置是否弹性滚动（别名方法）
    @discardableResult
    func bounces(bounces b: Bool) -> Self {
        base.bounces = b
        return self
    }
    /// 设置指示器样式
    @discardableResult
    func indicatorStyle(style s: UIScrollView.IndicatorStyle) -> Self {
        base.indicatorStyle = s
        return self
    }
    /// 设置减速率
    @discardableResult
    func decelerationRate(rate r: UIScrollView.DecelerationRate) -> Self {
        base.decelerationRate = r
        return self
    }
    /// 设置索引显示模式
    @discardableResult
    func indexDisplayMode(displayMode m: UIScrollView.IndexDisplayMode) -> Self {
        base.indexDisplayMode = m
        return self
    }
    /// 设置内容偏移（带动画）
    @discardableResult
    func setContentOffset(contentOffset p:CGPoint, _ animated:Bool = true) -> Self {
        base.setContentOffset(p, animated: animated)
        return self
    }
    /// 滚动到指定区域可见
    @discardableResult
    func scrollRectToVisible(rectToVisible r:CGRect, _ animated:Bool = true) -> Self {
        base.scrollRectToVisible(r, animated: animated)
        return self
    }
    /// 闪烁滚动指示器
    @discardableResult
    func flashScrollIndicators() -> Self {
        base.flashScrollIndicators()
        return self
    }
    /// 设置是否延迟内容触摸
    @discardableResult
    func delaysContentTouches(contentTouches b:Bool) -> Self {
        base.delaysContentTouches = b
        return self
    }
    /// 设置是否可以取消内容触摸
    @discardableResult
    func canCancelContentTouches(contentTouches b:Bool) -> Self {
        base.canCancelContentTouches = b
        return self
    }
    /// 设置是否弹性缩放
    @discardableResult
    func bouncesZoom(zoom b:Bool) -> Self {
        base.bouncesZoom = b
        return self
    }
    /// 设置是否滚动到顶部
    @discardableResult
    func scrollsToTop(_ b:Bool = true) -> Self {
        base.scrollsToTop = b
        return self
    }
    /// 设置最小缩放比例
    @discardableResult
    func minimumZoomScale(imumZoomScale a:CGFloat) -> Self {
        base.minimumZoomScale = max(0, a)
        return self
    }
    /// 设置最大缩放比例
    @discardableResult
    func maximumZoomScale(scale a:CGFloat) -> Self {
        base.maximumZoomScale = max(0, a)
        return self
    }
    /// 设置缩放比例
    @discardableResult
    func setZoomScale(zoomScale a:CGFloat, _ animated:Bool = true) -> Self {
        let scale = max(base.minimumZoomScale, min(base.maximumZoomScale, a))
        base.setZoomScale(scale, animated: animated)
        return self
    }
    /// 缩放到指定区域
    @discardableResult
    func zoom(toRect a:CGRect, _ animated:Bool = true) -> Self {
        base.zoom(to: a, animated: animated)
        return self
    }
    /// 设置键盘消失模式
    @discardableResult
    func keyboardDismissMode(dismissMode a:UIScrollView.KeyboardDismissMode) -> Self {
        base.keyboardDismissMode = a
        return self
    }
    /// 设置刷新控件（iOS 10.0+）
    @available(iOS 10.0, *)
    @discardableResult
    func refreshControl(control a:UIRefreshControl?) -> Self {
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
    
    /// 设置滚动指示器样式
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        base.indicatorStyle = style
        return self
    }
    
    /// 设置键盘消失模式
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        base.keyboardDismissMode = mode
        return self
    }
    
    /// 设置刷新控件
    @discardableResult
    func refreshControl(_ control: UIRefreshControl?) -> Self {
        base.refreshControl = control
        return self
    }
    
    /// 设置自动调整内容偏移（iOS 11.0+）
    @available(iOS 11.0, *)
    @discardableResult
    func automaticallyAdjustsScrollIndicatorInsets(_ adjusts: Bool) -> Self {
        base.automaticallyAdjustsScrollIndicatorInsets = adjusts
        return self
    }
    
    /// 设置内容偏移（带动画）
    @discardableResult
    func contentOffset(_ offset: CGPoint, animated: Bool) -> Self {
        base.setContentOffset(offset, animated: animated)
        return self
    }

    /// 设置是否启用缩放
    @discardableResult
    func bouncesZoom(_ bounces: Bool) -> Self {
        base.bouncesZoom = bounces
        return self
    }
    
    /// 设置是否显示滚动指示器
    @discardableResult
    func showsScrollIndicator(_ shows: Bool) -> Self {
        base.showsVerticalScrollIndicator = shows
        base.showsHorizontalScrollIndicator = shows
        return self
    }
    
    /// 设置是否延迟内容触摸
    @discardableResult
    func delaysContentTouches(_ delays: Bool) -> Self {
        base.delaysContentTouches = delays
        return self
    }
    
    /// 设置是否取消内容触摸
    @discardableResult
    func canCancelContentTouches(_ canCancel: Bool) -> Self {
        base.canCancelContentTouches = canCancel
        return self
    }
    
    /// 设置最小缩放比例
    @discardableResult
    func minimumZoomScale(_ scale: CGFloat) -> Self {
        base.minimumZoomScale = max(0, scale)
        return self
    }
    
    /// 设置最大缩放比例
    @discardableResult
    func maximumZoomScale(_ scale: CGFloat) -> Self {
        base.maximumZoomScale = max(0, scale)
        return self
    }
    
    /// 设置缩放比例
    @discardableResult
    func zoomScale(_ scale: CGFloat, animated: Bool = true) -> Self {
        let finalScale = max(base.minimumZoomScale, min(base.maximumZoomScale, scale))
        base.setZoomScale(finalScale, animated: animated)
        return self
    }
    
    /// 缩放到指定区域
    @discardableResult
    func zoom(to rect: CGRect, animated: Bool = true) -> Self {
        base.zoom(to: rect, animated: animated)
        return self
    }
}

public extension UIScrollView {
    /// 滚动到顶部
    func scrollToTop(isAnimated: Bool) {
        var off = self.contentOffset
        off.y = 0 - self.contentInset.top
        self.setContentOffset(off, animated: isAnimated)
    }
    
    /// 滚动到左侧
    func scrollToLeft(isAnimated: Bool) {
        var off = self.contentOffset
        off.x = 0 - self.contentInset.left
        self.setContentOffset(off, animated: isAnimated)
    }
    
    /// 滚动到底部
    func scrollToBottom(isAnimated: Bool) {
        var off = self.contentOffset
        off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
        self.setContentOffset(off, animated: isAnimated)
    }
    
    /// 滚动到右侧
    func scrollToRight(isAnimated: Bool) {
        var off = self.contentOffset
        off.x = self.contentSize.width - self.bounds.width + self.contentInset.right
        self.setContentOffset(off, animated: isAnimated)
    }
    
    /// 滚动到顶部（带动画）
    func scrollToTop() {
        scrollToTop(isAnimated: true)
    }
    
    /// 滚动到左侧（带动画）
    func scrollToLeft() {
        scrollToLeft(isAnimated: true)
    }
    
    /// 滚动到底部（带动画）
    func scrollToBottom() {
        scrollToBottom(isAnimated: true)
    }
    
    /// 滚动到右侧（带动画）
    func scrollToRight() {
        scrollToRight(isAnimated: true)
    }
}
