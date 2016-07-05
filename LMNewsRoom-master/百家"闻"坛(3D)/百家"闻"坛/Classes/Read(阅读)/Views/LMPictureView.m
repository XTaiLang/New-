//
//  LMPictureView.m
//  onlyOne
//
//  Created by tarena on 16/2/15.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPictureView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "LMBaseFun.h"

#define PaintInfoTextColor [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1] // #555555
#define DayTextColor [UIColor colorWithRed:55 / 255.0 green:194 / 255.0 blue:241 / 255.0 alpha:1] // #37C2F1
#define MonthAndYearTextColor [UIColor colorWithRed:173 / 255.0 green:173 / 255.0 blue:173 / 255.0 alpha:1] // #ADADAD

@interface LMPictureView ()

@property (nonatomic,strong) UIScrollView *homeScrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic,strong) UILabel *volLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *authorLabel;
@property (nonatomic,strong) UILabel *dayLabel;
@property (nonatomic,strong) UILabel *monthAndYearLabel;
@property (nonatomic,strong) UIImageView *contentBackImageView;
@property (nonatomic,strong) UITextView *contentView;
@property (nonatomic,strong) UIButton *likeButton;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;// item 加载中转转的菊花

@end

@implementation LMPictureView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpAllChildViews];
    }
    return self;
}

- (void)startRefreshing {
    self.indicatorView.center = self.center;
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.indicatorView startAnimating];
}

- (void)setUpHomeViewWithHomeModal:(LMPictureModal *)pictureModal animated:(BOOL)animate {
    self.volLabel.text = pictureModal.strHpTitle;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:pictureModal.strThumbnailUrl] completed:nil];
    self.titleLabel.text = [pictureModal.strAuthor componentsSeparatedByString:@"&"][0];
    self.authorLabel.text = [pictureModal.strAuthor componentsSeparatedByString:@"&"][1];
    NSString *marketTime = [LMBaseFun homeENMarketTimeWithOriginalMarketTime:pictureModal.strMarketTime];
    self.dayLabel.text = [marketTime componentsSeparatedByString:@"&"][0];
    self.monthAndYearLabel.text = [marketTime componentsSeparatedByString:@"&"][1];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attribute = @{NSParagraphStyleAttributeName : paragraphStyle,
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSFontAttributeName : [UIFont systemFontOfSize:13]};
    self.contentView.attributedText = [[NSAttributedString alloc] initWithString:pictureModal.strContent attributes:attribute];
    [self.contentView sizeToFit];
    
    self.contentBackImageView.image = [[UIImage imageNamed:@"contBack"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"  %@", pictureModal.strPn] forState:UIControlStateNormal];
    [self.likeButton sizeToFit];
    
    self.homeScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.containerView.frame));
}

- (void)refreshSubviewsForNewItem {
    self.volLabel.text = @"";
    //	self.paintImageView.image = nil;
    self.titleLabel.text = @"";
    self.authorLabel.text = @"";
    self.dayLabel.text = @"";
    self.monthAndYearLabel.text = @"";
    
    self.contentView.text = @"";
    [self.contentView sizeToFit];
    
    self.contentBackImageView.image = nil;
    
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    [self.likeButton sizeToFit];
    
    self.containerView.hidden = YES;
    self.homeScrollView.scrollsToTop = NO;
    
    [self startRefreshing];
}


- (void)setUpAllChildViews {
    
    //添加滚动视图
    UIScrollView *homeScrollView = [UIScrollView new];
    homeScrollView.showsVerticalScrollIndicator = NO;
    homeScrollView.showsHorizontalScrollIndicator = NO;
    homeScrollView.alwaysBounceVertical = YES;
    homeScrollView.scrollsToTop = YES;
    self.homeScrollView = homeScrollView;
    [self addSubview:self.homeScrollView];
    [self.homeScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // 初始化容器视图
    self.containerView = [UIView new];
    [self.homeScrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.homeScrollView);
        make.width.equalTo(self.homeScrollView);
    }];
    
    //初始化VOL
    UILabel *volLabel = [UILabel new];
    volLabel.font = systemFont(13);
    volLabel.textColor = VOLTextColor;
    self.volLabel = volLabel;
    [self.containerView addSubview:self.volLabel];
    [self.volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.top.equalTo(self.containerView.mas_top).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
        make.height.mas_equalTo(@16);
    }];
    
    //初始化图片视图
    UIImageView *imageView = [[UIImageView alloc]init];
    self.imageView = imageView;
    [self.containerView addSubview:self.imageView];
    CGFloat imageWidth = SCREEN_WIDTH - 20;
    CGFloat imageHeight = imageWidth * 0.75;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.volLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
        make.height.mas_equalTo(@(imageHeight));
    }];
    
    // 初始化画名文字控件
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = PaintInfoTextColor;
    self.titleLabel.font = systemFont(12);
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(10);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
    }];
    
    // 初始化画作者
    self.authorLabel = [UILabel new];
    self.authorLabel.textColor = PaintInfoTextColor;
    self.authorLabel.font = systemFont(12);
    self.authorLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
    }];
    
    // 初始化日文字控件
    self.dayLabel = [UILabel new];
    self.dayLabel.textColor = DayTextColor;
    self.dayLabel.backgroundColor = [UIColor whiteColor];
    self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:43];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.shadowOffset = CGSizeMake(1, 1);
    self.dayLabel.shadowColor = [UIColor whiteColor];
    [self.containerView addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@40);
    }];
    
    // 初始化月和年文字控件
    self.monthAndYearLabel = [UILabel new];
    self.monthAndYearLabel.textColor = MonthAndYearTextColor;
    self.monthAndYearLabel.backgroundColor = [UIColor whiteColor];
    self.monthAndYearLabel.font = [UIFont boldSystemFontOfSize:10];
    self.monthAndYearLabel.textAlignment = NSTextAlignmentCenter;
    self.monthAndYearLabel.shadowOffset = CGSizeMake(1, 1);
    self.monthAndYearLabel.shadowColor = [UIColor whiteColor];
    [self.containerView addSubview:self.monthAndYearLabel];
    [self.monthAndYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@12);
    }];
    
    // 初始化内容背景图片控件
    self.contentBackImageView = [UIImageView new];
    [self.containerView addSubview:self.contentBackImageView];
    [self.contentBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.dayLabel.mas_right).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
    }];
    
    // 初始化内容控件
    self.contentView = [UITextView new];
    self.contentView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    self.contentView.editable = NO;
    self.contentView.scrollEnabled = NO;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentBackImageView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentBackImageView.mas_left).with.offset(6);
        make.top.equalTo(self.contentBackImageView.mas_top).with.offset(0);
        make.right.equalTo(self.contentBackImageView.mas_right).with.offset(-6);
        make.bottom.equalTo(self.contentBackImageView.mas_bottom).with.offset(0);
    }];
    
    // 初始化点赞按钮
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.titleLabel.font = systemFont(12);
    [self.likeButton setTitleColor:PraiseBtnTextColor forState:UIControlStateNormal];
    UIImage *btnImage = [[UIImage imageNamed:@"home_likeBg"] stretchableImageWithLeftCapWidth:20 topCapHeight:2];
    [self.likeButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"home_like"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"home_like_hl"] forState:UIControlStateSelected];
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    self.likeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.likeButton addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBackImageView.mas_bottom).with.offset(30);
        make.right.equalTo(self.containerView.mas_right).with.offset(0);
        make.height.mas_equalTo(@28);
        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-16);
    }];

}

- (void)praise {
    self.likeButton.selected = !self.likeButton.isSelected;
}

@end
