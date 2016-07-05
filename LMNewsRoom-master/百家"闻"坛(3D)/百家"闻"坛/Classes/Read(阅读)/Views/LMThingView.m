//
//  LMThingView.m
//  onlyOne
//
//  Created by lim on 16/2/22.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMThingView.h"
#import "Masonry.h"
#import "LMBaseFun.h"
#import "UIImageView+WebCache.h"


#define ThingNameTextColor [UIColor colorWithRed:90 / 255.0 green:91 / 255.0 blue:92 / 255.0 alpha:1] // #5A5B5C
#define ThingDescriptionColor [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] // #333333

@interface LMThingView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *thingImageView;
@property (nonatomic, strong) UILabel *thingNameLabel;
@property (nonatomic, strong) UITextView *thingDescriptionTextView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;// item 加载中转转的菊花

@end

@implementation LMThingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUpViews];
    }
    
    return self;
}

- (void)setUpViews {

    self.backgroundColor = [UIColor whiteColor];
    // 初始化 ScrollView
    self.scrollView = [UIScrollView new];
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.tag = ScrollViewTag;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollsToTop = YES;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // 初始化容器视图
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 初始化日期文字控件
    self.dateLabel = [UILabel new];
    self.dateLabel.font = systemFont(13);
    self.dateLabel.textColor = DateTextColor;
    self.dateLabel.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).with.offset(12);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
    }];
    
    // 初始化东西图片控件
    self.thingImageView = [[UIImageView alloc] init];
    self.thingImageView.backgroundColor = [UIColor whiteColor];
    CGFloat imgWidth = SCREEN_WIDTH - 20;
    CGFloat imgHeight = imgWidth;
    [self.containerView addSubview:self.thingImageView];
    [self.thingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
        make.height.mas_equalTo(@(imgHeight));
    }];
    
    // 初始化东西名字文字控件
    self.thingNameLabel = [UILabel new];
    self.thingNameLabel.numberOfLines = 0;
    self.thingNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    self.thingNameLabel.textColor = ThingNameTextColor;
    [self.containerView addSubview:self.thingNameLabel];
    [self.thingNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thingImageView.mas_bottom).with.offset(32);
        make.left.equalTo(self.containerView.mas_left).with.offset(15);
        make.right.equalTo(self.containerView.mas_right).with.offset(-15);
    }];
    
    // 初始化东西介绍文字视图控件
    self.thingDescriptionTextView = [UITextView new];
    self.thingDescriptionTextView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    self.thingDescriptionTextView.editable = NO;
    self.thingDescriptionTextView.scrollEnabled = NO;
    self.thingDescriptionTextView.pagingEnabled = NO;
    self.thingDescriptionTextView.scrollsToTop = NO;
    self.thingDescriptionTextView.directionalLockEnabled = NO;
    self.thingDescriptionTextView.alwaysBounceVertical = NO;
    self.thingDescriptionTextView.alwaysBounceHorizontal = NO;
    self.thingDescriptionTextView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.thingDescriptionTextView];
    [self.thingDescriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thingNameLabel.mas_bottom).with.offset(25);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-10);
    }];
    
    // 初始化加载中的菊花控件
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.hidesWhenStopped = YES;
    [self addSubview:self.indicatorView];
}

- (void)startRefreshing {
    self.indicatorView.center = self.center;

        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.indicatorView startAnimating];
}

- (void)setUpThingViewWithThingModal:(LMThingModal *)thingModal animated:(BOOL)animate; {
    [self.indicatorView stopAnimating];
    self.containerView.hidden = NO;
    
    if (isGreatThanIOS9) {
        CGFloat activationPointX = self.scrollView.accessibilityActivationPoint.x;
        if (activationPointX > 0 && activationPointX < SCREEN_WIDTH) {
            self.scrollView.scrollsToTop = YES;
        } else {
            self.scrollView.scrollsToTop = NO;
        }
    }
    
    self.dateLabel.text = [LMBaseFun enMarketTimeWithOriginalMarketTime:thingModal.strTm];
    
    [self.thingImageView sd_setImageWithURL:[NSURL URLWithString:thingModal.strBu] placeholderImage:nil completed:nil];
    self.thingNameLabel.text = thingModal.strTt;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attribute;

        self.thingDescriptionTextView.backgroundColor = [UIColor whiteColor];
        
        attribute = @{NSParagraphStyleAttributeName : paragraphStyle,
                      NSForegroundColorAttributeName : ThingDescriptionColor,
                      NSFontAttributeName : [UIFont systemFontOfSize:15]};

    self.thingDescriptionTextView.attributedText = [[NSAttributedString alloc] initWithString:thingModal.strTc attributes:attribute];
    [self.thingDescriptionTextView sizeToFit];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.containerView.frame));
}

- (void)refreshSubviewsForNewItem {
    self.dateLabel.text = @"";
    self.thingNameLabel.text = @"";
    
    self.thingDescriptionTextView.text = @"";
    [self.thingDescriptionTextView sizeToFit];
    
    self.containerView.hidden = YES;
    self.scrollView.scrollsToTop = NO;
    
    [self startRefreshing];
}

@end
