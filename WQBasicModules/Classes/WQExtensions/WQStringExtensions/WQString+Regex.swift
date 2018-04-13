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
public enum WQRegExpression: String {
    
    case regexInt = "^[+-]?[0-9]+$"
    /// 后期考虑添加 附加值限定小数点位数等
    case regexFloat = "^[+-]?[0-9]+([.]{0,1}[0-9]+){0,1}$"
    
//     (?!pattern) 负向预查，在任何不匹配 pattern 的字符串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。
//      例如'Windows (?!95|98|NT|2000)' 能匹配 "Windows 3.1" 中的 "Windows"，但不能匹配 "Windows 2000" 中的 "Windows"。
//      预查不消耗字符，也就是说，在一个匹配发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始。
    case regexCommonPwd = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"//这里表示 如果密码中不包含数字 就验证不通过;不包含字母也验证不通过 ^(?![0-9]+$)表示从头到尾不包含数字
    case regexIDCard = "^(^[1-9]\\\\d{7}((0\\\\d)|(1[0-2]))(([0|1|2]\\\\d)|3[0-1])\\\\d{3}$)|(^[1-9]\\\\d{5}[1-9]\\\\d{3}((0\\\\d)|(1[0-2]))(([0|1|2]\\\\d)|3[0-1])((\\\\d{4})|\\\\d{3}[Xx])$)$"
    
    /** 中国手机号码 */
    case regexPhoneChina = "^1(34[0-9]|70[0-35-9]|(3[0-35-9]|4[5-9]|5[0-35-9]|66|7[135-8]|8[0-9])\\\\d)\\\\d{7}$"
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139;147,148;150,151,152,157,158,159;178,1703,1705,1706;182,183,184,187,188;
     */
    case regexPhoneChinaMobile = "^1(34[0-8]|70[356]|(3[5-9]|4[78]|5[0-27-9]|78|8[2-478])\\\\d)\\\\d{7}$"
    /**
     * 中国电信：China Telecom
     * 133,1349;149,1410;153;173,177,1700,1701,1702;,180,181,189
     */
    case regexPhoneChinaTelecom = "^1(349|70[0-2]|410|(33|49|53|7[37]|8[019])\\\\d)\\\\d{7}$"
    /**
     * 中国联通：China Unicom
     * 130,131,132;145,146;155,156;166;171,175,176,1707,1708,1709;185,186;
     */
    case regexPhoneChinaUnicom = "^1(70[7-9]|(3[0-2]]|4[56]|5[56]|66|7[156]|8[56])\\\\d)\\\\d{7}$"
    /**
      * 大陆地区固话及小灵通
      * 区号：010,020,021,022,023,024,025,027,028,029
      * 号码：七位或八位
      */
    case regexTelephone = "^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$"
    
}
extension String {
    /// 验证字符串是否全部为数字
    public var isPureInt: Bool {
        return evaluate(predicate: "SELF MATCHES \"\(WQRegExpression.regexInt.rawValue)\"")
    }
    
    /// 校验字符串是否由6~20个包含字母和数字的字符组成 (一般用于密码强度校验)
    public var isLegalPassword: Bool {
        return evaluate(predicate: "SELF MATCHES \"\(WQRegExpression.regexCommonPwd.rawValue)\"")
    }
    
    /// 校验电话号码
    ///
    /// - Parameter phoneType: 需要校验的电话类型 默认校验中国的手机号
    /// - Returns: bool
    public func isLegalPhone(_ phoneType: WQRegExpression = .regexPhoneChina) -> Bool {
        return evaluate(predicate: "SELF MATCHES \"\(phoneType.rawValue)\"")
    }
    
    ///  校验身份证是否合法
    /**
       中国大陆居民身份证号码中的地址码的数字编码规则为：
        * 第一、二位表示省（自治区、直辖市、特别行政区）。
        * 第三、四位表示市（地级市、自治州、盟及国家直辖市所属市辖区和县的汇总码）。其中，01-20，51-70表示省直辖市；21-50表示地区（自治州、盟）。
        * 第五、六位表示县（市辖区、县级市、旗）。01-18表示市辖区或地区（自治州、盟）辖县级市；21-80表示县（旗）；81-99表示省直辖县级市。
       ## 生日期码（身份证号码第七位到第十四位）
        表示编码对象出生的年、月、日，其中年份用四位数字表示，年、月、日之间不用分隔符。例如：1981年05月11日就用19810511表示。
       ## 顺序码（身份证号码第十五位到十七位）
        地址码所标识的区域范围内，对同年、月、日出生的人员编定的顺序号。其中第十七位奇数分给男性，偶数分给女性
       ## 校验码
        作为尾号的校验码，是由号码编制单位按统一的公式计算出来的，如果某人的尾号是0-9，都不会出现X，但如果尾号是10，那么就得用X来代替，因为如果用10做尾号，那么此人的身份证就变成了19位，而19位的号码违反了国家标准，并且中国的计算机应用系统也不承认19位的身份证号码。Ⅹ是罗马数字的10，用X来代替10，可以保证公民的身份证符合国家标准。
       ## 地址码==
        华北地区： 北京市|110000，天津市|120000，河北省|130000，山西省|140000，内蒙古自治区|150000，
        东北地区： 辽宁省|210000，吉林省|220000，黑龙江省|230000，
        华东地区： 上海市|310000，江苏省|320000，浙江省|330000，安徽省|340000，福建省|350000，江西省|360000，山东省|370000，
        华中地区： 河南省|410000，湖北省|420000，湖南省|430000，
        华南地区： 广东省|440000，广西壮族自治区|450000，海南省|460000，
        西南地区： 重庆市|500000，四川省|510000，贵州省|520000，云南省|530000，西藏自治区|540000，
        西北地区： 陕西省|610000，甘肃省|620000，青海省|630000，宁夏回族自治区|640000，新疆维吾尔自治区|650000，
        特别地区：台湾地区(886)|710000，香港特别行政区（852)|810000，澳门特别行政区（853)|820000
       # 身份证校验码的计算方法
        1. 将前面的身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。
        2. 将这17位数字和系数相乘的结果相加。
        3. 用加出来和除以11，看余数是多少？
        4. 余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字。其分别对应的最后一位身份证的号码为1－0－X－9－8－7－6－5－4－3－2。(即余数0对应1，余数1对应0，余数2对应X...)
        5. 通过上面得知如果余数是3，就会在身份证的第18位数字上出现的是9。如果对应的数字是2，身份证的最后一位号码就是罗马数字x。
 */
    public var isLegalIDCard: Bool {
        
            var isLegal = evaluate(predicate: "SELF MATCHES \"\(WQRegExpression.regexIDCard.rawValue)\"")
            if isLegal {//校验和
                //格式正确在判断是否合法
                //将前17位加权因子保存在数组里
                let weightFactor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
                //这是除以11后，可能产生的11位余数、验证码，也保存成数组
                let IDCardLasts = [
                    Character("1"), Character("0"), Character("x"),
                    Character("9"), Character("8"), Character("7"),
                    Character("6"), Character("5"), Character("4"),
                    Character("3"), Character("2")
                ]
                
                var IDSum = 0
                for index in 0 ..< 17 {
                    let startIndex = self.index(self.startIndex, offsetBy: index)
                    let endIndex = self.index(startIndex, offsetBy: 1)
                    let IDSubValue = Int(self[startIndex ..< endIndex])!
                    IDSum += IDSubValue * weightFactor[index]
                }
                let IDCardMode = IDSum % 11
                let IDCardLast = self.lowercased().last!
                
                //确认校验和
                if IDCardLast == IDCardLasts[IDCardMode] {
                    isLegal = true
                } else {
                    isLegal = false
                }
            }
            return isLegal
    }
    public func evaluate(predicate preStr: String) -> Bool {
        return NSPredicate.init(format: preStr).evaluate(with: self)
    }
}
