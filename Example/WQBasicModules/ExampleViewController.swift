//
//  ExampleViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/2/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class ExampleViewController: UITableViewController {

    let sections: [String] = ["WQUI", "Transitioning"]
    let sources:[[[String: String]]] = [
        [["浏览器控件": "TestWebViewController"],
         ["多布局风格按钮": "WQButtonViewController"]], // WQUI
        [["自定义评分控件": "WQStarViewController"],
         ["仿系统弹出框": "ExampleAlertViewController"],
         ["半截屏幕上下移动交互": "WQPanViewController"]]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        ExampleViewCell.register(for: self.tableView)
        let test = ViewController.TestModel("12345")
        WQCache.default["test"] = test
//          let test:ViewController.TestModel? = WQCache.default.object(forKey: "test")
         let model:ViewController.TestModel? = WQCache.default["test"]
        if "13898768609".isLegalPhone() {
            debugPrint("正确的手机号码")
        }
        let format: DateFormatEnum = .k1MM1ddCHHBmm
        debugPrint(format.formatString)
//        let str = #"SELF MATCHES "^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1]\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx]))$""#
//        let str = #"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"#
////        let predicate = NSPredicate(format: str)
//        let predicate = NSPredicate(format: "SELF MATCHES \"\(str)\"")
//        if predicate.evaluate(with: "421281199010135718")  {
//            debugPrint("正确的身份证号码")
//        }
        if "421281199010135718".isLegalIDCard   {
            debugPrint("正确的身份证号码")
        }
        if "https://www.jianshu.com".evaluate(predicate: "SELF MATCHES \"\(WQRegex.link.rawValue)\"") {
            debugPrint("正确的网站")
        }
        
        let button = SecondViewController.DownButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        button.setTitle("测试倒计时", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = UIColor.yellow
        button.countDown(total: 60, formater: NumberFormatter(countDownFormat: "还剩", suf: "秒"), color: UIColor.red)
        self.view.addSubview(button)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sources.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources[section].count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExampleViewCell.cell(for: tableView, with: indexPath)
        let values = sources[indexPath.section][indexPath.row]
        cell.titleLabel.text = values.keys.first
        cell.exampleLabel.text = values.values.first
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let values = sources[indexPath.section][indexPath.row]
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let clsStr = namespace + "." + values.values.first!
        let cls = NSClassFromString(clsStr) as! UIViewController.Type
        let viewController = cls.init()
        viewController.view.backgroundColor = UIColor.white 
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
