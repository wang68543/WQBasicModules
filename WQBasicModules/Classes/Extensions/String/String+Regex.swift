//
//  WQString+Date.swift
//  
//
//  Created by hejinyin on 2018/1/21.
//  swiftlint:disable line_length

import Foundation

///  正则表达式要 双引号括起来 并且`\`要转换以 两个\\表示一个`\`
/**
    如果 确定自己的正则表达式是正确的 但是验证总是不通过 可以用如下方式打印出swift中正则表达式的表达方式
  * let regex1 = "[A-Za-z]+"
  * let pre5 = NSPredicate(format: "SELF MATCHES %@" , regex1)
  * let bool5 = pre5.evaluateWithObject("2")
  */
#if swift(>=5.0)
public enum WQRegex: String {
    
    case int = "^[+-]?[0-9]+$"
    /// 后期考虑添加 附加值限定小数点位数等
    case float = "^[+-]?[0-9]+([.]{0,1}[0-9]+){0,1}$"
    //     (?!pattern) 负向预查，在任何不匹配 pattern 的字符串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。
    //      例如'Windows (?!95|98|NT|2000)' 能匹配 "Windows 3.1" 中的 "Windows"，但不能匹配 "Windows 2000" 中的 "Windows"。
    //      预查不消耗字符，也就是说，在一个匹配发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始。
    case commonPwd = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"//这里表示 如果密码中不包含数字 就验证不通过;不包含字母也验证不通过 ^(?![0-9]+$)表示从头到尾不包含数字
    /// 6~20位密码 
    case commonPwd2 = "[0-9a-zA-Z]{6,20}$"
//    case IDCard = #"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1]\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$"#
    case IDCard = #"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"#
    /// 提取网页图片
    case imgInHTML = #"\\< *[img][^\\\\>]*[src] *= *[\\\"\\']{0,1}([^\"\\'\\ >]*)"#
    // 搜索也可以用这个 NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)     detector.enumerateMatches
    /// 提取URL链接
    case link = #"((?:http|https)://)?(?:www\.)?[\\w\\d\\-_]+\.\\w{2,3}(\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-\./_]+)?)?"#
    /** 中国手机号码 */
    case chinaPhone = #"^1[3-9]\\d{9}$"#
    //    case chinaPhone = "^1(34[0-9]|70[0-35-9]|(3[0-35-9]|4[5-9]|5[0-35-9]|66|7[135-8]|8[0-9])\\\\d)\\\\d{7}$"
    //    /**
    //     * 中国移动：China Mobile
    //     * 134[0-8],135,136,137,138,139;147,148;150,151,152,157,158,159;178,1703,1705,1706;182,183,184,187,188;
    //     */
    //    case chinaMobilePhone = "^1(34[0-8]|70[356]|(3[5-9]|4[78]|5[0-27-9]|78|8[2-478])\\\\d)\\\\d{7}$"
    //    /**
    //     * 中国电信：China Telecom
    //     * 133,1349;149,1410;153;173,177,1700,1701,1702;,180,181,189
    //     */
    //    case chinaTelecomPhone = "^1(349|70[0-2]|410|(33|49|53|7[37]|8[019])\\\\d)\\\\d{7}$"
    //    /**
    //     * 中国联通：China Unicom
    //     * 130,131,132;145,146;155,156;166;171,175,176,1707,1708,1709;185,186;
    //     */
    //    case chinaUnicomPhone = "^1(70[7-9]|(3[0-2]]|4[56]|5[56]|66|7[156]|8[56])\\\\d)\\\\d{7}$"
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    case chinaTelephone = #"^0(10|2[0-5789]|\\d{3})\\d{7,8}$"#
    
    case email = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}"#
    
}
#else
public enum WQRegex: String {
    
    case int = "^[+-]?[0-9]+$"
    /// 后期考虑添加 附加值限定小数点位数等
    case float = "^[+-]?[0-9]+([.]{0,1}[0-9]+){0,1}$"
    
    case commonPwd = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"//这里表示 如果密码中不包含数字 就验证不通过;不包含字母也验证不通过 ^(?![0-9]+$)表示从头到尾不包含数字
    case IDCard = "^[1-9]\\\\d{7}((0\\\\d)|(1[0-2]))(([0|1|2]\\\\d)|3[0-1])\\\\d{3}$|^[1-9]\\\\d{5}[1-9]\\\\d{3}((0\\\\d)|(1[0-2]))(([0|1|2]\\\\d)|3[0-1])\\\\d{3}([0-9]|X)$"
    /// 提取网页图片
    case imgInHTML = "\\< *[img][^\\\\>]*[src] *= *[\\\"\\']{0,1}([^\\\"\\'\\ >]*)"
    /// 提取URL链接
    case link = "((?:http|https)://)?(?:www\\\\.)?[\\\\w\\\\d\\\\-_]+\\\\.\\\\w{2,3}(\\\\.\\\\w{2})?(/(?<=/)(?:[\\\\w\\\\d\\\\-\\\\./_]+)?)?"
    /** 中国手机号码 */
    case chinaPhone = "^1[3-9]\\\\d{9}$"
 
    case chinaTelephone = "^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$"
    
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
}
#endif

public extension String {
    /// 验证字符串是否全部为数字
    var isPureInt: Bool {
        return evaluate(predicate: "SELF MATCHES \"\(WQRegex.int.rawValue)\"")
    }
     
    var isEmail: Bool {
        return evaluate(predicate: "SELF MATCHES \"\(WQRegex.email.rawValue)\"")
    }
    /// 校验字符串是否由6~20个包含字母和数字的字符组成 (一般用于密码强度校验)
    var isLegalPassword: Bool {
        return evaluate(predicate: "SELF MATCHES \"\(WQRegex.commonPwd.rawValue)\"")
    }
    
    /// 校验电话号码
    ///
    /// - Parameter phoneType: 需要校验的电话类型 默认校验中国的手机号
    /// - Returns: bool
    func isLegalPhone(_ phoneType: WQRegex = .chinaPhone) -> Bool {
        return evaluate(predicate: "SELF MATCHES \"\(phoneType.rawValue)\"")
    }
    /// 校验规则: https://blog.csdn.net/zjslqshqz/article/details/73571736 (笔记已备份)
     var isLegalIDCard: Bool {
        guard evaluate(predicate: "SELF MATCHES \"\(WQRegex.IDCard.rawValue)\"") else { //基本校验
            return false
        }
        let provinces = [11: "北京", 12: "天津", 13: "河北", 14: "山西", 15: "内蒙古", 21: "辽宁", 22: "吉林",
                         23: "黑龙江", 31: "上海", 32: "江苏", 33: "浙江", 34: "安徽", 35: "福建", 36: "江西",
                         37: "山东", 41: "河南", 42: "湖北", 43: "湖南", 44: "广东", 45: "广西", 46: "海南",
                         50: "重庆", 51: "四川", 52: "贵州", 53: "云南", 54: "西藏", 61: "陕西", 62: "甘肃",
                         63: "青海", 64: "宁夏", 65: "新疆", 71: "台湾", 81: "香港", 82: "澳门", 91: "国外"]
        let proEndIndex = self.index(self.startIndex, offsetBy: 2)
        let code = Int(self[self.startIndex ..< proEndIndex]) ?? -1
        guard provinces[code] != nil else { return false } // 城市编码无法对应就是错的
        guard self.count == 18 else { return true } // 15位的无需继续校验了
        //将前17位加权因子保存在数组里
        let weightFactor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        #if swift(>=5.0)
        let nums = self.dropLast().compactMap({ $0.wholeNumberValue })
        #else
        let nums = self.dropLast().compactMap({ Int(String($0)) ?? 0 })
        #endif
        var sum: Int = 0
        for index in 0 ..< 17 {
            sum += (weightFactor[index] * nums[index])
        }
        // 校验位
        let parity: [Character] = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"]
        let residue = sum % 11
        return parity[residue] == self.last || (residue == 2 && self.last == "x") // 小写x
    }
    
    func evaluate(predicate preStr: String) -> Bool {
        return NSPredicate(format: preStr).evaluate(with: self)
    }
}
