//
//  ModalConfig.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//  转场动画所需环境的参数

import Foundation

public enum InteractDismissMode {
    public enum Direction {
        case toTop
        case toBottom
        case toLeft
        case toRight
    }
    case none
    /// 点击容器以外的背景消失
    case tapOutSide
    /// 点击所有的背景都消失
    case tapAll
    /// 移动消失
    case pan(Direction)
}

extension InteractDismissMode {
    var isGestureDrivenDismiss: Bool {
        switch self {
        case .pan:
            return true
        default:
            return false
        }
    }
}

public class ModalConfig {
    public let style: ModalStyle 
    /// 当前在结构中的 viewController
    internal weak var fromViewController: UIViewController?
    /// 容器控制器
//    let presenting: WQLayoutController = WQLayoutController()
    /// 是否要调用生命周期
    public var layoutControllerLifeCycleable: Bool = false
    /// 用户交互消失的方式
    public var interactionDismiss: InteractDismissMode = .none
    /// 容器控制器的View显示frame
    public var containerViewControllerFinalFrame: CGRect = UIScreen.main.bounds
    
    
    public init(_ style: ModalStyle = .autoModal) {
        self.style = style
        fromViewController = style.fromViewController
    }
}
public extension ModalConfig {
    static let `default` = ModalConfig()
    
    static func inParent(_ parentViewController: UIViewController) -> ModalConfig {
        return ModalConfig(.modalInParent(parentViewController))
    }
}
