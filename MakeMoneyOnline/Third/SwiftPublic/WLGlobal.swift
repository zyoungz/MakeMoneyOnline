//
//  WLGlobal.swift
//  Environments
//
//  Created by zhou Last on 2019/7/31.
//  Copyright © 2019 zhou Last. All rights reserved.
//

import UIKit

enum AppConstants {
    
    //MARK: - 是否是测试环境
    static let NetDebug: Bool = true
    
    //MARK: - 日志输出
    #if DEVELOPMENT
    static let LogDebug: Bool = true
    #else
    static let LogDebug: Bool = false
    #endif
    
    //MARK: - 随机颜色
    static let ColorDebug: Bool = true
    //网络请求超时时间
    static let QuestTimeout: Double = 10
    //倒计时
    static let KTimeoutCounter: Int = 60
    //存储-用户信息-键
    static let CurrentLoginUserInfo: String = ""
    static let KeyChainService: String = ""
    //倒计时通知
    static let NOTIFICATION_TIME_CELL: String = "NotificationTimeCell"
    //存储-网络请求token-键
    static let NetworkToken: String = "NetworkToken"
    static let versionCode:String = "107"
    //MARK: - 协议（http/https）（含“//”后缀，不能为空）
//    enum AppURLProtocol {
//    }
    
#if DEBUG
//    static let SERVER_URL = "http://192.168.3.22:8085"
//     static let SERVER_URL = "http://192.168.43.246:8084"
//    static let SERVER_URL = "http://api.dynamicwave.com.cn"
    
//    static let ipaddr = UserDefaults.standard.string(forKey: AccountInfo.ipInterfaceAddr)
    //    static let SERVER_URL = (ipaddr != nil && ipaddr?.count != 0) ? ipaddr : "http://192.168.3.22:8081"
    /// Description
    static let SERVER_URL = "http://tinybook-test-api.wunitu.com/api/"
    static let API_TOKEN = "开发环境"
    static let DomainHost = "项目测试域名"
    static let AppURLPort = "测试端口号"
    static let isPushProduction: Bool = false
    #else
    static let SERVER_URL = "http://tinybook-test-api.wunitu.com/swagger/v1"
    static let API_TOKEN = "生产环境"
    static let DomainHost = "项目生产域名"
    static let AppURLPort = "生产端口号"
    static let isPushProduction: Bool = true
    #endif

    //MARK: - 接口地址
    enum AppInterfaceAddress {
        //登录
        static let Login = "接口地址路由"
    }
    
    //MARK: - APP的appId
    public enum AppId {
        static let wexinAppId = "wxce6452ababd905dd"
        static let UMeng = "三方appId"
        static let BugleAppId = "40c0a0f3dc"
        //......
    }
    
    //MARK: - APP的key
    public enum AppKey {
        static let weixinKey = "12528e71ee833ab64de447bc36f41620"
        static let UMeng = "三方Key"
        static let GaodeKey = "d4f6e89bc8a63f22b7129d9de2c1f70b"
        static let BugleKey = "a1b020cd-4a06-4c3c-a1f3-652ad4661d54"
        static let jPushKey = "4ceb525381491ff50d81861d"
        static let aliPushKey = "28096113"
        static let mobKey = "321f89d400118"
        static let rsaPingPublicKey = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzorzRpOIdEW6rPiYcp9/WnPRp7UF8sp9lq/iA6CyUGWrq4s0VZ+g1x/y8DITe2JkmSbytlE9eePxl4aQ55PUq1H+u2eOO+qyQIh0ZQyI7x9byjIHAV0QHe0FiRN9MvjRO55AqgyLm84mNvjBG/jV/VovVcL3Qv+lBK5e/7E+2CQIDAQAB\n-----END PUBLIC KEY-----"
        //......
    }
    
    //MARK: - APP的密钥
    enum AppSecret {
        static let UMeng = "三方密钥"
        static let aliSecret = "26a3e11b720c8766c0e10f07f2d0c513"
        static let mobSecret = "83df876aa863f80408b22337b7025736"

        //......
    }
    
    //MARK: - 错误类型
    enum ErrorType {
        static let ServerError = "服务器异常"
    }
}

//IphoneX系列
var iPhoneXSeries: Bool {    //= UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896
    get {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window {
                return window?.safeAreaInsets.bottom ?? 0 > CGFloat(0)
            }
            return false
        }
        return false
    }
}


//MARK: - frame 相关
// MARK: ============================================================================
// MARK: 屏幕尺寸
public enum AppFrame {
    static let ScreenBounds = UIScreen.main.bounds
    /// 屏幕宽度
    static let ScreenWidth = ScreenBounds.size.width
    /// 屏幕高度
    static let ScreenHeight = ScreenBounds.size.height
    /// iPhone4(非必要)
    static let iPhone4 = ScreenHeight  < 568 ? true : false
    /// iPhone 5
    static let iPhone5 = ScreenHeight  == 568 ? true : false
    /// iPhone 6
    static let iPhone6 = ScreenHeight  == 667 ? true : false
    /// iphone 6P
    static let iPhone6P = ScreenHeight == 736 ? true : false
    /// iphone X
    static let iPhoneX = ScreenHeight == 812 ? true : false
    static let iPhone12Pro = ScreenHeight == 844 ? true : false
    /// 特指iphoneX 不含 iphoneXR
    /// 特指iphoneXR 不含 iphoneX
    static let iPhoneXR = ScreenHeight == 896 ? true : false
    // navigationBarHeight
    static let kNavigationBarHeight : CGFloat = iPhoneX ? 88 : 64
    /// tabBarHeight(系统tabbar高度)
    static let kTabBarHeight : CGFloat = CGFloat.systemTabBarHeight
    /** 如果是iPhoneX按照Plus 尺寸计算比例 */
    static let Scale_Height = iPhoneX ? 736.0/667.0 : ScreenHeight / 667
    static let Scale_Width = ScreenWidth / 375
    /// 底部安全区域
    static let kBottomMargin : CGFloat = iPhoneXSeries ? tkSafeAreaBottom() : 0
    ///底部安全区域的一半高度
    static let kBottomMidMargin : CGFloat = iPhoneXSeries ? 20 : 0
    /// 状态栏
    static let kTopMargin : CGFloat = iPhoneXSeries ? 24 : 0
    
    /// 返回状态栏高度
    static let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height
    /// 返回状态栏和导航栏的高度
    static let NavAndstatusBarHeight = clStatusBarHeight() + 44
}

extension CGFloat {
    /// 系统tabbar高度
    static var currentWindow: UIWindow? {
        // iOS 15+ 多 Scene 兼容
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }

    static var systemTabBarHeight: CGFloat {
        let baseHeight: CGFloat = 49.0
        let bottomInset = currentWindow?.safeAreaInsets.bottom ?? 0
        return baseHeight + bottomInset
    }
}

extension UIColor {
    //返回随机颜色
    public class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

func ADAPTX(x:CGFloat) -> CGFloat {
    return AppFrame.Scale_Width * x
}

func ADAPTY(y:CGFloat) -> CGFloat {
    return AppFrame.Scale_Height * y
}


// MARK: ============================================================================
// MARK: 设置颜色
//MARK: - AppColor 相关
public enum AppColor {
    
    static let clear = UIColor.clear
    // 导航栏颜色
    static let navColor = RGB0X(hexValue: 0xF2F8FD)
    //APP主题色(黄)
    static var themeBlue:UIColor = {
        return RGB0X(hexValue: 0x420064)
    }()
    // 主题紫色
    static var themePurple = RGB0X(hexValue: 0x420064)
    // 主题黄色
    static var themeYellow = RGB0X(hexValue: 0xFFF000)
    // 主题灰(页面背景)
    static let themeGray = RGB0X(hexValue: 0xF2F2F2)
    // 灰色线
    static let lineGray = RGB0X(hexValue: 0xDDDDDD)
    //APP红色
    static let red = RGB0X(hexValue: 0xff2323)
    //APP蓝色
    static let blue = RGB0X(hexValue: 0x488ff0)
    // 大框边框颜色
    static let rgb999 = RGB0X(hexValue: 0x999999)
    //APP黑色
    static let rgb333 = RGB0X(hexValue: 0x333333)
    //APP深灰色
    static let rgb666 = RGB0X(hexValue: 0x666666)
    //APP灰色
    static let rgbf9f9 = RGB0X(hexValue: 0xf9f9f9)
    //APP轻灰色
    static let rgbf5f5 = RGB0X(hexValue: 0xf5f5f5)
    //APP背景灰
    static let backGray = RGB0X(hexValue: 0xF6F6F6)
    //APP白色
    static let white = RGB0X(hexValue: 0xFFFFFF)
}


//// 换肤用
////自定义ThemeStyle示例
//extension ThemeStyle {
//    static let light = ThemeStyle(rawValue: "light")
//    static let dark = ThemeStyle(rawValue: "dark")
//
//    static let yellow = ThemeStyle(rawValue: "yellow")
//    static let red = ThemeStyle(rawValue: "red")
//    // 图片
//}



