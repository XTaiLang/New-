//
//  LMVideoTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMVideoTool.h"
#import "AFNetworking.h"
#import "LMHttpTool.h"
#import "LMVideoModal.h"
#import "MJExtension.h"

@implementation LMVideoTool

+ (void)requestVideoFromSeverSuccess:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSError *))failure{
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(41);
    
    // 发送请求
    [LMHttpTool GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(id responseObject) {
        // 存储maxtime
        NSString *maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典 -> 模型
        NSArray *videoModals = [LMVideoModal mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        if (success) {
            success(videoModals,maxtime);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)requestVideoFromSeverWithPage:(NSInteger)page maxTime:(NSString *)maxtime Success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSError *))failure {
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(41);
    params[@"page"] = @(page);
    params[@"maxtime"] = maxtime;
    
    // 发送请求
    [LMHttpTool GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(id responseObject) {
        // 存储maxtime
        NSString *maxtime = responseObject[@"info"][@"maxtime"];
        // 字典 -> 模型
        NSArray *videoModals = [LMVideoModal mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        if (success) {
            success(videoModals,maxtime);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
