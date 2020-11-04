//
//  UIView+Clipping.swift
//  Pods
//
//  Created by WangQiang on 2018/5/18.
//

import UIKit

// MARK: - --clip
public extension UIView {
    /// 设置view的圆角
    ///
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 圆角位置
    func maskCorners(_ radius: CGFloat, corners: UIRectCorner = .allCorners) {
        if corners.contains(.allCorners) {
            layer.cornerRadius = radius
            layer.masksToBounds = true
        } else {
            guard self.bounds.size != .zero else {
                fatalError("设置不规则圆角必须先有尺寸")
            }
           makeRectangleCorners(CGSize(width: radius, height: radius), react: self.bounds, corners: corners)
        }
    }

    /// 设置方形边框
    func makeRectangleCorners(_ cornerSize: CGSize, react: CGRect, corners: UIRectCorner = .allCorners) {
        let bounds = self.bounds
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerSize)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }

    /// 截屏
    func snapshot(_ size: CGSize = .zero) -> UIImage? {
        let drawSize = (size == .zero) ? self.bounds.size : size
        // 这里的截屏起始点 是从(0,0)开始的 只绘制bound的区域 其余区域黑屏
        UIGraphicsBeginImageContextWithOptions(drawSize, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIScrollView {
    struct AssociatedKeys {
        static let isSnapping = UnsafeRawPointer(bitPattern: "wq.view.clip.isSnapping".hashValue)!
    }

    var isSnapping: Bool {
        return (objc_getAssociatedObject(self, UIScrollView.AssociatedKeys.isSnapping) as? Bool) ?? false
    }

    fileprivate func snapshotScroll(_ drawSize: CGSize, clipPath: CGPath? = nil) -> UIImage? {
        let contentSize = self.contentSize
        let viewSize = self.frame.size
        var offsetY: CGFloat = 0
        var offsetX: CGFloat = 0
        // 依次滚动tableView截取整个contentSize的内容 并裁剪出当前屏幕的内容
        UIGraphicsBeginImageContextWithOptions(drawSize, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        if let path = clipPath {
            context.addPath(path)
            context.clip()
        }
        while offsetY < contentSize.height && offsetX < contentSize.width {
            context.saveGState()
            autoreleasepool(invoking: {
                self.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
                let rect = CGRect(x: offsetX, y: offsetY, width: viewSize.width, height: viewSize.height)
                //将当前View在屏幕中显示的内容画到rect区域
                self.drawHierarchy(in: rect, afterScreenUpdates: true)
                offsetX += rect.width
                if offsetX >= contentSize.width && offsetY <= contentSize.height {
                    offsetX = 0
                    offsetY += rect.height
                }
            })
        }
        if clipPath != nil {
            context.drawPath(using: .stroke)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /// 无感知截屏 (在scrollView上面覆盖一个View隐藏截屏时候的操作)
    func snapping(_ minSize: CGSize) -> UIImage? {
        guard let faterView = self.superview,
            let superSnap = faterView.snapshotView(afterScreenUpdates: true) else {
                debugPrint("must has superView")
                return nil
        }
        faterView.addSubview(superSnap)
        let long = self.longSnapshot(minSize)
        superSnap.removeFromSuperview()
        return long
    }
    /// tableView截图
    ///
    /// - Parameter minSize: 截图的最小尺寸
    /// - Returns: image
    func longSnapshot(_ size: CGSize? = nil) -> UIImage? {
        objc_setAssociatedObject(self, UIScrollView.AssociatedKeys.isSnapping, true, .OBJC_ASSOCIATION_ASSIGN)
        let preOffset = self.contentOffset
        let cornerRadius: CGFloat = self.layer.cornerRadius
        self.layer.cornerRadius = 0
        var drawSize: CGSize
        if let size = size {
            drawSize = size
        } else {
            drawSize = contentSize
        }
        var clipPath: UIBezierPath?
        if cornerRadius > 0 {
            clipPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: drawSize), cornerRadius: cornerRadius)
        }
        var longImage: UIImage?
        if let tableView = self as? UITableView {
            longImage = tableView.snapshotTable(drawSize, clipPath: clipPath?.cgPath)
        } else {
            longImage = self.snapshotScroll(drawSize, clipPath: clipPath?.cgPath)
        }
        self.setContentOffset(preOffset, animated: false)
        self.layer.cornerRadius = cornerRadius
        objc_setAssociatedObject(self, UIScrollView.AssociatedKeys.isSnapping, nil, .OBJC_ASSOCIATION_ASSIGN)
        return longImage
    }
}
fileprivate extension UITableView {

    func snapshotTable(_ drawSize: CGSize, clipPath: CGPath? = nil) -> UIImage? {
        if self.style == .plain {
            let scale = UIScreen.main.scale
            let contentSize = self.contentSize
            UIGraphicsBeginImageContextWithOptions(drawSize, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return nil
            }
            if let path = clipPath {
                context.addPath(path)
                context.clip()
            }
            let tableViewW = self.bounds.width
            let tableViewH = self.bounds.height
            var offsetY: CGFloat = 0
            // 依次滚动tableView截取整个contentSize的内容 并裁剪出当前屏幕的内容
            while offsetY < contentSize.height {
                var sectionHeight: CGFloat = 0
                if offsetY > 0 {
                    let visableRect = CGRect(x: 0, y: offsetY, width: tableViewW, height: tableViewH)
                    sectionHeight = suspendedHeaderHeight(for: visableRect)
                    offsetY -= sectionHeight //如果有头的
                }
                self.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
//                context.saveGState()
                //释放绘图对象
                autoreleasepool(invoking: {
                    let contentH = tableViewH - sectionHeight
                    UIGraphicsBeginImageContextWithOptions(CGSize(width: tableViewW, height: contentH), false, scale)
                    let rect = CGRect(x: 0, y: -sectionHeight, width: tableViewW, height: tableViewH)
                    self.drawHierarchy(in: rect, afterScreenUpdates: true)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                   UIGraphicsEndImageContext()
                    if let img = image {//图片拼接
                        img.draw(in: CGRect(x: 0, y: offsetY + sectionHeight, width: tableViewW, height: contentH))
                    }
                    offsetY += tableViewH
                })
            }
            if clipPath != nil {
                context.drawPath(using: .fillStroke)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        } else {
            return self.snapshotScroll(drawSize, clipPath: clipPath)
        }
    }
    /// 当前rect(已滚动到当前区域)区域悬停的头部的高度
    func suspendedHeaderHeight(for rect: CGRect) -> CGFloat {
        var sectionHeight: CGFloat = 0
        let indexPaths = self.indexPathsForRows(in: rect)
        if let indexPath = indexPaths?.min(by: { $0.section < $1.section }) {
            if let height = delegate?.tableView?(self, heightForHeaderInSection: indexPath.section) {
                sectionHeight = height
            } else if self.sectionHeaderHeight != 0 {
                sectionHeight = self.sectionHeaderHeight
            } else if self.estimatedSectionHeaderHeight != 0 {
                sectionHeight = self.estimatedSectionHeaderHeight
                // 暂时不知道咋处理
            }
        }
        return sectionHeight
    }
}
