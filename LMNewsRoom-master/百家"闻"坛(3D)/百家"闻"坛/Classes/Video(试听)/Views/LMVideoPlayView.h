//
//  LMVideoPlayView.h
//  百家"闻"坛
//
//  Created by lim on 16/2/19.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol LMVideoPlayViewDelegate <NSObject>

@optional
- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end

@interface LMVideoPlayView : UIView

@property (weak, nonatomic) id<LMVideoPlayViewDelegate> delegate;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@end
