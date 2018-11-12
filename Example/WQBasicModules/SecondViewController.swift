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
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50);
        self.view.addSubview(button)
        // Do any additional setup after loading the view.
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
