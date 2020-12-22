//
//  PageChildViewController.swift
//  WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2020/12/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class PageChildViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint(#function)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(#function)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(#function)
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
