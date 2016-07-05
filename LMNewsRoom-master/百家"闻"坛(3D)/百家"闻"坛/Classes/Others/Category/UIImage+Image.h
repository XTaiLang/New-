//
//  UIImage+Image.h
//  图片设置分类
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
//instancetype默认会识别当前是哪个类或者对象调用，就会转换成响应的类的对象
//加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

@end
