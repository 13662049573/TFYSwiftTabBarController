//
//  TFYTabbarController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit

extension Notification.Name {
    fileprivate static let name = Notification.Name(rawValue: "notification")
}

fileprivate class _ItemContainerView: TFYSwiftTabBarItemContainerView {
    override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func select() {
        let newFrame = self.convert(self.frame, to: self.tabBar) // frame转换
        print("\(newFrame)")
        NotificationCenter.default.post(name: .name, object: nil, userInfo: ["frame": newFrame])
    }
    override func reselect() {
        let newFrame = self.convert(self.frame, to: self.tabBar) // frame转换
        print("\(newFrame)")
        NotificationCenter.default.post(name: .name, object: nil, userInfo: ["frame": newFrame])
    }
}

fileprivate class _BackgroundView: UIView {
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        self.layer.addSublayer(self.gradientLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(change(noti:)), name: .name, object: nil)
    }
    
    @objc func change(noti: Notification) {
        guard let frame = noti.userInfo?["frame"] as? CGRect else { return }
        //CATransaction.begin()
        //CATransaction.setDisableActions(true)
        self.gradientLayer.frame = frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        self.gradientLayer.cornerRadius = frame.height / 2.0
        self.gradientLayer.masksToBounds = true
        //CATransaction.commit()
    }
}

class TFYTabbarController: TFYSwiftTabbarController {

    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    var itemArr = [
        ["normalImage":"tabbar_profile","selectedImage":"tabbar_profile_selected","title":"圈圈","vc":ViewController()],
        ["normalImage":"tabbar_quotation","selectedImage":"tabbar_quotation_selected","title":"摊摊","vc":ViewController()],
        ["normalImage":"tabbar_trade","selectedImage":"tabbar_trade_selected","title":"消息","vc":ViewController()]
    ]
    
    var vcArr = [UIViewController]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        for dict in itemArr {
            
            let itemsView = _ItemContainerView()
            itemsView.normalImage = UIImage(named: dict["normalImage"] as! String)
            itemsView.selectedImage = UIImage(named: dict["selectedImage"] as! String)
            itemsView.title = dict["title"] as? String
            
            let item = TFYSwiftTabBarItem(containerView: itemsView)
            let nav = TFYSwiftNaviController(rootViewController: dict["vc"] as! UIViewController)
            nav.tabBarItem = item
            
            vcArr.append(nav)
        }
        
        viewControllers = vcArr
                
        if let myTabBar = self.tabBar as? TFYSwiftTabBar {
            myTabBar.isTranslucent = false
            myTabBar.barTintColor = .white
            myTabBar.backgroundView = _BackgroundView()
        }
    }
}

