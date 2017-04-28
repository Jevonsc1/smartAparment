//
//  FBBLEFileHandle.h
//  FBAPP
//
//  Created by farbell-imac on 16/6/7.
//  Copyright © 2016年 XiaoWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBBLEFileHandle : NSObject
+ (void)handleInsertCurrentTimeData:(NSString*)appId doorId:(NSString*) doorId;

+ (void)handleDeleteTimeDataWithCount:(int)dataCount;

+ (NSString *)handleGetTimeData;

+ (int)handleGetTimeDataCount;

@end
