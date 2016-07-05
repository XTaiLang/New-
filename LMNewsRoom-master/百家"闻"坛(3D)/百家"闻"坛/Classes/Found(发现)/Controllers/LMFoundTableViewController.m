//
//  LMFoundTableViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMFoundTableViewController.h"
#import "UIBarButtonItem+Item.h"
#import "AFNetworking.h"
#import "LMAccountTool.h"
#import "LMStatus.h"
#import "LMUser.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "LMHttpTool.h"
#import "LMStatusTool.h"
#import "LMUserTool.h"
#import "LMAccount.h"
#import "LMStatusCell.h"
#import "LMStatusFrame.h"
#import "LMOAuthViewController.h"
#import "MJPhotoBrowser.h"
#import "LMPhoto.h"
#import "LMPhotoView.h"
#import "MJPhoto.h"

@interface LMFoundTableViewController ()<UIViewControllerPreviewingDelegate>

/**
 *  ViewModel:LMStatusFrame
 */
@property (nonatomic,strong) NSMutableArray *statusFrames;
@property (nonatomic,assign) NSInteger index;

@end

@implementation LMFoundTableViewController

- (NSMutableArray *)statusFrames {
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断有没有授权
    if ([LMAccountTool account]) {
        //选择根控制器
    }else {
        //进行授权
        LMOAuthViewController *oauthViewController = [[LMOAuthViewController alloc]init];
        //设置窗口的根控制器
        [self presentViewController:oauthViewController animated:YES completion:nil];
    }
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置导航条内容
    [self setUpNavigarionBar];
    
    //请求最新的微博数据 可以直接自动下拉刷新
    //[self loadNewStatus];
    //下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    //自动下拉刷新
    [self.tableView headerBeginRefreshing];
    
    //上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
    
    //设置导航条的
    [self setUpTitleView];
    
    //请求用户昵称
    [LMUserTool userInfoWithSuccess:^(LMUser *user) {
        //请求成功
        //获取用户模型
        LMAccount *account = [LMAccountTool account];
        account.name = user.name;
        
        //保存用户的名称
        [LMAccountTool saveAccount:account];
        
    } failure:^(NSError *error) {
        //请求失败
    }];
    
}

- (void)setUpTitleView {
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 23)];
    titleImageView.image = [UIImage imageNamed:@"luofengwuyu"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = titleImageView;
}

//{:json字典 [:json数组

#pragma mark - 展示最新的微博数据
- (void)loadNewStatus {
    
    NSString *sinceId = nil;
    if (self.statusFrames.count) {//有微博数据才需要下拉刷新
        LMStatusFrame *firstStatusFrame = self.statusFrames[0] ;
        sinceId = firstStatusFrame.status.idstr;
    }
    //请求更新的微博数据 由业务类LMStatusTool完成
    [LMStatusTool newStatusWithSinceId:sinceId success:^(NSArray *statues) {
        //请求成功的Block
        
        //展示最新的微博数
        [self showNewStatus:statues.count];
        
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        //把模型转换成视图模型 LMStatus -> LMStatusFrame
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (LMStatus *status in statues) {
            LMStatusFrame *statusFrame = [LMStatusFrame new];
            statusFrame.status = status;
            [statusFrames addObject:statusFrame];
        }
        //将请求到的数据插入到数组下标 0至请求数据长度 之间
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statues.count)];
        //把最新的微博数插入到最前面
        [self.statusFrames insertObjects:statusFrames atIndexes:indexSet];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 展示最新的微博数
- (void)showNewStatus:(NSUInteger)count {
    if (count == 0) return;
    CGFloat h = 35;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame)-h;
    CGFloat x = 0;
    CGFloat w = self.view.width;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.text = [NSString stringWithFormat:@"获得%lu条新微博",(unsigned long)count];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    //插入导航控制器下导航条下面
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //动画往下面平移
    [UIView animateWithDuration:0.25 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, h);
    } completion:^(BOOL finished) {
        //还原往上面平移
        [UIView animateWithDuration:0.25 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

#pragma mark - 展示更多的微博
- (void)loadMoreStatus {
    static NSString *maxId = nil;
    if (self.statusFrames.count) {//有微博数据才需要上拉刷新
        LMStatusFrame *lastStatusFrame = [self.statusFrames lastObject];
        maxId = [NSString stringWithFormat:@"%lld",[lastStatusFrame.status.idstr longLongValue] - 1];
    }
    //请求更多的微博数据 由业务类LMStatusTool完成
    [LMStatusTool moreStatusWithMaxId:maxId success:^(NSArray *statuses) {
        //请求成功
        //结束上拉刷新
        [self.tableView footerEndRefreshing];
        //把模型转为视图模型
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (LMStatus *status in statuses) {
            LMStatusFrame *statusFrame = [LMStatusFrame new];
            statusFrame.status = status;
            [statusFrames addObject:statusFrame];
        }
        //把最新的微博数插入到最后面
        [self.statusFrames addObjectsFromArray:statusFrames];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)setUpNavigarionBar {
    //设置左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_friendsearch"] highImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    //设置右边
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_pop"] highImage:[UIImage imageNamed:@"navigationbar_pop_highlighted"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    LMStatusCell *cell = [LMStatusCell cellWithTableView:self.tableView];
    
    //获取statusFrame模型
    LMStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    //注册3DTouch
    [self registerForPreviewingWithDelegate:self sourceView:cell.originalView.photoView];
    //给cell传递模型
    cell.statusFrame = statusFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取statusFrame模型
    LMStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}
#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    //防止重复加入
    if ([self.presentedViewController isKindOfClass:[MJPhotoBrowser class]])
    {
        return nil;
    }
    else
    {
        //当前点击view
        LMPhotosView *tapView = (LMPhotosView *)[previewingContext sourceView];
        NSInteger index = (NSInteger)(location.y)*3/88 + (NSInteger)(location.x)/88;
        NSLog(@"%ld",index);
        if (index > tapView.photos.count) {
            return nil;
        }else {
        self.index = index-1;
        return [self showImageViewBrowser:tapView];
        }
    }
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    //当前点击view
    LMPhotosView *tapView = (LMPhotosView *)[previewingContext sourceView];
    [[self showImageViewBrowser:tapView] show];
}

- (MJPhotoBrowser *)showImageViewBrowser:(LMPhotosView *)tapView{
    //LMPhoto ——> MJPhoto
    NSMutableArray *arrayM = [NSMutableArray array];
    for (LMPhoto *lPhoto in tapView.photos) {
        MJPhoto *mPhoto = [[MJPhoto alloc]init];
        NSString *highURLStr = lPhoto.thumbnail_pic.absoluteString;
        highURLStr = [highURLStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        mPhoto.url = [NSURL URLWithString:highURLStr];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:lPhoto.thumbnail_pic];
        
        mPhoto.srcImageView = imageView;
        [arrayM addObject:mPhoto];
    }
    
    //弹出图片浏览器
    //创建浏览器对象
    MJPhotoBrowser *photoBrowser= [[MJPhotoBrowser alloc]init];
    photoBrowser.photos = arrayM;
    photoBrowser.currentPhotoIndex = self.index;
    return photoBrowser;
}

#pragma mark - 刷新最新的微博
- (void)refresh {
    //自动下拉刷新
    [self.tableView headerBeginRefreshing];
}


@end
