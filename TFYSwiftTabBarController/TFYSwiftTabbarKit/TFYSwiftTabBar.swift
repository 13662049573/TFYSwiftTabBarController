//
//  TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/18.
//

import UIKit

// MARK: - Enums
public enum TFYSwiftTabBarItemPositioning: Int {
    case automatic
    case fill
    case centered
    case fillExcludeSeparator
    case fillIncludeSeparator
}

// MARK: - Protocols
/// 对UITabBarDelegate进行扩展，以支持UITabBarControllerDelegate的相关方法桥接
internal protocol TFYSwiftTabBarDelegate: NSObjectProtocol {
    /// 当前item是否支持选中
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool
    
    /// 当前item是否需要被劫持
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool
    
    /// 当前item的点击被劫持
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem)
}

// MARK: - TFYSwiftTabBar
/// TFYSwiftTabBar是高度自定义的UITabBar子类，通过添加UIControl的方式实现自定义tabBarItem的效果
open class TFYSwiftTabBar: UITabBar {
    
    // MARK: - Properties
    
    internal weak var customDelegate: TFYSwiftTabBarDelegate?
    
    /// tabBar中items布局偏移量
    public var itemEdgeInsets = UIEdgeInsets.zero
    
    /// 是否设置为自定义布局方式，默认为空
    public var itemCustomPositioning: TFYSwiftTabBarItemPositioning? {
        didSet {
            guard let itemCustomPositioning = itemCustomPositioning else { return }
            
            switch itemCustomPositioning {
            case .fill:
                itemPositioning = .fill
            case .automatic:
                itemPositioning = .automatic
            case .centered:
                itemPositioning = .centered
            default:
                break
            }
            self.reload()
        }
    }
    
    /// tabBar自定义item的容器view
    internal var containers = [TFYSwiftTabBarItemContainer]()
    
    /// 缓存当前tabBarController用来判断是否存在"More"Tab
    internal weak var tabBarController: UITabBarController?
    
    /// 自定义'More'按钮样式，继承自TFYSwiftTabBarItemContentView
    open var moreContentView: TFYSwiftTabBarItemContentView? = TFYSwiftTabBarItemMoreContentView() {
        didSet { self.reload() }
    }
    
    /// 是否处于编辑状态
    open var isEditing: Bool = false {
        didSet {
            if oldValue != isEditing {
                self.updateLayout()
            }
        }
    }
    
    // MARK: - Override Properties
    
    open override var items: [UITabBarItem]? {
        didSet {
            self.reload()
        }
    }
    
    // MARK: - Override Methods
    
    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        self.reload()
    }
    
    open override func beginCustomizingItems(_ items: [UITabBarItem]) {
        TFYSwiftTabbarController.printError("beginCustomizingItems(_:) is unsupported in TFYSwiftTabBar.")
        super.beginCustomizingItems(items)
    }
    
    open override func endCustomizing(animated: Bool) -> Bool {
        TFYSwiftTabbarController.printError("endCustomizing(_:) is unsupported in TFYSwiftTabBar.")
        return super.endCustomizing(animated: animated)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLayout()
        self.hiddenTabBarImageView()
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for container in containers {
                let containerPoint = CGPoint(x: point.x - container.frame.origin.x,
                                           y: point.y - container.frame.origin.y)
                if container.point(inside: containerPoint, with: event) {
                    b = true
                    break
                }
            }
        }
        return b
    }
    
    // MARK: - Private Methods
    
    /// 隐藏TabBar背景图片
    private func hiddenTabBarImageView() {
        let viewsArr = subviews
        for view in viewsArr {
            if view.isKind(of: NSClassFromString("_UIBarBackground")!) {
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Layout Extension
internal extension TFYSwiftTabBar {
    
    func updateLayout() {
        guard let tabBarItems = self.items else {
            TFYSwiftTabbarController.printError("empty items")
            return
        }
        
        let tabBarButtons = getTabBarButtons()
        
        updateButtonVisibility(tabBarItems: tabBarItems, tabBarButtons: tabBarButtons)
        updateContainerLayout(tabBarButtons: tabBarButtons)
    }
    
    private func getTabBarButtons() -> [UIView] {
        let tabBarButtons = subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
        }.sorted { (subview1, subview2) -> Bool in
            return subview1.frame.origin.x < subview2.frame.origin.x
        }
        return tabBarButtons
    }
    
    private func updateButtonVisibility(tabBarItems: [UITabBarItem], tabBarButtons: [UIView]) {
        if isCustomizing {
            for (idx, _) in tabBarItems.enumerated() {
                tabBarButtons[idx].isHidden = false
                moreContentView?.isHidden = true
            }
            for container in containers {
                container.isHidden = true
            }
        } else {
            for (idx, item) in tabBarItems.enumerated() {
                if let _ = item as? TFYSwiftTabBarItem {
                    tabBarButtons[idx].isHidden = true
                } else {
                    tabBarButtons[idx].isHidden = false
                }
                if isMoreItem(idx), let _ = moreContentView {
                    tabBarButtons[idx].isHidden = true
                }
            }
            for container in containers {
                container.isHidden = false
            }
        }
    }
    
    private func updateContainerLayout(tabBarButtons: [UIView]) {
        var layoutBaseSystem = true
        if let itemCustomPositioning = itemCustomPositioning {
            switch itemCustomPositioning {
            case .fill, .automatic, .centered:
                break
            case .fillIncludeSeparator, .fillExcludeSeparator:
                layoutBaseSystem = false
            }
        }
        
        if layoutBaseSystem {
            // System itemPositioning
            for (idx, container) in containers.enumerated() {
                if !tabBarButtons[idx].frame.isEmpty {
                    container.frame = tabBarButtons[idx].frame
                }
            }
        } else {
            // Custom itemPositioning
            layoutContainersWithCustomPositioning()
        }
    }
    
    private func layoutContainersWithCustomPositioning() {
        var x: CGFloat = itemEdgeInsets.left
        var y: CGFloat = itemEdgeInsets.top
        
        switch itemCustomPositioning! {
        case .fillExcludeSeparator:
            if y <= 0.0 {
                y += 1.0
            }
        default:
            break
        }
        
        let width = bounds.size.width - itemEdgeInsets.left - itemEdgeInsets.right
        let height = bounds.size.height - y - itemEdgeInsets.bottom
        let eachWidth = itemWidth == 0.0 ? width / CGFloat(containers.count) : itemWidth
        let eachSpacing = itemSpacing == 0.0 ? 0.0 : itemSpacing
        
        for container in containers {
            container.frame = CGRect(x: x, y: y, width: eachWidth, height: height)
            x += eachWidth + eachSpacing
        }
    }
}

// MARK: - Actions Extension
internal extension TFYSwiftTabBar {
    
    func isMoreItem(_ index: Int) -> Bool {
        return TFYSwiftTabbarController.isShowingMore(tabBarController) && (index == (items?.count ?? 0) - 1)
    }
    
    func removeAll() {
        for container in containers {
            container.removeFromSuperview()
        }
        containers.removeAll()
    }
    
    func reload() {
        removeAll()
        guard let tabBarItems = self.items else {
            TFYSwiftTabbarController.printError("empty items")
            return
        }
        
        for (idx, item) in tabBarItems.enumerated() {
            let container = TFYSwiftTabBarItemContainer(self, tag: 1000 + idx)
            self.addSubview(container)
            self.containers.append(container)
            
            if let item = item as? TFYSwiftTabBarItem {
                container.addSubview(item.contentView)
            }
            if self.isMoreItem(idx), let moreContentView = moreContentView {
                container.addSubview(moreContentView)
            }
        }
        
        self.isTranslucent = false
        self.updateAccessibilityLabels()
        self.setNeedsLayout()
    }
    
    @objc func highlightAction(_ sender: AnyObject?) {
        guard let container = sender as? TFYSwiftTabBarItemContainer else { return }
        
        let newIndex = max(0, container.tag - 1000)
        guard newIndex < items?.count ?? 0,
              let item = self.items?[newIndex],
              item.isEnabled == true else {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldSelect: item) ?? true) == false {
            return
        }
        
        if let item = item as? TFYSwiftTabBarItem {
            item.contentView.highlight(animated: true, completion: nil)
        } else if self.isMoreItem(newIndex) {
            moreContentView?.highlight(animated: true, completion: nil)
        }
    }
    
    @objc func dehighlightAction(_ sender: AnyObject?) {
        guard let container = sender as? TFYSwiftTabBarItemContainer else { return }
        
        let newIndex = max(0, container.tag - 1000)
        guard newIndex < items?.count ?? 0,
              let item = self.items?[newIndex],
              item.isEnabled == true else {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldSelect: item) ?? true) == false {
            return
        }
        
        if let item = item as? TFYSwiftTabBarItem {
            item.contentView.dehighlight(animated: true, completion: nil)
        } else if self.isMoreItem(newIndex) {
            moreContentView?.dehighlight(animated: true, completion: nil)
        }
    }
    
    @objc func selectAction(_ sender: AnyObject?) {
        guard let container = sender as? TFYSwiftTabBarItemContainer else { return }
        select(itemAtIndex: container.tag - 1000, animated: true)
    }
    
    @objc func select(itemAtIndex idx: Int, animated: Bool) {
        let newIndex = max(0, idx)
        let currentIndex = (selectedItem != nil) ? (items?.firstIndex(of: selectedItem!) ?? -1) : -1
        
        guard newIndex < items?.count ?? 0,
              let item = self.items?[newIndex],
              item.isEnabled == true else {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldSelect: item) ?? true) == false {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldHijack: item) ?? false) == true {
            customDelegate?.tabBar(self, didHijack: item)
            if animated {
                performHijackAnimation(item: item, newIndex: newIndex, animated: animated)
            }
            return
        }
        
        if currentIndex != newIndex {
            performSelectionChange(currentIndex: currentIndex, newIndex: newIndex, item: item, animated: animated)
        } else if currentIndex == newIndex {
            performReselection(item: item, newIndex: newIndex, animated: animated)
        }
        
        delegate?.tabBar?(self, didSelect: item)
        self.updateAccessibilityLabels()
    }
    
    private func performHijackAnimation(item: UITabBarItem, newIndex: Int, animated: Bool) {
        if let item = item as? TFYSwiftTabBarItem {
            item.contentView.select(animated: animated, completion: {
                item.contentView.deselect(animated: false, completion: nil)
            })
        } else if self.isMoreItem(newIndex) {
            moreContentView?.select(animated: animated, completion: {
                self.moreContentView?.deselect(animated: animated, completion: nil)
            })
        }
    }
    
    private func performSelectionChange(currentIndex: Int, newIndex: Int, item: UITabBarItem, animated: Bool) {
        if currentIndex != -1 && currentIndex < items?.count ?? 0 {
            if let currentItem = items?[currentIndex] as? TFYSwiftTabBarItem {
                currentItem.contentView.deselect(animated: animated, completion: nil)
            } else if self.isMoreItem(currentIndex) {
                moreContentView?.deselect(animated: animated, completion: nil)
            }
        }
        
        if let item = item as? TFYSwiftTabBarItem {
            item.contentView.select(animated: animated, completion: nil)
        } else if self.isMoreItem(newIndex) {
            moreContentView?.select(animated: animated, completion: nil)
        }
    }
    
    private func performReselection(item: UITabBarItem, newIndex: Int, animated: Bool) {
        if let item = item as? TFYSwiftTabBarItem {
            item.contentView.reselect(animated: animated, completion: nil)
        } else if self.isMoreItem(newIndex) {
            moreContentView?.reselect(animated: animated, completion: nil)
        }
        
        handleNavigationControllerReselection(animated: animated)
    }
    
    private func handleNavigationControllerReselection(animated: Bool) {
        guard let tabBarController = tabBarController else { return }
        
        var navVC: UINavigationController?
        if let n = tabBarController.selectedViewController as? UINavigationController {
            navVC = n
        } else if let n = tabBarController.selectedViewController?.navigationController {
            navVC = n
        }
        
        guard let navVC = navVC else { return }
        
        if navVC.viewControllers.contains(tabBarController) {
            if navVC.viewControllers.count > 1 && navVC.viewControllers.last != tabBarController {
                navVC.popToViewController(tabBarController, animated: true)
            }
        } else {
            if navVC.viewControllers.count > 1 {
                navVC.popToRootViewController(animated: animated)
            }
        }
    }
    
    func updateAccessibilityLabels() {
        guard let tabBarItems = self.items,
              tabBarItems.count == self.containers.count else {
            return
        }
        
        for (idx, item) in tabBarItems.enumerated() {
            let container = self.containers[idx]
            container.accessibilityIdentifier = item.accessibilityIdentifier
            container.accessibilityTraits = item.accessibilityTraits
            
            if item == selectedItem {
                container.accessibilityTraits = container.accessibilityTraits.union(.selected)
            }
            
            updateContainerAccessibilityLabel(container: container, item: item, idx: idx, tabBarItems: tabBarItems)
        }
    }
    
    private func updateContainerAccessibilityLabel(container: TFYSwiftTabBarItemContainer, item: UITabBarItem, idx: Int, tabBarItems: [UITabBarItem]) {
        if let explicitLabel = item.accessibilityLabel {
            container.accessibilityLabel = explicitLabel
            container.accessibilityHint = item.accessibilityHint ?? container.accessibilityHint
        } else {
            var accessibilityTitle = ""
            if let item = item as? TFYSwiftTabBarItem {
                accessibilityTitle = item.accessibilityLabel ?? item.title ?? ""
            }
            if self.isMoreItem(idx) {
                accessibilityTitle = NSLocalizedString("More_TabBarItem", bundle: Bundle(for: TFYSwiftTabbarController.self), comment: "")
            }
            
            let formatString = NSLocalizedString(item == selectedItem ? "TabBarItem_Selected_AccessibilityLabel" : "TabBarItem_AccessibilityLabel",
                                               bundle: Bundle(for: TFYSwiftTabbarController.self),
                                               comment: "")
            container.accessibilityLabel = String(format: formatString, accessibilityTitle, idx + 1, tabBarItems.count)
        }
    }
}
