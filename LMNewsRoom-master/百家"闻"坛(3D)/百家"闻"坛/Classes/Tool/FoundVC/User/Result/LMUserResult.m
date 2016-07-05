//
//  LMUserResult.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//
#import "LMUserResult.h"

@implementation LMUserResult

- (int)messageCount {
    return _cmt+_dm+_mention_cmt+_mention_status;
}

- (int)totalCount {
    return self.messageCount + _status + _follower;
}

@end
