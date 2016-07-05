//
//  LMPhotosView.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//
//  相册View包含所有配图

#import <UIKit/UIKit.h>
#import "LMPhotoView.h"

@interface LMPhotosView : UIView

@property (assign, nonatomic) NSUInteger index;

@property (strong, nonatomic) LMPhotoView *onePhotoView;

@property (nonatomic,strong) NSArray *photos;

@end
