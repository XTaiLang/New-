//
//  LMRightPullToRefreshView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMRightPullToRefreshView.h"

#define LabelOffsetX 20
#define LeftRefreshLabelTextColor [UIColor colorWithRed:90 / 255.0 green:91 / 255.0 blue:92 / 255.0 alpha:1] // #5A5B5C

@interface LMRightPullToRefreshView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,strong) iCarousel *carousel;
@property (nonatomic,strong) UILabel *refreshingLeftLabel;

@end

@implementation LMRightPullToRefreshView{
    //视图控件的高度
    CGFloat viewHeight;
    //item总数
    NSInteger itemsNumber;
    //label宽
    CGFloat refreshingLeftLabelWidth;
    //是否可以返回上一个已经存在的item，用于刷新时不改变refreshingLeftLabel的frame
    BOOL canScrollBack;
    // 标记是否需要刷新，默认为 NO
    BOOL isNeedRefresh;
    // 保存右拉的 x 距离
    CGFloat draggedX;
    // 最后一次显示的 item 的下标
    NSInteger lastItemIndex;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpBaseSetting];
    }
    return self;
}
#pragma mark - 设置视图基本属性
- (void)setUpBaseSetting {
    self.backgroundColor = [UIColor whiteColor];
    
    viewHeight = CGRectGetHeight(self.frame);
    isNeedRefresh = NO;
    canScrollBack = YES;
    draggedX = 0;
    lastItemIndex = -1;
    
    [self setUpAllChildViews];
}
#pragma mark - 添加所有子视图
- (void)setUpAllChildViews {
    //添加并设置旋转木马对象
    iCarousel *carousel = [[iCarousel alloc]initWithFrame:self.bounds];
    carousel.delegate = self;
    carousel.dataSource = self;
    //设置旋转木马的类型为linear
    carousel.type = iCarouselTypeLinear;
    carousel.vertical = NO;
    carousel.pagingEnabled = YES;
    //非包裹传送带冲出结束时，它会反弹的最大距离。这是衡量的倍数itemWidth ，所以值1.0表示一个整体的产品宽度传送带将反弹，将价值0.5项目的宽度的一半，依此类推。默认值是1.0 ;
    carousel.bounceDistance = 0.7;
    //传送带的速率减速时挥动。值越高意味着减速放缓。默认值是0.95 。值范围在0.0 （传送带时立即停止发布）到1.0 （传送带继续下去，而不会减慢，除非到达终点） 。
    carousel.decelerationRate = 0.6;
    self.carousel = carousel;
    [self addSubview:self.carousel];
    
    //设置"右拉刷新..."label
    UILabel *refreshingLeftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    refreshingLeftLabel.font = [UIFont systemFontOfSize:10.0f];
    refreshingLeftLabel.textColor = LeftRefreshLabelTextColor;
    refreshingLeftLabel.textAlignment = NSTextAlignmentRight;
    refreshingLeftLabel.text = LeftDragToRightForRefreshHintText;
    [refreshingLeftLabel sizeToFit];
    [refreshingLeftLabel setNeedsDisplay];
    self.refreshingLeftLabel = refreshingLeftLabel;
    refreshingLeftLabelWidth = CGRectGetWidth(refreshingLeftLabel.frame);
    CGRect labelFrame = CGRectMake(0 - refreshingLeftLabelWidth * 1.5 - LabelOffsetX, (CGRectGetMaxY(self.carousel.frame) - CGRectGetHeight(self.refreshingLeftLabel.frame)) / 2.0, refreshingLeftLabelWidth * 1.5, CGRectGetHeight(self.refreshingLeftLabel.frame));
    refreshingLeftLabel.frame = labelFrame;
    [self.carousel.contentView addSubview:refreshingLeftLabel];
}

#pragma mark - 共用部分

- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    itemsNumber++;
    // 在 iCarousel 的最后插入一个新的 item
    [self.carousel insertItemAtIndex:(itemsNumber - 1) animated:YES];
}

- (void)reloadData {
    [self.carousel reloadData];
}

- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.carousel reloadItemAtIndex:index animated:animated];
}
//获取指定下标上的view
- (UIView *)itemViewAtIndex:(NSInteger)index {
    return [self.carousel itemViewAtIndex:index];
}
//结束刷新
- (void)endRefreshing {
    if (isNeedRefresh) {//需要刷新
        //还原原始refreshingLeftLabel的frame
        CGRect frame = self.refreshingLeftLabel.frame;
        frame.origin.x = 0 - refreshingLeftLabelWidth * 1.5 - LabelOffsetX;
        
        [UIView animateWithDuration:DefaultAnimationDuration animations:^{
            self.carousel.contentOffset = CGSizeMake(0, 0);
            self.refreshingLeftLabel.frame = frame;
        } completion:^(BOOL finished) {
            isNeedRefresh = NO;
            canScrollBack = YES;
        }];
    }
}

#pragma mark - Getter

- (NSInteger)currentItemIndex {
    return self.carousel.currentItemIndex;
}

- (UIView *)currentItemView {
    return [self.carousel itemViewAtIndex:self.currentItemIndex];
}

- (UIView *)contentView {
    return self.carousel.contentView;
}

#pragma mark - Setter

- (void)setDelegate:(id<LMRightPullToRefreshViewDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        
        if (_delegate && _dataSource) {
            [self setNeedsLayout];
        }
    }
}

- (void)setDataSource:(id<LMRightPullToRefreshViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if (_dataSource) {
            [self.carousel reloadData];
        }
    }
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    //在controller中设置item的数量
    itemsNumber = [self.dataSource numberOfItemsInRightPullToRefreshView:self];
    return itemsNumber;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    return [self.dataSource rightPullToRefreshView:self viewForItemAtIndex:index reusingView:view];
}

#pragma mark - iCarouselDelegate
//获取旋转木马item的宽
- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return CGRectGetWidth(self.frame);
}
//当前展示的item发生改变时调用
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if ([self.delegate respondsToSelector:@selector(rightPullToRefreshViewCurrentItemIndexDidChange:)]) {
        [self.delegate rightPullToRefreshViewCurrentItemIndexDidChange:self];
    }
}
//当旋转木马滚动时调用，用于显示和改变refreshingLeftLabel
- (void)carouselDidScroll:(iCarousel *)carousel {
    //右拉刷新时，改变refreshingLeftLabel的x，进行显示
    if (carousel.scrollOffset <= 0) {
        if (canScrollBack) {
            // 计算右拉的距离
            draggedX = fabs(carousel.scrollOffset * carousel.itemWidth);
            CGRect frame = self.refreshingLeftLabel.frame;
            frame.origin.x = draggedX - CGRectGetWidth(self.refreshingLeftLabel.frame) - LabelOffsetX;
            self.refreshingLeftLabel.frame = frame;
            // 当右拉到一定的距离之后将 leftRefreshLabel 的文字改为“松开刷新数据...”，这里的距离为 leftRefreshLabel 宽度的1.5倍
            if (draggedX >= refreshingLeftLabelWidth * 1.5 + LabelOffsetX) {
                // 刷新 leftRefreshLabel文字为松开刷新数据
                self.refreshingLeftLabel.text = LeftReleaseToRefreshHintText;
                // 将刷新标记改为需要刷新
                isNeedRefresh = YES;
            } else {
                // 刷新 leftRefreshLabel文字为右拉刷新...
                self.refreshingLeftLabel.text = LeftDragToRightForRefreshHintText;
                // 将刷新标记改为不需要刷新
                isNeedRefresh = NO;
            }
        }
    }
}
//当旋转木马结束拖动时调用，用于判断是否需要刷新数据，以及是否需要改变refreshingLeftLabel的文字
//decelerate 当前item为左边第一个时，右拉释放，为NO 否则为YES
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    //右拉释放并且达到刷新数据的偏移量
    if (!decelerate && isNeedRefresh) {
        //设置refreshingLeftLabel的文字和横坐标
        self.refreshingLeftLabel.text = LeftReleaseIsRefreshingHintText;
        CGRect frame = self.refreshingLeftLabel.frame;
        frame.origin.x = refreshingLeftLabelWidth - CGRectGetWidth(self.refreshingLeftLabel.frame);
        
        // 不改变 refreshingLeftLabel 的 frame
        canScrollBack = NO;
        
        //动画还原refreshingLeftLabel
        [UIView animateWithDuration:DefaultAnimationDuration animations:^{
            // 设置 carousel item 的 X 轴偏移
            carousel.contentOffset = CGSizeMake(CGRectGetMaxX(frame) + LabelOffsetX, 0);
            
            self.refreshingLeftLabel.frame = frame;
        }];
        
        if ([self.delegate respondsToSelector:@selector(rightPullToRefreshViewRefreshing:)]) {
            [self.delegate rightPullToRefreshViewRefreshing:self];
        }
    }
}
//旋转木马结束滚动动画时调用
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {

    // 如果当前的 item 为第一个并且 leftRefreshLabel 可以 scroll back，那么就刷新 leftRefreshLabel
    if (carousel.currentItemIndex == 0 && canScrollBack) {
        self.refreshingLeftLabel.text = LeftDragToRightForRefreshHintText;
        isNeedRefresh = NO;
    }
    
    if (lastItemIndex != carousel.currentItemIndex) {
        if ([self.delegate respondsToSelector:@selector(rightPullToRefreshView:didDisplayItemAtIndex:)]) {
            [self.delegate rightPullToRefreshView:self didDisplayItemAtIndex:carousel.currentItemIndex];
        }
    }
    //保存当前item下标
    lastItemIndex = carousel.currentItemIndex;
    
}
//销毁时，清空所有设置，重用
- (void)dealloc {
    self.carousel.delegate = nil;
    self.carousel.dataSource = nil;
    [self.carousel removeFromSuperview];
    self.carousel = nil;
    [self.refreshingLeftLabel removeFromSuperview];
    self.refreshingLeftLabel = nil;
}

@end
