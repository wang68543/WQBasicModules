//
//  LaunchImage.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/4/15.
//

import Foundation
import UIKit

open class LaunchImage: NSObject {
    
    /// Launch Asset Image
    open var launchImages: UIImage? {
        guard let images = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else {
            return nil
        }
        for dict in images {
            if let imgName = dict["UILaunchImageName"] as? String,
               let imgSizeStr = dict["UILaunchImageSize"] as? String {
                let imgSize = NSCoder.cgSize(for: imgSizeStr)
                    if UIScreen.main.bounds.size == imgSize {
                        return UIImage(named: imgName)
                    }
            }
        }
        return nil
    }
    open var launchScreenImage: UIImage? {
        guard let launchStoryboardName = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String else { return nil }
        guard let launchViewController = UIStoryboard(name: launchStoryboardName, bundle: nil).instantiateInitialViewController(),
              let view = launchViewController.view else { return nil }
        // 加入到UIWindow后，LaunchScreenSb.view的safeAreaInsets在刘海屏机型才正常。
        let containerWindow = UIWindow(frame: UIScreen.main.bounds)
        view.frame = containerWindow.bounds
        containerWindow.addSubview(view)
        containerWindow.layoutIfNeeded()
       return containerWindow.snapshot() 
    }
    
}
//#pragma mark - private
//- (instancetype)initWithSourceType:(SourceType)sourceType{
//    self = [super init];
//    if (self) {
//        self.frame = [UIScreen mainScreen].bounds;
//        self.userInteractionEnabled = YES;
//        self.backgroundColor = [UIColor whiteColor];
//        switch (sourceType) {
//            case SourceTypeLaunchImage:{
//                self.image = [self imageFromLaunchImage];
//            }
//                break;
//            case SourceTypeLaunchScreen:{
//                self.image = [self imageFromLaunchScreen];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    return self;
//}
//
//-(UIImage *)imageFromLaunchImage{
//    UIImage *imageP = [self launchImageWithType:@"Portrait"];
//    if(imageP) return imageP;
//    UIImage *imageL = [self launchImageWithType:@"Landscape"];
//    if(imageL)  return imageL;
//    XHLaunchAdLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
//    return nil;
//}
 
//
//
//-(UIImage *)launchImageWithType:(NSString *)type{
//    //比对分辨率,获取启动图 fix #158:https://github.com/CoderZhuXH/XHLaunchAd/issues/158
//    CGFloat screenScale = [UIScreen mainScreen].scale;
//    CGSize screenDipSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * screenScale, [UIScreen mainScreen].bounds.size.height * screenScale);
//    NSString *viewOrientation = type;
//    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//    for (NSDictionary* dict in imagesDict){
//        UIImage *image = [UIImage imageNamed:dict[@"UILaunchImageName"]];
//        CGSize imageDpiSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
//        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
//            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]){
//                imageDpiSize = CGSizeMake(imageDpiSize.height, imageDpiSize.width);
//            }
//            if(CGSizeEqualToSize(screenDipSize, imageDpiSize)){
//                return image;
//            }
//        }
//    }
//    return nil;
//}

