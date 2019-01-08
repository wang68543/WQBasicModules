//
//  WQPresentationConveniences.swift
//  Pods
//
//  Created by WangQiang on 2019/1/7.
//

private var presenterKey: Void?

extension WQModules where Base: UIView {
    public var presentation: WQPresentationable? {
        return objc_getAssociatedObject(self.base, &presenterKey) as? WQPresentationable
    }
    
    internal func setPresenter(_ viewController: UIViewController? ) {
        objc_setAssociatedObject(self.base, &presenterKey, viewController, .OBJC_ASSOCIATION_ASSIGN)//只用于便捷获取
    }
    /// 内部没有强引用PresentationController 需要外部持有
    public func presentation(from: WQPresentionStyle.Position,
                             show: WQPresentionStyle.Position,
                             dismiss: WQPresentionStyle.Position? = nil) -> WQPresentationable {
        if self.base.frame.size == .zero {
            self.base.layoutIfNeeded()
        }
        assert(self.base.bounds.size != .zero, "view必须size不为0才能显示,便于动画")
        let animator = WQTransitioningAnimator(size: self.base.frame.size,
                                               initial: from,
                                               show: show,
                                               dismiss: dismiss,
                                               presentedFrame: UIScreen.main.bounds)
        let presention = WQPresentationable(subView: self.base, animator: animator)
        return presention
    }
    /// 动画参数配置完成之后展示 内部没有强引用 需要外部强引用了presention 否则没效果
    public func present(in viewController: UIViewController?, completion: (() -> Void)? = nil) {
        //使用下划线保存的返回变量 会在返回的时候就销毁了
        if let presention = self.presentation {
            presention.show(animated: true, in: viewController, completion: completion)
        }
    }
    public func show(items: WQAnimatedConfigItems,
                     inController: UIViewController? = nil,
                     completion: (() -> Void)? = nil) {
        let animator = WQTransitioningAnimator(items: items)
        let presention = WQPresentationable(subView: self.base, animator: animator)
        presention.show(animated: true, in: inController, completion: completion)
    }
    /// 采用默认的动画风格展示
    public func show(from: WQPresentionStyle.Position,
                     show: WQPresentionStyle.Position,
                     dismiss: WQPresentionStyle.Position? = nil,
                     inController: UIViewController? = nil,
                     completion: (() -> Void)? = nil) {
        let presention = self.presentation(from: from, show: show, dismiss: dismiss)
        presention.show(animated: true, in: inController, completion: completion)
    }
    public func dismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
        self.presentation?.dismiss(animated: true, completion: completion)
    }
}
