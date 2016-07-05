//
//  LMStatusToolBar.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMStatusToolBar.h"

@interface LMStatusToolBar ()

@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *divs;

@property (nonatomic,strong) UIButton *retweetButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIButton *unlikeButton;

@end

@implementation LMStatusToolBar

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)divs {
    if (!_divs) {
        _divs = [NSMutableArray array];
    }
    return _divs;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加所有子控件
        [self setUpAllChildView];
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"timeline_card_bottom_background"];
    }
    return self;
}

- (void)setUpAllChildView {
    //转发
    self.retweetButton = [self setUpOneButtonWithTitle:@"转发" image:[UIImage imageNamed:@"timeline_icon_retweet"]];
    //评论
    self.commentButton = [self setUpOneButtonWithTitle:@"评论" image:[UIImage imageNamed:@"timeline_icon_comment"]];
    //赞
    self.unlikeButton = [self setUpOneButtonWithTitle:@"赞" image:[UIImage imageNamed:@"timeline_icon_unlike"]];
    for (int i = 0; i < 2; i++) {
        UIImageView *divideView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
        [self.divs addObject:divideView];
        [self addSubview:divideView];
    }
}

- (UIButton *)setUpOneButtonWithTitle:(NSString *)title image:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = LMNameFont;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:button];
    [self.buttons addObject:button];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = self.buttons.count;
    //设置按钮的frame
    CGFloat w = LMScreenW / count;
    CGFloat h = self.height;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i < count; i++) {
        UIButton *button = self.buttons[i];
        x =  i * w;
        button.frame = CGRectMake( x, y, w, h);
    }
    int i = 1;
    for (UIImageView *div in self.divs) {
        UIButton *button = self.buttons[i];
        div.x = button.x;
        i++;
    }
    
}

- (void)setUpButton:(UIButton *)button title:(int)count {

    NSString *title = nil;
    if (count) {
        if (count >= 10000) {
            CGFloat floatCount = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",floatCount];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }else {
            title = [NSString stringWithFormat:@"%d",count];
        }
        
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setStatus:(LMStatus *)status {
    _status = status;
    
    [self setUpButton:_retweetButton title:status.reposts_count];
    [self setUpButton:_commentButton title:status.comments_count];
    [self setUpButton:_unlikeButton title:status.attitudes_count];

}

@end
