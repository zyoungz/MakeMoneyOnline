//
//  PKBaseViewController.swift
//  Pick记账
//
//  Created by eagle on 2023/6/8.
//  基础vc

import UIKit
//import IQKeyboardManagerSwift
import SnapKit

class BaseViewController: UIViewController {
    
    var gradientViewH: CGFloat = 351
    private var isGradientViewAdded = false
    
    var gradientColors: [CGColor] {
        [
            UIColor(hex_kit: "#D7C2EB", alpha: 1.0).cgColor,
            UIColor(hex_kit: "#D7C2EB", alpha: 0.6).cgColor,
            UIColor.white.cgColor
        ]
    }
    
    /// 渐变背景默认显示
    var isHiddenGradientView: Bool = false {
        didSet {
            gradientView.isHidden = isHiddenGradientView
        }
    }
    
    /// 渐变背景
    private lazy var gradientView: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    /// 此界面取消使用IQKeyboardManager管理
    var disableIQKeyboardManager = false
    
    var hiddenSystemNavBar: Bool = true
    /// 来源,
    /// 如果涉及到动态传参, 即 可能通过 'push(className: String, parameters: [String: Any]?)' 方法传递的参数, 都要加上此前缀
    @objc dynamic var parentPath: String = ""
    
    lazy var navBar: UIView = {
       let vi = UIView()
        vi.backgroundColor = .clear
        return vi
    }()
    
    lazy var backBt: UIButton = {
        let bt = UIButton(type: .custom)
        bt.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bt.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.roundedCornersKit(cornerRadius: 35/2.0)
        
        return bt
    }()
    
    lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    
    var hiddenBackBt: Bool = false {
        didSet {
            backBt.isHidden = hiddenBackBt
        }
    }
    
    var hiddenNavBar: Bool = false {
        didSet {
            navBar.isHidden = hiddenNavBar
        }
    }
    
    var clTitle: String = "" {
        didSet {
            titleLabel.text = clTitle
        }
    }
    
    /// 埋点对应的 page_name, 子类根据具体实现, 有值就会去实现'PKEventTrack.pageEvent'
    var pageName: String? {
        nil
    }
    
    ///埋点中对应的追加参数值.子类根据具体实现,
    var appendEventDict: [String: Any]? {
        nil
    }
    
    ///埋点中对应的追加参数值.子类根据具体实现,
    var cl_source: String? {
        nil
    }
    
    ///是否在viewDidLoad里面埋点
    var isViewDidLoadTrack: Bool? {
        true
    }
    
    ///是否在viewDidAppear里面埋点
    var isViewDidAppearTrack: Bool? {
        false
    }
    
//    deinit {
//        tkRemoveNotification(observer: self)
//    }
    
    func setupGradientView() {
        
        self.view.insertSubview(gradientView, at: 0)
        gradientView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(gradientViewH)
        }
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

//        gradientView.gradientColor(
//            colors: gradientColors,
//            locations: [0, 1],
//            startPoint: CGPoint(x: 0, y: 0),
//            endPoint: CGPoint(x: 0, y: 1)
//        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        // 是否显示渐变背景
        gradientView.isHidden = isHiddenGradientView
        view.backgroundColor = .white

        setupNavBar()
        
        
//        if let pageName = pageName, isViewDidLoadTrack == true {
//            PKEventTrack.pageEvent(pageName: pageName, source: cl_source, appendEventDict: appendEventDict)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let pageName = pageName, isViewDidAppearTrack == true {
//            PKEventTrack.pageEvent(pageName: pageName, source: cl_source, appendEventDict: appendEventDict)
//        }
    }
    
    func eventClick(target: String) {
//        if let pageName = pageName {
//            PKEventTrack.clickEvent(pageName: pageName, target: target, source: cl_source, appendEventDict: appendEventDict)
//        }

    }
    
    func eventPage() -> Void {
//        if let pageName = pageName {
//            PKEventTrack.pageEvent(pageName: pageName, source: cl_source, appendEventDict: appendEventDict)
//        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController? .setNavigationBarHidden(hiddenSystemNavBar, animated: animated)
        self.navigationController?.navigationBar.isHidden = hiddenSystemNavBar
        self.view.bringSubviewToFront(navBar)
//        if disableIQKeyboardManager {
//            IQKeyboardManager.shared.isEnabled = false
//        }
        
        if !isGradientViewAdded {
            setupGradientView()
            isGradientViewAdded = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if disableIQKeyboardManager {
//            IQKeyboardManager.shared.isEnabled = true
//        }
    }
    
    /// parameters 只支持 添加了   @objc dynamic前缀的基础参数
    func push(className: String, parameters: [String: Any]?) {
        var name = className
        if !name.hasPrefix("MakeMoneyOnline.") {
            name = "MakeMoneyOnline." + className
        }
        if let vcClass = NSClassFromString(name) as? BaseViewController.Type {
            let viewController = vcClass.init()
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    viewController.setValue(value, forKey: key)
                }
            }
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
//    func push(className: String, parameters: [String: Any]? = nil) {
//        // 获取命名空间
//        let namespace = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//        var fullName = className
//        if !fullName.hasPrefix(namespace + ".") {
//            fullName = namespace + "." + className
//        }
//
//        guard let vcClass = NSClassFromString(fullName) as? PKBaseViewController.Type else {
//            DLog("⚠️ 找不到类：\(fullName)")
//            return
//        }
//
//        let viewController = vcClass.init()
//        if let parameters = parameters {
//            for (key, value) in parameters {
//                viewController.setValue(value, forKey: key)
//            }
//        }
//
//        if let nav = self.navigationController {
//            nav.pushViewController(viewController, animated: true)
//        } else {
//            self.present(viewController, animated: true)
//        }
//    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            completion?()
            
//            postNotificaiton(name: .checkShowInterstitialAd)
        }
    }
    
    func setupNavBar() {
        if (self.hiddenNavBar) {
            return
        }
        self.view.addSubview(self.navBar)
        self.navBar.addSubview(self.backBt)
        self.navBar.addSubview(self.titleLabel)
        
        self.navBar.snp.makeConstraints { make in
//            let statusHeight = clStatusBarHeight()
            let statusHeight = 50
            make.left.right.top.equalTo(view)
            make.height.equalTo(52+statusHeight)
        }
        
        self.backBt.snp.makeConstraints { make in
            make.left.equalTo(self.navBar).offset(18)
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.bottom.equalTo(-10)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.backBt)
            make.centerX.equalTo(self.navBar)
        }
        
        self.backBt.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        assert(false, "forUndefinedKey \(key)")
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension BaseViewController {
    
    @IBAction @objc func back(sender: AnyObject?) {
        let vc = self.navigationController?.popViewController(animated: true) ?? nil
       if vc == nil {
           self .dismiss(animated: true, completion: nil)
       }
    }
}
