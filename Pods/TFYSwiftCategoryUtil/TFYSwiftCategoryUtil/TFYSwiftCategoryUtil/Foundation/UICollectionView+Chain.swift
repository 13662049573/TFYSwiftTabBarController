//
//  UICollectionView+TFY.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit

public extension TFY where Base: UICollectionView {
    
    @discardableResult
    func backgroundView(_ backgroundView: UIView?) -> TFY {
        base.backgroundView = backgroundView
        return self
    }
    
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource?) -> TFY {
        base.dataSource = dataSource
        return self
    }
    
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate?) -> TFY {
        base.delegate = delegate
        return self
    }
    
    @discardableResult
    func registerCell(_ cellClass: UICollectionViewCell.Type) -> TFY {
        base.register(cell: cellClass)
        return self
    }
    
    @discardableResult
    func registerNibCell(_ nibCell: UICollectionViewCell.Type) -> TFY {
        base.register(nibCell: nibCell)
        return self
    }
    
    @discardableResult
    func registerHeader(_ viewClass: UICollectionReusableView.Type) -> TFY {
        base.register(header: viewClass)
        return self
    }
    
    @discardableResult
    func registerFooter(_ viewClass: UICollectionReusableView.Type) -> TFY {
        base.register(footer: viewClass)
        return self
    }
    
    @discardableResult
    func registerNibHeader(_ nibHeader: UICollectionReusableView.Type) -> TFY {
        base.register(nibHeader: nibHeader)
        return self
    }
    
    @discardableResult
    func registerNibFooter(_ nibFooter: UICollectionReusableView.Type) -> TFY {
        base.register(nibFooter: nibFooter)
        return self
    }
}

extension UICollectionView {

    public func register<C>(cell clz:C.Type) where C : UICollectionViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func register<C>(nibCell clz:C.Type) where C : UICollectionViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forCellWithReuseIdentifier: identifier)
    }
    
    public func register<C>(header clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    public func register<C>(nibHeader clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    public func register<C>(footer clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
    public func register<C>(nibFooter clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
    
    public func dequeueReusable<C>(cell clz: C.Type, for indexPath: IndexPath) -> C where C : UICollectionViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! C
    }

    public func dequeueReusable<C>(header clz: C.Type, for indexPath: IndexPath) -> C where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! C
    }
    
    public func dequeueReusable<C>(footer clz: C.Type, for indexPath: IndexPath) -> C where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! C
    }
}
