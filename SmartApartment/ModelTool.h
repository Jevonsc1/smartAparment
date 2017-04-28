//
//  ModelTool.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnlockData+CoreDataClass.h"
#import "UnlockData+CoreDataProperties.h"
@interface ModelTool : NSObject

+(UserData *)find_UserData;

+(UnlockData *)create_UnlockData;

+(UnlockData *)find_UnlockData;

+(void)delete_UnlockDataWith:(NSString*)time;
@end
