//
//  PageViewController+UIScrollViewDelegate.swift
//  Pods
//
//  Created by WQ on 2020/4/8.
//

import UIKit

extension PageViewController: UIScrollViewDelegate {
   public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === controllerScrollView else { return }
        let offsetX = scrollView.contentOffset.x
        let viewW = scrollView.frame.width

        if offsetX >= 0.0 && offsetX <= CGFloat(controllerArray.count - 1) * viewW {
            if !didUserSelectedIndexToScroll {
                if didScrollAlready {
                    var newScrollDirection: PageScrollDirection = .unknown
                    let startDeltX = CGFloat(startingPageForScroll) * viewW - offsetX
                    if startDeltX > 0 {
                        newScrollDirection = .right
                    } else if startDeltX < 0 {
                        newScrollDirection = .left
                    }
                    if newScrollDirection != .unknown {
                        if lastScrollDirection != newScrollDirection {
                            let index = newScrollDirection == .left ? currentPageIndex + 1 : currentPageIndex - 1
                            addPageAtIndex(index)
                        }
                    }
                    lastScrollDirection = newScrollDirection
                }

                if !didScrollAlready {
                    if lastControllerScrollViewContentOffset > offsetX {
                        if currentPageIndex != controllerArray.count - 1 {
                            // Add page to the left of current page
                            let index = currentPageIndex - 1
                            addPageAtIndex(index)
                            lastScrollDirection = .right
                        }
                    } else if lastControllerScrollViewContentOffset < offsetX {
                        if currentPageIndex != 0 {
                            // Add page to the right of current page
                            let index = currentPageIndex + 1
                            addPageAtIndex(index)
                            lastScrollDirection = .left
                        }
                    }

                    didScrollAlready = true
                }

                lastControllerScrollViewContentOffset = offsetX
            }

//                        var ratio : CGFloat = 1.0

            // Calculate ratio between scroll views
//                        ratio = (menuScrollView.contentSize.width - self.view.frame.width) / (controllerScrollView.contentSize.width - self.view.frame.width)

//                        if menuScrollView.contentSize.width > self.view.frame.width {
//                            var offset : CGPoint = menuScrollView.contentOffset
//                            offset.x = controllerScrollView.contentOffset.x * ratio
//                            menuScrollView.setContentOffset(offset, animated: false)
//                        }

            // Calculate current page
            let page = Int((offsetX + 0.5 * viewW) / viewW)

            // Update page if changed
            if page != currentPageIndex {
                lastPageIndex = currentPageIndex
                currentPageIndex = page
                addPageAtIndex(page)
                if !didUserSelectedIndexToScroll {
                    // Make sure only up to 3 page views are in memory when fast scrolling, otherwise there should only be one in memory
                    let indexLeftTwo = page - 2
                    removePageAtIndex(indexLeftTwo)
                    let indexRightTwo = page + 2
                    removePageAtIndex(indexRightTwo)
                }
            }
            self.didSelectionIndicatorShouldChange?(page)
            // Move selection indicator view when swiping
//                        moveSelectionIndicator(page)
    } else {
//                    var ratio : CGFloat = 1.0
//
//                    ratio = (menuScrollView.contentSize.width - self.view.frame.width) / (controllerScrollView.contentSize.width - self.view.frame.width)
//
//                    if menuScrollView.contentSize.width > self.view.frame.width {
//                        var offset : CGPoint = menuScrollView.contentOffset
//                        offset.x = controllerScrollView.contentOffset.x * ratio
//                        menuScrollView.setContentOffset(offset, animated: false)
//                    }
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

//    @objc func scrollViewDidEndTapScrollingAnimation() {
//        // Call didMoveToPage delegate function
//        let currentController = controllerArray[currentPageIndex]
//        delegate?.didMoveToPage?(currentController, index: currentPageIndex)
//
//        var iterator = self.children.makeIterator()
//        while let controller = iterator.next() {
//            if currentController !== controller {
//                removePageController(controller)
//            }
//        }
//
//        startingPageForScroll = currentPageIndex
//        didUserSelectedIndexToScroll = false
//
//    }
}
