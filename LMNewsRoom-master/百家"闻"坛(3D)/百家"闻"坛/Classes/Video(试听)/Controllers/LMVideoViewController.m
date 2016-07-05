//
//  LMVideoViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMVideoViewController.h"
#import "LMVideoModal.h"
#import "MJRefresh.h"
#import "LMVideoCell.h"
#import "LMVideoTool.h"
#import "LMPlayViewController.h"


@interface LMVideoViewController ()<UIViewControllerPreviewingDelegate>

/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *videoModals;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation LMVideoViewController

- (NSMutableArray *)videoModals
{
    if (!_videoModals) {
        _videoModals = [NSMutableArray array];
    }
    return _videoModals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化titleView
    [self setUpTitleView];
    // 初始化表格
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
}

- (void)setUpTitleView {
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 23)];
    titleImageView.image = [UIImage imageNamed:@"shiting"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = titleImageView;
}

static NSString * const NKTopicCellId = @"topic";
- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = LMTitilesViewY + LMTitilesViewH;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewTopics)];
    [self.tableView headerBeginRefreshing];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreTopics)];
}

#pragma mark - 数据处理
/**
 * 加载新的帖子数据
 */
- (void)loadNewTopics {
    // 结束上拉
    [self.tableView footerEndRefreshing];
    
    [LMVideoTool requestVideoFromSeverSuccess:^(NSArray *videoModals, NSString *maxtime) {
        // 存储maxtime
        self.maxtime = maxtime;
        
        // 字典 -> 模型
        self.videoModals = (NSMutableArray *)videoModals;
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        
        // 清空页码
        self.page = 0;

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        // 结束刷新
        [self.tableView headerEndRefreshing];
    }];

}

/**
 * 加载更多的帖子数据
 */
- (void)loadMoreTopics {
    // 结束下拉
    [self.tableView headerEndRefreshing];
    
    [LMVideoTool requestVideoFromSeverWithPage:self.page maxTime:self.maxtime Success:^(NSArray *videoModals, NSString *maxtime) {
        
        
        self.maxtime = maxtime;
        [self.videoModals addObjectsFromArray:videoModals];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        // 结束刷新
        [self.tableView footerEndRefreshing];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footerHidden = (self.videoModals.count == 0);
    return self.videoModals.count;
}

static NSString *ID = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[LMVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //注册3dTouch
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    
    cell.videoModal = self.videoModals[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMVideoModal *videoModal = self.videoModals[indexPath.row];
    
    return videoModal.cellHeight;
}

#pragma mark - 3DTouch  UIViewControllerPreviewingDelegate
//此方法是轻按控件时，跳出peek的代理方法
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //防止重复加入
    if ([self.presentedViewController isKindOfClass:[LMPlayViewController class]])
    {
        return nil;
    }
    else
    {
        //根据点击的来源视图判断出当前点击的cell的indexPath
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
        LMVideoModal *videoModal = self.videoModals[indexPath.row];
        return [self showNextViewController:videoModal withType:1];
    }
    
}

//此方法是重按peek时，跳入pop的代理方法
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    LMVideoModal *videoModal = self.videoModals[indexPath.row];
    [self showNextViewController:videoModal withType:2];
    
}

//根据news的photosetID判断要弹出的viewController
- (UIViewController *)showNextViewController:(LMVideoModal *)videoModal withType:(NSInteger)type{
    LMPlayViewController *playVC = [[LMPlayViewController alloc] init];
    playVC.videoModal = videoModal;
    return[self finishActionWithViewController:playVC type:type];
}
//根据type类型判断推出方式
- (UIViewController *)finishActionWithViewController:(UIViewController *)viewController type:(NSInteger)type {
    
    switch (type) {
        case 2:
            viewController.hidesBottomBarWhenPushed = YES;
            self.navigationController.navigationBarHidden = YES;
            [self showViewController:viewController sender:self];
            break;
    }
    return viewController;
}

@end
