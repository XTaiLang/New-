//
//  LMPictureViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPictureViewController.h"
#import "LMPictureTool.h"
#import "LMPictureView.h"
#import "LMRightPullToRefreshView.h"
#import "LMArticleViewController.h"
#import "LMQuestionViewController.h"
#import "LMThingViewController.h"
#import "LMCategoryTableViewController.h"
#import "LMPopView.h"

@interface LMPictureViewController ()<LMRightPullToRefreshViewDelegate,LMRightPullToRefreshViewDataSource,LMPopViewDelegate>

@property (nonatomic,strong) LMRightPullToRefreshView *rightPullToRefreshView;
@property (nonatomic,strong) LMCategoryTableViewController *categoryViewController;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic, strong) LMPopView *popView;
@property (nonatomic,strong) LMArticleViewController *articleVC;
@property (nonatomic,strong) LMQuestionViewController *questionVC;
@property (nonatomic,strong) LMThingViewController *thingVC;

@end

@implementation LMPictureViewController
{
    // 当前一共有多少篇文章，默认为3篇
    NSInteger numberOfItems;
    // 保存当前查看过的数据
    NSMutableDictionary *readItems;
    // 最后展示的 item 的下标
    NSInteger lastConfigureViewForItemIndex;
    // 当前是否正在右拉刷新标记
    BOOL isRefreshing;
}


- (LMPopView *)popView {
    if (!_popView) {
        _popView = [LMPopView popView];
    }
    return _popView;
}

- (LMCategoryTableViewController *)categoryViewController {
    if (!_categoryViewController) {
        _categoryViewController = [[LMCategoryTableViewController alloc]init];
    }
    return _categoryViewController;
}

//初始化时设置tabBarItem
- (instancetype)init {
    if (self = [super init]) {
        [self setUpTabBarItemWithNormalImage:[UIImage imageNamed:@"tabbar_item_home"] selectedImage:[UIImage imageNamed:@"tabbar_item_home_selected"] title:@"首页"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewController:) name:@"changeViewControllers" object:nil];
    
    //设置导航条
    [self setUpNavigationBar];
    //加载默认设置
    [self configSetting];
    
}

- (void)setUpNavigationBar {
    
    [self setUpNavigationBar:YES];
    UIView *titleView = self.navigationItem.titleView;
    self.titleView = titleView;
    titleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeViewControllers)];
    [titleView addGestureRecognizer:tap];
}

- (void)changeViewControllers {
    
    //  显示菜单
    CGFloat x = (self.view.width - 200) * 0.5;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame) - 9;
    
    self.popView.contentView = self.categoryViewController.view;
    
    [self.popView showInRect:CGRectMake(x, y, 200, 200)];
}

// popView代理
- (void)popViewDidDismiss:(LMPopView *)popView
{
    _popView = nil;
}

- (void)changeViewController:(NSNotification *)notification {
    NSInteger index = [notification.userInfo[@"index"] intValue];
    switch (index) {
        case 0:
            [self.navigationController pushViewController:[[LMPictureViewController alloc]init] animated:YES];
            
            break;
        case 1:
            [self.navigationController pushViewController:[[LMArticleViewController alloc]init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[LMQuestionViewController alloc]init] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[[LMThingViewController alloc]init] animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)configSetting {
    numberOfItems = 2;
    readItems = [[NSMutableDictionary alloc] init];
    lastConfigureViewForItemIndex = 0;
    isRefreshing = NO;
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置右拉刷新视图
    self.rightPullToRefreshView = [[LMRightPullToRefreshView alloc] initWithFrame:CGRectMake(0, 64, LMScreenW, LMScreenH - 64 - CGRectGetHeight(self.tabBarController.tabBar.frame))];
    self.rightPullToRefreshView.delegate = self;
    self.rightPullToRefreshView.dataSource = self;
    [self.view addSubview:self.rightPullToRefreshView];
    
    [self requestHomeContentAtIndex:0];
}

#pragma mark - dataSource 
- (NSInteger)numberOfItemsInRightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView {
    return numberOfItems;
}

- (UIView *)rightPullToRefreshView:(LMRightPullToRefreshView *)rightPullToRefreshView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    LMPictureView *pictureView = nil;
    
//    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rightPullToRefreshView.frame), CGRectGetHeight(rightPullToRefreshView.frame))];
        pictureView = [[LMPictureView alloc] initWithFrame:view.bounds];
        [view addSubview:pictureView];
//    } else {
//        
//        homeView = (LMHomeView *)view.subviews[0];
//    }
    if (index == numberOfItems - 1 || index == readItems.allKeys.count) {// 当前这个 item 是没有展示过的
        [pictureView refreshSubviewsForNewItem];
    } else {// 当前这个 item 是展示过了但是没有显示过数据的
        lastConfigureViewForItemIndex = MAX(index, lastConfigureViewForItemIndex);
        [pictureView setUpHomeViewWithHomeModal:readItems[[@(index) stringValue]] animated:YES];
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
        LMPictureView *pictureView = (LMPictureView *)[rightPullToRefreshView itemViewAtIndex:index].subviews[0];
        [pictureView setUpHomeViewWithHomeModal:readItems[[@(index) stringValue]] animated:(lastConfigureViewForItemIndex == 0 || lastConfigureViewForItemIndex < index)];
    } else {
        [self requestHomeContentAtIndex:index];
    }
}

- (void)rightPullToRefreshViewCurrentItemIndexDidChange:(LMRightPullToRefreshView *)rightPullToRefreshView {
    if (isGreatThanIOS9) {
        UIView *currentItemView = [rightPullToRefreshView currentItemView];
        for (id subView in rightPullToRefreshView.contentView.subviews) {
            if (![subView isKindOfClass:[UILabel class]]) {
                UIView *itemView = (UIView *)subView;
                LMPictureView *pictureView = (LMPictureView *)itemView.subviews[0].subviews[0];
                UIScrollView *scrollView = (UIScrollView *)[pictureView viewWithTag:ScrollViewTag];
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
        [self requestHomeContentAtIndex:0];
    }
}

- (void)requestHomeContentAtIndex:(NSInteger)index {
    [LMPictureTool requestHomeDataFromSeverByIndex:index success:^(LMPictureModal *pictureModal) {
        
        if (isRefreshing) {
            [self endRefreshing];
            if ([pictureModal.strHpId isEqualToString:((LMPictureModal *)readItems[@"0"]).strHpId]) {
                [self showHUDWithText:IsLatestData delay:HUD_DELAY];
            }else {
                [readItems removeAllObjects];
                [self hideHud];
            }
            [self endRequestHomeContent:pictureModal atIndex:index];
        } else {
            [self hideHud];
            [self endRequestHomeContent:pictureModal atIndex:index];
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

- (void)endRequestHomeContent:(LMPictureModal *)pictureModal atIndex:(NSInteger)index {
    [readItems setObject:pictureModal forKey:[@(index) stringValue]];
    [self.rightPullToRefreshView reloadItemAtIndex:index animated:NO];
}

//销毁时 清空设置
- (void)dealloc {
    self.rightPullToRefreshView.delegate = nil;
    self.rightPullToRefreshView.dataSource = nil;
    self.rightPullToRefreshView = nil;
}

@end
