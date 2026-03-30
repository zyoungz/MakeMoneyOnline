//
//  PPWLBaseNavController.swift
//  PPWuliu
//
//  Created by zhou Last on 2019/10/15.
//  Copyright © 2019 zhou Last. All rights reserved.
//  导航栏

import UIKit

class BaseNavVC: UINavigationController,UINavigationControllerDelegate {

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



public enum AppFrame {
    static let ScreenBounds = UIScreen.main.bounds
    /// 屏幕宽度
    static let ScreenWidth = ScreenBounds.size.width
    /// 屏幕高度
    static let ScreenHeight = ScreenBounds.size.height
    /// iPhone4(非必要)
    static let iPhone4 = ScreenHeight  < 568 ? true : false
    /// iPhone 5
    static let iPhone5 = ScreenHeight  == 568 ? true : false
    /// iPhone 6
    static let iPhone6 = ScreenHeight  == 667 ? true : false
    /// iphone 6P
    static let iPhone6P = ScreenHeight == 736 ? true : false
    /// iphone X
    static let iPhoneX = ScreenHeight == 812 ? true : false
    static let iPhone12Pro = ScreenHeight == 844 ? true : false
    /// 特指iphoneX 不含 iphoneXR
    /// 特指iphoneXR 不含 iphoneX
    static let iPhoneXR = ScreenHeight == 896 ? true : false
    // navigationBarHeight
    static let kNavigationBarHeight : CGFloat = iPhoneX ? 88 : 64
    /// tabBarHeight(系统tabbar高度)
//    static let kTabBarHeight : CGFloat = CGFloat.systemTabBarHeight
//    /** 如果是iPhoneX按照Plus 尺寸计算比例 */
//    static let Scale_Height = iPhoneX ? 736.0/667.0 : ScreenHeight / 667
//    static let Scale_Width = ScreenWidth / 375
//    /// 底部安全区域
//    static let kBottomMargin : CGFloat = iPhoneXSeries ? tkSafeAreaBottom() : 0
//    ///底部安全区域的一半高度
//    static let kBottomMidMargin : CGFloat = iPhoneXSeries ? 20 : 0
//    /// 状态栏
//    static let kTopMargin : CGFloat = iPhoneXSeries ? 24 : 0
//    
//    /// 返回状态栏高度
//    static let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height
//    /// 返回状态栏和导航栏的高度
//    static let NavAndstatusBarHeight = clStatusBarHeight() + 44
}
