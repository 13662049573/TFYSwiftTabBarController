//
//  UIImageView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit
import ImageIO

public extension TFY where Base: UIImageView {
    
    @discardableResult
    func image(_ image: UIImage?) -> TFY {
        base.image = image
        return self
    }
    
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> TFY {
        base.isHighlighted = isHighlighted
        return self
    }
    
    func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                base.image = image
            }
        }
    }

    @available(iOS 9.0, *)
    func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                base.image = image
            }
        }
    }

}

