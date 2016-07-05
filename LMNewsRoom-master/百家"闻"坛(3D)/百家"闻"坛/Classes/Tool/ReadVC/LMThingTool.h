//
//  LMThingTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMThingModal.h"

@interface LMThingTool : NSObject

+ (void)requestThingDataFromSeverByDate:(NSString *)dateString success:(void (^)(LMThingModal *thingModal))success failure:(void (^)(NSError *error))failure;

+ (void)requestThingDataFromSeverByIndex:(NSInteger)index success:(void (^)(LMThingModal *thingModal))success failure:(void (^)(NSError *error))failure;
@end
