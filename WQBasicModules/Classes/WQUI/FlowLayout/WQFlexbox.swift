//
//  WQHorizontalTagsLayout.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2018/11/14.
//  参考此处 http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html?utm_source=tuicool

import UIKit
// MARK: - ==========整个View的属性===============
 ///属性决定主轴的方向（即项目的排列方向）
@objc public enum WQFlexDirection: Int {
    
    /// （默认值）：主轴为水平方向，起点在左端。
    case row
    
    /// 主轴为水平方向，起点在右端。
    case rowReverse
    
    /// 主轴为垂直方向，起点在上沿。
    case column
    
    /// 主轴为垂直方向，起点在下沿。
    case columnReverse
}
public extension WQFlexDirection {
    
    /// 是否是水平方向
    var isHorizontal: Bool {
        return self == .row || self == .rowReverse
    }
}
/// 属性定义了项目在主轴上的对齐方式。
@objc public enum WQJustifyContent: Int {
    
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
@objc public enum WQAlignItems: Int {
    
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
@objc public enum WQAlignContent: Int {
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
@objc public enum WQAlignSelf: Int {
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

@objc public protocol WQFlexboxDelegateLayout: UICollectionViewDelegateFlowLayout {
    
    /// 返回每个Section的高度;当只有一个section的时候 高度默认为collectionView的height
    /// 主要用于当前如果direction是竖排排列的话 section内部布局 (不包含header、footeru以及sectionInsets)
    @objc optional func flexbox(_ flexbox: WQFlexbox, sizeForSectionAt section: Int) -> CGSize
//    @objc optional func flexbox(_ flexbox: WQFlexbox, alignItemAt indexPath: IndexPath) -> WQAlignSelf
    /// Cells排列方向
    @objc optional func flexbox(_ flexbox: WQFlexbox, directionForSectionAt section: Int) -> WQFlexDirection
    @objc optional func flexbox(_ flexbox: WQFlexbox, justifyContentForSectionAt section: Int, inLine lineNum: Int, linesCount: Int) -> WQJustifyContent
     @objc optional func flexbox(_ flexbox: WQFlexbox, alignItemsForSectionAt section: Int, inLine lineNum: Int, with indexPath: IndexPath) -> WQAlignItems
     @objc optional func flexbox(_ flexbox: WQFlexbox, alignContentForSectionAt section: Int) -> WQAlignContent
}
//extension WQFlexboxDelegateLayout {
//    func flexbox(_ flexbox: WQFlexbox, alignItemAt indexPath: IndexPath) -> WQAlignSelf {
//        return .center
//    }
//    //返回0的时候 依次向下排
//    func flexbox(_ flexbox: WQFlexbox, sizeForSectionAt section: Int) -> CGSize {
//        return .zero
//    }
//    func flexbox(_ flexbox: WQFlexbox, directionForSectionAt section: Int) -> WQFlexDirection {
//        return .row
//    }
//}

/// 布局主要是针对每个Section里面的Cell 其他的正常布局
public class WQFlexbox: UICollectionViewFlowLayout {
    private weak var delegate: WQFlexboxDelegateLayout? {
        return self.collectionView?.delegate as? WQFlexboxDelegateLayout
    }
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
    
        // 每个分区内部
        
        var flowSectionY: CGFloat = 0
        var flowSectionX: CGFloat = 0
        
        flowSectionY = collectionView.contentInset.top
        flowSectionX = collectionView.contentInset.left
        var allAttrs: [[[UICollectionViewLayoutAttributes]]] = []
        for section in 0 ..< sections {
            let headerSize = self.referenceSizeForHeaderInSection(section)
            let lineSpace = self.minimumLineSpacingForSection(at: section)
            let interitemSpace = self.minimumInteritemSpacingForSection(at: section)
            let sectionSize = self.sizeForSection(at: section)
            let direction = self.directionForSection(at: section)
            let isHorizontal = direction.isHorizontal
            let insets = self.insetForSection(at: section)
            flowSectionX += insets.left + headerSize.width
            flowSectionY += insets.top + headerSize.height
            var sectionAttrs: [[UICollectionViewLayoutAttributes]] = []
            var lineAttrs: [UICollectionViewLayoutAttributes] = []
            let itemsCount = collectionView.numberOfItems(inSection: section)
            var maxValue: CGFloat = 0
            let limitValue: CGFloat = isHorizontal ? sectionSize.width : sectionSize.height
            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let itemSize = self.sizeForItem(at: indexPath)
                attr.frame = CGRect(origin: .zero, size: itemSize)
                if isHorizontal {
                    maxValue += itemSize.width + interitemSpace
                } else {
                    maxValue += itemSize.height + lineSpace
                }
                if maxValue < limitValue {
                    lineAttrs.append(attr)
                } else {
                    sectionAttrs.append(lineAttrs)
                    lineAttrs = []
                }
            }
            sectionAttrs.append(lineAttrs)
            allAttrs.append(sectionAttrs)
            switch direction {
            case .row:
                for index in 0 ..< sectionAttrs.count {
                    let lineAttrs = sectionAttrs[index]
                    let rowMaxH = lineAttrs.max(by: ({ $0.frame.height > $1.frame.height }))!.frame.height
                    let justtify = self.justifyContentForSection(at: section, inLine: index, total: lineAttrs.count)
                    var startX: CGFloat
                    var rowSectionW: CGFloat
                    switch justtify {
                    case .flexStart:
                        rowSectionW = interitemSpace
                        startX = insets.left + collectionView.contentInset.left
                    case .center:
                        rowSectionW = interitemSpace
                    case .flexEnd:
                        rowSectionW = interitemSpace
                    case .spaceAround:
                        break;
                    case .spaceBetween:
                        startX = insets.left + collectionView.contentInset.left
                    }
                    for idx in 0 ..< lineAttrs.count {
                        var ptX, ptY: CGFloat
                        let attr = lineAttrs[idx]
                        let alignItems = self.alignItemsForSection(at: section, inLine: index, with: attr.indexPath)
                        switch alignItems {
                        case .flexStart:
                        case .center:
                        case .flexEnd:
                        case .baseline:
                        case .stretch:
                        }
                        
                    }
                }
            case .rowReverse:
            case .column:
            case .columnReverse:
            }
            
            flowSectionY += sectionSize.height
            let footerSize = self.referenceSizeForFooterInSection(section)
            flowSectionY += footerSize.height + insets.bottom
        }
      
        attrs.removeAll()
        attrs.append(contentsOf: items)
        
    }
//    public func numberOfLines(inSection section: Int) -> Int {
//
//    }
//    public func
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
}

// MARK: - -- FlexboxLayout Datat Source
private extension WQFlexbox {
    func sizeForSection(at section: Int) -> CGSize {
        guard let collectionView = self.collectionView else {
            return .zero
        }
        var sectionSize: CGSize = .zero
        if collectionView.numberOfSections > 1 {
            sectionSize = delegate?.flexbox?(self, sizeForSectionAt: section) ?? .zero
        }
        if sectionSize == .zero {
            if collectionView.contentSize.height * collectionView.contentSize.width < collectionView.frame.width * collectionView.frame.height {
                sectionSize = collectionView.frame.size
            } else {
                sectionSize = collectionView.contentSize
            }
        }
        return sectionSize
    }
    
    func directionForSection(at section: Int) -> WQFlexDirection {
        return delegate?.flexbox?(self, directionForSectionAt: section) ?? self.direction
    }
    
    func justifyContentForSection(at section: Int, inLine: Int , total: Int) -> WQJustifyContent {
        return delegate?.flexbox?(self, justifyContentForSectionAt: section, inLine: inLine, linesCount: total) ?? self.justify_content
    }
    
    func alignItemsForSection(at section: Int, inLine: Int ,with indexPath: IndexPath) -> WQAlignItems {
        return delegate?.flexbox?(self, alignItemsForSectionAt: section, inLine: inLine, with: indexPath) ?? self.align_items
    }
    func alignContentForSection(at section: Int) -> WQAlignContent {
        return delegate?.flexbox?(self, alignContentForSectionAt: section) ?? self.align_content
    }
}
// MARK: - -- FlowLayout Data Source
private extension WQFlexbox {
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        //, let proxy = collectionView.delegate as? UICollectionViewDelegateFlowLayout
        if let collectionView = self.collectionView {
            return delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
        }
        return self.itemSize
    }
    func insetForSection(at section: Int) -> UIEdgeInsets {
        if let collectionView = self.collectionView {
            return delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? self.sectionInset
        }
        return self.sectionInset
    }
    
    func minimumLineSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView {
            return delegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? self.minimumLineSpacing
        }
        return self.minimumLineSpacing
    }
    
    func minimumInteritemSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView {
            return delegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? self.minimumInteritemSpacing
        }
        return self.minimumInteritemSpacing
    }
    
    func referenceSizeForHeaderInSection(_ section: Int) -> CGSize {
        if let collectionView = self.collectionView {
            return delegate?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? self.headerReferenceSize
        }
        return self.headerReferenceSize
    }
    
    func referenceSizeForFooterInSection(_ section: Int) -> CGSize {
        if let collectionView = self.collectionView {
            return delegate?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? self.footerReferenceSize
        }
        return self.footerReferenceSize
    }
}
