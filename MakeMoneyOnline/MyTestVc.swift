//
//  MyTestVc.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/27.
//

import UIKit

class MyTestVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .purple
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
