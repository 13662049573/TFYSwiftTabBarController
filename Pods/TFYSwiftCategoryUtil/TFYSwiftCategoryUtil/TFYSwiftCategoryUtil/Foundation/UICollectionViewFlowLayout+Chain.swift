//
//  UICollectionViewFlowLayout+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import UIKit

public extension TFY where Base: UICollectionViewFlowLayout {
    /// 设置最小行间距（>=0）
    @discardableResult
    func minimumLineSpacing(_ minimumLineSpacing: CGFloat) -> Self {
        base.minimumLineSpacing = max(0, minimumLineSpacing)
        return self
    }
    /// 设置最小项目间距（>=0）
    @discardableResult
    func minimumInteritemSpacing(_ minimumInteritemSpacing: CGFloat) -> Self {
        base.minimumInteritemSpacing = max(0, minimumInteritemSpacing)
        return self
    }
    /// 设置项目大小
    @discardableResult
    func itemSize(_ itemSize: CGSize) -> Self {
        base.itemSize = CGSize(width: max(0, itemSize.width), height: max(0, itemSize.height))
        return self
    }
    /// 设置项目大小（分开设置）
    @discardableResult
    func itemSize(width: CGFloat, height: CGFloat) -> Self {
        base.itemSize = CGSize(width: max(0, width), height: max(0, height))
        return self
    }
    /// 设置预估项目大小
    @discardableResult
    func estimatedItemSize(_ estimatedItemSize: CGSize) -> Self {
        base.estimatedItemSize = CGSize(width: max(0, estimatedItemSize.width), height: max(0, estimatedItemSize.height))
        return self
    }
    /// 设置预估项目大小（分开设置）
    @discardableResult
    func estimatedItemSize(width: CGFloat, height: CGFloat) -> Self {
        base.estimatedItemSize = CGSize(width: max(0, width), height: max(0, height))
        return self
    }
    /// 设置滚动方向
    @discardableResult
    func scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        base.scrollDirection = scrollDirection
        return self
    }
    /// 设置Header参考大小
    @discardableResult
    func headerReferenceSize(_ headerReferenceSize: CGSize) -> Self {
        base.headerReferenceSize = CGSize(width: max(0, headerReferenceSize.width), height: max(0, headerReferenceSize.height))
        return self
    }
    /// 设置Header参考大小（分开设置）
    @discardableResult
    func headerReferenceSize(width: CGFloat, height: CGFloat) -> Self {
        base.headerReferenceSize = CGSize(width: max(0, width), height: max(0, height))
        return self
    }
    /// 设置Footer参考大小
    @discardableResult
    func footerReferenceSize(_ footerReferenceSize: CGSize) -> Self {
        base.footerReferenceSize = CGSize(width: max(0, footerReferenceSize.width), height: max(0, footerReferenceSize.height))
        return self
    }
    /// 设置Footer参考大小（分开设置）
    @discardableResult
    func footerReferenceSize(width: CGFloat, height: CGFloat) -> Self {
        base.footerReferenceSize = CGSize(width: max(0, width), height: max(0, height))
        return self
    }
    /// 设置Section内边距
    @discardableResult
    func sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        base.sectionInset = sectionInset
        return self
    }
    /// 设置Section内边距（分开设置）
    @discardableResult
    func sectionInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        base.sectionInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
}
