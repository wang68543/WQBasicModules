//
//  ExampleAlertViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/3/7.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
//import SnapKit
class ExampleAlertViewController: BaseExampleViewController {
    let alertView = UIView()
    let imageView: UIImageView = UIImageView(image: UIImage(named: "首页8"))
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        self.edgesForExtendedLayout = []
        self.view.addSubview(button)
        button.setTitle("点击弹出", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
//        imageView.frame = CGRect(x: 300, y: 300, width: 60, height: 60)
//        self.view.addSubview(imageView)
//        imageView.image = UIImage(radialGradient: [UIColor.red.cgColor, UIColor.clear.cgColor],
//                                  size: CGSize(width: 60, height: 60),
//                                  startCenter: CGPoint(x: 0.5, y: 0.5),
//                                  startRaidus: 0,
//                                  endCenter: CGPoint(x: 0.5, y: 0.5),
//                                  endRaidus: 60,
//                                  options: .drawsAfterEndLocation)
//        imageView.layer.cornerRadius = 30
//        imageView.layer.masksToBounds = true

//        if Bundle.main.path(forResource: "douYin", ofType: "mp4") != nil {
//            let path = "http://129.204.89.248:9301/busvod/观光1路/1.mp4"
//            if let url = URL(string: path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
//                let img = UIImage(fromVideoURL: url, size: CGSize(width: 100, height: 100), isFirstFrame: false)
//                imageView.image = img
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
//            let alertView = UIView()
//                   let size = CGSize(width: 80, height: 600)
//            alertView.backgroundColor = .green
//            alertView.wm.alert(true, containerSize: size)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//                let star = WQStarViewController()
//                star.view.backgroundColor = .white
//                self.navigationController?.pushViewController(star, animated: true)
//            }
//
////               DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
////                    alertView.wm.dismiss(true)
////                }
//        }
    }

    @objc func alertAction(_ sender: UIButton) {

        let alertView = UIView()

//        let subView = UIView()
//        alertView.addSubview(subView)
////        subView.snp.makeConstraints { make in
//////            make.edges.equalToSuperview()
////            make.left.equalToSuperview().offset(25)
////            make.right.equalToSuperview().offset(-25)
////            make.top.bottom.equalToSuperview()
////        }
//        let size = CGSize(width: 200, height: 200)
//        alertView.backgroundColor = UIColor.red
//        let presentedFrame = UIScreen.main.bounds
//        let dismiss = CGRect(x: (presentedFrame.width - size.width) * 0.5, y: presentedFrame.height * 0.5, width: size.width, height: 0)
//
//        let show = CGRect(x: (presentedFrame.width - size.width) * 0.5, y: (presentedFrame.height - size.height) * 0.5, width: size.width, height: size.height)
//
//        let items = Array(default: WQAnimatedItem(containerFrame: dismiss, show: show, dismiss: dismiss), viewFrame: presentedFrame)
//        let animator = WQTransitionAnimator(items: items)
        let alertSubView = UIView()
        alertSubView.backgroundColor = UIColor.blue
//        alertView.addSubview(alertSubView)
        alertSubView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 700)
        let config = ModalConfig(.modalInParent(self))
        
        config.interactionDismiss = .tapOutSide
//        self.definesPresentationContext
//        alertSubView.alert(true, config: config)
        let postions = PanPosition.bottomToCenter(true)
        let style = StyleConfig(.pan(postions), anmation: .default)
        
//        alertSubView.present(config, states: style)
        alertSubView.wm.actionSheet(true, config: config)
//        let presention = WQTransitionable(subView: alertView, animator: animator, presentedFrame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
////        presention.show(animated: true, in: nil, completion: nil)
//        presention.interactionDismissDirection = .down
//         presention.tapDimmingViewDismissable = true
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//
//            alertView.wm.dismiss(true)
//        }
    }

    func show() {
//        let size = CGSize(width: 300, height: 100)
//         alertView.backgroundColor = UIColor.green
//         let presentedFrame = UIScreen.main.bounds
//         let dismiss = CGRect(x: (presentedFrame.width - size.width) * 0.5,
//                              y: presentedFrame.height * 0.5, width: size.width, height: 0)
//
//         let show = CGRect(x: (presentedFrame.width - size.width) * 0.5, y: (presentedFrame.height - size.height) * 0.5, width: size.width, height: size.height)
//
//         let items = Array(default: WQAnimatedItem(containerFrame: dismiss, show: show, dismiss: dismiss), viewFrame: presentedFrame)
//         let animator = WQTransitionAnimator(items: items)
//         let alertSubView = UIView()
//         alertSubView.backgroundColor = UIColor.blue
//         alertView.addSubview(alertSubView)
//         alertSubView.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
//         let presention = WQTransitionable(subView: alertView, animator: animator, presentedFrame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
////         presention.show(animated: true, in: nil, completion: nil)
//         presention.interactionDismissDirection = .down
//          presention.tapDimmingViewDismissable = true
//        let nav = UINavigationController(rootViewController: presention)
//        nav.view.backgroundColor = .clear
//        nav.transitioningDelegate = presention
//        nav.modalPresentationStyle = .custom
//        self.present(nav, animated: true, completion: nil)
    }
}
