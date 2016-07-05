//
//  LMPhotoDetail.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPhotoDetail.h"

@implementation LMPhotoDetail

+ (instancetype)photoDetailWithDict:(NSDictionary *)dict {
    LMPhotoDetail *photoDetail = [[LMPhotoDetail alloc]init];
    [photoDetail setValuesForKeysWithDictionary:dict];
    return photoDetail;
}

@end
