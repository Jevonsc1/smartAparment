//
//  BBKeyTool.m
//  SmartApartment
//
//  Created by bbapplepen on 2016/11/20.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "BBKeyTool.h"

@implementation BBKeyTool{
    UserData *userData;
}

+ (instancetype)bbManager{
    static BBKeyTool * instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        instance = [[BBKeyTool alloc] init];
    });
    return instance;
}

- (NSString *)bbKey{
    userData = [FindData find_UserData];
    return userData.key;
}

@end
