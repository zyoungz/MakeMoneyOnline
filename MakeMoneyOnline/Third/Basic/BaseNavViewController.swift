//
//  PPWLBaseNavController.swift
//  PPWuliu
//
//  Created by zhou Last on 2019/10/15.
//  Copyright © 2019 zhou Last. All rights reserved.
//  导航栏

import UIKit

class BaseNavViewController: UINavigationController,UINavigationControllerDelegate {

    var popDelegate:UIGestureRecognizerDelegate?
    var navBar:UINavigationBar = UINavigationBar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar字体颜色设置
//        self.navigationBar.barTintColor = AppColor.white
        //navigationBar字体颜色设置
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont(name: "Arial", size: 18)]
        self.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]

        self.navigationBar.barTintColor = UIColor.white
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        self.delegate = self
        
        self.navigationBar.barTintColor = UIColor.white
//        self.navigationBar.tintColor = UIColor.init(hexString: "#141414")
        self.navigationBar.tintColor = .black
        self.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        // 获取当前模式
//        if #available(iOS 13.0, *) {
//            let currentMode = UITraitCollection.current.userInterfaceStyle
//            if (currentMode == .dark) {
//                DLog("深色模式")
//                self.navigationController?.navigationBar.barStyle = .black
//            } else if (currentMode == .light) {
//                DLog("浅色模式")
//                self.navigationController?.navigationBar.barStyle = .black
//            } else {
//                DLog("未知模式")
//            }
//        } else {
//            self.navigationController?.navigationBar.barStyle = .default
//        }
        
//        self.navigationBar.layer.shadowColor = AppColor.lineGray.cgColor
//        self.navigationBar.layer.shadowOpacity = 0.25
//        self.navigationBar.layer.shadowOffset = CGSize.init(width: 0, height: 4)
//        self.navigationBar.backgroundColor = AppColor.clear
       
//        var height = 90
//        if iPhoneXSeries {
//            height = 114
//        }
        self.navBar.frame = CGRect.init(x: 0, y: 0, width: Int(AppFrame.ScreenWidth), height: Int(AppFrame.kNavigationBarHeight))
//
//        let image = UIImage(named: "navBg")?
//                    .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15),resizingMode: .stretch)
//
//        self.navigationBar
//            .setBackgroundImage(image, for: .default)
//        self.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    func imageFromColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        
        return image!
    }

    
    //MARK: - UIGestureRecognizerDelegate代理
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // 只有当 visible 的 vc 是聊天页，才显示

        
        /// 实现滑动返回的功能
        /// 清空滑动返回手势的代理就可以实现
        if viewController == self.viewControllers.first {
            self.interactivePopGestureRecognizer?.delegate = self.popDelegate
        } else {
            self.interactivePopGestureRecognizer?.delegate = nil;
        }
    }
    
    
    /// 拦截跳转事件
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            button.backgroundColor = .white
            button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(self.leftClick), for: .touchUpInside)
//            button.roundedCorners(cornerRadius: 35/2.0)
             
            let leftBarButtonItem = UIBarButtonItem(customView: button)
            
            /// 添加图片
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
            /// 添加文字
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(leftClick))
        }
        super.pushViewController(viewController, animated: animated)
        
    }
    
    /// 返回上一层控制器
    @objc func leftClick()  {
        popViewController(animated: true)
    }
    
}
