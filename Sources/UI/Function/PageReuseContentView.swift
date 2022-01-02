//
//  PageReuseContentView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/12/17.
//

import UIKit

/// 根据ViewController Class 进行动态创建的
open class PageReuseContentView: PageView {
    public let pageContentControllerType: UIViewController.Type
    /// controllers 的数量
    public var numberOfContentReuseControllers: Int = .zero

    /// 缓存ViewController
    public private(set) var cacheControllers: [Int: UIViewController] = [:]

    public init(_ pageController: UIPageViewController, type: UIViewController.Type) {
        self.pageContentControllerType = type
        super.init(pageController)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(_ count: Int, to index: Int) {
        self.cacheControllers.removeAll()
        self.numberOfContentReuseControllers = count
        move(to: index)
    }
    /// 验证是否有效
    public override func isValidate(_ index: Int) -> Bool {
        return index >= 0 && index < numberOfContentReuseControllers
    }
    public override func viewController(with index: Int) -> UIViewController? {
        guard isValidate(index) else { return nil }
        if let viewController = self.cacheControllers[index] {
            return viewController
        } else {
            let viewController = pageContentControllerType.init()
            self.cacheControllers[index] = viewController
            return viewController
        }
    }
    public override func index(of viewController: UIViewController) -> Int? {
        return self.cacheControllers.first(where: { $0.1 == viewController })?.0
    }
}
public extension PageReuseContentView {
    /// 初始时候显示的尺寸
    convenience init(_ type: UIViewController.Type,
                     pageStyle style: UIPageViewController.TransitionStyle = .scroll,
                     orientation: UIPageViewController.NavigationOrientation = .horizontal) {
        let controller = UIPageViewController(transitionStyle: style, navigationOrientation: orientation, options: nil)
        self.init(controller, type: type)
    }
}
