//
//  House.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "House.h"


@implementation House

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"rentInfo" : [Rent class],
             @"communityInfo":[Community class],
             @"communityRelationInfo":[CommunityRelation class]};
}

@end
