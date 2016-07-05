//
//  LMLikeTableViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/25.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMLikeTableViewController.h"
#import "LMDataBaseTool.h"
#import "UIImageView+WebCache.h"

@interface LMLikeTableViewController ()

@property (nonatomic,strong) FMDatabase *db;

@property (nonatomic,strong) NSMutableArray *allTitles;
@property (nonatomic,strong) NSMutableArray *allUrls;

@end

@implementation LMLikeTableViewController

- (NSMutableArray *)allUrls {
    if (!_allUrls) {
        _allUrls = [NSMutableArray array];
    }
    return _allUrls;
}

- (NSMutableArray *)allTitles {
    if (!_allTitles) {
        _allTitles = [NSMutableArray array];
    }
    return _allTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backButtonClick)];
    
    //获取数据库所存数据
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"news.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    NSString *title;
    NSString *url;
    if ([db open])
    {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM news"];
        while ([resultSet next])
        {
            title = [resultSet stringForColumn:@"title"];
            url = [resultSet stringForColumn:@"url"];
            
            [self.allTitles addObject:title];
            [self.allUrls addObject:url];
        }
        
        [self.tableView reloadData];
    }

}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
       cell = [[UITableViewCell alloc]init];
    }

    cell.textLabel.text = self.allTitles[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.allUrls[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageTransformAnimatedImage];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
