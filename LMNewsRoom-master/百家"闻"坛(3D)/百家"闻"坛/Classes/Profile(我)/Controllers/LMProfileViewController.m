//
//  LMProfileViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMProfileViewController.h"
#import "LMBaseSetting.h"
#import "LMProfileCell.h"
#import "Masonry.h"
#import "LMLikeTableViewController.h"
#import "LMNavigationController.h"

@interface LMProfileViewController ()

@end

@implementation LMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
    
    //设置导航栏
    [self setUpNavigationItem];
    //设置各个分组
    [self setUpGroup0];
    [self setUpGroup1];
    [self setUpGroup2];
}

- (void)setUpNavigationItem {
    

    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 23)];
    titleImageView.image = [UIImage imageNamed:@"wo"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = titleImageView;

    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(clickSettingButton)];
    self.navigationItem.rightBarButtonItem = setting;
}

- (void)clickSettingButton {
    
}

- (void)setUpGroup0 {
    LMArrowItem *msgItem = [LMArrowItem itemWithTitle:@"我的消息" subTitle:@"评论我的跟帖/通知" image:[UIImage imageNamed:@"user_set_icon_message"]];
    LMGroupItem *group = [[LMGroupItem alloc]init];
    group.items = @[msgItem];
    [self.groups addObject:group];
    
}
- (void)setUpGroup1 {
    LMArrowItem *gold = [LMArrowItem itemWithTitle:@"金币商城" subTitle:@"别端着,无脑看电影又怎样~" image:[UIImage imageNamed:@"user_set_icon_mall"]];
    LMArrowItem *task = [LMArrowItem itemWithTitle:@"金币任务" subTitle:@"5个任务未完成" image:[UIImage imageNamed:@"user_set_icon_mission"]];
    LMArrowItem *pocket = [LMArrowItem itemWithTitle:@"我的钱包" image:[UIImage imageNamed:@"user_set_icon_wallet"]];
    LMGroupItem *group = [[LMGroupItem alloc]init];
    group.items = @[gold,task,pocket];
    [self.groups addObject:group];
}
- (void)setUpGroup2 {
    LMArrowItem *read = [LMArrowItem itemWithTitle:@"离线阅读" image:[UIImage imageNamed:@"user_set_icon_offline"]];
    LMArrowItem *activity = [LMArrowItem itemWithTitle:@"活动广场" subTitle:@"猴年跑酷 年货免费送" image:[UIImage imageNamed:@"user_set_icon_promo"]];
    LMArrowItem *game = [LMArrowItem itemWithTitle:@"游戏中心" subTitle:@"春节年货送富士相机啦" image:[UIImage imageNamed:@"user_set_icon_game"]];
    LMArrowItem *email = [LMArrowItem itemWithTitle:@"我的邮箱" image:[UIImage imageNamed:@"user_set_icon_mail"]];
    LMArrowItem *friend = [LMArrowItem itemWithTitle:@"邀请好友" subTitle:@"邀请好友送百兆流量" image:[UIImage imageNamed:@"user_set_icon_invite"]];
    LMGroupItem *group = [[LMGroupItem alloc]init];
    group.items = @[read,activity,game,email,friend];
    [self.groups addObject:group];
}

//返回每一行长什么样
//重写父类的方法 修改subTitle的位置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.创建cell
    LMProfileCell *cell = [LMProfileCell cellWithTableView:self.tableView];
    //2.给cell传递模型
    LMGroupItem *group = self.groups[indexPath.section];
    LMSettingItem *item = group.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200;
    }else {
        return 3;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor redColor];
        headerView.frame = CGRectMake(0, 0, LMScreenW, 250);
        //头像
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.image = [UIImage imageNamed:@"comment_profile_default"];
        [headerView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView).offset(15);
            make.centerX.equalTo(headerView.mas_centerX);
            make.width.height.equalTo(@80);
        }];
        //用户名Label
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"落枫无语";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        [headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(10);
            make.centerX.equalTo(headerView.mas_centerX);
        }];
        //历史按钮
        UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [historyButton setImage:[UIImage imageNamed:@"user_read_icon"] forState:UIControlStateNormal];
        historyButton.backgroundColor = [UIColor whiteColor];
        [historyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [historyButton setTitle:@"历史" forState:UIControlStateNormal];
        [headerView addSubview:historyButton];
        //收藏按钮
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setImage:[UIImage imageNamed:@"user_favor_icon"] forState:UIControlStateNormal];
        likeButton.backgroundColor = [UIColor whiteColor];
        [likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [likeButton setTitle:@"收藏" forState:UIControlStateNormal];
        [headerView addSubview:likeButton];
        //跟帖按钮
        UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [followButton setImage:[UIImage imageNamed:@"user_comment_icon"] forState:UIControlStateNormal];
        followButton.backgroundColor = [UIColor whiteColor];
        [followButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [followButton setTitle:@"跟帖" forState:UIControlStateNormal];
        [headerView addSubview:followButton];
        //金币按钮
        UIButton *moneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moneyButton setImage:[UIImage imageNamed:@"user_coin_icon"] forState:UIControlStateNormal];
        moneyButton.backgroundColor = [UIColor whiteColor];
        [moneyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [moneyButton setTitle:@"金币" forState:UIControlStateNormal];
        
        [headerView addSubview:moneyButton];
        
        [historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(headerView).offset(0);
            make.height.equalTo(@50);
            make.width.equalTo(likeButton.mas_width);
            make.width.equalTo(followButton.mas_width);
            make.width.equalTo(moneyButton.mas_width);
            
        }];
        

        [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerView).offset(0);
            make.left.equalTo(historyButton.mas_right);
            make.height.equalTo(@50);
        }];
        

        [followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerView).offset(0);
            make.left.equalTo(likeButton.mas_right);
            make.height.equalTo(@50);
        }];
        
        [moneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerView).offset(0);
            make.left.equalTo(followButton.mas_right);
            make.right.equalTo(headerView).offset(0);
            make.height.equalTo(@50);
        }];

        
        return headerView;
    }else{
        return nil;
    }
}

- (void) likeButtonClick {
    LMLikeTableViewController *likeVC = [[LMLikeTableViewController alloc]init];
    LMNavigationController *nav = [[LMNavigationController alloc]initWithRootViewController:likeVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

@end
