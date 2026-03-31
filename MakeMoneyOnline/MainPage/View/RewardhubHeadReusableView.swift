//
//  RewardhubHeadReusableView.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//  福利中心-顶部金额部分

import UIKit
import SwifterSwift
import FSPagerView
import SnapKit

class RewardhubHeadReusableView: UICollectionReusableView {
        
    class var identifier: String {
        return "RewardhubHeadReusableView"
    }
    
    /// 高度
    static var topHeight:CGFloat = 358.0
    
    /// 背景
    private lazy var whiteBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightPinkKitColor
        
        return view
    }()
    
    // 提现记录轮播
    private lazy var autoScrollView: FSPagerView = {
        let view = FSPagerView()
        view.backgroundColor = UIColor.init(hex_kit: "#AD677F")
        
        return view
    }()
    
    /// 金额背景
    private lazy var moneyBgImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.redKitColor
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        addSubview(whiteBgView)
        whiteBgView.addSubview(autoScrollView)
        whiteBgView.addSubview(moneyBgImgView)
        
        whiteBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        autoScrollView.snp.makeConstraints { make in
            make.left.equalTo(36)
            make.top.equalTo(141)
            make.width.equalTo(212)
            make.height.equalTo(30)
        }
        
        moneyBgImgView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.top.equalTo(autoScrollView.snp.bottom).offset(5)
            make.height.equalTo(204)
        }
        
    }
    
    
}
