//
//  Community.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"
#import "CommunityTag.h"
@interface Community : NSObject

@property(nonatomic,copy)NSString* communityAddress;
@property(nonatomic,copy)NSString* communityAuditSuggestion;
@property(nonatomic,copy)NSString* communityCity;
@property(nonatomic,copy)NSString* communityElectricUnitPrice;
@property(nonatomic,copy)NSString* communityID;
@property(nonatomic,strong)NSNumber* communityIsAuditing;
@property(nonatomic,strong)NSNumber* communityIsDisable;
@property(nonatomic,copy)NSString* communityName;
@property(nonatomic,strong)NSNumber* communityNodeID;
@property(nonatomic,copy)NSString* communityOtherChargeDesc;
@property(nonatomic,copy)NSString* communityOtherChargePrice;
@property(nonatomic,copy)NSString* communityPhone;
@property(nonatomic,copy)NSString* communityShortName;
@property(nonatomic,strong)NSArray* communityPicAffixs;
@property(nonatomic,strong)NSNumber* communityStatus;
@property(nonatomic,strong)NSNumber* communitySubmitTime;
@property(nonatomic,copy)NSString* communityWaterUnitPrice;
@property(nonatomic,strong)NSArray* houseInfoList;

//我要租房添加字段
@property(nonatomic,copy)NSString* communityBOName;
@property(nonatomic,copy)NSString* communityBOPhone;
@property(nonatomic,copy)NSString* communityHouseAmount;
@property(nonatomic,copy)NSString* communityEmptyHouseAmount;
@property(nonatomic,copy)NSString* communityHouseRentMax;
@property(nonatomic,copy)NSString* communityHouseRentMin;
@property(nonatomic,copy)NSString* communityNodeName;
@property(nonatomic,strong)NSArray* tagInfoList;


@end
