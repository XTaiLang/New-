//
//  LMRetweetView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMRetweetView.h"
#import "UIImage+Image.h"
#import "LMPhotosView.h"

@interface LMRetweetView ()

/**
 *  昵称
 */
@property (nonatomic ,weak) UILabel *nameLabel;
/**
 *  正文
 */
@property (nonatomic ,weak) UILabel *textLabel;
/**
 *  配图相册
 */
@property (nonatomic,weak) LMPhotosView *photoView;

@end

@implementation LMRetweetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image= [UIImage imageNamed:@"timeline_retweet_background"];
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

- (void)setUpAllChildView {
    //昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = LMNameFont;
    nameLabel.textColor = [UIColor blueColor];
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    //正文
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.font = LMTextFont;
    textLabel.numberOfLines = 0;
    [self addSubview:textLabel];
    _textLabel = textLabel;
    
    //配图相册
    LMPhotosView *photosView = [[LMPhotosView alloc]init];
    [self addSubview:photosView];
    _photoView = photosView;
}

- (void)setStatusFrame:(LMStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    LMStatus *status = statusFrame.status;
    //昵称
    _nameLabel.frame = statusFrame.retweetNameFrame;
    _nameLabel.text = statusFrame.status.retweetName;
    //正文
    _textLabel.frame = statusFrame.retweetTextFrame;
    _textLabel.text = status.retweeted_status.text;
    //配图
    _photoView.frame = statusFrame.retweetPhotosFrame;
    _photoView.photos = status.retweeted_status.pic_urls;
    
}

@end
