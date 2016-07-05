//
//  LMVideoTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMVideoTool : NSObject

+ (void)requestVideoFromSeverSuccess:(void (^)(NSArray *videoModals,NSString *maxtime))success failure:(void (^)(NSError *error))failure;

+ (void)requestVideoFromSeverWithPage:(NSInteger)page maxTime:(NSString *)maxtime Success:(void (^)(NSArray *videoModals,NSString *maxtime))success failure:(void (^)(NSError *error))failure;

@end
