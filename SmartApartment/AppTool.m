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

    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNum];
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
