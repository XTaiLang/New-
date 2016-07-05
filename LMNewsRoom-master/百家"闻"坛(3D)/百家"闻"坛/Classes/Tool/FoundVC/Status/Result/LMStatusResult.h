//
//  LMStatusResult.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
/**
 *  结果模型
 */
@interface LMStatusResult : NSObject<MJKeyValue>
/**
 *  用户的微博数组（LMStatus模型）
 */
@property (nonatomic,strong) NSArray *statuses;
/**
 *  用户最新微博总数
 */
@property (nonatomic,assign) int total_number;
@end
