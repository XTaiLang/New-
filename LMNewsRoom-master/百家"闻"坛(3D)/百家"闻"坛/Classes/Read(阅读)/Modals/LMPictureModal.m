//
//  LMPictureModal.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMPictureModal.h"

@implementation LMPictureModal

- (NSString *)description {
    return [NSString stringWithFormat:@"strLastUpdateDate = %@, strDayDiffer = %@, strHpId = %@, strHpTitle = %@, strThumbnailUrl = %@, strOriginalImgUrl = %@, strAuthor = %@, strContent = %@, strMarketTime = %@, sWebLk = %@, strPn = %@, wImgUrl = %@.", self.strLastUpdateDate, self.strDayDiffer, self.strHpId, self.strHpTitle, self.strThumbnailUrl, self.strOriginalImgUrl, self.strAuthor, self.strContent, self.strMarketTime, self.sWebLk, self.strPn, self.wImgUrl];
}

@end
