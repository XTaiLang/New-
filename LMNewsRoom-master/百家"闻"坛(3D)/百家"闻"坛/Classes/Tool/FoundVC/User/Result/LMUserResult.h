//
//  LMUserResult.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//
//  用户结果模型

#import <Foundation/Foundation.h>

@interface LMUserResult : NSObject
/**
*  新微博未读数
*/
@property (nonatomic,assign) int status;
/**
 *  新粉丝数
 */
@property (nonatomic,assign) int follower;
/**
 *  新评论数
 */
@property (nonatomic,assign) int cmt;
/**
 *  新私信数
 */
@property (nonatomic,assign) int dm;
/**
 *  新提及我的微博数
 */
@property (nonatomic,assign) int mention_status;
/**
 *  新提及我的评论数
 */
@property (nonatomic,assign) int mention_cmt;
/**
 *  消息的综合
 *
 *  @return 消息的总和
 */
- (int)messageCount;
/**
 *  未读数总和
 *
 *  @return 消息的总和
 */
- (int)totalCount;
@end
