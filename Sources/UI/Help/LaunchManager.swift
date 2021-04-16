//
//  ShowWindowManager.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/4/15.
//

import Foundation
import UIKit
open class ShowWindowController: UIViewController {
//    -(BOOL)shouldAutorotate{
//
//        return NO;
//    }
//
//    -(BOOL)prefersHomeIndicatorAutoHidden{
//
//        return XHLaunchAdPrefersHomeIndicatorAutoHidden;
//    }

}
open class LaunchManager: NSObject {
    var window: UIWindow?
//    -(UIImage *)imageFromLaunchScreen{
//        NSString *UILaunchStoryboardName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
//        if(UILaunchStoryboardName == nil){
//            XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
//            return nil;
//        }
//        UIViewController *LaunchScreenSb = [[UIStoryboard storyboardWithName:UILaunchStoryboardName bundle:nil] instantiateInitialViewController];
//        if(LaunchScreenSb){
//            UIView * view = LaunchScreenSb.view;
//            // 加入到UIWindow后，LaunchScreenSb.view的safeAreaInsets在刘海屏机型才正常。
//            UIWindow *containerWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//            view.frame = containerWindow.bounds;
//            [containerWindow addSubview:view];
//            [containerWindow layoutIfNeeded];
//            UIImage *image = [self imageFromView:view];
//            containerWindow = nil;
//            return image;
//        }
//        XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
//        return nil;
//    }

    func setup() {
          
//        removeOnly()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ShowWindowController()
        window?.rootViewController?.view.backgroundColor = .clear
        window?.rootViewController?.view.isUserInteractionEnabled = false
        window?.windowLevel = UIWindow.Level.statusBar + 1
        window?.isHidden = false
        window?.alpha = 1
//        window?.addSubview(<#T##view: UIView##UIView#>)
        
//        window = UIWindow(frame: UIScreen.mainScreen.bounds)
    }
//    -(void)setupLaunchAd{
//        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        window.rootViewController = [XHLaunchAdController new];
//        window.rootViewController.view.backgroundColor = [UIColor clearColor];
//        window.rootViewController.view.userInteractionEnabled = NO;
//        window.windowLevel = UIWindowLevelStatusBar + 1;
//        window.hidden = NO;
//        window.alpha = 1;
//        _window = window;
//        /** 添加launchImageView */
//        [_window addSubview:[[XHLaunchImageView alloc] initWithSourceType:_sourceType]];
//    }
//
//    -(void)removeAndAnimated:(BOOL)animated{
//        if(animated){
//            [self removeAndAnimate];
//        }else{
//            [self remove];
//        }
//    }
//    func removeOnly() {
//
//        if(_window){
//            [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                REMOVE_FROM_SUPERVIEW_SAFE(obj)
//            }];
//            _window.hidden = YES;
//            _window = nil;
//        }
//    }
//    -(void)remove{
//        [self removeOnly];
//    #pragma clang diagnostic push
//    #pragma clang diagnostic ignored"-Wdeprecated-declarations"
//        if ([self.delegate respondsToSelector:@selector(xhLaunchShowFinish:)]) {
//            [self.delegate xhLaunchShowFinish:self];
//        }
//    #pragma clang diagnostic pop
//        if ([self.delegate respondsToSelector:@selector(xhLaunchAdShowFinish:)]) {
//            [self.delegate xhLaunchAdShowFinish:self];
//        }
//    }
//    -(void)removeAndAnimateDefault{
//        XHLaunchAdConfiguration * configuration = [self commonConfiguration];
//        CGFloat duration = showFinishAnimateTimeDefault;
//        if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
//        [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionNone animations:^{
//            _window.alpha = 0;
//        } completion:^(BOOL finished) {
//            [self remove];
//        }];
//    }
//
//    -(void)removeAndAnimate{
//
//        XHLaunchAdConfiguration * configuration = [self commonConfiguration];
//        CGFloat duration = showFinishAnimateTimeDefault;
//        if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
//        switch (configuration.showFinishAnimate) {
//            case ShowFinishAnimateNone:{
//                [self remove];
//            }
//                break;
//            case ShowFinishAnimateFadein:{
//                [self removeAndAnimateDefault];
//            }
//                break;
//            case ShowFinishAnimateLite:{
//                [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
//                    _window.transform = CGAffineTransformMakeScale(1.5, 1.5);
//                    _window.alpha = 0;
//                } completion:^(BOOL finished) {
//                    [self remove];
//                }];
//            }
//                break;
//            case ShowFinishAnimateFlipFromLeft:{
//                [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//                    _window.alpha = 0;
//                } completion:^(BOOL finished) {
//                    [self remove];
//                }];
//            }
//                break;
//            case ShowFinishAnimateFlipFromBottom:{
//                [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//                    _window.alpha = 0;
//                } completion:^(BOOL finished) {
//                    [self remove];
//                }];
//            }
//                break;
//            case ShowFinishAnimateCurlUp:{
//                [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionCurlUp animations:^{
//                    _window.alpha = 0;
//                } completion:^(BOOL finished) {
//                    [self remove];
//                }];
//            }
//                break;
//            default:{
//                [self removeAndAnimateDefault];
//            }
//                break;
//        }
//    }

}
