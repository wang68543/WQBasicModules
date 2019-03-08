//
//  WQAlertView.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/3/7.
//  模仿系统弹出框

import UIKit

public class WQAlertAction: NSObject {
    public typealias Handler = (WQAlertAction) -> Void
    public let attributedText: NSAttributedString
    public let handler: Handler?
    public var isEnabled: Bool = true
    /// 是否点击之后自动销毁
    public var isDestructive: Bool = true
    
    public init(attributedText: NSAttributedString, handler: Handler? = nil) {
        self.handler = handler
        self.attributedText = attributedText
        super.init()
    }
}
public extension WQAlertAction {
    convenience
    init(title: String,
         attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black],
         handler: Handler? = nil) {
        self.init(attributedText: NSAttributedString(string: title, attributes: attrs), handler: handler)
    }
}
//public protocol WQAlertBottomViewProtocol {
//    static var heightForView: CGFloat { get }
//    func addActions(_ actions: [WQAlertAction])
//    var buttons: [UIButton] { get }
//}
//public typealias WQAlertBottomView = UIView & WQAlertBottomViewProtocol

public class WQAlertView: UIView {
    let titleLabel: UILabel
    let messageLabel: UILabel
    /// 标题跟内容的周边间距 不包含底部按钮视图
    public var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 25, left: 15, bottom: 25, right: 10)
    /// 标题与内容之间的间距
    public var margin: CGFloat = 8
    ///底部视图高度
    public var bottomHeight: CGFloat = 45
    lazy var bottomView: BottomView = BottomView()
    public var attributedTitle: NSAttributedString? {
        didSet {
            self.titleLabel.attributedText = attributedTitle
        }
    }
    public var attributedMessage: NSAttributedString {
        didSet {
            self.messageLabel.attributedText = attributedMessage
        }
    }
    
    private var showSize: CGSize = .zero
    
    public init(_ title: String?, message: String) {
        titleLabel = UILabel()
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        attributedMessage = NSAttributedString(string: message,
                                               attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black])
        if let text = title {
            attributedTitle = NSAttributedString(string: text,
                                                 attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.black])
        }
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
        titleLabel.textAlignment = .center
        self.titleLabel.attributedText = attributedTitle
        self.messageLabel.attributedText = attributedMessage
    }
    public func addAction(_ action: WQAlertAction) {
        if self.bottomView.superview == nil {
            self.addSubview(self.bottomView)
        }
        self.bottomView.addButton(for: action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func size(for width: CGFloat) -> CGSize {
       let limitWidth: CGFloat = width - self.contentEdgeInsets.left - self.contentEdgeInsets.right
        var viewH: CGFloat = self.contentEdgeInsets.top
        if self.attributedTitle != nil {
          let titleBounds = CGRect(origin: .zero, size: CGSize(width: limitWidth, height: 60))
          let titleSize = self.titleLabel.textRect(forBounds: titleBounds, limitedToNumberOfLines: 1).size
            viewH += titleSize.height + self.margin
            self.titleLabel.bounds = CGRect(origin: .zero, size: titleSize)
        }
       let msgBounds = CGRect(origin: .zero, size: CGSize(width: limitWidth, height: 400))
       let msgSize = self.messageLabel.textRect(forBounds: msgBounds, limitedToNumberOfLines: 0).size
       self.messageLabel.bounds = CGRect(origin: .zero, size: msgSize)
       viewH += msgSize.height + self.contentEdgeInsets.bottom
       return self.bottomView.btns.isEmpty ? CGSize(width: width, height: viewH ) : CGSize(width: width, height: viewH + self.bottomHeight)
    }
    
    public func show(for width: CGFloat = UIScreen.main.bounds.width - 50) {
        let size = self.size(for: width)
//        self.frame = CGRect(origin: .zero, size: self.size(for: width))
        let showFrame = CGRect(x: (UIScreen.main.bounds.width - size.width) * 0.5, y: (UIScreen.main.bounds.height - size.height) * 0.5, width: size.width, height: size.height)
        let initailItem = WQAnimatedItem(containerFrame: showFrame, show: .zero)
        let presention = WQPresentationable(subView: self, animator: WQTransitioningAnimator(items: [initailItem], delegate: self))
        presention.show(animated: true, in: nil, completion: nil)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        let contentW = self.frame.width - self.contentEdgeInsets.left - self.contentEdgeInsets.top
        var offsetY = self.contentEdgeInsets.top
        let leftX = self.contentEdgeInsets.left
        if self.attributedTitle != nil {
            self.titleLabel.frame = CGRect(x: leftX, y: offsetY, width: contentW, height: self.titleLabel.bounds.height)
            offsetY += self.titleLabel.bounds.height + self.margin
        } else {
            self.titleLabel.frame = .zero
        }
        self.messageLabel.frame = CGRect(x: leftX, y: offsetY, width: contentW, height: self.messageLabel.bounds.height)
        if self.bottomView.btns.isEmpty {
            bottomView.frame = .zero
        } else {
            bottomView.frame = CGRect(x: 0, y: self.frame.height - self.bottomHeight, width: self.frame.width, height: self.bottomHeight)
        }
    }
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            self.bottomView.btns.forEach { btn in
                btn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            }
        } else {
            self.bottomView.btns.forEach { btn in
                btn.removeTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            }
        }
    }
    deinit {
        debugPrint("销毁了")
    }
}

// MARK: - button
extension WQAlertView {
    open class Button: UIButton {
        
        public let action: WQAlertAction
        
        public init(_ action: WQAlertAction) {
            self.action = action
            super.init(frame: .zero)
            self.setAttributedTitle(action.attributedText, for: .normal)
        }
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
   open class BottomView: UIView {
        open private(set) var btns: [UIButton] = []
        open private(set) var lines: [CALayer] = []
        open var lineColor: CGColor = UIColor.groupTableViewBackground.cgColor
    
        open func addButton(for action: WQAlertAction) {
            let btn = Button(action)
            self.btns.append(btn)
            self.addSubview(btn)
            let line = CALayer()
            line.backgroundColor = lineColor
            self.lines.append(line)
            self.layer.addSublayer(line)
        }
    
    override
    open func layoutSubviews() {
            super.layoutSubviews()
            let viewW = self.frame.width
            let viewH = self.frame.height
            let lineW = (1 / UIScreen.main.scale)
            let lineOffset = (1 / UIScreen.main.scale) / 2
            let btnsCount = CGFloat(self.btns.count)
            let btnW = (viewW - (btnsCount - 1) ) / btnsCount
            let btnH = viewH - 1
            for index in 0 ..< self.btns.count {
                let line = self.lines[index]
                let offsetIdx = CGFloat(index)
                if index == 0 {
                   line.frame = CGRect(x: 0, y: lineOffset, width: viewW, height: lineW)
                } else {
                    line.frame = CGRect(x: btnW * offsetIdx + lineOffset, y: lineW, width: lineW, height: btnH + lineOffset)
                }
                let btn = self.btns[index]
                btn.frame = CGRect(x: btnW * offsetIdx, y: 1, width: btnW, height: btnH)
            }
        }
    }
   
    @objc
    func buttonAction(_ sender: Button) {
        let action = sender.action
        guard action.isEnabled else { return }
        if action.isDestructive {
            self.wm.dismiss(true) {
                action.handler?(action)
            }
        } else {
            action.handler?(action)
        }
    }
}
extension WQAlertView: WQTransitioningAnimatorable {
    public func transition(shouldAnimated animator: WQTransitioningAnimator,
                           presented: UIViewController?,
                           presenting: UIViewController?,
                           isShow: Bool,
                           completion: @escaping WQAnimateCompletion) {
        if let presentingVC = presenting as? WQPresentationable {
            
            if isShow {
                presentingVC.view.backgroundColor = UIColor.clear
                presentingVC.view.frame = UIScreen.main.bounds
                presentingVC.containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            }
            if isShow {
                UIView.animate(withDuration: 0.15,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 15,
                               options: [.beginFromCurrentState, .curveEaseOut, .layoutSubviews],
                               animations: {
                                presentingVC.containerView.transform = CGAffineTransform.identity
                },
                               completion: nil)
                UIView.animate(withDuration: 0.15, animations: {
                    presentingVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                }, completion: { flag in
                    completion(flag)
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    presentingVC.containerView.removeFromSuperview()
                    presentingVC.view.backgroundColor = UIColor.clear
                }, completion: { flag in
                    completion(flag)
                })
            }
        }
    }
}
