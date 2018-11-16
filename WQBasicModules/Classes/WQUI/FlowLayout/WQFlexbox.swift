//
//  WQHorizontalTagsLayout.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2018/11/14.
//  参考此处 http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html?utm_source=tuicool

import UIKit
//TODO: - --整个布局都是以Section为单位进行的 整个section的布局还是按照原有的
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
/// 属性定义了项目在主轴上的对齐方式。(布局去掉了ectionInset区域)
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
    
//    /// 项目的第一行文字的基线对齐。
//    case baseline
    
    /// （默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
    case stretch
}

// 适应行间距 以line为单位布局每个Section
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
//    case stretch
}
// MARK: - ==========整个View的属性END===============
//// MARK: - ==========Cell属性==========
//@objc public enum WQAlignSelf: Int {
//    case auto //继承自父View的属性
//    /// 交叉轴的起点对齐。
//    case flexStart
//
//    /// 交叉轴的终点对齐。
//    case flexEnd
//
//    /// 交叉轴的中点对齐。
//    case center
//
//    /// 项目的第一行文字的基线对齐。
//    case baseline
//
//    /// （默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
//    case stretch
//}
//// MARK: - ==========Cell属性END==========

@objc public protocol WQFlexboxDelegateLayout: UICollectionViewDelegateFlowLayout {
    
    /// 返回每个Section的高度;当只有一个section的时候 高度默认为collectionView的height
    /// section尺寸 (包含header、footer(上下布局) 包含sectionInsets)
    @objc optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, sizeForSectionAt section: Int) -> CGSize
//    @objc optional func flexbox(_ flexbox: WQFlexbox, alignItemAt indexPath: IndexPath) -> WQAlignSelf
    /// Cells排列方向
    @objc optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, directionForSectionAt section: Int) -> WQFlexDirection
    @objc optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, justifyContentForSectionAt section: Int, inLine lineNum: Int, linesCount: Int) -> WQJustifyContent
     @objc optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, alignItemsForSectionAt section: Int, inLine lineIndex: Int, with indexPath: IndexPath) -> WQAlignItems
     @objc optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, alignContentForSectionAt section: Int) -> WQAlignContent
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
    public var direction: WQFlexDirection = .row
    
    /// 整个line主轴方向在section中的排列方式
    public var justify_content: WQJustifyContent = .flexStart
    
    /// 若line中有item有尺寸不相等的以尺寸最大的item进行相对布局(当direction为水平方向时参照最大的height 否则参照最大的width)
    public var align_items: WQAlignItems = .center
    
    /// 动态调整每个section中lines之间的间距,以及first line section 顶部或右侧间距
    public var align_content: WQAlignContent = .flexStart
    
    /// 主轴方向的排列cell的个数 默认0 根据最小间距属性来动态计算每行的个数
    public var lineItemsCount: Int = 0
    
    public override var collectionViewContentSize: CGSize {
        return contentSize
    }
    private var attrs: [UICollectionViewLayoutAttributes] = []
    private var supplementary: [UICollectionViewLayoutAttributes] = []
    /// 不包含contentInset
    private var contentSize: CGSize = .zero
    
    public override func invalidateLayout() {
        super.invalidateLayout()
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    override public func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else {
            debugPrint("请配合CollectionView使用")
            return
        }
        //        let frame = collectionView.frame
        guard collectionView.frame.size != .zero else {
            debugPrint("尺寸不能为0")
            return
        }
        //        let eachLineCount = lineItemsCount
        
        let sections = collectionView.numberOfSections
        var flowSectionY: CGFloat = 0
        var flowSectionX: CGFloat = 0
        
        flowSectionY = collectionView.contentInset.top
        flowSectionX = collectionView.contentInset.left
        //所有section的所有行
        var allAttrs: [[[UICollectionViewLayoutAttributes]]] = []
        var supplementaryAttrs: [[UICollectionViewLayoutAttributes]] = []
        
        // 记录所有section的最大宽高 用于计算ContentSize
        var allSectionMaxHeight: CGFloat = 0
        var allSectionMaxWidth: CGFloat = 0
        
        for section in 0 ..< sections {
            // 获取每个section的布局风格
            let headerSize = self.referenceSizeForHeaderInSection(section)
            let footerSize = self.referenceSizeForFooterInSection(section)
            let lineSpace = self.minimumLineSpacingForSection(at: section)
            let interitemSpace = self.minimumInteritemSpacingForSection(at: section)
            let lineDirection = self.directionForSection(at: section)
            let sectionAlignContent = self.alignContentForSection(at: section)
            let insets = self.insetForSection(at: section)
            let sectionSize = self.sizeForSection(at: section)
//            let isHorizontal = lineDirection.isHorizontal
            
            let contentW: CGFloat = sectionSize.width - insets.left - insets.right
            let contentH: CGFloat = sectionSize.height - insets.bottom - insets.top
            
            
            //获取section的左上角坐标
            flowSectionX += insets.left
            flowSectionY += insets.top
            var headerFooterAttr: [UICollectionViewLayoutAttributes] = []
            if headerSize != .zero {
                let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerAttr.frame = CGRect(x: flowSectionX, y: flowSectionY, width: contentW, height: headerSize.height)
                headerFooterAttr.append(headerAttr)
            }
            var sectionAttrs: [[UICollectionViewLayoutAttributes]] = []
            var lineAttrs: [UICollectionViewLayoutAttributes] = []
            let itemsCount = collectionView.numberOfItems(inSection: section)
            
            //处理一个区的
            switch lineDirection {
            case .row:
                /// 分Lines 处理每行最多能放多少个
                flowSectionY += headerSize.height
                var lineMaxX: CGFloat = 0
                let limitValue: CGFloat = contentW
                let itemSpace = interitemSpace
                for item in 0 ..< itemsCount {
                    let indexPath = IndexPath(item: item, section: section)
                    let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    let itemSize = self.sizeForItem(at: indexPath)
                    attr.frame = CGRect(origin: .zero, size: itemSize)
                    lineMaxX += itemSize.width
                    if lineMaxX > limitValue {
                        lineMaxX = itemSize.width
                        sectionAttrs.append(lineAttrs)
                        lineAttrs = []
                    }
                    lineMaxX += itemSpace
                    lineAttrs.append(attr)
                }
                sectionAttrs.append(lineAttrs)
                
                //每行的最大高度或宽度
                var linesMaxHeightValue: [CGFloat] = []
                var linesTotalWidthValue: [CGFloat] = []
                var linesTotalHeight: CGFloat = 0
                // 每行items的总高度或者总宽度
                for index in 0 ..< sectionAttrs.count {
                    let lineAttrs = sectionAttrs[index]
                    var lineMaxHeight: CGFloat = 0
                    var totalValue: CGFloat = 0
                    for idx in 0 ..< lineAttrs.count {
                        let attr = lineAttrs[idx]
                        if lineMaxHeight < attr.frame.height {
                            lineMaxHeight = attr.frame.height
                        }
                        totalValue += attr.frame.width
                    }
                    linesMaxHeightValue.append(lineMaxHeight)
                    linesTotalWidthValue.append(totalValue)
                    linesTotalHeight += lineMaxHeight
                }
                //留待它用
                allAttrs.append(sectionAttrs)
                // 记录section内容的最大宽高 用于计算ContentSize
                var maxHeight: CGFloat = 0
                let maxWidth: CGFloat = contentW
                
                let linesCount = sectionAttrs.count
                let linesNum = CGFloat(linesCount)
                var topY = flowSectionY
                var sectionLineSpace: CGFloat
                var sectionBottomH: CGFloat = 0
                var marginTop: CGFloat = 0
                let sel: Selector = #selector(WQFlexboxDelegateLayout.flexbox(_:flexbox:sizeForSectionAt:))
                if let deleg = self.delegate,
                    deleg.responds(to: sel) {
                    switch sectionAlignContent {
                    case .flexStart:
                        sectionLineSpace = lineSpace
                        sectionBottomH = contentH - linesTotalHeight - linesNum * sectionLineSpace
                    case .center:
                        sectionLineSpace = lineSpace
                        marginTop = (contentH - linesTotalHeight - sectionLineSpace * (linesNum - 1)) * 0.5
                        sectionBottomH = marginTop
                    case .flexEnd:
                        sectionLineSpace = lineSpace
                        marginTop = contentH - linesTotalHeight - sectionLineSpace * (linesNum - 1)
                    case .spaceAround:
                        sectionLineSpace = (contentH - linesTotalHeight) / (linesNum * 2)
                        marginTop = sectionLineSpace * 0.5
                    case .spaceBetween:
                        sectionLineSpace = (contentH - linesTotalHeight) / (linesNum - 1)
                    }
                } else {
                    sectionLineSpace = lineSpace
                }
                topY += marginTop
                maxHeight += marginTop
                //按照Line为单位处理
                for index in 0 ..< linesCount {
                    let lineAttrs = sectionAttrs[index]
                    let lineItemsCount = CGFloat(lineAttrs.count)
                    
                    let rowMaxH = linesMaxHeightValue[index]
                    let totalW = linesTotalWidthValue[index]
                    let justtify = self.justifyContentForSection(at: section, inLine: index, total: linesCount)
                    // 确定每个line的起始X位置
                    var startX: CGFloat = flowSectionX
                    var rowSectionW: CGFloat
                    switch justtify {
                    case .flexStart:
                        rowSectionW = interitemSpace
                    case .center:
                        rowSectionW = interitemSpace
                        startX +=  (contentW - totalW - rowSectionW * (lineItemsCount - 1)) * 0.5
                    case .flexEnd:
                        rowSectionW = interitemSpace
                        startX += (contentW - totalW - rowSectionW * (lineItemsCount - 1))
                    case .spaceAround:
                        rowSectionW = (contentW - totalW) / (lineItemsCount * 2)
                        startX = rowSectionW * 0.5
                        break;
                    case .spaceBetween:
                        rowSectionW = (contentW - totalW) / (lineItemsCount - 1)
                    }
                    // 确定每个item的位置并修正尺寸
                    for idx in 0 ..< lineAttrs.count {
                        var ptX, ptY: CGFloat
                        let attr = lineAttrs[idx]
                        var attrFrame = attr.frame
                        let alignItems = self.alignItemsForSection(at: section, inLine: index, with: attr.indexPath)
                        ptX = startX
                        var attrHeight: CGFloat = attrFrame.height
                        switch alignItems {
                        case .flexStart:
                            ptY = topY
                        case .center:
                            ptY = topY + (rowMaxH - attrFrame.height) * 0.5
                        case .flexEnd:
                            ptY = topY + (rowMaxH - attrFrame.height)
                        //                        case .baseline:
                        case .stretch:
                            ptY = topY
                            attrHeight = rowMaxH
                        }
                        startX += attrFrame.width + rowSectionW
                        attrFrame = CGRect(x: ptX, y: ptY, width: attrFrame.width, height: attrHeight)
                        attr.frame = attrFrame
                        debugPrint(attrFrame)
                    }
                    topY += rowMaxH + sectionLineSpace
                    maxHeight += rowMaxH + sectionLineSpace
                }
                maxHeight -= sectionLineSpace
                //加上剩余的距离
                maxHeight += sectionBottomH
                
                if footerSize != .zero {
                    let footerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                    footerAttr.frame = CGRect(x: flowSectionX, y: flowSectionY + maxHeight, width: contentW, height: footerSize.height)
                    headerFooterAttr.append(footerAttr)
                }
                if self.scrollDirection == .horizontal {//水平方向
                    flowSectionX += maxWidth
                    flowSectionX += insets.right
                    flowSectionY = collectionView.contentInset.top
                } else {
                    flowSectionY += maxHeight
                    flowSectionY += footerSize.height + insets.bottom
                    flowSectionX = collectionView.contentInset.left
                }
                
                if allSectionMaxWidth < maxWidth {
                    allSectionMaxWidth = maxWidth
                }
                if allSectionMaxHeight < maxHeight {
                    allSectionMaxHeight = maxHeight
                }
            default:
                break;
                //            case .rowReverse:
                //            case .column:
                //            case .columnReverse:
            }
            
            
            supplementaryAttrs.append(headerFooterAttr)
            
            
            
        }
        if self.scrollDirection == .horizontal { //水平方向
            self.contentSize = CGSize(width: flowSectionX - collectionView.contentInset.left + allSectionMaxWidth , height: flowSectionY - collectionView.contentInset.top + allSectionMaxHeight)
        } else {//垂直方向滚动
            self.contentSize = CGSize(width: flowSectionX - collectionView.contentInset.left + allSectionMaxWidth , height: flowSectionY - collectionView.contentInset.top)
        }
        debugPrint("=====",self.contentSize)
        let items = allAttrs.flatMap({ $0.flatMap({$0}) })
        attrs = items
        supplementary = supplementaryAttrs.flatMap({$0})
        //        attrs.append(contentsOf: supplementaryAttrs.flatMap({$0}))
        
    }
    
//    override public func prepare() {
//        super.prepare()
//
//        guard let collectionView = self.collectionView else {
//            debugPrint("请配合CollectionView使用")
//            return
//        }
////        let frame = collectionView.frame
//        guard collectionView.frame.size != .zero else {
//            debugPrint("尺寸不能为0")
//            return
//        }
////        let eachLineCount = lineItemsCount
//
//        let sections = collectionView.numberOfSections
//        var flowSectionY: CGFloat = 0
//        var flowSectionX: CGFloat = 0
//
//        flowSectionY = collectionView.contentInset.top
//        flowSectionX = collectionView.contentInset.left
//        //所有section的所有行
//        var allAttrs: [[[UICollectionViewLayoutAttributes]]] = []
//        var supplementaryAttrs: [[UICollectionViewLayoutAttributes]] = []
//
//        // 记录所有section的最大宽高 用于计算ContentSize
//        var allSectionMaxHeight: CGFloat = 0
//        var allSectionMaxWidth: CGFloat = 0
//
//        for section in 0 ..< sections {
//            // 获取每个section的布局风格
//            let headerSize = self.referenceSizeForHeaderInSection(section)
//            let footerSize = self.referenceSizeForFooterInSection(section)
//            let lineSpace = self.minimumLineSpacingForSection(at: section)
//            let interitemSpace = self.minimumInteritemSpacingForSection(at: section)
//            let lineDirection = self.directionForSection(at: section)
//            let sectionAlignContent = self.alignContentForSection(at: section)
//            let insets = self.insetForSection(at: section)
//            let sectionSize = self.sizeForSection(at: section)
//            let isHorizontal = lineDirection.isHorizontal
//
//            let contentW: CGFloat = sectionSize.width - insets.left - insets.right
//            let contentH: CGFloat = sectionSize.height - insets.bottom - insets.top
//
//
//            //获取section的左上角坐标
//            flowSectionX += insets.left
//            flowSectionY += insets.top
//            var headerFooterAttr: [UICollectionViewLayoutAttributes] = []
//            if headerSize != .zero {
//                let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
//                headerAttr.frame = CGRect(x: flowSectionX, y: flowSectionY, width: contentW, height: headerSize.width)
//                headerFooterAttr.append(headerAttr)
//                flowSectionX += headerSize.width
//                flowSectionY += headerSize.height
//            }
//            var sectionAttrs: [[UICollectionViewLayoutAttributes]] = []
//            var lineAttrs: [UICollectionViewLayoutAttributes] = []
//            let itemsCount = collectionView.numberOfItems(inSection: section)
//
//            //处理一个区的
//            switch lineDirection {
//            case .row:
//                /// 分Lines 处理每行最多能放多少个
//                var maxValue: CGFloat = 0
////                let limitValue: CGFloat = (self.scrollDirection == .horizontal) ? contentH: contentW
//                let limitValue: CGFloat = contentW
//                let itemSpace = isHorizontal ? interitemSpace : lineSpace
//                for item in 0 ..< itemsCount {
//                    let indexPath = IndexPath(item: item, section: section)
//                    let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//                    let itemSize = self.sizeForItem(at: indexPath)
//                    attr.frame = CGRect(origin: .zero, size: itemSize)
//                    if isHorizontal {
//                        maxValue += itemSize.width
//                    } else {
//                        maxValue += itemSize.height
//                    }
//                    if maxValue > limitValue {
//                        maxValue = isHorizontal ? itemSize.width : itemSize.height
//                        sectionAttrs.append(lineAttrs)
//                        lineAttrs = []
//                    }
//                    maxValue += itemSpace
//                    lineAttrs.append(attr)
//                }
//                if !lineAttrs.isEmpty {
//                    sectionAttrs.append(lineAttrs)
//                }
//
//                //每行的最大高度或宽度
//                var linesMaxValue: [CGFloat] = []
//                var linesTotalValue: [CGFloat] = []
//                var sumMaxValue: CGFloat = 0
//                // 每行items的总高度或者总宽度
//                for index in 0 ..< sectionAttrs.count {
//                    let lineAttrs = sectionAttrs[index]
//                    var maxValue: CGFloat = 0
//                    var totalValue: CGFloat = 0
//                    for idx in 0 ..< lineAttrs.count {
//                        let attr = lineAttrs[idx]
//                        if isHorizontal {
//                            if maxValue < attr.frame.width {
//                                maxValue = attr.frame.width
//                            }
//                            totalValue += attr.frame.width
//                        } else {
//                            if maxValue < attr.frame.height {
//                                maxValue = attr.frame.height
//                            }
//                            totalValue += attr.frame.height
//                        }
//                    }
//                    linesMaxValue.append(maxValue)
//                    linesTotalValue.append(totalValue)
//                    sumMaxValue += maxValue
//                }
//                //留待它用
//                allAttrs.append(sectionAttrs)
//                // 记录section内容的最大宽高 用于计算ContentSize
//                var maxHeight: CGFloat = 0
//                let maxWidth: CGFloat = contentW
//
//                let linesCount = sectionAttrs.count
//                let linesNum = CGFloat(linesCount)
//                var topY = flowSectionY
//                var sectionLineSpace: CGFloat
//                var sectionBottomH: CGFloat = 0
//                var marginTop: CGFloat = 0
//                topY += insets.top
//                let sel: Selector = #selector(WQFlexboxDelegateLayout.flexbox(_:flexbox:sizeForSectionAt:))
//                if let deleg = self.delegate,
//                    deleg.responds(to: sel) {
//                    switch sectionAlignContent {
//                    case .flexStart:
//                        sectionLineSpace = lineSpace
//                        sectionBottomH = contentH - sumMaxValue - linesNum * sectionLineSpace
//                    case .center:
//                        sectionLineSpace = lineSpace
//                        marginTop = (contentH - sumMaxValue - sectionLineSpace * (linesNum - 1)) * 0.5
//                        sectionBottomH = marginTop
//                    case .flexEnd:
//                        sectionLineSpace = lineSpace
//                        marginTop = contentH - sumMaxValue - sectionLineSpace * (linesNum - 1)
//                    case .spaceAround:
//                        sectionLineSpace = (contentH - sumMaxValue) / (linesNum * 2)
//                        marginTop = sectionLineSpace * 0.5
//                    case .spaceBetween:
//                        sectionLineSpace = (contentH - sumMaxValue) / (linesNum - 1)
//                    }
//                } else {
//                     sectionLineSpace = lineSpace
//                }
//                topY += marginTop
//                maxHeight += marginTop
//                //按照Line为单位处理
//                for index in 0 ..< linesCount {
//                    let lineAttrs = sectionAttrs[index]
//                    let lineItemsCount = CGFloat(lineAttrs.count)
//
//                    let rowMaxH = linesMaxValue[index]
//                    let totalW = linesTotalValue[index]
//                    let justtify = self.justifyContentForSection(at: section, inLine: index, total: linesCount)
//                    // 确定每个line的起始X位置
//                    var startX: CGFloat = flowSectionX
//                    var rowSectionW: CGFloat
//                    switch justtify {
//                    case .flexStart:
//                        rowSectionW = interitemSpace
//                        startX += insets.left
//                    case .center:
//                        rowSectionW = interitemSpace
//                        startX += insets.left + (contentW - totalW - rowSectionW * (lineItemsCount - 1)) * 0.5
//                    case .flexEnd:
//                        rowSectionW = interitemSpace
//                        startX += insets.left + (contentW - totalW - rowSectionW * (lineItemsCount - 1))
//                    case .spaceAround:
//                        rowSectionW = (contentW - totalW) / (lineItemsCount * 2)
//                        startX = insets.left +  rowSectionW * 0.5
//                        break;
//                    case .spaceBetween:
//                        rowSectionW = (contentW - totalW) / (lineItemsCount - 1)
//                        startX += insets.left
//                    }
//                    // 确定每个item的位置并修正尺寸
//                    for idx in 0 ..< lineAttrs.count {
//                        var ptX, ptY: CGFloat
//                        let attr = lineAttrs[idx]
//                        var attrFrame = attr.frame
//                        let alignItems = self.alignItemsForSection(at: section, inLine: index, with: attr.indexPath)
//                        ptX = startX
//                        var attrHeight: CGFloat = attrFrame.height
//                        switch alignItems {
//                        case .flexStart:
//                            ptY = topY
//                        case .center:
//                            ptY = topY + (rowMaxH - attrFrame.height) * 0.5
//                        case .flexEnd:
//                            ptY = topY + (rowMaxH - attrFrame.height)
////                        case .baseline:
//                        case .stretch:
//                            ptY = topY
//                            attrHeight = rowMaxH
//                        }
//                        startX += attrFrame.width + rowSectionW
//                        attrFrame = CGRect(x: ptX, y: ptY, width: attrFrame.width, height: attrHeight)
//                        attr.frame = attrFrame
//                        debugPrint(attrFrame)
//                    }
//                    topY += rowMaxH + sectionLineSpace
//                    maxHeight += rowMaxH + sectionLineSpace
//                }
//                maxHeight -= sectionLineSpace
//                //加上剩余的距离
//                maxHeight += sectionBottomH
//
//                if footerSize != .zero {
//                    let footerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
//                    footerAttr.frame = CGRect(x: flowSectionX, y: flowSectionY + maxHeight, width: contentW, height: footerSize.height)
//                    headerFooterAttr.append(footerAttr)
//                }
//                if self.scrollDirection == .horizontal {
//                    flowSectionX += maxWidth
//                    flowSectionX += insets.right
//                    flowSectionY = collectionView.contentInset.top
//                } else {
//                    flowSectionY += maxHeight
//                    flowSectionY += footerSize.height + insets.bottom
//                    flowSectionX = collectionView.contentInset.left
//                }
//
//                if allSectionMaxWidth < maxWidth {
//                    allSectionMaxWidth = maxWidth
//                }
//                if allSectionMaxHeight < maxHeight {
//                    allSectionMaxHeight = maxHeight
//                }
//            default:
//                break;
////            case .rowReverse:
////            case .column:
////            case .columnReverse:
//            }
//
//
//            supplementaryAttrs.append(headerFooterAttr)
//
//
//
//        }
//        if self.scrollDirection == .horizontal { //水平方向
//              self.contentSize = CGSize(width: flowSectionX - collectionView.contentInset.left + allSectionMaxWidth , height: flowSectionY - collectionView.contentInset.top + allSectionMaxHeight)
//        } else {//垂直方向滚动
//              self.contentSize = CGSize(width: flowSectionX - collectionView.contentInset.left + allSectionMaxWidth , height: flowSectionY - collectionView.contentInset.top)
//        }
//       debugPrint("=====",self.contentSize)
//        let items = allAttrs.flatMap({ $0.flatMap({$0}) })
//        attrs = items
//        supplementary = supplementaryAttrs.flatMap({$0})
////        attrs.append(contentsOf: supplementaryAttrs.flatMap({$0}))
//
//    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = attrs.first(where: { $0.indexPath == indexPath })
        return attr
    }
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = supplementary.first(where: { $0.indexPath == indexPath && $0.representedElementKind == elementKind})
        return attr
    }
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs + supplementary
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
            sectionSize = CGSize(width: collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right, height: collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom)
        }
        return sectionSize
    }
    
    func directionForSection(at section: Int) -> WQFlexDirection {
        return delegate?.flexbox?(collectionView!, flexbox: self, directionForSectionAt: section) ?? self.direction
    }
    
    func justifyContentForSection(at section: Int, inLine: Int , total: Int) -> WQJustifyContent {
        return delegate?.flexbox?(collectionView!, flexbox: self, justifyContentForSectionAt: section, inLine: inLine, linesCount: total) ?? self.justify_content
    }
    
    func alignItemsForSection(at section: Int, inLine: Int ,with indexPath: IndexPath) -> WQAlignItems {
        return delegate?.flexbox?(collectionView!, flexbox: self, alignItemsForSectionAt: section, inLine: inLine, with: indexPath) ?? self.align_items
    }
    func alignContentForSection(at section: Int) -> WQAlignContent {
        return delegate?.flexbox?(collectionView!, flexbox: self, alignContentForSectionAt: section) ?? self.align_content
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
