//
//  LMStatusCell.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMStatusCell.h"
#import "LMStatusFrame.h"


#import "LMRetweetView.h"
#import "LMStatusToolBar.h"

@interface LMStatusCell ()


@property (nonatomic,weak) LMRetweetView *retweetView;
@property (nonatomic,weak) LMStatusToolBar *toolBar;
@end

@implementation LMStatusCell

//注意：cell用initWithStyle初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加所有子控件
        [self setUpAllChildView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark - 添加所有子控件
- (void)setUpAllChildView {
    //原创微博
    LMOriginalView *originalView = [[LMOriginalView alloc]init];
    [self addSubview:originalView];
    _originalView = originalView;
    //转发微博
    LMRetweetView *retweetView = [[LMRetweetView alloc]init];
    [self addSubview:retweetView];
    _retweetView = retweetView;
    //工具条
    LMStatusToolBar *toolBar = [[LMStatusToolBar alloc]init];
    [self addSubview:toolBar];
    _toolBar = toolBar;
}
//问题：1.cell 的高度应该提前计算出来
//     1.cell 的高度必须要先计算出每个子控件的frame才能确定
//     3.如果在cell的setStatus方法计算子控件位置 会比较耗性能
//解决：MVVM思想
// M:模型 V:视图 VM:视图模型（模型包装视图模型 模型+模型对应视图的frame）

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    return cell;
}

- (void)setStatusFrame:(LMStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    //设置原创微博的frame
    _originalView.frame = statusFrame.originalViewFrame;
    _originalView.statusFrame = statusFrame;
    //设置转发微博的frame
    _retweetView.frame = statusFrame.retweetViewFrame;
    _retweetView.statusFrame = statusFrame;
    //设置工具条的frame
    _toolBar.frame = statusFrame.toolBarFrame;
    _toolBar.status = statusFrame.status;
}

@end
