//
//  LMProfileCell.m
//  我界面的单元格
//
//  Created by lim on 15/8/7.
//  Copyright © 2015年 lim. All rights reserved.
//

#import "LMProfileCell.h"

@implementation LMProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

@end
