//
//  LMAccountTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMAccountTool.h"
#import "LMHttpTool.h"
#import "LMAccountParam.h"
#import "MJExtension.h"

#define LMOAuthBaseUrl @"https://api.weibo.com/oauth2/authorize"
#define LMClient_id @"2004282461"
#define LMRedirect_uri @"http://www.baidu.com"
#define LMAppSecret @"8e2823592b7a47ce51278689e2167ac5"

#define LMAccountFileName  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"account.data"]

@implementation LMAccountTool
//类方法中一般用静态变量代替成员属性
static LMAccount *_account;

+ (void)saveAccount:(LMAccount *)account {
    [NSKeyedArchiver archiveRootObject:account toFile:LMAccountFileName];
}

+ (LMAccount *)account {
    if (!_account) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:LMAccountFileName];
        //判断账号是否过期，如果过期直接返回nil
        if ([[NSDate date] compare:_account.expires_date] != NSOrderedAscending) {
            return nil;
        }
    }

    return _account;
}

+ (void)accountWithCode:(NSString *)code success:(void (^)())success failure:(void (^)(NSError *))failure {
    //创建参数模型
    LMAccountParam *params = [[LMAccountParam alloc]init];
    params.client_id = LMClient_id;
    params.client_secret = LMAppSecret;
    params.grant_type = @"authorization_code";
    params.code = code;
    params.redirect_uri = LMRedirect_uri;
    [LMHttpTool POST:@"https://api.weibo.com/oauth2/access_token" parameters:params.mj_keyValues success:^(id responseObject) {
        //请求成功
        //字典转模型
        LMAccount *account = [LMAccount accountWithDict:responseObject];
        //保存账号信息(很少归档解档)：数据存储一般开发中会搞一个业务类，专门处理数据的存储
        //以后不想归档，用数据库，直接改业务类
        [LMAccountTool saveAccount:account];
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        //请求失败
        if (failure) {
            failure(error);
        }
    }];
    


}

@end
