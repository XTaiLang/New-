//
//  LMThingTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMThingTool.h"
#import "LMHttpTool.h"
#import "MJExtension.h"
#import "LMBaseFun.h"

@implementation LMThingTool

+ (void)requestThingDataFromSeverByDate:(NSString *)dateString success:(void (^)(LMThingModal *))success failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{@"strDate" : dateString, @"strRow" : @"1"};
    [LMHttpTool GET:URL_GET_THING_CONTENT parameters:params success:^(id responseObject) {
        if (success) {
            LMThingModal *thingModal = [[LMThingModal alloc]init];
            [thingModal mj_setKeyValues:responseObject[@"entTg"]];
            success(thingModal);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSDictionary *)parametersWithIndex:(NSInteger)index {
    if (index > 9) {
        NSString *date = [LMBaseFun stringDateBeforeTodaySeveralDays:index];
        NSDictionary *parameters = @{@"strDate" : date, @"strRow" : @"1"};
        
        return parameters;
    } else {
        NSString *date = [LMBaseFun stringDateFromCurrent];
        NSDictionary *parameters = @{@"strDate" : date, @"strRow" : [@(++index) stringValue]};
        
        return parameters;
    }
}

+ (void)requestThingDataFromSeverByIndex:(NSInteger)index success:(void (^)(LMThingModal *))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = [self parametersWithIndex:index];
    [LMHttpTool GET:URL_GET_THING_CONTENT parameters:parameters success:^(id responseObject) {
        if (success) {
            LMThingModal *thingModal = [[LMThingModal alloc]init];
            [thingModal mj_setKeyValues:responseObject[@"entTg"]];
            success(thingModal);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
