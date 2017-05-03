//
//  NoPayOrder.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/3.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "NoPayOrder.h"
#import "BillOrder.h"

@implementation NoPayOrder

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"waterOrder" : [BillOrder class],
             @"electricOrder":[BillOrder class],
             @"rentOrder":[BillOrder class],
             @"otherOrder":[BillOrder class]};
}

@end
