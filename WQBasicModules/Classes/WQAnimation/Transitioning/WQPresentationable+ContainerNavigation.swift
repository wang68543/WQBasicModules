//
//  WQPresentationable+ContainerNavigation.swift
//  Pods
//
//  Created by WangQiang on 2019/1/20.
//

import Foundation
// MARK: - -- transition between sibling containerView childViews
extension WQPresentationable {
    private var defaultDuration: TimeInterval {
        return 0.15
    }
    
    internal func addContainerSubview(_ subView: UIView) {
        subView.presentation = self
        containerView.addSubview(subView)
        addConstraints(for: subView)
    }
    private func addConstraints(for subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                subView.topAnchor.constraint(equalTo: containerView.topAnchor),
                subView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                subView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                subView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
        } else {
            let left = NSLayoutConstraint(item: subView,
                                          attribute: .left,
                                          relatedBy: .equal,
                                          toItem: containerView,
                                          attribute: .left,
                                          multiplier: 1.0,
                                          constant: 0)
            let right = NSLayoutConstraint(item: subView,
                                           attribute: .right,
                                           relatedBy: .equal,
                                           toItem: containerView,
                                           attribute: .right,
                                           multiplier: 1.0,
                                           constant: 0)
            let top = NSLayoutConstraint(item: subView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: containerView,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: 0)
            let bottom = NSLayoutConstraint(item: subView,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: containerView,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 0)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
    /// 容器里面view的转场动画
    public func transitionContainer(from fromView: UIView,
                                    to toView: UIView,
                                    duration: TimeInterval,
                                    options: UIView.AnimationOptions = [],
                                    animations: (() -> Void)?,
                                    completion: ((Bool) -> Void)? = nil) {
        guard self.childViews.last !== toView  else {
            debugPrint("traget show view is current ")
            return
        }
        self.addContainerSubview(toView)
        UIView.transition(from: fromView, to: toView, duration: duration, options: options) { flag in
            if flag {
                fromView.removeFromSuperview()
            } else {
                toView.removeFromSuperview()
            }
            completion?(flag)
        }
        if let animateOperation = animations {
            UIView.animate(withDuration: duration, animations: animateOperation)
        }
    }
    public func push(to toView: UIView, options: UIView.AnimationOptions = .transitionFlipFromRight, completion: ((Bool) -> Void)? = nil) {
        if self.childViews.isEmpty {
            self.addContainerSubview(toView)
            self.childViews.append(toView)
        } else {
            self.transitionContainer(from: self.childViews.last!,
                                     to: toView,
                                     duration: defaultDuration,
                                     animations: nil,
                                     completion: { flag in
                                        if flag {
                                            if let index = self.childViews.firstIndex(of: toView) {
                                                self.childViews.remove(at: index)
                                            }
                                            self.childViews.append(toView)
                                        }
                                        completion?(flag)
            })
        }
    }
    /// 判断是否为空处理 (当 当前数组里面的个数小于一个的时候就直接整个dismiss掉)
    private func isEmptyPopHandle(_ completion: ((Bool) -> Void)? = nil) -> Bool {
        guard self.childViews.count > 1 else {
            self.dismiss(animated: true) {
                completion?(true)
            }
            debugPrint("current is root childView so direct dismiss controller")
            return true
        }
        return false
    }
    public func pop(toRoot options: UIView.AnimationOptions = .transitionFlipFromLeft, completion: ((Bool) -> Void)? = nil) {
        guard !self.isEmptyPopHandle(completion) else {
            return
        }
        self.pop(to: self.childViews.first!, options: options, completion: completion)
    }
    public func pop(_ options: UIView.AnimationOptions = .transitionFlipFromLeft, completion: ((Bool) -> Void)? = nil) {
        guard !self.isEmptyPopHandle(completion) else {
            return
        }
        self.pop(to: self.childViews[self.childViews.count - 2], options: options, completion: completion)
    }
    public func pop(to toView: UIView, options: UIView.AnimationOptions = .transitionFlipFromLeft, completion: ((Bool) -> Void)? = nil) {
        guard !self.isEmptyPopHandle(completion) else {
            return
        }
        guard let index = self.childViews.firstIndex(of: toView) else {
            debugPrint("\(toView) is not containerView hierarchy")
            return
        }
        let from = self.childViews.last!
        self.transitionContainer(from: from, to: toView, duration: defaultDuration, options: options, animations: nil) { flag in
            if flag {
                self.childViews.removeLast(index)
            }
            completion?(flag)
        }
    }
    
}
