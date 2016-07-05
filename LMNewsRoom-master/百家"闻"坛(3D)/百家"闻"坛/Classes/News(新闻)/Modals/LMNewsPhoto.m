//
//  LMNewsPhoto.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMNewsPhoto.h"
#import "LMPhotoDetail.h"

@implementation LMNewsPhoto

+ (instancetype)photoWith:(NSDictionary *)dict {
    LMNewsPhoto *photo = [[LMNewsPhoto alloc]init];
    [photo setValuesForKeysWithDictionary:dict];
    
    NSArray *photoArray = photo.photos;
    NSMutableArray *photos = [NSMutableArray array];
    for (NSDictionary *dict in photoArray) {
        LMPhotoDetail *photoDetail = [LMPhotoDetail photoDetailWithDict:dict];
        [photos addObject:photoDetail];
    }
    photo.photos = photos;
    return photo;
}

@end
