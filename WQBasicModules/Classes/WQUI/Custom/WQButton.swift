//
//  WQButton.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/8/5.
//  1.当没有加到superView中的时候不会产生布局
//  2.布局顺序是①backgroundRect ②contentRect->imageRect ③contentRect->titleRect(若没有对应属性就不会产生对应的属性布局)
//  3.当加到superView后改变标题或者图片都会整个重新布局(若图片或标题不变不会引起布局)
//  4.state改变也会重新布局

import UIKit

public final class WQButton: UIButton {
    public enum TitleAlignment {
        case left, right, bottom, top
    }
    //以下计算都是基于当前button有尺寸之后的调整
    public var imgSize: CGSize = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    /// 是否允许标题换行
   public var isAllowWrap: Bool = false {
        didSet {
            self.titleLabel?.numberOfLines = isAllowWrap ? 0 : 1
            setNeedsLayout()
        }
    }
    
    public var titleAlignment: TitleAlignment = .left {
        didSet {
             setNeedsLayout()
        }
    }
    
    private var titleFont = UIFont.systemFont(ofSize: 15) // 系统按钮默认字体字体
    private var titleFontObservation: NSKeyValueObservation?
    //AutoLayout时候 默认尺寸
    public override var intrinsicContentSize: CGSize {
        var contentSize: CGSize = .zero
        let imageSize = self.currentImageSize
        let titleSize = self.currentTitleSize
        let imageEdgeW = self.imageEdgeInsets.left + self.imageEdgeInsets.right
        let imageEdgeH = self.imageEdgeInsets.top + self.imageEdgeInsets.bottom
        let titleEdgeW = self.titleEdgeInsets.left + self.titleEdgeInsets.right
        let titleEdgeH = self.titleEdgeInsets.bottom + self.titleEdgeInsets.top
        let contentEdgeW = self.contentEdgeInsets.left + self.contentEdgeInsets.right
        let contentEdgeH = self.contentEdgeInsets.top + self.contentEdgeInsets.bottom
        if titleAlignment.isHorizontal {
            contentSize.width = imageEdgeW + titleEdgeW + imageSize.width + titleSize.width
            contentSize.height = max(imageSize.height + imageEdgeH, titleSize.height + titleEdgeH)
        } else {
            contentSize.height = imageEdgeH + titleEdgeH + imageSize.height + titleSize.height
            contentSize.width = max(imageSize.width + imageEdgeW, titleSize.width + titleEdgeW)
        } 
        return CGSize(width: contentSize.width + contentEdgeW, height: contentSize.height + contentEdgeH)
    }
    
       //swiftlint:disable function_body_length
    public override func contentRect(forBounds bounds: CGRect) -> CGRect {
        guard bounds.size != .zero else { return .zero }
        let rect = bounds.inset(by: self.contentEdgeInsets)
        var contentW, contentH: CGFloat
        let titleSize = self.currentTitleSize; let imageSize = self.currentImageSize
        let titleEdgeW = self.titleEdgeInsets.left + self.titleEdgeInsets.right
        let titleEdgeH = self.titleEdgeInsets.top + self.titleEdgeInsets.bottom
        let imageEdgeW = self.imageEdgeInsets.left + self.imageEdgeInsets.right
        let imageEdgeH = self.imageEdgeInsets.top + self.imageEdgeInsets.bottom
        if self.titleAlignment.isHorizontal {
            contentW = titleEdgeW + imageEdgeW + titleSize.width + imageSize.width
            contentH = max(titleSize.height + titleEdgeH, imageSize.height + imageEdgeH)
        } else {
            contentH = titleEdgeH + imageEdgeH + titleSize.height + imageSize.height
            contentW = max(titleSize.width + titleEdgeW, imageSize.width + imageEdgeW)
        } 
        var contentX: CGFloat
        switch self.contentHorizontalAlignment {
        case .left :
            contentX = self.contentEdgeInsets.left
        case .center:
            contentX = self.contentEdgeInsets.left + (rect.width - contentW) * 0.5
        case .right:
            contentX = rect.width - contentW - self.contentEdgeInsets.right + self.contentEdgeInsets.left
        case .fill:
            contentX = self.contentEdgeInsets.left
            contentW = rect.width
        default:
            fatalError("暂不支持此属性")
        }
        var contentY: CGFloat
        switch self.contentVerticalAlignment {
        case .top:
            contentY = self.contentEdgeInsets.top
        case .center:
            contentY = self.contentEdgeInsets.top + (rect.height - contentH) * 0.5
        case .bottom:
            contentY = rect.height - contentH - self.contentEdgeInsets.bottom + self.contentEdgeInsets.top
        case .fill:
            contentY = self.contentEdgeInsets.top
            contentH = rect.height
            #if swift (>=5.0)
        @unknown default:
            fatalError("不支持的布局类型")
            #endif
        }
        return CGRect(x: contentX, y: contentY, width: contentW, height: contentH)
    }
    
    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imgX, imgY: CGFloat
        let imageSize = self.currentImageSize
        let imageEdgeW = self.imageEdgeInsets.left + self.imageEdgeInsets.right
        let imageEdgeH = self.imageEdgeInsets.top + self.imageEdgeInsets.bottom
        if self.titleAlignment.isVertical {
            if self.titleAlignment == .top {
                imgY = contentRect.height - self.imageEdgeInsets.bottom - imageSize.height
            } else {
                imgY = self.imageEdgeInsets.top
            }
            switch self.contentHorizontalAlignment {
            case .left:
                imgX = self.imageEdgeInsets.left
            case .center, .fill:
                imgX = self.imageEdgeInsets.left + (contentRect.width - imageSize.width - imageEdgeW) * 0.5
            case .right:
                imgX = contentRect.width - imageSize.width - self.imageEdgeInsets.right
            default:
                fatalError("暂不支持类型")
            }
        } else {
            if self.titleAlignment == .left {
                imgX = contentRect.width - self.imageEdgeInsets.right - imageSize.width
            } else {
                imgX = self.imageEdgeInsets.left
            }
            switch self.contentVerticalAlignment {
            case .top:
                imgY = self.imageEdgeInsets.top
            case .center, .fill:
                imgY = self.imageEdgeInsets.top + (contentRect.height - imageSize.height - imageEdgeH) * 0.5
            case .bottom:
                imgY = contentRect.height - imageSize.height - self.imageEdgeInsets.bottom
                #if swift (>=5.0)
            @unknown default:
                fatalError("不支持的布局类型")
                #endif
            }
        }
        return CGRect(origin: CGPoint(x: imgX + contentRect.minX, y: imgY + contentRect.minY), size: imageSize)
    }
    
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleX, titleY: CGFloat 
        let titleSize = self.currentTitleSize
        let titleEdgeW = self.titleEdgeInsets.left + self.titleEdgeInsets.right
        let titleEdgeH = self.titleEdgeInsets.top + self.titleEdgeInsets.bottom
        if titleAlignment.isVertical {
            if self.titleAlignment == .bottom {
                titleY = contentRect.height - self.titleEdgeInsets.bottom - titleSize.height
            } else {
                titleY = self.titleEdgeInsets.top
            }
            switch self.contentHorizontalAlignment {
            case .left:
                titleX = self.titleEdgeInsets.left
            case .center, .fill:
                titleX = self.titleEdgeInsets.left + (contentRect.width - titleSize.width - titleEdgeW) * 0.5
            case .right:
                titleX = contentRect.width - titleSize.width - self.titleEdgeInsets.right
            default:
                fatalError("暂不支持类型")
            }
        } else {
            if self.titleAlignment == .right {
                titleX = contentRect.width - self.titleEdgeInsets.right - titleSize.width
            } else {
                titleX = self.titleEdgeInsets.left
            }
            switch self.contentVerticalAlignment {
            case .top:
                titleY = self.titleEdgeInsets.top
            case .center, .fill:
                titleY = self.titleEdgeInsets.top + (contentRect.height - titleSize.height - titleEdgeH) * 0.5
            case .bottom:
                titleY = contentRect.height - titleSize.height - self.titleEdgeInsets.bottom
                #if swift (>=5.0)
            @unknown default:
                fatalError("不支持的布局类型")
                #endif
            }
        }
        return CGRect(origin: CGPoint(x: titleX + contentRect.minX, y: titleY + contentRect.minY), size: titleSize)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        if self.hasTitle {
           self.addTitleLabelFontObservation()
        }
    }
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.addTitleLabelFontObservation()
    }
    public override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        super.setAttributedTitle(title, for: state)
        self.addTitleLabelFontObservation()
    }
    deinit {
        // fix: iOS 10
        if let observer = self.titleFontObservation {
          observer.invalidate()
          self.removeObserver(observer, forKeyPath: "titleLabel.font")
          self.titleFontObservation = nil
        }
    }
}

private extension WQButton.TitleAlignment {
    var isHorizontal: Bool {
        return self == .left || self == .right
    }
    var isVertical: Bool {
        return self == .top || self == .bottom
    }
}
private extension WQButton {
    /// 内容的布局区域
    var conentBounds: CGRect {
        return self.bounds.inset(by: self.contentEdgeInsets)
    }
    var hasTitle: Bool {
        return self.currentTitle != nil || self.currentAttributedTitle != nil
    }
    var currentImageSize: CGSize {
        guard self.frame.size != .zero else {
            return .zero
        }
        if imgSize != .zero {
            return fitImageSize(imgSize)
        } else if let image = self.currentImage {
            return fitImageSize(image.size)
        }
        return .zero
    }
    var currentTitleSize: CGSize {
        guard self.hasTitle && self.frame.size != .zero else { return .zero }
        let rect = self.conentBounds
        var maxW = rect.width - self.titleEdgeInsets.left - self.titleEdgeInsets.right
        var maxH = rect.height - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom
        let imageSize = self.currentImageSize
        if  imageSize != .zero {
            if titleAlignment.isHorizontal {
                maxW -= (self.imageEdgeInsets.left + self.imageEdgeInsets.right + imageSize.width)
            } else {
                maxH -= (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom + imageSize.height)
            }
        }
        let maxSize = CGSize(width: maxW, height: maxH)
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var size: CGSize = .zero
        if let attributeString = self.currentAttributedTitle {
            size = attributeString.boundingRect(with: maxSize, options: options, context: nil).size
        } else if let title = self.currentTitle {
            let text = NSString(string: title)
            //notaTODO: 如果当maxSize不够的时候 就会缩减多余的字符以..代替并返回缩减之后的尺寸
            size = text.boundingRect(with: maxSize, options: options, attributes: [.font: titleFont], context: nil).size
        }
        //向上取整 解决达不到最大值的问题
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    // 修正尺寸过大的图片
    func fitImageSize(_ size: CGSize) -> CGSize {
        guard frame.size != .zero else { return size }
        let insetsBound = self.conentBounds
        var maxW = insetsBound.width - self.imageEdgeInsets.left - self.imageEdgeInsets.right
        var maxH = insetsBound.height - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom
        if self.hasTitle {
            if self.titleAlignment.isHorizontal {
                maxW -= (self.titleEdgeInsets.left - self.titleEdgeInsets.right)
            } else {
                maxH -= (self.titleEdgeInsets.top - self.titleEdgeInsets.bottom)
            }
        }
        var fitSize = size
        if fitSize.width > maxW {
            fitSize.width = maxW
            fitSize.height = maxW / size.width * size.height
        }
        if fitSize.height > maxH {
            fitSize.height = maxH
            fitSize.width = maxH / fitSize.height * fitSize.width
        }
        return fitSize
    }
    func addTitleLabelFontObservation() {
        guard self.titleFontObservation == nil else {
            return
        }
        if let font = self.titleLabel?.font {
            self.titleFont = font
        }
        // nota: 这里如果是自身监听自身的话不能把自身传入到回调中 会引起crash 只能通过弱引用
        self.titleFontObservation = self.observe(\WQButton.titleLabel?.font,
                                                 options: [.old, .new], changeHandler: { [weak self ] _, change in
            guard change.newValue != change.oldValue else { return }
            guard let weakSelf = self,
                let newValue = change.newValue,
                let newFont = newValue else {
                return
            }
            weakSelf.titleFont = newFont
            weakSelf.setNeedsLayout()
        })
    }
}
 
public extension WQModules where Base: WQButton {
    
    func setImageMasks(_ radius: CGFloat) {
        guard let imgView = self.base.imageView else { return }
        imgView.layer.cornerRadius = radius
        imgView.layer.masksToBounds = true
    }
    
    func setImageCircularBorder(_ width: CGFloat, color: CGColor) {
        guard let imgView = self.base.imageView else {
            return
        }
        self.setImageBorder(width, color: color, radius: imgView.frame.height * 0.5)
    }
    
    func setImageBorder(_ width: CGFloat, color: CGColor, radius: CGFloat = 0) {
        guard let imgView = self.base.imageView else { return }
        imgView.layer.borderWidth = width
        imgView.layer.cornerRadius = radius
        imgView.layer.borderColor = color
        imgView.layer.masksToBounds = true
    }
    
    func setTitleCircularBorder(_ width: CGFloat, color: CGColor) {
        guard let label = self.base.titleLabel else {
            return
        }
        self.setTitleBorder(width, color: color, radius: label.frame.height * 0.5)
    }
    
    func setTitleBorder(_ width: CGFloat, color: CGColor, radius: CGFloat = 0) {
        guard let label = self.base.titleLabel else { return }
        label.layer.borderWidth = width
        label.layer.cornerRadius = radius
        label.layer.borderColor = color
        label.layer.masksToBounds = true
    }
}

public extension WQButton {
    convenience init(_ title: String?, image: UIImage?, alignment: TitleAlignment = .left, state: UIControl.State = .normal) {
        self.init()
        self.setTitle(title, for: state)
        self.setImage(image, for: state)
        self.titleAlignment = alignment
    }
    @available(*, deprecated, renamed: "wm.setImageMasks")
    func wq_setImageMasks(_ radius: CGFloat) {
        self.imageView?.layer.cornerRadius = radius
        self.imageView?.layer.masksToBounds = true
    }
    @available(*, deprecated, renamed: "wm.setImageCircularBorder")
    func wq_setImageCircularBorder(_ width: CGFloat, color: CGColor) {
        guard let imgView = self.imageView else {
            return
        }
        self.wq_setImageBorder(width, color: color, radius: imgView.frame.height * 0.5)
    }
    @available(*, deprecated, renamed: "wm.setImageBorder")
    func wq_setImageBorder(_ width: CGFloat, color: CGColor, radius: CGFloat = 0) {
        self.imageView?.layer.borderWidth = width
        self.imageView?.layer.cornerRadius = radius
        self.imageView?.layer.borderColor = color
        self.imageView?.layer.masksToBounds = true
    }
    @available(*, deprecated, renamed: "wm.setTitleCircularBorder")
    func wq_setTitleCircularBorder(_ width: CGFloat, color: CGColor) {
        guard let label = self.titleLabel else {
            return
        }
        self.wq_setTitleBorder(width, color: color, radius: label.frame.height * 0.5)
    }
    @available(*, deprecated, renamed: "wm.setTitleBorder")
    func wq_setTitleBorder(_ width: CGFloat, color: CGColor, radius: CGFloat = 0) {
        self.titleLabel?.layer.borderWidth = width
        self.titleLabel?.layer.cornerRadius = radius
        self.titleLabel?.layer.borderColor = color
        self.titleLabel?.layer.masksToBounds = true
    }
}
