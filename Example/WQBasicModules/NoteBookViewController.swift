//
//  NoteBookViewController.swift
//  WQBasicModules_Example
//
//  Created by 王强 on 2021/5/29.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules

class NoteBookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let notebook = NoteBook(frame: CGRect(x: 10, y: 10, width: 200, height: 200))
        self.view.addSubview(notebook)
        notebook.load()
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
