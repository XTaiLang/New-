//
//  LMGroupItem.h
//  描述每一组长什么样子
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.


#import <Foundation/Foundation.h>

@interface LMGroupItem : NSObject
/**
 *  一组有多少行cell(LMSettingItem)
 */
@property (nonatomic,strong) NSArray *items;
/**
 *  头部标题
 */
@property (nonatomic,copy) NSString *headerTitle;
/**
 *  尾部标题
 */
@property (nonatomic,copy) NSString *footerTitle;

@end
