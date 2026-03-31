//
//  PKBaseView.swift
//  Pick记账
//
//  Created by eagle on 2023/6/8.
//

import UIKit

class PKBaseView: UIView {
    
    /// 来源,
    /// 如果涉及到动态传参, 即 可能通过 'push(className: String, parameters: [String: Any]?)' 方法传递的参数, 都要加上此前缀
    @objc dynamic var parentPath: String = ""
    
    /// 埋点对应的 page_name, 子类根据具体实现, 有值就会去实现'PKEventTrack.pageEvent'
    var pageName: String? {
        nil
    }
    
    ///埋点中对应的追加参数值.子类根据具体实现,
    var appendEventDict: [String: Any]? {
        nil
    }
    
    ///埋点中对应的追加参数值.子类根据具体实现,
    var cl_source: String? {
        nil
    }
    
//    func eventClick(target: String) {
//        if let pageName = pageName {
//            PKEventTrack.clickEvent(pageName: pageName, target: target, source: cl_source, appendEventDict: appendEventDict)
//        }
//    }
//    
//    func eventPage() -> Void {
//        if let pageName = pageName {
//            PKEventTrack.pageEvent(pageName: pageName, source: cl_source, appendEventDict: appendEventDict)
//        }
//    }
    
    deinit {
        tkRemoveNotification_kit(observer: self)
    }
    
    open class func build(xibName: String? = nil) -> Self {
        var xib = xibName
        if xib == nil {
            xib = String(describing: self)
        }
        // 从info.plist读取namespace
        let path = Bundle.main.path(forResource: xib, ofType: "nib")
        
        guard let path = path, !path.isEmpty else { return self.init()}
        
        return Bundle.main.loadNibNamed(xib!, owner: nil, options: nil)?.last as! Self
    }
    
}
