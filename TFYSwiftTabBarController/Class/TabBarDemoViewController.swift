//
//  TabBarDemoViewController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2024/1/1.
//

import UIKit

/// TabBar功能演示主控制器
class TabBarDemoViewController: UIViewController {
    
    private let tableView = UITableView()
    private let demos = [
        ("基础TabBar", "展示基础的TabBar功能"),
        ("自定义TabBar", "展示自定义样式的TabBar"),
        ("徽章功能", "展示徽章显示和管理功能"),
        ("动画效果", "展示丰富的动画和交互效果"),
        ("事件劫持", "展示自定义点击事件处理"),
        ("More按钮", "展示自定义More按钮样式"),
        ("响应式布局", "展示不同屏幕尺寸和方向的适配")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "TFYSwiftTabBarController 功能演示"
        view.backgroundColor = UIColor.white
        
        // 设置TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension TabBarDemoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        let demo = demos[indexPath.row]
        
        cell.textLabel?.text = demo.0
        cell.detailTextLabel?.text = demo.1
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TabBarDemoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let demoVC: UIViewController
        
        switch indexPath.row {
        case 0:
            demoVC = BasicTabBarViewController()
        case 1:
            demoVC = CustomTabBarViewController()
        case 2:
            demoVC = BadgeTabBarViewController()
        case 3:
            demoVC = AnimationTabBarViewController()
        case 4:
            demoVC = HijackTabBarViewController()
        case 5:
            demoVC = MoreTabBarViewController()
        case 6:
            demoVC = ResponsiveTabBarViewController()
        default:
            return
        }
        
        demoVC.title = demos[indexPath.row].0
        navigationController?.pushViewController(demoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
} 