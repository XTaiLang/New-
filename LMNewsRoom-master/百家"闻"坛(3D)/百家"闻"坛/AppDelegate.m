//
//  AppDelegate.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "AppDelegate.h"
#import "LMTabBarController.h"
#import "UIImageView+WebCache.h"
#import "LMTabBar.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppDelegate ()

@property (strong ,nonatomic) LMTabBarController *tabBarController;
//指纹解锁上下文对象
@property (nonatomic, strong) LAContext *context;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建window实例对象
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //创建自定义tabBar
    LMTabBarController *tabBarController = [[LMTabBarController alloc]init];
    //将tabBarController设置为根视图控制器
    self.tabBarController = tabBarController;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    //指纹解锁判断
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        self.context = [[LAContext alloc] init];
        [self touchIDSuccess];
    }
    return YES;
}

#pragma mark - 3D Touch

//获取在快捷视图列表点击的item，并对其点击作出反应，此处是是打印出userinfo中的数据
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{

    [self clickedWithShortcutItem:shortcutItem];
}

-(void)clickedWithShortcutItem:(UIApplicationShortcutItem *)item
{
    if (item.userInfo)
    {
        NSString *index = (NSString *)item.userInfo[@"url"];
        self.tabBarController.selectedIndex = [index intValue];
        LMTabBar *tabBar = self.tabBarController.tabBar.subviews[1];
        
        for (int i = 0; i<5; i++) {
            UIButton *button = tabBar.subviews[i];
            if (i == [index intValue]) {
                button.selected = YES;
            }else {
                button.selected = NO;
            }
            
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        self.context = [[LAContext alloc] init];
        [self touchIDSuccess];
    }
}

- (void)touchIDSuccess {
    __block NSString *msg;
    
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                 localizedReason:NSLocalizedString(@"解锁 百家闻坛", nil)
                           reply:^(BOOL success, NSError *error) {
                           }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
