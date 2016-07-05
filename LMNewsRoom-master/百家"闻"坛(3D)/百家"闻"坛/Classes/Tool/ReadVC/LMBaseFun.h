//
//  LMBaseFun.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMBaseFun : NSObject

/**
 *  取一个随机整数 0~x-1
 *
 *  @param x
 *
 *  @return
 */
+ (int)random:(int)x;

/**
 *  根据文件名来加载文件内容，并转化为 NSDictionary 对象
 *
 *  @param fileName 文件名
 *
 *  @return 转化之后的 NSDictionary 对象
 */
+ (NSDictionary *)loadTestDatasWithFileName:(NSString *)fileName;

/**
 *  根据“yyyy-MM-dd”格式的时间获取文章或者东西头部的时间格式
 *
 *  @param originalMarketTime 原数据中的时间
 *
 *  @return 转换之后的时间
 */
+ (NSString *)enMarketTimeWithOriginalMarketTime:(NSString *)originalMarketTime;

/**
 *  根据“yyyy-MM-dd”格式的时间获取首页的时间格式（天）和（月、年）用 & 连接，用来切割字符串
 *
 *  @param originalMarketTime originalMarketTime 原数据中的时间
 *
 *  @return 转换之后的时间
 */
+ (NSString *)homeENMarketTimeWithOriginalMarketTime:(NSString *)originalMarketTime;

+ (NSString *)stringDateFromCurrent;

/**
 *  获取今天之前的相应天数的日期
 *
 *  @param days 几天之前
 *
 *  @return 相应天数之前的那天的日期
 */
+ (NSString *)stringDateBeforeTodaySeveralDays:(NSInteger)days;

+ (NSString *)stringDateFromDate:(NSDate *)date;

@end
