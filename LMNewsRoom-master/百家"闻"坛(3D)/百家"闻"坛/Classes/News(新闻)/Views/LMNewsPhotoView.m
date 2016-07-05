//
//  LMNewsPhotoView.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMNewsPhotoView.h"
#import "LMDataBaseTool.h"

@interface LMNewsPhotoView ()

@property(nonatomic,strong)FMDatabase *db;

@end

@implementation LMNewsPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpAllChildViews];
    }
    return self;
}

- (void)setUpAllChildViews {
    self.photoScrollView = [[UIScrollView alloc]init];
    [self addSubview:self.photoScrollView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, LMScreenH-160, LMScreenW-90, 40)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(LMScreenW-90, LMScreenH-160, 90, 40)];
    self.countLabel.font = [UIFont boldSystemFontOfSize:20];
    self.countLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.countLabel];
    
    self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+10, LMScreenW-40, 60)];
    self.descLabel.font = [UIFont systemFontOfSize:17];
    self.descLabel.numberOfLines = 2;
    self.descLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.descLabel];
    
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LMScreenW-140, CGRectGetMaxY(self.descLabel.frame)+10, 40, 40)];
    self.leftImageView.contentMode = UIViewContentModeCenter;
    self.leftImageView.image = [UIImage imageNamed:@"top_navigation_more"];
    [self addSubview:self.leftImageView];
    
    self.middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LMScreenW-90, CGRectGetMaxY(self.descLabel.frame)+10, 40, 40)];
    self.middleImageView.contentMode = UIViewContentModeCenter;
    self.middleImageView.image = [UIImage imageNamed:@"weather_share"];
    [self addSubview:self.middleImageView];
    
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LMScreenW-40, CGRectGetMaxY(self.descLabel.frame)+10, 40, 40)];
    self.rightImageView.userInteractionEnabled = YES;
    self.rightImageView.contentMode = UIViewContentModeCenter;
    self.rightImageView.image = [UIImage imageNamed:@"icon_star"];
    [self addSubview:self.rightImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeButtonClick)];
    [self.rightImageView addGestureRecognizer:tap];
}

- (void)likeButtonClick {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"news.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    //3.打开数据库
    if ([db open])
    {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS news (title text PRIMARY KEY NOT NULL, url text NOT NULL);"];
        if (result)
        {
            NSLog(@"创表成功");
            
        }
        else
        {
            NSLog(@"创表失败");
        }
    }
    self.db = db;
    
    [self.db executeUpdate:@"INSERT INTO news (title, url) VALUES (?, ?);", self.news.title, self.news.imgsrc];
    
    
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM news"];
    NSString *title;
    NSString *url;
    
    // 2.遍历结果
    while ([resultSet next])
    {
        title = [resultSet stringForColumn:@"title"];
        url = [resultSet stringForColumn:@"url"];
        
        NSLog(@"%@ %@",title,url);
    }
    [resultSet close];
    [db close];
}

@end
