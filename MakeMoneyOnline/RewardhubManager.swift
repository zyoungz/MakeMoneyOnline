//
//  RewardhubManager.swift
//  rewardhubSDK
//
//  Created by 向日葵 on 2026/3/27.
//

import UIKit
import Foundation

public class RewardhubManager {

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
        vc.present(featureVC, animated: true)
    }
}
