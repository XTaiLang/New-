//
//  LMOriginalView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMOriginalView.h"
#import "LMStatus.h"
#import "UIImageView+WebCache.h"


@interface LMOriginalView ()

/**
 *  头像
 */
@property (nonatomic ,weak) UIImageView *iconView;
/**
 *  昵称
 */
@property (nonatomic ,weak) UILabel *nameLabel;
/**
 *  vip
 */
@property (nonatomic ,weak) UIImageView *vipImageView;
/**
 *  时间
 */
@property (nonatomic ,weak) UILabel *timeLabel;
/**
 *  来源
 */
@property (nonatomic ,weak) UILabel *sourceLabel;
/**
 *  正文
 */
@property (nonatomic ,weak) UILabel *textLabel;


@end

@implementation LMOriginalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加所有子控件
        [self setUpAllChildView];
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"timeline_card_top_background"];
    }
    return self;
}

- (void)setUpAllChildView {
    //添加头像
    UIImageView *iconView = [[UIImageView alloc]init];
    [self addSubview:iconView];
    _iconView = iconView;
    //昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = LMNameFont;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    //vip
    UIImageView *vipImageView = [[UIImageView alloc]init];
    [self addSubview:vipImageView];
    _vipImageView = vipImageView;
    //时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = LMTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    //来源
    UILabel *sourceLabel = [[UILabel alloc]init];
    sourceLabel.font = LMSourceFont;
    [self addSubview:sourceLabel];
    _sourceLabel = sourceLabel;
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
    //设置frame
    [self setUpFrame];
    //设置data
    [self setUpData];
    
}

- (void)setUpData {
    LMStatus *status = _statusFrame.status;
    //头像
    [_iconView sd_setImageWithURL:status.user.profile_image_url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //昵称
    if (status.user.vip) {
        _nameLabel.textColor = [UIColor redColor];
    }else {
        _nameLabel.textColor = [UIColor blackColor];
    }
    _nameLabel.text = status.user.name;
    //vip
    NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%d",status.user.mbrank];
    _vipImageView.image = [UIImage imageNamed:imageName];
    //时间
    _timeLabel.text = status.created_at;
    //来源
    _sourceLabel.text = status.source;
    //正文
    _textLabel.text = status.text;
    //配图
    _photoView.photos = status.pic_urls;
}

- (void)setUpFrame {
    
    LMStatus *status = _statusFrame.status;
    //头像
    _iconView.frame = _statusFrame.originalIconFrame;
    //昵称
    _nameLabel.frame = _statusFrame.originalNameFrame;
    //vip
    if (_statusFrame.status.user.vip) {//是vip
        _vipImageView.hidden = NO;
        _vipImageView.frame = _statusFrame.originalVipFrame;
    }else {
        _vipImageView.hidden = YES;
    }
    //时间(每次有新的时间都要重新计算frame)
    
    CGFloat timeX = _nameLabel.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameLabel.frame) + LMStatusCellMargin * 0.5;
    CGSize timeSize = [status.created_at sizeWithFont:LMTimeFont];
    //结构体强转赋值
    _timeLabel.frame = (CGRect){{timeX,timeY},timeSize};

    //来源
    CGFloat sourceX = CGRectGetMaxX(_timeLabel.frame) + LMStatusCellMargin;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:LMSourceFont];
    _sourceLabel.frame = (CGRect){{sourceX,sourceY},sourceSize};
    
    //正文
    _textLabel.frame = _statusFrame.originalTextFrame;
    
    //配图
    _photoView.frame = _statusFrame.originalPhotosFrame;
}

@end
