//
//  RewardhubModel.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//

import UIKit
import ObjectMapper

enum RewardCellType:Int {
    /// 领取新人现金红包
    case getNewerCash = 1
    /// 完成首次提现
    case firstWithdrawal
    /// 完成签到
    case sign
    /// 看视频赚钱
    case makeMoneyByWatching
    /// 点击立得金币
    case getCoinbyClicking
    /// 逛商场赚钱
    case makeMoneyByShop
    /// 每小时发奖励
    case sendRewardEveryHour
    /// 打开消息通知
    case notification
}

struct RewardhubModel: Mappable {

    /// 类型
    var type:RewardCellType = .getNewerCash
    /// 图标
    var imageUrl:String = ""
    /// 标题
    var title:String = ""
    /// 描述
    var desc:String = ""
    /// 按钮文本
    var btnText:String = ""
    /// 按钮状态
    var btnStatus:Int = 0
    
    init() {}  // 👈 手动加一个默认构造函数
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        type            <- map["type"]
        imageUrl        <- map["imageUrl"]
        title           <- map["title"]
        desc            <- map["desc"]
        btnText         <- map["btnText"]
        btnStatus       <- map["btnStatus"]
    }
}
