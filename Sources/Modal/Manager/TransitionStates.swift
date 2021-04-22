//
//  TransitionStates.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//

import Foundation
import UIKit

public enum ModalPresentation: Equatable {
    case modalSystem(UIViewController?)
    /// 这里要分
    case modalInParent(UIViewController)
    case modalInWindow
    case modalNavigation(UINavigationController?)
    /// 根据当前场景自动选择 (优先system 其次parent 再window)
    case autoModal
}
extension ModalPresentation {
    var snapshotTransitaion: UIView? {
        switch self {
        case .autoModal:
            return self.autoAdaptationStyle.snapshotTransitaion
        case .modalInWindow:
            return UIWindow.topNormal?.snapshotView(afterScreenUpdates: true)
        case .modalSystem:
            return UIWindow.topNormal?.snapshotView(afterScreenUpdates: true)
        case let .modalInParent(controller):
            return controller.view.snapshotView(afterScreenUpdates: true)
        case let .modalNavigation(navgationController):
            if let nav = navgationController ?? WQUIHelp.topNavigationController() {
                return nav.view.snapshotView(afterScreenUpdates: true)//.topViewController?
            }
            return nil
        }
    }
}
public extension ModalPresentation {
    var inParent: Bool {
        switch self {
        case .modalInParent:
            return true
        default:
            return false
        }
    }
}
public extension ModalPresentation {
    var fromViewController: UIViewController? {
        switch self {
        case let .modalSystem(viewController):
            return viewController ?? WQUIHelp.topVisibleViewController()
        case let .modalInParent(viewController):
            return viewController
        case let .modalNavigation(navgationController):
            return navgationController ?? WQUIHelp.topNavigationController() 
        case .autoModal:
            return self.autoAdaptationStyle.fromViewController
        default:
            return nil
        }
    }
    /// 自动适配autoModal Style
    var autoAdaptationStyle: ModalPresentation {
        switch self {
        case .autoModal:
            //,!topVisible.isBeingDismissed 
            if let topVisible = WQUIHelp.topVisibleViewController(),
               !topVisible.isBeingDismissed {
                if topVisible.presentedViewController == nil {
                    return .modalSystem(topVisible)
                } else {
                    return .modalInParent(topVisible)
                }
            } else {
                return .modalInWindow
            }
        default:
            return self
        }
    }
}

/// 支持动画方式
@available(iOS 10.0, *)
public enum ModalAnimationStyle {
   /// 背景淡入
   case `default`
//   case scaleFade
   /// 自定义states 默认动画
   case custom(ModalAnimation)
}

@available(iOS 10.0, *)
public extension ModalAnimationStyle {
    
    var animator: ModalAnimation {
        switch self {
        case .default:
            return ModalDefaultAnimation()
//        case .scaleFade:
//            return ModalScaleFadeAnimation()
        case let .custom(animation):
            return animation
        }
    }
}
