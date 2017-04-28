//
//  TDBLENodeTool.m
//  TrudianLife
//
//  Created by williamliuwen on 2016/10/21.
//  Copyright © 2016年 trudian. All rights reserved.
//  判断是否能开门的节点

#import "TDBLENodeTool.h"
//#import "FMDB.h"
//#import "MJExtension.h"
//#import "NSString+TDChangeTimestamp.h"
#import "TDBLEUnlockDataMode.h"

@interface TDBLENodeTool()

//@property (nonatomic, strong) FMDatabase *db;

@end

@implementation TDBLENodeTool

+ (instancetype)manager {
    static TDBLENodeTool* Instance;
    
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        Instance = [[TDBLENodeTool alloc] init];
    });
    
    return Instance;
}

- (void)bbWriteLocalID{
    
}

/**
 *  上传门口机记录
 */
- (void)uploadDoorData:(NSString*)localID{
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *loadDataDict = [NSMutableDictionary dictionary];
    //门口机ID
    loadDataDict[@"appID"]=localID;
    //蓝牙开门为4，对应unlockUser为手机号码
    loadDataDict[@"unlockType"]=@"13";
    loadDataDict[@"isUnlock"]=@"1";
    loadDataDict[@"unlockUser"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    loadDataDict[@"unlockTime"]=[self bbDateTimestimp:[NSDate date]];
    [array addObject:loadDataDict];
    NSString *loadDataString=[self pingString:array];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"logData"]= loadDataString;
    params[@"key"]= [AppTool find_UserData].key;
    [WebAPIForRenthouse uploadACLog:params callback:^(NSError *error, id response) {
        NSLog(@"[uploadDoorData]%@",response);
        //返回数据
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!error && responseModel.rcode==10000) {
//            NSLog(@"upload door record online success");
//        }else{
//           //上传不成功就保存到本地数据库
           [self saveUnlockRecord:localID];
//        }
    }];
}

#pragma mark -拼接数据
- (NSString*)pingString:(NSArray*)array{
    NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:array] encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

//NSDate-时间戳(秒级)
- (NSString*) bbDateTimestimp:(NSDate*)date{
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    return timeSp;
}

/**
 *  保存开门数据到数据库
 */
- (void)saveUnlockRecord:(NSString*)localID{
//    self.db = [FMDatabase databaseWithPath:[self bbDBPath]];
//    [self.db open];
//    // 2.创表
//    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_unlock (unlockTime text PRIMARY KEY,appID text NOT NULL,unlockMode blob NOT NULL);"];
//    
//    TDBLEUnlockDataMode *unlockMode = [[TDBLEUnlockDataMode alloc]init];
//    unlockMode.app_id=localID;
//    unlockMode.unlock_time=[NSString formatTimestampFromDate:[NSDate date]];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:unlockMode];
//
//    [self.db executeUpdateWithFormat:@"INSERT OR REPLACE INTO t_unlock(appID,unlockTime,unlockMode) VALUES (%@,%@,%@);",unlockMode.app_id,unlockMode.unlock_time,data];
//    
//    [self.db close];
}

/**
 *  上传数据库里面的开门记录
 */
- (void)uploadDoorDataFromDB{
//    self.db = [FMDatabase databaseWithPath:[self bbDBPath]];
//    [self.db open];
//    FMResultSet *set = [self.db executeQuery:@"SELECT * FROM t_unlock limit 1;"];
//    
//    while (set.next) {
//        NSData *data = [set objectForColumnName:@"unlockMode"];
//        TDBLEUnlockDataMode *unlock = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [self upload:unlock.app_id time:unlock.unlock_time];
//    }
//    
//    [self.db close];
}

- (void)upload:(NSString*)localID time:(NSString*)time{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *loadDataDict = [NSMutableDictionary dictionary];
    //门口机ID
    loadDataDict[@"appID"]=localID;
    //蓝牙开门为4，对应unlockUser为手机号码
    loadDataDict[@"unlockType"]=@"13";
    loadDataDict[@"isUnlock"]=@"1";
    loadDataDict[@"unlockUser"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    loadDataDict[@"unlockTime"]=time;
    [array addObject:loadDataDict];
    NSString *loadDataString=[self pingString:array];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"logData"]= loadDataString;
//    params[@"key"]= [[BBKeyTool bbManager] bbKey];
    
    [WebAPIForRenthouse uploadACLog:params callback:^(NSError *error, id response) {
        NSLog(@"[uploadDoorData]%@",response);
        //返回数据
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!error && responseModel.rcode==10000) {
//            NSLog(@"upload db's door record success");
//            [self deleteUnlockData:time];
//        }
    }];
}

- (void)deleteUnlockData:(NSString*)time{
    //删除数据库上传成功的开门记录
//    self.db = [FMDatabase databaseWithPath:[self bbDBPath]];
//    [self.db open];
//
//    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_unlock WHERE unlockTime = %@", time];
//    BOOL check = [self.db executeUpdate:sql];
//    
//    if (check) {
//        NSLog(@"delete db'door record success");
//    }else{
//        NSLog(@"delete db'door record fail");
//    }
//    
//    [self.db close];
}

- (NSString*)bbDBPath{
    NSString *ownID = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    NSString *comID = [[NSUserDefaults standardUserDefaults] objectForKey:@"comID"];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"USER_DOOR_RECORD_DATA_%@_%@.sqlite",ownID,comID]];
    return path;
}

@end
