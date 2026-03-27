//
//  MyTestVc.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/27.
//

import UIKit
import SnapKit

class MyTestVc: UIViewController {

    /// 标题
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "标题"
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.black
        label.textAlignment = .left
        
        return label
    }()
    
    /// 确定按钮
    private lazy var okButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("长按说话", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        /// 录音完成
        button.addTarget(self, action: #selector(okButtonAction) , for: .touchUpInside)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setupUI()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.navigationItem.title = "测试"
        self.view.addSubview(titleLabel)
        self.view.addSubview(okButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.left.equalTo(18)
            make.right.equalTo(-18)
        }
        
    }

}

extension MyTestVc {
    /// 确定
    @objc private func okButtonAction() {
        
    }
    
}
