//
//  UIImageView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit
import ImageIO

public extension TFY where Base: UIImageView {
    
    /// 设置图片
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }
    
    /// 设置高亮状态
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> Self {
        base.isHighlighted = isHighlighted
        return self
    }
    
    /// 加载本地GIF图片（按名称）
    func loadGif(name: String) {
        guard !name.isEmpty else { return }
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }

    /// 加载本地GIF图片（按asset，iOS9+）
    @available(iOS 9.0, *)
    func loadGif(asset: String) {
        guard !asset.isEmpty else { return }
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }

}

