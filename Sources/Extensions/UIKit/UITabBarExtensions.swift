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
    ///   - index: tabBar 按照x坐标排列的下标
    ///   - width: bage的宽度
    ///   - offset: 偏移位置
    func showBadgeOnItem(_ index: Int, width: CGFloat = 4, offset: UIOffset) {
        self.hideBadgeOnItem(with: index)
        if  let selItem = selectedItem,
            let selIndex = self.items?.firstIndex(of: selItem) {
            if selIndex == index { // 当前正在展示的 不显示红点
                return
            }
        }
//        guard let cls = NSClassFromString("UITabBarButton") else { return }
        //.filter({ $0.isKind(of: cls) })
        let items = self.subviews.sorted(by: { $0.frame.minX < $1.frame.minX })
        guard items.count > index else { return }
        let badge = BadgeView()
        badge.tag = 100010 + index
        self.addSubview(badge)
        let item = items[index]
        let bageW: CGFloat = width
        badge.frame = CGRect(x: item.frame.midX + offset.horizontal - bageW*0.5, y: item.frame.minY-bageW*0.5+offset.vertical, width: bageW, height: bageW)
        }
        
        func hideBadgeOnItem(with index: Int) {
            guard let subView = self.viewWithTag(100010+index) else {
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
