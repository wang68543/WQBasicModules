//
//  FIFOModalQueue.swift
//  Pods
//
//  Created by 王强 on 2020/12/19.
//

import Foundation
@available(iOS 10.0, *)
public class FILOModalQueue: NSObject {
    public static let shared = FILOModalQueue()
    
    internal var items: [FIFOModalItem] = []
    
    public func modal(_ controller: WQLayoutController, states: StyleConfig, comletion: ModalAnimation.Completion?) {
        func showItem() {
            controller.ctxShow(states, comletion: comletion)
            self.items.append(FIFOModalItem(controller, states: states, completion: comletion))
        }
        if items.isEmpty {
            showItem()
        } else { // 等待显示
            guard let last = items.last else { return }
            /// 之前的 先暂停
            last.layoutController.ctxHide(animated: false) {
                showItem()
            }
        }
    }
    
//    public func hiddenCompletion(with controller: WQLayoutController) {
//        guard controller == items.first?.layoutController else {
//            return
//        }
//        items.removeFirst()
//        guard let showItem = items.first else { return }
//        showItem.layoutController.modal(showItem.states, comletion: showItem.completion)
//    }
    public func dismiss(_ controller: WQLayoutController, flag: Bool, completion: (() -> Void)?) {
        if items.isEmpty {
            controller.ctxHide(animated: flag, completion: completion)
        } else {
            let item = items.removeLast()
            item.layoutController.ctxHide(animated: flag) {
                completion?()
                if let last = self.items.last {
                    item.states.animator.animationEnable = false
                    last.layoutController.ctxShow(item.states, comletion: item.completion)
                }
            }
        }
    }
}
@available(iOS 10.0, *)
internal class FIFOModalItem: NSObject {
    let layoutController: WQLayoutController
    let states: StyleConfig
    let completion: ModalAnimation.Completion?
    
    init(_ controller: WQLayoutController, states: StyleConfig, completion: ModalAnimation.Completion?) {
        self.layoutController = controller
        self.states = states
        self.completion = completion
        super.init()
    }
}
