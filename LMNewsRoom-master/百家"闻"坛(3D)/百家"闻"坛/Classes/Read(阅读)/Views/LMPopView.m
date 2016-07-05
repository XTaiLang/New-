//
//  LMPopView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/22.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPopView.h"

#define LMMarginX 5
#define LMMarginY 13
@interface LMPopView()

@property (nonatomic, weak) UIImageView *containView;

@end

@implementation LMPopView

- (UIImageView *)containView
{
    if (_containView == nil) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"popover_background"];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        _containView = imageView;
    }
    return _containView;
}

+ (instancetype)popView
{
    LMPopView *popView = [[LMPopView alloc] initWithFrame:LMKeyWindow.bounds];
    
    return popView;
}

- (void)showInRect:(CGRect)rect
{
    self.containView.frame = rect;
    
    [LMKeyWindow addSubview:self];
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    [self.containView addSubview:_contentView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = LMMarginX;
    CGFloat y = LMMarginY;
    CGFloat w = _containView.width - LMMarginX * 2;
    CGFloat h = _containView.height - LMMarginY * 2;
    
    _contentView.frame = CGRectMake(x, y, w, h);
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
        [_delegate popViewDidDismiss:self];
    }
    
}


@end
