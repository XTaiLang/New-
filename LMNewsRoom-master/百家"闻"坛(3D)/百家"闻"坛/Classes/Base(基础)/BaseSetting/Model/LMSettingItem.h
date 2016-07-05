//
//  LMSettingItem.h
//  描述每一行的cell长什么样
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.


#import <Foundation/Foundation.h>

@class LMCheckItem;
@interface LMSettingItem : NSObject
/**
 *  描述imageView
 */
@property (nonatomic,strong) UIImage *image;
/**
 *  描述textLabel
 */
@property (nonatomic,copy) NSString *title;
/**
 *  描述detailLabel
 */
@property (nonatomic,copy) NSString *subTitle;
/**
 *  保存每一行需要做的事情
 */
@property (nonatomic,copy) void(^option)(LMCheckItem *item);

/**
 *  跳转到控制器的类名
 */
@property (nonatomic, assign) Class destVCClass;

+ (instancetype)itemWithTitle:(NSString *)title;

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image;

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image;

@end
