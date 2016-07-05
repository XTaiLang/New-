//
//  LMArticleTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMArticleModal.h"

@interface LMArticleTool : NSObject

+ (void)requestArticleDataFromSeverByDate:(NSString *)dateString lastUpdateDate:(NSString *)lastUpdateDateString success:(void (^)(LMArticleModal *articleModal))success failure:(void (^)(NSError *error))failure;

@end
