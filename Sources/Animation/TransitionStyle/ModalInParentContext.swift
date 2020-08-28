//
//  ModalInParentContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

class ModalInParentContext: ModalContext {
    let parent: UIViewController
    init(_ parentViewController: UIViewController) {
        parent = parentViewController
        super.init()
    }
}
