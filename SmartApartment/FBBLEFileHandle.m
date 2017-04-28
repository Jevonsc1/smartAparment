//
//  FBBLEFileHandle.m
//  FBAPP
//
//  Created by farbell-imac on 16/6/7.
//  Copyright © 2016年 XiaoWen. All rights reserved.
//

#import "FBBLEFileHandle.h"
#import "FBBLETransfer.h"
#import <sqlite3.h>
#import "FBTimeData.h"

#define FBBLESqliteFile  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"FBBLE.sqlite"]
#define SQLIET_FILE  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SQLIET_FILE.sqlite"]

@implementation FBBLEFileHandle

+ (void)handleInsertCurrentTimeData:(NSString*)appId doorId:(NSString*) doorId{
    NSData *currentTime = [self dataCurrentTime];
    FBTimeData* timeData = [[FBTimeData alloc]initWithData:currentTime];
    UInt64 timestamp = timeData.toTimeStamp;
    
    sqlite3 *db = nil;
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:SQLIET_FILE];
    
    if (!success) {
        NSString *defaultPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SQLITE_FILE.sqlite"];
        success = [fileManager copyItemAtPath:defaultPath toPath:SQLIET_FILE error:&error];
    }
    
    if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
        const char *creatTableSQL = "CREATE TABLE IF NOT EXISTS time_table (id integer PRIMARY KEY AUTOINCREMENT, DOORID text NOT NULL, APPID text NOT NULL, TIME text NOT NULL);";
        char *error = NULL;
        int result = sqlite3_exec(db, creatTableSQL, NULL, NULL, &error);
        
        if (result == SQLITE_OK) {

            NSString *insertDataSQL = [NSString stringWithFormat:@"INSERT INTO time_table (DOORID,APPID,TIME) VALUES ('%@','%@','%llu');", doorId,appId,timestamp];
            char *erroMsg = NULL;
            sqlite3_exec(db, insertDataSQL.UTF8String, NULL, NULL, &erroMsg);
            
            if (erroMsg){
                sqlite3_close(db);
                db = nil;
            } else {
                sqlite3_close(db);
                db = nil;
            }
        } else {
            sqlite3_close(db);
            db = nil;
        }
    }else{
        sqlite3_close(db);
        db = nil;
    }
}


+ (NSString *)handleGetTimeData {

        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:SQLIET_FILE];
        if (!success)  return nil;
    
        sqlite3 *db = nil;
        NSMutableString* jsonString = [[NSMutableString alloc]init];
        sqlite3_stmt *stmt = nil;
        if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
            
            NSString *getDataSQL = [NSString stringWithFormat:@"SELECT * FROM time_table"];
            int result = sqlite3_prepare_v2(db, getDataSQL.UTF8String, -1, &stmt, nil);
            if (result == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    char * doorID = (char *)sqlite3_column_text(stmt, 1);
                    char * appID = (char *)sqlite3_column_text(stmt, 2);
                    char * time = (char *)sqlite3_column_text(stmt, 3);
                    [jsonString appendFormat:@"{`DOORID`:`%s`,`APPID`:`%s`,`TIME`:`%s`}",doorID,appID,time];
                    [jsonString appendString:@","];
                }
            }else {
                sqlite3_finalize(stmt);
                sqlite3_close(db);
                db = nil;
            }
        }else{
            sqlite3_finalize(stmt);
            sqlite3_close(db);
            db = nil;
        }
    
    // lastString删除最后的逗号
    NSString *lastString = [jsonString substringToIndex:[jsonString length] - 1];
    // modelString最后加上中括号
    NSMutableString* modelString = [NSMutableString stringWithFormat:@"[%@]",lastString];
    
    return modelString;
}

+ (void)handleDeleteTimeDataWithCount:(int)dataCount {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:FBBLESqliteFile];
    if (!success) return;
    
    sqlite3 *db = nil;
    if (sqlite3_open([FBBLESqliteFile UTF8String],&db) == SQLITE_OK) {
        char *error = NULL;
        NSString *sql = [NSString stringWithFormat:@"Delete from FBBLE_TimeTable where rowid IN (Select rowid from FBBLE_TimeTable limit %d)",dataCount];
        int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &error);
        
        if (result == SQLITE_OK) {
            sqlite3_close(db);
            db = nil;
        }else {
            sqlite3_close(db);
            db = nil;
        }
    }else{
        sqlite3_close(db);
        db = nil;
    }

}

+ (int)handleGetTimeDataCount{
    NSLog(@" ______getTimeDataCount Ready to get TimeDataCount ");
    sqlite3 *db = nil;
    int count = 0;
    sqlite3_stmt *stmt = nil;
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:FBBLESqliteFile];
    
    if (!success){
        NSLog(@" ______getTimeDataCount Get TimeDataCount fail because DB not exist ");
        return 0;
    }
    
    if (sqlite3_open([FBBLESqliteFile UTF8String],&db) == SQLITE_OK){
        int result = sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM FBBLE_TimeTable", -1, &stmt, nil);
        if (result == SQLITE_OK){
            while (sqlite3_step(stmt) == SQLITE_ROW){
                count = sqlite3_column_int(stmt, 0);
            }
        }else {
            sqlite3_finalize(stmt);
            sqlite3_close(db);
            db = nil;
        }
    }else{
        NSLog(@" ______getTimeDataCount Open DB fail when Get TimeDataCount ");
        sqlite3_finalize(stmt);
        sqlite3_close(db);
        db = nil;
    }
    
    return count;
}

+ (unsigned short)getTimeToShort:(NSInteger)decimal{
    NSString *string = [FBBLETransfer DecimalToHexadecimal:decimal];
    return strtoul([string UTF8String],0,16);
}

+ (unsigned char)getTimeToByte:(NSInteger)decimal{
    NSString *string = [FBBLETransfer DecimalToHexadecimal:decimal];
    return strtoul([string UTF8String],0,16);
}

+ (NSData *)dataCurrentTime{
    
    NSMutableData* mutableTimeData = [NSMutableData data];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [comps year];//
    unsigned short yearbyte = [self getTimeToShort:year];
    [mutableTimeData appendBytes:&yearbyte length:2];
    
    NSInteger month = [comps month];
    unsigned char monthbyte = [self getTimeToByte:month];
    [mutableTimeData appendBytes:&monthbyte length:1];
    
    NSInteger day = [comps day];
    unsigned char daybyte = [self getTimeToByte:day];
    [mutableTimeData appendBytes:&daybyte length:1];
    
    NSInteger hour = [comps hour];
    unsigned char hourbyte = [self getTimeToByte:hour];
    [mutableTimeData appendBytes:&hourbyte length:1];
    
    NSInteger min = [comps minute];
    unsigned char minbyte = [self getTimeToByte:min];
    [mutableTimeData appendBytes:&minbyte length:1];
    
    NSInteger sec = [comps second];
    unsigned char secbyte = [self getTimeToByte:sec];
    [mutableTimeData appendBytes:&secbyte length:1];
    
    unsigned char RFU = 0x00;
    [mutableTimeData appendBytes:&RFU length:1];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%ld年%ld月%ld日%ld时%ld分%ld秒",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec]);
    
    return mutableTimeData;
}


@end
