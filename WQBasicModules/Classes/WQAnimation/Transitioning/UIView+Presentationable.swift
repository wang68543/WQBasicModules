//
//  UIView.swift
//  Pods
//
//  Created by WangQiang on 2019/1/7.
//

private var presenterKey: Void?

extension UIView {
    var presentation: WQPresentationable? {
        set {
            objc_setAssociatedObject(self, &presenterKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &presenterKey) as? WQPresentationable
        }
    }
}

public extension WQModules where Base: UIView {
    internal var presentation: WQPresentationable? {
        return self.base.presentation
    }
//    /// 内部没有强引用PresentationController 需要外部持有
//     internal func presentation(from: WQPresentionStyle.Position,
//                      show: WQPresentionStyle.Position,
//                      dismiss: WQPresentionStyle.Position? = nil) -> WQPresentationable {
//        let viewSize = self.base.frame.size
//        if viewSize == .zero {
//            self.base.setNeedsUpdateConstraints()
//            self.base.layoutIfNeeded()
//        }
//        assert(self.base.bounds.size != .zero, "view必须size不为0才能显示,便于动画")
//         let item = WQAnimatedItem(container: viewSize,
//                                   initial: from,
//                                   show: show,
//                                   dismiss: dismiss,
//                                   presentedFrame: UIScreen.main.bounds)
//        let animator = WQTransitioningAnimator(items: [item])
//        let presention = WQPresentationable(subView: self.base, animator: animator)
//        return presention
//    }
    /// 动画参数配置完成之后展示 内部没有强引用 需要外部强引用了presention 否则没效果
    internal func present(in viewController: UIViewController?, completion: (() -> Void)? = nil) {
        //使用下划线保存的返回变量 会在返回的时候就销毁了
        if let presention = self.presentation {
            presention.show(animated: true, in: viewController, completion: completion)
        }
    }
    /// 采用默认的动画风格展示
    func show(from: WQPresentionStyle.Position,
              show: WQPresentionStyle.Position,
              dismiss: WQPresentionStyle.Position? = nil,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) {
        let viewSize = self.base.frame.size
        if viewSize == .zero {
            self.base.setNeedsUpdateConstraints()
            self.base.layoutIfNeeded()
        }
        assert(self.base.bounds.size != .zero, "view必须size不为0才能显示,便于动画")
        let item = WQAnimatedItem(container: viewSize,
                                  initial: from,
                                  show: show,
                                  dismiss: dismiss,
                                  presentedFrame: UIScreen.main.bounds)
        self.show(items: [item], inController: inController, completion: completion)
//        let presention = self.presentation(from: from, show: show, dismiss: dismiss)
//        presention.show(animated: true, in: inController, completion: completion)
    }
    func show(items: WQAnimatedConfigItems,
              inController: UIViewController? = nil,
              completion: (() -> Void)? = nil) {
        let animator = WQTransitioningAnimator(items: items)
        let presention = WQPresentationable(subView: self.base, animator: animator)
        presention.show(animated: true, in: inController, completion: completion)
    }
   
    func dismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
        self.presentation?.dismiss(animated: true, completion: completion)
    }
}
