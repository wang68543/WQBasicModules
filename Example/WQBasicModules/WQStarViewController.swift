//
//  WQStarViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/2/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class WQStarViewController: BaseExampleViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let star = WQStarControl()
        star.value = 90
//        star.normalImage = UIImage(named: "003")
//        star.halfHighlightedImage = UIImage(named: "002")
//        star.highlightedImage = UIImage(named: "001")
        star.starSize = CGSize(width: 36, height: 33)
        star.valueType = .valueRandom
        star.backgroundColor = .white
        star.frame = CGRect(x: 30, y: 400, width: 300, height: 80)
        self.view.addSubview(star)
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
