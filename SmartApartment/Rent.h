//
//  Rent.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renter.h"
@interface Rent : NSObject

@property(nonatomic,copy)NSString* electricUnitPrice;
@property(nonatomic,strong)NSNumber* iniElectric;//initElectric
@property(nonatomic,strong)NSNumber* iniWater;//initWater
@property(nonatomic,copy)NSString* monthRent;
@property(nonatomic,copy)NSString* otherChargePrice;
@property(nonatomic,strong)NSNumber* payDateMonth;
@property(nonatomic,copy)NSString* rentDeposit;
@property(nonatomic,strong)NSNumber* rentDepositTime;
@property(nonatomic,strong)NSNumber* rentDueTime;
@property(nonatomic,strong)NSNumber* rentIsDisable;
@property(nonatomic,strong)NSNumber* rentRecordGraceDays;
@property(nonatomic,strong)NSNumber* rentRecordID;
@property(nonatomic,strong)NSNumber* rentRecordStatus;
@property(nonatomic,strong)NSNumber* rentTime;
@property(nonatomic,strong)NSNumber* hasPayBill;
@property(nonatomic,copy)NSString* waterUnitPrice;
@property(nonatomic,strong)NSArray* renterInfo;
@property(nonatomic,copy)NSString* rentMoney;
@end
