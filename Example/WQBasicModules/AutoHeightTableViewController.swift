//
//  AutoHeightTableViewController.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2019/10/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class AutoHeightTableViewController: BaseExampleViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let textView = WQAutoIncreaseTextView()
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.preferredValue = 60
        textView.backgroundColor = .red
        textView.minLimit = 60
        textView.maxLimit = 120
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        textView.font = UIFont.systemFont(ofSize: 30)
        
        let subView = UIView()
        subView.backgroundColor = .yellow
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subView)
        NSLayoutConstraint.activate([
                   subView.topAnchor.constraint(equalTo: textView.bottomAnchor),
                   subView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                   subView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                   subView.heightAnchor.constraint(equalToConstant: 80)
               ])
//        textView.constraints.
        // Do any additional setup after loading the view.
    }
    
 

}
