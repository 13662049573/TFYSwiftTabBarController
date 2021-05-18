//
//  UITableViewController+ITools.swift
//  TFYSwiftNavigationKit
//
//  Created by 田风有 on 2021/5/15.
//

import UIKit

extension UITableViewController {
    
    private var observation: NSKeyValueObservation {
        if let observation = objc_getAssociatedObject(
            self,
            &TFYAssociatedKeys.observation
            ) as? NSKeyValueObservation {
            return observation
        }
        
        let observation = tableView.observe(
            \.contentOffset,
            options: .new
        ) { [weak self] tableView, change in
            guard let `self` = self else { return }
            
            self.view.bringSubviewToFront(self._navigationBar)
            self._navigationBar.frame.origin.y = tableView.contentOffset.y + self._navigationBar.barMinY
        }
        
        objc_setAssociatedObject(
            self,
            &TFYAssociatedKeys.observation,
            observation,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        return observation
    }
    
    func observeContentOffset() {
        _navigationBar.automaticallyAdjustsPosition = false
        
        _ = observation
    }
}
