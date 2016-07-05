//
//  LMVideoModal.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMVideoModal.h"
#import "MJExtension.h"

@implementation LMVideoModal{
    CGFloat _cellHeight;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}


- (NSString *)create_time {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [create deltaWithNow];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}


- (CGFloat)cellHeight {
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake(LMScreenW - 4 * LMVideoCellMargin, MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell的高度
        // 文字部分的高度
        _cellHeight = LMVideoCellTextY + textH + LMVideoCellMargin;
        
        //视频视图frame
        CGFloat videoX = LMVideoCellMargin;
        CGFloat videoY = LMVideoCellTextY + textH + LMVideoCellMargin;
        CGFloat videoW = maxSize.width;
        CGFloat videoH = videoW * self.height / self.width;
        _videoF = CGRectMake(videoX, videoY, videoW, videoH);
        
        _cellHeight += videoH + LMVideoCellMargin;
        
        // 底部工具条的高度
        _cellHeight += LMVideoCellBottomBarH + LMVideoCellMargin;
    }
    return _cellHeight;
}

@end
