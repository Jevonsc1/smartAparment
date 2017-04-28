//
//  MasterInfo.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/25.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "MasterInfo.h"
#import "BankCard.h"


@implementation MasterInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"boBank" : [BankCard class] };
}
@end
