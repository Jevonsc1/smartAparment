//
//  RentRoom.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/27.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "RentRoom.h"

@implementation RentRoom
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"communityInfoList" : [Community class],
             @"communityTagsList" : [CommunityTag class],
             @"cityNodeInfoList"  : [CityNode class],};
}

@end
