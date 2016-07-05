//
//  LMBaseViewController.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMBaseViewController : UIViewController

/**
 *  设置导航条
 *
 *  @param show 是否显示右上角分享按钮
 */
- (void)setUpNavigationBar:(BOOL)show;
//隐藏返回按钮的title
- (void)hideBackButtonTitle;
//设置tabBarItem
- (void)setUpTabBarItemWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title;
//分享模块
- (void)share;

- (void)showHUDWaitingWhileExecuting:(SEL)method;

- (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)delay;

- (void)showHUDDone;

- (void)showHUDDoneWithText:(NSString *)text;

- (void)showHUDErrorWithText:(NSString *)text;

- (void)showHUDNetError;

- (void)showHUDServerError;

- (void)showWithLabelText:(NSString *)showText executing:(SEL)method;

- (void)showHUDWithText:(NSString *)text;

/**
 *  隐藏当前显示的提示框
 */
- (void)hideHud;

@property (nonatomic, copy) void (^hudWasHidden)(void);

@end
