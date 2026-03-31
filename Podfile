source 'https://github.com/CocoaPods/Specs.git'
#source 'http://114.215.28.117:8989/ShuMan/MMPods.git'
platform :ios, '13.0'
use_frameworks!

targetsArray = ['MakeMoneyOnline']

targetsArray.each do |t|
  target t do

    pod 'SnapKit', '~> 5.0' #约束
    pod 'Alamofire' #网络
    pod 'Kingfisher' #图片
    pod 'CryptoSwift' # 加密
    pod 'SwiftyJSON' #json
    pod 'SwifterSwift'
    pod 'Moya'
    
    pod 'MJRefresh' # 刷新
    pod 'ObjectMapper' # 对象
    pod 'FSPagerView', '~> 0.8.3' # 轮播视图
    
#    #----⬇️⬇️⬇️ 广告 ----
#    pod 'MSMobAdSDK/MS','2.7.12.3'
#    pod 'BaiduMobAdSDK', '10.02'
#    pod 'JADYun','2.6.4'
#    pod 'JADYunMotion','2.6.4'
#    pod 'KSAdSDK','4.8.10.1'
#    pod 'GDTMobSDK','4.15.60'
#    pod 'Ads-CN-Beta','7.3.0.0', :subspecs => ['BUAdSDK','CSJMediation']
#    
#    #⭐️⭐️⭐️⭐️⭐️中台广告SDK支持的第三方广告SDK版本同上，在调整第三方广告SDK版本号时，要验证中台广告SDK是否需要适配更新
#    pod 'MMToolsKit', '1.4.2', :subspecs => ['MMAdManager/BUAd', 'MMAdManager/GDTAd', 'MMAdManager/KSAd', 'MMAdManager/BDAd', 'MMAdManager/MSAd', 'MMAdManager/XMAd', 'MMAdManager/MMAd']
#    #----⬆️⬆️⬆️ 广告 ----
    
    
  end
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      
      # ✅ 关键：排除 arm64（模拟器）
      # config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      
      # ✅ 强制架构
      # config.build_settings["ARCHS[sdk=iphonesimulator*]"] = "x86_64"
      
      # 最低版本
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
      
    end
  end
end
