//
//  NSString+TDChangeTimestamp.h
//  TrudianLife
//
//  Created by williamliuwen on 2016/10/15.
//  Copyright © 2016年 trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TDChangeTimestamp)

+ (NSString *)changeTimestampToNomarltime:(NSString *)timestamp;

/**
 *  没有时分秒：2016-10-10
 */
+ (NSString *)changeTimestampToNomarltimeWithoutHours:(NSString *)timestamp;

+ (NSString *)formatTimestampFromTime:(NSString *)theTime;

/**
 *  返回MD5加密字符串
 */
+ (NSString *)md5:(NSString *)str;

//当前NSDate转换成时间戳
+ (NSString*)formatTimestampFromDate:(NSDate*)date;

@end
