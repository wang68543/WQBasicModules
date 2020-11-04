//  swiftlint:disable:this file_name
//  WQFlexLayout.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/23.
//

import Foundation

public struct WQFlexLinePath {
    let section: Int
    let line: Int
    let totalLines: Int
    /// items IndexPath.item Range
    let range: Range<Int>
}
internal struct WQFlexItemAttributes {
    let indexPath: IndexPath
    var size: CGSize
}
extension Array where Element == WQFlexItemAttributes {
    func totalLength(_ isHorizontal: Bool) -> CGFloat {
        var sum: CGFloat = 0
        if isHorizontal {
            sum = self.reduce(0) { result, item in
                return result + item.size.width
            }
        } else {
            sum = self.reduce(0) { result, item in
                return result + item.size.height
            }
        }
        return sum
    }
    func maxWidth(_ isHorizontal: Bool) -> CGFloat {
        var max: CGFloat = 0
        if isHorizontal {
            if let value = self.max(by: { $0.size.height < $1.size.height }) {
                max = value.size.height
            }
        } else {
            if let value = self.max(by: { $0.size.width < $1.size.width }) {
                max = value.size.width
            }
        }
        return max
    }
}
// 不包含 insets 跟header 和footer
internal struct WQFlexLineSpace {
    let space: CGFloat
    let leading: CGFloat
    let trailing: CGFloat

    init(singleLine space: CGFloat) {
        leading = 0
        trailing = 0
        self.space = space
    }
    init(_ items: [WQFlexItemAttributes],
         limitLength: CGFloat,
         justify: WQJustifyContent,
         minItemsSpace: CGFloat,
         isHorizontal: Bool) {
        let lineCount = CGFloat(items.count)
        let totalWidth = items.totalLength(isHorizontal)
        let minTotalValue = totalWidth + (lineCount - 1) * minItemsSpace
        switch justify {
        case .flexStart:
        space = minItemsSpace
        leading = 0
        trailing = limitLength - minTotalValue
        case .flexEnd:
            space = minItemsSpace
            trailing = 0
            leading = limitLength - minTotalValue
        case .center:
            space = minItemsSpace
            let margin = (limitLength - minTotalValue) * 0.5
            leading = margin
            trailing = margin
        case .spaceBetween:
            if lineCount < 2 {
                space = 0
            } else {
                space = (limitLength - totalWidth) / (lineCount - 1)
            }
            leading = 0
            trailing = 0
        case .spaceAround:
            let margin = (limitLength - totalWidth) / lineCount
            leading = margin * 0.5
            trailing = margin * 0.5
            if lineCount < 2 {
                space = 0
            } else {
               space = margin
            }

        }
    }
    private init (space: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.space = space
        self.leading = leading
        self.trailing = trailing
    }
}
extension WQFlexLineSpace {
    static let zero = WQFlexLineSpace(space: 0, leading: 0, trailing: 0)
}
internal struct WQFlexLineAttributes {
    let linePath: WQFlexLinePath
    let items: [WQFlexItemAttributes]
    /// 主轴方向内容的实际总长度
    let length: CGFloat
    /// 交叉轴方向items的最大边框
    let maxWidth: CGFloat
    let margin: WQFlexLineSpace

    init(_ path: WQFlexLinePath,
         items: [WQFlexItemAttributes],
         margin: WQFlexLineSpace,
         isHorizontal: Bool) {
        self.margin = margin
        linePath = path
        if items.isEmpty {
            length = 0
            maxWidth = 0
        } else {
            maxWidth = items.maxWidth(isHorizontal)
            var totalLength = items.totalLength(isHorizontal)
            totalLength += margin.space * CGFloat(items.count - 1) + margin.leading + margin.trailing
            length = totalLength
        }
        self.items = items
    }
}
extension Array where Element == WQFlexLineAttributes {
    func totalWidth() -> CGFloat {
        return self.reduce(0, { $0 + $1.maxWidth })
    }
}
// 不包含 insets 跟header 和footer
internal struct WQFlexSectionSpace {
    let lineSpace: CGFloat
    let lineHeader: CGFloat
    let lineFooter: CGFloat
}
extension WQFlexSectionSpace {
    static let zero = WQFlexSectionSpace(lineSpace: 0, lineHeader: 0, lineFooter: 0)
}
internal struct WQFlexSectionAttributes {
    let section: Int
    ///包含 header footer insets
    var bounds: CGRect = .zero
    /// 不包含 insets 跟header 和footer
    var edge: WQFlexSectionSpace = .zero
    let insets: UIEdgeInsets // 用于行计算
    let headerSize: CGSize
    let footerSize: CGSize
    let lines: [WQFlexLineAttributes]

    init(_ section: Int, header: CGSize, footer: CGSize, insets: UIEdgeInsets, lines: [WQFlexLineAttributes]) {
        self.section = section
        self.insets = insets
        self.footerSize = footer
        self.headerSize = header
        self.lines = lines
    }

    /// 计算egde和bounds
    ///
    /// - Parameters:
    ///   - viewWidth: 非主轴方向的 view的内容长度 (不包含insets 、header/footer)
    ///   - alignContent: lines整体排列方式(以collectionView的size为参照 sections 为1的时候 并且内容小于size的时候才起作用)
    ///   - lineSpace:  (item 之间的间距) //最小的line 间距
    mutating func config(viewWidth: CGFloat, alignContent: WQAlignContent, lineSpace: CGFloat, sections: Int) {
        var fixAlign: WQAlignContent = alignContent
        let lineCount = CGFloat(lines.count)
        let linesTotalWidth = self.lines.totalWidth()
        let minTotalWidth = (lineCount - 1) * lineSpace + linesTotalWidth
        if sections > 1 || viewWidth < minTotalWidth { // 只有一个分区并且内容长度小于限制长度
            fixAlign = .flexStart
        }
        var lineHeader, lineFooter, space: CGFloat
        switch fixAlign {
        case .flexStart:
            lineHeader = 0
            space = lineSpace
            if sections == 1 {
                lineFooter = max(viewWidth - minTotalWidth, 0)
            } else {
                lineFooter = 0
            }
        //下面的属性只有 sections == 0 并且长度小于viewLength才生效
        case .flexEnd:
            space = lineSpace
            lineFooter = 0
            lineHeader = viewWidth - minTotalWidth
        case .center:
            space = lineSpace
            lineFooter = (viewWidth - minTotalWidth) * 0.5
            lineHeader = lineFooter
        case .spaceAround:
            if lineCount < 2 {
                lineFooter = (viewWidth - linesTotalWidth) * 0.5
                lineHeader = lineFooter
                space = 0
            } else {
                space = (viewWidth - linesTotalWidth) / lineCount
                lineFooter = space * 0.5
                lineHeader = lineFooter
            }
        case .spaceBetween:
            lineFooter = 0
            lineHeader = 0
            if lineCount < 2 {
                space = 0
            } else {
                space = (viewWidth - linesTotalWidth) / (lineCount - 1)
            }
        }

        edge = WQFlexSectionSpace(lineSpace: space, lineHeader: lineHeader, lineFooter: lineFooter)
    }
    mutating func config(_ isHorizonal: Bool) {
        let lineCount = CGFloat(lines.count)
        let realWidth = self.lines.totalWidth() + self.edge.lineSpace * (lineCount - 1) + self.edge.lineFooter + self.edge.lineHeader
        let realLength = lines.first?.length ?? 0
        var contentLength = self.insets.left + self.insets.right
        var contentHeight = self.insets.top + self.insets.bottom + self.headerSize.height + self.footerSize.height
        if isHorizonal {
            contentLength += realLength
            contentHeight += realWidth
        } else {
            contentLength += realWidth
            contentHeight += realLength
        }
        self.bounds = CGRect(x: 0, y: 0, width: contentLength, height: contentHeight)
    }
}
