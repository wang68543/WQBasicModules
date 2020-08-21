//
//  ModalInWindowContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

class WQModalContainerWindow: UIWindow {
    
}
class ModalInWindowContext: ModalContext {
    lazy var window: WQModalContainerWindow = {
       let win = WQModalContainerWindow()
        return win
    }()
}
