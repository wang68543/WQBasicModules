//
//  TableTextInputViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/1/24.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class TableTextInputViewController: UIViewController {

    class TestCell: UITableViewCell {
        static let reuseIdentifier: String = "TestCell"
        let textFiled: UITextField
        let line = UIView()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            textFiled = UITextField()
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(textFiled)
            self.contentView.addSubview(line)
            line.backgroundColor = UIColor.green
            self.contentView.backgroundColor = UIColor.red
            textFiled.backgroundColor = UIColor.white
            
            self.selectionStyle = .none
        }
    override func layoutSubviews() {
        super.layoutSubviews()
//        let width =
        textFiled.frame = CGRect(x: 10, y: 10, width: self.contentView.bounds.width - 30, height: self.contentView.bounds.height - 15)
        self.line.bounds = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: 1)
        self.line.center = self.textFiled.center
    }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint(#function)
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(#function)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("*********",#function)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("*********",#function)
    }
    var tableView: UITableView!
    var keyboardMangaer: WQKeyboardManager!
    var line = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView = UITableView()
        tableView.register(TestCell.self, forCellReuseIdentifier: TestCell.reuseIdentifier)
        tableView.rowHeight = 100
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        keyboardMangaer = WQKeyboardManager(self.tableView)
        keyboardMangaer.shouldResignOnTouchOutside = true
        self.view.addSubview(line)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        line.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {
            line.frame = CGRect(x: 0, y: self.view.frame.height - self.view.safeAreaInsets.bottom - 1, width: self.view.frame.width, height: 1)
        } else {
            // Fallback on earlier versions
        }
    }

}
extension TableTextInputViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TestCell.reuseIdentifier, for: indexPath) as! TestCell
        cell.textFiled.placeholder = "===:" + String(indexPath.row)
       
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        keyboardMangaer.reloadTextFieldViews()
    }
}
