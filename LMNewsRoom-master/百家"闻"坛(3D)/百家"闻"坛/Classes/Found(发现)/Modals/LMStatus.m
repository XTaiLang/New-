//
//  LMStatus.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMStatus.h"
#import "LMPhoto.h"
#import "NSDate+MJ.h"

@implementation LMStatus

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"pic_urls":[LMPhoto class]};
}

- (NSString *)created_at {
    
    //字符串转换为NSDate
    //日期格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    //真机必须加上这句话，否则转换不成功，必须告诉日期格式的区域，才知道怎么解析
    //设置格式本地化，让日期格式字符串知道是那个国家的日期
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSDate *create_at = [fmt dateFromString:_created_at];
    if ([create_at isThisYear]) {//是今年
        if ([create_at isToday]) {//今天
            //计算跟当前时间的差距
            NSDateComponents *cmp = [create_at deltaWithNow];
            if (cmp.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时之前",cmp.hour];
            }else if (cmp.minute > 1){
                return [NSString stringWithFormat:@"%ld分钟之前",cmp.minute];
            }else{
                return @"刚刚";
            }
        }else if ([create_at isYesterday]){//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:create_at];
        }else {//前天
            fmt.dateFormat = @"MM-dd HH:mm";
             return [fmt stringFromDate:create_at];
        }
    }else {//不是今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:create_at];
    }
}

- (void)setSource:(NSString *)source {
    // abc>微< 3 1
    //  微博 weibo.com</a>
    //  <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
    // 微博 weibo.com
    NSRange range = [source rangeOfString:@">"];
    source = [source substringFromIndex:range.location + range.length];
    range = [source rangeOfString:@"<"];
    source = [source substringToIndex:range.location];
    source = [NSString stringWithFormat:@"来自%@",source];
    _source = source;
}

- (void)setRetweeted_status:(LMStatus *)retweeted_status {
    _retweeted_status = retweeted_status;
    _retweetName = [NSString stringWithFormat:@"@%@",_retweeted_status.user.name];
}

@end
