//
//  PageViewController+UIScrollViewDelegate.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/4/8.
//

import UIKit

extension PageViewController: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === controllerScrollView else { return }
        let offsetX = scrollView.contentOffset.x
        let viewW = scrollView.frame.width
        guard offsetX >= 0.0 && offsetX <= CGFloat(controllerArray.count - 1) * viewW else {
            return
        }
          
        if self.didUserSelectedIndexToScroll == false {
            if didScrollAlready {
                var newScrollDirection: PageScrollDirection = .unknown
                if (CGFloat(startingPageForScroll) * viewW > offsetX) {
                    newScrollDirection = .right
                } else if (CGFloat(startingPageForScroll) * viewW < offsetX) {
                    newScrollDirection = .left
                }
                if newScrollDirection != .unknown {
                    if lastScrollDirection != newScrollDirection {
                        let index : Int = newScrollDirection == .left ? currentPageIndex + 1 : currentPageIndex - 1
                        addPageAtIndex(index)
                    }
                    lastScrollDirection = newScrollDirection
                }
            } else {
                if (lastControllerScrollViewContentOffset > offsetX) {
                    if currentPageIndex != controllerArray.count - 1 {
                        // Add page to the left of current page
                        let index : Int = currentPageIndex - 1
                        addPageAtIndex(index)
                        lastScrollDirection = .right
                    }
                } else if (lastControllerScrollViewContentOffset < offsetX) {
                    if currentPageIndex != 0 {
                        // Add page to the right of current page
                        let index : Int = currentPageIndex + 1
                        addPageAtIndex(index)
                        lastScrollDirection = .left
                    }
                }
                
                didScrollAlready = true
            }
            
            lastControllerScrollViewContentOffset = offsetX
        }
    }
    
   public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === controllerScrollView else { return }
        // Call didMoveToPage delegate function
        let currentController = controllerArray[currentPageIndex]
        delegate?.didMoveToPage?(currentController, index: currentPageIndex)
        var iterator = self.children.makeIterator()
        while let controller = iterator.next() {
            if currentController !== controller {
                removePageController(controller)
            }
        }
        didScrollAlready = false
        startingPageForScroll = currentPageIndex
    }
    
    @objc func scrollViewDidEndTapScrollingAnimation() {
        // Call didMoveToPage delegate function
        let currentController = controllerArray[currentPageIndex]
        delegate?.didMoveToPage?(currentController, index: currentPageIndex) 
        
        var iterator = self.children.makeIterator()
        while let controller = iterator.next() {
            if currentController !== controller {
                removePageController(controller)
            }
        }
        
        startingPageForScroll = currentPageIndex
        didUserSelectedIndexToScroll = false
         
    }
}
