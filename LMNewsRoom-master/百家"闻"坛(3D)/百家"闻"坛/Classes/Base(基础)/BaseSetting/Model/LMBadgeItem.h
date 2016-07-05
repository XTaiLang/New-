//
//  LMBadgeItem.h
//  带badge的Cell模型
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.


#import "LMSettingItem.h"

@interface LMBadgeItem : LMSettingItem

/**
 *  设置badge的值
 */
@property (nonatomic,copy) NSString *badgeValue;

@end
