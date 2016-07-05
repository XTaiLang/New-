//
//  LMNewsTableViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMNewsTableViewController.h"
#import "LMNewsTool.h"
#import "LMNews.h"
#import "LMNewsCell.h"
#import "LMBigImageCell.h"
#import "LMImagesCell.h"
#import "LMNewsCellTool.h"
#import "LMTopImageCell.h"
#import "MJRefresh.h"
#import "LMNewsDetailViewController.h"
#import "LMPhotoViewController.h"

@interface LMNewsTableViewController ()<UIViewControllerPreviewingDelegate>

@property (nonatomic,strong) NSMutableArray *allNews;
@property(nonatomic,assign) NSInteger index;

@end

@implementation LMNewsTableViewController

- (NSMutableArray *)allNews {
    if (!_allNews) {
        _allNews = [NSMutableArray array];
    }
    return _allNews;
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewData];
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}
//加载最新数据
- (void)loadNewData {
    [self loadDataByMethodType:1 andUrlString:self.urlString];
}
//加载更多数据
- (void)loadMoreData {
    [self loadDataByMethodType:2 andUrlString:self.urlString];
}
//根据传参判断请求网络数据的index
- (void)loadDataByMethodType:(NSInteger)methodType andUrlString:(NSString *)urlString {
    if (methodType == 1) {
        _index = 0;
    }else {
        _index += 20;
    }
    //请求网络数据
    [LMNewsTool newsFromSeverWithIndex:_index urlString:self.urlString success:^(NSMutableArray *newses) {
        if (methodType == 1) {
            [self.tableView headerEndRefreshing];
            self.allNews = newses;
        }else {
            [self.tableView footerEndRefreshing];
            [self.allNews addObjectsFromArray:newses];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获得news对象
    LMNews *news = self.allNews[indexPath.row];
    //取得每一行的重用ID
    NSString *ID = [LMNewsCellTool idForRow:news];
    //根据ID重用cell
    LMNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //如果取不到就根据ID创建新的cell
    if (!cell) {
        
        if (news.hasHead){
            cell = [[LMTopImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }else if (news.imgType) {
            cell = [[LMBigImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }else if (news.imgextra) {
            cell = [[LMImagesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }else {
            cell = [[LMNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }

    }
    //为cell注册3DTouch的代理
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    
    cell.news = news;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 在选中时马上取消选中，做到不变灰的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMNews *news = self.allNews[indexPath.row];

    //根据模型的photosetID判断进入detail页面还是photoset页面
    [self showNextViewController:news withType:0];
    
}
//根据当前news的类型返回不同的cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMNews *news = self.allNews[indexPath.row];
    return [LMNewsCellTool heightForRow:news];
}

#pragma mark - 3DTouch  UIViewControllerPreviewingDelegate
//此方法是轻按控件时，跳出peek的代理方法
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //防止重复加入
    if ([self.presentedViewController isKindOfClass:[LMPhotoViewController class]] || [self.presentedViewController isKindOfClass:[LMNewsDetailViewController class]])
    {
        return nil;
    }
    else
    {
        //根据点击的来源视图判断出当前点击的cell的indexPath
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
        LMNews *news = self.allNews[indexPath.row];
        return [self showNextViewController:news withType:1];
    }
    
}

//此方法是重按peek时，跳入pop的代理方法
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    LMNews *news = self.allNews[indexPath.row];
    [self showNextViewController:news withType:2];

}

//根据news的photosetID判断要弹出的viewController
- (UIViewController *)showNextViewController:(LMNews *)news withType:(NSInteger)type{
    if (news.photosetID) {
        LMPhotoViewController *photoVC = [[LMPhotoViewController alloc]init];
        photoVC.news = news;
        photoVC.hidesBottomBarWhenPushed = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        [self finishActionWithViewController:photoVC type:type];
        return photoVC;
        
    }else{
        
        LMNewsDetailViewController *detailVC = [[LMNewsDetailViewController alloc]init];
        detailVC.news = news;
        detailVC.hidesBottomBarWhenPushed = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        [self finishActionWithViewController:detailVC type:type];

        return detailVC;
    }

}
//根据type类型判断推出方式
- (UIViewController *)finishActionWithViewController:(id)viewController type:(NSInteger)type {

    switch (type) {
        case 0:
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        case 2:
            [self showViewController:viewController sender:self];
            break;
    }
    return viewController;
}

@end
