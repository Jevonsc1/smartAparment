//
//  EntryRecord.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/15.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryRecord : NSObject

@property(nonatomic,copy)NSString* acLogCategoryName;
@property(nonatomic,copy)NSString* acLogDate;
@property(nonatomic,copy)NSString* acLogHouseName;
@property(nonatomic,copy)NSString* acLogID;
@property(nonatomic,copy)NSString* acLogMemberAvatar;
@property(nonatomic,copy)NSString* acLogMemberName;
@property(nonatomic,copy)NSString* acLogMemberPhone;
@property(nonatomic,copy)NSString* acLogTime;

@end
