//
//  LMStatusCell.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMStatusFrame.h"
#import "LMOriginalView.h"
@interface LMStatusCell : UITableViewCell

@property (nonatomic,weak) LMOriginalView *originalView;

@property (nonatomic,strong) LMStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
