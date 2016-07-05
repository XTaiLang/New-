//
//  LMAccount.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "access_token" = "2.001fd_VDT7ldLCba867b464dIoEBSE";
 "expires_in" = 157679999;
 "remind_in" = 157679999;
 uid = 3211145622;
 */

@interface LMAccount : NSObject<NSCoding>
/**
 *  获取数据的访问命令牌
 */
@property (nonatomic,copy) NSString *access_token;
/**
 *  账号的有效期
 */
@property (nonatomic,copy) NSString *expires_in;
/**
 *  账号的有效期
 */
@property (nonatomic,copy) NSString *remind_in;
/**
 *  用户的唯一标识符
 */
@property (nonatomic,copy) NSString *uid;
/**
 *  过期时间 = 当前保存时间+有效期
 */
@property (nonatomic,strong) NSDate *expires_date;
/**
 *  用户昵称
 */
@property (nonatomic,copy) NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;


@end
