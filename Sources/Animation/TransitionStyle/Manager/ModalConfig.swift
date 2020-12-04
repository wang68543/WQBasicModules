//
//  ModalConfig.swift
//  Pods
//
//  Created by WQ on 2020/10/30.
//  转场动画所需环境的参数

import Foundation
 
public class ModalConfig {
    public let style: ModalPresentation 
    /// 当前在结构中的 viewController
    internal weak var fromViewController: UIViewController?
    /// 是否要调用生命周期
    public var layoutControllerLifeCycleable: Bool = false
    /// 用户交互消失的方式
    public var interactionDismiss: InteractDismissMode = .none
    /// 容器控制器的View显示frame
    // 可以通过 self.edgesForExtendedLayout = [] 确保alertView 居中
    public var showControllerFrame: CGRect = UIScreen.main.bounds
    
    public init(_ style: ModalPresentation = .autoModal) {
        self.style = style
        if let viewController = style.fromViewController  {
            showControllerFrame = viewController.view.bounds
            fromViewController = viewController
        }
    }
    deinit {
        // 这里如果使用常量是不会释放的 例如: 下面的default
        debugPrint("\(self):" + #function + "♻️")
    }
}
public extension ModalConfig {
    static let `default` = ModalConfig() 
}
