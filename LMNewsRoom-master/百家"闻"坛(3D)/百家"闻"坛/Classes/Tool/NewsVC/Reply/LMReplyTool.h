//
//  LMReplyTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMReplyTool : NSObject

/**
 *  请求跟帖信息
 *
 *  @param docid 详细信息参数
 *  @param success 请求成功时回调
 *  @param failure 请求失败时回调 错误传递给外界
 */

+ (void)replyFromSeverWithUrlString:(NSString *)url success:(void(^)(NSArray *replies))success failure:(void(^)(NSError *error))failure;

@end
