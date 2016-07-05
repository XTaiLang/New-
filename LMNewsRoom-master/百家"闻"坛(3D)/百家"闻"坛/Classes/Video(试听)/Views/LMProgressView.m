//
//  LMProgressView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/19.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMProgressView.h"

@implementation LMProgressView

- (instancetype)init {
    if (self = [super init]) {
        self.roundedCorners = 6;
        self.progressLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [super setProgress:progress animated:animated];
    progress = (progress <= 0 ? 0 : progress);
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
}

@end
