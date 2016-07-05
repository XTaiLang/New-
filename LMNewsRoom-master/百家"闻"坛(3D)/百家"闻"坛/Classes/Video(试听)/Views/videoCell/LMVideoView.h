//
//  LMVideoView.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMVideoModal.h"

@interface LMVideoView : UIView
//视频数据
@property (strong, nonatomic) LMVideoModal *videoModal;

+ (LMVideoView *)videoView;

@end
