//
//  UICollectionViewFlowLayout+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UICollectionViewFlowLayout {
    
    @discardableResult
    func minimumLineSpacing(_ minimumLineSpacing: CGFloat) -> TFY {
        base.minimumLineSpacing = minimumLineSpacing
        return self
    }
    
    @discardableResult
    func minimumInteritemSpacing(_ minimumInteritemSpacing: CGFloat) -> TFY {
        base.minimumInteritemSpacing = minimumInteritemSpacing
        return self
    }
    
    @discardableResult
    func itemSize(_ itemSize: CGSize) -> TFY {
        base.itemSize = itemSize
        return self
    }
    
    @discardableResult
    func itemSize(width: CGFloat, height: CGFloat) -> TFY {
        base.itemSize = CGSize(width: width, height: height)
        return self
    }
    
    @discardableResult
    func estimatedItemSize(_ estimatedItemSize: CGSize) -> TFY {
        base.estimatedItemSize = estimatedItemSize
        return self
    }
    
    @discardableResult
    func estimatedItemSize(width: CGFloat, height: CGFloat) -> TFY {
        base.estimatedItemSize = CGSize(width: width, height: height)
        return self
    }
    
    @discardableResult
    func scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> TFY {
        base.scrollDirection = scrollDirection
        return self
    }
    
    @discardableResult
    func headerReferenceSize(_ headerReferenceSize: CGSize) -> TFY {
        base.headerReferenceSize = headerReferenceSize
        return self
    }
    
    @discardableResult
    func headerReferenceSize(width: CGFloat, height: CGFloat) -> TFY {
        base.headerReferenceSize = CGSize(width: width, height: height)
        return self
    }
    
    @discardableResult
    func footerReferenceSize(_ footerReferenceSize: CGSize) -> TFY {
        base.footerReferenceSize = footerReferenceSize
        return self
    }
    
    @discardableResult
    func footerReferenceSize(width: CGFloat, height: CGFloat) -> TFY {
        base.footerReferenceSize = CGSize(width: width, height: height)
        return self
    }
    
    @discardableResult
    func sectionInset(_ sectionInset: UIEdgeInsets) -> TFY {
        base.sectionInset = sectionInset
        return self
    }
    
    @discardableResult
    func sectionInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> TFY {
        base.sectionInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
}
