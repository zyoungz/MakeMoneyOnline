//
//  WLAction.swift
//  PPWuliu
//
//  Created by zhou Last on 2019/8/9.
//  Copyright © 2019 zhou Last. All rights reserved.
//

import UIKit
import Alamofire
import CommonCrypto
import Kingfisher

var downloader: ImageDownloader!
//MARK: - 日志输出
// <T>: 为泛型，外界传入什么就是什么
func BJDLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    
    if AppConstants.LogDebug {
        DLog("\(method)[\(line)]:\(message)")
    }
}

// 圆角
func cordius(_ view:UIView, _ radius:CGFloat) {
    view.layer.cornerRadius = radius
    //    view.clipsToBounds = true
}



// 检测登录情况
func judgeIsLogin() -> Bool {
//    let token = UserDefaults.standard.string(forKey: AccountInfo.token)
    let userId = User.shared.userId

    if (userId > 0) {
        // 已登录
        return true
    } else {
        // 未登录
        return false
    }
}

//func cl_userMMKV() -> MMKV? {
//    return (AIYOUserInfo.shared.userId ?? 0) > 0 ? MMKV(mmapID: "\(User.userIdString)") : nil
//}

/// 获取当前window
func tkCurrentWindow() -> UIWindow? {
    let window = UIApplication.shared.keyWindow
    if window?.windowLevel != .normal {
        let arr = UIApplication.shared.windows
        for sub in arr {
            if sub.windowLevel == .normal {
                return sub
            }
        }
    }
    return window
}

/// 弹窗在主线程
public func tkDispatch_safe_main_queue(_ closure: @escaping ()->Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}


// 阴影
func shadow(_ view: UIView,_ width: CGFloat, _ color: UIColor,_ shadowRadius:CGFloat = 3.0,_ opacity:Float = 1.0) {
    view.layer.cornerRadius = shadowRadius
    view.layer.shadowOffset = .zero
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = opacity
}

func buildTableView(_ nibName: String, _ color: UIColor,_ vc:UIViewController) -> UITableView{
    let waybillTableView = UITableView()
    waybillTableView.backgroundColor = color
    waybillTableView.delegate = (vc as! UITableViewDelegate)
    waybillTableView.dataSource = (vc as! UITableViewDataSource)
    waybillTableView.separatorStyle = .none
    let cellNib = UINib(nibName: nibName, bundle: nil)
    waybillTableView.register(cellNib, forCellReuseIdentifier: nibName)
    
    return waybillTableView
}

// 边框
func border(_ view:UIView,_ width:CGFloat,_ color:UIColor) {
    view.layer.borderWidth = width
    view.layer.borderColor = color.cgColor
}


// 检测网络
func checkNetwork()-> Bool {
    let kNetworkStatusManager = NetworkReachabilityManager(host: "www.baidu.com")

    if !(kNetworkStatusManager?.isReachable ?? true) {
       return false
    } else {
        return true
    }
}

func intSystemSetting() {
    let alert = UIAlertController(title: "已为您关闭无线局域网", message: "你可以在'设置'中为此App打开无线局域网", preferredStyle: .alert)
    let setAction = UIAlertAction(title: "设置", style: .default) { (_) in
//            ZLPhotoConfiguration.default().noAuthorityCallback?(.library)
        let settingUrl = NSURL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(settingUrl as URL) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(settingUrl as URL, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(settingUrl as URL)
            }
        }
    }
    let okAction = UIAlertAction(title: "好", style: .default) { (_) in
//            ZLPhotoConfiguration.default().noAuthorityCallback?(.library)
//        let settingUrl = NSURL(string: UIApplication.openSettingsURLString)!
//        if UIApplication.shared.canOpenURL(settingUrl as URL) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(settingUrl as URL, options: [:],
//                                          completionHandler: {
//                                            (success) in
//                })
//            } else {
//                UIApplication.shared.openURL(settingUrl as URL)
//            }
//        }
    }
    alert.addAction(setAction)
    alert.addAction(okAction)
    let appDelegate = UIApplication.shared.delegate
//                    appDelegate?.window??.rootViewController?.navigationController?.pushViewController(DPLoginController(), animated: true)
    appDelegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
}

// placeHolder
func resetPlaceHolder(_ textField:UITextField,_ placeHolderText:String,_ placeColor:UIColor) {
    textField.attributedPlaceholder = NSAttributedString.init(string:placeHolderText, attributes: [NSAttributedString.Key.foregroundColor:AppColor.rgb999])
    textField.tintColor = AppColor.rgb666
}

// 绘制虚线
func drawDashLine(_ view:UIView,strokeColor: UIColor, lineWidth: CGFloat, lineLength: Int, lineSpacing: Int, isBottom: Bool, totolLenth:CGFloat) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = view.bounds
    shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
    shapeLayer.fillColor = UIColor.blue.cgColor
    shapeLayer.strokeColor = strokeColor.cgColor
    
    shapeLayer.lineWidth = lineWidth
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    
    //每一段虚线长度 和 每两段虚线之间的间隔
    shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
    
    let path = CGMutablePath()
    let y = isBottom == true ? view.layer.bounds.height - lineWidth : 0
    path.move(to: CGPoint(x: 0, y: y))
    if isBottom {
        path.addLine(to: CGPoint(x: totolLenth , y: y ))
    } else {
        path.addLine(to: CGPoint(x: y , y: totolLenth))
    }
    shapeLayer.path = path
    view.layer.addSublayer(shapeLayer)
}

// 改变部分字符串的颜色
func changeSubStringColor(_ totalStr:String,_ subStr:String,_ label:UILabel,_ color:UIColor) {
    let strg = totalStr
    let ranStr = subStr
    //所有文字变为富文本
    let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
    //颜色处理的范围
    
    let str = NSString(string: strg)
    let theRange = str.range(of: ranStr)
    //颜色处理
    attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range: theRange)
    //行间距
    let paragraphStye = NSMutableParagraphStyle()
    paragraphStye.lineSpacing = 5
    //行间距的范围
    let distanceRange = NSMakeRange(0, CFStringGetLength(strg as CFString?))
    attrstring .addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: distanceRange)
    label.attributedText = attrstring
//    goodsLabel.attributedText = attrstring//赋值方法
}

// 改变部分字符串的颜色
func changeSubStringColor(_ totalStr:String,_ subStr:String,_ label:UILabel,_ color:UIColor, alignment:NSTextAlignment = .left) {
    let strg = totalStr
    let ranStr = subStr
    //所有文字变为富文本
    let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
    //颜色处理的范围
    
    let str = NSString(string: strg)
    let theRange = str.range(of: ranStr)
    //颜色处理
    attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range: theRange)
    //行间距
    let paragraphStye = NSMutableParagraphStyle()
    paragraphStye.lineSpacing = 5
    paragraphStye.alignment = alignment
    //行间距的范围
    let distanceRange = NSMakeRange(0, CFStringGetLength(strg as CFString?))
    attrstring .addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: distanceRange)
    label.attributedText = attrstring
//    goodsLabel.attributedText = attrstring//赋值方法
}

// 改变部分字符串的颜色(部分字符串是字符串数组)
func changeSubStringListColor(_ totalStr: String,
                              _ subStrList: [String],
                              _ label: UILabel,
                              _ color: UIColor,
                              isItalic: Bool = false) {
    
    let attrstring = NSMutableAttributedString(string: totalStr)
    let fullRange = NSRange(location: 0, length: attrstring.length)
    let baseFont = label.font!
    
    // 设置整体字体
    attrstring.addAttribute(.font, value: baseFont, range: fullRange)
    
    for subStr in subStrList {
        
        let nsStr = totalStr as NSString
        let range = nsStr.range(of: subStr)
        if range.location == NSNotFound { continue }

        // 颜色
        attrstring.addAttribute(.foregroundColor, value: color, range: range)

        if isItalic {
            // 强制中文倾斜 0.2～0.3 比较明显
            attrstring.addAttribute(.obliqueness, value: 0.25, range: range)
        }
    }

    // 行间距
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 5
    attrstring.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
    
    label.attributedText = attrstring
}

// 字符串不同的字体大小
func changeSubStringFont(_ totalStr:String,_ subStr:String,_ label:UILabel,_ font:UIFont) {
    let strg = totalStr
    let ranStr = subStr
    //所有文字变为富文本
    let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
    //颜色处理的范围
    
    let str = NSString(string: strg)
    let theRange = str.range(of: ranStr)
    //颜色处理
    attrstring.addAttribute(NSAttributedString.Key.font, value:font, range: theRange)
    //行间距
    let paragraphStye = NSMutableParagraphStyle()
    paragraphStye.lineSpacing = 5
    //行间距的范围
    let distanceRange = NSMakeRange(0, CFStringGetLength(strg as CFString?))
    attrstring .addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: distanceRange)
    label.attributedText = attrstring
//    goodsLabel.attributedText = attrstring//赋值方法
}


func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        BJDLog("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
}

func openOtherUrl(_ urlStr:String) {
    let str = NSString(format: urlStr as NSString)
    let url = NSURL(string: str as String)! as URL
    
    if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:],
                                  completionHandler: {
                                    (success) in
        })
    } else {
        UIApplication.shared.openURL(url)
    }
}

// 注册tableview nib
func registTableViewNib(_ tableView:UITableView,_ cellName:String) {
    let cellNib = UINib(nibName: cellName, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: cellName)
}

/// 部分圆角
///
/// - Parameters:
///   - corners: 需要实现为圆角的角，可传入多个
///   - radii: 圆角半径
///    -> CALayer
func configRectCorner(_ view:UIView,_ height:CGFloat,_ corner: UIRectCorner,_ radio: CGSize) {
    
    let rect = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: height)
//    let corner = UInt8(UIRectCorner.topLeft.rawValue) | UInt8(UIRectCorner.topRight.rawValue) // 这只圆角位置
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: radio)
    let masklayer = CAShapeLayer() // 创建shapelayer
    masklayer.frame = rect
    masklayer.path = path.cgPath // 设置路径
    view.layer.mask = masklayer
    
//    return masklayer
}

func configCustomRectCorner(_ view:UIView,_ height:CGFloat, topLeft:CGFloat, topRight:CGFloat,bottomLeft:CGFloat, bottomRight:CGFloat, borderColor:UIColor = .clear, borderWidth:CGFloat = 0.0) {
//    let rect = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: height)

//    // 设置每个角的圆角半径
//    let path = UIBezierPath(
//        roundedRect: view.bounds,
//        byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
//        cornerRadii: CGSize(width: 20, height: 20) // 会被同时应用到所有角
//    )

    // ⚠️ 想设置不同的半径，就得自定义 path
//    let topLeft: CGFloat = 10
//    let topRight: CGFloat = 20
//    let bottomLeft: CGFloat = 30
//    let bottomRight: CGFloat = 40

    let bounds = view.bounds
    let maskPath = UIBezierPath()

    // 从左上角开始，顺时针画 path
    maskPath.move(to: CGPoint(x: bounds.minX + topLeft, y: bounds.minY))

    // 顶部边和右上角
    maskPath.addLine(to: CGPoint(x: bounds.maxX - topRight, y: bounds.minY))
    maskPath.addArc(withCenter: CGPoint(x: bounds.maxX - topRight, y: bounds.minY + topRight),
                    radius: topRight,
                    startAngle: -.pi / 2,
                    endAngle: 0,
                    clockwise: true)

    // 右边和右下角
    maskPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bottomRight))
    maskPath.addArc(withCenter: CGPoint(x: bounds.maxX - bottomRight, y: bounds.maxY - bottomRight),
                    radius: bottomRight,
                    startAngle: 0,
                    endAngle: .pi / 2,
                    clockwise: true)

    // 底部和左下角
    maskPath.addLine(to: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY))
    maskPath.addArc(withCenter: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY - bottomLeft),
                    radius: bottomLeft,
                    startAngle: .pi / 2,
                    endAngle: .pi,
                    clockwise: true)

    // 左边和左上角
    maskPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + topLeft))
    maskPath.addArc(withCenter: CGPoint(x: bounds.minX + topLeft, y: bounds.minY + topLeft),
                    radius: topLeft,
                    startAngle: .pi,
                    endAngle: 3 * .pi / 2,
                    clockwise: true)

    maskPath.close()

    // 设置 mask
    let maskLayer = CAShapeLayer()
    maskLayer.path = maskPath.cgPath
    view.layer.mask = maskLayer
    
    // ---------- 关键在下面 ----------
    // remove old border
    view.layer.sublayers?
        .filter{ $0.name == "customCornerBorder" }
        .forEach{ $0.removeFromSuperlayer() }
    
    // 用 shape layer 绘制边框
    if borderWidth > 0 {
        let borderLayer = CAShapeLayer()
        borderLayer.name = "customCornerBorder"
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = view.bounds
        view.layer.addSublayer(borderLayer)
    }

}

//func stringWithnull(_ text:String) ->Bool {
//    if ((text == "") || (text == "null")  || (text == nil) || (text == "<null>") || (text == "(null)")) {
//        return true
//    }
//    
//    return false
//}


public extension UIButton {

/** 部分圆角
 * - corners: 需要实现为圆角的角，可传入多个
 * - radii: 圆角半径
 */
func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
    let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path = maskPath.cgPath
    self.layer.mask = maskLayer
  }

}

func viewShadow(view:UIView,opacity:Float = 0.3,radius:CGFloat) {
    view.layer.shadowColor = AppColor.themeYellow.cgColor
    view.layer.shadowOpacity = opacity
//    view.layer.shadowOffset = 
    cordius(view, radius)
}

    
func PingFangSemibold(_ fsize: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Semibold", size: fsize)!
}

func PingFangRegular(_ fsize: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Regular", size: fsize)!
}

func PingFangMedium(_ fsize: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Medium", size: fsize)!
}

/// RGBA的颜色设置
func RGB(_ r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func HEXA(hexValue: Int, a: CGFloat) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                   alpha: a)
}

func RGB0X(hexValue: Int) -> (UIColor) {
    return HEXA(hexValue: hexValue, a: 1.0)
}

func FONT(font: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font)
}

// MARK: ============================================================================
// MARK:生成默认UIBarButtonItem
///
/// - parameter title  : 标题
/// - parameter style  : UIBarButton类型
/// - parameter target  : 触发方法
/// - parameter action  : 方法名
/// - returns : UIBarButtonItem
//func mNavRightItem(title: String?, style: UIBarButtonItem.Style, target: Any?, action: Selector?, color: UIColor = AppColor.themeYellow, font: UIFont) -> UIBarButtonItem{
//    let item = UIBarButtonItem(title: title, style: style, target: target, action: action)
//    item.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:color], for: UIControl.State.normal)
//
//    return item
//}

//view的tap事件
func tapGesture(_ view: UIView, _ vc:Any, _ action: Selector?) {
    view.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer.init(target: vc, action: action)
    view.addGestureRecognizer(tap)
}

//button的click事件
func btnClicked(_ btn: UIButton,_ vc: UIViewController, _ action: Selector?) {
    btn.isUserInteractionEnabled = true
    btn.addTarget(vc, action: action!, for: .touchUpInside)
}


// 显示框
func showAlert(currentVC:UIViewController,tittle: String, meg:String, cancelBtn:String, otherBtn:String?, handler:((UIAlertAction) -> Void)?){
    //        guard let vc = self.getCurrentVC() else{ return }
    //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
    let alertController = UIAlertController(title:tittle,
                                            message:meg ,
                                            preferredStyle: .alert)
    let cancelAction = UIAlertAction(title:cancelBtn, style: .cancel, handler:nil)
    
    alertController.addAction(cancelAction)
    
    if otherBtn != nil{
        let settingsAction = UIAlertAction(title: otherBtn, style: .default, handler: { (action) -> Void in
            handler?(action)
        })
        alertController.addAction(settingsAction)
    }
    currentVC.present(alertController, animated: true, completion: nil)
    //        })
}

// FIXME: ---- 高斯模糊
func blurry(_ image:UIImage) -> UIImage {
    let context: CIContext = CIContext(options: nil)
    let inputImage =  CIImage(image: image)
    //使用高斯模糊滤镜
    let filter = CIFilter(name: "CIGaussianBlur")!
    filter.setValue(inputImage, forKey:kCIInputImageKey)
    //设置模糊半径值（越大越模糊）
    filter.setValue(25, forKey: kCIInputRadiusKey)
    let outputCIImage = filter.outputImage!
    let rect = CGRect(origin: CGPoint.zero, size: image.size)
    let cgImage = context.createCGImage(outputCIImage, from: rect)
    //显示生成的模糊图片
    return UIImage(cgImage: cgImage!)
}

// FIXME: ----- 包含
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

//判断手机号格式是否合法
func isTelNumber(num:NSString)->Bool
{
//    let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
//    let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
//    let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
//    let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    let  CR = "^1[0-9]{10}$";
//    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
//    let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
//    let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
//    let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
    let regextestcr = NSPredicate(format: "SELF MATCHES %@" ,CR)

    if (regextestcr.evaluate(with: num) == true)
    {
        return true
    }
    else
    {
        return false
    }
}

func validateEmail(email: String) -> Bool {
    if email.count == 0 {
        return false
    }
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}

enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    
    case URL(_: String)
    case IP(_: String)
    
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
}

// MARK: ============================================================================
// MARK: 获取汉字首字母
///
/// - parameter string  : 需要获取首字母的字符串
/// - returns : 首字母
func mGetFirstCharactor(string: String) -> String{
    let str = NSMutableString(string: string) as CFMutableString
    CFStringTransform(str, nil, kCFStringTransformToLatin, false)
    let s: String = str as String
    let index = s.index(s.startIndex, offsetBy: 1)
    
    return String(s[..<index]).uppercased()
    //    return s.substring(to: index).uppercased()
}

// 身份证号
func isTrueIDNumber(text:String) -> Bool{
    var value = text
    value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    var length : Int = 0
    length = value.count
    if length != 15 && length != 18{
       //不满足15位和18位，即身份证错误
        return false
    }
    // 省份代码
    let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
    // 检测省份身份行政区代码
    let index = value.index(value.startIndex, offsetBy: 2)
    let valueStart2 = value.substring(to: index)
    //标识省份代码是否正确
    var areaFlag = false
    for areaCode in areasArray {
        if areaCode == valueStart2 {
            areaFlag = true
            break
        }
    }
    if !areaFlag {
       return false
    }
    var regularExpression : NSRegularExpression?
    var numberofMatch : Int?
    var year = 0
    switch length {
        case 15:
             //获取年份对应的数字
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
            year = yearStr.integerValue + 1900
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }else{
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            if numberofMatch! > 0 {
                return true
            }else{
                return false
            }
        case 18:
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
            year = yearStr.integerValue
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                
            }else{
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            
            if numberofMatch! > 0 {
                let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7
                let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7
                let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9
                let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9
                let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10
                let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10
                let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5
                let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5
                let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8
                let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8
                let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4
                let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4
                let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2
                let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2
                let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1
                let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6
                let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3
                let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
                
                let Y = S % 11
                
                var M = "F"
                
                let JYM = "10X98765432"
                
                M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
                
                let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
                
                if lastStr == "x" {
                    if M == "X" {
                        return true
                    }else{
                        return false
                    }
                }else{
                    if M == lastStr {
                        return true
                    }else{
                        return false
                    }
                }
                
            }else{
                return false
            }
        default:
            return false
      }
}


func getStringByRangeIntValue(Str : NSString,location : Int, length : Int) -> Int{
    let a = Str.substring(with: NSRange(location: location, length: length))
    let intValue = (a as NSString).integerValue
    return intValue
}

/// 时间类型截取到日
///
/// - parameter time  : 时间字符串->例子：1991-12-03
/// - returns : 时间日字符串->例子：1991-12-03
func mSubscribTimeStringToDay(time: String) -> String{
    if time == "" {return ""}
    let i = time.index(time.startIndex, offsetBy: 10)
    let s = String(time[..<i])
    
    return s
}

/// 时间类型截取到分钟
///
/// - parameter time  : 时间字符串->例子：1991-12-03 10:30:11
/// - returns : 时间分钟字符串->例子：1991-12-03 10:30
func mSubscribTimeStringToMin(time: String) -> String{
    if time == "" {return ""}
    let i = time.index(time.startIndex, offsetBy: 16)
    let s = String(time[..<i]) //time.substring(to: i)
    return s
}

// MARK: ============================================================================
// MARK: 设置日期格式
///yyyy-MM-dd
let kFormatteryyyy_mm_dd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

let kFormatterTittleyyyy_mm_dd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日"
    return formatter
}()

/// yyyy/MM/dd
let kFormatteryyyymmdd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter
}()
///MM月
let kMonthFormattermm: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月"
    return formatter
}()
///yyyy
let kYearFormatteryyyy: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter
}()
///yyyy MM月
let kS2MFormatteryyyymm: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy MM月"
    return formatter
}()
///HH:mm
let kTimeFormatterhhmm: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()
///yyyy-MM-dd HH:mm
let kAllFormatteryyyy_mm_dd_hh_mm: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}()
///yyyy-MM-dd HH:mm:ss
let kSecondFormatternormal: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()
///yyyy.MM.dd
let kPointDayFormatteryyyy0mm0dd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter
}()
//yyyyMMddHHmmss
let kAllSecondFormatterSSS: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmssSSS"
    return formatter
}()

//日期转字符串
func mGetDate2String(_ date: Date,_ formatter: DateFormatter) -> String {
    return formatter.string(from: date)
}

//字符串转日期
func stringConvertDate(_ string:String,_ formatter: DateFormatter) -> Date {
    let date = formatter.date(from: string)
    return date!
}
/*
----时间转时间戳函数
:param: stringTime 时间为stirng

:returns: 返回时间戳为stirng
*/
func stringToTimeStamp(stringTime:String,_ formatter: DateFormatter)->String {
    
    let date = formatter.date(from: stringTime)
    let dateStamp:TimeInterval = date?.timeIntervalSince1970 ?? 0
    
    let dateSt:Int = Int(dateStamp)

    return String(dateSt)
}

func dateStrToTimeStamp(_ formatter: DateFormatter)->String {
    let dateStamp:TimeInterval = Date().timeIntervalSince1970
    let dateSt:Int = Int(dateStamp)
    
    return String(dateSt)
}

/*
-----时间戳转时间函数
:param: timeStamp 时间戳

:returns: return time
*/
func timeStampToString(timeStamp:String,_ formatter: DateFormatter)->String {
    if timeStamp.count == 0 {
        return ""
    }
    
    var newTimeStamp: NSString?
    if timeStamp.count >= 13  {
        let tstamp = Int(timeStamp)!/1000
        newTimeStamp = String(tstamp) as NSString
    } else {
        newTimeStamp = NSString(string: timeStamp)
    }
    
    let timeSta:TimeInterval = newTimeStamp!.doubleValue
    let date = NSDate(timeIntervalSince1970: timeSta)
    
    return formatter.string(from: date as Date)
}

func stringConvertDate(string:String, dateFormat:DateFormatter) -> Date {
    let date = dateFormat.date(from: string)
    return date!
}

//FIXME:------ 字符串转Float型
extension String {
    func stringToCGFloat()-> (CGFloat) {
        var gFloat:CGFloat = 0
        if let doubleValue = Double(self)
        {
            gFloat = CGFloat(doubleValue)
        }
        return gFloat
    }
}


// FIXME: ---- 把秒数转换成时分秒（00:00:00）格式
///
/// - Parameter time: time(Float格式)
/// - Returns: String格式(00:00:00)
func transToHourMinSec(time: Int) -> String
{
    let allTime: Int = Int(time)
    var hours = 0
    var minutes = 0
    var seconds = 0
    var hoursText = ""
    var minutesText = ""
    var secondsText = ""
    
    hours = allTime / 3600
    hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
    
    minutes = allTime % 3600 / 60
    minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
    
    seconds = allTime % 3600 % 60
    secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
    
    return "\(hoursText):\(minutesText):\(secondsText)"
}

// 判断某段日期是周几
func getweekDay(_ date : Date,_ isCompleteWeek:Bool = true) ->String{
    let interval = Int(date.timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()
    let days = Int(interval/86400) // 24*60*60
    let weekday = ((days + 4)%7+7)%7
    let comps = weekday == 0 ? 7 : weekday
    
    var str = ""
    if comps == 1 {
        str = "星期一"
        if !isCompleteWeek {
            str = "周一"
        }
    }else if comps == 2 {
        str = "星期二"
        if !isCompleteWeek {
            str = "周二"
        }
    }else if comps == 3 {
        str =  "星期三"
        if !isCompleteWeek {
            str = "周三"
        }
    }else if comps == 4 {
        str =  "星期四"
        if !isCompleteWeek {
            str = "周四"
        }
    }else if comps == 5 {
        str =  "星期五"
        if !isCompleteWeek {
            str = "周五"
        }
    }else if comps == 6 {
        str =  "星期六"
        if !isCompleteWeek {
            str = "周六"
        }
    }else if comps == 7 {
        str =  "星期日"
        if !isCompleteWeek {
            str = "周日"
        }
    }
    return str
}

// 判断字符串日期是周几
func getWeekStrDay(_ dateStr : String) ->String{
    let interval = Int(stringToTimeStamp(stringTime:dateStr, kFormatteryyyy_mm_dd))
    let days = Int(interval!/86400) // 24*60*60
    let weekday = ((days + 4)%7+7)%7
    let comps = weekday == 0 ? 7 : weekday
//    DLog("------:\(comps) days:\(days) weekday:\(weekday)")
    
    var str = ""
    if comps == 1 {
        str = "周一"
    }else if comps == 2 {
        str = "周二"
    }else if comps == 3 {
        str =  "周三"
    }else if comps == 4 {
        str =  "周四"
    }else if comps == 5 {
        str =  "周五"
    }else if comps == 6 {
        str =  "周六"
    }else if comps == 7 {
        str =  "周日"
    }
    return str
}

func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd") -> Date {
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: string)
    return date!
}


extension Date {

  /*
     获取往后20天的所有日期
     if let date = Calendar.current.date(byAdding: .day, value: 20, to: Date()) {
   DLog("--------:\(Date().allDates(till: date))")
     }
     */
  func allDates(till endDate: Date) -> [Date] {
    var date = self
    var array: [Date] = []
    while date <= endDate {
      array.append(date)
      date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    return array
  }
    
  /*
     获取2个日期之间的所有日期数组
     */
  func twoMonthsArray(from fromDate: Date, to toDate: Date) -> [Date] {
       var dates: [Date] = []
       var date = fromDate

       while date <= toDate {
           dates.append(date)
           guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
           date = newDate
       }
       return dates
   }
}

//func shareToMiniObject(path:String, title:String, desc:String, image:String,_ isImg:Bool = false) {
//    let wxMiniObject = WXMiniProgramObject.init()
//    // 微信低版本会自动转为 url 的地址
//    wxMiniObject.webpageUrl = ""
//    // gh_开头的,小程序的起始 ID
//    wxMiniObject.userName = "gh_07975f2c0b7d"
//    // 启动路径 , 可以带参数,详情见下面解释
//    wxMiniObject.path = path
//    // 图片的 data 这个不能大于 128k 做的时候注意点
//    //               wxMiniObject.hdImageData = getDataWith(hdImage)
//    // 正式版
//    wxMiniObject.miniProgramType = .release
//    wxMiniObject.withShareTicket = true
//
//    let message = WXMediaMessage.init()
//    // 分享的标题
//    message.title = title
//    message.description = desc
//    message.mediaObject = wxMiniObject
//    
//    if isImg {
//        message.thumbData = UIImage.init(named: image)?.jpegData(compressionQuality: 0.4)
//    } else {
//        if image.count == 0 {
//            if let image = UIImage(named: "logo_100"),let data = image.pngData() {
//                message.thumbData = data
//            }
//        } else {
//            let imgStr = getThumbnailSize(image,350,250)
//            let url = URL(string:imgStr)
//            let imgView = UIImageView()
//            imgView.kf.setImage(with: url, placeholder: nil, options: nil) { (progress, finish) in
//            } completionHandler: { (result) in
//                if let image = imgView.image,let data = image.pngData() {
////                    message.thumbData = data
//                    message.setThumbImage(image)
//                } else {
//                    if let image = UIImage(named: "logo_100"),let data = image.pngData() {
//                        message.thumbData = data
//                    }
//                }
//            }
//    //        let urlData = (image.dataRepresentation)!
//    //        message.thumbData = urlData
//        }
//    }
//
//    let req = SendMessageToWXReq.init()
//    req.message = message
//    req.bText = false
//    // 目前只支持分享到微信朋友, 不支持分享到朋友圈
//    req.scene = Int32(WXScene.init(0).rawValue)
//    WXApi.send(req)
////    let isLaunchSuc: Bool = WXApi.send(req)
//
//    // 我这里做了回调是方便如果分享之后怎么操作,
//}

func getThumbnailSize(_ urlStr:String,_ width:Int,_ height:Int)-> String {
    let thumbnailStr:String = String.init(format: "%@?x-oss-process=image/resize,m_fill,h_%d,w_%d", urlStr,height,width)
    return thumbnailStr
}

func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
   var maxSize = maxSizeKB
   var maxImageSize = maxImageLenght
   if (maxSize <= 0.0) {
       maxSize = 1024.0
   }

   if (maxImageSize <= 0.0)  {
       maxImageSize = 1024.0
   }

   //先调整分辨率

   var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
   let tempHeight = newSize.height / maxImageSize;
   let tempWidth = newSize.width / maxImageSize;
   if (tempWidth > 1.0 && tempWidth > tempHeight) {
       newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
   } else if (tempHeight > 1.0 && tempWidth < tempHeight){
       newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
   }
   UIGraphicsBeginImageContext(newSize)
   sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
   let newImage = UIGraphicsGetImageFromCurrentImageContext()
   UIGraphicsEndImageContext()
    var imageData = newImage!.jpegData(compressionQuality: 1.0)
   var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0
   //调整大小
   var resizeRate = 0.9
   while (sizeOriginKB > maxSize && resizeRate > 0.1) {
    imageData = newImage!.jpegData(compressionQuality: CGFloat(resizeRate))
       sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0
       resizeRate -= 0.1
   }
   return imageData!
  }

// 获取当前页面
func getCurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return getCurrentViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        return getCurrentViewController(base: tab.selectedViewController)
    }
    if let presented = base?.presentedViewController {
        return getCurrentViewController(base: presented)
    }
    return base
}


// 判断输入的字符串是否为数字，不含其它字符
func isPurnInt(string: String) -> Bool {
    let scan: Scanner = Scanner(string: string)
    var val:Int = 0
    return scan.scanInt(&val) && scan.isAtEnd
}

func judgeIsExamine() -> Bool{
    let isExamine = UserDefaults.standard.string(forKey: AccountInfo.isExamine)
    if (isExamine != nil && isExamine?.count != 0) {
        // 审核中
        if isExamine == "1" {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

// 判断2个时间段星期几的组合
//func judgeTwoDateWeek(_ startDateStr:String, _ endDateStr:String,_ startTime:String,_ endTime:String,_ weekStr:String) -> NSMutableArray {
//    var startDate = startDateStr.toDate(formatter: "yyyy-MM-dd")
//    let endDate = endDateStr.toDate(formatter: "yyyy-MM-dd")
//    DLog("-------:\(startDate) end:\(endDate)")
//
//    // Formatter for printing the date, adjust it according to your needs:
//    let fmt = DateFormatter()
//    fmt.dateFormat = "yyyy-MM-dd"
//
//    let calendar = NSCalendar.current
//
//    let regularTimeArray = NSMutableArray()
//    while startDate <= endDate {
//        let currentWeekStr = getweekDay(startDate)
//        
//        if weekStr.contains(currentWeekStr) {
//            var startTime:String = fmt.string(from: startDate) + " " + startTime
//            var endTime:String = fmt.string(from: startDate) + " " + endTime
//            startTime = stringToTimeStamp(stringTime: startTime, kAllFormatteryyyy_mm_dd_hh_mm)
////            let startTimeStamp:Double = (startTime as NSString).doubleValue
////            let startNum:NSNumber = NSNumber.init(value: startTimeStamp)
//            
//            endTime = stringToTimeStamp(stringTime: endTime, kAllFormatteryyyy_mm_dd_hh_mm)
////            let endTimeStamp:Double = (endTime as NSString).doubleValue
////            let endNum:NSNumber = NSNumber.init(value: endTimeStamp)
//            
//            let dic = ["startTimeAll":startTime,"endTimeAll":endTime] as [String : Any]
//            DLog("------judgeTwoDateWeekdic:\(dic)")
//
//            regularTimeArray.add(dic)
//        }
//        startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
//    }
//    
//    return regularTimeArray
//}

func createLabel(_ text:String,_ font:UIFont) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textAlignment = .left
    
    label.textColor = AppColor.rgb666
    
    return label
}

func createButton(_ text:String,_ font:UIFont,_ color:UIColor) -> UIButton {
    let btn = UIButton.init(type: .custom)
    btn.setTitle(text, for: .normal)
    btn.titleLabel?.font = font
    btn.titleLabel?.textAlignment = .center
    btn.setTitleColor(color, for: .normal)
    
    return btn
}

extension String{
    func sizeWithText(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
}

func getOrderString(_ orderStatus:String) ->String {
    //  orderStatus* 订单状态 1:待支付  2：取消支付 3：已经支付/等待老师确认 4老师取消课程 5：学生取消课程 6:老师已经确认课程  7：课程开始  8：课程结束
    switch orderStatus {
    case "1":
        return "待支付"
    case "2":
        return "取消支付"
    case "3":
        return "已支付"
    case "4":
        // 老师取消课程
        return "取消课程"
    case "5":
        // 学生取消课程
        return "取消课程"
    case "6":
        // 老师确认课程
        return "已确认"
    case "7":
        return "课程开始"
    case "8":
        return "课程结束"
    default:
        return ""
    }
}

func getJsonString(_ element:AnyObject) -> String {
//    if (!JSONSerialization.isValidJSONObject(dictionary)) {
//        DLog("无法解析出JSONString")
//        return ""
//    }
//    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
//    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
//    return JSONString! as String
    
    let jsonData = try! JSONSerialization.data(withJSONObject: element, options: JSONSerialization.WritingOptions.prettyPrinted)
    let str = String(data: jsonData, encoding: String.Encoding.utf8)!
    
//    BJDLog("---------转换json:\(str)")
    
    return str
}

//value 是AnyObject类型是因为有可能所传的值不是String类型，有可能是其他任意的类型。
func DYStringIsEmpty(_ value: AnyObject?) -> String {
    //首先判断是否为nil
    if (nil == value) {
        //对象是nil，直接认为是空串
        return ""
    }else{
        //然后是否可以转化为String
        if let myValue  = value as? String{
            //然后对String做判断
            if myValue == "" || myValue == "(null)" || myValue == "<null>" || 0 == myValue.count {
                return ""
            } else {
                return myValue
            }
        }else{
            if let a = value as? NSNumber {
                return a.stringValue
            } else {
                return ""
            }
        }
    }
}

func DStringIsEmpty(_ value: AnyObject?) -> String {
    //首先判断是否为nil
    if (nil == value) {
        //对象是nil，直接认为是空串
        return ""
    }else{
        //然后是否可以转化为String
        if let myValue  = value as? String{
            //然后对String做判断
            if myValue == "" || myValue == "(null)" || myValue == "<null>" || 0 == myValue.count {
                return ""
            } else {
                return myValue
            }
        }else{
            if let a = value as? NSNumber {
                return a.stringValue
            } else {
                return ""
            }
        }
    }
}

func encoder<T>(toDictonry model:T) ->[String:Any]? where T:Encodable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let data = try?encoder.encode(model) else {
        return nil
    }
    
    guard let dict = try?JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as?[String:Any] else {
        return nil
    }
    return dict
}

//获取字符串尺寸
func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
    if str != nil {
        let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: PingFangMedium(font)], context: nil).size
        return strSize
    }
    
    if attriStr != nil {
        let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
        return strSize
    }
    
    return CGSize.zero
}


func getNormalStrH(_ str: String,_ strFont: CGFloat,_ w: CGFloat) -> CGFloat {
    return getNormalStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
}


func getAttributedStrH(attriStr: NSMutableAttributedString, strFont: CGFloat, w: CGFloat) -> CGFloat {
    return getNormalStrSize(attriStr: attriStr, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
}

// 图片颜色
//func changeImgColor(_ imageView:UIImageView,_ imageName:String) {
//    let image:UIImage = UIImage.init(named: imageName)!
//    imageView.image =         image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//    imageView.tintColor = AppColor.themeYellow
//}

// 导航栏颜色
func navChangeColor(_ name:String) ->UIImage {
    var image:UIImage = UIImage.init(named: name)!
    image = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    return image
}

//获取缓存大小(单位M)
func getFileSizeOfCache()-> Int {
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    //缓存目录路径
    //DLog(cachePath)
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    //快速枚举出所有文件名 计算文件大小
    var size = 0
    for file in fileArr! {
        // 把文件名拼接到路径中
        let path = cachePath?.appending("/\(file)")
        // 取出文件属性
        let floder = try! FileManager.default.attributesOfItem(atPath: path!)
        // 用元组取出文件大小属性
        for (abc, bcd) in floder {
            // 累加文件大小
            if abc == FileAttributeKey.size {
                size += (bcd as AnyObject).integerValue
            }
        }
    }
    
    let mm = size / 1024 / 1024
    
    return mm
}

// 清除缓存
func clearCaches(){
    do {
        try deleteLibraryFolderContents(folder: "Caches")
        //DLog("clear done")
    } catch {
        //DLog("clear Caches Error")
    }
}

func getPriceIntOrFloat(_ price:Int) ->String {
    if price % 100 == 0 {
        BJDLog("============「整数」")
        // 元
        return String.init(format: "%d", price/100)
    } else if ((price % 100) % 10 == 0) {
        // 角
//        BJDLog("============「一位小数」")
        return String.init(format: "%.1f", (Double(price)/100.0))
    } else {
        // 分
//        BJDLog("============「两位小数」")
        return String.init(format: "%.2f", Double(price)/100)
    }
}

//func isHaveDecimalPoint(_ price:Int) ->Bool {
//    if price % 100 == 0 {
//        DLog("-----「没有小数点」")
//        return false
//    } else {
//        DLog("-----「有小数点」")
//        return true
//    }
//}


func stretchableImage(_ img:UIImage) -> UIImage {
    let leftCapWidth: Int = Int(img.size.width / 2)
    // 取图片Width的中心点
    let topCapHeight: Int = Int(img.size.height / 2)
    // 取图片Height的中心点

    let image:UIImage = img.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
    // 拉伸
    
    return image
}

@MainActor func kfSetImage(_ headImg:UIImageView,_ url:URL,_ ratio:CGFloat) {
    headImg.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (result) in
        if headImg.image != nil {
            let image:UIImage = headImg.image!
            let image2 = image.crop(ratio: ratio)
            headImg.image = image2
        }
    }
}


//func browsePhoto(_ imageArray:NSMutableArray,_ currentPage:Int) {    
//    var arr = NSMutableArray()
//    imageArray.enumerateObjects { (obj, index, stop) in
//        let objText:String = obj as! String
//        if (objText.hasSuffix(".mp4")&&(objText.hasPrefix("http"))) {
//            // 网络视频
//            let data = YBIBVideoData()
//            data.allowSaveToPhotoAlbum = false
//            data.videoURL = URL.init(string: objText)
//            arr.add(data)
//        } else if (objText.hasSuffix(".mp4")) {
//            // 本地视频
//            let path = Bundle.main.path(forResource: objText, ofType: "")
//            let data = YBIBVideoData()
//            data.allowSaveToPhotoAlbum = false
//            data.videoURL = URL.init(fileURLWithPath: path!)
//            arr.add(data)
//        } else if (objText.hasPrefix("http")) {
//            // 网络图片
//            let data = YBIBImageData()
//            data.allowSaveToPhotoAlbum = false
//            data.imageURL = NSURL.init(string: objText) as URL?
////                data.projectiveView = [self viewAtIndex:idx];
//            arr.add(data)
//        } else {
//            // 本地图片
//            let data = YBIBImageData()
//            data.allowSaveToPhotoAlbum = false
//            data.imageName = objText
////                data.projectiveView =
//            arr.add(data)
//        }
//    }
//    
//    let browser = YBImageBrowser()
//    browser.dataSourceArray = arr as! [YBIBDataProtocol]
//    browser.currentPage = currentPage
////        browser.defaultToolViewHandler?.topView.operationType = .save
//    browser.show()
//}

//func jumpVcInType(_ jumpType:String,_ val:String,_ vc:UIViewController,_ isOrder:Bool = false) {
//    // // COURSE 课程 ，TEACHER 老师， ACTIVITY 活动 ，WEB h5 ，OTHER 其他   对应字段jumptype
//    switch jumpType {
//    case "COURSE":
//        let detailVc = DPHomeDetailController()
//        detailVc.courseListId = val
//        vc.navigationController?.pushViewController(detailVc, animated: true)
//        break
//    case "TEACHER":
//        let teacherDetailVc = DPUserSeeTeacherController()
//        teacherDetailVc.teacherNumber = val
////        teacherDetailVc.teacherId = result.teacherId
//        vc.navigationController?.pushViewController(teacherDetailVc, animated: true)
//        break
//    case "ACTIVITY","WEB","OTHER":
//        if val.count != 0 {
//            let htmlVc = PPWLHtmlController()
//            htmlVc.type = -1
//            htmlVc.htmlUrl = val
//            vc.navigationController?.pushViewController(htmlVc, animated: true)
//        }
//        break
//    default:
//        break
//    }
//}

extension String {
    ///MD5 加密
    func md5() -> String {
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
 
 
    ///sha1 加密
    func sha1() -> String {
        //UnsafeRawPointer
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        let newData = NSData.init(data: data)
        CC_SHA1(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}

extension UserDefaults { //1
    func saveCustomObject(_ object:NSCoding,_ key:String) { //2
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        self.set(encodedObject, forKey: key)
        self.synchronize()
    }
 
    func getCustomObject(_ key:String) -> AnyObject? { //3
        let decodedObject = self.object(forKey: key) as? NSData
 
        if let decoded = decodedObject {
            let object = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data)
            return object as AnyObject
        }
 
        return nil
    }
}

import UIKit

@discardableResult
func changeSubText(_ mainStr:String,_ subStr:String,_ subColor:UIColor) -> NSMutableAttributedString{
    let range = (mainStr as NSString).range(of: subStr)
    let attributedString = NSMutableAttributedString(string:mainStr)
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: subColor , range: range)
    
    return attributedString
}

extension UIImage {
    /// 将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        /// 计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        /// 图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
    
    // 图片压缩到指定大小
    func scaleToSize(size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

