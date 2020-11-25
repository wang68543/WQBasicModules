//
//  WQContainerView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/5.
//

import Foundation
import UIKit
public class WQContainerView: UIView {
    var currentView: UIView? {
        return self.subviews.last
    }
    /** translatesAutoresizingMaskIntoConstraints
    视图 使用代码创建，frame 布局 ，不用去管 translatesAutoresizingMaskIntoConstraints
    视图 使用代码创建，autolayout 布局，translatesAutoresizingMaskIntoConstraints 设置为 NO
    视图 IB 创建，frame 布局 , translatesAutoresizingMaskIntoConstraints 不用管 (IB 帮我们设置好了：YES)
    视图 IB 创建，autolayout 布局，translatesAutoresizingMaskIntoConstraints 不用管 (IB 帮我们设置好了，NO)
    center与bounds 结合不会设置 translatesAutoresizingMaskIntoConstraints 为NO 需要手动设置
    translatesAutoresizingMaskIntoConstraints 的本意是将 frame 布局 自动转化为 约束布局，转化的结果是为这个视图自动添加所有需要的约束，如果我们这时给视图添加自己创建的约束就一定会约束冲突。
 */
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let left = view.leftAnchor.constraint(equalTo: self.leftAnchor)
        let right = view.rightAnchor.constraint(equalTo: self.rightAnchor)
        let top = view.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([left,top,right,bottom])
        self.setNeedsUpdateConstraints()
    } 
    public func sizeThatFits(_ view: UIView? = nil) -> CGSize {
        if view == nil && !self.bounds.isEmpty { return self.bounds.size }
        guard let subView = view ?? self.subviews.first else { return .zero }
        return subView.modalSize
    }
}
