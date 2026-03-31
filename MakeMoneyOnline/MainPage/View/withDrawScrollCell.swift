//
//  withDrawScrollCell.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//  提现记录

import UIKit
import SnapKit
import FSPagerView

class withDrawScrollCell: FSPagerViewCell {
    
    class var identifier: String {
        return "withDrawScrollCell"
    }
    
    /// 背景
    private lazy var whiteBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    /// 头像
    private lazy var avatarImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.roundedCornersKit(cornerRadius: 10)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    /// 标题
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = getAttributed_kit(input: "后***子 提现了###10.00###元至微信", UIColor.yellow)
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.white
        label.textAlignment = .left
        
        return label
    }()
    
    /// 微信图标
    private lazy var iconImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .green
        view.contentMode = .scaleAspectFit
        view.roundedCornersKit(cornerRadius: 10)
        
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
        whiteBgView.addSubview(avatarImgView)
        whiteBgView.addSubview(titleLabel)
        whiteBgView.addSubview(iconImgView)
        
        whiteBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        avatarImgView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImgView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(120)
        }
        
        iconImgView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
    }
    
}
