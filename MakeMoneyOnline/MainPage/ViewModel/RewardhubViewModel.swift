//
//  RewardhubViewModel.swift
//  MakeMoneyOnline
//
//  Created by 向日葵 on 2026/3/31.
//

import UIKit
import SwifterSwift

class RewardhubViewModel: NSObject {

    
    var sectionList:[RewardhubSectionModel] = []
    
    func updateSectionList() {
        self.sectionList.removeAll()
        
        /// 福利中心
        var centerModel = RewardhubSectionModel()
        centerModel.type = .rewardCenter
        centerModel.list = []
        self.sectionList.append(centerModel)
        
        /// 新人福利
        var newerModel = RewardhubSectionModel()
        newerModel.type = .newerReward
        newerModel.list = self.buildCellList(type: .newerReward)
        self.sectionList.append(newerModel)
        
        /// 日常福利
        var normalRewardModel = RewardhubSectionModel()
        normalRewardModel.type = .normalReward
        normalRewardModel.list = self.buildCellList(type: .normalReward)
        self.sectionList.append(normalRewardModel)
    }
    
        
}


extension RewardhubViewModel {
    /// 生成数组
    private func buildCellList(type:RewardhubType = .newerReward) -> [RewardhubModel] {
        var list:[RewardhubModel] = []
        
        if type == .newerReward {
            /// 新人现金红包包
            var getCashModel      = RewardhubModel()
            getCashModel.type     = .getNewerCash
            getCashModel.title    = "领取新人现金红包"
            getCashModel.desc     = "最高可得68元，可提现！"
            getCashModel.btnText  = "去领取"
            list.appendIfNonNil(getCashModel)
            
            /// 完成首次提现
            var withdrawModel     = RewardhubModel()
            withdrawModel.type    = .firstWithdrawal
            withdrawModel.title   = "领取新人现金红包"
            withdrawModel.desc    = "最高可得68元，可提现！"
            withdrawModel.btnText = "去领取"
            list.appendIfNonNil(withdrawModel)
            
            return list
        } else {
            /// 日常福利
            
            /// 完成每日签到
            var signModel      = RewardhubModel()
            signModel.type     = .sign
            signModel.title    = "完成每日签到"
            signModel.desc     = "连续签到7天获得神秘奖励"
            signModel.btnText  = "去签到"
            list.appendIfNonNil(signModel)
            
            
            /// 看视频赚钱
            var videoModel      = RewardhubModel()
            videoModel.type     = .makeMoneyByWatching
            videoModel.title    = "看视频赚钱"
            videoModel.desc     = "达成以下数量即可点击领取奖励"
            videoModel.btnText  = "去签到"
            list.appendIfNonNil(videoModel)
            
            
            return list
        }
        
        
    }
    
}
