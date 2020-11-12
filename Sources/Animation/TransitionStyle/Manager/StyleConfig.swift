//
//  TransitionStatesConfig.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//

import Foundation


/// 转场动画各种状态的配置
public class StyleConfig {
    /// 各个状态的配置
    public var states: [ModalState: WQReferenceStates]
    /// 是否需要遮罩
    public var dimming: Bool = true
   /// states
    public let showStyle: TransitionShowStyle
    /// 动画方式 ModalDefaultAnimation
    public let animationStyle: TransitionAnimationStyle 
    /// 动画之前附加的view
    public var snapShotAttachAnimatorViews: [ModalState: [UIView: [UIView]]] = [:]
    
    /// 约束container的显示尺寸(主要适用于actionSheet,alert)
    public var constraintSize = CGSize.zero
    /// 动画执行者
    lazy var animator: TransitionAnimation = {
        return animationStyle.animator
    }()
    
    public init(_ style: TransitionShowStyle, anmation: TransitionAnimationStyle) {
        self.showStyle = style
        self.animationStyle = anmation
        var sts: [ModalState: WQReferenceStates]
        switch style {
        case let .custom(values):
            sts = values
        default:
            sts = [:]
            break
        } 
        states = sts
    }
    deinit {
        debugPrint("\(self):" + #function + "♻️")
    }
}
public extension StyleConfig {
    func addState(_ target: NSObject, values: [TSReferenceWriteable], state: ModalState) {
        var sts = self.states[state] ?? []
        sts.addState(target, values)
        self.states[state] = sts
    }
    
    func addState(_ target: NSObject, value: TSReferenceWriteable, state: ModalState) {
        self.addState(target, values: [value], state: state)
    }
}   
public extension StyleConfig {
    func setupStates(_ layout: WQLayoutController, config: ModalConfig) {
        var values: [ModalState: WQReferenceStates] = [:]
        let size = layout.container.sizeThatFits()
        let controllerSize = config.showControllerFrame.size
        switch self.showStyle {
            case .alert:
                let diming = self.dimingReference()
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: (controllerSize.height - size.height)*0.5, width: size.width, height: size.height)
                let willShowFrame = TSReferenceRect(container: containerFrame)
                
                let tranforms = self.alertTransform()
                
//                var willShowStates: WQReferenceStates = []
//                let dimWillShowalpha = TSReferenceValue(dimming: 0.0)
//                let containerWillShowalpha = TSReferenceValue(container: 0.0)
//
//                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: (controllerSize.height - size.height)*0.5, width: size.width, height: size.height)
//                let willShowTransform = TSReferenceTransform(container: CGAffineTransform(scaleX: 0.3, y: 0.3))
//                let willShowFrame = TSReferenceRect(container: containerFrame)
//                willShowStates.addState(layout, [dimWillShowalpha, containerWillShowalpha,willShowFrame,
//                                                 willShowTransform])
//
//                let showDimalpha = TSReferenceValue(dimming: 1.0)
//                let showConataineralpha = TSReferenceValue(container: 1.0)
//                let showRefrenceTransform = TSReferenceTransform(container: CGAffineTransform(scaleX: 1.05, y: 1.05))
//                var showStates: WQReferenceStates = []
//                showStates.addState(layout, [showDimalpha, showConataineralpha,showRefrenceTransform])
//
//                let didShowRefrenceTransform = TSReferenceTransform(container: .identity)
//                var didShowStates: WQReferenceStates = []
//                didShowStates.addState(layout, [didShowRefrenceTransform])
//
//
//                var hideStates: WQReferenceStates = []
//
//                let hideTransform = TSReferenceTransform(container: CGAffineTransform(scaleX: 0.6, y: 0.6))
//                hideStates.addState(layout, [hideTransform, dimWillShowalpha, containerWillShowalpha])
//
//                values[.willShow] = willShowStates
//                values[.show] = showStates
//                values[.didShow] = didShowStates
//                values[.hide] = hideStates
            case .actionSheet:
                var willShowStates: WQReferenceStates = []
                let dimWillShowalpha = TSReferenceValue(dimming: 0.0)
                let containerWillShowalpha = TSReferenceValue(container: 0.0)
                
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: controllerSize.height - size.height, width: size.width, height: size.height)
                let willShowTransform = TSReferenceTransform(container: CGAffineTransform(translationX: 0, y: size.height))
                let willShowFrame = TSReferenceRect(container: containerFrame)
                //这里设置transform 必须在设置frame之后 否则identity将会对应为 先设置的transform(离屏的frame)
                willShowStates.addState(layout, [dimWillShowalpha, containerWillShowalpha,willShowFrame,
                                                 willShowTransform ])
  
                let showDimalpha = TSReferenceValue(dimming: 1.0)
                let showConataineralpha = TSReferenceValue(container: 1.0)
                let showRefrenceTransform = TSReferenceTransform(container: CGAffineTransform(translationX: 0, y: -10))
                var showStates: WQReferenceStates = []
                showStates.addState(layout, [showDimalpha, showConataineralpha,showRefrenceTransform])
                 
                let didShowRefrenceTransform = TSReferenceTransform(container: .identity)
                var didShowStates: WQReferenceStates = []
                didShowStates.addState(layout, [didShowRefrenceTransform])
                
                
                var hideStates: WQReferenceStates = []
                let hideTransform = TSReferenceTransform(container: CGAffineTransform(translationX: 0, y: size.height))
                hideStates.addState(layout, [hideTransform, dimWillShowalpha, containerWillShowalpha])
                
                values[.willShow] = willShowStates
                values[.show] = showStates
                values[.didShow] = didShowStates
                values[.hide] = hideStates
        case let .pan(positions):
           if let willShowPostion = positions[.willShow],
            let showPostion = positions[.show],
            let hidePosition = positions[.hide] {
            let containerFrame = showPostion.frame(size: size, container: controllerSize, state: .show)
            let willShowPoint = willShowPostion.center(size: size, container: controllerSize, state: .willShow)
            let showPoint = showPostion.center(size: size, container: controllerSize, state: .show)
            let hidePoint = hidePosition.center(size: size, container: controllerSize, state: .hide)
            
            
            var willShowStates: WQReferenceStates = []
            let dimWillShowalpha = TSReferenceValue(dimming: 0.0)
            let containerWillShowalpha = TSReferenceValue(container: 0.0)
            
            let willShowTransform = TSReferenceTransform(container: CGAffineTransform(translationX: willShowPoint.x - showPoint.x, y: willShowPoint.y - showPoint.y))
            let willShowFrame = TSReferenceRect(container: containerFrame)
            //这里设置transform 必须在设置frame之后 否则identity将会对应为 先设置的transform(离屏的frame)
            willShowStates.addState(layout, [dimWillShowalpha, containerWillShowalpha,willShowFrame,
                                             willShowTransform])
            
            
            let showDimalpha = TSReferenceValue(dimming: 1.0)
            let showConataineralpha = TSReferenceValue(container: 1.0)
            let showRefrenceTransform = TSReferenceTransform(container: CGAffineTransform(translationX: -(willShowPoint.x - showPoint.x) * 0.1, y: -(willShowPoint.y - showPoint.y) * 0.1))
            var showStates: WQReferenceStates = []
            showStates.addState(layout, [showDimalpha, showConataineralpha,showRefrenceTransform])
            
            let didShowRefrenceTransform = TSReferenceTransform(container: .identity)
            var didShowStates: WQReferenceStates = []
            didShowStates.addState(layout, [didShowRefrenceTransform])
            
            var hideStates: WQReferenceStates = []
            let hideTransform = TSReferenceTransform(container: CGAffineTransform(translationX: hidePoint.x - showPoint.x, y: hidePoint.y - showPoint.y))
            hideStates.addState(layout, [hideTransform, dimWillShowalpha, containerWillShowalpha])
            values[.willShow] = willShowStates
            values[.show] = showStates
            values[.didShow] = didShowStates
            values[.hide] = hideStates
            
           }
            default:
                break
            }
        self.states.merge(values, uniquingKeysWith: {(_, new) in new })
    }
    
   private func dimingReference() -> [ModalState: TSReferenceWriteable] {
        var values: [ModalState: TSReferenceWriteable] = [:]
        if self.dimming {
            values[.willShow] = TSReferenceValue(dimming: 0.0)
            values[.show] = TSReferenceValue(dimming: 1.0)
            values[.hide] = values[.willShow]
        }
        return values
    }
    
    private func alertTransform() -> [ModalState: TSReferenceWriteable] {
        let initalValue = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let showValue = CGAffineTransform(scaleX: 1.05, y: 1.05)
        let didShowValue = CGAffineTransform.identity
        let hideValue = CGAffineTransform(scaleX: 0.4, y: 0.4)
        var values: [ModalState: TSReferenceWriteable] = [:]
        values[.willShow] = TSReferenceTransform(container: initalValue)
        values[.show] = TSReferenceTransform(container: showValue)
        values[.didShow] = TSReferenceTransform(container: didShowValue)
        values[.hide] = TSReferenceTransform(container: hideValue)
        return values
    }
    private func panContainerTransform(_ initial: CGPoint, show: CGPoint, hide: CGPoint, size: CGSize, frameSize: CGSize) -> [ModalState: TSReferenceWriteable] {
        let initalValue = CGAffineTransform(translationX: show.x - initial.x, y: show.y - initial.y)
        let showValue = CGAffineTransform(translationX: -(show.x - initial.x) * 0.1, y: -(show.y - initial.y) * 0.1)
        let didShowValue = CGAffineTransform.identity
        let hideValue = CGAffineTransform(translationX: hide.x - initial.x, y: hide.y - initial.y)
        var values: [ModalState: TSReferenceWriteable] = [:]
        values[.willShow] = TSReferenceTransform(container: initalValue)
        values[.show] = TSReferenceTransform(container: showValue)
        values[.didShow] = TSReferenceTransform(container: didShowValue)
        values[.hide] = TSReferenceTransform(container: hideValue)
        return values
    }
}
