//
//  PageViewController+UIScrollViewDelegate.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/4/8.
//

import UIKit

extension PageViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll2(_ scrollView: UIScrollView) {
//        if !didLayoutSubviewsAfterRotation {
//            if scrollView.isEqual(controllerScrollView) {
//                if scrollView.contentOffset.x >= 0.0 && scrollView.contentOffset.x <= (CGFloat(controllerArray.count - 1) * self.view.frame.width) {
//                    if (currentOrientationIsPortrait && UIApplication.shared.statusBarOrientation.isPortrait) || (!currentOrientationIsPortrait && UIApplication.shared.statusBarOrientation.isLandscape) {
//                        // Check if scroll direction changed
//                        if !didTapMenuItemToScroll {
//                            if didScrollAlready {
//                                var newScrollDirection : CAPSPageMenuScrollDirection = .other
//                                
//                                if (CGFloat(startingPageForScroll) * scrollView.frame.width > scrollView.contentOffset.x) {
//                                    newScrollDirection = .right
//                                } else if (CGFloat(startingPageForScroll) * scrollView.frame.width < scrollView.contentOffset.x) {
//                                    newScrollDirection = .left
//                                }
//                                
//                                if newScrollDirection != .other {
//                                    if lastScrollDirection != newScrollDirection {
//                                        let index : Int = newScrollDirection == .left ? currentPageIndex + 1 : currentPageIndex - 1
//                                        
//                                        if index >= 0 && index < controllerArray.count {
//                                            // Check dictionary if page was already added
//                                            if pagesAddedDictionary[index] != index {
//                                                addPageAtIndex(index)
//                                                pagesAddedDictionary[index] = index
//                                            }
//                                        }
//                                    }
//                                }
//                                
//                                lastScrollDirection = newScrollDirection
//                            }
//                            
//                            if !didScrollAlready {
//                                if (lastControllerScrollViewContentOffset > scrollView.contentOffset.x) {
//                                    if currentPageIndex != controllerArray.count - 1 {
//                                        // Add page to the left of current page
//                                        let index : Int = currentPageIndex - 1
//                                        
//                                        if pagesAddedDictionary[index] != index && index < controllerArray.count && index >= 0 {
//                                            addPageAtIndex(index)
//                                            pagesAddedDictionary[index] = index
//                                        }
//                                        
//                                        lastScrollDirection = .right
//                                    }
//                                } else if (lastControllerScrollViewContentOffset < scrollView.contentOffset.x) {
//                                    if currentPageIndex != 0 {
//                                        // Add page to the right of current page
//                                        let index : Int = currentPageIndex + 1
//                                        
//                                        if pagesAddedDictionary[index] != index && index < controllerArray.count && index >= 0 {
//                                            addPageAtIndex(index)
//                                            pagesAddedDictionary[index] = index
//                                        }
//                                        
//                                        lastScrollDirection = .left
//                                    }
//                                }
//                                
//                                didScrollAlready = true
//                            }
//                            
//                            lastControllerScrollViewContentOffset = scrollView.contentOffset.x
//                        }
//                        
//                        var ratio : CGFloat = 1.0
//                        
//                        
//                        // Calculate ratio between scroll views
//                        ratio = (menuScrollView.contentSize.width - self.view.frame.width) / (controllerScrollView.contentSize.width - self.view.frame.width)
//                        
//                        if menuScrollView.contentSize.width > self.view.frame.width {
//                            var offset : CGPoint = menuScrollView.contentOffset
//                            offset.x = controllerScrollView.contentOffset.x * ratio
//                            menuScrollView.setContentOffset(offset, animated: false)
//                        }
//                        
//                        // Calculate current page
//                        let width : CGFloat = controllerScrollView.frame.size.width;
//                        let page : Int = Int((controllerScrollView.contentOffset.x + (0.5 * width)) / width)
//                        
//                        // Update page if changed
//                        if page != currentPageIndex {
//                            lastPageIndex = currentPageIndex
//                            currentPageIndex = page
//                            
//                            if pagesAddedDictionary[page] != page && page < controllerArray.count && page >= 0 {
//                                addPageAtIndex(page)
//                                pagesAddedDictionary[page] = page
//                            }
//                            
//                            if !didTapMenuItemToScroll {
//                                // Add last page to pages dictionary to make sure it gets removed after scrolling
//                                if pagesAddedDictionary[lastPageIndex] != lastPageIndex {
//                                    pagesAddedDictionary[lastPageIndex] = lastPageIndex
//                                }
//                                
//                                // Make sure only up to 3 page views are in memory when fast scrolling, otherwise there should only be one in memory
//                                let indexLeftTwo : Int = page - 2
//                                if pagesAddedDictionary[indexLeftTwo] == indexLeftTwo {
//                                    pagesAddedDictionary.removeValue(forKey: indexLeftTwo)
//                                    removePageAtIndex(indexLeftTwo)
//                                }
//                                let indexRightTwo : Int = page + 2
//                                if pagesAddedDictionary[indexRightTwo] == indexRightTwo {
//                                    pagesAddedDictionary.removeValue(forKey: indexRightTwo)
//                                    removePageAtIndex(indexRightTwo)
//                                }
//                            }
//                        }
//                        
//                        // Move selection indicator view when swiping
//                        moveSelectionIndicator(page)
//                    }
//                } else {
//                    var ratio : CGFloat = 1.0
//                    
//                    ratio = (menuScrollView.contentSize.width - self.view.frame.width) / (controllerScrollView.contentSize.width - self.view.frame.width)
//                    
//                    if menuScrollView.contentSize.width > self.view.frame.width {
//                        var offset : CGPoint = menuScrollView.contentOffset
//                        offset.x = controllerScrollView.contentOffset.x * ratio
//                        menuScrollView.setContentOffset(offset, animated: false)
//                    }
//                }
//            }
//        } else {
//            didLayoutSubviewsAfterRotation = false
//            
//            // Move selection indicator view when swiping
//            moveSelectionIndicator(currentPageIndex)
//        }
//    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === controllerScrollView else { return }
        let offsetX = scrollView.contentOffset.x
        let viewW = scrollView.frame.width
        guard offsetX >= 0.0 && offsetX <= CGFloat(controllerArray.count - 1) * viewW else {
            return
        }
//        if self.didUserSelectedIndexToScroll == false {
            if didScrollAlready {
                var newScrollDirection: PageScrollDirection = .unknown
                if (CGFloat(startingPageForScroll) * viewW > offsetX) {
                    newScrollDirection = .right
                } else if (CGFloat(startingPageForScroll) * viewW < offsetX) {
                    newScrollDirection = .left
                }
                if newScrollDirection != .unknown {
                    if lastScrollDirection != newScrollDirection {
                        let index = newScrollDirection == .left ? currentPageIndex + 1 : currentPageIndex - 1
                        addPageAtIndex(index)
                    }
                    lastScrollDirection = newScrollDirection
                }
            } else {
                if (lastControllerScrollViewContentOffset > offsetX) {
                    if currentPageIndex != controllerArray.count - 1 {
                        let index : Int = currentPageIndex - 1
                        addPageAtIndex(index)
                        lastScrollDirection = .right
                    }
                } else if (lastControllerScrollViewContentOffset < offsetX) {
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
//        }
        let page = Int((offsetX + 0.5 * viewW) / viewW)
        if page != currentPageIndex {
            lastPageIndex = currentPageIndex
            currentPageIndex = page
            addPageAtIndex(page)
            if !didUserSelectedIndexToScroll {
                let indexLeftTwo : Int = page - 2
                let indexRightTwo : Int = page + 2
                removePageAtIndex(indexLeftTwo)
                removePageAtIndex(indexRightTwo)
            } 
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
