//
//  TFYBarButtonItem.swift
//  TFYSwiftNavigationKit
//
//  Created by 田风有 on 2021/5/15.
//

import UIKit

open class TFYBarButtonItem: UIBarButtonItem {

    public var shouldBack: (TFYBarButtonItem) -> Bool = { _ in true }
    
    public var willBack: () -> Void = {}
    
    public var didBack: () -> Void = {}
    
    weak var navigationController: UINavigationController?
    
}

extension TFYBarButtonItem {
    
    public enum ItemStyle {
        case title(String?)
        case image(UIImage?)
        case custom(UIButton)
    }
}

public extension TFYBarButtonItem {
    
    convenience init(style: ItemStyle, tintColor: UIColor? = nil) {
        let action = #selector(backBarButtonItemAction)
        
        switch style {
        case .title(let title):
            self.init(title: title, style: .plain, target: nil, action: action)
            
            self.target = self
            self.tintColor = tintColor
        case .image(let image):
            self.init(image: image, style: .plain, target: nil, action: action)
            
            self.target = self
            self.tintColor = tintColor
        case .custom(let button):
            self.init(customView: button)
            
            button.addTarget(self, action: action, for: .touchUpInside)
            button.tintColor = tintColor
        }
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension TFYBarButtonItem {
    
    @objc private func backBarButtonItemAction() {
        guard shouldBack(self) else { return }
    
        willBack()
        goBack()
        didBack()
    }
}
