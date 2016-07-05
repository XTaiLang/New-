//
//  LMStatusTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//
//  处理微博数据

#import <Foundation/Foundation.h>

@interface LMStatusTool : NSObject

/**
 *  请求更新的微博数据
 *
 *  @param sinceId 返回比这个更大的微博数据
 *  @param success 请求成功时回调 statuses （LMStatus模型）
 *  @param failure 请求失败时回调 错误传递给外界
 */

+ (void)newStatusWithSinceId:(NSString *)sinceId success:(void(^)(NSArray *statues))success failure:(void(^)(NSError *error))failure;
/**
 *  请求更多的微博数据
 *
 *  @param sinceId 返回比这个更小的微博数据
 *  @param success 请求成功时回调 statuses （LMStatus模型）
 *  @param failure 请求失败时回调 错误传递给外界
 */
+ (void)moreStatusWithMaxId:(NSString *)maxId success:(void(^)(NSArray *statuses))success failure:(void(^)(NSError *error))failure;

@end
