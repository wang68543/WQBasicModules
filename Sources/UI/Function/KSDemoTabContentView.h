//
//  KSDemoTabContentView.h
//  KSAdSDKGitDemo
//
//  Created by zangmina on 2020/1/21.
//  Copyright © 2020 xuzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TabSwitchBlcok) (NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface KSDemoTabContentView : UIView

/**
 page
 */
@property (nonatomic, strong) UIPageViewController *pageController;

/**
 内容页数组
 */
@property (nonatomic, strong) NSArray<UIViewController *> *controllers;
/**
 内容页数组
 */
@property (nonatomic, strong) TabSwitchBlcok tabSwitch;

-(void)updateTab:(NSInteger) index;

-(void)configParam:(NSMutableArray<UIViewController*>*) controllers Index:(NSInteger) index block:(TabSwitchBlcok)  tabSwitch;

@end

NS_ASSUME_NONNULL_END
