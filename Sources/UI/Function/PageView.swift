//
//  PageView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/12/17.
//

import UIKit
public protocol PageContentController: NSObjectProtocol {
    var pageIndex: Int { get set }
}

open class PageView: UIView {

    public let pageController: UIPageViewController
    /// 当前的索引
    public internal(set) var currentIndex: Int = .max

    public var pageDidChange: ((Int) -> Void)?
    /// 重复
//    public var isLoop: Bool = false

    public init(_ pageController: UIPageViewController) {
        self.pageController = pageController
        super.init(frame: .zero)
        self.addSubview(pageController.view)
        pageController.delegate = self
        pageController.dataSource = self
    }
    /// 验证索引是否有效
    public func isValidate(_ index: Int) -> Bool {
        fatalError("子类实现")
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        pageController.view.frame = self.bounds
    }
    /// 移动到指定的页面
    open func move(to index: Int) {
        guard let viewController = self.viewController(with: index) else {
            return
        }
        config(visible: viewController, with: index)
        pageController.setViewControllers([viewController], direction: .reverse, animated: true) { [weak self] _ in
            guard let `self` = self else { return }
            // MARK: - 这里 不会回调block 以及不调用 didFinishAnimating
            self.currentIndex = index
        }
    }
    /// 为content ViewController 配置索引
    public func config(visible viewController: UIViewController, with index: Int) {
        guard let page = viewController as? PageContentController else {
            return
        }
        page.pageIndex = index
    }

    public func viewController(with index: Int) -> UIViewController? {
       fatalError("子类实现")
    }
    public func index(of viewController: UIViewController) -> Int? {
        fatalError("子类实现")
    }
}
extension PageView: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = index(of: viewController),
             let viewController = self.viewController(with: index-1) else {
            return nil
        }
        config(visible: viewController, with: index - 1)
        return viewController
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = index(of: viewController),
              let viewController = self.viewController(with: index+1) else {
            return nil
        }
        config(visible: viewController, with: index+1)
        return viewController
    }
}
extension PageView: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = index(of: viewController) else {
            return
        }
        currentIndex = index
        pageDidChange?(index)
    }
    // 开始滑动
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {

    }
}
