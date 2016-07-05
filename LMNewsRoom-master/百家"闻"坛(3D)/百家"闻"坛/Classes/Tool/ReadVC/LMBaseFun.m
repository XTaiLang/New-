//
//  LMBaseFun.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMBaseFun.h"

// 1天的长度
static const NSTimeInterval oneDay = 24 * 60 * 60;

@implementation LMBaseFun

/**
 *  取一个随机整数 0~x-1
 **/
+ (int)random:(int)x {
    return arc4random() % x;
}

+ (NSDictionary *)loadTestDatasWithFileName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@".txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *testData = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
    
    return testData;
}

+ (NSString *)enMarketTimeWithOriginalMarketTime:(NSString *)originalMarketTime {
    NSDate *marketTime = [self dateFromString:originalMarketTime];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *readingENMarketTime = [dateformatter stringFromDate:marketTime];
    
    return readingENMarketTime;
}

+ (NSString *)homeENMarketTimeWithOriginalMarketTime:(NSString *)originalMarketTime {
    NSDate *marketTime = [self dateFromString:originalMarketTime];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd&MMM , yyyy"];
    NSString *readingENMarketTime = [dateformatter stringFromDate:marketTime];
    
    return readingENMarketTime;
}

+ (NSDate *)dateFromString:(NSString *)dateStr {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    [inputFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    // 标准时间
    return [inputFormatter dateFromString:dateStr];
}

// 将当前时间转成字符串，格式：yyyy-MM-dd
+ (NSString *)stringDateFromCurrent {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currDateString = [dateformatter stringFromDate:currentDate];
    
    return currDateString;
}

/**
 *  获取今天之前的相应天数的日期
 *
 *  @param days 几天之前
 *
 *  @return 相应天数之前的那天的日期
 */
+ (NSString *)stringDateBeforeTodaySeveralDays:(NSInteger)days {
    NSString *stringDate = @"";
    
    NSDate *now = [NSDate date];
    NSDate *theDate;
    
    if (days != 0) {
        theDate = [now initWithTimeIntervalSinceNow:(-oneDay * days)];
    } else {
        theDate = now;
    }
    
    stringDate = [self stringDateFromDate:theDate];
    
    return stringDate;
}

+ (NSString *)stringDateFromDate:(NSDate *)date {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateformatter stringFromDate:date];
    
    return dateString;
}

@end
