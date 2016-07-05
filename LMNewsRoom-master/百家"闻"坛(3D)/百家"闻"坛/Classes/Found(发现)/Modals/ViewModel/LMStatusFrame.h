//
//  LMStatusFrame.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMStatus.h"

@interface LMStatusFrame : NSObject
/**
 *  微博数据
 */
@property (nonatomic,strong) LMStatus *status;


/**
 *  原创微博
 */
@property (nonatomic, assign) CGRect originalViewFrame;
/** ******原创微博子控件frame******* */
/**
 *  头像frame
 */
@property (nonatomic, assign) CGRect originalIconFrame;
/**
 *  昵称frame
 */
@property (nonatomic, assign) CGRect originalNameFrame;
/**
 *  Vip frame
 */
@property (nonatomic, assign) CGRect originalVipFrame;
/**
 *  时间 frame
 */
@property (nonatomic, assign) CGRect originalTimeFrame;
/**
 *  来源 frame
 */
@property (nonatomic, assign) CGRect originalSourceFrame;
/**
 *  正文 frame
 */
@property (nonatomic, assign) CGRect originalTextFrame;
/**
 *  原创配图相册 frame
 */
@property (nonatomic, assign) CGRect originalPhotosFrame;



/**
 *  转发微博
 */
@property (nonatomic, assign) CGRect retweetViewFrame;
/** ******转发微博子控件frame******* */
/**
 *  昵称 frame
 */
@property (nonatomic, assign) CGRect retweetNameFrame;
/**
 *  正文 frame
 */
@property (nonatomic, assign) CGRect retweetTextFrame;
/**
 *  转发配图相册 frame
 */
@property (nonatomic, assign) CGRect retweetPhotosFrame;


/**
 *  工具条微博
 */
@property (nonatomic, assign) CGRect toolBarFrame;


/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat  cellHeight;


@end
