//
//  PKLoadingView.swift
//  Pick记账
//
//  Created by Pick记账 on 2023/6/26.
//

import UIKit
import SnapKit
import Kingfisher

class PKLoadingView: PKBaseView {

    @IBOutlet weak var imgView: UIImageView!

    static func ShowView() -> PKLoadingView? {
        
        guard let window = cl_HudWindow() else { return  nil}
        window.isHidden = false
        
        let view = PKLoadingView.build()
        
        window.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        view.imgView.setImage_kit(gifName: "cl_loading")
        
        view.tag = 9999

        return view
    }

    static func DissMissView() -> Void {
        guard let window = cl_HudWindow() else { return }
        
        for sub in window.subviews.reversed() { // 避免有多个的情况
            if sub.isKind(of: PKLoadingView.self) {
                sub.removeFromSuperview()
            }
        }
        
    }
}


func cl_HudWindow() -> UIWindow? {
    
    if RewardhubManager.shared.hudWindow == nil {
        let window = HUDWindow(frame: UIScreen.main.bounds)
        let toastRoot = BaseViewController()
        toastRoot.view.backgroundColor = .clear
#if DEBUG
#endif
        toastRoot.hiddenNavBar = true
        window.rootViewController = toastRoot
        RewardhubManager.shared.hudWindow = window
    }
    return RewardhubManager.shared.hudWindow
    
//    return UIApplication.shared.windows.first
}

class HUDWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommand()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommand()
    }
    
    func initCommand() {
        self.windowLevel = UIWindow.Level.statusBar + 1
#if DEBUG
        self.backgroundColor = tkRandowColor_kit(alpha: 0.4)
#endif
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let vi = super.hitTest(point, with: event), vi.isKind(of: PKLoadingView.self) {
            return vi
        }
        return nil
    }
}
