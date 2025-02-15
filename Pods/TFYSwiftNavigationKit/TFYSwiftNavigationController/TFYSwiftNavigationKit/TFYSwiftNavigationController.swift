//
//  TFYSwiftNavigationController.swift
//  TFYSwiftNavigationController
//
//  Created by 田风有 on 2022/5/4.
//

import UIKit

public class TFYSwiftNavigationController: UINavigationController {

    // MARK: -  属性
    private lazy var fakeBar: TFYSwiftFakeNavigationBar = {
        let fakeBar = TFYSwiftFakeNavigationBar()
        return fakeBar
    }()
    
    private lazy var fromFakeBar: TFYSwiftFakeNavigationBar = {
        let fakeBar = TFYSwiftFakeNavigationBar()
        return fakeBar
    }()
    
    private lazy var toFakeBar: TFYSwiftFakeNavigationBar = {
        let fakeBar = TFYSwiftFakeNavigationBar()
        return fakeBar
    }()
    
    private var fakeSuperView: UIView? {
        get {
            return navigationBar.subviews.first
        }
    }
    
    private weak var poppingVC: UIViewController?
    private var fakeFrameObserver: NSKeyValueObservation?

    // MARK: -  override

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleinteractivePopGesture(gesture:)))
        setupNavigationBar()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let coordinator = transitionCoordinator {
            guard let fromVC = coordinator.viewController(forKey: .from) else { return }
            if fromVC == poppingVC {
                tfy_updateNavigationBar(for: fromVC)
            }
        } else {
            guard let topViewController = topViewController else { return }
            tfy_updateNavigationBar(for: topViewController)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutFakeSubviews()
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        poppingVC = topViewController
        let viewController = super.popViewController(animated: animated)
        if let topViewController = topViewController {
            tfy_updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return viewController
    }

    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        poppingVC = topViewController
        let vcArray = super.popToRootViewController(animated: animated)
        if let topViewController = topViewController {
            tfy_updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return vcArray
    }

    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        poppingVC = topViewController
        let vcArray = super.popToViewController(viewController, animated: animated)
        if let topViewController = topViewController {
            tfy_updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return vcArray
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        poppingVC = topViewController
        if viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        let vcArr: Void = super.pushViewController(viewController, animated: animated)
        if let topViewController = topViewController {
            tfy_updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return vcArr
    }
    
}

// MARK: -  Private Methods
extension TFYSwiftNavigationController {
    
    private func setupNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        setupFakeSubviews()
    }
    
    private func setupFakeSubviews() {
        guard let fakeSuperView = fakeSuperView else { return }
        if fakeBar.superview == nil {
            fakeFrameObserver = fakeSuperView.observe(\.frame, changeHandler: { [weak self] (obj, changed) in
                guard let `self` = self else { return }
                self.layoutFakeSubviews()
            })
            fakeSuperView.insertSubview(fakeBar, at: 0)
        }
    }
    
    private func layoutFakeSubviews() {
        guard let fakeSuperView = fakeSuperView else { return }
        fakeBar.frame = fakeSuperView.bounds
        fakeBar.setNeedsLayout()
    }
    
    @objc private func handleinteractivePopGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        guard let coordinator = transitionCoordinator,
            let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to) else {
                return
        }
        if gesture.state == .changed {
            navigationBar.tintColor = average(fromColor: fromVC.tfy_tintColor, toColor: toVC.tfy_tintColor, percent: coordinator.percentComplete)
        }
    }
    
    private func average(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        let red = fromRed + (toRed - fromRed) * percent
        let green = fromGreen + (toGreen - fromGreen) * percent
        let blue = fromBlue + (toBlue - fromBlue) * percent
        let alpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func showViewController(_ viewController: UIViewController, coordinator: UIViewControllerTransitionCoordinator) {
        guard let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to) else {
                return
        }
        resetButtonLabels(in: navigationBar)
        coordinator.animate(alongsideTransition: { (context) in
            self.tfy_updateNavigationBarTint(for: viewController, ignoreTintColor: context.isInteractive)
            if viewController == toVC {
                self.showTempFakeBar(fromVC: fromVC, toVC: toVC)
            } else {
                self.tfy_updateNavigationBarBackground(for: viewController)
                self.tfy_updateNavigationBarShadow(for: viewController)
            }
        }) { (context) in
            if context.isCancelled {
                self.tfy_updateNavigationBar(for: fromVC)
            } else {
                self.tfy_updateNavigationBar(for: viewController)
            }
            if viewController == toVC {
                self.clearTempFakeBar()
            }
        }
    }
    
    private func showTempFakeBar(fromVC: UIViewController, toVC: UIViewController) {
        UIView.setAnimationsEnabled(false)
        fakeBar.alpha = 0
        // from
        fromVC.view.addSubview(fromFakeBar)
        fromFakeBar.frame = fakerBarFrame(for: fromVC)
        fromFakeBar.setNeedsLayout()
        fromFakeBar.tfy_updateFakeBarBackground(for: fromVC)
        fromFakeBar.tfy_updateFakeBarShadow(for: fromVC)
        // to
        toVC.view.addSubview(toFakeBar)
        toFakeBar.frame = fakerBarFrame(for: toVC)
        toFakeBar.setNeedsLayout()
        toFakeBar.tfy_updateFakeBarBackground(for: toVC)
        toFakeBar.tfy_updateFakeBarShadow(for: toVC)
        UIView.setAnimationsEnabled(true)
    }
    
    private func clearTempFakeBar() {
        fakeBar.alpha = 1
        fromFakeBar.removeFromSuperview()
        toFakeBar.removeFromSuperview()
    }
    
    private func fakerBarFrame(for viewController: UIViewController) -> CGRect {
        guard let fakeSuperView = fakeSuperView else {
            return navigationBar.frame
        }
        var frame = navigationBar.convert(fakeSuperView.frame, to: viewController.view)
        frame.origin.x = viewController.view.frame.origin.x
        return frame
    }
    
    private func resetButtonLabels(in view: UIView) {
        let viewClassName = view.classForCoder.description().replacingOccurrences(of: "_", with: "")
        if viewClassName == "UIButtonLabel" {
            view.alpha = 1
        } else {
            if view.subviews.count > 0 {
                for subview in view.subviews {
                    resetButtonLabels(in: subview)
                }
            }
        }
    }

}

// MARK: -  UINavigationControllerDelegate
extension TFYSwiftNavigationController: UINavigationControllerDelegate {
 
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = transitionCoordinator {
            showViewController(viewController, coordinator: coordinator)
        } else {
            if !animated && viewControllers.count > 1 {
                let lastButOneVC = viewControllers[viewControllers.count - 2]
                showTempFakeBar(fromVC: lastButOneVC, toVC: viewController)
                return
            }
            tfy_updateNavigationBar(for: viewController)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if !animated {
            tfy_updateNavigationBar(for: viewController)
            clearTempFakeBar()
        }
        poppingVC = nil
    }
    
}

// MARK: -  UIGestureRecognizerDelegate
extension TFYSwiftNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        if let topViewController = topViewController {
            return topViewController.tfy_enablePopGesture
        }
        return true
    }
    
}

// MARK: -  Public
extension TFYSwiftNavigationController {
    
    func tfy_updateNavigationBar(for viewController: UIViewController) {
        setupFakeSubviews()
        tfy_updateNavigationBarTint(for: viewController)
        tfy_updateNavigationBarBackground(for: viewController)
        tfy_updateNavigationBarShadow(for: viewController)
    }
    
    func tfy_updateNavigationBarTint(for viewController: UIViewController, ignoreTintColor: Bool = false) {
        if viewController != topViewController {
            return
        }
        UIView.setAnimationsEnabled(false)
        navigationBar.barStyle = viewController.tfy_barStyle
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: viewController.tfy_titleColor,
            NSAttributedString.Key.font: viewController.tfy_titleFont
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        if !ignoreTintColor {
            navigationBar.tintColor = viewController.tfy_tintColor
        }
        if #available(iOS 14.0, *) {
            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", image: UIImage(), primaryAction: nil, menu: nil)
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func tfy_updateNavigationBarBackground(for viewController: UIViewController) {
        if viewController != topViewController {
            return
        }
        fakeBar.tfy_updateFakeBarBackground(for: viewController)
    }
    
    func tfy_updateNavigationBarShadow(for viewController: UIViewController) {
        if viewController != topViewController {
            return
        }
        fakeBar.tfy_updateFakeBarShadow(for: viewController)
    }

}
