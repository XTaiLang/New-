//
//  LMSettingItem.m
//  描述每一行的cell长什么样
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.

#import "LMSettingItem.h"

@implementation LMSettingItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image {
    LMSettingItem *item = [[self alloc]init];
    item.title = title;
    item.subTitle = subTitle;
    item.image = image;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image {
    return [self itemWithTitle:title subTitle:nil image:image];
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title subTitle:nil image:nil];
}

@end
