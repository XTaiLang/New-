//
//  LMNewsPhotoView.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNews.h"

@interface LMNewsPhotoView : UIView

@property (nonatomic,strong) LMNews *news;

@property (nonatomic,strong) UIScrollView *photoScrollView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *middleImageView;
@property (nonatomic,strong) UIImageView *rightImageView;

@end
