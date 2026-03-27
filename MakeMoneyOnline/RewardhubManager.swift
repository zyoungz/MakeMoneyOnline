//
//  RewardhubManager.swift
//  rewardhubSDK
//
//  Created by 向日葵 on 2026/3/27.
//

import UIKit
import Foundation

public class RewardhubManager {

    /// APPID
    var appId:String = ""
    /// 是否打印日志
    var isDebug:Bool = false
    /// 是否是测试环境
    var isTest:Bool = false
    
    
    // 单例（推荐）
    public static let shared = RewardhubManager()

    // 必须 public
    private init() {}

    /// 初始化 SDK
    public func setup(appId: String) {
        print("RewardhubSDK init with appId: \(appId)")
    }

    /// 打开某个页面
    public func openFeature(from vc: UIViewController) {
        let featureVC = MyTestVc()
        let nav = PKBaseNavVC(rootViewController: featureVC)
        
        vc.present(featureVC, animated: true)
    }
}

extension RewardhubManager {
    /// 登录
    public static func login(userId:String) {
        
    }
    
    /// 退出登录
    public static func logout() {
        
    }
    
}
