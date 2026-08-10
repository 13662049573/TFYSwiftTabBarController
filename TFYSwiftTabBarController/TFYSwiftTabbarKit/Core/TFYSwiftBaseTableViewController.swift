//
//  TFYSwiftBaseTableViewController.swift
//  TFYSwiftTabBarController
//
//  Converted from CYLBaseTableViewController.h/.m
//

import UIKit

open class TFYSwiftBaseTableViewController: UITableViewController {

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfy_viewWillAppearNavigationSetting(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfy_viewDidAppearNavigationSetting(animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tfy_viewWillDisappearNavigationSetting(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tfy_viewDidDisappearNavigationSetting(animated)
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        tfy_deallocNavigationSetting()
    }
}
