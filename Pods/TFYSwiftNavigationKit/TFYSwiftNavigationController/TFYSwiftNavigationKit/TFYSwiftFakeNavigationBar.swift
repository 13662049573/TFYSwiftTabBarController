//
//  TFYSwiftFakeNavigationBar.swift
//  TFYSwiftNavigationController
//
//  Created by 田风有 on 2022/5/4.
//

import UIKit

class TFYSwiftFakeNavigationBar: UIView {

    // MARK: -  lazy load
    
    private lazy var fakeBackgroundImageView: UIImageView = {
        let fakeBackgroundImageView = UIImageView()
        fakeBackgroundImageView.isUserInteractionEnabled = false
        fakeBackgroundImageView.contentScaleFactor = 1
        fakeBackgroundImageView.contentMode = .scaleToFill
        fakeBackgroundImageView.backgroundColor = .clear
        return fakeBackgroundImageView
    }()
    
    private lazy var fakeBackgroundEffectView: UIVisualEffectView = {
        let fakeBackgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        fakeBackgroundEffectView.isUserInteractionEnabled = false
        return fakeBackgroundEffectView
    }()
    
    private lazy var fakeShadowImageView: UIImageView = {
        let fakeShadowImageView = UIImageView()
        fakeShadowImageView.isUserInteractionEnabled = false
        fakeShadowImageView.contentScaleFactor = 1
        return fakeShadowImageView
    }()
    
    // MARK: -  init
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubview(fakeBackgroundEffectView)
        addSubview(fakeBackgroundImageView)
        addSubview(fakeShadowImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fakeBackgroundEffectView.frame = bounds
        fakeBackgroundImageView.frame = bounds
        fakeShadowImageView.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
    }
    
    // MARK: -  public
    
    func tfy_updateFakeBarBackground(for viewController: UIViewController) {
        fakeBackgroundEffectView.subviews.last?.backgroundColor = viewController.tfy_backgroundColor
        fakeBackgroundImageView.image = viewController.tfy_backgroundImage
        if viewController.tfy_backgroundImage != nil {
            // 直接使用fakeBackgroundEffectView.alpha控制台会有提示
            // 这样使用避免警告
            fakeBackgroundEffectView.subviews.forEach { (subview) in
                subview.alpha = 0
            }
        } else {
            fakeBackgroundEffectView.subviews.forEach { (subview) in
                subview.alpha = viewController.tfy_barAlpha
            }
        }
        fakeBackgroundImageView.alpha = viewController.tfy_barAlpha
        fakeShadowImageView.alpha = viewController.tfy_barAlpha
    }
    
    func tfy_updateFakeBarShadow(for viewController: UIViewController) {
        fakeShadowImageView.isHidden = viewController.tfy_shadowHidden
        fakeShadowImageView.backgroundColor = viewController.tfy_shadowColor
    }

}
