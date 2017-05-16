//
//  GlobalPass.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/16.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"
@interface GlobalPass : NSObject

+ (GlobalPass *)pass;

@property(nonatomic,strong)House* apartmentBillHouse;

@property(nonatomic,copy)NSString* allMoneyPay;

@end
