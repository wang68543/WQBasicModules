//
//  SerialShowQueue.swift
//  Pods
//
//  Created by WQ on 2020/4/15.
//

import UIKit
public class SerialShowQueue: NSObject {
    static let `default` = SerialShowQueue()
}
extension Notification.Name {
    static let TransitionViewWillShow = Notification.Name("TransitionViewWillShow")
    static let TransitionViewDidShow = Notification.Name("TransitionViewDidShow")
    static let TransitionViewWillDismiss = Notification.Name("TransitionViewWillDismiss")
    static let TransitionViewDidDismiss = Notification.Name("TransitionViewDidDismiss")
}
