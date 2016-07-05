//
//  LMSettingCell.h
//  设置界面单元格
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSettingItem.h"

@interface LMSettingCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) LMSettingItem *item;

@end
