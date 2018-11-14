//
//  WQHorizontalTagsLayout.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2018/11/14.
//  参考此处 http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html?utm_source=tuicool

import UIKit
// MARK: - ==========整个View的属性===============
 ///属性决定主轴的方向（即项目的排列方向）
public enum WQFlexDirection: Int {
    
    /// （默认值）：主轴为水平方向，起点在左端。
    case row
    
    /// 主轴为水平方向，起点在右端。
    case rowReverse
    
    /// 主轴为垂直方向，起点在上沿。
    case column
    
    /// 主轴为垂直方向，起点在下沿。
    case columnReverse
}

/// 属性定义了项目在主轴上的对齐方式。
public enum WQJustifyContent: Int {
    
    /// （默认值）：左对齐
    case flexStart
    
    /// 右对齐
    case flexEnd
    
    /// 居中
    case center
    
    /// 两端对齐，项目之间的间隔都相等。
    case spaceBetween
    
    /// 每个项目两侧的间隔相等。所以，项目之间的间隔比项目与边框的间隔大一倍。
    case spaceAround
}
//定义项目在交叉轴上如何对齐。
public enum WQAlignItems: Int {
    
    /// 交叉轴的起点对齐。
    case flexStart
    
    /// 交叉轴的终点对齐。
    case flexEnd
    
    /// 交叉轴的中点对齐。
    case center
    
    /// 项目的第一行文字的基线对齐。
    case baseline
    
    /// （默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
    case stretch
}

//定义了多根轴线的对齐方式。如果项目只有一根轴线，该属性不起作用。
public enum WQAlignContent: Int {
    /// 交叉轴的起点对齐。
    case flexStart
    
    /// 交叉轴的终点对齐。
    case flexEnd
    
    /// 交叉轴的中点对齐。
    case center
    
    /// 与交叉轴两端对齐，轴线之间的间隔平均分布。
    case spaceBetween
    
    /// 每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。
    case spaceAround
    
    /// （默认值）：轴线占满整个交叉轴。
    case stretch
}
// MARK: - ==========整个View的属性END===============
// MARK: - ==========Cell属性==========
public enum WQAlignSelf: Int {
    case auto //继承自父View的属性
    /// 交叉轴的起点对齐。
    case flexStart
    
    /// 交叉轴的终点对齐。
    case flexEnd
    
    /// 交叉轴的中点对齐。
    case center
    
    /// 项目的第一行文字的基线对齐。
    case baseline
    
    /// （默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
    case stretch
}
// MARK: - ==========Cell属性END==========

public protocol WQFlexboxLayout: NSObjectProtocol {
    
    /// 返回每个Section的高度;当只有一个section的时候 高度默认为collectionView的height
    /// 主要用于当前如果direction是竖排排列的话 section内部布局
     func flexbox(_ flexbox: WQFlexbox, heightForSectionAt section: Int) -> CGFloat
     func flexbox(_ flexbox: WQFlexbox, alignItemAt indexPath: IndexPath) -> WQAlignSelf
}
extension WQFlexboxLayout {
    func flexbox(_ flexbox: WQFlexbox, alignItemAt indexPath: IndexPath) -> WQAlignSelf {
        return .center
    }
    func flexbox(_ flexbox: WQFlexbox, heightForSectionAt section: Int) -> CGFloat {
        fatalError("当cell垂直布局的时候,此协议方法必须代理对象实现")
        return 0
    }
}
public class WQFlexbox: UICollectionViewFlowLayout {
    weak var delegate: WQFlexboxLayout?
    
    /// Cells排列方向
    var direction: WQFlexDirection = .row
    
    /// 项目在主轴上的对齐方式
    var justify_content: WQJustifyContent = .flexStart
    
    /// 项目在交叉轴上如何对齐
    var align_items: WQAlignItems = .stretch
    
    /// 属性定义了多根轴线的对齐方式。如果项目只有一根轴线，该属性不起作用
    var align_content: WQAlignContent = .stretch
    
    /// 主轴方向的排列cell的个数 默认0 根据最小间距属性来动态计算每行的个数
    var lineItemsCount: Int = 0
    
    private var attrs: [UICollectionViewLayoutAttributes] = []
    
    override public func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else {
            debugPrint("请配合CollectionView使用")
            return
        }
        guard collectionView.frame.size != .zero else {
            debugPrint("尺寸不能为0")
            return
        }
        let eachLineCount = lineItemsCount
        
        let viewW = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        let viewH = collectionView.frame.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom
//        var sizes: [[CGSize]] = []
        let sections = collectionView.numberOfSections
        
        var items: [UICollectionViewLayoutAttributes] = []
        //TODO: - -- 计算所有项目的尺寸
//        for section in 0 ..< sections {
//            let items = collectionView.numberOfItems(inSection: section)
//            var sectionSizes: [CGSize] = []
//            for item in 0 ..< items {
//                let indexPath = IndexPath(item: item, section: section)
//                sectionSizes.append()
//            }
//            sizes.append(sectionSizes)
//        }
        // 每个分区内部
        var maxValue: CGFloat = 0
        var startValue: CGFloat = 0
        
        var flowSectionY: CGFloat = 0
        var flowSectionX: CGFloat = 0
        
        switch self.direction {
        case .column:
            flowSectionY = collectionView.contentInset.top
            flowSectionX = collectionView.contentInset.left
            for section in 0 ..< sections {
                let headerSize = self.referenceSizeForHeaderInSection(section)
                flowSectionX += self.sectionInset.left + headerSize.width
                flowSectionY += self.sectionInset.top  + headerSize.height
                
                let items = collectionView.numberOfItems(inSection: section)
                var lineAttrs: [UICollectionViewLayoutAttributes] = []
                for item in 0 ..< items {
                    let indexPath = IndexPath(item: item, section: section)
                    let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attr.frame = CGRect(origin: .zero, size: self.sizeForItem(at: indexPath))
                    
                }
            }
        case .columnReverse:
          
        case .row, .rowReverse:
            for section in 0 ..< sections {
                let items = collectionView.numberOfItems(inSection: section)
                var lineAttrs: [UICollectionViewLayoutAttributes] = []
                for item in 0 ..< items {
                    let indexPath = IndexPath(item: item, section: section)
                    let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attr.frame = CGRect(origin: .zero, size: self.sizeForItem(at: indexPath))
                    
                }
            }
        }
      
        attrs.removeAll()
        attrs.append(contentsOf: items)
        
    }
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
}

// MARK: - -- Data Source
private extension WQFlexbox {
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        if let collectionView = self.collectionView,
            let proxy = collectionView.delegate as? UICollectionViewDelegateFlowLayout{
            return proxy.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
        }
        return self.itemSize
    }
    
    func heightForSection(at section: Int) -> CGFloat {
        if let sections = self.collectionView?.numberOfSections,
            sections > 0 {
          return delegate?.flexbox(self, heightForSectionAt: section) ?? 0
        }
        return self.collectionView?.contentSize.height ?? 0
    }
    func insetForSection(at section: Int) -> UIEdgeInsets {
        if let collectionView = self.collectionView,
            let proxy = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            return proxy.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? self.sectionInset
        }
        return self.sectionInset
    }
    
    func minimumLineSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView,
            let proxy = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            return proxy.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? self.minimumLineSpacing
        }
        return self.minimumLineSpacing
    }
    
    func minimumInteritemSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView,
            let proxy = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            return proxy.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? self.minimumInteritemSpacing
        }
        return self.minimumInteritemSpacing
    }
    
    func referenceSizeForHeaderInSection(_ section: Int) -> CGSize {
        if let collectionView = self.collectionView,
            let proxy = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            return proxy.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? self.headerReferenceSize
        }
        return self.headerReferenceSize
    }
    
    func referenceSizeForFooterInSection(_ section: Int) -> CGSize {
        if let collectionView = self.collectionView,
            let proxy = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            return proxy.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? self.footerReferenceSize
        }
        return self.footerReferenceSize
    }
}
