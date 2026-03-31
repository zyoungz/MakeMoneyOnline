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
        view.isInfinite = true
        view.delegate = self
        view.dataSource = self
        view.scrollDirection = .vertical
        view.roundedCornersKit(cornerRadius: 15.0)
        view.automaticSlidingInterval = 3.0
        view.register(withDrawScrollCell.self, forCellWithReuseIdentifier: withDrawScrollCell.identifier)
        let bannerWidth = AppFrame.ScreenWidth - 18 * 2
        let bannerHeight = 30
        view.itemSize = CGSize(width: bannerWidth.int, height: bannerHeight)
        
        return view
    }()
    
    /// 金额背景
    private lazy var moneyBgImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rewardhub_top_bg")
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
            make.height.equalTo(276)
        }
        
    }
    
}

///  滚动代理
extension RewardhubHeadReusableView: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: withDrawScrollCell.identifier, at: index) as? withDrawScrollCell else {
            fatalError("Unexpected cell in collection view")
        }
        
        return cell
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        //        DLog("pageView pagerViewDidEndDecelerating \(pagerView.currentIndex)")
//        pageControl.currentPage = pagerView.currentIndex
//        if isUserDrag {
//            isUserDrag = false
//            bannerIconCollection.selectItem(at: IndexPath(row: pagerView.currentIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
//        }
    }
}
