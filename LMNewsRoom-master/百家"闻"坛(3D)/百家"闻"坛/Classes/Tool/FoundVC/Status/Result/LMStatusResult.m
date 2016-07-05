//
//  LMStatusResult.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMStatusResult.h"
#import "LMStatus.h"

@implementation LMStatusResult

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"statuses":[LMStatus class]};
}

@end
