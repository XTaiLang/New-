//
//  LMVideoPlayView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/19.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMVideoPlayView.h"
#import "Masonry.h"

@interface LMVideoPlayView ()

/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;

// 播放器的Layer
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *toolView;
@property (strong, nonatomic) UIButton *playOrPauseBtn;
@property (strong, nonatomic) UISlider *progressSlider;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *fullScreenButton;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;
//全屏
@property(nonatomic, assign) BOOL isFullScreen;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation LMVideoPlayView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setUpAllChildViews];
    }
    return self;
}

- (void)setUpAllChildViews {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    self.tap = tap;
    [self addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    self.imageView = imageView;
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.image = [UIImage imageNamed:@"imageBackground"];
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    UIView *toolView = [[UIView alloc]init];
    self.toolView = toolView;
    toolView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self).offset(0);
        make.height.equalTo(@50);
    }];
    self.toolView.alpha = 0;
    self.isShowToolView = NO;
    
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn = playOrPauseBtn;
    [playOrPauseBtn setImage:[UIImage imageNamed:@"full_play_btn_hl"] forState:UIControlStateNormal];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"full_pause_btn_hl"] forState:UIControlStateSelected];
    [playOrPauseBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:playOrPauseBtn];
    [playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(toolView).offset(0);
        make.width.equalTo(@50);
    }];
    self.playOrPauseBtn.selected = YES;

    UIButton *fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullScreenButton setImage:[UIImage imageNamed:@"full_minimize_btn_hl"] forState:UIControlStateNormal];
    [fullScreenButton setImage:[UIImage imageNamed:@"mini_launchFullScreen_btn_hl"] forState:UIControlStateSelected];
    self.fullScreenButton = fullScreenButton;
    [fullScreenButton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    fullScreenButton.contentMode = UIViewContentModeScaleToFill;
    [toolView addSubview:self.fullScreenButton];
    [fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(toolView).offset(0);
        make.width.equalTo(@50);
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    [toolView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fullScreenButton.mas_left).offset(0);
        make.top.bottom.equalTo(toolView).offset(0);
        make.width.equalTo(@110);
    }];
    
    UISlider *progressSlider = [[UISlider alloc]init];
    [progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    self.progressSlider = progressSlider;
    [toolView addSubview:progressSlider];
    [progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playOrPauseBtn.mas_right);
        make.top.bottom.equalTo(toolView).offset(0);
        make.right.equalTo(timeLabel.mas_left).offset(0);
    }];
    
    [self removeProgressTimer];
    [self addProgressTimer];
}
//点击屏幕时弹出工具栏
- (void)tapScreen:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0;
            self.isShowToolView = NO;
        } else {
            self.toolView.alpha = 1;
            self.isShowToolView = YES;
        }
    }];
}
//播放按钮点击时调用
- (void)playButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        [self addProgressTimer];
    } else {
        [self.player pause];
        [self removeProgressTimer];
    }
}

// 切换屏幕的方向
- (void) fullScreenButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
//    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
//        [self.delegate videoplayViewSwitchOrientation:sender.selected];
//    }
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;//
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }else{
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;//
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

#define mark - 定时器相关方法
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo {
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}

- (NSString *)timeString {
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 设置播放的视频
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.playerLayer.frame = self.bounds;
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        self.isFullScreen = YES;
        [self initLandscape];
    }else{
        self.isFullScreen = NO;
        [self initPortraint];
    }
}

//initLandscape与initPortraint里面一样


-(void)initLandscape{//横屏
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.superview).offset(0);
    }];
    
}
//
-(void)initPortraint{//竖屏
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.superview.mas_centerX);
        make.centerY.equalTo(self.superview.mas_centerY);
        make.width.equalTo(@(self.superview.width));
        make.height.equalTo(@(self.superview.width*9/16));
    }];
}

@end
