//
//  LMStatusFrame.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMStatusFrame.h"
#import "LMStatus.h"
#import "LMUser.h"

@implementation LMStatusFrame

- (void)setStatus:(LMStatus *)status {
    _status            = status;
    //计算原创微博
    [self setUpOriginalViewFrame];

    //计算toolBar的Y值 有或无转发微博
    CGFloat toolBarY   = CGRectGetMaxY(_originalViewFrame);

    if (status.retweeted_status) {
        //计算转发微博
        [self setUpRetweetViewFrame];
        //有转发微博的toolBar的Y值
    toolBarY           = CGRectGetMaxY(_retweetViewFrame);
    }
    //计算工具条
    CGFloat toolBarX   = 0;
    CGFloat toolBarW   = LMScreenW;
    CGFloat toolBarH   = 35;
    _toolBarFrame      = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);

    //计算cell高度
    _cellHeight        = CGRectGetMaxY(_toolBarFrame);
}
//计算配图尺寸
- (CGSize)photoSizeWithCount:(NSInteger)count {
    //获取总列数
    NSInteger cols = count == 4 ? 2 : 3;
    //获取总行数
    NSInteger rows = (count - 1) / cols + 1;
    CGFloat photoWH = 80;
    CGFloat photosW = photoWH * cols + LMStatusCellMargin * (cols - 1);
    CGFloat photosH = photoWH * rows + LMStatusCellMargin * (rows - 1);
    CGSize photosSize = CGSizeMake(photosW , photosH);
    return photosSize;
}

#pragma mark - 计算原创微博frame
- (void) setUpOriginalViewFrame {
    //头像
    CGFloat imageX     = LMStatusCellMargin;
    CGFloat imageY     = LMStatusCellMargin;
    CGFloat imageWH    = 35;
    _originalIconFrame = CGRectMake(imageX, imageY, imageWH, imageWH);

    //昵称
    CGFloat nameX      = CGRectGetMaxX(_originalIconFrame) + LMStatusCellMargin;
    CGFloat nameY      = LMStatusCellMargin;
    CGSize nameSize    = [_status.user.name sizeWithFont:LMNameFont];
    _originalNameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    //vip
    // vip
    if (_status.user.vip) {
    CGFloat vipX       = CGRectGetMaxX(_originalNameFrame) + LMStatusCellMargin;
    CGFloat vipY       = nameY;
    CGFloat vipWH      = 14;
    _originalVipFrame  = CGRectMake(vipX, vipY, vipWH, vipWH);
    }
//    // 时间
//    CGFloat timeX = nameX;
//    CGFloat timeY = CGRectGetMaxY(_originalNameFrame) + LMStatusCellMargin * 0.5;
//    CGSize timeSize = [_status.created_at sizeWithFont:LMTimeFont];
//    //结构体强转赋值
//    _originalTimeFrame = (CGRect){{timeX,timeY},timeSize};
//    // 来源
//    CGFloat sourceX = CGRectGetMaxX(_originalTimeFrame) + LMStatusCellMargin;
//    CGFloat sourceY = timeY;
//    CGSize sourceSize = [_status.source sizeWithFont:LMSourceFont];
//    _originalSourceFrame = (CGRect){{sourceX,sourceY},sourceSize};

    // 正文
    CGFloat textX      = imageX;
    CGFloat textY      = CGRectGetMaxY(_originalIconFrame) + LMStatusCellMargin;

    CGFloat textW      = LMScreenW - 2 * LMStatusCellMargin;
    CGSize textSize    = [_status.text sizeWithFont:LMTextFont constrainedToSize:CGSizeMake(textW, MAXFLOAT)];
    _originalTextFrame = (CGRect){{textX,textY},textSize};
    
    CGFloat originH    = CGRectGetMaxY(_originalTextFrame) + LMStatusCellMargin;
    
    // 原创配图
    if (_status.pic_urls.count) {
        CGFloat photosX      = LMStatusCellMargin;
        CGFloat photosY      = CGRectGetMaxY(_originalTextFrame) + LMStatusCellMargin;
        CGSize photosSize    = [self photoSizeWithCount:_status.pic_urls.count];
        _originalPhotosFrame = (CGRect){{photosX,photosY},photosSize};
        originH    = CGRectGetMaxY(_originalPhotosFrame) + LMStatusCellMargin;
    }


    // 原创微博的frame
    CGFloat originX    = 0;
    CGFloat originY    = 10;
    CGFloat originW    = LMScreenW;

    _originalViewFrame = CGRectMake(originX, originY, originW, originH);

}
#pragma mark - 计算转发微博frame
- (void) setUpRetweetViewFrame {
    //昵称
    CGFloat nameX      = LMStatusCellMargin;
    CGFloat nameY      = LMStatusCellMargin;
    CGSize nameSize    = [_status.retweetName sizeWithFont:LMNameFont];
    _retweetNameFrame  = (CGRect){{nameX,nameY},nameSize};
    // 正文
    CGFloat textX      = LMStatusCellMargin;
    CGFloat textY      = CGRectGetMaxY(_retweetNameFrame) + LMStatusCellMargin;

    CGFloat textW      = LMScreenW - 2 * LMStatusCellMargin;
    //一定要是转发微博的正文
    CGSize textSize    = [_status.retweeted_status.text sizeWithFont:LMTextFont constrainedToSize:CGSizeMake(textW, MAXFLOAT)];
    _retweetTextFrame  = (CGRect){{textX,textY},textSize};
    
    CGFloat retweetH    = CGRectGetMaxY(_retweetTextFrame) + LMStatusCellMargin;
    
    // 转发配图
    if (_status.retweeted_status.pic_urls.count) {
        CGFloat photosX      = LMStatusCellMargin;
        CGFloat photosY      = CGRectGetMaxY(_retweetTextFrame) + LMStatusCellMargin;
        CGSize photosSize    = [self photoSizeWithCount:_status.retweeted_status.pic_urls.count];
        _retweetPhotosFrame  = (CGRect){{photosX,photosY},photosSize};
        retweetH    = CGRectGetMaxY(_retweetPhotosFrame) + LMStatusCellMargin;
    }
    // 转发微博的frame
    CGFloat retweetX   = 0;
    CGFloat retweetY   = CGRectGetMaxY(_originalViewFrame);
    CGFloat retweetW   = LMScreenW;
    
    _retweetViewFrame  = CGRectMake(retweetX, retweetY, retweetW, retweetH);
}

@end
