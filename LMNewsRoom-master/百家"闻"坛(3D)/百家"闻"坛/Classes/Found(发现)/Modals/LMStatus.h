//
//  LMStatus.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMUser.h"
#import "MJExtension.h"

@interface LMStatus : NSObject<MJKeyValue>
/**
 *  转发微博
 */
@property (nonatomic,strong) LMStatus *retweeted_status;
/**
 *  转发微博用户名
 */
@property (nonatomic,copy) NSString *retweetName;
/**
 *  用户
 */
@property (nonatomic,strong) LMUser *user;
/**
 *  微博创建时间
 */
@property (nonatomic,copy) NSString *created_at;
/**
 *  字符串型的微博ID
 */
@property (nonatomic,copy) NSString *idstr;
/**
 *  微博信息内容
 */
@property (nonatomic,copy) NSString *text;
/**
 *  微博来源
 */
@property (nonatomic,copy) NSString *source;
/**
 *  转发数
 */
@property (nonatomic,assign) int reposts_count;
/**
 *  评论数
 */
@property (nonatomic,assign) int comments_count;
/**
 *  表态数(赞)
 */
@property (nonatomic,assign) int attitudes_count;
/**
 *  配图数组（LMPhoto）
 */
@property (nonatomic,strong) NSArray *pic_urls;


@end
