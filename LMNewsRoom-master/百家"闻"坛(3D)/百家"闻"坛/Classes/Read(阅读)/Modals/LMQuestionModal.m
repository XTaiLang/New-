//
//  LMQuestionModal.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMQuestionModal.h"

@implementation LMQuestionModal

- (NSString *)description {
    return [NSString stringWithFormat:@"sWebLk = %@, strQuestionId = %@, strQuestionContent = %@, strAnswerTitle = %@, sEditor = %@, strQuestionTitle = %@, strLastUpdateDate = %@, strPraiseNumber = %@, strDayDiffer = %@, strQuestionMarketTime = %@, strAnswerContent = %@.", self.sWebLk, self.strQuestionId, self.strQuestionContent, self.strAnswerTitle, self.sEditor, self.strQuestionTitle, self.strLastUpdateDate, self.strPraiseNumber, self.strDayDiffer, self.strQuestionMarketTime, self.strAnswerContent];
}

@end
