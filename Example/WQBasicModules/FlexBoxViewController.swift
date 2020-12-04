//
//  FlexBoxViewController.swift
//  WQBasicModules_Example
//
//  Created by WQ on 2019/6/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class FlexBoxViewController: UIViewController {

    let timesView: UICollectionView = {
        let flex = WQFlexbox()
        let viewH: CGFloat = 44
        let size = CGSize(width: Screen.width, height: viewH)
        let frame = CGRect(origin: CGPoint(x: 0, y: 100), size: size)
        let view = UICollectionView(frame: frame,
                                    collectionViewLayout: flex)
        flex.itemSize = CGSize(width: viewH - 8, height: viewH - 8)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        flex.direction = .row
        flex.justifyContent = .spaceBetween
        flex.isSingleLine = true
        view.backgroundColor = UIColor.white
        view.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        timesView.dataSource = self
        timesView.delegate = self
        self.view.addSubview(timesView)
        if #available(iOS 11.0, *) {
            timesView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension FlexBoxViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
