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

end