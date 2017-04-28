//
//  NSString+TDChangeTimestamp.m
//  TrudianLife
//
//  Created by williamliuwen on 2016/10/15.
//  Copyright © 2016年 trudian. All rights reserved.
//

#import "NSString+TDChangeTimestamp.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TDChangeTimestamp)

#define mark - 时间戳——字符串时间

+ (NSString *)changeTimestampToNomarltime:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

+ (NSString *)changeTimestampToNomarltimeWithoutHours:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

#pragma mark - 字符串时间——时间戳

+ (NSString *)formatTimestampFromTime:(NSString *)theTime{
    //theTime __@"%04d-%02d-%02d %02d:%02d:00"
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* dateTodo = [formatter dateFromString:theTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    
    return timeSp;
}

#pragma mark - 当前NSDate转换成时间戳

+ (NSString*)formatTimestampFromDate:(NSDate*)date{
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    return timeSp;
}


+ (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
