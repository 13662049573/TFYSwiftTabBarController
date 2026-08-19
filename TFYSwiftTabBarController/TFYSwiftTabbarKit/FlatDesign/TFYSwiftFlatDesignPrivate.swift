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
    static var extensionDelegate: UInt8 = 0
    static var gestureRegistered: UInt8 = 0
    static var hookInstalled = false
}

private func tfyflatdesign_swizzle(_ cls: AnyClass, _ original: Selector, _ swizzled: Selector) {
    guard let originalMethod = class_getInstanceMethod(cls, original),
          let swizzledMethod = class_getInstanceMethod(cls, swizzled) else { return }
    let added = class_addMethod(cls, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    if added {
        class_replaceMethod(cls, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

public extension UINavigationController {

    @objc var tfyflatdesign_customPopGestureRecognizer: UIGestureRecognizer? {
        get { objc_getAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.customPop) as? UIGestureRecognizer }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.customPop, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfyflatdesign_nestedInCYLFlatDesignUITabBarController: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.nested) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.nested, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc var tfyflatdesign_extensionDelegate: TFYSwiftNavigationControllerExtensionDelegate? {
        get { objc_getAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.extensionDelegate) as? TFYSwiftNavigationControllerExtensionDelegate }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.extensionDelegate, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    private var tfyflatdesign_interactivePopGestureRecognizerRegistered: Bool {
        get { (objc_getAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.gestureRegistered) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &TFYSwiftFlatDesignNavKeys.gestureRegistered, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Mirrors CYL `+cyl_navigationBarActionHook` (push/pop parallax overlay).
    @objc class func tfy_navigationBarActionHook() {
        guard !TFYSwiftFlatDesignNavKeys.hookInstalled else { return }
        TFYSwiftFlatDesignNavKeys.hookInstalled = true
        let cls = UINavigationController.self
        tfyflatdesign_swizzle(cls, #selector(UINavigationController.popViewController(animated:)), #selector(UINavigationController.tfyflatdesign_popViewControllerAnimated(_:)))
        tfyflatdesign_swizzle(cls, #selector(UINavigationController.popToViewController(_:animated:)), #selector(UINavigationController.tfyflatdesign_popToViewController(_:animated:)))
        tfyflatdesign_swizzle(cls, #selector(UINavigationController.popToRootViewController(animated:)), #selector(UINavigationController.tfyflatdesign_popToRootViewControllerAnimated(_:)))
        tfyflatdesign_swizzle(cls, #selector(UINavigationController.pushViewController(_:animated:)), #selector(UINavigationController.tfyflatdesign_pushViewController(_:animated:)))
        tfyflatdesign_swizzle(cls, #selector(UINavigationController.setViewControllers(_:animated:)), #selector(UINavigationController.tfyflatdesign_setViewControllers(_:animated:)))
        tfyflatdesign_swizzle(cls, #selector(UINavigationController.didMove(toParent:)), #selector(UINavigationController.tfyflatdesign_didMoveToParentViewController(_:)))
        tfyflatdesign_swizzle(cls, #selector(UINavigationController.viewDidLayoutSubviews), #selector(UINavigationController.tfyflatdesign_viewDidLayoutSubviews))
    }

    @objc(tfyflatdesign_popViewControllerAnimated:)
    func tfyflatdesign_popViewControllerAnimated(_ animated: Bool) -> UIViewController? {
        let previous = tfyflatdesign_popViewControllerAnimated(animated)
        guard tfyflatdesign_nestedInCYLFlatDesignUITabBarController else { return previous }
        tfyflatdesign_notifyPop(from: previous, to: topViewController, animated: animated)
        return previous
    }

    @objc(tfyflatdesign_popToViewController:animated:)
    func tfyflatdesign_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let previous = topViewController
        let result = tfyflatdesign_popToViewController(viewController, animated: animated)
        guard tfyflatdesign_nestedInCYLFlatDesignUITabBarController else { return result }
        tfyflatdesign_notifyPop(from: previous, to: viewController, animated: animated)
        return result
    }

    @objc(tfyflatdesign_popToRootViewControllerAnimated:)
    func tfyflatdesign_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        let previous = topViewController
        let result = tfyflatdesign_popToRootViewControllerAnimated(animated)
        guard tfyflatdesign_nestedInCYLFlatDesignUITabBarController else { return result }
        guard let result, !result.isEmpty else { return result }
        tfyflatdesign_notifyPop(from: previous, to: topViewController, animated: animated)
        return result
    }

    @objc(tfyflatdesign_pushViewController:animated:)
    func tfyflatdesign_pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard tfyflatdesign_nestedInCYLFlatDesignUITabBarController else {
            tfyflatdesign_pushViewController(viewController, animated: animated)
            return
        }
        let previous = topViewController
        tfyflatdesign_pushViewController(viewController, animated: animated)
        tfyflatdesign_notifyPush(from: previous, to: viewController, animated: animated)
    }

    @objc(tfyflatdesign_setViewControllers:animated:)
    func tfyflatdesign_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        guard tfyflatdesign_nestedInCYLFlatDesignUITabBarController else {
            tfyflatdesign_setViewControllers(viewControllers, animated: animated)
            return
        }
        let previous = topViewController
        let toVC = viewControllers.last
        let isPush = toVC.map { !self.viewControllers.contains($0) } ?? false
        tfyflatdesign_setViewControllers(viewControllers, animated: animated)
        if isPush {
            tfyflatdesign_notifyPush(from: previous, to: toVC, animated: animated)
        } else {
            tfyflatdesign_notifyPop(from: previous, to: toVC, animated: animated)
        }
    }

    @objc(tfyflatdesign_didMoveToParentViewController:)
    func tfyflatdesign_didMoveToParentViewController(_ parent: UIViewController?) {
        tfyflatdesign_didMoveToParentViewController(parent)
        if parent == nil, tfyflatdesign_nestedInCYLFlatDesignUITabBarController {
            tfyflatdesign_extensionDelegate = nil
            tfyflatdesign_nestedInCYLFlatDesignUITabBarController = false
            tfyflatdesign_unregisterPopGestureRecognizer()
        } else if parent?.tfy_isFlatDesignStyleTabBar() == true {
            tfyflatdesign_extensionDelegate = parent as? TFYSwiftNavigationControllerExtensionDelegate
            tfyflatdesign_nestedInCYLFlatDesignUITabBarController = true
            tfyflatdesign_registerPopGestureRecognizer()
            tfyflatdesign_updateNavigationBarHeight()
        }
    }

    @objc(tfyflatdesign_viewDidLayoutSubviews)
    func tfyflatdesign_viewDidLayoutSubviews() {
        tfyflatdesign_viewDidLayoutSubviews()
        if tfyflatdesign_nestedInCYLFlatDesignUITabBarController {
            tfyflatdesign_updateNavigationBarHeight()
        }
    }

    private func tfyflatdesign_responsePopGestureRecognizer() -> UIGestureRecognizer? {
        if let custom = tfyflatdesign_customPopGestureRecognizer { return custom }
        if #available(iOS 26.0, *) {
            return (value(forKey: "interactiveContentPopGestureRecognizer") as? UIGestureRecognizer)
                ?? interactivePopGestureRecognizer
        }
        return interactivePopGestureRecognizer
    }

    private func tfyflatdesign_registerPopGestureRecognizer() {
        guard !tfyflatdesign_interactivePopGestureRecognizerRegistered else { return }
        guard let pop = tfyflatdesign_responsePopGestureRecognizer() else { return }
        pop.addTarget(self, action: #selector(tfyflatdesign_popGestureRecognizerHandler(_:)))
        tfyflatdesign_interactivePopGestureRecognizerRegistered = true
    }

    private func tfyflatdesign_unregisterPopGestureRecognizer() {
        guard tfyflatdesign_interactivePopGestureRecognizerRegistered else { return }
        tfyflatdesign_responsePopGestureRecognizer()?.removeTarget(self, action: #selector(tfyflatdesign_popGestureRecognizerHandler(_:)))
        tfyflatdesign_interactivePopGestureRecognizerRegistered = false
    }

    @objc private func tfyflatdesign_popGestureRecognizerHandler(_ popGestureRecognizer: UIPanGestureRecognizer) {
        let fromVC = transitionCoordinator?.viewController(forKey: .from)
        tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
            self,
            didUpdateInteractiveFrom: fromVC ?? UIViewController(),
            to: topViewController ?? UIViewController(),
            popGestureRecognizer: popGestureRecognizer
        )
        guard popGestureRecognizer.state != .ended else { return }
        let translation = popGestureRecognizer.translation(in: view).x
        guard translation != 0 else { return }
        let completed = max(0, min(1, translation / view.bounds.width))
        tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
            self,
            didUpdateInteractiveFrom: fromVC ?? UIViewController(),
            to: topViewController ?? UIViewController(),
            percentComplete: completed
        )
    }

    private func tfyflatdesign_notifyPush(from fromVC: UIViewController?, to toVC: UIViewController?, animated: Bool) {
        guard let fromVC, let toVC else { return }
        tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(self, didBeginTransitionFrom: fromVC, to: toVC, operation: .push)
        tfyflatdesign_runTransition(from: fromVC, to: toVC, operation: .push, animated: animated)
    }

    private func tfyflatdesign_notifyPop(from fromVC: UIViewController?, to toVC: UIViewController?, animated: Bool) {
        var toVC = toVC
        if let fromVC, fromVC === toVC {
            if let index = viewControllers.firstIndex(of: fromVC), index > 0 {
                toVC = viewControllers[index - 1]
            }
        }
        guard let fromVC, let toVC else { return }
        tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(self, didBeginTransitionFrom: fromVC, to: toVC, operation: .pop)
        tfyflatdesign_runTransition(from: fromVC, to: toVC, operation: .pop, animated: animated)
    }

    private func tfyflatdesign_runTransition(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        operation: UINavigationController.Operation,
        animated: Bool
    ) {
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] context in
                guard let self else { return }
                self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                    self, willEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: context.isCancelled
                )
            }, completion: { [weak self] context in
                guard let self else { return }
                self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                    self, didEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: context.isCancelled
                )
            })
            return
        }
        let finish = { [weak self] in
            guard let self else { return }
            self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                self, willEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: false
            )
            self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                self, didEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: false
            )
        }
        if animated {
            if operation == .pop {
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: 7 << 16), animations: {
                    self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                        self, willEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: false
                    )
                }, completion: { _ in
                    self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                        self, didEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: false
                    )
                })
            } else {
                UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions(rawValue: 7 << 16), animations: {
                    self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                        self, willEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: false
                    )
                }, completion: { _ in
                    self.tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(
                        self, didEndTransitionFrom: fromVC, to: toVC, operation: operation, cancelled: false
                    )
                })
            }
        } else {
            finish()
        }
    }

    private func tfyflatdesign_updateNavigationBarHeight() {
        var value: CGFloat = 0
        for subview in navigationBar.subviews where NSStringFromClass(type(of: subview)).contains("ContentView") {
            value = subview.frame.maxY
            break
        }
        tfyflatdesign_extensionDelegate?.tfyflatdesign_navigationController(self, navigationBarDidChangeHeight: value + view.safeAreaInsets.top)
    }
}

public extension UIViewController {
    @objc var tfyflatdesign_tabBarController: UIViewController? {
        get {
            if let stored = objc_getAssociatedObject(self, &TFYSwiftFlatDesignVCKeys.flatTabBarController) as? UIViewController {
                return stored
            }
            if tabBarController?.tfy_isFlatDesignStyleTabBar() == true {
                return tabBarController
            }
            if tfy_getViewControllerInsteadOfNavigationController().tabBarController?.tfy_isFlatDesignStyleTabBar() == true {
                return tfy_getViewControllerInsteadOfNavigationController().tabBarController
            }
            return tfy_nearestParentViewControllerThatIsFlatDesignStyleTabBar()
        }
        set {
            objc_setAssociatedObject(self, &TFYSwiftFlatDesignVCKeys.flatTabBarController, newValue, .OBJC_ASSOCIATION_ASSIGN)
            let resolved = tfy_getViewControllerInsteadOfNavigationController()
            if resolved !== self {
                objc_setAssociatedObject(resolved, &TFYSwiftFlatDesignVCKeys.flatTabBarController, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }

    @objc func tfy_nearestParentViewControllerThatIsFlatDesignStyleTabBar() -> UIViewController? {
        var controller = parent
        while let current = controller, !current.tfy_isFlatDesignStyleTabBar() {
            controller = current.parent
        }
        return controller?.tfy_isFlatDesignStyleTabBar() == true ? controller : nil
    }

    @objc func tfy_nearestParentViewController(thatIsKindOf cls: AnyClass) -> UIViewController? {
        var controller = parent
        while let current = controller, !current.isKind(of: cls) {
            controller = current.parent
        }
        return controller?.isKind(of: cls) == true ? controller : nil
    }
}

private enum TFYSwiftFlatDesignVCKeys {
    static var flatTabBarController: UInt8 = 0
}
