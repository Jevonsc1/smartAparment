//
//  BillInfo.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/16.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rent.h"
#import "Good.h"
@interface Bill : NSObject
@property(nonatomic,copy)NSString* billEndDate;
@property(nonatomic,copy)NSString* billStartDate;
@property(nonatomic,copy)NSString* payBillCanUnpaid;
@property(nonatomic,copy)NSString* payBillDate;
@property(nonatomic,copy)NSString* payBillDesc;
@property(nonatomic,copy)NSString* payBillEndTime;
@property(nonatomic,copy)NSString* payBillFixedCostInfo;
@property(nonatomic,copy)NSString* payBillFreezingPay;
@property(nonatomic,copy)NSString* payBillHavePay;
@property(nonatomic,copy)NSString* payBillID;
@property(nonatomic,copy)NSString* payBillIsComplete;
@property(nonatomic,copy)NSString* payBillIsCompleteTime;
@property(nonatomic,copy)NSString* payBillName;
@property(nonatomic,copy)NSString* payBillNotPay;
@property(nonatomic,copy)NSString* payBillRefundPay;
@property(nonatomic,copy)NSString* payBillRentRecordID;
@property(nonatomic,copy)NSString* payBillStatus;
@property(nonatomic,copy)NSString* payBillTime;
@property(nonatomic,copy)NSString* payBillTotalPay;
@property(nonatomic,copy)NSString* payBillVariableCostInfo;

@property(nonatomic,strong)NSArray *goodsInfo;
@property(nonatomic,strong)Rent* rentInfo;
@end
