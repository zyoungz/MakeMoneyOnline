//
//  RewardhubSectionModel.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//

import UIKit
import ObjectMapper

enum RewardhubType:Int {
    /// 福利中心
    case rewardCenter = 1
    /// 新人福利
    case newerReward
    /// 日常福利
    case normalReward
}

struct RewardhubSectionModel: Mappable {

    /// 类型
    var type:RewardhubType = .rewardCenter
    var list:[RewardhubModel]?
    
    init() {}  // 👈 手动加一个默认构造函数
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        type            <- map["type"]
        list            <- map["list"]
    }
    
}
