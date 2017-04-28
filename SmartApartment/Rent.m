//
//  Rent.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "Rent.h"
#import "Renter.h"

@implementation Rent

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"renterInfo" : [Renter class] };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"intiElectric" : @"initElectric",
             @"iniWater" : @"initWater"};
}
@end
