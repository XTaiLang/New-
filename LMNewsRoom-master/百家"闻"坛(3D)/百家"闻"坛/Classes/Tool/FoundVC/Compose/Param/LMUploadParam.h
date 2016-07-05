//
//  LMUploadParam.h
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUploadParam : NSObject

/**
*  要上传的文件的二进制数据
*/
@property (nonatomic, strong) NSData *data;
/**
 *  参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  上传到服务器的文件名称
 */
@property (nonatomic,copy) NSString *fileName;
/**
 *  文件类型
 */
@property (nonatomic,copy) NSString *mimeType;

@end
