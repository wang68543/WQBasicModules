//
//  StyleConfig+Config.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/3/11.
//

import Foundation
@available(iOS 10.0, *)
public extension StyleConfig {
    func setupStates(_ layout: WQLayoutController, config: ModalConfig) {
        var values: [ModalState: ModalMapItems] = [:]
        let size = layout.container.sizeThatFits()
        let controllerSize = config.showControllerFrame.size
        switch self.showStyle {
            case .alert:
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: (controllerSize.height - size.height)*0.5, width: size.width, height: size.height)
                let willShowFrame = ModalRect(container: containerFrame)
                let tranforms = self.alertTransform()
                var references: [ModalState: [ModalKeyPath]] = [:]
                references.combine([.willShow: willShowFrame])
                if config.dimming {
                    let diming = self.dimingReference()
                    references.combine(diming)
                }
                references.combine(tranforms)
                references.combine(self.alertAlpha())
                for (key, items) in references {
                    values[key] = [ModalMapItem(layout, refrences: items)]
                }
            case .actionSheet:
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: controllerSize.height - size.height, width: size.width, height: size.height)
                let willShowFrame = ModalRect(container: containerFrame)
                let tranforms = self.actionSheetTransform(size, container: controllerSize)
                var references: [ModalState: [ModalKeyPath]] = [:]
                references.combine([.willShow: willShowFrame])
                if config.dimming {
                    let diming = self.dimingReference()
                    references.combine(diming)
                }
                references.combine(tranforms)
                for (key, items) in references {
                    values[key] = [ModalMapItem(layout, refrences: items)]
                }
            case let .pan(positions):
               if let willShowPostion = positions[.willShow],
                let showPostion = positions[.show],
                let hidePosition = positions[.hide] {
                let containerFrame = showPostion.frame(size: size, container: controllerSize, state: .show)
                let willShowPoint = willShowPostion.center(size: size, container: controllerSize, state: .willShow)
                let showPoint = showPostion.center(size: size, container: controllerSize, state: .show)
                let hidePoint = hidePosition.center(size: size, container: controllerSize, state: .hide)
                let willShowFrame = ModalRect(container: containerFrame)
                let tranforms = self.panTransform(willShowPoint, show: showPoint, hide: hidePoint)
                var references: [ModalState: [ModalKeyPath]] = [:]
                references.combine([.willShow: willShowFrame])
                if config.dimming {
                    let diming = self.dimingReference()
                    references.combine(diming)
                }
                references.combine(tranforms)
                for (key, items) in references {
                    values[key] = [ModalMapItem(layout, refrences: items)]
                }
               }
            case let .popup(position, anchorPoint, direction):

                let origin = CGPoint(x: position.x - anchorPoint.x * size.width, y: position.y - anchorPoint.y * size.height)

                func horizontalExpend(_ anchorPtX: CGFloat) -> CGRect {
                    if anchorPtX < 0.5 { // 向右展开
                        return CGRect(x: origin.x, y: origin.y, width: .zero, height: size.height)
                    } else if anchorPtX > 0.5 { // 向左展开
                        return CGRect(x: origin.x+size.width, y: origin.y, width: .zero, height: size.height)
                    } else {
                        return CGRect(x: origin.x+size.width*0.5, y: origin.y, width: .zero, height: size.height)
                    }
                }
                func verticalExpend(_ anchorPtY: CGFloat) -> CGRect {
                    if anchorPtY < 0.5 { // 向下展开
                        return CGRect(x: origin.x, y: origin.y, width: size.width, height: .zero)
                    } else if anchorPtY > 0.5 { // 向上展开
                        return CGRect(x: origin.x, y: origin.y+size.height, width: size.width, height: .zero)
                    } else {
                        return CGRect(x: origin.x, y: origin.y+size.height*0.5, width: size.width, height: .zero)
                    }
                }

                let willShowFrame: CGRect
                switch direction {
                case .left:
                    willShowFrame = horizontalExpend(1.0)
                case .down:
                    willShowFrame = verticalExpend(0.0)
                case .right:
                    willShowFrame = horizontalExpend(0.0)
                case .up:
                    willShowFrame = verticalExpend(1.0)
                case .horizontalMiddle:
                    willShowFrame = horizontalExpend(0.5)
                case .verticalMiddle:
                    willShowFrame = verticalExpend(0.5)
                case .horizontalAuto:
                    willShowFrame = horizontalExpend(anchorPoint.x)
                case .verticalAuto:
                    willShowFrame = verticalExpend(anchorPoint.y)
                }

                let didShowFrame = CGRect(origin: origin, size: size)
                let scale: CGFloat = 1.03
                let showFrame = CGRect(x: origin.x - (size.width * (scale - 1.0))*0.5, y: origin.y - (size.height * (scale - 1.0))*0.5, width: size.width*scale, height: size.height*scale)

                let willShow = ModalRect(container: willShowFrame)
                let show = ModalRect(container: showFrame)
                let didShow = ModalRect(container: didShowFrame)

                var references: [ModalState: [ModalKeyPath]] = [:]
                references.combine([.willShow: willShow, .show: show, .didShow: didShow, .hide: willShow])
                if config.dimming {
                    let diming = self.dimingReference()
                    references.combine(diming)
                }
                for (key, items) in references {
                    values[key] = [ModalMapItem(layout, refrences: items)]
                }
            default:
                break
            }
        self.states.merge(values, uniquingKeysWith: {(_, new) in new })
    }
  /// 遮罩属性动画
   private func dimingReference() -> [ModalState: ModalKeyPath] {
        var values: [ModalState: ModalKeyPath] = [:]
        values[.willShow] = ModalFloat(dimming: 0.0)
        values[.show] = ModalFloat(dimming: 0.85)
        values[.didShow] = ModalFloat(dimming: 1.0)
        values[.hide] = values[.willShow]
        return values
    }
    /// AlertStyle:容器的透明度属性
    private func alertAlpha() -> [ModalState: ModalKeyPath] {
        var values: [ModalState: ModalKeyPath] = [:]
        values[.willShow] = ModalFloat(container: 0.0)
        values[.show] = ModalFloat(container: 1.0)
        values[.didShow] = ModalFloat(container: 1.0)
        values[.hide] = values[.willShow]
        return values
    }
    /// AlertStyle: 容器的transform属性
    private func alertTransform() -> [ModalState: ModalKeyPath] {
        let initalValue = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let showValue = CGAffineTransform(scaleX: 1.05, y: 1.05)
        let didShowValue = CGAffineTransform.identity
        let hideValue = CGAffineTransform(scaleX: 0.4, y: 0.4)
        var values: [ModalState: ModalKeyPath] = [:]
        values[.willShow] = ModalTransform(container: initalValue)
        values[.show] = ModalTransform(container: showValue)
        values[.didShow] = ModalTransform(container: didShowValue)
        values[.hide] = ModalTransform(container: hideValue)
        return values
    }
    /// actionSheet: 容器的transform属性
    private func actionSheetTransform(_ size: CGSize, container: CGSize) -> [ModalState: ModalKeyPath] {
        let inital = CGPoint(x: 0, y: container.height + size.height*0.5)
        let show = CGPoint(x: 0, y: container.height - size.height*0.5)
        let hide = inital
        return panTransform(inital, show: show, hide: hide)
    }
    /// pan: 容器的transform属性
    private func panTransform(_ initial: CGPoint, show: CGPoint, hide: CGPoint) -> [ModalState: ModalKeyPath] {
        let initalValue = CGAffineTransform(translationX: initial.x - show.x, y: initial.y - show.y)
        let showValue = CGAffineTransform(translationX: -min((initial.x - show.x) * 0.05, 15), y: -min((initial.y - show.y) * 0.05, 15))
        let didShowValue = CGAffineTransform.identity
        let hideValue = CGAffineTransform(translationX: hide.x - show.x, y: hide.y - show.y)
        var values: [ModalState: ModalKeyPath] = [:]
        values[.willShow] = ModalTransform(container: initalValue)
        values[.show] = ModalTransform(container: showValue)
        values[.didShow] = ModalTransform(container: didShowValue)
        values[.hide] = ModalTransform(container: hideValue)
        return values
    }
}

extension Dictionary where Key == ModalState, Value == ModalMapItems {
    // TODO: - 这里要考虑 在设置didShow的时候 有的属性没有didShow状态只有show状态
    func setup(forState state: ModalState) {
        self[state]?.setup(for: state)
    }
}
