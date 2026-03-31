//
//  HUDManager.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//

import UIKit

public final class HUDManager {
    
    public static let shared = HUDManager()
    
    private init() {}
    
    // MARK: - Window 获取（兼容 Scene）
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    // MARK: - 基础方法
    public func showErrorMsg(_ msg: String) {
        DispatchQueue.main.async {
            BJDLog("_____" + msg)
            _ = PKMsgView.ShowView(msg)
        }
    }
    
    public func showSuccessMsg(_ msg: String) {
        DispatchQueue.main.async {
            BJDLog("_____" + msg)
            _ = PKMsgView.ShowView(msg)
        }
    }
    
    public func showNormalMsg(_ msg: String) {
        DispatchQueue.main.async {
            BJDLog("_____" + msg)
            _ = PKMsgView.ShowView(msg)
        }
    }
    
    public func showAttributeMsg(_ attribute: NSAttributedString,
                                 afterTime: CGFloat = 1.5) {
        DispatchQueue.main.async {
            _ = PKMsgView.ShowView(attribute: attribute,
                                   afterTime: afterTime)
        }
    }
    
    public func showLoadingHUD() {
        DispatchQueue.main.async {
            BJDLog("_____showLoadingHUD____")
            _ = PKLoadingView.ShowView()
        }
    }
    
    public func dismissLoadingHUD() {
        DispatchQueue.main.async {
            BJDLog("_____dismissLoadingHUD____")
            PKLoadingView.DissMissView()
        }
    }
}
