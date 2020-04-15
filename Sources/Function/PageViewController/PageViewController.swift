//
//  PageViewController.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/4/8.
//

import UIKit
@objc public protocol PageViewControllerDelegate: NSObjectProtocol {
    @objc optional func willMoveToPage(_ controller: UIViewController, index: Int)
    @objc optional func didMoveToPage(_ controller: UIViewController, index: Int)
}
open class PageViewController: UIViewController {
    // 参考 https://github.com/PageMenu/PageMenu.git
    // MARK: - Properties
    let controllerScrollView = UIScrollView()
    var controllerArray : [UIViewController] = []
   

    public internal(set) var currentPageIndex : Int = 0
    var lastPageIndex : Int = 0
    
    public var didSelectionIndicatorShouldChange: ((Int) -> ())?
//    var currentOrientationIsPortrait : Bool = true
//    var pageIndexForOrientationChange : Int = 0
//    var didLayoutSubviewsAfterRotation : Bool = false
    var didScrollAlready : Bool = false

    var lastControllerScrollViewContentOffset : CGFloat = 0.0
 
    var startingPageForScroll : Int = 0

    // 用户主动点击切换
    var didUserSelectedIndexToScroll: Bool = false

    open weak var delegate : PageViewControllerDelegate?

//    var tapTimer : Timer?
    var lastScrollDirection : PageScrollDirection = .unknown
    enum PageScrollDirection : Int {
        case left
        case right
        case unknown
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    public init(_ viewControllers: [UIViewController],
                frame: CGRect,
                startIndex index: Int = 0,
                in controller: UIViewController? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.controllerArray = viewControllers
        self.view.frame = frame
        if let parentController = controller {
            self.add(toParent: parentController)
        }
        setUpUserInterface()
        configureUserInterface(index)
    }
    
   public func add(toParent parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(self.view)
        didMove(toParent: parent)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
 
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewW = self.view.frame.width
        controllerScrollView.contentSize = CGSize(width: viewW * CGFloat(controllerArray.count), height: self.view.frame.height)
//        for view in controllerScrollView.subviews {
//            view.frame = self.view.bounds.offsetBy(dx: viewW * CGFloat(currentPageIndex), dy: 0)
//        }
//        let xOffset = CGFloat(self.currentPageIndex) * viewW
//        controllerScrollView.setContentOffset(CGPoint(x: xOffset, y: controllerScrollView.contentOffset.y), animated: false)
        self.view.layoutIfNeeded()
        debugPrint(#function)
    }
    
    func setUpUserInterface() {
        let viewsDictionary = ["controllerScrollView":controllerScrollView]
        
        // Set up controller scroll view
        controllerScrollView.isPagingEnabled = true
        controllerScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        controllerScrollView.frame = self.view.bounds
        if #available(iOS 11.0, *) {
           controllerScrollView.contentInsetAdjustmentBehavior = .never
        } else {
           self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(controllerScrollView)
        
        let controllerScrollView_constraint_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[controllerScrollView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let controllerScrollView_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[controllerScrollView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        self.view.addConstraints(controllerScrollView_constraint_H)
        self.view.addConstraints(controllerScrollView_constraint_V)
       
        controllerScrollView.showsHorizontalScrollIndicator = false
        controllerScrollView.showsVerticalScrollIndicator = false
    }
    
    func configureUserInterface(_ startIndex: Int) {
         
        controllerScrollView.delegate = self
        controllerScrollView.scrollsToTop = false
        
        controllerScrollView.alwaysBounceHorizontal = true
        
        controllerScrollView.bounces = true
         
        controllerScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(controllerArray.count), height: 0.0)
      
        let initialController = controllerArray[startIndex]
        initialController.viewWillAppear(true)
        self.addPageAtIndex(startIndex)
        initialController.viewDidAppear(true)
        
        startingPageForScroll = startIndex
        lastPageIndex = currentPageIndex
        currentPageIndex = startIndex
    }
}


extension PageViewController {
    // MARK: - Remove/Add Page
    func addPageAtIndex(_ index : Int) {
        guard let newVC = self.safeIndexOfArrayController(index) else { return }
    
        guard !self.children.contains(newVC) else { return }
        delegate?.willMoveToPage?(newVC, index: index)
        newVC.willMove(toParent: self)
        
        newVC.view.frame =  self.view.bounds.offsetBy(dx: self.view.frame.width * CGFloat(index), dy: 0)
        
        self.addChild(newVC)
        
        debugPrint("\(#function):index-\(index)")
        self.controllerScrollView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
    }
    
    func removePageAtIndex(_ index : Int) {
        guard let oldVC = self.safeIndexOfArrayController(index) else { return }
        removePageController(oldVC)
    }
    func indexOfControllerInArray(_ controller: UIViewController) -> Int? {
        return controllerArray.firstIndex(of: controller)
    }
    
    func removePageController(_ controller: UIViewController) {
        guard self.children.contains(controller) else { return }
        controller.willMove(toParent: nil)
        
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        
        controller.didMove(toParent: nil)
    }
    
  open func moveToPage(_ index: Int) {
    guard index >= 0 && index < controllerArray.count else { return }
      // Update page if changed
      if index != currentPageIndex {
          startingPageForScroll = index
          lastPageIndex = currentPageIndex
          currentPageIndex = index

          let smallerIndex = min(lastPageIndex, currentPageIndex)
          let largerIndex = max(lastPageIndex, currentPageIndex)
          
          if smallerIndex + 1 != largerIndex {
              for i in (smallerIndex + 1)...(largerIndex - 1) {
                addPageAtIndex(i)
              }
          }
          addPageAtIndex(index)
      }
    didUserSelectedIndexToScroll = true
    UIView.animate(withDuration: 0.25, animations: {
        let xOffset = CGFloat(index) * self.controllerScrollView.frame.width
        self.controllerScrollView.setContentOffset(CGPoint(x: xOffset, y: self.controllerScrollView.contentOffset.y), animated: false)
    }) { flag in
        self.didUserSelectedIndexToScroll = false
    }
  }
    
    private func safeIndexOfArrayController(_ index: Int) -> UIViewController? {
        guard index >= 0 && index < controllerArray.count else { return nil }
        return controllerArray[index]
    }
}
