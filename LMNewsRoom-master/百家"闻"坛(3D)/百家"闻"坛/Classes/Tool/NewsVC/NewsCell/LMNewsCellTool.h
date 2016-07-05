//
//  LMNewsCellTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMNews.h"

@interface LMNewsCellTool : NSObject

@property (nonatomic,strong) LMNews *news;

/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(LMNews *)news;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(LMNews *)news;

@end
