//
//  LMComposeTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMComposeTool : UIView

+ (void)composeWithStatus:(NSString *)status success:(void(^)())success failure:(void(^)(NSError *error))failure;

+ (void)composeWithImage:(UIImage *)image status:(NSString *)status success:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
