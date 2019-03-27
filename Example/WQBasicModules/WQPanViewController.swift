//
//  WQPanViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/3/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class WQPanViewController: BaseExampleViewController {
    let containerView: PanContainerView = PanContainerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.frame = self.view.bounds
    }
}
