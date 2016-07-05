//
//  LMVideoView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMVideoView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "LMPlayViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LMVideoViewController.h"
#import "LMNavigationController.h"

@interface LMVideoView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *playcountLabel;
@property (strong, nonatomic) UILabel *videotimeLabel;
//播放按钮
@property (strong, nonatomic) UIButton *playButton;

@end

@implementation LMVideoView

+ (LMVideoView *)videoView {
    LMVideoView *videoView = [[LMVideoView alloc]init];
    [videoView addAllChildViews];
    return videoView;
}

- (void)addAllChildViews {
    UIImageView *imageView = [[UIImageView alloc]init];
    self.imageView = imageView;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self).offset(0);
    }];
    
    UILabel *playcountLabel = [[UILabel alloc]init];
    self.playcountLabel = playcountLabel;
    playcountLabel.font = [UIFont systemFontOfSize:14];
    playcountLabel.textColor = [UIColor whiteColor];
    [self addSubview:playcountLabel];
    [playcountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_right);
        make.top.equalTo(imageView.mas_top);
    }];
    
    UILabel *videotimeLabel = [[UILabel alloc]init];
    self.videotimeLabel = videotimeLabel;
    videotimeLabel.font = [UIFont systemFontOfSize:14];
    videotimeLabel.textColor = [UIColor whiteColor];
    [self addSubview:videotimeLabel];
    [videotimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom);
        make.right.equalTo(imageView.mas_right);
    }];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [self addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@70);
    }];
    
}

- (void)setVideoModal:(LMVideoModal *)videoModal {
    _videoModal = videoModal;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:videoModal.large_image]];
    
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%ld播放", videoModal.playcount];
    
    // 时长
    NSInteger minute = videoModal.videotime / 60;
    NSInteger second = videoModal.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
}

- (void)playButtonClick {
    //系统视频视图控制器
//    AVPlayer * player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoModal.videouri]];
//    AVPlayerViewController * playerViewConteller = [[AVPlayerViewController alloc] init];
//    playerViewConteller.player = player;
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerViewConteller animated:NO completion:^{
//        [player play];
//    }];
    //自定义视图控制器
    LMPlayViewController *playVC = [[LMPlayViewController alloc] init];
    playVC.videoModal = self.videoModal;
    LMNavigationController *videoViewController = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[2];
    videoViewController.navigationBarHidden = YES;
    [videoViewController.tabBarController.tabBar setHidden:YES];
    [videoViewController pushViewController:playVC animated:NO];
}

@end
