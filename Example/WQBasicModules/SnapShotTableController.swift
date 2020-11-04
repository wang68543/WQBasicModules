//
//  SnapShotTableController.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/19.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SnapShotTableController: UIViewController {
    static let reuseIdentifier = "cell"
    let tableView = UITableView(frame: .zero, style: .plain)
    let scrollView: UIScrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
//        self.navigationController.

        let btn = UIButton(frame: CGRect(x: 100.rpx(), y: 2500, width: 200, height: 100))
        btn.backgroundColor = UIColor.red
        scrollView.addSubview(btn)
        scrollView.backgroundColor = UIColor.white
//        self.view.addSubview(scrollView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SnapShotTableController.reuseIdentifier)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.layer.cornerRadius = 10
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
//            let images = self.tableView.snapshots()
            if let data = self.tableView.longSnapshot()?.pngData() {
                try? data.write(to: URL(fileURLWithPath: "/Users/WangQiang/Desktop/1111111111111.png"))
//            }
            }
//            if let data = self.scrollView.longSnapshot()?.pngData() {
//                try! data.write(to: URL(fileURLWithPath: "/Users/WangQiang/Desktop/1111111111111.png"))
//            }
//            if let data = self.tableView.snapShotTable(self.tableView.bounds.size)?.pngData() {
//                try! data.write(to: URL(fileURLWithPath: "/Users/WangQiang/Desktop/1111111111111.png"))
//            }
            debugPrint("存储完成")
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
        self.scrollView.frame = self.view.bounds
         scrollView.contentSize = CGSize(width: self.view.frame.width, height: 3000)
    }
}
extension SnapShotTableController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapShotTableController.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "分区:\(indexPath.section),行:\(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "======:\(section)"
        return label
    }

}
