//
//  WQHorizontalTagsLayout.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2018/11/14.
//  参考此处 http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html?utm_source=tuicool

import UIKit 
public protocol WQFlexboxDelegateLayout: UICollectionViewDelegateFlowLayout {
    func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, justifyContentFor linePath: WQFlexLinePath) -> WQJustifyContent
    func flexbox(_ collectionView: UICollectionView,
                 flexbox: WQFlexbox,
                 alignItemsFor section: Int,
                 with linePath: WQFlexLinePath,
                 in indexPath: IndexPath) -> WQAlignItems
}
/// 布局主要是针对每个Section里面的Cell 其他的正常布局
public class WQFlexbox: UICollectionViewFlowLayout {
    
    public var direction: WQFlexDirection = .row
    /// 整个line主轴方向在section中的排列方式
    public var justifyContent: WQJustifyContent = .flexStart
    /// 若line中有item有尺寸不相等的以尺寸最大的item进行相对布局(当direction为水平方向时参照最大的height 否则参照最大的width)
    public var alignItems: WQAlignItems = .center
    /// 动态调整每个section中lines之间的间距,以及first line section 顶部或右侧间距 (只有单个section且内容不超过高度的时候起作用)
    public var alignContent: WQAlignContent = .flexStart
    /// 主轴方向的排列cell的个数 默认0 根据最小间距属性来动态计算每行的个数
    /// 存储items的布局属性
    private var attrs: [UICollectionViewLayoutAttributes] = []
    /// 存储supplementary的布局属性
    private var supplementary: [UICollectionViewLayoutAttributes] = []
    /// 不包含contentInset
    private var contentSize: CGSize = .zero
//    private var contentWidth: CGFloat = 0
    private var limitLength: CGFloat = 0
    
    override public
    func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else {
                debugPrint("请配合CollectionView使用,并且尺寸不为零")
                return
        }
        guard collectionView.frame.size != .zero else {
            return
        }
        let isHorizontal = self.direction.isHorizontal
        if isHorizontal { //水平方向 限制宽度为collectionView的frame宽度
            self.limitLength = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        } else {
            self.limitLength = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        }
        let sections = collectionView.numberOfSections
        
        let groupItems: [[[WQFlexItemAttributes]]] = self.groupItems(isHorizontal, limitValue: self.limitLength, sections: sections)
        
        let sectionAttrs: [WQFlexSectionAttributes] = self.sectionsAttrbutes(isHorizontal, sections: sections, groupItems: groupItems)
        
        attrs = self.layoutSectionsItems(isHorizontal, sectionAttributes: sectionAttrs)
        
        supplementary = self.layoutSupplementaries(isHorizontal, sectionAttrs: sectionAttrs)
        if isHorizontal {
            let length = sectionAttrs.reduce(0, { $0 + $1.bounds.height })
            contentSize = CGSize(width: collectionView.frame.width, height: length)
        } else {
            let length = sectionAttrs.reduce(0, { $0 + $1.bounds.width })
            contentSize = CGSize(width: length, height: collectionView.frame.height)
        }
    }
    
    public override
    var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    public override
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else {
            return false
        }
        return collectionView.bounds.size != newBounds.size
    }
    
    public override
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = attrs.first(where: { $0.indexPath == indexPath })
        return attr
    }
    
    public override
    func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                              at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = supplementary.first(where: { $0.indexPath == indexPath && $0.representedElementKind == elementKind })
        return attr
    }
    
    public override
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs + supplementary
    }
}
private extension WQFlexbox {
    func groupItems(_ isHorizontal: Bool, limitValue: CGFloat, sections: Int) -> [[[WQFlexItemAttributes]]] {
        var groupItems: [[[WQFlexItemAttributes]]] = []
        //分组 分列
        for section in 0 ..< sections {
            let items = collectionView!.numberOfItems(inSection: section)
            let insets = self.insetForSection(at: section)
            let itemSpace = self.minimumInteritemSpacingForSection(at: section)
            let headerSize = self.referenceSizeForHeaderInSection(section)
            let footerSize = self.referenceSizeForFooterInSection(section)
            var limit: CGFloat
            if isHorizontal {
                limit = limitValue - (insets.left + insets.right)
            } else {
                limit = limitValue - (insets.top + insets.bottom + footerSize.height + headerSize.height)
            }
            var sectionItems: [[WQFlexItemAttributes]] = []
            var lineItems: [WQFlexItemAttributes] = []
            var maxValue: CGFloat = 0
            for item in 0 ..< items {
                let indexPath = IndexPath(item: item, section: section)
                let itemSize = self.sizeForItem(at: indexPath)
                let attr = WQFlexItemAttributes(indexPath: indexPath, size: itemSize)
                let itemLength = isHorizontal ? itemSize.width : itemSize.height
                 maxValue += itemLength + itemSpace
                //notaFIXME: 需要确认边界问题
                if maxValue + itemLength > limit {
                    maxValue = itemLength + itemSpace
                    sectionItems.append(lineItems)
                    lineItems = []
                }
                lineItems.append(attr)
            }
            sectionItems.append(lineItems)
            groupItems.append(sectionItems)
        }
        return groupItems
    }
    /// 所有分区的FlexSections
     //swiftlint:disable function_body_length
    func sectionsAttrbutes(_ isHorizontal: Bool,
                           sections: Int,
                           groupItems: [[[WQFlexItemAttributes]]]) -> [WQFlexSectionAttributes] {
        var sectionAttrs: [WQFlexSectionAttributes] = []
        guard let collectionView = self.collectionView else { return sectionAttrs }
        for section in 0 ..< groupItems.count {
            let lineSpace = self.minimumLineSpacingForSection(at: section)
            let itemSpace = self.minimumInteritemSpacingForSection(at: section)
            let header = self.referenceSizeForHeaderInSection(section)
            let footer = self.referenceSizeForFooterInSection(section)
            let insets = self.insetForSection(at: section)
            var limitValue: CGFloat
            if isHorizontal {
                limitValue = self.limitLength - insets.left - insets.right
            } else {
                limitValue = self.limitLength - insets.top - insets.bottom - footer.height - header.height
            }
            let sectionLines = groupItems[section]
            var lineAttrs: [WQFlexLineAttributes] = []
            let lineCount = sectionLines.count
            for line in 0 ..< lineCount {
                let items = sectionLines[line]
                let range = Range(uncheckedBounds: (lower: items.first?.indexPath.item ?? 0, upper: items.last?.indexPath.item ?? 0))
                let linePath = WQFlexLinePath(section: section, line: line, totalLines: lineCount, range: range)
                if items.isEmpty {
                    let lineAttr = WQFlexLineAttributes(linePath, items: items, margin: .zero, isHorizontal: isHorizontal)
                    lineAttrs.append(lineAttr)
                } else { 
                    let justify = self.justifyContent(for: linePath)
                    //  swiftlint:disable line_length
                    let flexSpace = WQFlexLineSpace(items, limitLength: limitValue, justify: justify, minItemsSpace: itemSpace, isHorizontal: isHorizontal)
                    let lineAttr = WQFlexLineAttributes(linePath, items: items, margin: flexSpace, isHorizontal: isHorizontal)
                    lineAttrs.append(lineAttr)
                }
            }
            var totalLineMaxWidth: CGFloat
            if isHorizontal {
                let contentClip = collectionView.contentInset.top + collectionView.contentInset.bottom
                let sectionClip = insets.bottom + insets.top
                let headerFooterClip = header.height + footer.height
                totalLineMaxWidth = collectionView.frame.height - contentClip - headerFooterClip - sectionClip
            } else {
                let contentClip = collectionView.contentInset.left + collectionView.contentInset.right
                let sectionClip = insets.left + insets.right
                totalLineMaxWidth = collectionView.frame.width - contentClip - sectionClip
            }
            var sectionAttr = WQFlexSectionAttributes(section, header: header, footer: footer, insets: insets, lines: lineAttrs)
            sectionAttr.config(viewWidth: totalLineMaxWidth, alignContent: self.alignContent, lineSpace: lineSpace, sections: sections)
            sectionAttr.config(isHorizontal)
            sectionAttrs.append(sectionAttr)
        }
        return sectionAttrs
    }
    func layoutSectionsItems(_ isHorizontal: Bool, sectionAttributes: [WQFlexSectionAttributes]) -> [UICollectionViewLayoutAttributes] {
        var rectX = collectionView!.contentInset.left
        var rectY = collectionView!.contentInset.top
        let itemAttrs = sectionAttributes.flatMap({ sectionAttr -> [UICollectionViewLayoutAttributes] in
            let sectionOrigin = CGPoint(x: rectX, y: rectY)
            let sectionItems = self.sectionItemsAttributes(forSection: isHorizontal, sectionOrigin: sectionOrigin, sectionAttr: sectionAttr)
            if isHorizontal { //横向排列就纵向滚动
                rectY += sectionAttr.bounds.height
            } else {
                rectX += sectionAttr.bounds.width
            }
            return sectionItems
        })
        return itemAttrs
    }
    /// 单个Section所有Item的 LayoutAttributes
    func sectionItemsAttributes(forSection isHorizontal: Bool,
                                sectionOrigin: CGPoint,
                                sectionAttr: WQFlexSectionAttributes) -> [UICollectionViewLayoutAttributes] {
        var originY = sectionOrigin.y
        var originX = sectionOrigin.x
        originY = sectionOrigin.y + sectionAttr.headerSize.height
        if isHorizontal {
            originY += sectionAttr.headerSize.height + sectionAttr.edge.lineHeader
        } else {
            originX += sectionAttr.edge.lineHeader
        }
        var sectionX = originX
        var sectionY = originY
        let sectionItems = sectionAttr.lines.flatMap({ lineAttr -> [UICollectionViewLayoutAttributes] in
            let lineOrgin = CGPoint(x: sectionX, y: sectionY)
            let lineitems = self.lineItemsAttributes(forLine: sectionAttr.section,
                                                     isHorizontal: isHorizontal,
                                                     lineOrigin: lineOrgin,
                                                     lineAttr: lineAttr)
            if isHorizontal {
                sectionY += lineAttr.maxWidth + sectionAttr.edge.lineSpace
                sectionX = originX
            } else {
                sectionY = originY
                sectionX += lineAttr.maxWidth + sectionAttr.edge.lineSpace
            }
            return lineitems
        })
        return sectionItems
    }
    /// 单个line的Item的 LayoutAttributes
    func lineItemsAttributes(forLine section: Int,
                             isHorizontal: Bool,
                             lineOrigin: CGPoint,
                             lineAttr: WQFlexLineAttributes) -> [UICollectionViewLayoutAttributes] {
    var lineX = lineOrigin.x
    var lineY = lineOrigin.y
    let isReverse = self.direction.isReverse
    if isHorizontal {
        if isReverse {
           lineX += lineAttr.length - lineAttr.margin.trailing
        } else {
           lineX += lineAttr.margin.leading
        }
    } else {
        if isReverse {
            lineY += lineAttr.length - lineAttr.margin.trailing
        } else {
            lineY += lineAttr.margin.leading
        }
    }
    let lineItems = lineAttr.items.map({ item -> UICollectionViewLayoutAttributes in
        let attr = UICollectionViewLayoutAttributes(forCellWith: item.indexPath)
        let alignItems = self.alignItemsForSection(at: section, inLine: lineAttr.linePath, with: item.indexPath)
        let origin = CGPoint(x: lineX, y: lineY)
        let frame = alignItems.fixItemFrame(origin, size: item.size, lineMaxWidth: lineAttr.maxWidth, isHorizontal: isHorizontal, isReverse: isReverse)
        attr.frame = frame
        if isHorizontal {
            let width = item.size.width + lineAttr.margin.space
            if isReverse { lineX -= width } else { lineX += width }
        } else {
            let height = item.size.height + lineAttr.margin.space
            if isReverse { lineY -= height } else { lineY += height }
        }
        return attr
    })
    return lineItems
    }
    
    /// 所有的header/footer的 attributes
    func layoutSupplementaries(_ isHorizontal: Bool,
                               sectionAttrs: [WQFlexSectionAttributes]) -> [UICollectionViewLayoutAttributes] {
        var rectX = collectionView!.contentInset.left
        var rectY = collectionView!.contentInset.top
        var supplements: [UICollectionViewLayoutAttributes] = []
        for section in 0 ..< sectionAttrs.count {
            let sectionOrigin = CGPoint(x: rectX, y: rectY)
            let secAttr = sectionAttrs[section]
            let atts = self.sectionSupplementaries(for: section, attributes: secAttr, origin: sectionOrigin)
            if isHorizontal { //横向排列就纵向滚动
                rectY += secAttr.bounds.height
            } else {
                rectX += secAttr.bounds.width
            }
            supplements.append(contentsOf: atts)
        }
        return supplements
    }
    /// 单个section的 header/footer supplementAttributes
    func sectionSupplementaries(for section: Int,
                                attributes: WQFlexSectionAttributes,
                                origin: CGPoint) -> [UICollectionViewLayoutAttributes] {
        var supplements: [UICollectionViewLayoutAttributes] = []
        let indexPath = IndexPath(item: 0, section: section)
        if attributes.headerSize != .zero {
            let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                        with: indexPath)
            attr.frame = CGRect(x: origin.x + attributes.insets.left,
                                y: origin.y + attributes.insets.top,
                                width: attributes.bounds.width,
                                height: attributes.headerSize.height)
            supplements.append(attr)
        }
        
        if attributes.footerSize != .zero {
            let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                                        with: indexPath)
            attr.frame = CGRect(x: origin.x + attributes.insets.left ,
                                y: origin.y + attributes.bounds.height - attributes.insets.bottom - attributes.footerSize.height,
                                width: attributes.bounds.width,
                                height: attributes.footerSize.height)
            supplements.append(attr)
        }
        return supplements
    }
}
// MARK: - -- FlexboxLayout Datat Source
private extension WQFlexbox {
    weak var delegate: WQFlexboxDelegateLayout? {
        return self.collectionView?.delegate as? WQFlexboxDelegateLayout
    }
    
    func justifyContent(for line: WQFlexLinePath) -> WQJustifyContent {
        return delegate?.flexbox(collectionView!, flexbox: self, justifyContentFor: line) ?? self.justifyContent
    }
    func alignItemsForSection(at section: Int, inLine: WQFlexLinePath, with indexPath: IndexPath) -> WQAlignItems {
        return delegate?.flexbox(collectionView!,
                                 flexbox: self,
                                 alignItemsFor: section,
                                 with: inLine,
                                 in: indexPath) ?? self.alignItems
    }
}
// MARK: - -- FlowLayout Data Source
private extension WQFlexbox {
    weak var collectionViewLayout: UICollectionViewDelegateFlowLayout? {
        return self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        if let collectionView = self.collectionView {
            return collectionViewLayout?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
        }
        return self.itemSize
    }
    func insetForSection(at section: Int) -> UIEdgeInsets {
        if let collectionView = self.collectionView {
            return collectionViewLayout?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? self.sectionInset
        }
        return self.sectionInset
    }
    
    func minimumLineSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView {
            return collectionViewLayout?
                .collectionView?(collectionView,
                                 layout: self,
                                 minimumLineSpacingForSectionAt: section) ?? self.minimumLineSpacing
        }
        return self.minimumLineSpacing
    }
    //
    func minimumInteritemSpacingForSection(at section: Int) -> CGFloat {
        if let collectionView = self.collectionView {
            return collectionViewLayout?
                .collectionView?(collectionView,
                                 layout: self,
                                 minimumInteritemSpacingForSectionAt: section) ?? self.minimumInteritemSpacing
        }
        return self.minimumInteritemSpacing
    }
    
    func referenceSizeForHeaderInSection(_ section: Int) -> CGSize {
        if let collectionView = self.collectionView {
            return collectionViewLayout?
                .collectionView?(collectionView,
                                 layout: self,
                                 referenceSizeForHeaderInSection: section) ?? self.headerReferenceSize
        }
        return self.headerReferenceSize
    }
    
    func referenceSizeForFooterInSection(_ section: Int) -> CGSize {
        if let collectionView = self.collectionView {
            return delegate?.collectionView?(collectionView,
                                             layout: self,
                                             referenceSizeForFooterInSection: section) ?? self.footerReferenceSize
        }
        return self.footerReferenceSize
    }
}
