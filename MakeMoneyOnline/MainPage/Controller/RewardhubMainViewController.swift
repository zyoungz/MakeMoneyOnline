//
//  RewardhubVc.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//  网赚首页

import UIKit
import SnapKit

class RewardhubMainViewController: BaseViewController {
    
    /// viewModel
    let viewModel = RewardhubViewModel()
    
    /// 列表
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        layout.sectionInset = .zero
        /// 垂直行间距
        layout.minimumLineSpacing = 0.0
        /// 水平间隔
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        /// 注册header
        //        collectionView.register(PKChatCreateRoleHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(PKChatCreateRoleHeaderReusableView.classForCoder()))
        collectionView.register(RewardhubHeadReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RewardhubHeadReusableView")
        /// 注册footer
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()))

        /// 活动
        let selfBillsIdentifier = String(describing: RewardhubActivityCell.self)
        collectionView.register(RewardhubActivityCell.self, forCellWithReuseIdentifier: selfBillsIdentifier)
        /// 默认cell
        let defaultIdentifier = String(describing: UICollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultIdentifier)
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
        
        return collectionView
    }()
    
    /// 说明
    private let descLabel: UILabel = {
        let label = UILabel()
        label.attributedText = getAttributed_kit(input: "如有疑问请参考###《活动规则》###\n本活动与Apple.Inc无关", attrs: [NSAttributedString.Key.foregroundColor: UIColor.bigTitleKitColor], lineSpacing: 20, textAlignment: .center)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// UI
    private func setupUI() {
        self.view.addSubview(descLabel)
        self.view.addSubview(collectionView)
        
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-25-AppFrame.kBottomMargin)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(descLabel.snp.top).offset(-25)
        }
    }

}

// FIXME: ---- UICollectionViewDelegate & UICollectionViewDataSource
extension RewardhubMainViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    /// 实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard self.viewModel.sectionList.count > 0 else { return .zero }
        
        let model = self.viewModel.sectionList[section]
        
        return model.list?.count ?? .zero
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.sectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section < self.viewModel.sectionList.count, section == 0 else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: RewardhubHeadReusableView.topHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:RewardhubHeadReusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "RewardhubHeadReusableView",
                for: indexPath) as! RewardhubHeadReusableView
            
            return headerView
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()), for: indexPath)
            
            return view
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.section == 0) {
            return .zero
        } else {
            return CGSize(width: AppFrame.ScreenWidth - 36, height: RewardhubActivityCell.activityHeight)
        }
        
    }

    /// 返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model:RewardhubSectionModel = self.viewModel.sectionList[indexPath.section]
        
        let identifier = String(describing: RewardhubActivityCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? RewardhubActivityCell else {
            fatalError("Unexpected cell in collection view")
        }
        cell.layer.zPosition = CGFloat(indexPath.row)
        cell.backgroundColor = .clear
        
        return cell
        
//        /// 默认数据
//        let identifier = String(describing: UICollectionViewCell.self)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        
//        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}
