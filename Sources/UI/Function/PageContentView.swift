//
//  PageContentView.swift
//  Pods
//
//  Created by 王强 on 2020/12/17.
//

import Foundation
import UIKit

open class PageContentView: UIView {
    
    public lazy var pageController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.delegate = self
        controller.dataSource = self
        return controller
    }()
    
    
    public private(set) var viewControllers: [UIViewController] = []
    
    public var pageIndexDidChange: ((Int) -> (Void))?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(pageController.view)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        pageController.view.frame = self.bounds
    }
    
    open func setup(_ controllers: [UIViewController], with index: Int) {
        viewControllers = controllers
        update(index)
    }
    
    open func update(_ index: Int) {
        pageController.setViewControllers([viewControllers[index]], direction: .reverse, animated: true, completion: nil)
    }
}
extension PageContentView: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
             index > 0 else {
            return nil
        }
        return viewControllers[index-1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[index+1]
    }
}
extension PageContentView: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = viewControllers.firstIndex(of: viewController) else {
            return
        }
        pageIndexDidChange?(index)
        debugPrint("\(index)")
    }
    // 开始滑动
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
}
