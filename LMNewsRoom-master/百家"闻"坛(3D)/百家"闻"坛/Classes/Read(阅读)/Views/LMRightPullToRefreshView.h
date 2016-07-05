//
//  LMRightPullToRefreshView.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@class LMRightPullToRefreshView;

@protocol LMRightPullToRefreshViewDataSource <NSObject>
@required
/**
 *  一共有多少个item
 *
 *  @param rightPullToRefreshView 右拉刷新视图
 *
 *  @return item的个数
 */
- (NSInteger)numberOfItemsInRightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView;
/**
 *  当前要显示的item的view
 *
 *  @param rightPullToRefreshView 右拉刷新视图
 *  @param index                  当前要显示的下标
 *  @param view                   重用视图
 *
 *  @return 当前item的view
 */
- (UIView *)rightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;
@end

@protocol LMRightPullToRefreshViewDelegate <NSObject>
@optional
/**
 *  右拉刷新最新数据
 *
 *  @param rightPullToRefreshView 右拉刷新视图
 */
- (void)rightPullToRefreshViewRefreshing:(LMRightPullToRefreshView *)rightPullToRefreshView;
/**
 *  左拉到最后一个item，需要更旧的数据
 *
 *  @param rightPullToRefreshView 右拉刷新视图
 */
- (void)rightPullToRefreshViewDidScrollToFinalItem:(LMRightPullToRefreshView *)rightPullToRefreshView;
/**
 *  item 在屏幕上显示完毕
 *
 *  @param rightPullToRefreshView rightPullToRefreshView
 *  @param index                  当前 item 的下标
 */
- (void)rightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView didDisplayItemAtIndex:(NSInteger)index;

/**
 *  当前要展示的 item 的下标发生变化
 *
 *  @param rightPullToRefreshView rightPullToRefreshView
 */
- (void)rightPullToRefreshViewCurrentItemIndexDidChange:(LMRightPullToRefreshView *)rightPullToRefreshView;
@end

@interface LMRightPullToRefreshView : UIView

@property (nonatomic, assign) id<LMRightPullToRefreshViewDelegate> delegate;
@property (nonatomic, assign) id<LMRightPullToRefreshViewDataSource> dataSource;
@property (nonatomic, readonly) NSInteger currentItemIndex;
@property (nonatomic, strong, readonly) UIView *currentItemView;
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 *  插入一个新的 item
 *
 *  @param index     新的 item 的下标
 *  @param animated 是否需要动画
 */
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  重新加载数据
 */
- (void)reloadData;

/**
 *  重新加载指定下标的 item
 *
 *  @param index  要重新加载的 item 的下标
 */
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  获取指定下标的 item
 *
 *  @param index  要获取的 item 的下标
 *
 *  @return 指定下标的 item
 */
- (UIView *)itemViewAtIndex:(NSInteger)index;

/**
 *  结束刷新
 */
- (void)endRefreshing;

@end
