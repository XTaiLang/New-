//
//  LMArticleViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMArticleViewController.h"
#import "LMArticleTool.h"
#import "LMArticleView.h"
#import "LMBaseFun.h"
#import "LMRightPullToRefreshView.h"

@interface LMArticleViewController ()<LMRightPullToRefreshViewDelegate, LMRightPullToRefreshViewDataSource>

@property (nonatomic, strong) LMRightPullToRefreshView *rightPullToRefreshView;
@end

@implementation LMArticleViewController {
    // 当前一共有多少篇文章，默认为3篇
    NSInteger numberOfItems;
    // 保存当前查看过的数据
    NSMutableDictionary *readItems;
    // 最后更新的日期
    NSString *lastUpdateDate;
    // 当前是否正在右拉刷新标记
    BOOL isRefreshing;
}
static LMArticleViewController *articleVC = nil;
+ (LMArticleViewController *)sharedArticleViewController {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!articleVC) {
            articleVC = [LMArticleViewController new];
        }
    });
    return articleVC;
}

//初始化时设置tabBarItem
- (instancetype)init {
    if (self = [super init]) {
        [self setUpTabBarItemWithNormalImage:[UIImage imageNamed:@"tabbar_item_reading"] selectedImage:[UIImage imageNamed:@"tabbar_item_reading_selected"] title:@"文章"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setUpNavigationBar:YES];
    //加载默认设置
    [self configSetting];
}

- (void)configSetting {
    numberOfItems = 2;
    readItems = [[NSMutableDictionary alloc] init];
    lastUpdateDate = [LMBaseFun stringDateBeforeTodaySeveralDays:0];
    isRefreshing = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置右拉刷新视图
    self.rightPullToRefreshView = [[LMRightPullToRefreshView alloc] initWithFrame:CGRectMake(0, 64, LMScreenW, LMScreenH - 64 - CGRectGetHeight(self.tabBarController.tabBar.frame))];
    self.rightPullToRefreshView.delegate = self;
    self.rightPullToRefreshView.dataSource = self;
    [self.view addSubview:self.rightPullToRefreshView];
    
    [self requestThingContentAtIndex:0];
}

#pragma mark - dataSource
- (NSInteger)numberOfItemsInRightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView {
    return numberOfItems;
}

- (UIView *)rightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    LMArticleView *articleView = nil;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rightPullToRefreshView.frame), CGRectGetHeight(rightPullToRefreshView.frame))];
    articleView = [[LMArticleView alloc] initWithFrame:view.bounds];
    [view addSubview:articleView];
    
    if (index == numberOfItems - 1 || index == readItems.allKeys.count) {// 当前这个 item 是没有展示过的
        [articleView refreshSubviewsForNewItem];
    } else {// 当前这个 item 是展示过了但是没有显示过数据的
        [articleView configureArticleViewWithArticleModal:readItems[[@(index) stringValue]]];
    }
    return view;
}

#pragma mark - RightPullToRefreshViewDelegate

- (void)rightPullToRefreshViewRefreshing:(LMRightPullToRefreshView *)rightPullToRefreshView {
    [self refreshing];
}

- (void)rightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView didDisplayItemAtIndex:(NSInteger)index {
    if (index == numberOfItems - 1) {// 如果当前显示的是最后一个，则添加一个 item
        numberOfItems++;
        [self.rightPullToRefreshView insertItemAtIndex:(numberOfItems - 1) animated:YES];
    }
    if (index < readItems.allKeys.count && readItems[[@(index) stringValue]]) {
        LMArticleView *articleView = (LMArticleView *)[rightPullToRefreshView itemViewAtIndex:index].subviews[0];
        [articleView configureArticleViewWithArticleModal:readItems[[@(index) stringValue]]];
    } else {
        [self requestThingContentAtIndex:index];
    }
}

- (void)rightPullToRefreshViewCurrentItemIndexDidChange:(LMRightPullToRefreshView *)rightPullToRefreshView {
    if (isGreatThanIOS9) {
        UIView *currentItemView = [rightPullToRefreshView currentItemView];
        for (id subView in rightPullToRefreshView.contentView.subviews) {
            if (![subView isKindOfClass:[UILabel class]]) {
                UIView *itemView = (UIView *)subView;
                LMArticleView *articleView = (LMArticleView *)itemView.subviews[0].subviews[0];
                UIScrollView *scrollView = (UIScrollView *)[articleView viewWithTag:ScrollViewTag];
                if (itemView == currentItemView.superview) {
                    scrollView.scrollsToTop = YES;
                } else {
                    scrollView.scrollsToTop = NO;
                }
            }
        }
    }
}

#pragma mark - Network Requests

// 右拉刷新
- (void)refreshing {
    if (readItems.allKeys.count > 0) {// 避免第一个还未加载的时候右拉刷新更新数据
        [self showHUDWithText:@""];
        isRefreshing = YES;
        [self requestThingContentAtIndex:0];
    }
}

- (void)requestThingContentAtIndex:(NSInteger)index {
    NSString *date = [LMBaseFun stringDateBeforeTodaySeveralDays:index];
    [LMArticleTool requestArticleDataFromSeverByDate:date lastUpdateDate:lastUpdateDate success:^(LMArticleModal *articleModal) {
        if (isRefreshing) {
            [self endRefreshing];
            if ([articleModal.strContentId isEqualToString:((LMArticleModal *)readItems[@"0"]).strContentId]) {
                [self showHUDWithText:IsLatestData delay:HUD_DELAY];
            }else {
                [readItems removeAllObjects];
                [self hideHud];
            }
            [self endRequestArticleContent:articleModal atIndex:index];
        } else {
            [self hideHud];
            [self endRequestArticleContent:articleModal atIndex:index];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Private

- (void)endRefreshing {
    isRefreshing = NO;
    [self.rightPullToRefreshView endRefreshing];
}

- (void)endRequestArticleContent:(LMArticleModal *)articleModal atIndex:(NSInteger)index {
    [readItems setObject:articleModal forKey:[@(index) stringValue]];
    [self.rightPullToRefreshView reloadItemAtIndex:index animated:NO];
}

//销毁时 清空设置
- (void)dealloc {
    self.rightPullToRefreshView.delegate = nil;
    self.rightPullToRefreshView.dataSource = nil;
    self.rightPullToRefreshView = nil;
}

@end
