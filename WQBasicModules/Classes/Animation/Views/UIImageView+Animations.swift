//
//  UIImageView+Animations.swift
//  Pods
//
//  Created by WangQiang on 2018/5/18.
//

import UIKit

public extension UIImageView {
    func fade(_ img: UIImage?) {
        if let fadeImage = img {
            layer.transition(timing: CAMediaTimingFunction(name: .easeIn),
                             type: .fade,
                             duration: 0.2)
            self.image = fadeImage
        }
    }
}
