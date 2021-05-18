//
//  TableView+ITools.swift
//  TFYCategoryUtil
//
//  Created by 田风有 on 2021/5/4.
//

import Foundation
import UIKit

/// MARK ---------------------------------------------------------------  UITableView ---------------------------------------------------------------

public extension TFY where Base == UITableView {
    
    /// 代理delegate
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }
    
    /// 数组代理
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        base.dataSource = dataSource
        return self
    }
    
    /// ios 11 必须设置方式
    func adJustedContentIOS11() -> Void {
        base.estimatedSectionFooterHeight = 0
        base.estimatedSectionHeaderHeight = 0
        base.contentInsetAdjustmentBehavior = .never
    }
    
    /// 行高
    @discardableResult
    func rowHeight(_ rowHeight: CGFloat) -> Self {
        base.rowHeight = rowHeight
        return self
    }
    
    /// 头部高度
    @discardableResult
    func sectionHeaderHeight(_ sectionHeaderHeight: CGFloat) -> Self {
        base.sectionHeaderHeight = sectionHeaderHeight
        return self
    }
    
    /// 尾部行高
    @discardableResult
    func sectionFooterHeight(_ sectionFooterHeight: CGFloat) -> Self {
        base.sectionFooterHeight = sectionFooterHeight
        return self
    }
    
    /// 默认高度
    @discardableResult
    func estimatedRowHeight(_ estimatedRowHeight: CGFloat) -> Self {
        base.estimatedRowHeight = estimatedRowHeight
        return self
    }
    
    /// 默认是UITableViewAutomaticDimension，设置为0禁用
    @discardableResult
    func estimatedSectionHeaderHeight(_ sectionHeaderHeight: CGFloat) -> Self {
        base.estimatedSectionHeaderHeight = sectionHeaderHeight
        return self
    }
    
    /// default is UITableViewAutomaticDimension, set to 0 to disable
    @discardableResult
    func estimatedSectionFooterHeight(_ sectionFooterHeight: CGFloat) -> Self {
        base.estimatedSectionFooterHeight = sectionFooterHeight
        return self
    }
    
    /// 线条内边际设置
    @discardableResult
    func separatorInset(_ Inset: UIEdgeInsets) -> Self {
        base.separatorInset = Inset
        return self
    }
    
    /// Vertical 边框线条
    @discardableResult
    func showsVerticalScrollIndicator(_ vertical: Bool) -> Self {
        base.showsVerticalScrollIndicator = vertical
        return self
    }
    
    /// Horizontal 边框线条
    @discardableResult
    func showsHorizontalScrollIndicator(_ horizontal: Bool) -> Self {
        base.showsHorizontalScrollIndicator = horizontal
        return self
    }
    
    /// 是否开启编辑
    @discardableResult
    func editing(_ editing: Bool) -> Self {
        base.isEditing = editing
        return self
    }
    
    /// 带动画编辑
    @discardableResult
    func setEditing(_ editing: Bool,animated: Bool) -> Self {
        base.setEditing(editing, animated: animated)
        return self
    }
    
    /// 默认是肯定的。控制不在编辑模式下是否可以选择行
    @discardableResult
    func allowsSelection(_ selection: Bool) -> Self {
        base.allowsSelection = selection
        return self
    }
    
    /// 默认的是的。如果是，则跳过内容的边缘并返回
    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        base.bounces = bounces
        return self
    }
    
    /// 默认是否定的。控制是否可以同时选择多个行
    @discardableResult
    func allowsMultipleSelection(_ multipSelection: Bool) -> Self {
        base.allowsMultipleSelection = multipSelection
        return self
    }
    
    /// 默认是否定的。控制在编辑模式下是否可以选择行
    @discardableResult
    func allowsSelectionDuringEditing(_ allowsEditing: Bool) -> Self {
        base.allowsSelectionDuringEditing = allowsEditing
        return self
    }
    
    /// 默认是否定的。控制在编辑模式下是否可以同时选择多行
    @discardableResult
    func allowsMultipleSelectionDuringEditing(_ allowsMultipleSelection: Bool) -> Self {
        base.allowsMultipleSelectionDuringEditing = allowsMultipleSelection
        return self
    }
    
    /// cell 点击状态
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        base.separatorStyle = style
        return self
    }
    
    /// cell 点击颜色
    @discardableResult
    func separatorColor(_ color: UIColor?) -> Self {
        base.separatorColor = color
        return self
    }
    
    /// 以上行内容的附件视图。默认是零。不要与节标题混淆
    @discardableResult
    func tableHeaderView(_ view: UIView?) -> Self {
        base.tableHeaderView = view
        return self
    }
    
    /// 附件视图下面的内容。默认是零。不要与节页脚混淆
    @discardableResult
    func tableFooterView(_ view: UIView?) -> Self {
        base.tableFooterView = view
        return self
    }
    
    /// 未被修改的节索引的背景色
    @discardableResult
    func sectionIndexBackgroundColor(_ color: UIColor?) -> Self {
        base.sectionIndexBackgroundColor = color
        return self
    }
    
    /// 区段索引文本所用的颜色
    @discardableResult
    func sectionIndexColor(_ color: UIColor?) -> Self {
        base.sectionIndexColor = color
        return self
    }
    
    /// 添加容器
    @discardableResult
    func addSubview(_ subView: UIView) -> Self {
        subView.addSubview(base)
        return self
    }
    
    /// 背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        base.backgroundColor = color
        return self
    }
    
    /// 圆角
    @discardableResult
    func cornerRadius(_ radius:CGFloat) -> Self {
        base.layer.cornerRadius = radius
        return self
    }
    
    /// 是否隐藏
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        base.isHidden = hidden
        return self
    }
    
    /// tintColor
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        base.tintColor = color
        return self
    }
    
    /// 透明度
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
    
    /// clipsToBounds
    @discardableResult
    func clipsToBounds(_ clips: Bool) -> Self {
        base.clipsToBounds = clips
        return self
    }
    
    /// isOpaque
    @discardableResult
    func opaque(_ opaque: Bool) -> Self {
        base.isOpaque = opaque
        return self
    }
    
    /// isUserInteractionEnabled
    @discardableResult
    func userInteractionEnabled(_ enabled: Bool) -> Self {
        base.isUserInteractionEnabled = enabled
        return self
    }
    
    /// contentMode
    @discardableResult
    func multipleTouchEnabled(_ enabled: Bool) -> Self {
        base.isMultipleTouchEnabled = enabled
        return self
    }
    
    ///
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        base.contentMode = mode
        return self
    }
    
    /// transform
    @discardableResult
    func transform(_ transform: CGAffineTransform) -> Self {
        base.transform = transform
        return self
    }
    
    /// autoresizingMask
    @discardableResult
    func autoresizingMask(_ mask: UIView.AutoresizingMask) -> Self {
        base.autoresizingMask = mask
        return self
    }
    
    /// autoresizesSubviews
    @discardableResult
    func autoresizesSubviews(_ sizes: Bool) -> Self {
        base.autoresizesSubviews = sizes
        return self
    }
    
    /// 默认为没有。可以做成动画。
    @discardableResult
    func shouldRasterize(_ rasterize: Bool) -> Self {
        base.layer.shouldRasterize = rasterize
        return self
    }
    
    ///
    @discardableResult
    func opacity(_ opacity: Float) -> Self {
        base.layer.opacity = opacity
        return self
    }
    
    /// 图层的背景色。默认值为nil。颜色支持从平铺模式创建。可以做成动画。
    @discardableResult
    func backGroundColor(_ color: UIColor?) -> Self {
        base.layer.backgroundColor = color?.cgColor
        return self
    }
    
    /// 一个提示标记- drawcontext提供的图层内容:完全不透明。默认为没有。注意，这并不影响直接解释' contents'属性。
    @discardableResult
    func opaqueLayer(_ opaque: Bool) -> Self {
        base.layer.isOpaque = opaque
        return self
    }
    
    /// 图层将被栅格化的比例(当shouldRasterize属性已设置为YES)相对于图层的坐标空间。默认为1。可以做成动画。
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        base.layer.rasterizationScale = scale
        return self
    }
    
    /// 当为true时，将应用与图层边界匹配的隐式蒙版 图层(包括' cornerRadius'属性的效果)。如果' mask'和' masksToBounds'两个掩码都是非nil的 乘以得到实际的掩码值。默认为没有。可以做成动画。
    @discardableResult
    func masksToBounds(_ maske: Bool) -> Self {
        base.layer.masksToBounds = maske
        return self
    }
    
    /// 图层边界的宽度，从图层边界中插入。的边框是合成在层的内容和子层和 包含了' cornerRadius'属性的效果。默认为0。可以做成动画。
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        base.layer.borderWidth = width
        return self
    }
    
    /// 图层边界的颜色。默认为不透明的黑色。颜色 支持从平铺模式创建。可以做成动画。
    @discardableResult
    func borderColor(_ color: UIColor?) -> Self {
        base.layer.borderColor = color?.cgColor
        return self
    }
    
    /// 在超层中，该层的锚点的位置 bounds rect对齐到。默认值为0。可以做成动画。
    @discardableResult
    func zPosition(_ point: CGPoint) -> Self {
        base.layer.position = point
        return self
    }
    
    /// 影子的颜色。默认为不透明的黑色。颜色创建 from模式目前不支持。可以做成动画。
    @discardableResult
    func shadowColor(_ color: UIColor?) -> Self {
        base.layer.shadowColor = color?.cgColor
        return self
    }
    
    /// 阴影的不透明。默认值为0。属性之外指定一个值 [0,1]范围将给出未定义的结果。可以做成动画。
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        base.layer.shadowOpacity = opacity
        return self
    }
    
    /// 影子偏移量。默认为(0，-3)。可以做成动画。
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        base.layer.shadowOffset = offset
        return self
    }
    
    /// 用于创建阴影的模糊半径。默认为3。可以做成动画。
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        base.layer.shadowRadius = radius
        return self
    }
    
    /// 相对于该层的锚点应用到该层的转换默认为标识转换。可以做成动画。
    @discardableResult
    func transform(_ transform: CATransform3D) -> Self {
        base.layer.transform = transform
        return self
    }
    
    /// shadowPath
    @discardableResult
    func shadowPath(_ path: CGPath?) -> Self {
        base.layer.shadowPath = path
        return self
    }
    
    /// 手势添加
    @discardableResult
    func addGubview(_ gesture: UIGestureRecognizer) -> Self {
        base.addGestureRecognizer(gesture)
        return self
    }
    
    /// 注册一个基于nib的' UITableViewCell '子类(符合' TFYReusable ' & ' TFYNibLoadable ')
    @discardableResult
    func register<T: UITableViewCell>(cellType: T.Type) -> Self where T: TFYReusable & TFYNibLoadable {
        base.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
        return self
    }
    
    ///注册一个基于类的' UITableViewCell '子类(符合' Reusable ')
    @discardableResult
    func register<T: UITableViewCell>(cellType: T.Type) -> Self where T: TFYReusable {
        base.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
        return self
    }
    
    /// 为由返回类型推断的类返回一个可重用的' UITableViewCell '对象
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
      where T: TFYReusable {
        guard let cell = base.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }
    
    /// 注册一个基于nib的' UITableViewHeaderFooterView '子类(符合' TFYReusable ' & ' TFYNibLoadable ')
    @discardableResult
    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) -> Self
      where T: TFYReusable & TFYNibLoadable {
        base.register(headerFooterViewType.nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
        return self
    }
    
    /// 注册一个基于类的' UITableViewHeaderFooterView '子类(符合'可重用')
    @discardableResult
    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) -> Self
      where T: TFYReusable {
        base.register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
        return self
    }

    /// 返回一个可重用的' UITableViewHeaderFooterView '对象，用于由返回类型推断的类
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T?
      where T: TFYReusable {
        guard let view = base.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
          fatalError(
            "Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) "
              + "matching type \(viewType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the header/footer beforehand"
          )
        }
        return view
    }
}

