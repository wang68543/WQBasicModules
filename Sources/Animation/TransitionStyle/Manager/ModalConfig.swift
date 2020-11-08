//
//  ModalConfig.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//  转场动画所需环境的参数

import Foundation

public enum InteractDismissMode: Equatable {
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
public extension InteractDismissMode {
    static func == (lhs: InteractDismissMode, rhs: InteractDismissMode) -> Bool {
        switch lhs {
        case .none:
            switch rhs {
            case .none: return true
            default: return false
            }
        case .tapAll:
            switch rhs {
            case .tapAll: return true
            default: return false
            }
        case .tapOutSide:
            switch rhs {
            case .tapOutSide: return true
            default: return false
            }
        case .pan:
            switch rhs {
            case .pan: return true
            default: return false
            }
        }
    }
}
public extension InteractDismissMode {
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
