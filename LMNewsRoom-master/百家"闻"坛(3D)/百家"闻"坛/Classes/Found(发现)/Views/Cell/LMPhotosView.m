//
//  LMPhotosView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPhotosView.h"
#import "LMPhoto.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "LMPhotoView.h"

@implementation LMPhotosView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

- (void)setUpAllChildView {
    for (int i = 0; i < 9; i++) {
        LMPhotoView *imageView = [[LMPhotoView alloc]init];
        //添加点按手势
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:tapGR];
        [self addSubview:imageView];
    }
}
#pragma mark - 点击图片时调用(MJPhotoBrowser)
- (void)tap:(UITapGestureRecognizer *)tap {
    
    //当前点击view
    LMPhotoView *tapView = (LMPhotoView *)tap.view;
    self.index = tapView.tag;
    //LMPhoto ——> MJPhoto
    NSMutableArray *arrayM = [NSMutableArray array];
    for (LMPhoto *lPhoto in _photos) {
        MJPhoto *mPhoto = [[MJPhoto alloc]init];
        NSString *highURLStr = lPhoto.thumbnail_pic.absoluteString;
        highURLStr = [highURLStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        mPhoto.url = [NSURL URLWithString:highURLStr];
        mPhoto.srcImageView = tapView;
        [arrayM addObject:mPhoto];
    }

    //弹出图片浏览器
    //创建浏览器对象
    MJPhotoBrowser *photoBrowser= [[MJPhotoBrowser alloc]init];
    photoBrowser.photos = arrayM;
    photoBrowser.currentPhotoIndex = tapView.tag;
    [photoBrowser show];
    
}


- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    //遍历子控件 解决重用问题
    NSInteger count = self.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
       
        LMPhotoView *imageView = self.subviews[i];
        if (i < _photos.count) {
            imageView.hidden = NO;
            
             LMPhoto *photo = photos[i];
            imageView.photo = photo;
        }else {
            imageView.hidden = YES;
        }
    }
}

//计算尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 80;
    CGFloat h = 80;
    CGFloat margin = 10;
    int col = 0;
    int row = 0;
    int cols = _photos.count == 4?2:3;
    
    //计算显示出来的imageView
    for (int i = 0; i < _photos.count; i++) {
        
        col = i % cols;
        row = i / cols;
        
        LMPhotoView *imageView = self.subviews[i];
        x = col * (w + margin);
        y = row * (h + margin);
        
        imageView.frame = CGRectMake(x, y, w, h);
    }
}

@end
