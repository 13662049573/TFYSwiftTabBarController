//
//  MixViewController.swift
//  TabBar
//
//  Created by galaxy on 2020/10/29.
//

import UIKit

public class MixViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissAction))
        navigation.item.title = "混合使用"
    }
    
    @objc private func dismissAction() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
}
