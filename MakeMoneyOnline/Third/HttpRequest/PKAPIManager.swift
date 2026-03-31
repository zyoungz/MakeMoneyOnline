//
//  RequestManager.swift
//  Pick记账
//
//  Created by Dev on 2023/6/8.
//

import Foundation
import Moya
import Alamofire
import ObjectMapper
import SwiftyJSON
import SwifterSwift

func cpString() -> String? {
    // 计算时区差
    let currentTimeZone = TimeZone.current
    let currentDate = Date()
    let offsetSeconds = currentTimeZone.secondsFromGMT(for: currentDate)
    let offsetHours = offsetSeconds / 3600
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let mutableDictionary = NSMutableDictionary()
//    if (PKDevice.deviceId.isEmpty) {
//        mutableDictionary.setValue(UUID().uuidString, forKey: "deviceId")
//    } else {
//        mutableDictionary.setValue(PKDevice.deviceId, forKey: "deviceId")
//    }
//    mutableDictionary.setValue(PKDevice.idfa, forKey: "idfa")
//    mutableDictionary.setValue(PKDevice.deviceMachine, forKey: "deviceInfo")
//    mutableDictionary.setValue(Int(User.userIdString), forKey: "userId")
//    mutableDictionary.setValue(width.string, forKey: "width")
//    mutableDictionary.setValue(height.string, forKey: "height")
//    mutableDictionary.setValue("0", forKey: "platform")
//    mutableDictionary.setValue("AppStore", forKey: "channel")
//    mutableDictionary.setValue("AppStore", forKey: "brand")
//    mutableDictionary.setValue(PKDevice.deviceId, forKey: "deviceToken")
////    mutableDictionary.setValue(CLUtility.getGeTuiDeviceToken(), forKey: "deviceToken")
//    mutableDictionary.setValue(PKDevice.appVersion, forKey: "appVersion")
//    mutableDictionary.setValue(offsetHours.string, forKey: "timeZone")
//    mutableDictionary.setValue(TDAnalytics.getDeviceId(), forKey: "ssDeviceId")
//    mutableDictionary.setValue(TDAnalytics.getDistinctId(), forKey: "ssDistinctId")
//    mutableDictionary.setValue(Paid().paid, forKey: "PAID")
//    mutableDictionary.setValue(CLUtility.deviceIDFV(), forKey: "idfv")
//    mutableDictionary.setValue(BDASignalManager.getWebviewUA(), forKey: "ua")//tjc 新增传 ua值
//    let traceId = PKEventTrack.traceId()
//    if traceId > 0 {
//        mutableDictionary.setValue(traceId, forKey: "traceId")
//    }
//    mutableDictionary.setValue(CLUtility.getGetuiCID(), forKey: "gtCid")
    return JSON(mutableDictionary).rawString()
}

func getSystemBootTime() -> Date {
    let uptime = ProcessInfo.processInfo.systemUptime
    return Date().addingTimeInterval(-uptime)
}

/// 超时时长
private var requestTimeOut: Double = 30

// 单个模型的成功回调 包括： 模型，网络请求的模型(code,message,data等，具体根据业务来定)
typealias RequestModelSuccessCallback<T:Mappable> = ((T, ResponseModel) -> Void)
// 数组模型的成功回调 包括： 模型数组， 网络请求的模型(code,message,data等，具体根据业务来定)
typealias RequestModelsSuccessCallback<T:Mappable> = (([T], ResponseModel) -> Void)

// 网络请求的回调 包括：网络请求的模型(code,message,data等，具体根据业务来定)
typealias RequestCallback = ((_ response: ResponseModel) -> Void)
// 网络错误的回调
typealias VoidCallback = (() -> Void)
//
typealias BoolCallback = ((_ isSuccess: Bool) -> Void)

/// dataKey一般是 "data"  这里用的知乎daily 的接口 为stories
let responseDataKey = "data"
let responseCodeKey = "code"
let responseStatusKey = "status"
let responseMessageKey = "message"
let responseTimestampKey = "timestamp"
let responseSuccess: Int = 200

/// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let endpointClosure = { (target: TargetType) -> Endpoint in
    /// 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task

    /*
     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
     */
//    let additionalParameters = ["token":"888888"]
//    let defaultEncoding = URLEncoding.default
//    switch target.task {
//        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
//    case .requestPlain:
//        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
//    case .requestParameters(var parameters, let encoding):
//        additionalParameters.forEach { parameters[$0.key] = $0.value }
//        task = .requestParameters(parameters: parameters, encoding: encoding)
//    default:
//        break
//    }
    /*
     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     */

    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    
    let encryptString = PKAPICryptor.encrypt(string: cpString() ?? "");
    endpoint = endpoint.adding(newHTTPHeaderFields: ["cp": encryptString ?? "", "appid": RewardhubManager.shared.appId])
    
    // 针对于某个具体的业务模块来做接口配置. 每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    if let apiTarget = target as? MultiTarget,
       let target = apiTarget.target as? PKAPI {
        switch target {
        case .userInfo:
            requestTimeOut = 30
            return endpoint
        default:
            requestTimeOut = 30
            return endpoint
        }
    }
    
    return endpoint
}

/// 网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            DLog_kit("请求的url：\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "发送参数：" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            DLog_kit("请求的url：\(request.url!)" + "\(String(describing: request.httpMethod))")
        }

        if let header = request.allHTTPHeaderFields {
            DLog_kit("请求头内容：\(header)")
        }

        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
     publicKeys: ServerTrustPolicy.publicKeysInBundle(),
     validateCertificateChain: true,
     validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Session看实际需求。HTTPS就要手动实现Session了
// private func defaultAlamofireSession() -> Session {
//
////     let configuration = Alamofire.Session.default
//
//     let configuration = URLSessionConfiguration.default
//     configuration.headers = .default
//
//     let policies: [String: ServerTrustEvaluating] = ["demo.mXXme.com": DisabledTrustEvaluator()]
//
//     let session = Session(configuration: configuration,
//                           startRequestsImmediately: false,
//                           serverTrustManager: ServerTrustManager(evaluators: policies))
//
//    return session
// }

/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
/// 但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    BJDLog("networkPlugin \(changeType)")
    let multiTarget = targetType as? MultiTarget
    let target = multiTarget?.target as? PKAPI
    // targetType 是当前请求的基本信息
    switch changeType {
    case .began:
        BJDLog("开始请求网络")
        if target?.showLoading == true {
//            showLoadingHUD()
        }
    case .ended:
        if target?.showLoading == true {
//            dismissLoadingHUD()
        }
        BJDLog("结束")
    }
}
/// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
/// 网络请求发送的核心初始化方法，创建网络请求对象
fileprivate let Provider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

/// 网络请求，当模型为dict类型
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - modelType: 模型
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetWorkRequest<T: Mappable>(_ target: TargetType, needShowFailAlert: Bool = true, modelType: T.Type, successCallback:@escaping RequestModelSuccessCallback<T>, failureCallback: RequestCallback? = nil) -> Cancellable? {
//    return NetWorkRequest(target, showFailAlert: showFailAlert, modelType: modelType, successCallback: successCallback, failureCallback: nil)
    return NetWorkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: { (responseModel) in
        
        if let model = T(JSONString: responseModel.data) {
            successCallback(model, responseModel)
        } else {
            errorHandler(code: responseModel.code , message: "解析失败", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
        
    }, failureCallback: failureCallback)
}

/// 网络请求，当模型为dict类型
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - modelType: 模型
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetWorkRequest<T: Mappable>(_ target: TargetType, needShowFailAlert: Bool = true, modelType: [T].Type, successCallback:@escaping RequestModelsSuccessCallback<T>, failureCallback: RequestCallback? = nil) -> Cancellable? {
    return NetWorkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: { (responseModel) in
        
        if let model = [T](JSONString: responseModel.data) {
            successCallback(model, responseModel)
        } else {
            errorHandler(code: responseModel.code , message: "解析失败", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
        
    }, failureCallback: failureCallback)
}


/// 网络请求的基础方法
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true, successCallback:@escaping RequestCallback, failureCallback: RequestCallback? = nil) -> Cancellable? {
    
    // 先判断网络是否有链接 没有的话直接返回--代码略
    if !UIDevice.isNetworkConnect {
        // code = 9999 代表无网络  这里根据具体业务来自定义
        errorHandler(code: 9999, message: "网络似乎出现了问题", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        return nil
    }
    
    return Provider.request(MultiTarget(target)) { result in
        switch result {
        case let .success(response):
            do {
                let jsonData = try JSON(data: response.data)
                
                // 检查响应并调用失败回调
                guard validateRepsonse(response: jsonData.dictionary, needShowFailAlert: needShowFailAlert, failure: failureCallback) else {
                    return
                }
                
//                DLog("服务器返回数据response = \(jsonData)")
                
                let respModel = ResponseModel()
                respModel.status = jsonData[responseStatusKey].int ?? 0
                respModel.code = jsonData[responseCodeKey].int ?? 0
                respModel.timestamp = jsonData[responseTimestampKey].int64 ?? 0
                respModel.message = jsonData[responseMessageKey].stringValue
                
                if respModel.status == responseSuccess {
                    if let dataString = jsonData[responseDataKey].string,
                       let decryptString = PKAPICryptor.decrypt(string: dataString) {
                        respModel.data = decryptString
                        DLog_kit("服务器返回数据明文：\(decryptString)")
                    }
                    
                    
                    successCallback(respModel)
                } else {
                    if (respModel.status == 2001 || respModel.status == 2002) {
                        /// 这里单独处理
                        errorHandler(code: respModel.status, message: respModel.message, needShowFailAlert: needShowFailAlert, failure: failureCallback)
                        return
                    }
                    errorHandler(code: respModel.code, message: respModel.message, needShowFailAlert: needShowFailAlert, failure: failureCallback)
                    return
                }
                
            } catch {
                // code = 10000 代表JSON解析失败  这里根据具体业务来自定义
                errorHandler(code: 10000, message: String(data: response.data, encoding: String.Encoding.utf8) ?? "网络请求错误", needShowFailAlert: needShowFailAlert, failure: failureCallback)
            }
        case let .failure(error as NSError):
            errorHandler(code: error.code, message: "网络错误，请重试", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
    }
}


/// 预判断后台返回的数据有效性 如通过Code码来确定数据完整性等  根据具体的业务情况来判断  有需要自己可以打开注释
/// - Parameters:
///   - response: 后台返回的数据
///   - showFailAlet: 是否显示失败的弹框
///   - failure: 失败的回调
/// - Returns: 数据是否有效
private func validateRepsonse(response: [String: JSON]?, needShowFailAlert: Bool, failure: RequestCallback?) -> Bool {
    /**
    var errorMessage: String = ""
    if response != nil {
        if !response!.keys.contains(codeKey) {
            errorMessage = "返回值不匹配：缺少状态码"
        } else if response![codeKey]!.int == 500 {
            errorMessage = "服务器开小差了"
        }
    } else {
        errorMessage = "服务器数据开小差了"
    }

    if errorMessage.count > 0 {
        var code: Int = 999
        if let codeNum = response?[codeKey]?.int {
            code = codeNum
        }
        if let msg = response?[messageKey]?.stringValue {
            errorMessage = msg
        }
        errorHandler(code: code, message: errorMessage, showFailAlet: showFailAlet, failure: failure)
        return false
    }
     */

    return true
}

/// 错误处理
/// - Parameters:
///   - code: code码
///   - message: 错误消息
///   - needShowFailAlert: 是否显示网络请求失败的弹框
///   - failure: 网络请求失败的回调
private func errorHandler(code: Int, message: String, needShowFailAlert: Bool, failure: RequestCallback?) {
    BJDLog("发生错误：\(code)--\(message)")
    var newMessage:String = message
    if (message.isEmpty) {
        newMessage = "网络错误，请重试"
    }
    
    if needShowFailAlert {
        BJDLog("弹出错误信息弹框\(message)")
        
        HUDManager.shared.showErrorMsg(newMessage)
    }
    
    guard let _ = failure else {
        return
    }
    
    let model = ResponseModel()
    model.code = code
    model.message = newMessage
    
    failure?(model)
}

class ResponseModel {
    var data: String = ""
    var message: String = ""
    var code: Int = 0
    var status: Int = 0
    var timestamp: Int64 = Date().secondValue
    
    lazy var dataDict:JSON? = {
        guard let utf8Data = data.data(using: .utf8) else {
            return nil
        }
        
        return try? JSON(data: utf8Data)
    }()
    
    var isSuccess: Bool {
        status == responseSuccess
    }
    
    var displayMsg: String {
        message
    }
}


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用计算型属性是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
extension UIDevice {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }
}


/**
 下面的三个方法是对于 Swift5.5 Concurrency的支持  目前(2022.02.18)一般项目中还用不到。 可自行删除
 */
@available(iOS 13.0, *)
@discardableResult
func NetWorkRequest<T: Mappable>(_ target: TargetType, needShowFailAlert: Bool = true, modelType: T.Type) async -> (model:T?,response: ResponseModel) {
    await withCheckedContinuation({ continuation in
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, modelType: modelType) { model, responseModel in
            continuation.resume(returning: (model, responseModel))
        } failureCallback: { responseModel in
            continuation.resume(returning: (nil, responseModel))
        }
    })
}

@available(iOS 13.0, *)
@discardableResult
func NetWorkRequest<T: Mappable>(_ target: TargetType, needShowFailAlert: Bool = true, modelType: [T].Type) async -> (model:[T]?,response: ResponseModel) {
    await withCheckedContinuation({ continuation in
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, modelType: modelType) { model, responseModel in
            continuation.resume(returning: (model, responseModel))
        } failureCallback: { responseModel in
            continuation.resume(returning: (nil, responseModel))
        }
    })
}

@available(iOS 13.0, *)
@discardableResult
func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true) async -> ResponseModel {
    await withCheckedContinuation({ continuation in
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: {(responseModel) in
            continuation.resume(returning: responseModel)
        }, failureCallback:{(responseModel) in
            continuation.resume(returning: responseModel)
        })
    })
}



