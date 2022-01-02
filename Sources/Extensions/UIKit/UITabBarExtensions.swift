//
//  UITabBarExtensions.swift
//  Pods
//
//  Created by WQ on 2020/7/30.
//
#if canImport(UIKit) && !os(watchOS)
import Foundation
public extension UITabBar {

    func itemCenter(for index: Int) -> CGPoint {
        guard let count = self.items?.count,
             count > 0 && index < count && index >= 0 else {
            return .zero
        }
        func layoutCenter(_ width: CGFloat, index: Int) -> CGPoint {
            let itemW = width/CGFloat(count)
            return CGPoint(x: itemW*(CGFloat(index)+0.5), y: 49*0.5)
        }
        if self.bounds.width == 0 {
            return layoutCenter(UIScreen.main.bounds.width, index: index)
        } else {
            guard let cls = NSClassFromString("UITabBarButton") else { return .zero }
            let items = self.subviews.filter({ $0.isKind(of: cls) }).sorted(by: { $0.frame.minX < $1.frame.minX && $0.frame.midX != 0 })
            if items.count < count {
                return layoutCenter(self.bounds.width, index: index)
            } else {
                return CGPoint(x: items[index].frame.midX, y: items[index].frame.midY)
            }
        }
    }
    /// 中心点默认显示在右上角
    /// - Parameters:
    ///   - index: tabBar 按照x坐标排列的下标 从0开始
    ///   - width: bage的宽度
    ///   - offset: 偏移位置
    func showBadgeOnItem(_ index: Int, width: CGFloat = 4, offset: UIOffset) {
        let badge = BadgeView()
        badge.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        self.showBadgeOnItem(index, bageView: badge, offset: offset)
    }

    func showBadgeOnItem(_ index: Int, bageView: UIView, offset: UIOffset) {
        self.hideBadgeOnItem(with: index)
        let position = self.itemCenter(for: index)
        bageView.tag = 100010 + index
        self.addSubview(bageView)
        bageView.center = CGPoint(x: position.x + offset.horizontal, y: position.y + offset.vertical)
    }

    func bageView(for index: Int) -> UIView? {
        return self.viewWithTag(100010+index)
    }

    func hideBadgeOnItem(with index: Int) {
        guard let subView = bageView(for: index) else { return }
        subView.removeFromSuperview()
    }
}
extension UITabBar {
    class BadgeView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .red
            self.layer.masksToBounds = true
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = self.frame.height * 0.5
        }

    }
}
#endif
