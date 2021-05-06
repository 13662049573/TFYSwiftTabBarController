//
//  TFYSwiftTradeController.swift
//  TFYSwiftTabBarController
//
//  Created by 田风有 on 2021/5/5.
//

import UIKit

class TFYSwiftTradeController: UIViewController,TabBarItemRepeatTouch {

    override func viewDidLoad() {
        super.viewDidLoad()

        let badge = UIButton(type: .system)
        badge.setTitle("更改背景色", for: .normal)
        badge.addTarget(self, action: #selector(badgeClick), for: .touchUpInside)
        badge.frame = CGRect(x: 100, y: 100, width: 100, height: 60)
        view.addSubview(badge)
        
        let number = UIButton(type: .system)
        number.setTitle("数字", for: .normal)
        number.addTarget(self, action: #selector(numberClick), for: .touchUpInside)
        number.frame = CGRect(x: 100, y: 200, width: 60, height: 60)
        view.addSubview(number)
        
        let changeIndex = UIButton(type: .system)
        changeIndex.setTitle("变选中", for: .normal)
        changeIndex.addTarget(self, action: #selector(changeIndexClick), for: .touchUpInside)
        changeIndex.frame = CGRect(x: 100, y: 300, width: 60, height: 60)
        view.addSubview(changeIndex)
        
        let changeIcon = UIButton(type: .system)
        changeIcon.setTitle("变图标", for: .normal)
        changeIcon.addTarget(self, action: #selector(changeIconClick), for: .touchUpInside)
        changeIcon.frame = CGRect(x: 100, y: 400, width: 60, height: 60)
        view.addSubview(changeIcon)
        
        let changeTitle = UIButton(type: .system)
        changeTitle.setTitle("变标题", for: .normal)
        changeTitle.addTarget(self, action: #selector(changeTitleClick), for: .touchUpInside)
        changeTitle.frame = CGRect(x: changeIcon.frame.maxX + 30, y: 400, width: 60, height: 60)
        view.addSubview(changeTitle)
        
        let changeRed = UIButton(type: .system)
        changeRed.setTitle("红点", for: .normal)
        changeRed.tag = 100
        changeRed.addTarget(self, action: #selector(changeRedClick), for: .touchUpInside)
        changeRed.frame = CGRect(x: 100, y: 500, width: 60, height: 60)
        view.addSubview(changeRed)
        
        let changeRed2 = UIButton(type: .system)
        changeRed2.setTitle("红点2", for: .normal)
        changeRed2.addTarget(self, action: #selector(changeRedClick), for: .touchUpInside)
        changeRed2.frame = CGRect(x: changeRed.frame.maxX + 30, y: 500, width: 60, height: 60)
        changeRed2.tag = 101
        view.addSubview(changeRed2)
    }
    

    
    @objc func badgeClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        // 更换背景颜色
        if btn.isSelected {
            let barView = TFY.mainViewController.tabBarView
            barView.setBackgroundImage(image: UIImage(named: "new_tabbar_me_selected")!)
        } else {
            let barView = TFY.mainViewController.tabBarView
            barView.setBackgroundColors(gradientColors:  [UIColor.blue.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor])
        }
    }
    
    @objc func numberClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        TFY.mainViewController.showBadgeNumber(btn.isSelected ? 12 : 0, index: 0)
        TFY.mainViewController.showBadgeNumber(btn.isSelected ? 32 : 0, index: 2)
    }
    
    @objc func changeIndexClick(btn: UIButton) {
        TFY.mainViewController.setSelectedItem(at: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            TFY.mainViewController.setSelectedItem(at: 2)
        })
    }
    
    @objc func changeIconClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        let imageName = btn.isSelected ? "tabbar_reload" : "new_tabbar_home"
        TFY.mainViewController.setUpItemImage(imageName, index: 0)
    }
    
    @objc func changeTitleClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        let str = btn.isSelected ? "首页" : "回到顶部"
        TFY.mainViewController.setUpItemTitle(str, index: 0)
    }
    
    // 设置红点
    @objc func changeRedClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.tag == 100 {
            TFY.mainViewController.setRedPoint(at: 1, isShow: btn.isSelected ? true : false)
            TFY.mainViewController.setRedPoint(at: 2, isShow: btn.isSelected ? true : false)
        } else {
            TFY.mainViewController.setRedPoint(at: 0, isShow: btn.isSelected ? true : false)
        }
    }
    

}
