//
//  LMUserTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//
//  处理用户业务

#import <Foundation/Foundation.h>
#import "LMUserResult.h"
#import "LMUser.h"
@interface LMUserTool : NSObject
/**
 *  请求用户的未读数
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)unreadWithSuccess:(void(^)(LMUserResult *result))success failure:(void(^)(NSError *error))failure;

/**
 *  请求用户的信息
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)userInfoWithSuccess:(void(^)(LMUser *user))success failure:(void(^)(NSError *error))failure;

@end
