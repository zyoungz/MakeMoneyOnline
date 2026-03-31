//
//  PKMsgView.swift
//  Pick记账
//
//  Created by Pick记账 on 2023/6/26.
//

import UIKit
import SnapKit
import SwifterSwift

class PKMsgView: PKBaseView {

    @IBOutlet weak var tipsHeight: NSLayoutConstraint!
    @IBOutlet weak var msgLab: UILabel!
    
    // 提示消失时间
//    let afterTime = 1.5

    static func ShowView(_ msg: String, afterTime: CGFloat = 1.5) -> PKMsgView? {
        return ShowView(attribute: getAttributed_kit(input: msg, textAlignment: .center), afterTime: afterTime)
    }
    
    static func ShowView(attribute: NSAttributedString, afterTime: CGFloat = 1.5) -> PKMsgView? {
        
        if attribute.string.isEmpty {
            return nil
        }
        
        let view = PKMsgView.build()
        view.msgLab.attributedText = attribute
        view.tipsHeight.constant = max(attribute.getHeight_kit(width: AppFrame.ScreenWidth - 50), 50)
        
        guard let window = cl_HudWindow() else { return nil }
        view.backgroundColor = .clear
        view.tag = 9998
        window.addSubview(view)
        window.isHidden = false
        
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-tkStatusBarHeight_kit())
            make.left.right.equalToSuperview()
            make.height.equalTo(clStatusBarNavHeight_kit())
        }
        window.setNeedsLayout()
        window.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.15) {
            view.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(0)
                make.left.right.equalToSuperview()
                make.height.equalTo(clStatusBarNavHeight_kit())
            }
            window.setNeedsLayout()
            window.layoutIfNeeded()
        } completion: { finish in
            
        }

//        view.backgroundColor = .clear
//        let attribute = EKAttributes.setupSheetTop(height: clStatusBarNavHeight(), screenInteraction: .absorbTouches, displayDuration: view.afterTime)
//        SwiftEntryKit.display(entry: view, using: attribute)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + afterTime, execute: dissMissView(view))

        return view
    }
    
    func dissMissView() -> Void {
//        SwiftEntryKit.dismiss()
        
//        guard let window = cl_toastWindow(), let view = window.viewWithTag(9998) else { return }
        UIView.animate(withDuration: 0.15) {
            self.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(-clStatusBarNavHeight_kit())
                make.left.right.equalToSuperview()
                make.height.equalTo(clStatusBarNavHeight_kit())
            }
            cl_HudWindow()?.setNeedsLayout()
            cl_HudWindow()?.layoutIfNeeded()
        } completion: { finsh in
            self.removeSubviews()
            
//            cl_toastWindow()?.isHidden = true
        }

        
    }
    
}
