//
//  AppTool.m
//  HuiChengHang
//
//  Created by ZhengJevons on 15/12/18.
//  Copyright © 2015年 ZhengJevons. All rights reserved.
//

#import "AppTool.h"
#import "NewFeatureViewController.h"
#import "TDTabViewController.h"

#import<CommonCrypto/CommonDigest.h>

//#import "TDLaunchAD.h"

@implementation AppTool

+(void)chooseController
{
    NSString* key=@"CFBundleShortVersionString";
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString* version=[defaults stringForKey:key];
    
    
    NSString* currentVersion=[NSBundle mainBundle].infoDictionary[key];
    
    if(![currentVersion isEqualToString:version]){

        [UIApplication sharedApplication].keyWindow.rootViewController=[[NewFeatureViewController alloc]init];
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
    else{
        TDTabViewController* tabVC = [[TDTabViewController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
    }
}




+(BOOL)checkPhoneNumInput:(NSString*)phoneNum{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNum];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNum];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNum];
    BOOL res4 = [regextestct evaluateWithObject:phoneNum];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

+ (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(BOOL)wlClearCachePath:(NSString *)path
{
    BOOL hasPath = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSError *error = nil;
    if (hasPath)
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            return NO;
        }
    }
    
    return YES;
}

+(void)enterBackground{

    
}

+(void)enterForeground{

    
}
@end
