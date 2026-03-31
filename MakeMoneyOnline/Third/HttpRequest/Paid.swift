//
//  Paid.swift
//  Travel
//
//  Created by Pick记账 on 2025/4/14.
//

import Darwin // 导入系统底层库
import Foundation

class Paid {
    // 使用 lazy 实现更简洁的懒加载
    lazy var paid: String = {
        let fileTime = self.getFileTime().md5Value
        let update = self.getSysU().md5Value
        let bootTime = self.bootTimeInSec.md5Value
        return "\(fileTime)-\(update)-\(bootTime)".lowercased()
    }()
    
    /// 获取系统更新时间 (转换为 Swift)
    func getSysU() -> String {
        // 1. Base64 解码路径信息
        let base64String = "L3Zhci9tb2JpbGUvTGlicmFyeS9Vc2VyQ29uZmlndXJhdGlvblByb2ZpbGVzL1B1YmxpY0luZm8vTUNNZXRhLnBsaXN0"
        guard let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
              let filePath = String(data: data, encoding: .utf8) else {
            return ""
        }
        
        // 2. 获取文件属性
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            
            // 3. 提取创建日期
            if let creationDate = fileAttributes[.creationDate] as? Date {
                // 4. 转换为时间戳字符串 (保留6位小数)
                let timestamp = creationDate.timeIntervalSince1970
                return String(format: "%.6f", timestamp)
            }
        } catch {
            DLog_kit("获取文件属性失败: \(error.localizedDescription)")
        }
        
        return ""
    }
    
    var bootTimeInSec: String {
        return String(bootSecTime()) // 假设 bootSecTime() 返回 Int 或类似类型
    }

    /// 系统启动时间
    private func bootSecTime() -> time_t {
        var mib = [CTL_KERN, KERN_BOOTTIME] as [Int32]
        var bootTime = timeval()
        var size = MemoryLayout.size(ofValue: bootTime)
        
        let result = sysctl(
            &mib,
            u_int(mib.count),
            UnsafeMutableRawPointer(&bootTime),
            &size,
            nil,
            0
        )
        
        return result == 0 ? bootTime.tv_sec : 0
    }
    
    /// 获取设备初始化时间（/var/mobile 目录的创建时间戳）
    func getFileTime() -> String {
        var fileStat = stat() // 创建 stat 结构体实例
        let path = "/var/mobile" // 目标路径
        
        // 调用 stat 函数获取文件信息
        let result = stat(path, &fileStat)
        
        guard result == 0 else {
            DLog_kit("获取文件信息失败，错误码: \(result)")
            return ""
        }
        
        // 提取时间戳（tv_sec 秒 + tv_nsec 纳秒）
        let birthTime = fileStat.st_birthtimespec
        return String(format: "%ld.%09ld", birthTime.tv_sec, birthTime.tv_nsec)
    }


}

import CommonCrypto

extension String {
    var md5Value: String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}


