//
//  WQTransitionWindow.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/2.
//

import Foundation

/// 专职于显示Alert的Window
public class WQTransitionWindow: UIWindow {
    /// 记录的属性 用于消失之后恢复
    var previousKeyWindow: UIWindow?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let preKey = self.previousKeyWindow,
            UIApplication.shared.keyWindow === self {
            if preKey.isHidden {
                UIApplication.shared.delegate?.window??.makeKey()
            } else {
                preKey.makeKey()
            }
        }
    }
}

public extension WQTransitionWindow {
    /// 添加根控制器 并且让window显示 
    func addVisible(root viewController: UIViewController) {
        self.previousKeyWindow = UIApplication.shared.keyWindow
        self.rootViewController = viewController
        if !self.isKeyWindow { //重复设置root
          self.makeKeyAndVisible()
        }
    }
    func remove() {
        if let preKey = self.previousKeyWindow,
            UIApplication.shared.keyWindow === self {
            if preKey.isHidden {
                UIApplication.shared.delegate?.window??.makeKey()
            } else {
                preKey.makeKey()
            }
        }
        self.isHidden = true
        if #available(iOS 13.0, *) { } else {
            // TODO: - 这里在iOS13下 设置rootViewController为nil 会自动调用 rootViewController 的dismiss
            self.rootViewController = nil
        }
        self.previousKeyWindow = nil
    }
}
