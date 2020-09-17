//
//  ModalPresentationContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit
//https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html
open class ModalPresentationContext: ModalContext {
    lazy var driven: UIPercentDrivenInteractiveTransition = {
       let driven = UIPercentDrivenInteractiveTransition()
        return driven
    }()
    
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    
//    var presenter: UIViewController?
    
    public override init(_ viewController: WQLayoutController) {
        super.init(viewController)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
    }
    
    /// 开始当前的ViewController转场动画
    /// - Parameters:
    ///   - viewController: 承载present的viewController
    public override func show(in viewController: UIViewController?, animated flag: Bool, completion: ModalContext.Completion? = nil) {
        super.show(in: viewController, animated: flag, completion: completion)
        showViewController.transitioningDelegate = self
        showViewController.modalPresentationStyle = .custom
        fromViewController?.present(showViewController, animated: flag, completion: completion)
    }
    public override func dismiss(animated flag: Bool, completion: ModalContext.Completion? = nil) {
        showViewController.dismiss(animated: flag, completion: completion)
    }
    
    
    
}
extension ModalPresentationContext: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

      
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteracting ? self.driven : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteracting ? self.driven : nil
    } 
}
extension ModalPresentationContext: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVc = transitionContext.viewController(forKey: .from)
        let toVc = transitionContext.viewController(forKey: .to)
        
    }
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        return
//    }
    public func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
