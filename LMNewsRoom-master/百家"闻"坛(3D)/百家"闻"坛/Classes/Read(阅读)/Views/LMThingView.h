//
//  LMThingView.h
//  onlyOne
//
//  Created by lim on 16/2/22.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMThingModal.h"

@interface LMThingView : UIView

//用传入的首页模型设置首页视图
- (void)setUpThingViewWithThingModal:(LMThingModal *)thingModal animated:(BOOL)animate;

/**
 *  刷新视图内的子视图，主要是为了准备显示新的 item
 */
- (void)refreshSubviewsForNewItem;

@end
