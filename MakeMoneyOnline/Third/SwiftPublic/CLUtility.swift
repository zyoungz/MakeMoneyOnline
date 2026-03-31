//
//  CLUtility.swift
//  Pick记账
//
//  Created by eagle on 2023/6/9.
//

import UIKit
import Kingfisher
import Foundation
import SwifterSwift

class CLUtility: NSObject {
    
    static func saveGeTuiDeviceToken_kit(_ token: String) {
        TTUtility.setValueInUserDefault_kit(token, key: "kGeTuiDeviceTokenKit")
    }
    
    static func getGeTuiDeviceToken_kit() -> String {
        return TTUtility.valueInUserDefault_kit("kGeTuiDeviceTokenKit") as? String ?? ""
    }
    
    static func saveGeTuiCID_kit(_ cid: String) {
        TTUtility.setValueInUserDefault_kit(cid, key: "kGeTuiCidKit")
    }
    
    static func getGetuiCID_kit() -> String {
        return TTUtility.valueInUserDefault_kit("kGeTuiCidKit") as? String ?? ""
    }
    
    static func deviceIDFV_kit() -> String? {
        if let idfvUUID = UIDevice.current.identifierForVendor {
            return idfvUUID.uuidString
        }
        return nil
    }
    
   static func country_kit() -> String? {
        let locale = Locale.current
        return locale.regionCode
    }
    
    static func isSupportedAutoBillDevice_kit() -> Bool {
        #if DEBUG
        // return false
        #endif
        
        let model = UIDevice.current.model
        
        if model == "iPhone" {
            if #available(iOS 15.0, *) {
                return true
            } else {
                return false // < iOS 15
            }
        } else {
            return false // 不是 iPhone
        }
    }
    
//    static func haveCeBianActionKit() -> Bool {
//        #if DEBUG
//         return true
//        #endif
//
//        let device = PKDevice.deviceMachine
//        if device == "iPhone16,1" { // iPhone 15 Pro
//            return true
//        }
//        if device == "iPhone16,2" { // iPhone 15 Pro Max
//            return true
//        }
//        return false
//    }
//    
//    static func isIPhone8LaterKit() -> Bool {
//        #if DEBUG
//         return true
//        #endif
//
//        let model = UIDevice.current.model
//        
//        if model == "iPhone" {
//            if #available(iOS 15.0, *) {
//                let modelIdentifier = PKDevice.deviceMachine ?? ""
//                
//                let components = modelIdentifier.split(separator: ",")
//                if components.count >= 2 {
//                    var modelNumberStr = String(components[0])
//                    modelNumberStr = modelNumberStr.replacingOccurrences(of: "iPhone", with: "")
//                    if let modelNumber = Int(modelNumberStr) {
//                        // iPhone 8及以上机型的 modelIdentifier 前缀大于等于10
//                        if modelNumber >= 10 {
//                            return true
//                        } else {
//                            return false // 不是 iPhone 8 及以上机型
//                        }
//                    } else {
//                        return false // modelNumberStr 无法转换为整数
//                    }
//                } else {
//                    return false // modelIdentifier 不合法
//                }
//            } else {
//                return false // < iOS 15
//            }
//        } else {
//            return false // 不是 iPhone
//        }
//    }
    
}

/// 计算文本高度
func getTextHeight_kit(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
    ]
    
    let boundingRect = NSString(string: text).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: attributes,
                                                           context: nil)
    
    return ceil(boundingRect.height)
}

func clCurrentViewController_kit() -> BaseViewController? {
    let vc = tkCurrentViewControllerKit_kit()
    if vc?.isKind(of: BaseViewController.self) ?? false {
        return vc as? BaseViewController
    }
    return nil
}

func convertDictionaryToString_kit(dictionary: [String: Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch {
        return nil
    }
}


///
/// - Parameters:
///   - input: 需要更改的文字, 富文本部分用'###'相隔
///   - attrs: 需要添加的富文本属性
///   - normalAttrs: 对全部文字进行的富文本设置
///   - alignment: alignment
///   - wordSpace: 默认为-1,为项目中默认的字间距. 0即为系统字间距
///   - paragraphSpacing: 段间距, 默认0 为系统段间距, 此更改不支持textView等多行输入形式的view
///   - lineSpacing: 行间距, 默认0为系统行间距, 此更改不支持textView等多行输入形式的view
///   - lineBreakMode: 省略形式, 注意如果是在textView / TTTAttributedLabel这种用的时候 需要设置会默认. 不然会只显示一行
/// - Returns: NSMutableAttributedString
///
func getAttributed_kit(input: String, attrs: [NSAttributedString.Key: Any]? = nil, normalAttrs:[NSAttributedString.Key: Any]? = nil, wordSpace: CGFloat = 0, paragraphSpacing: CGFloat = 0, lineSpacing: CGFloat = 0, lineBreakMode: NSLineBreakMode = .byTruncatingTail,_ highColor:UIColor = tkColor_kit(hex: "#D0F7FF"), textAlignment:NSTextAlignment = .left) -> NSMutableAttributedString {
    
    let attributes = attrs ?? [NSAttributedString.Key.foregroundColor: highColor]
    let regexPattern = #"###(.*?)###"#
    let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

    let attributedString = NSMutableAttributedString(string: input)
    if let normalAttrs = normalAttrs {
        attributedString.addAttributes(normalAttrs, range: NSRange(location: 0, length: attributedString.length))
    }
    
    for match in matches.reversed() {
        if let range = Range(match.range(at: 1), in: input) {
            let fieldRange = NSRange(range, in: input)
            attributedString.addAttributes(attributes, range: fieldRange)
        }
    }
    
    /// 将文字中的'###'标识符去掉
    for match in matches.reversed() {
        if let range = Range(match.range(at: 1), in: input) {
            let fieldRange = NSRange(range, in: input)
            let fieldText = attributedString.attributedSubstring(from: fieldRange)
            attributedString.replaceCharacters(in: match.range, with: fieldText)
        }
    }
    
    if wordSpace != 0 {
        attributedString.addAttributes([NSAttributedString.Key.kern: wordSpace], range: NSRange(location: 0, length: attributedString.length))
    }
    
    let paragrahStyle = NSMutableParagraphStyle()
    if paragraphSpacing != 0 {
        /// 两个字之间的间距
        paragrahStyle.paragraphSpacing = paragraphSpacing
    }
    if lineSpacing != 0 {
        /// 行间距
        paragrahStyle.lineSpacing = lineSpacing
    }
    paragrahStyle.lineBreakMode = lineBreakMode
    paragrahStyle.alignment = textAlignment
    
    attributedString.addAttribute(.paragraphStyle, value: paragrahStyle, range: NSRange(location: 0, length: attributedString.length))
    return attributedString
}


func clNavHeight_kit() -> CGFloat {
    return 52.0
}

func clStatusBarNavHeight_kit() -> CGFloat {
    return clStatusBarHeight_kit() + clNavHeight_kit()
}

func clStatusBarHeight_kit() -> CGFloat {
    return tkStatusBarHeight_kit()
//    let  height: CGFloat = (tkIsFullScreenIphone() && tkIsPhone()) ? 40.0 : 20.0
//    return height
}

//func lightVibrate() {
//    if PKSettingProvider.vibrateIsAvailable() {
//        UIDevice.lightVibrate()
//    }
//}

//func playSoundEffect() {
//    PKAudioManager.playSoundEffect()
//}

extension UIFont {
    static let systemFont = "PingFangSC-Regular"
    static let systemMediumFont = "PingFangSC-Medium"
    static let systemThinFont = "PingFangSC-Thin"
    static let systemSemiboldFont = "PingFangSC-Semibold"
    static let systemUltralightFont = "PingFangSC-Ultralight"
    
    static func cc_font_kit(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        guard let font = font else { return UIFont.systemFont(ofSize: size) }
        return font
    }
    
    static func cl_systemFont_kit(OfSize: CGFloat) -> UIFont {
        return self.cc_font_kit(name: systemFont, size: OfSize)
    }
    
    static func cl_systemMediumFont_kit(OfSize: CGFloat) -> UIFont {
        return self.cc_font_kit(name: systemMediumFont, size: OfSize)
    }
    
    static func cl_systemThinFont_kit(OfSize: CGFloat) -> UIFont {
        return self.cc_font_kit(name: systemThinFont, size: OfSize)
    }
    
    static func cl_systemSemiboldFont_Kit(OfSize: CGFloat) -> UIFont {
        return self.cc_font_kit(name: systemSemiboldFont, size: OfSize)
    }
}

extension UIImageView {
    
    public func setImage_kit(urlstring: String, placeholder: String? = nil, complete: ((UIImage?) -> Void)? = nil) {
        
        if !urlstring.hasPrefix("http") {
           let image = UIImage(named: urlstring)
            if let image = image {
                self.image = image
                complete?(image)
                return
            }
        }
        
        let plcImage = placeholder == nil ?  nil : UIImage(named: placeholder!)
        let option = [KingfisherOptionsInfoItem.transition(.fade(0.25))]
        self.kf.indicatorType = .activity // 加载动画, 可以展示系统小菊花, 支持自定义view 和 图片
        let url = URL(string: urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        
        self.kf.setImage(with: url, placeholder: plcImage, options: option, progressBlock: nil) { result in
            
            switch result {
            case .success(let value):
                complete?(value.image)
            case .failure(_):
                complete?(nil)
            }
        }
        
    }
    
    public func setImage_kit(gifName: String) {
        let path = Bundle.main.path(forResource: gifName, ofType: ".gif")
        let fileUrl = URL(fileURLWithPath: path!)
        let provider = LocalFileImageDataProvider(fileURL: fileUrl)
        //从`provider`加载图像数据，使用`p`处理图像，并将其存储在缓存中。ps:你也可以不处理图片
        self.kf.setImage(with: provider)
    }
    
//    func setBillImage(_ billImage: BillImage, placeholder: String? = nil, isOnSwitch:Bool = true) {
//        var image: UIImage?
//        
//        if let img = billImage.image {
//            image = img
//        } else if !billImage.local.isEmpty {
//            image = PKBillImageManager.billImage(fileName: billImage.local)
//        }
//        
//        if let image = image {
//            self.image = image
//        } else if !billImage.url.isEmpty {
//            self.setImage(urlstring: billImage.url, placeholder: placeholder, complete: nil)
//        } else if let placeholder = placeholder, !placeholder.isEmpty {
//            self.image = UIImage(named: placeholder)
//        }
//    }
    
}

extension UILabel {
    
    func setTextColor_kit(_ hex: String)  {
        self.textColor = tkColor_kit(hex: hex)
    }
}

extension UIButton {
    
    func setTitleColor_Kit(_ hex: String, state: UIButton.State) {
        self.setTitleColor(tkColor_kit(hex: hex), for: state)
    }
    
    func setImage_Kit(urlstring: String, placeholder: String? = nil, state: UIControl.State, complete: ((UIImage?) -> Void)? = nil) {
        
        if !urlstring.hasPrefix("http") {
            let image = UIImage(named: urlstring)
            if let image = image {
                self.setImage(image, for: state)
                complete?(image)
                return
            }
        }
        
        let placeholderImage = placeholder == nil ? nil : UIImage(named: placeholder!)
        let option = [KingfisherOptionsInfoItem.transition(.none)]
        let url = URL(string: urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        self.kf.setImage(with: url, for: state, placeholder: placeholderImage, options: option, completionHandler:  { result in
            
            switch result {
            case .success(let value):
                complete?(value.image)
            case .failure(_):
                complete?(nil)
            }
        })
    }
}

extension UIView {
    
    func setBackgroundColor_kit(_ hex: String) {
        self.backgroundColor = tkColor_kit(hex: hex)
    }
}

extension UIImage {
    
    static func renderImageWithForegroundColor_Kit(image: UIImage, foregroundColor: UIColor, targetColor: UIColor) -> UIImage? {
        let ciImage = CIImage(image: image)
        
        guard let filter = CIFilter(name: "CIFalseColor") else {
            return nil
        }
        
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIColor(cgColor: foregroundColor.cgColor), forKey: "inputColor0")
        filter.setValue(CIColor(cgColor: targetColor.cgColor), forKey: "inputColor1")
        
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        let renderedImage = UIImage(cgImage: cgImage)
        return renderedImage.tt.resizeImage_kit(image: renderedImage, newSize: image.size)
    }
    
    static func renderImageWithColor_kit(image: UIImage?, targetColor: UIColor) -> UIImage? {
        // 创建一个 CIImage 对象，作为滤镜的输入
        guard let image = image,let ciImage = CIImage(image: image) else {
            return nil
        }
        
        // 创建一个 CIFilter 对象，并设置滤镜名称为 "CIMultiplyCompositing"
        guard let filter = CIFilter(name: "CIMultiplyCompositing") else {
            return nil
        }
        
        // 创建一个单色的 CIImage 作为颜色图层
        let colorImage = CIImage(color: CIColor(color: targetColor))
        
        // 设置滤镜的输入图像和颜色图层
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(colorImage, forKey: kCIInputBackgroundImageKey)
        
        // 获取滤镜输出的 CIImage
        guard let outputCIImage = filter.outputImage else {
            return nil
        }
        
        // 创建一个 CIContext 用于渲染
        let context = CIContext(options: nil)
        
        // 渲染输出的 CIImage 到一个 CGImage
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        // 创建一个 UIImage 并返回
        let renderedImage = UIImage(cgImage: cgImage)
        
        return renderedImage.tt.resizeImage_kit(image: renderedImage, newSize: image.size)
    }
}

extension String {
    
    static func getHexString_kit(for data: Data) -> String {
        let len = data.count
        let chars = data.withUnsafeBytes { $0.baseAddress!.assumingMemoryBound(to: UInt8.self) }
        var hexString = ""
        
        for i in 0..<len {
            hexString.append(String(format: "%02hhx", chars[i]))
        }
        
        return hexString
    }
    ///根据设定的最大长度, 截取字符串, 中文占两个位置
    func cl_truncateString_kit(toLengh maxLength: Int) -> String {
        var currentLength = 0
        var currentIndex = self.startIndex
        
        while currentIndex < self.endIndex {
            let character = self[currentIndex]
            
            if character.isChinese_kit() {
                currentLength += 2
            } else {
                currentLength += character.utf8.count
            }
            
            if currentLength > maxLength {
                let endIndex = self.index(before: currentIndex)
                let truncatedSubstring = self[self.startIndex...endIndex]
                return String(truncatedSubstring)
            }
            
            currentIndex = self.index(after: currentIndex)
        }
        
        return self
    }
    
    /// 现在字符串的长度, 中文算两个长度
    var cl_length_kit: Int {
        var count = 0
        for scalar in self.charactersArray {
            if scalar.isChinese_kit() {
                count += 2
            } else {
                count += scalar.utf8.count
            }
        }
        return count
    }
    
}

extension Character {
    func isChinese_kit() -> Bool {
        let pattern = "^[\u{4E00}-\u{9FA5}]$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: 1)
        return regex.firstMatch(in: String(self), options: [], range: range) != nil
    }
}


extension Bool {
    var cl_chineseString_kit: String {
        return self ? "是" : "否"
    }
}

// 扩展UIColor以添加计算颜色之间距离的方法
extension UIColor {
    func distanceTo_kit(color: UIColor) -> CGFloat {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let dr = r1 - r2
        let dg = g1 - g2
        let db = b1 - b2
        
        return sqrt(dr * dr + dg * dg + db * db)
    }
    
    
    ///根据主题,切换颜色组
    static func rearrangeColors_kit(_ colors: [UIColor], withReferenceColor referenceColor: UIColor) -> [UIColor] {
        var sortedColors = colors.sorted { (color1, color2) -> Bool in
            let distance1 = color1.distanceTo_kit(color: referenceColor)
            let distance2 = color2.distanceTo_kit(color: referenceColor)
            return distance1 < distance2
        }
        
        var result = colors
        
        let closestColor = sortedColors.removeFirst()
        
        // 找到最接近的颜色并将其替换为指定颜色
        if let index = colors.firstIndex(of: closestColor) {
            result[index] = referenceColor
            moveElementsBeforeIndexToEnd_kit(&result, index: index)
        }
        
        return result
    }
    
    static func moveElementsBeforeIndexToEnd_kit<T>(_ array: inout [T], index: Int) {
        if index < array.count && index >= 0 {
            let prefix = array[..<index]
            array.removeSubrange(..<index)
            array.append(contentsOf: prefix)
        }
    }
}

extension Date {
    /**
     1 表示星期日（Sunday）
     2 表示星期一（Monday）
     3 表示星期二（Tuesday）
     4 表示星期三（Wednesday）
     5 表示星期四（Thursday）
     6 表示星期五（Friday）
     7 表示星期六（Saturday）
     */
    func startOfWeek_kit(firstWeekDay: Int = 2) -> Date? {
        
        var calendar = Calendar.current
        
        calendar.firstWeekday = firstWeekDay
        
        // 获取当前日期所在周的开始时间
        if let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) {
            return weekStartDate
        } else {
            return nil
        }

    }
    
    /**
     1 表示星期日（Sunday）
     2 表示星期一（Monday）
     3 表示星期二（Tuesday）
     4 表示星期三（Wednesday）
     5 表示星期四（Thursday）
     6 表示星期五（Friday）
     7 表示星期六（Saturday）
     */
    
    func endOfWeek_kit(firstWeekDay: Int = 2) -> Date? {
        var calendar = Calendar.current
        calendar.firstWeekday = firstWeekDay
        // 获取当前日期
//        let currentDate = Date()

        // 获取一周的开始时间
        if let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)),
           let weekEndDate = calendar.date(byAdding: .second, value: -1, to: calendar.date(byAdding: .weekOfYear, value: 1, to: weekStartDate)!) {
            return weekEndDate
        } else {
            return nil
        }
    }
}


extension NSAttributedString {
    
    /// 获取文本高度
    func getHeight_kit(width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return ceil(rect.height)
//        
//        let options:NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading]
//        
//        
//        let bounds = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
//        let context = NSStringDrawingContext()
//        let height = self.boundingRect(with: bounds.size, options: options, context: context).size.height
//        
////        let height = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], context: nil).size.height
//        
//        return ceil(height)
    }
    
    /// 获取文本宽度
    func getWidth_kit(height: CGFloat) -> CGFloat {
        let width = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: [.usesLineFragmentOrigin], context: nil).size.width
        
        return ceil(width)
    }
}
