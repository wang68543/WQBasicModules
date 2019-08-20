//
//  UIView.swift
//  Pods
//
//  Created by WangQiang on 2019/1/7.
//

// MARK: - common
public extension WQModules where Base: UIView {
    var presentation: WQTransitionable? {
        return self.base.presentation
    }
    //显示
    @discardableResult
    func show(animator: WQTransitionAnimator,
              frame container: CGRect? = nil,
              presented: CGRect? = nil,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) -> WQTransitionable {
        let presention = WQTransitionable(subView: self.base, animator: animator, containerFrame: container, presentedFrame: presented)
        presention.show(animated: true, in: inController, completion: completion)
        return presention
    }
    
    func dismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
        self.presentation?.dismiss(animated: true, completion: completion)
    }
    
    
}

// MARK: - normal animate api
public extension WQModules where Base: UIView {
    /// 在页面show之后此处才有值 动画参数配置完成之后展示 内部没有强引用 需要外部强引用了presention 否则没效果
    internal func present(in viewController: UIViewController?, completion: (() -> Void)? = nil) {
        //使用下划线保存的返回变量 会在返回的时候就销毁了
        if let presention = self.presentation {
            presention.show(animated: true, in: viewController, completion: completion)
        }
    }
    /// 自己直接设置动画尺寸
    @discardableResult
    func show(from: CGRect,
              show: CGRect,
              dismiss: CGRect? = nil,
              isDimming: Bool = true,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) -> WQTransitionable {
        let item = WQAnimatedItem(containerFrame: from, show: show, dismiss: dismiss)
        var items: [WQAnimatedConfigAble] = []
        items.append(item)
        if isDimming {
            let dimmingBakcground = WQAnimatedItem.defaultViewBackground()
            items.append(dimmingBakcground)
        }
       return self.show(items: items, inController: inController, completion: completion)
    }
    /// 采用默认的动画风格展示
    @discardableResult
    func show(from: WQTransitionOption.Position,
              show: WQTransitionOption.Position,
              dismiss: WQTransitionOption.Position? = nil,
              isDimming: Bool = true,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) -> WQTransitionable {
        let viewSize = self.base.layoutUpdates()
        let item = WQAnimatedItem(container: viewSize,
                                  initial: from,
                                  show: show,
                                  dismiss: dismiss,
                                  presentedFrame: UIScreen.main.bounds)
        var items: [WQAnimatedConfigAble] = []
        items.append(item)
        if isDimming {
           let dimmingBakcground = WQAnimatedItem.defaultViewBackground()
            items.append(dimmingBakcground)
        }
        return self.show(items: items, inController: inController, completion: completion)
    }
    //    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
    //        CATransaction.begin()
    //        let animation: CAKeyframeAnimation
    //        switch direction {
    //        case .horizontal:
    //            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    //        case .vertical:
    //            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
    //        }
    //        switch animationType {
    //        case .linear:
    //            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    //        case .easeIn:
    //            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    //        case .easeOut:
    //            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    //        case .easeInOut:
    //            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    //        }
    //        CATransaction.setCompletionBlock(completion)
    //        animation.duration = duration
    //        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    //        layer.add(animation, forKey: "shake")
    //        CATransaction.commit()
    //    }
    @discardableResult
    func show(items: WQAnimatedConfigItems,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) -> WQTransitionable {
        let animator = WQTransitionAnimator(items: items)
       return self.show(animator: animator, inController: inController, completion: completion)
    }
}

// MARK: - alert
public extension WQModules where Base: UIView {
    @discardableResult
    func alert(_ isDimming: Bool = true,
               containerSize: CGSize? = nil,
               inController: UIViewController? = nil,
               completion: (() -> Void)? = nil) -> WQTransitionable {
        let presentedFrame = UIScreen.main.bounds
        let viewW = presentedFrame.width
        let viewH = presentedFrame.height
        var size: CGSize
        if let vectorSize = containerSize {
            size = vectorSize
        } else {
            size = self.base.layoutUpdates()
        }
        let frame = CGRect(x: (viewW - size.width) * 0.5,
                           y: (viewH - size.height) * 0.5,
                           width: size.width,
                           height: size.height)
        var items: [WQAnimatedConfigAble] = []
        let initial = CGAffineTransform(scaleX: 0.5, y: 0.5)
        // 这里不能用scale 0,否则在手势驱动动画的时候会出现bounds与frame不一致的异常
        let dis = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let item = WQAnimatedItem(containerTransform: initial, show: .identity, dismiss: dis)
        items.append(item)
        if isDimming {
            let dimmingBakcground = WQAnimatedItem.defaultViewBackground()
            items.append(dimmingBakcground)
        }
        let animator = WQTransitionAnimator(items: items, options: .alertPresent, dismiss: .alertDismiss)
        return self.show(animator: animator, frame: frame, inController: inController, completion: completion)
    }
    @discardableResult
    func actionSheet(_ isDimming: Bool = true,
                     containerSize: CGSize? = nil,
                     inController: UIViewController? = nil,
                     completion: (() -> Void)? = nil) -> WQTransitionable {
        let presentedFrame = UIScreen.main.bounds
        let viewW = presentedFrame.width
        let viewH = presentedFrame.height
        var size: CGSize
        if let vectorSize = containerSize {
            size = vectorSize
        } else {
            size = self.base.layoutUpdates()
        }
        var items: [WQAnimatedConfigAble] = []
        let frame = CGRect(x: (viewW - size.width) * 0.5, y: viewH - size.height, width: size.width, height: size.height)
        let initial = CGAffineTransform(translationX: 0, y: viewH)
        let item = WQAnimatedItem(containerTransform: initial, show: .identity)
        items.append(item)
        if isDimming {
            let dimmingBakcground = WQAnimatedItem.defaultViewBackground()
            items.append(dimmingBakcground)
        }
        let animator = WQTransitionAnimator(items: items, options: .actionSheetPresent, dismiss: .actionSheetDismiss)
        return self.show(animator: animator, frame: frame, inController: inController, completion: completion)
    } 
    
}
 
private var presenterKey: Void?

internal extension UIView {
    var presentation: WQTransitionable? {
        set {
            //这里内存由外部管理
            objc_setAssociatedObject(self, &presenterKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &presenterKey) as? WQTransitionable
        }
    }
    
    func layoutUpdates() -> CGSize {
        guard self.bounds.size == .zero else {
            return self.bounds.size
        }
        UIView.performWithoutAnimation {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
        assert(self.bounds.size != .zero, "view必须size不为0才能显示,便于动画")
        return self.bounds.size
    }
}
