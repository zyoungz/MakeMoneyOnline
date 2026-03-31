//
//  PickService.swift
//  Pick记账
//
//  Created by Dev on 2023/6/8.
//

import Foundation
import Moya
import Alamofire

enum PKAPI {
    case accountActivate(parameters:[String:Any])
    /// 发送验证码
    case accountSendValidCode(parameters:[String:Any])
    /// 手机号登录
    case accountLoginByPhone(parameters:[String:Any])
    case accountLoginOpen(parameters:[String:Any])
    case accountBind(parameters:[String:Any])
    case accountBindPhone(parameters:[String:Any])
    case accountClearUser
    
    case assetsGetTypes
    case assetsGetTypeItem(parameters:[String:Any])
    case assetsGet
    case assetsAdd(parameters:[String:Any])
    case assetsUpdate(parameters:[String:Any])
    case assetsDelete(parameters:[String:Any])
    case assetsUpdateStatus(parameters:[String:Any])

    case billAddOrUpdate(parameters:[String:Any])
    case billDelete(parameters:[String:Any])
    case bills(parameters:[String:Any])
    
    case fixedBillAddOrUpdate(parameters:[String:Any])
    case fixedBills
    case fixedBillDelete(parameters:[String:Any])
    case billsByFixedId(parameters:[String:Any])
    case fixedBillStatusUpdate(parameters:[String:Any])
    
    case billBooks
    case billBookTemplates
    case billBookAdd(parameters:[String:Any])
    case billBookUpdate(parameters:[String:Any])
    case billBookDelete(parameters:[String:Any])
    
    case config(parameters:[String:Any])
    
    case keyWordMatchingRule
    
    case orderConfigs
    case orderRechargeDiscountConfig
    case orderCreate(parameters:[String:Any])
    case orderCheckStatus(parameters:[String:Any])
    case orderAppleSuccess(parameters:[String:Any])
    case orderAppleRestore(parameters: [String: Any])
    
    case uploadImages(parameters:[String:Any], data:Data)
    case uploadImg(parameters:[String:Any])
    case uploadCallback
    /// 获取用户信息
    case userInfo
    case userUpdateNickName(parameters:[String:Any])
    case userUpdateAvatar(parameters:[String:Any])
    
    case userCardAddOrUpdate(parameters:[String:Any])
    case userCardDelete(parameters:[String:Any])
    case userCards
    case userCardUpdateSort(parameters:[String:Any])
    case userRefreshToken(parameters:[String:Any])
    
    case userCates
    case userCateIcons
    case userCateAdd(parameters:[String:Any])
    case userCateUpdate(parameters:[String:Any])
    case userCateDelete(parameters:[String:Any])
    case userCateUpdateSort(parameters:[String:Any])
    
    case userSettingAddOrUpdate(parameters:[String:Any])
    case userSetting
    case initSSOldUserInfo
    case operationDialog
    
    case reimbursements
    case reimbursementAdd(parameters:[String:Any])
    case reimbursementDelete(parameters:[String:Any])
    /// 修改背景图片(AI聊天页)
    case updateChatBackGroundImg(parameters:[String:Any])
    /// 获取用户角色信息(AI聊天页)
    case getUserCharacter
    /// 获取角色列表(AI聊天页)
    case getCharacterList
    /// 获取角色称呼列表(AI聊天页)
    case getNickNameList
    /// 获取关系列表(AI聊天页)
    case getRelationsList
    /// 自定义角色(AI聊天页)
    case addOrUpdateChatCharacter(parameters:[String:Any])
    /// 自定义称呼(AI聊天页)
    case addOrUpdateChatNickName(parameters:[String:Any])
    /// 自定义关系(AI聊天页)
    case addOrUpdateChatRelation(parameters:[String:Any])
    /// 添加或者更新用户的角色「注：整个模块的添加或修改」(AI聊天页)
    case addOrUpdateUserChatCharacter(parameters:[String:Any])
    /// 修改聊天头像(AI聊天页)
    case updateChatUserCharacterAvtar(parameters:[String:Any])
    /// AI聊天
    case aiChat(parameters:[String:Any])
    /// 问候语(AI聊天页) 「注：已被v2替换」
    case chatGreetingsV2
    /// 提取账单 返回账单数据
    case extractBill(parameters:[String:Any])
    /// 获取key
    case getApiKey
    /// config
    case getApiConfig
    /// 获取账单分析记录
    case getBillAnalysisRecords
    /// 删除分析记录
    case DeleteBillAnalysisById(parameters:[String:Any])
    /// 账单分析
    case getBillAnalysisByDate(parameters:[String:Any])
    /// 获取聊天等级
    case getChatLevels
    /// 修改连续聊天天数
    case updateChatLevel(parameters:[String:Any])
    /// 修改聊天等级icon
    case UpdateChatLevelIcon(parameters:[String:Any])
    /// 获取文本转语音文件的token
    case getASRKey
    
    /// 小组件
    case budgetGet(parameters:[String:Any])
    case budgetDelete(parameters:[String:Any])
    case budgetAddOrUpdate(parameters:[String:Any])
    case budgetSetting(parameters:[String:Any])
    
    /// 获取语音列表
    case getDoubaoVoiceList
    /// 修改语音
    case updateVoiceType(parameters:[String:Any])
    
    /// 获取视频生成页面配置
    case getVideoCreateConfig
    /// 获取视频生成
    case imageToVideo(parameters:[String:Any])
    /// 获取视频生成结果
    case imageToVideoResult(parameters:[String:Any])
    /// 视频生成结果删除
    case imageToVideoDelete(parameters:[String:Any])
    /// 获取用户奶茶代付信息
    case getMilkTeaGift(parameters:[String:Any])
    /// 放弃奶茶
    case giveUpMilkTeaGift(parameters:[String:Any])
    /// 复制账本
    case billBookCopy(parameters:[String:Any])
    /// 获取用户的植物标本
    case getUserSpecimens
    
    /// 获取所有预设角色信息
    case getPresetsCharacter
    /// 获取app升级信息
    case getUpdateRemind
    /// 切换角色问候语
    case switchRoleGreetings
    /// 问候语 最新 2.1.2需求
    case greetingNew(parameters:[String:Any])
}


extension PKAPI: TargetType {
    var sampleData: Data {
        return Data()
    }
    
    
    /// The target's base `URL`.
    var baseURL: URL {
        switch self {
        case .config:
            if RewardhubManager.shared.isTest {
                return URL(string: "https://meow-config-test.aiyouaiyou.cn")!
            } else {
                return URL(string: "http://meow-config.aiyouaiyou.cn")!
            }
        default:
            if RewardhubManager.shared.isTest {
                return URL(string: "http://tinybook-test-api.wunitu.com")!
            } else {
                return URL(string: "https://tinybook-api.wunitu.com")!
            }
        }

    }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .accountActivate:
            return "/api/account/ActivateV2"
        case .accountSendValidCode:
            /// 发送验证码
            return "/api/Account/SendValidCode"
        case .accountLoginByPhone:
            /// 手机号登录
            return "/api/Account/LoginByPhone"
        case .accountLoginOpen:
            return "/api/Account/LoginOpen"
        case .accountBind:
            return "/api/Account/Bind"
        case .accountBindPhone:
            return "/api/Account/BindPhone"
        case .accountClearUser:
            return "/api/Account/ClearUser"
            
        case .assetsGetTypes:
            return "/api/Assets/GetTypes"
        case .assetsGetTypeItem:
            return "/api/Assets/GetTypeItem"
        case .assetsGet:
            return "/api/Assets/Get"
        case .assetsAdd:
            return "/api/Assets/Add"
        case .assetsUpdate:
            return "/api/Assets/Update"
        case .assetsDelete:
            return "/api/Assets/Delete"
        case .assetsUpdateStatus:
            return "/api/Assets/UpdateStatus"

        case .billAddOrUpdate:
            return "/api/Bill/AddOrUpdate"
        case .billDelete:
            return "/api/Bill/Delete"
        case .bills:
            return "/api/Bill/Get"
            
        case .billBooks:
            return "/api/BillBooks/Get"
        case .billBookTemplates:
            return "/api/BillBooks/GetTemplates"
        case .billBookAdd:
            return "/api/BillBooks/Add"
        case .billBookUpdate:
            return "/api/BillBooks/Update"
        case .billBookDelete:
            return "/api/BillBooks/Delete"
        case .fixedBillAddOrUpdate:
            return "/api/Bill/AddOrUpdateFiexdBill"
        case .fixedBills:
            return "/api/Bill/GetFiexdList"
        case .fixedBillDelete:
            return "/api/Bill/DeleteFixed"
        case .fixedBillStatusUpdate:
            return "/api/Bill/UpdateFixedBillStatus"
        case .billsByFixedId:
            return "/api/Bill/GetBillByFixedId"
            
        case .config:
            return "/api/Config/GetV2"
            
        case .keyWordMatchingRule:
            return "/api/KeyWordMatchingRule/Get"
        
        case .orderConfigs:
            return "/api/Order/Configs"
        case .orderRechargeDiscountConfig:
            return "/api/Order/GetRechargeDiscountConfig"
        case .orderCreate:
            return "/api/Order/CreateOrder"
        case .orderCheckStatus:
            return "/api/Order/CheckStatus"
        case .orderAppleSuccess:
            return "/api/Order/AppleSuccess"
        case .orderAppleRestore:
            return "/api/Order/RenewBuySuccess"
            
        case .uploadImages:
            return "/api/Upload/UploadImages"
        case .uploadImg:
            return "/api/Upload/UploadImg"
        case .uploadCallback:
            return "/api/Upload/UploadCallback"
        
        case .userInfo:
            /// 获取用户信息
            return "/api/User/UserInfo"
        case .userUpdateNickName:
            return "/api/User/UpdateNickName"
        case .userUpdateAvatar:
            return "/api/User/UpdateAvatar"
        
        case .userCardAddOrUpdate:
            return "/api/UserCard/AddOrUpdate"
        case .userCardDelete:
            return "/api/UserCard/Delete"
        case .userCards:
            return "/api/UserCard/Get"
        case .userCardUpdateSort:
            return "/api/UserCard/UpdateSort"
//        case .userCardUpdateSort:
//            return "/api/User/RefreshToken"
            
        case .userCates:
            return "/api/UserCate/Get"
        case .userCateIcons:
            return "/api/UserCate/GetIcon"
        case .userCateAdd:
            return "/api/UserCate/Add"
        case .userCateUpdate:
            return "/api/UserCate/Update"
        case .userCateDelete:
            return "/api/UserCate/Delete"
        case .userCateUpdateSort:
            return "/api/UserCate/UpdateSort"
        case .userRefreshToken:
            return "/api/User/RefreshToken"
            
        case .userSettingAddOrUpdate:
            return "/api/UserSetting/AddOrUpdate"
        case .userSetting:
            return "/api/UserSetting/Get"
        case .initSSOldUserInfo:
            return "/api/User/InitSSOldUserInfo"
        case .operationDialog:
            return "/api/Operation/OperationDialog"
            
        case .reimbursements:
            return "/api/Reimbursement/Get"
        case .reimbursementAdd:
            return "/api/Reimbursement/Add"
        case .reimbursementDelete:
            return "/api/Reimbursement/Delete"
        case .updateChatBackGroundImg:
            /// 修改聊天背景图片(AI聊天页)
            return "/api/Character/UpdateChatBackGroundImg"
        case .getUserCharacter:
            /// 获取用户角色信息(AI聊天页)
            return "/api/Character/GetUserCharacter"
        case .getCharacterList:
            /// 获取角色列表(AI聊天页)
            return "/api/Character/GetCharacter"
        case .getNickNameList:
            /// 获取角色称呼列表(AI聊天页)
            return "/api/Character/GetNickNames"
        case .getRelationsList:
            /// 获取关系列表(AI聊天页)
            return "/api/Character/GetRelations"
        case .addOrUpdateChatCharacter:
            /// 自定义角色(AI聊天页)
            return "/api/Character/AddOrUpdateCharacter"
        case .addOrUpdateChatNickName:
            /// 自定义称呼(AI聊天页)
            return "/api/Character/AddOrUpdateNickName"
        case .addOrUpdateChatRelation:
            /// 自定义关系(AI聊天页)
            return "/api/Character/AddOrUpdateRelation"
        case .addOrUpdateUserChatCharacter:
            /// 添加或者更新用户的角色「注：整个模块的添加或修改」(AI聊天页)
            return "/api/Character/AddOrUpdateUserCharacter"
        case .updateChatUserCharacterAvtar:
            /// 修改聊天头像(AI聊天页)
            return "/api/Character/UpdateUserCharacterAvtar"
        case .aiChat:
            /// AI聊天
            return "/api/Character/ChatV2"
        case .chatGreetingsV2:
            /// 问候语(AI聊天页)
            return "/api/Character/GreetingV2"
        case .extractBill:
            /// AI聊天-账单
            return "/api/Character/ExtractBillV2"
        case .getApiKey:
            /// AI聊天-获取key
            return "/api/Character/GetApiKey"
        case .getApiConfig:
            /// config
            return "/api/Config/Get"
        case .getBillAnalysisRecords:
            /// 获取账单分析记录
            return "/api/BillAnalysis/BillAnalysisRecords"
        case .DeleteBillAnalysisById:
            /// 删除分析记录
            return "/api/BillAnalysis/DeleteBillAnalysisById"
        case .getBillAnalysisByDate:
            /// 删除分析记录
            return "/api/Character/AIBillAnalysis"
        case .getChatLevels:
            /// 获取聊天等级
            return "/api/Character/GetChatLevels"
        case .updateChatLevel:
            /// 修改连续聊天天数
            return "/api/Character/UpdateChatLevel"
        case .UpdateChatLevelIcon:
            /// 修改聊天等级icon
            return "/api/Character/UpdateChatLevelIcon"
        case .getASRKey:
            /// 获取文本转语音文件的token
            return "/api/Character/GetASRKey"
        case .budgetGet:
            /// 小组件
            return "/api/UserBudget/Get"
        case .budgetDelete:
            return "/api/UserBudget/Delete"
        case .budgetAddOrUpdate:
            return "/api/UserBudget/AddOrUpdate"
        case .budgetSetting:
            return "/api/UserBudget/UpdateUserBudgetSetting"
        case .getDoubaoVoiceList:
            return "/api/DoubaoTTS/GetVoiceList"
        case .updateVoiceType:
            return "/api/Character/v2/UpdateVoiceType"
        case .getVideoCreateConfig:
            return "/api/VideoGeneration/VideoGenerationHistory"
        case .imageToVideo:
            return "/api/VideoGeneration/VideoTask"
        case .imageToVideoResult:
            return "/api/VideoGeneration/VideoTaskDetail"
        case .imageToVideoDelete:
            return "/api/VideoGeneration/VideoTaskDelete"
        case .getMilkTeaGift: /// 获取用户奶茶代付信息
            return "/api/CharacterMilkTeaGift/GetCharacterMilkTeaGift"
        case .giveUpMilkTeaGift: /// 放弃奶茶
            return "/api/CharacterMilkTeaGift/GiveUpGift"
        case .billBookCopy: /// 复制账本
            return "/api/BillBooks/CopyBookCates"
        case .getUserSpecimens: /// 用户的植物标本
            return "/api/UserBudget/GetUserSpecimens"
        case .getPresetsCharacter:  /// 获取所有预设角色信息
            return "/api/PresetsCharacter/GetAll"
        case .getUpdateRemind: /// 更新提醒
            return "/api/Operation/GetUpdateRemind"
        case .switchRoleGreetings: /// 切换角色
            return "/api/Character/SwitchRolesGreetings"
        case .greetingNew: /// 问候语最新 2.1.2需求
            return "/api/Character/GreetingNew"
        }
    }
    /// 是否需要框架直接加载loading, 单独请求一个接口就可以处理结果的一般都为true
    var showLoading: Bool {
        switch self {
        case .accountActivate, .userRefreshToken:
            return false
        case .userInfo:
            /// 获取用户信息
            return false
        case .orderRechargeDiscountConfig, .orderAppleSuccess, .orderAppleRestore, .orderCreate:
            return false
        case .getApiKey:
            return false
        case .config:
            return false
        case .keyWordMatchingRule:
            return false
        case .userCateUpdateSort:
            return false
        case .uploadImg:
            return false
        case .operationDialog:
            return false
        case .reimbursementDelete:
            return false
        case .getApiConfig:
            return false
        case .DeleteBillAnalysisById:
            return false
        case .getASRKey:
            return false
        case .getMilkTeaGift:
            return false
        case .giveUpMilkTeaGift:
            return false
        case .greetingNew:
            return false
        default:
            return true
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .accountClearUser, .assetsGet, .assetsGetTypes, .billBooks, .billBookTemplates, .keyWordMatchingRule, .userInfo, .userCards, .userCates, .userCateIcons, .userSetting, .operationDialog, .reimbursements, .getUserCharacter, .getCharacterList, .getNickNameList, .getRelationsList, .getApiKey, .getBillAnalysisRecords, .getChatLevels, .chatGreetingsV2, .getDoubaoVoiceList, .getASRKey, .getVideoCreateConfig, .getUserSpecimens , .getPresetsCharacter, .getUpdateRemind, .switchRoleGreetings:
            return .get
        default:
            return .post
        }
    }

    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case .accountClearUser, .assetsGet, .assetsGetTypes, .billBooks, .billBookTemplates, .keyWordMatchingRule, .orderConfigs, .orderRechargeDiscountConfig, .uploadCallback, .userInfo, .userCards, .userCates, .userCateIcons, .userSetting, .operationDialog, .reimbursements, .initSSOldUserInfo, .fixedBills, .getUserCharacter, .getCharacterList, .getNickNameList, .getRelationsList, .chatGreetingsV2, .getApiKey, .getApiConfig, .getBillAnalysisRecords, .getChatLevels, .getDoubaoVoiceList, .getASRKey, .getVideoCreateConfig, .getUserSpecimens, .getPresetsCharacter, .getUpdateRemind, .switchRoleGreetings:
            return .requestPlain
        case let.accountSendValidCode(parameters):
            /// 发送验证码
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .accountLoginByPhone(parameters: parameters):
            /// 手机号登录
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .accountLoginOpen(parameters: parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .accountBind(parameters: parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .accountBindPhone(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .assetsGetTypeItem(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .assetsAdd(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .assetsUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .assetsDelete(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .assetsUpdateStatus(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .billAddOrUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .billDelete(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .bills(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .billBookAdd(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .billBookUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .billBookDelete(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .fixedBillAddOrUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .fixedBillStatusUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .fixedBillDelete(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .billsByFixedId(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .orderCreate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .orderCheckStatus(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .orderAppleSuccess(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .orderAppleRestore(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .uploadImages(parameters: parameters, data:data):
            return .requestData(data)
        case let .uploadImg(parameters:parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        
        case let .userUpdateNickName(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userUpdateAvatar(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userCardAddOrUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userCardDelete(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userCardUpdateSort(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        
        case let .userCateAdd(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userCateUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userCateDelete(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userCateUpdateSort(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userSettingAddOrUpdate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .userRefreshToken(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .accountActivate(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case let .reimbursementAdd(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .reimbursementDelete(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .config(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .updateChatBackGroundImg(parameters):
            /// 修改聊天背景图片(AI聊天页)
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .addOrUpdateChatCharacter(parameters):
            /// 自定义角色(AI聊天页)
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .addOrUpdateChatNickName(parameters):
            /// 自定义称呼(AI聊天页)
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .addOrUpdateChatRelation(parameters):
            /// 自定义关系(AI聊天页)
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .addOrUpdateUserChatCharacter(parameters):
            /// 添加或者更新用户的角色「注：整个模块的添加或修改」(AI聊天页)
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .updateChatUserCharacterAvtar(parameters):
            /// 修改聊天头像(AI聊天页)
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .aiChat(parameters):
            /// AI聊天
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .extractBill(parameters):
            /// 提取账单 返回账单数据
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .DeleteBillAnalysisById(parameters):
            /// 删除分析记录
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .getBillAnalysisByDate(parameters):
            /// 删除分析记录
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .updateChatLevel(parameters):
            /// 修改连续聊天天数
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .UpdateChatLevelIcon(parameters):
            /// 修改聊天等级icon
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .giveUpMilkTeaGift(parameters):
            /// 放弃奶茶
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .getMilkTeaGift(parameters):
            /// 获取奶茶数据
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .billBookCopy(parameters): /// 账本复制
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        case let .greetingNew(parameters): /// 问候语最新 2.1.2需求
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            /// 小组件
        case let .budgetGet(parameters),
            let .budgetDelete(parameters),
            let .budgetAddOrUpdate(parameters),
            let .budgetSetting(parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case .updateVoiceType(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case .imageToVideo(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case .imageToVideoResult(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
            
        case .imageToVideoDelete(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: PKAPIParameterEncoding.default)
        }
    }

    /// The headers to be used in the request.
    var headers: [String: String]? {
//        return ["Content-type": "multipart/form-data","GtCid":CLUtility.getGetuiCID()]
        return ["Content-type": "multipart/form-data","GtCid":RewardhubManager.shared.getuiCID]
    }
}
