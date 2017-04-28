//
//  House.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : NSObject

@property(nonatomic,strong)NSArray* communityInfo;
@property(nonatomic,strong)NSArray* communityRelationInfo;
@property(nonatomic,copy)NSString* houseAddr;
@property(nonatomic,copy)NSString* houseAddress;
@property(nonatomic,copy)NSString* houseAffixs;
@property(nonatomic,strong)NSNumber* houseArea;
@property(nonatomic,strong)NSNumber* houseCategoryID;
@property(nonatomic,copy)NSString* houseDesc;
@property(nonatomic,strong)NSNumber* houseDueTime;
@property(nonatomic,strong)NSNumber* houseElectricDesc;
@property(nonatomic,copy)NSString* houseElectricUnitPrice;
@property(nonatomic,strong)NSNumber* houseHightNum;
@property(nonatomic,strong)NSNumber* houseID;
@property(nonatomic,strong)NSNumber* houseInitElectric;
@property(nonatomic,strong)NSNumber* houseIsDisable;
@property(nonatomic,strong)NSNumber* houseIsValidated;
@property(nonatomic,copy)NSString* houseMonthRent;
@property(nonatomic,strong)NSNumber* houseNodeID;
@property(nonatomic,strong)NSNumber* houseNum;
@property(nonatomic,copy)NSString* houseOtherChargeDesc;
@property(nonatomic,copy)NSString* houseOtherChargePrice;
@property(nonatomic,copy)NSString* houseRequestRentDeposit;
@property(nonatomic,strong)NSNumber* houseStatus;
@property(nonatomic,strong)NSNumber* houseType;
@property(nonatomic,strong)NSNumber* houseWaterDesc;
@property(nonatomic,copy)NSString* houseWaterUnitPrice;
@property(nonatomic,strong)NSArray* rentInfo;



@end
