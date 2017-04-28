//
//  TDBLEUnlockDataMode.m
//  TrudianLife
//
//  Created by williamliuwen on 2016/10/21.
//  Copyright © 2016年 trudian. All rights reserved.
//

#import "TDBLEUnlockDataMode.h"

@implementation TDBLEUnlockDataMode

/**
 *  归档
 *
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.app_id forKey:@"app_id"];
    [encoder encodeObject:self.unlock_time forKey:@"unlock_time"];
    
}

/**
 *  解档
 *
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.app_id = [decoder decodeObjectForKey:@"app_id"];
        self.unlock_time = [decoder decodeObjectForKey:@"unlock_time"];
        
    }
    return self;
}

@end
