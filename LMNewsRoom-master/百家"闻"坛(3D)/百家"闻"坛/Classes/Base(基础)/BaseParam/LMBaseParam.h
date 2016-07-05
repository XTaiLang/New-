//
//  LMBaseParam.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMBaseParam : NSObject
/**
 *  采用OAuth授权方式为必填参数,访问的命令牌
 */
@property (nonatomic,copy) NSString *access_token;

+ (instancetype)param;

@end
