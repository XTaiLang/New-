//
//  LMHttpTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LMUploadParam.h"

@interface LMHttpTool : NSObject

/**
 *  get请求 不需要返回值:1.用不到 2.返回网络数据有延迟，不会马上返回，只能通过block回调（接收到数据后再返回）
 *
 *  @param URLString  基本网址字符串
 *  @param parameters 拼接参数字典
 *  @param success    请求成功回调block
 *  @param failure    请求失败回调block
 *
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  POST请求
 *
 *  @param URLString  基本网址字符串
 *  @param parameters 请求的参数字典
 *  @param success    请求成功回调block
 *  @param failure    请求失败回调block
 *
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  POST请求(上传图片等文件)
 *
 *  @param URLString  基本网址字符串
 *  @param parameters 请求的参数字典
 *  @param block      拼接二进制数据block
 *  @param success    请求成功回调block
 *  @param failure    请求失败回调block
 *
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters uploadParam:(LMUploadParam *)uploadParam success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
