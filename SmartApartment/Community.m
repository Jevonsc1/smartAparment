//
//  Community.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "Community.h"


@implementation Community

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"houseInfoList" : [House class],
             @"tagInfoList":[CommunityTag class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"houseInfoList" : @[@"houseInfoList",@"houseInfo"]};
    
}

@end
