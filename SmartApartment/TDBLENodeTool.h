//
//  TDBLENodeTool.h
//  TrudianLife
//
//  Created by williamliuwen on 2016/10/21.
//  Copyright © 2016年 trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDBLENodeTool : NSObject

+ (instancetype)manager;

/**
 *  保存开门数据到数据库
 */
//- (void)saveUnlockRecord:(NSString*)localID;

/**
 *  上传门口机记录
 */
- (void)uploadDoorData:(NSString*)localID;

/**
 *  上传数据库里面的开门记录
 */
- (void)uploadDoorDataFromDB;

@end
