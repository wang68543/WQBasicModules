//
//  UIView+Clipping.swift
//  Pods
//
//  Created by WangQiang on 2018/5/18.
//

import UIKit
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
        return (objc_getAssociatedObject(self, AssociatedKeys.isSnapping) as? Bool) ?? false
    }
    /// 用于tableView的截图
    private func sectionHeightForTableView(_ tableView: UITableView, rect: CGRect) -> CGFloat {
        var sectionHeight: CGFloat = 0
        let indexPaths = tableView.indexPathsForRows(in: rect)
        if let indexPath = indexPaths?.min(by: { $0.section < $1.section }) {
            if let height = tableView.delegate?.tableView?(tableView, heightForHeaderInSection: indexPath.section) {
                sectionHeight = height
            } else if tableView.sectionHeaderHeight != 0 {
                sectionHeight = tableView.sectionHeaderHeight
            } else if tableView.estimatedSectionHeaderHeight != 0 {
                sectionHeight = tableView.estimatedSectionHeaderHeight
                // 暂时不知道咋处理
            }
        }
        return sectionHeight
    }
    
    /// scrollView 根据bounds的size 截成多张图片 (主线程)
    ///
    /// - Returns: images
    func snapshots() -> [UIImage] {
        objc_setAssociatedObject(self, UITableView.AssociatedKeys.isSnapping, true, .OBJC_ASSOCIATION_ASSIGN)
        var images: [UIImage] = []
        let preOffset = self.contentOffset; let contentSize = self.contentSize
        let tableViewW = self.bounds.width; let tableViewH = self.bounds.height
        let cornerRadius: CGFloat = self.layer.cornerRadius; self.layer.cornerRadius = 0
        let scale = UIScreen.main.scale
        let contentH = contentSize.height * scale
        let snapH = tableViewH * scale; let snapW = self.frame.width * scale
        var offsetY: CGFloat = 0
        var isPlain = false
        if let tableView = self as? UITableView,
            tableView.style == .plain {
            isPlain = true
        }
        // 依次滚动tableView截取整个contentSize的内容 并裁剪出当前屏幕的内容
        while offsetY < contentSize.height {
            var sectionHeight: CGFloat = 0
            if offsetY > 0 && isPlain,
                let tableView = self as? UITableView {
                let visableRect = CGRect(x: 0, y: offsetY, width: tableViewW, height: tableViewH)
                sectionHeight = self.sectionHeightForTableView(tableView, rect: visableRect)
                offsetY -= sectionHeight //如果有头的
            }
            self.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            // 截取包含当前屏幕整个内容
            let snapImage = self.snapshot(contentSize)
            if let img = snapImage {
                let scaleSectionH = sectionHeight * scale
                let rectY = offsetY * scale + scaleSectionH
                let minRectH = contentH - rectY
                let rectH = min(snapH - scaleSectionH, minRectH)
                let rect = CGRect(x: 0, y: rectY, width: snapW, height: rectH)
                //截取当前屏幕
                if let cgImg = img.cgImage?.cropping(to: rect) {
                    let clipImg = UIImage(cgImage: cgImg, scale: scale, orientation: .up)
                    images.append(clipImg)
                }
            }
            offsetY += tableViewH
        }
        self.setContentOffset(preOffset, animated: false)
        self.layer.cornerRadius = cornerRadius
        objc_setAssociatedObject(self, UITableView.AssociatedKeys.isSnapping, nil, .OBJC_ASSOCIATION_ASSIGN)
        return images
    }
    /// tableView截图
    ///
    /// - Parameter minSize: 截图的最小尺寸
    /// - Returns: image
    func longSnapshot(_ minSize: CGSize = .zero) -> UIImage? {
        guard let faterView = self.superview,
            let superSnap = faterView.snapshot() else {
                fatalError("must has superView")
        }
        let coverImage = UIImageView(image: superSnap)
        coverImage.isUserInteractionEnabled = true //拦截事件
        faterView.addSubview(coverImage)
        let images: [UIImage] = self.snapshots()
        let cornerRadius: CGFloat = self.layer.cornerRadius 
        let drawSize = contentSize.height < minSize.height ? minSize : contentSize
        var clipPath: UIBezierPath?
        if cornerRadius > 0 {
            clipPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: drawSize), cornerRadius: cornerRadius)
        }
        let backColor = self.backgroundColor?.cgColor ?? UIColor.white.cgColor
        let longImage = images.splice(drawSize, defaultColor: backColor, clipPath: clipPath?.cgPath)
        coverImage.removeFromSuperview()
        return longImage
    }
}
