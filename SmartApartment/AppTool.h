//
//  AppTool.h
//  HuiChengHang
//
//  Created by ZhengJevons on 15/12/18.
//  Copyright © 2015年 ZhengJevons. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppTool : NSObject
@property(nonatomic,assign)BOOL barHidden;
+(void)chooseController;

+(UserData *)find_UserData;

+(BOOL)checkPhoneNumInput:(NSString*)phoneNum;

+ (NSString *)md5:(NSString *)str;

+(BOOL)wlClearCachePath:(NSString *)path;

+(void)enterBackground;

+(void)enterForeground;
@end
