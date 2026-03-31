//
//  RewardHubNewerCell.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//  新人福利cell

import UIKit

class RewardHubNewerCell: UICollectionViewCell {
    
    /// 背景
    private lazy var whiteBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkPinkKitColor
        view.roundedCornersKit(cornerRadius: 19)
        
        return view
    }()
    
    let btnList: [RewardhubModel]?
    
    
    // 按钮数组
    lazy var typeButtons: [RewardhubActivityView] = {
        return btnList.map { model in
            let guideView = RewardhubActivityView()
            guideView.title = model.title
            guideView.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(guideViewTap))
            singleTap.numberOfTapsRequired = 1
            // 只添加单击手势即可避免双击触发
            guideView.addGestureRecognizer(singleTap)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
            doubleTap.numberOfTapsRequired = 2
            // 单击等双击失败后再触发
            singleTap.require(toFail: doubleTap)
            
            return guideView
        }
    }()
    
    // StackView
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: typeButtons)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
}
