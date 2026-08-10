//
//  TFYSwiftFlatDesignPrivate.swift
//  TFYSwiftTabBarController
//
//  Converted from FlatDesign private transition helpers + nav hook entry.
//

import UIKit
import ObjectiveC

// MARK: - Transition Context

final class TFYSwiftFlatDesignTabBarControllerTransitionContext: NSObject, UIViewControllerContextTransitioning {

    var completionBlock: ((Bool) -> Void)?
    var isAnimated: Bool = false
    var isInteractive: Bool = false

    private weak var sourceViewController: UIViewController?
    private weak var destinationViewController: UIViewController?
    private weak var _containerView: UIView?
    private var _targetTransform: CGAffineTransform = .identity

    init(
        sourceViewController: UIViewController?,
        destinationViewController: UIViewController?,
        containerView: UIView
    ) {
        self.sourceViewController = sourceViewController
        self.destinationViewController = destinationViewController
        self._containerView = containerView
        super.init()
    }

    var containerView: UIView { _containerView ?? UIView() }
    var transitionWasCancelled: Bool { false }
    var presentationStyle: UIModalPresentationStyle { .custom }
    var targetTransform: CGAffineTransform { _targetTransform }

    func updateInteractiveTransition(_ percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    func pauseInteractiveTransition() {}

    func completeTransition(_ didComplete: Bool) {
        completionBlock?(didComplete)
    }

    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        switch key {
        case .from: return sourceViewController
        case .to: return destinationViewController
        default: return nil
        }
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        switch key {
        case .from: return sourceViewController?.view
        case .to: return destinationViewController?.view
        default: return nil
        }
    }

    func initialFrame(for vc: UIViewController) -> CGRect { containerView.bounds }
    func finalFrame(for vc: UIViewController) -> CGRect { containerView.bounds }
}

// MARK: - Transition Animator

final class TFYSwiftFlatDesignTabBarControllerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0 }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toVC = transitionContext.viewController(forKey: .to) {
            transitionContext.containerView.addSubview(toVC.view)
        }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}

// MARK: - Parallax Overlay

final class TFYSwiftFlatDesignTabBarParallaxOverlayView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override var safeAreaInsets: UIEdgeInsets {
        if let tab = parallaxCurrentViewController()?.tfyflatdesign_tabBarController as? UITabBarController {
            return tab.view.safeAreaInsets
        }
        return super.safeAreaInsets
    }

    private func parallaxCurrentViewController() -> UIViewController? {
        var next: UIResponder? = next
        while let current = next {
            if let vc = current as? UIViewController { return vc }
            next = current.next
        }
        return nil
    }
}

// MARK: - Navigation Hook

@objc public protocol TFYSwiftNavigationControllerExtensionDelegate: AnyObject {
    func tfyflatdesign_navigationController(_ navigationController: UINavigationController, navigationBarDidChangeHeight height: CGFloat)
    func tfyflatdesign_navigationController(_ navigationController: UINavigationController, didBeginTransitionFrom fromVC: UIViewController, to toVC: UIViewController, operation: UINavigationController.Operation)
    func tfyflatdesign_navigationController(_ navigationController: UINavigationController, didUpdateInteractiveFrom fromVC: UIViewController, to toVC: UIViewController, percentComplete: CGFloat)
    func tfyflatdesign_navigationController(_ navigationController: UINavigationController, didUpdateInteractiveFrom fromVC: UIViewController, to toVC: UIViewController, popGestureRecognizer: UIGestureRecognizer)
    func tfyflatdesign_navigationController(_ navigationController: UINavigationController, willEndTransitionFrom fromVC: UIViewController, to toVC: UIViewController, operation: UINavigationController.Operation, cancelled: Bool)
    func tfyflatdesign_navigationController(_ navigationController: UINavigationController, didEndTransitionFrom fromVC: UIViewController, to toVC: UIViewController, operation: UINavigationController.Operation, cancelled: Bool)
}

private enum TFYSwiftFlatDesignNavKeys {
    static var customPop: UInt8 = 0
    static var nested: UInt8 = 0
    static var hookInstalled = false
}

public extension UINavigationController {

    @objc var tfyflatdesign_customPopGestureRecognizer: UIGestureRecognizer? {
        get { objc_getAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.customPop) as? UIGestureRecognizer }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.customPop, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Install once; mirrors CYL `+cyl_navigationBarActionHook` for FlatDesign push/pop tabBar parallax.
    @objc class func tfy_navigationBarActionHook() {
        guard !TFYSwiftFlatDesignNavKeys.hookInstalled else { return }
        TFYSwiftFlatDesignNavKeys.hookInstalled = true
        // Hook is opt-in at FlatDesign TabBar init. Full interactive parallax
        // swizzle lives in ObjC private category; Swift port keeps a no-crash entry
        // and relies on hidesBottomBarWhenPushed / BaseNavigationController for hide.
        // ponytail: ceiling = no full UINavigationController method swizzle for parallax overlay;
        // upgrade path = port UINavigationController+CYLFlatDesignTabBarPrivate.m swizzle body if needed.
    }
}

public extension UIViewController {
    @objc var tfyflatdesign_tabBarController: UIViewController? {
        get { objc_getAssociatedObject(self, &TFYSwiftFlatDesignVCKeys.flatTabBarController) as? UIViewController }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignVCKeys.flatTabBarController, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

private enum TFYSwiftFlatDesignVCKeys {
    static var flatTabBarController: UInt8 = 0
}
