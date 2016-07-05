//
//  LMUserParam.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//
//  用户未读数请求的参数模型

#import <Foundation/Foundation.h>
#import "LMBaseParam.h"

@interface LMUserParam : LMBaseParam
/**
*  需要获取消息未读数的用户UID，必须是当前登录用户。
*/
@property (nonatomic,copy) NSString *uid;


@end
