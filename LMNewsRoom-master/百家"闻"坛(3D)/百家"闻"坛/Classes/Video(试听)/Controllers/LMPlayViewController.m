//
//  LMPlayViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/19.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPlayViewController.h"
#import "LMProgressView.h"
#import "Masonry.h"
#import "LMVideoPlayView.h"
#import "LMVideoViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface LMPlayViewController ()
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIButton *reweetButton;
@property (strong, nonatomic) LMProgressView *progressView;

/**  video */
@property (nonatomic, weak) LMVideoPlayView *videoView;

@end

@implementation LMPlayViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setUpAllChildViews];
    }
    return self;
}

- (void)setUpAllChildViews {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"show_image_back_icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = backButton;
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(40);
        make.width.height.equalTo(@35);
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor lightGrayColor];
    self.saveButton = saveButton;
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-40);
        make.height.equalTo(@35);
        make.width.equalTo(@70);
    }];
    
    UIButton *reweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reweetButton setTitle:@"转发" forState:UIControlStateNormal];
    [reweetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reweetButton.backgroundColor = [UIColor lightGrayColor];
    self.reweetButton = reweetButton;
    [self.view addSubview:reweetButton];
    [reweetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(saveButton.mas_left).offset(-20);
        make.bottom.equalTo(self.view).offset(-40);
        make.height.equalTo(@35);
        make.width.equalTo(@70);
    }];
    
    LMVideoPlayView *videoView = [[LMVideoPlayView alloc]init];
    self.videoView = videoView;
    [self.view addSubview:videoView];
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(self.view.width));
        make.height.equalTo(@(self.view.width*9/16));
    }];
}

- (void)setVideoModal:(LMVideoModal *)videoModal {
    _videoModal = videoModal;
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.videoModal.videouri]];
    self.videoView.playerItem = item;

}

- (void)backButtonClick {
    //竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;//
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];

    }
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];

}


@end
