//
//  LMQuestionTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMQuestionModal.h"

@interface LMQuestionTool : NSObject

+ (void)requestQuestionDataFromSeverByDate:(NSString *)dateString lastUpdateDate:(NSString *)lastUpdateDateString success:(void (^)(LMQuestionModal *questionModal))success failure:(void (^)(NSError *error))failure;

@end
