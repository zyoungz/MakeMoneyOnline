//
//  RewardhubActionvityCell.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//  活动cell

import UIKit
import SnapKit

class RewardhubActivityCell: UICollectionViewCell {
    
    /// 高度
    static var activityHeight:CGFloat = 80.0
    
    /// 背景
    private lazy var whiteBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    /// 图标
    lazy var iconImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    /// 标题
    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "标题"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.smallTitleKitColor
        label.textAlignment = .left
        
        return label
    }()
    
    /// 描述
    private let descLabel: UILabel = {
        let label = UILabel()
//        label.text = "标题"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.grayKitColor
        label.textAlignment = .left
        
        return label
    }()
    
    /// 操作按钮
    private lazy var optButton:UIButton = {
        
        let button = UIButton()
        button.backgroundColor = UIColor.redKitColor
        button.setTitle("去领取", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        /// 录音完成
        button.addTarget(self, action: #selector(optButtonAction) , for: .touchUpInside)
        button.roundedCornersKit(cornerRadius: 30/2.0)
        
        return button
    }()
    
    /// 线
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightPinkKitColor
        
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
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(whiteBgView)
        whiteBgView.addSubview(iconImgView)
        whiteBgView.addSubview(titleLabel)
        whiteBgView.addSubview(descLabel)
        whiteBgView.addSubview(optButton)
        whiteBgView.addSubview(lineView)
        
        whiteBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImgView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        optButton.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImgView.snp.right).offset(12)
            make.right.equalTo(optButton.snp.left).offset(-10)
            make.top.equalTo(iconImgView).offset(10)
            make.height.equalTo(16)
        }
        
    }
    
}


extension RewardhubActivityCell {
    /// 点击按钮
    @objc private func optButtonAction() {
        
    }
    
}
