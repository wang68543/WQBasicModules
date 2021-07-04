//
//  ExampleViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/2/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
import CommonCrypto
class ExampleViewController: UITableViewController {

    var sections: [String] = ["WQUI", "Transitioning"]
    var sources: [[[String: String]]] = [
        [["浏览器控件": "TestWebViewController"],
         ["多布局风格按钮": "WQButtonViewController"],
         ["flexbox": "FlexBoxViewController"]], // WQUI
        [["自定义评分控件": "WQStarViewController"],
         ["自增长TextView": "AutoHeightTableViewController"],
         ["仿系统弹出框": "ExampleAlertViewController"],
         ["半截屏幕上下移动交互": "WQPanViewController"],
         ["页面分栏": "PageScrollViewController"],
         ["页面分栏2": "PageContentViewController"],
         ["输入框": "TextFieldViewController"],
         ["富文本输入": "NoteBookViewController"]]
    ]

//    let sections2: [String] = ["WQUI", "Transitioning","WQUI", "Transitioning"]
//    let sources2:[[[String: String]]] = [
//        [["浏览器控件": "TestWebViewController"],
//         ["多布局风格按钮": "WQButtonViewController"]], // WQUI
//        [["自定义评分控件": "WQStarViewController"],
//         ["仿系统弹出框": "ExampleAlertViewController"],
//         ["半截屏幕上下移动交互": "WQPanViewController"]],
//
//        [["浏览器控件": "TestWebViewController"],
//         ["多布局风格按钮": "WQButtonViewController"]], // WQUI
//        [["自定义评分控件": "WQStarViewController"],
//         ["仿系统弹出框": "ExampleAlertViewController"],
//         ["半截屏幕上下移动交互": "WQPanViewController"]]
//    ]
    weak var btn: SecondViewController.DownButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        ExampleViewCell.register(for: self.tableView)
//          let test:ViewController.TestModel? = WQCache.default.object(forKey: "test")
//         let model:ViewCåontroller.TestModel? = WQCache.default["test"]
        if "13898768609".isLegalPhone() {
            debugPrint("正确的手机号码")
        }
        self.tableView.rowHeight = 70.0
        let format: DateFormatEnum = .k1MM1ddCHHBmm
        debugPrint(format.formatString)
        if let date = "20190101 0234".toDate(format: .kMMddHHmm) {
            let days = Calendar.current.numberOfDaysInYear(for: date)
            debugPrint(days)
        }
        debugPrint("123456".md5String())
        if "421281199010135718".isLegalIDCard {
            debugPrint("正确的身份证号码")
        }
        let dic: [String: Any] = ["key1": "value1", "key2": "value2"]
        if let data = try? JSONSerialization.data(withJSONObject: dic, options: []) {
            //as12456
//            debugPrint(data.DES(decodeWithKey:"ac12456b")?.base64EncodedString())
            if let aesdata = try? data.encodedDES("ac12456b") {
                debugPrint(aesdata.base64EncodedString())
                if let value = try? aesdata.decodedDES("ac12456b") {
                    if let result = try? JSONSerialization.jsonObject(with: value, options: []) {
                        debugPrint(result)
                    }

                }
            }

        }

        if "https://www.jianshu.com".evaluate(predicate: "SELF MATCHES \"\(WQRegex.link.rawValue)\"") {
            debugPrint("正确的网站")
        }

        let button = SecondViewController.DownButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        button.setTitle("测试倒计时", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = UIColor.yellow

        let cancel = false

            let address = String(format: "%p", cancel)
            print(address)
        button.totalValue = "60"
        button.countDown(total: 60, formater: NumberFormatter(countDownFormat: "还剩", suf: "秒"), color: UIColor.red)
//        let appName = UIApplication.shared.displayName
        self.view.addSubview(button)
//        let archivedData = NSKeyedArchiver.archivedData(withRootObject: button)
//        let copyView = NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? WQCountDownView
//        button.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
       self.btn = button
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            debugPrint("数据刷新了")
//            self.sections = self.sections2
//            self.sources = self.sources2
//            self.tableView.reloadData()
//        }
//        button.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        HookClangTrace.makeOrder()
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }

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
        debugPrint(indexPath)
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let values = sources[indexPath.section][indexPath.row]
        if let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
            let clsStr = namespace + "." + values.values.first!
            if let cls = NSClassFromString(clsStr) as? UIViewController.Type {
                let viewController = cls.init()
                viewController.view.backgroundColor = UIColor.white
                self.navigationController?.pushViewController(viewController, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

}
