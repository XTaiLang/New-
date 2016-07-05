//
//  LMCategoryTableViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/22.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMCategoryTableViewController.h"
#import "LMPopView.h"
#import "LMNavigationController.h"
#import "LMArticleViewController.h"

@interface LMCategoryTableViewController ()

@end

@implementation LMCategoryTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"美图";
            return cell;
        case 1:
            cell.textLabel.text = @"美文";
            return cell;
        case 2:
            cell.textLabel.text = @"美问";
            return cell;
        case 3:
            cell.textLabel.text = @"美物";
            return cell;
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"!!!%ld",indexPath.row);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeViewControllers" object:nil userInfo:@{@"index":@(indexPath.row)}];
    [self.view.superview removeFromSuperview];
}

@end
