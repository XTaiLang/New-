//
//  LMOriginalView.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMStatusFrame.h"
#import "LMPhotosView.h"

@interface LMOriginalView : UIImageView

/**
 *  配图相册
 */
@property (nonatomic,weak) LMPhotosView *photoView;

@property (nonatomic,strong) LMStatusFrame *statusFrame;
@end
