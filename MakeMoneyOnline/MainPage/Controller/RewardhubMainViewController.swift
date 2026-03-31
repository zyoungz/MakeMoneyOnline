//
//  RewardhubVc.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//  网赚首页

import UIKit

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
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.isHidden = true
        /// 注册header
        //        collectionView.register(PKChatCreateRoleHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(PKChatCreateRoleHeaderReusableView.classForCoder()))
        collectionView.register(RewardhubHeadReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RewardhubHeadReusableView")
        /// 注册footer
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()))
//       
//        let selfBillsIdentifier = String(describing: PKAIChatSelfBillsCell.self)
//        collectionView.register(PKAIChatSelfBillsCell.self, forCellWithReuseIdentifier: selfBillsIdentifier)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// UI
    private func setupUI() {
        
    }
    

}

// FIXME: ---- UICollectionViewDelegate & UICollectionViewDataSource
//extension RewardhubMainViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//    /// 实现UICollectionViewDataSource
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return 1
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.viewModel.sectionList.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        guard section < self.viewModel.sectionList.count else { return .zero }
//        return CGSize(width: collectionView.bounds.width, height: RewardhubHeadReusableView.topHeight)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return .zero
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if (kind == UICollectionView.elementKindSectionHeader) {
//            let headerView:RewardhubHeadReusableView = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: "RewardhubHeadReusableView",
//                for: indexPath) as! RewardhubHeadReusableView
//            
//            return headerView
//        } else {
//            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()), for: indexPath)
//            
//            return view
//        }
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        if (indexPath.section == 0) {
//            return CGSize(width: AppFrame.ScreenWidth - 36, height: PKBillBookInfoTotalCell.billBookInfoTotalHeight)
//        } else {
//            return CGSize(width: AppFrame.ScreenWidth - 36, height: 55)
//        }
//        
//    }
//
//    /// 返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let model:PKBillBookInfoModel = self.viewModel.sectionList[indexPath.section]
//        
//        switch model.type {
//        case .general:
//            /// 账本总览
//            let identifier = String(describing: PKBillBookInfoTotalCell.self)
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PKBillBookInfoTotalCell else {
//                fatalError("Unexpected cell in collection view")
//            }
//            cell.layer.zPosition = CGFloat(indexPath.row)
//            cell.backgroundColor = .clear
//            cell.fillBillBookTotalData(self.viewModel.billGroup)
//            
//            return cell
//        case .bookName:
//            /// 账本名称
//            let identifier = String(describing: PKChatCreateRoleNameCell.self)
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PKChatCreateRoleNameCell else {
//                fatalError("Unexpected cell in collection view")
//            }
//            cell.layer.zPosition = CGFloat(indexPath.row)
//            cell.backgroundColor = .clear
//            cell.delegate = self
//            cell.nameTextField.placeholder = "请输入账本名称"
//            cell.fillBillBookNameData(billBook?.name ?? "")
//            
//            return cell
//        case .monthlyStartDay:
//            /// 月起始日
//            let identifier = String(describing: PKBillBookInfoMonthlyDayCell.self)
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PKBillBookInfoMonthlyDayCell else {
//                fatalError("Unexpected cell in collection view")
//            }
//            cell.layer.zPosition = CGFloat(indexPath.row)
//            cell.backgroundColor = .clear
//            cell.delegate = self
//            cell.fillMonthlyStartDay(self.viewModel.billBook?.startDay ?? 1)
//            
//            return cell
//        default:
//            break
//        }
//        
//        /// 默认数据
//        let identifier = String(describing: UICollectionViewCell.self)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
    
//}
