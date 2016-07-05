//
//  LMArticleTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMArticleTool.h"
#import "LMHttpTool.h"
#import "MJExtension.h"

@implementation LMArticleTool

+ (void)requestArticleDataFromSeverByDate:(NSString *)dateString lastUpdateDate:(NSString *)lastUpdateDateString success:(void (^)(LMArticleModal *))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = @{@"strDate" : dateString, @"strLastUpdateDate" : lastUpdateDateString};
    [LMHttpTool GET:URL_GET_READING_CONTENT parameters:parameters success:^(id responseObject) {
        if (success) {
            LMArticleModal *articleModal = [[LMArticleModal alloc]init];
            [articleModal mj_setKeyValues:responseObject[@"contentEntity"]];
            success(articleModal);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
