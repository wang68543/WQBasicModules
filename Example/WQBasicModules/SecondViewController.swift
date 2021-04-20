//
//  SecondViewController.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class SecondViewController: UIViewController {

    var collectionView: UICollectionView!
    class Cell: UICollectionViewCell {
        static let reuseIdentifier: String = "cell"
        let textLabel: UILabel
        override init(frame: CGRect) {
            textLabel = UILabel()
            super.init(frame: frame)
            self.contentView.addSubview(textLabel)
            self.backgroundColor = .red
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            textLabel.frame = self.contentView.bounds
        }
    }
    class HeaderFooterView: UICollectionReusableView {
        static let reuseIdentifier: String = "HeaderFooterView"
    } 
    class DownButton: UIButton {

        deinit {
            debugPrint("销毁了")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = DownButton()
        button.countDown(total: 60, formater: NumberFormatter(countDownFormat: "还剩", suf: "s"), color: UIColor.red) { (_, _) -> Bool in

            return true
        }
//        button.countDown(60, execute: { (sender, count, state) in
//            debugPrint("\(count)")
//        }) { (sender, flag) -> Bool in
//
//            return true
//        }
        button.frame = CGRect(x: 20, y: 100, width: 100, height: 50)
        self.view.addSubview(button)
        let layout = WQFlexbox()
        layout.direction = .columnReverse
        layout.justifyContent = .center
        layout.alignContent = .center

        layout.alignItems = .center

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: 300, height: 500), collectionViewLayout: layout)
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 40, right: 40)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView.register(HeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HeaderFooterView.reuseIdentifier)
        collectionView.register(HeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderFooterView.reuseIdentifier)
        collectionView.backgroundColor = UIColor.green
        self.view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

/**
     (10.0, 0.0, 50.0, 50.0)
     (70.0, 0.0, 50.0, 50.0)
     (130.0, 0.0, 50.0, 50.0)
     (190.0, 0.0, 50.0, 50.0)
     (250.0, 0.0, 50.0, 50.0)
     */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SecondViewController: WQFlexboxDelegateLayout {
    func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, justifyContentFor linePath: WQFlexLinePath) -> WQJustifyContent {
        return .center
    }
//
    func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, alignItemsFor section: Int, with linePath: WQFlexLinePath, in indexPath: IndexPath) -> WQAlignItems {
        return .center
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item % 3 == 0 {
            return CGSize(width: 30, height: 80)
        } else {
          return CGSize(width: 60, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: 200, height: 50)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//    func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, justifyContentForSectionAt section: Int, inLine lineIndex: Int, linesCount: Int) -> WQJustifyContent {
//        if lineIndex == linesCount - 1 {
//            return .flexStart
//        } else {
//            return .flexEnd
//        }
//    }
//    func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, sizeForSectionAt section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 1400)
//    }
}
extension SecondViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                                      for: indexPath)
        if let reuseCell = cell as? Cell {
            reuseCell.textLabel.text = "\(indexPath.item)"
        }
        if indexPath.section == 1 {
            cell.backgroundColor = UIColor.yellow
        } else {
            cell.backgroundColor = UIColor.blue
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
       let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: HeaderFooterView.reuseIdentifier,
                                                                  for: indexPath)

        if kind == UICollectionView.elementKindSectionHeader {
            view.backgroundColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.black
        }
        return view
    }
}
extension SecondViewController.DownButton {
   private struct CountDownKeys {
        static let timerSource = UnsafeRawPointer(bitPattern: "wq.button.countDown.timerSource".hashValue)!
        static let totalCount = UnsafeRawPointer(bitPattern: "wq.button.countDown.totalCount".hashValue)!
        static let completion = UnsafeRawPointer(bitPattern: "wq.button.countDown.completion".hashValue)!
        static let execute = UnsafeRawPointer(bitPattern: "wq.button.countDown.execute".hashValue)!
        static let isCanCancel = UnsafeRawPointer(bitPattern: "wq.button.countDown.isCanCancel".hashValue)!
        static let beforeStatus = UnsafeRawPointer(bitPattern: "wq.button.countDown.beforeStatus".hashValue)!
    }
    var totalValue: String {
        set {
            #if arch(arm64) || arch(x86_64)
            objc_setAssociatedObject(self, CountDownKeys.totalCount, newValue, .OBJC_ASSOCIATION_ASSIGN)
            #else //解决非64位 内存优化问题
            objc_setAssociatedObject(self, CountDownKeys.totalCount, newValue, .OBJC_ASSOCIATION_COPY)
            #endif

        }
        get {
            if let count = objc_getAssociatedObject(self, CountDownKeys.totalCount) as? String {
                return count
            } else {
                return "1"
            }
        }
    }
}
