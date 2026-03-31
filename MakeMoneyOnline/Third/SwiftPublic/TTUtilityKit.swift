//
//  TTUtility.swift
//  SwiftDemo
//
//  Created by tangbowen on 2020/4/29.
//  Copyright © 2020 tangbowen. All rights reserved.
//

import UIKit
import SwifterSwift
//#if DEBUG
//    import CocoaDebug
//#endif

let tkDevice_Width_kit = UIScreen.main.bounds.width
let tkDevice_Height_kit = UIScreen.main.bounds.height

typealias voidClosure = (() ->Void)
typealias optionVoidClosure = (()->Void)?
typealias boolClosure = ((Bool) -> Void)
typealias optionBoolClosure = ((Bool) -> Void)?

public func DLog_kit<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\n<=====> \(Date())  \(fileName) (line: \(lineNum)): \(message)\n")
//        let logText:String = ">>> \(Date())  \(fileName) (line: \(lineNum)): \(message)\n"
    
//    _OCLogHelper.shared().handleLog(withFile: "", function: "", line: 0, message: logText, color: UIColor(hexString: "#99DAFF"), type: .none)

    #endif
}

public func tkPostNotification_kit(name: NSNotification.Name, obj:Any? = nil) {
    NotificationCenter.default.post(name: name, object: obj)
}

public func tkAddNotification_kit(observer: Any, selector:Selector,name: NSNotification.Name,obj: Any? = nil) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: obj)
}

public func tkRemoveNotification_kit(observer: Any){
    NotificationCenter.default.removeObserver(observer)
}

public func tkStatusBarHeight_kit() -> CGFloat {
    if #available(iOS 13, *) {
        let window = tkCurrentWindow()
        var height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        if height == 0 {
            height = window?.safeAreaInsets.top ?? 0.0
        }
        return height
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

public func tkSafeAreaBottom_kit() -> CGFloat {
    if let window = tkCurrentWindow() {
        if #available(iOS 11.0, *) {
            return window.safeAreaInsets.bottom
        }
        return 0
    }
    return 0
}

public func tkIsFullScreenIphone_kit() -> Bool {
    let bottom = tkSafeAreaBottom_kit()
    return bottom > 0
}

public func tkIsPhone_kit() -> Bool {
    return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
}

func tkRandowColor_kit() -> UIColor {
    return tkRandowColor_kit(alpha: 1.0)
}

func tkRandowColor_kit(alpha: CGFloat) -> UIColor {
    let rValue = arc4random() % 255
    let gValue = arc4random() % 255
    let bValue = arc4random() % 255
    return UIColor(red: CGFloat(rValue)/255.0, green: CGFloat(gValue)/255.0, blue: CGFloat(bValue)/255.0, alpha: alpha)
}

public func tkColor_kit(hex: String, alpha: CGFloat = 1) -> UIColor {
    return UIColor(hex_kit: hex, alpha: alpha)
}

public func tkColor_kit(r:CGFloat, g:CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: alpha)
}

func tkDoucumentPath_kit() -> String {
    let string = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    return string
}

func tkCachePath_kit() -> String {
    let string = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    return string
}

func tkCachePathAppend_kit(_ string: String) -> String {
    guard !tkCachePath_kit().isEmpty else { return "" }
    
    let home = tkCachePath_kit() as NSString
    let path = home.appendingPathComponent(string)
    return path
}

func tkDoucumentPathAppend_kit(_ string: String) -> String {
    guard !tkDoucumentPath_kit().isEmpty else { return "" }
    
    let home = tkDoucumentPath_kit() as NSString
    let path = home.appendingPathComponent(string)
    return path
}

/// 获取当前VC, 不支持多窗口, 如果实现了SceneDelegate 则无法使用此方法查找, rootViewController的获取不同
func tkCurrentViewControllerKit_kit() -> UIViewController? {
    var vc = tkCurrentWindow()?.rootViewController
    while true {
        if let nav = vc as? UINavigationController {
            vc = nav.visibleViewController
        }
        if let tab = vc as? UITabBarController {
            vc = tab.selectedViewController
        }
        if let present = vc?.presentedViewController {
            vc = present
        }
        if !(vc?.isKind(of: UITabBarController.self) ?? false || vc?.isKind(of: UINavigationController.self) ?? false || vc?.presentedViewController != nil) {
            break
        }
    }
    return vc
}

extension UIColor {
    convenience init(hex_kit: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex_kit.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    convenience init(_ r_kit: CGFloat, g_kit: CGFloat, b_kit: CGFloat, alpha:CGFloat = 1) {
        self.init(red: r_kit / 255.0, green: r_kit/255.0, blue:r_kit/255.0, alpha: alpha)
    }
}

extension NSObject: TTNamespaceWrappable{}
extension TTTypeWrapperProtocol where WrappedType: NSObject{
    
    func className_kit() -> String{
        let cls = type(of: wrappedValue)
        return NSStringFromClass(cls)
    }
    
}

extension Array {
    
    func jsonString_kit(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
}
//extension Array :TTNamespaceWrappable{}
//extension TTTypeWrapperProtocol where WrappedType == Array<Any> {
//
//    func jsonString(prettify: Bool = false) -> String? {
//        guard JSONSerialization.isValidJSONObject(wrappedValue) else { return nil }
//        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: wrappedValue, options: options) else { return nil }
//        return String(data: jsonData, encoding: .utf8)
//    }
//}

extension Date: TTNamespaceWrappable{}
extension TTTypeWrapperProtocol where WrappedType ==  Date {
    /// 获取相隔多少个自然天
    func daysSince_kit(_ toDate: Date) -> Int {
        // 因为系统的计算方法, 相隔的两天如果有一天不足24小时是不会算入其中,所以手动将时间设为0:00 来进行比较
        let startDate = wrappedValue.tt.beginning_kit(of: .day)
        let endData = toDate.tt.beginning_kit(of: .day)
        guard let finalSd = startDate, let finalEnd = endData else { return 0 }
        let components = Calendar.current.dateComponents([.day], from: finalSd, to: finalEnd)
        return components.day ?? 0
    }
    
    func beginning_kit(of component: Calendar.Component) -> Date? {
        let calender = Calendar.current
        if component == .day {
            return calender.startOfDay(for: wrappedValue)
        }
        var components: Set<Calendar.Component> {
            switch component {
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]

            case .minute:
                return [.year, .month, .day, .hour, .minute]

            case .hour:
                return [.year, .month, .day, .hour]

            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]

            case .month:
                return [.year, .month]

            case .year:
                return [.year]

            default:
                return []
            }
        }

        guard !components.isEmpty else { return nil }
        return calender.date(from: calender.dateComponents(components, from: wrappedValue))
    }
}

extension String: TTNamespaceWrappable{}
extension TTTypeWrapperProtocol where WrappedType ==  String {
    
    /// json 字符串数
    func jsonToArray_kit<T>(elementsType: T.Type)->Array<T>{
        
        let arr = [T]()
        do{
            
            let data = wrappedValue.data(using: String.Encoding.utf8)!
            //把NSData对象转换回JSON对象
            let json : Any! = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
            return json as! [T]
        }catch{
            return arr
        }
        
    }
    
    func transformToPinYin_kit() -> String {
        
        let mutableString = NSMutableString(string: wrappedValue)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        //去掉空格
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    /// NSRange转化为range
    func range_kit(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = wrappedValue.utf16.index(wrappedValue.utf16.startIndex, offsetBy: nsRange.location, limitedBy: wrappedValue.utf16.endIndex),
            let to16 = wrappedValue.utf16.index(from16, offsetBy: nsRange.length, limitedBy: wrappedValue.utf16.endIndex),
            let from = String.Index(from16, within: wrappedValue),
            let to = String.Index(to16, within: wrappedValue)
            else { return nil }
          return from ..< to
    }
    
    /// range转换为NSRange
    func nsRange_kit(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: wrappedValue)
    }
    
    func boundingSize_kit(maxSize: CGSize, font: UIFont) -> CGSize {
        let nsStr = wrappedValue as NSString
        return nsStr.boundingRect(with: maxSize, options: [NSStringDrawingOptions.usesFontLeading, NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    /// 根据给定的最大字节长度, 返回截取过的字符串, 注意是字节长度, 比如一个汉字一般占3个字节
    func truncateString_kit(with maxbyteLength: Int) -> String {
        let utf8 = wrappedValue.utf8
        if utf8.count <= maxbyteLength {
            return wrappedValue
        } else {
            let endIndex = utf8.index(utf8.startIndex, offsetBy: maxbyteLength)
            let truncatedSubstring = wrappedValue[..<endIndex]
            return String(truncatedSubstring)
        }
    }

}

extension TTTypeWrapperProtocol where WrappedType: NSLayoutConstraint {
    
    func add_kit(_ x: CGFloat) {
        wrappedValue.constant += x
    }
    
    func mutiply_kit(_ x: CGFloat) {
        wrappedValue.constant = wrappedValue.constant * x
    }
    
}

extension TTTypeWrapperProtocol where WrappedType: UIView {
    
    func scale_kit(to offset: CGPoint, animation: Bool = false, duration: TimeInterval = 0.35, completion: ((Bool) -> Void)?) {
        if animation {
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options:[], animations: {
                //
                self.wrappedValue.transform = CGAffineTransform(scaleX: offset.x, y: offset.y)
                self.wrappedValue.layoutIfNeeded()
            }, completion: completion)
        } else {
            wrappedValue.transform = CGAffineTransform(scaleX: offset.x, y: offset.y)
            wrappedValue.layoutIfNeeded()
        }
    }
    
    func zoomInAnimation_kit(duration: TimeInterval = 0.35, startClosure: optionVoidClosure = nil, progress: optionVoidClosure = nil, completion: ((Bool) -> Void)?)  {
        tkDispatch_safe_main_queue {
            self.wrappedValue.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            if let start = startClosure {
                start()
            }
            self.wrappedValue.layoutIfNeeded()
            UIView.animate(withDuration: duration,
                            delay: 0,
                            usingSpringWithDamping: 0.7,
                            initialSpringVelocity: 5,
                            options: [],
                            animations: {
                                if let progress = progress {
                                    progress()
                                }
                                self.wrappedValue.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                self.wrappedValue.layoutIfNeeded()
            }, completion: completion)
        }
    }
    
    func zoomOutAnimation_kit(duration: TimeInterval = 0.35 , startClosure: optionVoidClosure = nil, progress: optionVoidClosure = nil, completion: ((Bool) -> Void)? = nil) {
        tkDispatch_safe_main_queue {
            if let startClosure = startClosure {
                startClosure()
            }
            UIView.animate(withDuration: 0.35, animations: {
                if let progress = progress {
                    progress()
                }
                self.wrappedValue.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
                self.wrappedValue.alpha = 0;
                self.wrappedValue.layoutIfNeeded()
            }, completion: completion)
        }
    }
    
    func shake_kit() {
        let keyAnimaiton = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let shakeWidth = 16.0
        keyAnimaiton.values = [-shakeWidth, 0, shakeWidth, 0, -shakeWidth, 0, shakeWidth, 0]
        keyAnimaiton.duration = 0.1
        keyAnimaiton.repeatCount = 2
        keyAnimaiton.isRemovedOnCompletion = true
        wrappedValue.layer.add(keyAnimaiton, forKey: "shake")
        
    }
     /// 设置圆角
    func setupConnerRadius_kit(_ radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat = 0) {
        wrappedValue.layer.masksToBounds = true
        wrappedValue.layer.cornerRadius = radius
        wrappedValue.layer.borderWidth = borderWidth
        wrappedValue.layer.borderColor = borderColor?.cgColor
    }
    
    func screenShot_kit(size: CGSize = CGSize.zero) -> UIImage? {
        var targetSize = size
        if size == CGSize.zero {
            targetSize = wrappedValue.frame.size
        }
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        wrappedValue.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /// 添加一个边缘拖动手势
    @discardableResult
    func addScreenEdgePanGesture_kit(_ target: Any? = nil, action: Selector) -> UIScreenEdgePanGestureRecognizer {
        self.addGesture_kit(target, action: action, cls: UIScreenEdgePanGestureRecognizer.self) as! UIScreenEdgePanGestureRecognizer
    }
    /// 添加一个长按手势
    @discardableResult
    func addLongPressGesture_kit(_ target: Any? = nil, action: Selector) -> UILongPressGestureRecognizer {
        self.addGesture_kit(target, action: action, cls: UILongPressGestureRecognizer.self) as! UILongPressGestureRecognizer
    }
    /// 添加一个捏合手势
    @discardableResult
    func addPinGesture_kit(_ target: Any? = nil, action: Selector) -> UIPinchGestureRecognizer {
        self.addGesture_kit(target, action: action, cls: UIPinchGestureRecognizer.self) as! UIPinchGestureRecognizer
    }
    /// 添加一个旋转手势
    @discardableResult
    func addRotationGesture_kit(_ target: Any? = nil, action: Selector) -> UIRotationGestureRecognizer {
        self.addGesture_kit(target, action: action, cls: UIRotationGestureRecognizer.self) as! UIRotationGestureRecognizer
    }
    /// 添加一个轻扫手势
    @discardableResult
    func addSwipeGesture_kit(_ target: Any? = nil, action : Selector) -> UISwipeGestureRecognizer {
        self.addGesture_kit(target, action: action, cls: UISwipeGestureRecognizer.self) as! UISwipeGestureRecognizer
    }
    /// 添加一个拖动手势
    @discardableResult
    func addPanGesture_kit(_ target: Any? = nil, action: Selector) -> UIPanGestureRecognizer {
        self.addGesture_kit(target, action: action, cls: UIPanGestureRecognizer.self) as! UIPanGestureRecognizer
    }
    /// 添加一个点击手势
    @discardableResult
    func addTapGesture_kit(_ target: Any? = nil, action: Selector) -> UITapGestureRecognizer {
         self.addGesture_kit(target, action: action, cls: UITapGestureRecognizer.self) as! UITapGestureRecognizer
    }
    
    ///添加手势     `@discardableResult` 用来告知编辑器结果外部可以不用接收, 否则编辑器会报黄
    @discardableResult
    func addGesture_kit(_ target: Any? = nil,  action: Selector, cls: UIGestureRecognizer.Type) -> UIGestureRecognizer {
        var obj = target
        if target == nil {
            obj = wrappedValue
        }
        wrappedValue.isUserInteractionEnabled = true
        let ges = cls.init(target: obj, action: action)
        wrappedValue.addGestureRecognizer(ges)
        return ges
    }
}

// MARK: - UIButton
extension UIButton {
    enum DistributionStyle_kit:Int {
        case imageTop = 0, imageLeft, imageBottom, imageRight
    }
    
    func layoutButton_kit(distributionStyle: DistributionStyle_kit, space: CGFloat) {
        
        let imageWidth = self.currentImage?.size.width ?? 0;
        let imageHeight = self.currentImage?.size.height ?? 0;
        let labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0;
        let labelHeight = self.titleLabel?.intrinsicContentSize.width ?? 0;
        
        var imageEdgeInsets = UIEdgeInsets()
        var labelEdgeInsets = UIEdgeInsets()
        switch distributionStyle {
        case .imageTop:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-space/2.0, right: 0)
        case .imageLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
        case .imageBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWidth, bottom: 0, right: 0)
        case .imageRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-space/2.0, bottom: 0, right: imageWidth+space/2.0)
            
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}

extension TTTypeWrapperProtocol where WrappedType: UIButton {
    
    func setImageNamed_kit(_ imageName: String, state: UIButton.State = .normal) {
        let image = UIImage(named: imageName)
        wrappedValue.setImage(image, for: state)
    }
    
    func setNormalImageNamed_kit(_ imageName: String) {
        self.setImageNamed_kit(imageName, state: .normal)
    }
    
    func setSelectedImageNamed_kit(_ imageName: String) {
        self.setImageNamed_kit(imageName, state: .selected)
    }
}

extension TTTypeWrapperProtocol where WrappedType: UIButton {
    
    /// 以拉伸部分区域的形式去改变图片, isBackground默认值为true
    func updateImageForScretch_kit(state: UIButton.State, isBackground: Bool = true) {
        var image = isBackground ? wrappedValue.backgroundImage(for: state) :wrappedValue.image(for: state)
        image = image?.tt.resizableImageForStretch_kit()
        if isBackground {
            wrappedValue.setImage(image, for: state)
        } else {
            wrappedValue.setImage(image, for: state)
        }
    }
}
// MARK: - UIImage
extension TTTypeWrapperProtocol where WrappedType: UIImage {
    
     func resizableImageForStretch_kit() -> UIImage {
        let hor = wrappedValue.size.width * 0.5 - 1
        let ver = wrappedValue.size.height * 0.5 - 1
        return wrappedValue .resizableImage(withCapInsets: UIEdgeInsets(top: ver, left: hor, bottom: ver, right: hor),
                                            resizingMode: .stretch)
        
    }
    
    /// 修改图片颜色
    func render_kit(color:UIColor) -> UIImage? {
        guard let cgImage = wrappedValue.cgImage else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(wrappedValue.size, true, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: wrappedValue.size.width, height: wrappedValue.size.height)
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -area.size.height)
        ctx?.saveGState()
        ctx?.clip(to: area, mask: cgImage)
        color.set()
        ctx?.fill(area)
        ctx?.restoreGState()
        ctx?.setBlendMode(.multiply)
        ctx?.draw(cgImage, in: area)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    func resizeImage_kit(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension TTTypeWrapperProtocol where WrappedType: UIImageView {
    
    func resizableImageForStretch_kit() {
        wrappedValue.image = wrappedValue.image?.tt.resizableImageForStretch_kit()
    }
}

extension TTTypeWrapperProtocol where WrappedType: UITextField {
    
    func setPlaceholder_kit(_ placeholder: String, hexColor: String) {
        
        let attribute = NSMutableAttributedString(string: placeholder)
        
        attribute.addAttributes([NSMutableAttributedString.Key.foregroundColor: tkColor_kit(hex: hexColor)], range: NSRange(location: 0, length: attribute.length))
        if let font = wrappedValue.font {
            attribute.addAttributes([NSMutableAttributedString.Key.font: font], range: NSRange(location: 0, length: attribute.length))
        }
        wrappedValue.attributedPlaceholder = attribute
    }
    
}

// MARK: - UITableView
extension TTTypeWrapperProtocol where WrappedType: UITableView {
    
    func register_kit(nibCellClass cls: AnyClass, identifier: String? = nil) {
        let nibName = String(describing: cls)//NSStringFromClass(cls)
//        nibName = nibName.removingPrefix(TTUtility.spaceName()! + ".")
        let reid = identifier  == nil ? nibName: identifier!
        wrappedValue.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: reid)
    }
}

extension UITableViewCell {
    class var cellIdentifier_kit: String {
        let name = String(describing: self)//NSStringFromClass(self)
//        name = name.removingPrefix(TTUtility.spaceName()! + ".")
        return name
    }
//    class var cellHeight: CGFloat {
//        return 0
//    }
}

// MARK: - UICollectionView
extension TTTypeWrapperProtocol where WrappedType: UICollectionView {
    
    func register_kit(nibCellClass nibClass: AnyClass, identifier: String? = nil) {
        let nibName = String(describing: nibClass)//NSStringFromClass(nibClass)
//        nibName = nibName.removingPrefix(TTUtility.spaceName()! + ".")
        var reid:String
        if identifier == nil {
            reid = nibName
        } else {
            reid = identifier!
        }
        wrappedValue.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: reid)
    }
    
    func register_kit(supplementaryClass nibClass: AnyClass, isHeader: Bool = true, identifier: String? = nil) {
        let nibName = String(describing: nibClass)//NSStringFromClass(nibClass)
//        nibName = nibName.removingPrefix(TTUtility.spaceName()! + ".")
        let kind = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        let reid = identifier == nil ? nibName  : identifier!
        wrappedValue.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reid)
        
    }
}

extension UICollectionReusableView {
    
    class var reuseableViewIdentifier_kit: String {
        let name = String(describing: self)//NSStringFromClass(self)
//        name = name.removingPrefix(TTUtility.spaceName()! + ".")
        return name
    }
}
extension Bundle {
        
    static var appName_kit: String {
        let dic = main.infoDictionary
        var name = dic?["CFBundleDisplayName"] as? String
        if name == nil {
            name = dic?["CFBundleName"] as? String
        }
        let nm = name ?? ""
        return nm
    }
    
    static var appVersion_kit: String {
        let dic = main.infoDictionary
        let version = dic?["CFBundleShortVersionString"] as? String
        return version ?? ""
    }
    
    static var buildVersion_kit: String {
        let dic = main.infoDictionary
        let version = dic?["CFBundleVersion"] as? String
        return version ?? ""
    }
    
    static func iconImage_kit() -> UIImage? {
        if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIconDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIconDictionary["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            let icon = UIImage(named: lastIcon)
            // 在这里使用获取到的图标（icon）
            return icon
        }
        return nil
    }
}

// MARK: - UICollectionViewCell
extension UICollectionViewCell {
    class var cellIdentifier_kit: String {
        let name = String(describing: self)//NSStringFromClass(self)
//        name = name.removingPrefix(TTUtility.spaceName()! + ".")
        return name
    }
    @objc class var itemHeight_kit: CGFloat {
        return 0
    }
    @objc class var itemSize_kit: CGSize {
        return CGSize.zero
    }
}

extension DispatchTime: @retroactive ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: @retroactive ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

class TTUtility: NSObject {
    // 获取命名空间
    class func spaceName_kit() -> String? {
        guard let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }
        return spaceName
    }
    
    static func setValueInUserDefault_kit(_ value: Any?, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func valueInUserDefault_kit(_ key: String) -> Any? {
        UserDefaults.standard.object(forKey: key)
    }
    
    static func removeValueInUserDefault_kit(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /* *  @param inputMsg 二维码保存的信息
       *  @param fgImage  前景图片  */
   static func generateQRCode_kit(inputMsg: String, fgImage: UIImage?) -> UIImage {
        //1. 将内容生成二维码
        //1.1 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //1.2 恢复默认设置
        filter?.setDefaults()
        
        //1.3 设置生成的二维码的容错率
        //value = @"L/M/Q/H"
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        // 2.设置输入的内容(KVC)
        // 注意:key = inputMessage, value必须是NSData类型
        let inputData = inputMsg.data(using: .utf8)
        filter?.setValue(inputData, forKey: "inputMessage")
        
        //3. 获取输出的图片
        guard let outImage = filter?.outputImage else { return UIImage() }
        
        //4. 获取高清图片
        let hdImage = getHDImage_kit(outImage)
        
        //5. 判断是否有前景图片
        if fgImage == nil{
            return hdImage
        }
        
        //6. 获取有前景图片的二维码
        return getResultImage_kit(hdImage: hdImage, fgImage: fgImage!)
    }
    
    //4. 获取高清图片
    fileprivate static func getHDImage_kit(_ outImage: CIImage) -> UIImage {
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        //放大图片
        let ciImage = outImage.transformed(by: transform)
        
        return UIImage(ciImage: ciImage)
    }
    
    //获取前景图片
    fileprivate static func getResultImage_kit(hdImage: UIImage, fgImage: UIImage) -> UIImage {
        let hdSize = hdImage.size
        //1. 开启图形上下文
        UIGraphicsBeginImageContext(hdSize)
        
        //2. 将高清图片画到上下文
        hdImage.draw(in: CGRect(x: 0, y: 0, width: hdSize.width, height: hdSize.height))
        
        //3. 将前景图片画到上下文
        let fgWidth: CGFloat = 80
        fgImage.draw(in: CGRect(x: (hdSize.width - fgWidth) / 2, y: (hdSize.height - fgWidth) / 2, width: fgWidth, height: fgWidth))
        
        //4. 获取上下文
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        
        //5. 关闭上下文
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
}


 ///命名空间部分
public protocol TTNamespaceWrappable {
    associatedtype WrapperType
    var tt: WrapperType { get }
//    static var tt: WrapperType.Type { get }
}

public extension TTNamespaceWrappable {
    var tt: TTNamespaceWrapper<Self> {
        return TTNamespaceWrapper(value: self)
    }

//    static var tt: TTNamespaceWrapper<Self>.Type {
//        return TTNamespaceWrapper.self
//    }
}

public protocol TTTypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct TTNamespaceWrapper<T>: TTTypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

// FIXME: ---- 注：表情包的处理逻辑
extension String {
    /// 是否为单个emoji表情
    var isSingleEmoji_kit: Bool {
        return count == 1 && containsEmoji_kit
    }

    /// 包含emoji表情
    var containsEmoji_kit: Bool {
        return contains{ $0.isEmoji_kit}
    }

    /// 只包含emoji表情
    var containsOnlyEmoji_kit: Bool {
        return !isEmpty && !contains{!$0.isEmoji_kit}
    }

    /// 提取emoji表情字符串
    var emojiString_kit: String {
        return emojis_kit.map{String($0) }.reduce("",+)
    }

    /// 提取emoji表情数组
    var emojis_kit: [Character] {
        return filter{ $0.isEmoji_kit}
    }

    /// 提取单元编码标量
    var emojiScalars_kit: [UnicodeScalar] {
        return filter{ $0.isEmoji_kit}.flatMap{ $0.unicodeScalars}
    }
}

// FIXME: ---- 注：表情包的处理逻辑
extension Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji_kit: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else{
            return false
        }
        return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation ||
                firstProperties.generalCategory == .otherSymbol)
    }

    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji_kit: Bool {
        return unicodeScalars.count > 1 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否为emoji表情
    var isEmoji_kit:Bool{
        return isSimpleEmoji_kit || isCombinedIntoEmoji_kit
    }
}


public extension UIColor {
    /// 主色(深粉色)
    static let darkPinkKitColor = UIColor(hex: 0xFF65BB)
    /// 浅粉色
    static let lightPinkKitColor = UIColor(hex: 0xFFAAE1)
    /// 红色
    static let redKitColor = UIColor(hex: 0xfd2353)
    /// 按钮颜色
    static let btnKitColor = UIColor(hex: 0xFE597F)
    /// 大的标题颜色
    static let bigTitleKitColor = UIColor(hex: 0x471B27)
    /// 小标题
    static let smallTitleKitColor = UIColor(hex: 0x272727)
    /// 灰色
    static let grayKitColor = UIColor(hex: 0xB3B3B3)
}
