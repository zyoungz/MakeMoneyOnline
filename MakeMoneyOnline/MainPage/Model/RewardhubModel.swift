//
//  RewardhubModel.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//

import UIKit
import ObjectMapper

struct RewardhubModel: Mappable {

    /// 0 点亮了 1 升级了 2 降级了
    var type:Int = 0
    /// 火花名称
    var chatLevelName:String = ""
    /// 火花图标
    var chatLevelIcon:String = ""
    /// 等级
    var chatLevel:Int = 0
    /// icon名称 （埋点用）
    var iconTypeName:String = ""
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        type            <- map["type"]
        chatLevelName   <- map["chatLevelName"]
        chatLevelIcon   <- map["chatLevelIcon"]
        chatLevel       <- map["chatLevel"]
        iconTypeName    <- map["iconTypeName"]
    }
}
