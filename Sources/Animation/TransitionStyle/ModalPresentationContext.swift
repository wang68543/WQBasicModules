//
//  ModalPresentationContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

class ModalPresentationContext: ModalContext {
    
}
//extension ModalPresentationContext: UIViewControllerTransitioningDelegate {
//    @available(iOS 2.0, *)
//      optional func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
//
//      
//      @available(iOS 2.0, *)
//      optional func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
//
//      
//      optional func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
//
//      
//      optional func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
//
//      
//      @available(iOS 8.0, *)
//      optional func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
//}
//extension ModalPresentationContext: UIViewControllerAnimatedTransitioning {
//    // This is used for percent driven interactive transitions, as well as for
//       // container controllers that have companion animations that might need to
//       // synchronize with the main animation.
//       func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
//
//       // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
//       func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
//
//       
//       /// A conforming object implements this method if the transition it creates can
//       /// be interrupted. For example, it could return an instance of a
//       /// UIViewPropertyAnimator. It is expected that this method will return the same
//       /// instance for the life of a transition.
//       @available(iOS 10.0, *)
//       optional func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating
//
//       
//       // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
//       optional func animationEnded(_ transitionCompleted: Bool)
//}
//extension ModalPresentationContext: UIPercentDrivenInteractiveTransition {
//    /// This is the non-interactive duration that was returned when the
//       /// animators transitionDuration: method was called when the transition started.
//       open var duration: CGFloat { get }
//
//       
//       /// The last percentComplete value specified by updateInteractiveTransition:
//       open var percentComplete: CGFloat { get }
//
//       
//       /// completionSpeed defaults to 1.0 which corresponds to a completion duration of
//       /// (1 - percentComplete)*duration.  It must be greater than 0.0. The actual
//       /// completion is inversely proportional to the completionSpeed.  This can be set
//       /// before cancelInteractiveTransition or finishInteractiveTransition is called
//       /// in order to speed up or slow down the non interactive part of the
//       /// transition.
//       open var completionSpeed: CGFloat
//
//       
//       /// When the interactive part of the transition has completed, this property can
//       /// be set to indicate a different animation curve. It defaults to UIViewAnimationCurveEaseInOut.
//       /// Note that during the interactive portion of the animation the timing curve is linear.
//       open var completionCurve: UIView.AnimationCurve
//
//       
//       /// For an interruptible animator, one can specify a different timing curve provider to use when the
//       /// transition is continued. This property is ignored if the animated transitioning object does not
//       /// vend an interruptible animator.
//       @available(iOS 10.0, *)
//       open var timingCurve: UITimingCurveProvider?
//
//       
//       /// Set this to NO in order to start an interruptible transition non
//       /// interactively. By default this is YES, which is consistent with the behavior
//       /// before 10.0.
//       @available(iOS 10.0, *)
//       open var wantsInteractiveStart: Bool
//
//       
//       /// Use this method to pause a running interruptible animator. This will ensure that all blocks
//       /// provided by a transition coordinator's notifyWhenInteractionChangesUsingBlock: method
//       /// are executed when a transition moves in and out of an interactive mode.
//       @available(iOS 10.0, *)
//       open func pause()
//
//       
//       // These methods should be called by the gesture recognizer or some other logic
//       // to drive the interaction. This style of interaction controller should only be
//       // used with an animator that implements a CA style transition in the animator's
//       // animateTransition: method. If this type of interaction controller is
//       // specified, the animateTransition: method must ensure to call the
//       // UIViewControllerTransitionParameters completeTransition: method. The other
//       // interactive methods on UIViewControllerContextTransitioning should NOT be
//       // called. If there is an interruptible animator, these methods will either scrub or continue
//       // the transition in the forward or reverse directions.
//       open func update(_ percentComplete: CGFloat)
//
//       open func cancel()
//
//       open func finish()
//}
