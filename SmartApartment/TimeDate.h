//
//  TimeDate.h
//  SmartApartment
//
//  Created by Trudian on 16/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeDate : NSObject
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
+ (NSString *)timeDetailWithTimeIntervalString:(NSString *)timeString;
+ (NSString *)timeToTimeSp:(NSString *)timeString;
+ (NSString *)timeToTimeSpDay:(NSString *)timeString;
@end
