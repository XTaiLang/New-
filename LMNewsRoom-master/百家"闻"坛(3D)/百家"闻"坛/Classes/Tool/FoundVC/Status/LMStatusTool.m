//
//  LMStatusTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMStatusTool.h"
#import "LMHttpTool.h"
#import "LMStatus.h"
#import "LMAccountTool.h"
#import "LMAccount.h"
#import "LMStatusParam.h"
#import "MJExtension.h"
#import "LMStatusResult.h"

@implementation LMStatusTool

+ (void)newStatusWithSinceId:(NSString *)sinceId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    LMStatusParam *param = [[LMStatusParam alloc]init];
    param.access_token = [LMAccountTool account].access_token;
    if (sinceId) {//有微博数据才需要下拉刷新
        param.since_id = sinceId;
    }
    //模型转字典 param.keyValues
    [LMHttpTool GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:param.mj_keyValues success:^(id responseObject) {
        //成功请求
        //获取到微博数据 把结果字典转换成结果模型
        LMStatusResult *result = [LMStatusResult mj_objectWithKeyValues:responseObject];
        if (success) {
           success(result.statuses);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)moreStatusWithMaxId:(NSString *)maxId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    //数据模型化
    LMStatusParam *param = [[LMStatusParam alloc]init];
    if (maxId) {
        param.max_id = maxId;
    }
    param.access_token = [LMAccountTool account].access_token;
    //发送get请求
    //模型转字典
    [LMHttpTool GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:param.mj_keyValues success:^(id responseObject) {
        //成功请求
        //获取到微博数据 把结果字典转换成结果模型
        LMStatusResult *result = [LMStatusResult mj_objectWithKeyValues:responseObject];
        if (success) {
            success(result.statuses);
        }
    } failure:^(NSError *error) {
        //请求失败时调用
    }];
}

@end
