//
//  UIImageView+Animations.swift
//  Pods
//
//  Created by WangQiang on 2018/5/18.
//

import UIKit

public extension UIImageView {
    func fadeImage(_ fade: UIImage?) {
        if let fadeImage = fade {
            addTransitionAnimate(timing: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
                                 type: CATransitionType.fade,
                                 duration: 0.2) 
            self.image = fadeImage
        }
    }
    
}

