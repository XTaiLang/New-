//
//  LMBaseParam.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMBaseParam.h"
#import "LMAccount.h"
#import "LMAccountTool.h"

@implementation LMBaseParam

+ (instancetype)param {
    LMBaseParam *param = [[self alloc]init];
    param.access_token = [LMAccountTool account].access_token;
    return param;
}

@end
