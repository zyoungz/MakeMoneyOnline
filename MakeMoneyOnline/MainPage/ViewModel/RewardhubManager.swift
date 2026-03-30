//
//  RewardhubManager.swift
//  rewardhubSDK
//
//  Created by 向日葵 on 2026/3/27.
//

import UIKit
import Foundation

public protocol RewardhubDelegate: AnyObject {
    /// 获取用户token
    func getUserToken() -> String
}

public class RewardhubManager {

    /// APPID
    var appId:String = ""
    /// 是否打印日志
    var isDebug:Bool = false
    /// 是否是测试环境
    var isTest:Bool = false
    
    // 用 weak 防止循环引用
    public weak var delegate: RewardhubDelegate?
    
    // 单例（推荐）
    public static let shared = RewardhubManager()
    
    // SDK 内部调用
    public func fetchTokenFromHost() -> String {
        return delegate?.getUserToken() ?? ""
    }

    // 必须 public
    private init() {}

    /// 初始化 SDK
    public func setup(appId: String) {
        print("RewardhubSDK init with appId: \(appId)")
    }

    /// 打开某个页面
    public func openFeature(from vc: UIViewController) {
        let featureVC = MyTestVc()
        // 设置 modal 全屏
        featureVC.modalPresentationStyle = .fullScreen
        let nav = PKBaseNavVC(rootViewController: featureVC)
        nav.modalPresentationStyle = .fullScreen  // ✅ 关键：导航控制器也要设置
        vc.present(nav, animated: true)
        
        let token = RewardhubManager.shared.fetchTokenFromHost()
        print("拿到宿主 token: \(token)")
    }
    
    public func test123() {
        print("NEW SDK")
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
