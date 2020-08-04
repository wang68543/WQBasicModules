//
//  UITabBarExtensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/7/30.
//

import Foundation
public extension UITabBar {
    
    
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
        guard let cls = NSClassFromString("UITabBarButton") else { return } 
        let items = self.subviews.filter({ $0.isKind(of: cls) }).sorted(by: { $0.frame.minX < $1.frame.minX })
        guard items.count > index else { return }
        
        bageView.tag = 100010 + index
        self.addSubview(bageView)
        let item = items[index]
        bageView.center = CGPoint(x: item.frame.midX + offset.horizontal, y: item.frame.midY + offset.vertical)
    }
    
    func bageView(for index: Int) -> UIView? {
        return self.viewWithTag(100010+index)
    }
    
    func hideBadgeOnItem(with index: Int) {
        guard let subView = bageView(for: index) else {
            return
        }
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
