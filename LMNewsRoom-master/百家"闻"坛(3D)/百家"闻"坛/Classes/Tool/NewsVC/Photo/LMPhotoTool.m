//
//  LMPhotoTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPhotoTool.h"
#import "LMHttpTool.h"
#import "MJExtension.h"

@implementation LMPhotoTool

+ (void)photoFromSeverWithUrlString:(NSString *)url success:(void (^)(LMNewsPhoto *))success failure:(void (^)(NSError *))failure {
    [LMHttpTool GET:url parameters:nil success:^(id responseObject) {
        LMNewsPhoto *photo = [LMNewsPhoto mj_objectWithKeyValues:responseObject];
        if (success) {
            success(photo);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
