//
//  LMPopView.h
//  百家"闻"坛
//
//  Created by lim on 16/2/22.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMPopView;

@protocol LMPopViewDelegate <NSObject>

@optional
- (void)popViewDidDismiss:(LMPopView *)popView;

@end

@interface LMPopView : UIView

+ (instancetype)popView;

- (void)showInRect:(CGRect)rect;

@property (nonatomic, weak) id<LMPopViewDelegate> delegate;

@property (nonatomic, weak) UIView *contentView;

@end
