//
//  LMUserTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMUserTool.h"
#import "LMHttpTool.h"
#import "LMUserParam.h"
#import "LMAccountTool.h"
#import "LMAccount.h"
#import "MJExtension.h"

@implementation LMUserTool

+(void)unreadWithSuccess:(void (^)(LMUserResult *))success failure:(void (^)(NSError *))failure {
    //创建参数模型
    LMUserParam *params = [LMUserParam param];
    params.uid = [LMAccountTool account].uid;
    //get请求
    [LMHttpTool GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params.mj_keyValues success:^(id responseObject) {
        if (success) {
            //字典转模型
            LMUserResult *result = [LMUserResult mj_objectWithKeyValues:responseObject];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)userInfoWithSuccess:(void (^)(LMUser *))success failure:(void (^)(NSError *))failure {
    //创建参数模型
    LMUserParam *params = [LMUserParam param];
    params.uid = [LMAccountTool account].uid;
    //发送get请求
    //parameters参数一定要字典，所以用mj_keyValues进行模型转字典
    [LMHttpTool GET:@"https://api.weibo.com/2/users/show.json" parameters:params.mj_keyValues success:^(id responseObject) {
        //请求成功
        if (success) {
            //用户字典转用户模型
            LMUser *user = [LMUser mj_objectWithKeyValues:responseObject];
            if (success) {
                success(user);
            }
        }
    } failure:^(NSError *error) {
        //请求失败
        if (failure) {
            failure(error);
        }
    }];
}


@end
