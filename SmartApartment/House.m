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

-(NSComparisonResult)compareHouseByTime:(House *)house{
  
    NSComparisonResult result = [house.billInfo.payBillTime compare:self.billInfo.payBillTime];

    if (result == NSOrderedSame) {
        result = [house.houseNum compare:self.houseNum];
    }
    return result;
}

-(NSComparisonResult)compareHouseByName:(House *)house{
    
    NSComparisonResult result = [house.communityName compare:self.communityName];
    
    if (result == NSOrderedSame) {
        result = [house.houseNum compare:self.houseNum];
    }
    return result;
}

@end
