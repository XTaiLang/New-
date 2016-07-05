//
//  LMAccount.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMAccount.h"

#import "MJExtension.h"

#define LMAccountTokenKey @"Token" 
#define LMUidKey @"uid"
#define LMExpires_inKey @"exoires"
#define LMExpires_dateKey @"date"
#define LMNameKey @"name"

@implementation LMAccount
//底层遍历当前的类的所有属性，一个个归档和解档
MJCodingImplementation

+ (instancetype)accountWithDict:(NSDictionary *)dict {
    LMAccount *account = [[self alloc]init];
    [account setValuesForKeysWithDictionary:dict];
    return account;
}

- (void)setExpires_in:(NSString *)expires_in {
    //计算过期时间 = 当前保存时间+有效期
    _expires_date = [NSDate dateWithTimeIntervalSinceNow:[expires_in longLongValue]];
}

////归档时调用,告诉系统哪个属性需要归档，以及如何归档
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:_access_token forKey:LMAccountTokenKey];
//    [aCoder encodeObject:_expires_in   forKey:LMExpires_inKey];
//    [aCoder encodeObject:_uid  forKey:LMUidKey];
//    [aCoder encodeObject:_expires_date forKey:LMExpires_dateKey];
//    [aCoder encodeObject:_name forKey:LMNameKey];
//}
////解档时调用,告诉系统哪个属性需要解档，以及如何解档
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        //一定要赋值
//        _access_token = [aDecoder decodeObjectForKey:LMAccountTokenKey];
//        _expires_in = [aDecoder decodeObjectForKey:LMExpires_inKey];
//        _uid = [aDecoder decodeObjectForKey:LMUidKey];
//        _expires_date = [aDecoder decodeObjectForKey:LMExpires_dateKey];
//        _name = [aDecoder decodeObjectForKey:LMNameKey];
//    }
//    return self;
//}

/**
 *  KVC底层实现：遍历字典里的所有key(uid)
    一个一个获取key，会去模型里查找setKey: setUid:,
    直接调用该方法赋值
    寻找有没有带下划线的_key,_uid,直接拿到属性赋值
    寻找有没有key的属性，如果有，直接赋值
    如果在模型里面找不到对应的Key，报错
 */

@end
