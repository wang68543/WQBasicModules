//
//  UIView.swift
//  Pods
//
//  Created by WangQiang on 2019/1/7.
//

// MARK: - common
public extension WQModules where Base: UIView {
    var presentation: WQPresentationable? {
        return self.base.presentation
    }
    //显示
    func show(animator: WQTransitioningAnimator,
              frame container: CGRect? = nil,
              presented: CGRect? = nil,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) {
        let presention = WQPresentationable(subView: self.base, animator: animator, containerFrame: container, presentedFrame: presented)
        presention.show(animated: true, in: inController, completion: completion)
    }
    
    func dismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
        self.presentation?.dismiss(animated: true, completion: completion)
    }
}

// MARK: - normal animate api
public extension WQModules where Base: UIView {
    /// 动画参数配置完成之后展示 内部没有强引用 需要外部强引用了presention 否则没效果
    internal func present(in viewController: UIViewController?, completion: (() -> Void)? = nil) {
        //使用下划线保存的返回变量 会在返回的时候就销毁了
        if let presention = self.presentation {
            presention.show(animated: true, in: viewController, completion: completion)
        }
    }
    /// 采用默认的动画风格展示
    func show(from: WQPresentationOption.Position,
              show: WQPresentationOption.Position,
              dismiss: WQPresentationOption.Position? = nil,
              isDimming: Bool = true,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) {
        if self.base.bounds.size == .zero {
            self.base.setNeedsUpdateConstraints()
            self.base.layoutIfNeeded()
        }
        assert(self.base.bounds.size != .zero, "view必须size不为0才能显示,便于动画")
        let viewSize = self.base.frame.size
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
        self.show(items: items, inController: inController, completion: completion)
    }
    
    func show(items: WQAnimatedConfigItems,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) {
        let animator = WQTransitioningAnimator(items: items)
       self.show(animator: animator, inController: inController, completion: completion)
    }
}

// MARK: - alert
public extension WQModules where Base: UIView {
    func alert(options present: WQTransitioningAnimator.Options = .alertPresent,
               dismiss: WQTransitioningAnimator.Options = .alertDismiss,
               isDimming: Bool = true,
               containerSize: CGSize? = nil,
               inController: UIViewController? = nil,
               completion: (() -> Void)? = nil) {
        let presentedFrame = UIScreen.main.bounds
        let viewW = presentedFrame.width
        let viewH = presentedFrame.height
        var size: CGSize
        if let vectorSize = containerSize {
            size = vectorSize
        } else {
            if self.base.bounds.size == .zero {
                self.base.setNeedsUpdateConstraints()
                self.base.layoutIfNeeded()
            }
            size = self.base.bounds.size
        }
        let frame = CGRect(x: (viewW - size.width) * 0.5,
                           y: (viewH - size.height) * 0.5,
                           width: size.width,
                           height: size.height)
        var items: [WQAnimatedConfigAble] = []
        let initial = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let dis = CGAffineTransform(scaleX: 0, y: 0)
        let item = WQAnimatedItem(containerTransform: initial, show: .identity, dismiss: dis)
        items.append(item)
        if isDimming {
            let dimmingBakcground = WQAnimatedItem.defaultViewBackground()
            items.append(dimmingBakcground)
        }
        let animator = WQTransitioningAnimator(items: items, options: present, dismiss: dismiss)
        self.show(animator: animator, frame: frame, inController: inController, completion: completion)
    }
    func actionSheet(options present: WQTransitioningAnimator.Options = .actionSheetPresent,
                     dismiss: WQTransitioningAnimator.Options = .actionSheetDismiss,
                     isDimming: Bool = true,
                     containerSize: CGSize? = nil,
                     inController: UIViewController? = nil,
                     completion: (() -> Void)? = nil) {
        let presentedFrame = UIScreen.main.bounds
        let viewW = presentedFrame.width
        let viewH = presentedFrame.height
        var size: CGSize
        if let vectorSize = containerSize {
            size = vectorSize
        } else {
            if self.base.bounds.size == .zero {
                self.base.setNeedsUpdateConstraints()
                self.base.layoutIfNeeded()
            }
            size = self.base.bounds.size
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
        let animator = WQTransitioningAnimator(items: items, options: present, dismiss: dismiss)
        self.show(animator: animator, frame: frame, inController: inController, completion: completion)
    } 
    
}
 
private var presenterKey: Void?

internal extension UIView {
    var presentation: WQPresentationable? {
        set {
            //这里内存由外部管理
            objc_setAssociatedObject(self, &presenterKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &presenterKey) as? WQPresentationable
        }
    }
}
