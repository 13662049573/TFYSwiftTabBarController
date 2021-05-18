//
//  TFYNavigationItem.swift
//  TFYSwiftNavigationKit
//
//  Created by 田风有 on 2021/5/15.
//

import UIKit

class TFYNavigationItem: UINavigationItem {

    private weak var viewController: UIViewController?
    
    convenience init(viewController: UIViewController?) {
        self.init()
        
        self.viewController = viewController
    }
    
    override var title: String? {
        didSet { viewController?.navigationItem.title = title }
    }
    
    @available(iOS 11.0, *)
    override var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
        get { super.largeTitleDisplayMode }
        set {
            super.largeTitleDisplayMode = newValue
            
            viewController?.navigationItem.largeTitleDisplayMode = newValue
        }
    }
}
