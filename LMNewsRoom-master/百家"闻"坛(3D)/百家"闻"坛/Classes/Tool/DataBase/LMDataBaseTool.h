//
//  LMDataBaseTool.h
//  百家"闻"坛
//
//  Created by lim on 16/2/25.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface LMDataBaseTool : NSObject

@property(nonatomic,strong)FMDatabase *db;

-(void)open;
-(void)insert:(NSString *)title Password:(NSString *)url;
-(void)deleteData;
-(BOOL)query:(NSString *)title PassWord:(NSString *)url;

@end
