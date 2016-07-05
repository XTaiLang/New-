//
//  LMDataBaseTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/25.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMDataBaseTool.h"

@implementation LMDataBaseTool

-(void)open
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[docPath stringByAppendingPathComponent:@"news.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    //3.打开数据库
    if ([db open])
    {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS news (title text PRIMARY KEY AUTOINCREMENT, url text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    }
    self.db = db;
}

-(void)insert:(NSString *)title Password:(NSString *)url
{
    for (int i = 0; i<10; i++) {
        //插入数据库数据
        [self.db executeUpdate:@"INSERT INTO news (title, url) VALUES (?, ?);", title, url];
    }
}

-(void)deleteData
{
    [self.db executeUpdate:@"DROP TABLE IF EXISTS news;"];
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS news (title text PRIMARY KEY AUTOINCREMENT, url text NOT NULL);"];
}

-(BOOL)query:(NSString *)title PassWord:(NSString *)url
{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM news"];
    NSString *myTitle;
    NSString *myUrl;
    
    // 2.遍历结果
    while ([resultSet next]) {
        myTitle = [resultSet stringForColumn:@"title"];
        myUrl = [resultSet stringForColumn:@"url"];
    }
    
    if ([myTitle isEqualToString:title] && [myUrl isEqualToString:url]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
