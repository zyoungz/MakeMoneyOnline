Pod::Spec.new do |s|
  s.name         = 'MakeMoneyOnline'
  s.version      = '1.0.0'
  s.summary      = 'MakeMoneyOnline modular SDK with MVVM architecture'
  s.description  = 'MakeMoneyOnline provides MVVM structure for easy integration in iOS apps.'
  s.homepage     = 'https://github.com/zyoungz/MakeMoneyOnline'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'zhouyang' => '1143469121@qq.com' }
  s.source       = { :git => 'https://github.com/zyoungz/MakeMoneyOnline.git', :tag => '1.0.0' }

  s.platform      = :ios, '13.0'
  s.swift_version = '5.0'
  # 只包含 SDK 核心文件
  s.source_files = 'MakeMoneyOnline/**/*.{swift}'
  s.dependency 'SnapKit', '~> 5.0'   # SDK 依赖 SnapKit
  s.dependency 'Alamofire'
  s.dependency 'Kingfisher'

  #----⬇️⬇️⬇️ 广告 ----
#  s.dependency 'MSMobAdSDK/MS','2.7.12.3'
#  s.dependency 'BaiduMobAdSDK', '10.02'
#  s.dependency 'JADYun','2.6.4'
#  s.dependency 'JADYunMotion','2.6.4'
#  s.dependency 'KSAdSDK','4.8.10.1'
#  s.dependency 'GDTMobSDK','4.15.60'
#  s.dependency 'Ads-CN-Beta','7.3.0.0', :subspecs => ['BUAdSDK','CSJMediation']
    
    #⭐️⭐️⭐️⭐️⭐️中台广告SDK支持的第三方广告SDK版本同上，在调整第三方广告SDK版本号时，要验证中台广告SDK是否需要适配更新
#  s.dependency 'MMToolsKit', '1.4.2', :subspecs => ['MMAdManager/BUAd', 'MMAdManager/GDTAd', 'MMAdManager/KSAd', 'MMAdManager/BDAd', 'MMAdManager/MSAd', 'MMAdManager/XMAd', 'MMAdManager/MMAd']
  #----⬆️⬆️⬆️ 广告 ----

end