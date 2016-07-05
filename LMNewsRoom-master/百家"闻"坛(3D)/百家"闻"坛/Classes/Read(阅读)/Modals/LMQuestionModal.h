//
//  LMQuestionModal.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMQuestionModal : NSObject

//"sWebLk" : "http:\/\/m.wufazhuce.com\/question\/2015-07-26",
//"strQuestionId" : "1049",
//"strQuestionContent" : "泰大问：常常不小心看到烂片，看完以后要怎么吐槽才能准确表达内心？",
//"strAnswerTitle" : "阿能答泰大：",
//"sEditor" : "（责任编辑：天天）",
//"strQuestionTitle" : "如何吐槽一部电影很烂？",
//"strLastUpdateDate" : "2015-07-28 15:21:37",
//"strPraiseNumber" : "20282",
//"strDayDiffer" : "3",
//"strQuestionMarketTime" : "2015-07-26",
//"strAnswerContent" : "影厅座位有18排，每排32个座位，天花板上共有48盏灯，荧幕的左下角有个黑点总是出现，频率大概是1分20秒一次。"

@property (nonatomic, copy) NSString *sWebLk;
@property (nonatomic, copy) NSString *strQuestionId;
@property (nonatomic, copy) NSString *strQuestionContent;
@property (nonatomic, copy) NSString *strAnswerTitle;
@property (nonatomic, copy) NSString *sEditor;
@property (nonatomic, copy) NSString *strQuestionTitle;
@property (nonatomic, copy) NSString *strLastUpdateDate;
@property (nonatomic, copy) NSString *strPraiseNumber;
@property (nonatomic, copy) NSString *strDayDiffer;
@property (nonatomic, copy) NSString *strQuestionMarketTime;
@property (nonatomic, copy) NSString *strAnswerContent;

@end
