//
//  UIImageView+Animations.swift
//  Pods
//
//  Created by WangQiang on 2018/5/18.
//

import UIKit

public extension UIImageView {
    var fadeImage: UIImage? {
        didSet {
            if let fadeImage = fadeImage {
                addTransitionAnimate(timing: kCAMediaTimingFunctionEaseInEaseOut, subtype: kCATransitionFade, duration: 0.2)
                self.image = fadeImage
            }
        }
    }
    
}
