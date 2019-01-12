//
//  WQHorizontalTagsLayout.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2018/11/14.
//  参考此处 http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html?utm_source=tuicool
// swiftlint:disable line_length
// swiftlint:disable file_length

import UIKit 

/// 布局主要是针对每个Section里面的Cell 其他的正常布局
public class WQFlexbox: UICollectionViewFlowLayout {
    private weak var delegate: WQFlexboxDelegateLayout? {
        return self.collectionView?.delegate as? WQFlexboxDelegateLayout
    }
    /// 根据 collectionView的frame限制另一边的长度 (isHorizontal contentSize限制为frame的宽度)
    public var direction: WQFlexDirection = .row
    /// 整个line主轴方向在section中的排列方式
    public var justifyContent: WQJustifyContent = .flexStart
    /// 若line中有item有尺寸不相等的以尺寸最大的item进行相对布局(当direction为水平方向时参照最大的height 否则参照最大的width)
    public var alignItems: WQAlignItems = .center
    /// 动态调整每个section中lines之间的间距,以及first line section 顶部或右侧间距 (只有一个section 并且section的长度 y小于主轴长度才有用)
    public var alignContent: WQAlignContent = .flexStart
    /// 主轴方向的排列cell的个数 默认0 根据最小间距属性来动态计算每行的个数
    /// 存储items的布局属性
    private var attrs: [UICollectionViewLayoutAttributes] = []
    /// 存储supplementary的布局属性
    private var supplementary: [UICollectionViewLayoutAttributes] = []
    /// 不包含contentInset
    private var contentSize: CGSize = .zero
     
    //swiftlint:disable function_body_length
    override public func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView,
        collectionView.frame.size != .zero else {
            debugPrint("请配合CollectionView使用,并且尺寸不为零")
            return
        }
        var allAttrs: [[[UICollectionViewLayoutAttributes]]] = []
        
        let sections = collectionView.numberOfSections
        //起始的左上角
        var flowSectionY: CGFloat = collectionView.contentInset.top
        var flowSectionX: CGFloat = collectionView.contentInset.left
        
        // 记录所有section的最大宽高 用于计算ContentSize
        var allSectionMaxHeight: CGFloat = 0
        var allSectionMaxWidth: CGFloat = 0
         let sel = #selector(WQFlexboxDelegateLayout.flexbox(_:flexbox:sizeForSectionAt:))
        var isCustomSectionSize: Bool = false
        if let delegate = self.delegate,
            delegate.responds(to: sel) {
            isCustomSectionSize = true
        }
        for section in 0 ..< sections {
            // 获取每个section的布局风格
            let interitemSpace = self.minimumInteritemSpacingForSection(at: section)
            let lineDirection = self.directionForSection(at: section)
            let isHorizontal = lineDirection.isHorizontal
            let insets = self.insetForSection(at: section)
            let sectionSize = self.sizeForSection(at: section)
            let footerSize = self.referenceSizeForFooterInSection(section)
            let headerSize = self.referenceSizeForHeaderInSection(section)
            let contentW: CGFloat = sectionSize.width - insets.left - insets.right
            let contentH: CGFloat = sectionSize.height - insets.bottom - insets.top - headerSize.height - footerSize.height
            let itemsCount = collectionView.numberOfItems(inSection: section)
            var limitValue: CGFloat = 0
           
            //当没有实现代理 且是同向滚动和同向排列的时候 需要动态调整宽高
            var shouldFixSize: Bool = false
            if self.scrollDirection == .horizontal { //水平滚动
                // 排列方式为水平 且 没有实现代理方法
                if isCustomSectionSize {
                     limitValue = contentH - headerSize.height - footerSize.height
                } else if self.direction.isHorizontal { // 水平排列
                    limitValue = CGFloat.greatestFiniteMagnitude
                    shouldFixSize = true
                } else {
                    limitValue = contentH - headerSize.height - footerSize.height
                }
            } else { //纵向滚动
                if isCustomSectionSize {
                     limitValue = contentW
                } else if !self.direction.isHorizontal { // 纵向排列
                    limitValue = CGFloat.greatestFiniteMagnitude
                } else {
                     limitValue = contentW
                }
            }
            let sectionAttrs = self.groupSectionItems(limitValue, space: interitemSpace, count: itemsCount, inSection: section, isHorizontal: isHorizontal)
            var linesFrame = self.attributeLines(section, lines: sectionAttrs, direction: lineDirection)
            linesFrame.insets = insets
            var rectSize = sectionSize
            // 如果 同轴同向滚动 且未设置sectionSize 则需要动态计算同轴方向长度
            if shouldFixSize {
                var maxValue: CGFloat = 0
                var maxIndex: Int = 0
                for idx in 0 ..< linesFrame.totalValues.count {
                    if maxValue < linesFrame.totalValues[idx] {
                        maxValue = linesFrame.totalValues[idx]
                        maxIndex = idx
                    }
                }
                let lineCount = maxIndex < sectionAttrs.count ? sectionAttrs[maxIndex].count : 0
                let space = CGFloat(lineCount - 1) * interitemSpace
                maxValue += space
                if self.scrollDirection == .horizontal {
                    if rectSize.width < maxValue {
                        rectSize.width = maxValue + insets.left + insets.right
                    }
                } else {
                    if rectSize.height < maxValue {
                        rectSize.height = maxValue + insets.bottom + insets.top + headerSize.height + footerSize.height
                    }
                }
            }
            linesFrame.rect = CGRect(origin: CGPoint(x: flowSectionX, y: flowSectionY), size: rectSize)
            linesFrame.headerSize = headerSize
            linesFrame.footerSize = footerSize
            allAttrs.append(sectionAttrs)
            
            let maxSize = self.layoutItemsFrame(attributes: sectionAttrs, itemsSpace: interitemSpace, linesFrame: linesFrame)

            if self.scrollDirection == .horizontal {//水平方向
                flowSectionX += maxSize.width
                flowSectionY = collectionView.contentInset.top
            } else {
                 flowSectionY += maxSize.height
                 flowSectionX = collectionView.contentInset.left
            }
            if allSectionMaxWidth < maxSize.width {
                allSectionMaxWidth = maxSize.width
            }
            if allSectionMaxHeight < maxSize.height {
                allSectionMaxHeight = maxSize.height
            }
        }
        if self.scrollDirection == .horizontal { //水平方向
            self.contentSize = CGSize(width: flowSectionX - collectionView.contentInset.left, height: flowSectionY - collectionView.contentInset.top + allSectionMaxHeight)
        } else {//垂直方向滚动
            self.contentSize = CGSize(width: flowSectionX - collectionView.contentInset.left + allSectionMaxWidth, height: flowSectionY - collectionView.contentInset.top)
        }
        let items = allAttrs.flatMap({ $0.flatMap({ $0 }) })
        attrs = items
    }
    
    public override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    public override func invalidateLayout() {
        super.invalidateLayout()
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else {
            return false
        }
        return collectionView.bounds.size != newBounds.size
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = attrs.first(where: { $0.indexPath == indexPath })
        return attr
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = supplementary.first(where: { $0.indexPath == indexPath && $0.representedElementKind == elementKind })
        return attr
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs + supplementary
    }
}

// MARK: - --处理布局并分类
private extension WQFlexbox {
    // 前提 必需要确定 主轴方向的长度
    // 将section中的items分成line
    func groupSectionItems(_ limit: CGFloat,
                           space: CGFloat,
                           count: Int,
                           inSection: Int,
                           isHorizontal: Bool = true) -> [[UICollectionViewLayoutAttributes]] {
        var attrs: [[UICollectionViewLayoutAttributes]] = []
        if isHorizontal {//row
            var lineAttrs: [UICollectionViewLayoutAttributes] = []
            var maxValue: CGFloat = 0
            for item in 0 ..< count {
                let indexPath = IndexPath(item: item, section: inSection)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let itemSize = self.sizeForItem(at: indexPath)
                attr.frame = CGRect(origin: .zero, size: itemSize)
                maxValue += itemSize.width
                if maxValue > limit {
                    maxValue = itemSize.width
                    attrs.append(lineAttrs)
                    lineAttrs = []
                }
                maxValue += space
                lineAttrs.append(attr)
            }
            attrs.append(lineAttrs)
        } else {// coloum
            var sizes: [CGSize] = []
            var items: [UICollectionViewLayoutAttributes] = []
            for item in 0 ..< count {
                let indexPath = IndexPath(item: item, section: inSection)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let itemSize = self.sizeForItem(at: indexPath)
                attr.frame = CGRect(origin: .zero, size: itemSize)
                sizes.append(itemSize)
                items.append(attr)
            }
            let lineSpace = self.minimumLineSpacingForSection(at: inSection)
            
            var linesNum: Int = 1 //每个line的items数量
            var lineCount: Int = sizes.count
            var linesSizes: [ArraySlice<CGSize>] = []
            var isLoop: Bool = true
            while isLoop {
                for index in 0 ..< linesNum {
                   let end = min((index + 1) * lineCount, sizes.count)
                   let start = index * lineCount
                    if start < end {
                        let itemsSize = sizes[start ..< end]
                        linesSizes.append(itemsSize)
                    }
                }
                let maxValue = linesSizes.compactMap({ $0.max(by: { $0.width < $1.width }) })
                let sum = maxValue.reduce(0) { result, size in
                    return result + size.width + lineSpace
                }
                if sum < limit {
                    linesSizes = []
                    linesNum += 1
                    lineCount = sizes.count / linesNum
                    isLoop = true
                } else {
                    if linesNum > 1 {
                        linesNum -= 1
                        lineCount = sizes.count / linesNum
                    }
                    isLoop = false
                }
            }
            for index in 0 ..< linesNum {
                let end = (index + 1) * lineCount
                let start = index * lineCount
                if start < end {
                    if index == linesNum - 1 {
                        let lineAttrs = Array(items[start ..< sizes.count])
                        attrs.append(lineAttrs)
                    } else {
                        let lineAttrs = Array(items[start ..< end])
                        attrs.append(lineAttrs)
                    }
                }
            }
        }
        return attrs
    }
    // 获取section中每个line的最大高度(或宽度)、每个line的items总长度(或总高度)以及所有lines的高度和(或宽度和)
    func attributeLines(_ section: Int,
                        lines: [[UICollectionViewLayoutAttributes]],
                        direction: WQFlexDirection) -> LinesFrameAttribute {
        var maxValues: [CGFloat] = []
        var totalValues: [CGFloat] = []
        var sumMaxValue: CGFloat = 0
        let count = lines.count
        // 每行items的总高度或者总宽度
        if direction.isHorizontal { //水平
            for index in 0 ..< count {
                let lineAttrs = lines[index]
                var lineMaxHeight: CGFloat = 0
                var totalValue: CGFloat = 0
                for idx in 0 ..< lineAttrs.count {
                    let attr = lineAttrs[idx]
                    if lineMaxHeight < attr.frame.height {
                        lineMaxHeight = attr.frame.height
                    }
                    totalValue += attr.frame.width
                }
                maxValues.append(lineMaxHeight)
                totalValues.append(totalValue)
                sumMaxValue += lineMaxHeight
            }
        } else {
            for index in 0 ..< count {
                let lineAttrs = lines[index]
                var lineMaxW: CGFloat = 0
                var totalValue: CGFloat = 0
                for idx in 0 ..< lineAttrs.count {
                    let attr = lineAttrs[idx]
                    if lineMaxW < attr.frame.width {
                        lineMaxW = attr.frame.width
                    }
                    totalValue += attr.frame.height
                }
                maxValues.append(lineMaxW)
                totalValues.append(totalValue)
                sumMaxValue += lineMaxW
            }
        } 
        return LinesFrameAttribute(section, maxValues: maxValues, totalValues: totalValues, sumMaxValue: sumMaxValue, direction: direction)
    }
    // 前提: 需确定section的宽高 (即rect的size必须为实际的宽高)
    func attributeLinesMargin(_ linesFrame: LinesFrameAttribute) -> LinesMarginAttribute {
        let section = linesFrame.section
        let space = self.minimumLineSpacingForSection(at: section)
        var lineSpace: CGFloat
        var leaveMargin: CGFloat = 0
        var margin: CGFloat = 0
        let linesCount = CGFloat(linesFrame.count)
        var sectionLength: CGFloat = 0
        if linesFrame.direction.isHorizontal {
            sectionLength = linesFrame.rect.height - linesFrame.headerSize.height - linesFrame.footerSize.height - linesFrame.insets.top - linesFrame.insets.bottom
        } else {
            sectionLength = linesFrame.rect.width - linesFrame.insets.left - linesFrame.insets.right
        }
        let alignContent = self.alignContentForSection(at: section)
        switch alignContent {
        case .flexStart:
            lineSpace = space
            leaveMargin = 0
//            leaveMargin = sectionLength - linesFrame.sumMaxValue - (linesCount - 1) * lineSpace
        case .center:
            lineSpace = space
            margin = (sectionLength - linesFrame.sumMaxValue - lineSpace * (linesCount - 1)) * 0.5
            leaveMargin = margin
        case .flexEnd:
            lineSpace = space
            margin = sectionLength - linesFrame.sumMaxValue - lineSpace * (linesCount - 1)
        case .spaceAround:
            lineSpace = (sectionLength - linesFrame.sumMaxValue) / (linesCount * 2)
            margin = lineSpace * 0.5
        case .spaceBetween:
            lineSpace = (sectionLength - linesFrame.sumMaxValue) / (linesCount - 1)
        }
      return LinesMarginAttribute(margin: margin, remainingMargin: leaveMargin, space: lineSpace, section: section)
    }
    
    /// 每个区域 的
    func attributeLineItems(lineIndex: Int,
                            lineItems count: Int,
                            itemsSpace: CGFloat,
                            contentLength: CGFloat,
                            linesFrame: LinesFrameAttribute) -> LineItemsMarginAttribute {
        let lineItemsCount = CGFloat(count)
        let section = linesFrame.section
        let totalW = linesFrame.totalValues[lineIndex]
        let justtify = self.justifyContentForSection(at: section, inLine: lineIndex, total: linesFrame.count)
        // 确定每个line的起始X位置
        var startValue: CGFloat = 0
        var rowSectionW: CGFloat
        switch justtify {
        case .flexStart:
            rowSectionW = itemsSpace
        case .center:
            rowSectionW = itemsSpace
            startValue += (contentLength - totalW - rowSectionW * (lineItemsCount - 1)) * 0.5
        case .flexEnd:
            rowSectionW = itemsSpace
            startValue += (contentLength - totalW - rowSectionW * (lineItemsCount - 1))
        case .spaceAround:
            rowSectionW = (contentLength - totalW) / (lineItemsCount * 2)
            startValue = rowSectionW * 0.5
        case .spaceBetween:
            rowSectionW = (contentLength - totalW) / (lineItemsCount - 1)
        }
        return LineItemsMarginAttribute(startItemValue: startValue, itemSpace: rowSectionW, count: count, section: section, index: lineIndex)
    }
    //返回
    func layoutItemsFrame(attributes: [[UICollectionViewLayoutAttributes]],
                          itemsSpace: CGFloat,
                          linesFrame: LinesFrameAttribute) -> CGSize {
        //notaFIXME:这里暂时当做row处理
        let section = linesFrame.section
        let sectionContentSize = linesFrame.contentSize
        let contentW = sectionContentSize.width
        let contentH = sectionContentSize.height
        let linesCount = linesFrame.count
        let linesMargin = self.attributeLinesMargin(linesFrame)
 
        let sectionX: CGFloat = linesFrame.insets.left + linesFrame.rect.minX
        var sectionY: CGFloat = linesFrame.insets.top + linesFrame.rect.minY
        var headerFooter: [UICollectionViewLayoutAttributes] = []
        let headerSize = linesFrame.headerSize
        let footerSize = linesFrame.footerSize
        let path = IndexPath(item: 0, section: section)
        var header: UICollectionViewLayoutAttributes?
        if headerSize != .zero {
            header = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: path)
            header?.frame = CGRect(x: linesFrame.rect.minX + linesFrame.insets.left, y: sectionY, width: contentW, height: headerSize.height)
            headerFooter.append(header!)
            sectionY += headerSize.height
        }
        var realSize: CGSize
         let linesSpace = linesMargin.space
        var contentLength: CGFloat = 0
//        let sel: Selector = #selector(WQFlexboxDelegateLayout.flexbox(_:flexbox:sizeForSectionAt:))
//        if let deleg = self.delegate,
//            deleg.responds(to: sel) {
        if direction.isHorizontal {
            contentLength = contentW
        } else {
            contentLength = contentH - headerSize.height - footerSize.height
        }
        realSize = linesFrame.rect.size
//        } else {
//            if direction.isHorizontal {
//                contentLength = contentW
//                let height = linesFrame.sumMaxValue + linesMargin.space * CGFloat(linesFrame.count - 1) + headerSize.height + footerSize.height + linesFrame.insets.top + linesFrame.insets.bottom
//                realSize = CGSize(width: contentLength, height: height)
//            } else {
//                var maxValue: CGFloat = 0
//                var maxIndex: Int = 0
//                for index in 0 ..< linesFrame.totalValues.count {
//                    let value = linesFrame.totalValues[index]
//                    if maxValue < value {
//                        maxValue = value
//                        maxIndex = index
//                    }
//                }
//                contentLength = maxValue + CGFloat(attributes[maxIndex].count - 1) * linesSpace
//                let height = contentLength + headerSize.height + footerSize.height + linesFrame.insets.top + linesFrame.insets.bottom
//                realSize = CGSize(width: linesFrame.rect.width, height: height)
//            }
//        }
        var startY: CGFloat = 0
        var startX: CGFloat = 0
        switch linesFrame.direction {
        case .row, .rowReverse:
            startY = sectionY + linesMargin.margin
            for index in 0 ..< linesCount {
                let lineLayouts = attributes[index]
                let count = lineLayouts.count
                let rowMaxH = linesFrame.maxValues[index]
                let itemsAttr = attributeLineItems(lineIndex: index, lineItems: count, itemsSpace: itemsSpace, contentLength: contentLength, linesFrame: linesFrame)
                startX = sectionX + itemsAttr.startItemValue
                // 确定每个item的位置并修正尺寸
                for idx in 0 ..< count {
                    var ptX, ptY: CGFloat
                    let attr = lineLayouts[idx]
                    var attrFrame = attr.frame
                    let alignItems = self.alignItemsForSection(at: section, inLine: index, with: attr.indexPath)
                    ptX = startX
                    var attrHeight: CGFloat = attrFrame.height
                    switch alignItems {
                    case .flexStart:
                        ptY = startY
                    case .center:
                        ptY = startY + (rowMaxH - attrFrame.height) * 0.5
                    case .flexEnd:
                        ptY = startY + (rowMaxH - attrFrame.height)
                    case .stretch:
                        ptY = startY
                        attrHeight = rowMaxH
                    }
                    startX += attrFrame.width + itemsAttr.itemSpace
                    attrFrame = CGRect(x: ptX, y: ptY, width: attrFrame.width, height: attrHeight)
                    attr.frame = attrFrame
                }
                startY += rowMaxH + linesSpace
            }
        case .column, .columnReverse:
            startX += sectionX + linesMargin.margin
            for index in 0 ..< linesCount {
                let lineLayouts = attributes[index]
                let count = lineLayouts.count
                let rowMaxW = linesFrame.maxValues[index]
                let itemsAttr = attributeLineItems(lineIndex: index, lineItems: count, itemsSpace: itemsSpace, contentLength: contentLength, linesFrame: linesFrame)
                startY = sectionY + itemsAttr.startItemValue
                // 确定每个item的位置并修正尺寸
                for idx in 0 ..< count {
                    var ptX, ptY: CGFloat
                    let attr = lineLayouts[idx]
                    var attrFrame = attr.frame
                    let alignItems = self.alignItemsForSection(at: section, inLine: index, with: attr.indexPath)
                    ptY = startY
                    var attrWidth: CGFloat = attrFrame.width
                    switch alignItems {
                    case .flexStart:
                        ptX = startX
                    case .center:
                        ptX = startX + (rowMaxW - attrFrame.height) * 0.5
                    case .flexEnd:
                        ptX = startX + (rowMaxW - attrFrame.height)
                    case .stretch:
                        ptX = startX
                        attrWidth = rowMaxW
                    }
                    startY += attrFrame.height + itemsAttr.itemSpace
                    attrFrame = CGRect(x: ptX, y: ptY, width: attrWidth, height: attrFrame.height)
                    attr.frame = attrFrame
                }
                startX += rowMaxW + linesSpace
            }
        }
    
        if footerSize != .zero {
            let footer = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: path)
            footer.frame = CGRect(x: linesFrame.rect.minX + linesFrame.insets.left, y: linesFrame.rect.minY + realSize.height - linesFrame.insets.bottom - footerSize.height, width: realSize.width, height: footerSize.height)
            headerFooter.append(footer)
        }
        if !headerFooter.isEmpty {
            if let header = header {
                header.frame = CGRect(origin: header.frame.origin, size: CGSize(width: realSize.width, height: header.frame.height))
            }
            supplementary.append(contentsOf: headerFooter)
        }
        return realSize
    }
}

// MARK: - -- FlexboxLayout Datat Source
private extension WQFlexbox {
    func sizeForSection(at section: Int) -> CGSize {
        guard let collectionView = self.collectionView else {
            return .zero
        }
        var sectionSize: CGSize
        if let size = delegate?.flexbox?(collectionView, flexbox: self, sizeForSectionAt: section) {
            sectionSize = size
        } else {
            let inset = collectionView.contentInset
            sectionSize = CGSize(width: collectionView.frame.width - inset.left - inset.right,
                                 height: collectionView.frame.height - inset.top - inset.bottom)
        }
        return sectionSize
    }
    
    func directionForSection(at section: Int) -> WQFlexDirection {
        return delegate?.flexbox?(collectionView!, flexbox: self, directionForSectionAt: section) ?? self.direction
    }
    
    func justifyContentForSection(at section: Int, inLine: Int, total: Int) -> WQJustifyContent {
        return delegate?.flexbox?(collectionView!, flexbox: self, justifyContentForSectionAt: section, inLine: inLine, linesCount: total) ?? self.justifyContent
    }
    
    func alignItemsForSection(at section: Int, inLine: Int, with indexPath: IndexPath) -> WQAlignItems {
        return delegate?.flexbox?(collectionView!, flexbox: self, alignItemsForSectionAt: section, inLine: inLine, with: indexPath) ?? self.alignItems
    }
    func alignContentForSection(at section: Int) -> WQAlignContent {
        return delegate?.flexbox?(collectionView!, flexbox: self, alignContentForSectionAt: section) ?? self.alignContent
    }
}
// MARK: - -- FlowLayout Data Source
private extension WQFlexbox {
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
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
