//
//  Renter.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "Renter.h"

@implementation Renter
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"renterMemberAvatar" : @[@"memberAvatar",@"renterMemberAvatar"],
             @"renterIsValidate": @[@"memberIsValidate",@"renterIsValidate"],
             @"renterTrueName": @[@"memberTrueName",@"renterTrueName"],
             @"renterPhone": @[@"memberPhone",@"renterPhone"],
             @"renterMemberID":@[@"renterMemberID",@"memberID"]};
    
}


@end
