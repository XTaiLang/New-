//
//  LMBaseViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMBaseViewController.h"
#import "MBProgressHUD.h"

@interface LMBaseViewController ()<MBProgressHUDDelegate>

@end

@implementation LMBaseViewController{
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUpNavigationBar:(BOOL)show {
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 23)];
    titleImageView.image = [UIImage imageNamed:@"yige"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = titleImageView;
    
    if (show) {
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        [shareButton setImage:[UIImage imageNamed:@"nav_share_btn_normal"] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:@"nav_share_btn_highlighted"] forState:UIControlStateHighlighted];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    }
}

- (void)hideBackButtonTitle {
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)setUpTabBarItemWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    self.tabBarItem.title = title;
    self.tabBarItem.image = normalImage;
    self.tabBarItem.selectedImage = selectedImage;

}

- (void)share {

}

#pragma mark - MBProgressHUD

- (void)showHUDWaitingWhileExecuting:(SEL)method {
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.color = [UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:0.9];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:method onTarget:self withObject:nil animated:YES];
}

- (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)delay {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = text;
    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    [HUD hide:YES afterDelay:delay];
}

- (void)showHUDDone {
    [self showHUDDoneWithText:@"Done"];
}

- (void)showHUDDoneWithText:(NSString *)text {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_right"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    [HUD show:YES];
    [HUD hide:YES afterDelay:HUD_DELAY];
}

- (void)showHUDErrorWithText:(NSString *)text {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    [HUD show:YES];
    [HUD hide:YES afterDelay:HUD_DELAY];
}

- (void)showHUDNetError {
    [self showHUDErrorWithText:BadNetwork];
}

- (void)showHUDServerError {
    [self showHUDErrorWithText:@"Server Error"];
}

- (void)showWithLabelText:(NSString *)showText executing:(SEL)method {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = showText;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    [HUD showWhileExecuting:method onTarget:self withObject:nil animated:YES];
}

- (void)showHUDWithText:(NSString *)text {
    [self hideHud];
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = text;
    HUD.margin = 10.f;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    HUD.removeFromSuperViewOnHide = YES;
}

- (void)processServerErrorWithCode:(NSInteger)code andErrorMsg:(NSString *)msg {
    if (code == 500) {
        [self showHUDServerError];
    } else {
        [self showHUDDoneWithText:msg];
    }
}

- (void)hideHud {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (self.hudWasHidden) {
        self.hudWasHidden();
    }
}

@end
