//
//  LMComposeTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMComposeTool.h"
#import "LMHttpTool.h"
#import "LMComposeParam.h"
#import "MJExtension.h"
#import "LMUploadParam.h"

@implementation LMComposeTool

+ (void)composeWithStatus:(NSString *)status success:(void (^)())success failure:(void (^)(NSError *))failure {
    //只有调用该类方法，才会将父类LMBaseParam的属性初始化
    LMComposeParam *params = [LMComposeParam param];
    params.status = status;
    
    [LMHttpTool POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params.mj_keyValues success:^(id responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)composeWithImage:(UIImage *)image status:(NSString *)status success:(void (^)())success failure:(void (^)(NSError *))failure {
    LMComposeParam *params = [LMComposeParam param];
    params.status = status;
    
    LMUploadParam *uploadParams = [[LMUploadParam alloc]init];
    uploadParams.data = UIImagePNGRepresentation(image);
    uploadParams.name = @"pic";
    uploadParams.fileName = @"image.png";
    uploadParams.mimeType = @"image/png";
    
    //以后如果一个方法要传很多参数，就封装成一个模型，将模型传过去
    //如果一个方法有很多返回值，就写成block，回传值
    [LMHttpTool POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params.mj_keyValues uploadParam:uploadParams success:^(id responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
