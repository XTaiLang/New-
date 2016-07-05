//
//  LMTabBarController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMTabBarController.h"
#import "LMTabBar.h"
#import "LMNewsViewController.h"
#import "LMFoundTableViewController.h"
#import "LMVideoViewController.h"
#import "LMProfileViewController.h"
#import "LMPictureViewController.h"
#import "LMNavigationController.h"

@interface LMTabBarController ()<LMTabBarDelegate>

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,strong) LMNewsViewController *home;
@property (nonatomic,strong) LMPictureViewController *reading;
@property (nonatomic,strong) LMVideoViewController *video;
@property (nonatomic,strong) LMFoundTableViewController *found;
@property (nonatomic,strong) LMProfileViewController *profile;

@end

@implementation LMTabBarController

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

+ (void)initialize {
    //获取所有的tabBarItem外观标识
    //UITabBarItem *item = [UITabBarItem appearance];
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    //设置富文本
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor redColor];
    [item setTitleTextAttributes:attributes forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器
    [self addChildViewController];
    //添加自定义TabBar
    [self addTabBar];
}

- (void)addTabBar {
    LMTabBar *tabBar = [[LMTabBar alloc]initWithFrame:self.tabBar.bounds];
    tabBar.delegate = self;
    tabBar.items = self.items;
    [self.tabBar addSubview:tabBar];
}

- (void)tabBar:(LMTabBar *)tabBar didClickButton:(NSInteger)index {
    self.selectedIndex = index;
}

- (void)addChildViewController {
    
    LMNewsViewController *home = [[LMNewsViewController alloc]init];
    [self setUpOneChileViewController:home image:[UIImage imageWithOriginalName:@"tabbar_icon_news_normal"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_icon_news_highlight"] andTitle:@"新闻"];
    LMPictureViewController *reading = [[LMPictureViewController alloc]init];
    [self setUpOneChileViewController:reading image:[UIImage imageWithOriginalName:@"tabbar_icon_reader_normal"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_icon_reader_highlight"] andTitle:@"阅读"];
    LMVideoViewController *video = [[LMVideoViewController alloc]init];
    [self setUpOneChileViewController:video image:[UIImage imageWithOriginalName:@"tabbar_icon_media_normal"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_icon_media_highlight"] andTitle:@"视听"];
    LMFoundTableViewController *found = [[LMFoundTableViewController alloc]init];
    [self setUpOneChileViewController:found image:[UIImage imageWithOriginalName:@"tabbar_icon_found_normal"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_icon_found_highlight"] andTitle:@"发现"];
    LMProfileViewController *profile = [[LMProfileViewController alloc]init];
    [self setUpOneChileViewController:profile image:[UIImage imageWithOriginalName:@"tabbar_icon_me_normal"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_icon_me_highlight"] andTitle:@"我"];
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChileViewController:(UIViewController *)viewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage andTitle:(NSString *)title{
    //导航栏的title由栈顶控制器的title决定
    //tabBar的title由当前控制器title决定
    viewController.title = title;
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selectedImage;
    //设置badgeView
    //    viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"10"];
    //将tabBarItem添加到数组中
    [self.items addObject:viewController.tabBarItem];
    
    LMNavigationController *nav = [[LMNavigationController alloc]initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}

@end
