//
//  WQButton.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/8/5.
//

import UIKit
public enum WQTitleAlignment {
    case left, right, bottom, top
}
public final class WQButton: UIButton {
    
    //以下计算都是基于当前button有尺寸之后的调整
   public var imgSize: CGSize = .zero
   public var isAllowWrap: Bool = false {
        didSet {
            self.titleLabel?.numberOfLines = isAllowWrap ? 0 : 1
        }
    }
    
    public var titleAlignment: WQTitleAlignment = .left
    
    private var _titleFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addKVO()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addKVO()
    }
    private func addKVO() {
        self.addObserver(self, forKeyPath: "titleLabel.font", options: [.new], context: nil)
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[NSKeyValueChangeKey.newKey] as? UIFont {
            _titleFont = newValue
        }
    }
    private func removeKVO() {
        removeObserver(self, forKeyPath: "titleLabel.font")
    }
    deinit {
        removeKVO()
    }

    //AutoLayout时候 默认尺寸
    public override var intrinsicContentSize: CGSize {
        var contentSize: CGSize = .zero
        let imageSize = self.currentImageSize
        let titleSize = self.currentTitleSize
        let imageEdgeW = self.imageEdgeInsets.left + self.imageEdgeInsets.right
        let imageEdgeH = self.imageEdgeInsets.top + self.imageEdgeInsets.bottom
        let titleEdgeW = self.titleEdgeInsets.left + self.titleEdgeInsets.right
        let titleEdgeH = self.titleEdgeInsets.bottom + self.titleEdgeInsets.top
        switch titleAlignment {
        case .left, .right:
            contentSize.width = imageEdgeW + titleEdgeW + imageSize.width + titleSize.width
            contentSize.height = max(imageSize.height + imageEdgeH, titleSize.height + titleEdgeH)
        case .bottom, .top:
            contentSize.height = imageEdgeH + titleEdgeH + imageSize.height + titleSize.height
            contentSize.width = max(imageSize.width + imageEdgeW, titleSize.width + titleEdgeW)
        }
        return CGSize(width: contentSize.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                      height: contentSize.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom)
    }
   private var currentImageSize: CGSize {
        if imgSize != .zero {
            return fitImageSize(imgSize)
        } else if let image = self.currentImage {
            return fitImageSize(image.size)
        }
        return .zero
    }
    
    private
     func fitImageSize(_ size: CGSize) -> CGSize {
        guard frame.size != .zero else {
            return size
        }
        let insetsBound = UIEdgeInsetsInsetRect(frame, self.contentEdgeInsets)
        var fitSize = size
        if size.width > insetsBound.width {
            self.imageEdgeInsets = .zero
            fitSize.width = insetsBound.width
            fitSize.height = insetsBound.width / size.width * size.height
        }
        if fitSize.height > insetsBound.height {
            self.imageEdgeInsets = .zero
            fitSize.height = insetsBound.height
            fitSize.width = insetsBound.height / fitSize.height * fitSize.width
        }
        return fitSize
    }
    
    private var currentTitleSize: CGSize {
        var titleMaxW: CGFloat = CGFloat.greatestFiniteMagnitude
        var titleMaxH: CGFloat = 20
        if frame.size != .zero {
            let insetsBound = UIEdgeInsetsInsetRect(frame, self.contentEdgeInsets)
            titleMaxW = insetsBound.width - self.titleEdgeInsets.left
                - self.titleEdgeInsets.right
            titleMaxH = insetsBound.height - self.titleEdgeInsets.top
                - self.titleEdgeInsets.bottom
        }
     
        let imageSize = self.currentImageSize
        if  imageSize != .zero {
            if titleAlignment == .left || titleAlignment == .right {
                titleMaxW -= (self.imageEdgeInsets.left + self.imageEdgeInsets.right + imageSize.width)
            } else {
                titleMaxH -= (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom + imageSize.height)
            }
        }
        let titleMaxSize = CGSize(width: titleMaxW, height: titleMaxH)
        if let attributeString = self.currentAttributedTitle {
            return  attributeString
                   .boundingRect(with: titleMaxSize,
                                 options: .usesLineFragmentOrigin,
                                 context: nil).size
        } else if let title = self.currentTitle {
            let size = (title as NSString)
                .boundingRect(with: titleMaxSize,
                              options: .usesLineFragmentOrigin,
                              attributes: [.font: _titleFont],
                              context: nil ).size
            return size
        } else {
            return .zero
        }
    }
    
    public override
    func contentRect(forBounds bounds: CGRect) -> CGRect {
        guard bounds.size != .zero else { return .zero }
        let rect = UIEdgeInsetsInsetRect(bounds, self.contentEdgeInsets)
        var contentW: CGFloat; var contentH: CGFloat
        let titleSize = self.currentTitleSize; let imageSize = self.currentImageSize
        let titleEdgeW = self.titleEdgeInsets.left + self.titleEdgeInsets.right
        let titleEdgeH = self.titleEdgeInsets.top + self.titleEdgeInsets.bottom
        let imageEdgeW = self.imageEdgeInsets.left + self.imageEdgeInsets.right
        let imageEdgeH = self.imageEdgeInsets.top + self.imageEdgeInsets.bottom
        switch self.titleAlignment {
        case .left, .right:
            contentW = titleEdgeW + imageEdgeW + titleSize.width + imageSize.width
            contentH = max(titleSize.height + titleEdgeH, imageSize.height + imageEdgeH)
        case .bottom, .top:
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
        }
        return CGRect(x: contentX, y: contentY, width: contentW, height: contentH)
    }
    
    public override
    func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imgX: CGFloat; var imgY: CGFloat
        let imageSize = self.currentImageSize
        let imageEdgeW = self.imageEdgeInsets.left + self.imageEdgeInsets.right
        let imageEdgeH = self.imageEdgeInsets.top + self.imageEdgeInsets.bottom
        switch self.titleAlignment {
        case .top, .bottom:
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
        case .right, .left:
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
            }
        }
        return CGRect(origin: CGPoint(x: imgX + contentRect.minX, y: imgY + contentRect.minY), size: imageSize)
    }
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleX: CGFloat; var titleY: CGFloat
        let titleSize = self.currentTitleSize
        let titleEdgeW = self.titleEdgeInsets.left + self.titleEdgeInsets.right
        let titleEdgeH = self.titleEdgeInsets.top + self.titleEdgeInsets.bottom
        switch self.titleAlignment {
        case .top, .bottom:
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
        case .right, .left:
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
            }
        }
        return CGRect(origin: CGPoint(x: titleX + contentRect.minX, y: titleY + contentRect.minY), size: titleSize)
    }
  
}
public extension WQButton {
    convenience init(_ title: String?, image: UIImage?, alignment: WQTitleAlignment = .left , state: UIControlState = .normal) {
        self.init()
        self.titleAlignment = alignment
        self.setTitle(title, for: state)
        self.setImage(image, for: state)
    }
    func wq_setImageMasks(_ radius: CGFloat)  {
        self.imageView?.layer.cornerRadius = radius;
        self.imageView?.layer.masksToBounds = true
    }
    func wq_setImageCircularBorder(_ width: CGFloat, color: CGColor) {
        guard let imgView = self.imageView else {
            return
        }
        self.wq_setImageBorder(width, color: color, radius: imgView.frame.height * 0.5)
    }
    func wq_setImageBorder(_ width: CGFloat, color: CGColor, radius: CGFloat = 0) {
        self.imageView?.layer.borderWidth = width
        self.imageView?.layer.cornerRadius = radius
        self.imageView?.layer.borderColor = color
        self.imageView?.layer.masksToBounds = true
    }
    func wq_setTitleCircularBorder(_ width: CGFloat, color: CGColor) {
        guard let label = self.titleLabel else {
            return
        }
        self.wq_setTitleBorder(width, color: color, radius: label.frame.height * 0.5)
    }
    func wq_setTitleBorder(_ width: CGFloat, color: CGColor, radius: CGFloat = 0) {
        self.titleLabel?.layer.borderWidth = width
        self.titleLabel?.layer.cornerRadius = radius
        self.titleLabel?.layer.borderColor = color
        self.titleLabel?.layer.masksToBounds = true
    }
}
