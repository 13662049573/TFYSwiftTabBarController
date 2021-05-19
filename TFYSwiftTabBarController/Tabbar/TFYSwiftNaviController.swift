//
//  TFYSwiftNaviController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/18.
//

import UIKit

class TFYSwiftNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.configuration.isEnabled = true
        navigation.configuration.barTintColor = UIColor.white
        navigation.configuration.tintColor = UIColor.black
//        navigation.configuration.isShadowHidden = true
        
        if #available(iOS 11.0, *) {
            navigation.configuration.prefersLargeTitles = true
            navigation.configuration.largeTitle.displayMode = .never
        }
        
        // Do any additional setup after loading the view.
    }
}
