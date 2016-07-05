//
//  LMQuestionViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMQuestionViewController.h"
#import "LMQuestionTool.h"
#import "LMBaseFun.h"
#import "LMQuestionView.h"
#import "LMRightPullToRefreshView.h"

@interface LMQuestionViewController ()<LMRightPullToRefreshViewDataSource,LMRightPullToRefreshViewDelegate>
@property (nonatomic, strong) LMRightPullToRefreshView *rightPullToRefreshView;
@end
static LMQuestionViewController *questionVC = nil;
@implementation LMQuestionViewController {
    // 当前一共有多少 item，默认为3个
    NSInteger numberOfItems;
    // 保存当前查看过的数据
    NSMutableDictionary *readItems;
    // 最后更新的日期
    NSString *lastUpdateDate;
    // 当前是否正在右拉刷新标记
    BOOL isRefreshing;
}

+ (LMQuestionViewController *)sharedQuestionViewController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!questionVC) {
            questionVC = [LMQuestionViewController new];
        }
    });
    return questionVC;
}


//初始化时设置tabBarItem
- (instancetype)init {
    if (self = [super init]) {
        [self setUpTabBarItemWithNormalImage:[UIImage imageNamed:@"tabbar_item_question"] selectedImage:[UIImage imageNamed:@"tabbar_item_question_selected"] title:@"问题"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setUpNavigationBar:YES];
    //加载默认设置
    [self setUpBaseSetting];
}

- (void)setUpBaseSetting {
    numberOfItems = 2;
    readItems = [[NSMutableDictionary alloc] init];
    lastUpdateDate = [LMBaseFun stringDateBeforeTodaySeveralDays:0];
    isRefreshing = NO;
    
    self.rightPullToRefreshView = [[LMRightPullToRefreshView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CGRectGetHeight(self.tabBarController.tabBar.frame))];
    self.rightPullToRefreshView.delegate = self;
    self.rightPullToRefreshView.dataSource = self;
    [self.view addSubview:self.rightPullToRefreshView];
    
    [self requestQuestionContentAtIndex:0];
}

#pragma mark - Lifecycle

- (void)dealloc {
    self.rightPullToRefreshView.delegate = nil;
    self.rightPullToRefreshView.dataSource = nil;
    self.rightPullToRefreshView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification

- (void)nightModeSwitch:(NSNotification *)notification {
    [self.rightPullToRefreshView reloadData];
}

#pragma mark - RightPullToRefreshViewDataSource

- (NSInteger)numberOfItemsInRightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView {
    return numberOfItems;
}

- (UIView *)rightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    LMQuestionView *questionView = nil;
    
    //create new view if no view is available for recycling
    //    if (view == nil) {
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(rightPullToRefreshView.frame), CGRectGetHeight(rightPullToRefreshView.frame))];
    questionView = [[LMQuestionView alloc] initWithFrame:view.bounds];
    [view addSubview:questionView];
    //    } else {
    //        questionView = (LMQuestionView *)view.subviews[0];
    //    }
    
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    if (index == numberOfItems - 1 || index == readItems.allKeys.count) {// 当前这个 item 是没有展示过的
        [questionView refreshSubviewsForNewItem];
    } else {// 当前这个 item 是展示过了但是没有显示过数据的
        [questionView configureQuestionViewWithQuestionModal:readItems[[@(index) stringValue]]];
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
        LMQuestionView *questionView = (LMQuestionView *)[rightPullToRefreshView itemViewAtIndex:index].subviews[0];
        [questionView configureQuestionViewWithQuestionModal:readItems[[@(index) stringValue]]];
    } else {
        [self requestQuestionContentAtIndex:index];
    }
}

- (void)rightPullToRefreshViewCurrentItemIndexDidChange:(LMRightPullToRefreshView *)rightPullToRefreshView {
    if (isGreatThanIOS9) {
        UIView *currentItemView = [rightPullToRefreshView currentItemView];
        for (id subView in rightPullToRefreshView.contentView.subviews) {
            if (![subView isKindOfClass:[UILabel class]]) {
                UIView *itemView = (UIView *)subView;
                LMQuestionView *questionView = (LMQuestionView *)itemView.subviews[0].subviews[0];
                UIWebView *webView = (UIWebView *)[questionView viewWithTag:WebViewTag];
                if (itemView == currentItemView.superview) {
                    webView.scrollView.scrollsToTop = YES;
                } else {
                    webView.scrollView.scrollsToTop = NO;
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
        [self requestQuestionContentAtIndex:0];
    }
}

- (void)requestQuestionContentAtIndex:(NSInteger)index {
    NSString *date = [LMBaseFun stringDateBeforeTodaySeveralDays:index];
    [LMQuestionTool requestQuestionDataFromSeverByDate:date lastUpdateDate:lastUpdateDate success:^(LMQuestionModal *questionModal) {
        
        if (IsStringEmpty(questionModal.strQuestionId)) {
            questionModal.strQuestionMarketTime = date;
        }
        if (isRefreshing) {
            [self endRefreshing];
            if ([questionModal.strQuestionId isEqualToString:((LMQuestionModal *)readItems[@"0"]).strQuestionId]) {
                [self showHUDWithText:IsLatestData delay:HUD_DELAY];
            }else {
                [readItems removeAllObjects];
                [self hideHud];
            }
            [self endRequestQuestionContent:questionModal atIndex:index];
        } else {
            [self hideHud];
            [self endRequestQuestionContent:questionModal atIndex:index];
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

- (void)endRequestQuestionContent:(LMQuestionModal *)questionModal atIndex:(NSInteger)index {
    [readItems setObject:questionModal forKey:[@(index) stringValue]];
    [self.rightPullToRefreshView reloadItemAtIndex:index animated:NO];
}

#pragma mark - Parent

- (void)share {
    [super share];
}

@end
