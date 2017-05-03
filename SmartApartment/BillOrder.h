//
//  WaterOrder.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/3.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillOrder : NSObject

@property(nonatomic,strong)NSNumber* orderID;
@property(nonatomic,strong)NSNumber* orderAddTime;
@property(nonatomic,copy)NSString*  orderAmount;
@property(nonatomic,strong)NSNumber* orderBuyerID;
@property(nonatomic,copy)NSString* orderBuyerPhone;
@property(nonatomic,strong)NSNumber* orderFinishedTime;
@property(nonatomic,strong)NSNumber* orderGoodsAmount;
@property(nonatomic,strong)NSNumber* orderPayCategory;
@property(nonatomic,copy)NSString* orderPaySN;
@property(nonatomic,strong)NSNumber* orderPaymentTime;
@property(nonatomic,copy)NSString* orderRemarks;
@property(nonatomic,strong)NSNumber* orderRentRecordID;
@property(nonatomic,strong)NSNumber* orderSN;
@property(nonatomic,strong)NSNumber* orderState;
@property(nonatomic,copy)NSString* orderTitle;
@end
