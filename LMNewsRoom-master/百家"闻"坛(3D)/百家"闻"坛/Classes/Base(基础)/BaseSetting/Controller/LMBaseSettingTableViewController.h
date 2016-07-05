//
//  LMBaseSettingTableViewController.h
//  通用设置表视图控制器
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMBaseSettingTableViewController : UITableViewController

/**
 *  描述控制器界面有多少组(LMGroupItem)
 */
@property (nonatomic,strong) NSMutableArray *groups;

@end
