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
    class DownButton: UIButton {
        
        
        deinit {
            debugPrint("销毁了")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = DownButton()
        button.countDown(60, execute: { (sender, count, state) in
            debugPrint("\(count)")
        }) { (sender, flag) -> Bool in
            
            return true
        }
        button.frame = CGRect(x: 20, y: 60, width: 100, height: 50);
        self.view.addSubview(button)
        let layout = WQFlexbox()
        layout.justify_content = .flexEnd
        layout.align_content = .spaceBetween
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: 300, height: 500), collectionViewLayout: layout)
//        collectionView.contentInset = UIEdgeInsets(top: 80, left: 20, bottom: 60, right: 40)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.green
        self.view.addSubview(collectionView)
    }
    

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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
 
    func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, justifyContentForSectionAt section: Int, inLine lineIndex: Int, linesCount: Int) -> WQJustifyContent {
        if lineIndex == linesCount - 1 {
            return .flexStart
        } else {
            return .flexEnd
        }
    }
    func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, sizeForSectionAt section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 1200)
    }
}
extension SecondViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.textLabel.text = "\(indexPath.item)"
        return cell
    }
}
