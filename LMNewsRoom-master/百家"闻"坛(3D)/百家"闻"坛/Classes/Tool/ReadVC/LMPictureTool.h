//
//  LMPictureTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMPictureModal.h"

@interface LMPictureTool : NSObject

+ (void)requestHomeDataFromSeverByDate:(NSString *)dateString success:(void (^)(LMPictureModal *pictureModal))success failure:(void (^)(NSError *error))failure;

/**
 *  获取首页数据
 *
 *  @param index   要展示数据的 Item 的下标
 *  @param success 请求成功 Block
 *  @param fail    请求失败 Block
 */

+ (void)requestHomeDataFromSeverByIndex:(NSInteger)index success:(void (^)(LMPictureModal *pictureModal))success failure:(void (^)(NSError *error))failure;

@end
