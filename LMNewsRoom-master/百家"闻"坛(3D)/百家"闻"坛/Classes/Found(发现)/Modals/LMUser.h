//
//  LMUser.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUser : NSObject
/**
 *  微博昵称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  微博头像
 */
@property (nonatomic,copy) NSURL *profile_image_url;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;

@property (nonatomic, assign,getter=isVip) BOOL vip;


@end
