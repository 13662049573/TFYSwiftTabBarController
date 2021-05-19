//
//  BackgroundViewController.swift
//  TabBar
//
//  Created by galaxy on 2020/11/3.
//

import UIKit

public class BackgroundViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissAction))
        navigation.item.title = "Tabbar渐变背景"
    }
    
    @objc private func dismissAction() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
}
