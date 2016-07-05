//
//  LMAccountParam.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMAccountParam : NSObject

/**
*  appKey
*/
@property (nonatomic,copy) NSString *client_id;
/**
 *  AppSecret
 */
@property (nonatomic,copy) NSString *client_secret;
/**
 *  请求的类型，编写authorization_code
 */
@property (nonatomic,copy) NSString *grant_type;
/**
 *  调用authorize获得的code值
 */
@property (nonatomic,copy) NSString *code;
/**
 *  回调地址
 */
@property (nonatomic,copy) NSString *redirect_uri;


@end
