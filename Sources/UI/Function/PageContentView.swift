//
//  PageContentView.swift
//  Pods
//
//  Created by 王强 on 2020/12/17.
//

import Foundation
import UIKit

open class PageContentView: PageView {
    public private(set) var viewControllers: [UIViewController] = []

    open func setup(_ controllers: [UIViewController], with index: Int) {
        viewControllers = controllers
        move(to: index)
    }
    public override func isValidate(_ index: Int) -> Bool {
        return index >= 0 && index < viewControllers.count
    }

    public override func viewController(with index: Int) -> UIViewController? {
        guard isValidate(index) else { return nil }
        return viewControllers[index]
    }

    public override func index(of viewController: UIViewController) -> Int? {
        return self.viewControllers.firstIndex(of: viewController)
    }
}
public extension PageContentView {
    /// 初始时候显示的尺寸
    convenience init(_ controllers: [UIViewController],
                     index: Int = .zero,
                     pageStyle style: UIPageViewController.TransitionStyle = .scroll,
                     orientation: UIPageViewController.NavigationOrientation = .horizontal) {
        let controller = UIPageViewController(transitionStyle: style, navigationOrientation: orientation, options: nil)
        self.init(controller)
        setup(controllers, with: index)
    }
}
