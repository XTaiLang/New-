//
//  LMPhotoView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPhotoView.h"
#import "UIImageView+WebCache.h"

@interface LMPhotoView ()

@property (nonatomic,strong) UIImageView *gifView;

@end

@implementation LMPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        //剪裁图片，超出控件部分
        self.clipsToBounds = YES;
        
        UIImageView *gifView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    return self;
}

- (void)setPhoto:(LMPhoto *)photo {
    _photo = photo;
    //设置图片
    [self sd_setImageWithURL:photo.thumbnail_pic placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //判断是不是.gif
    NSString *urlStr = photo.thumbnail_pic.absoluteString;
    if ([urlStr hasSuffix:@".gif"]) {
        self.gifView.hidden = NO;
    }else {
        self.gifView.hidden = YES;
    }
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
    
}

@end
