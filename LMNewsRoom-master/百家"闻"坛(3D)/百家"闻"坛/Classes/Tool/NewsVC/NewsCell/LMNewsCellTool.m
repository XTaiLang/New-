//
//  LMNewsCellTool.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMNewsCellTool.h"

@implementation LMNewsCellTool

+ (NSString *)idForRow:(LMNews *)news {
    if (news.hasHead){
        return @"TopImageCell";
    }else if (news.imgType) {
        return @"bigImageCell";
    }else if (news.imgextra) {
        return @"imagesCell";
    }else {
        return @"baseCell";
    }
}

+ (CGFloat)heightForRow:(LMNews *)news {
    
    if (news.hasHead){
        return 245;
    }else if (news.imgType) {
        return 170;
    }else if (news.imgextra) {
        return 130;
    }else {
        return 80;
    }
}

@end
