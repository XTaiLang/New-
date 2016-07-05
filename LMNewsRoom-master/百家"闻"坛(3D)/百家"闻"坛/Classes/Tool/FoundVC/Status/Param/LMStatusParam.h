//
//  LMStatusParam.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMBaseParam.h"
//参数模型如何设计，参照接口文档的参数列表
@interface LMStatusParam : LMBaseParam

/**
 *  若指定此参数，则返回ID比since_id大的微博,默认为0
 */
@property (nonatomic,copy) NSString *since_id;
/**
 *  若指定此参数，则返回ID小于或等于max_id的微博，默认为0
 */
@property (nonatomic,copy) NSString *max_id;

@end
