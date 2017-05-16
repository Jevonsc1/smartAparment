//
//  BillInfo.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/16.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "Bill.h"
#import "Good.h"

@implementation Bill

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"goodsInfo" : [Good class]};
}

@end
