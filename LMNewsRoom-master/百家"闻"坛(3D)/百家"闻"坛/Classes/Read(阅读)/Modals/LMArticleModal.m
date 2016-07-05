//
//  LMArticleModal.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMArticleModal.h"

@implementation LMArticleModal

- (NSString *)description {
    return [NSString stringWithFormat:@"strContent = %@, sRdNum = %@, strContentId = %@, subTitle = %@, strContDayDiffer = %@, strPraiseNumber = %@, strLastUpdateDate = %@, sGW = %@, sAuth = %@, sWebLk = %@, wImgUrl = %@, strContAuthorIntroduce = %@, strContTitle = %@, sWbN = %@, strContAuthor = %@, strContMarketTime = %@.", self.strContent, self.sRdNum, self.strContentId, self.subTitle, self.strContDayDiffer, self.strPraiseNumber, self.strLastUpdateDate, self.sGW, self.sAuth, self.sWebLk, self.wImgUrl, self.strContAuthorIntroduce, self.strContTitle, self.sWbN, self.strContAuthor, self.strContMarketTime];
}

@end
