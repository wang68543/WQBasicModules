//
//  FlexBox.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/5/10.
//

import UIKit

@objc public protocol FlexBoxDelegate: UICollectionViewDelegateFlowLayout {
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout flexBox: FlexBox, itemAlignSelf indexPath: NSIndexPath) -> FlexAlignItem
}
open class FlexBox: UICollectionViewFlowLayout {
//    mainAxis
//    crossAxis
    /// 属性决定主轴的方向（即项目的排列方向）
    open var flexDirection: FlexDirection = .row
    open var flexWrap: FlexWrap = .noWrap
    open var flexJustify: FlexJustify = .flexStart
    open var flexItem: FlexItem = .flexStart
    open var flexContent: FlexContent = .flexStart

}
