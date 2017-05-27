//
//  RentRoomModel.h
//  SmartApartment
//
//  Created by Trudian on 17/1/12.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentRoomModel : NSObject
@property(nonatomic)UIImage *icon;
@property(nonatomic)NSString *communityName;
@property(nonatomic)NSString *communityNodeName;
@property(nonatomic)NSString *communityEmptyHouseAmount;
@property(nonatomic)NSString *communityHouseAmount;
@property(nonatomic)NSString *communityHouseRentMin;
@property(nonatomic)NSString *communityHouseRentMax;
@property(nonatomic)NSArray *tagInfoList;
@property(nonatomic)NSArray *communityPicAffixs;
@property(nonatomic)NSString *communityBOName;
@property(nonatomic)NSString *communityBOPhone;
@property(nonatomic)NSString *communityCity;
@property(nonatomic)NSString *communityAddress;
@property (nonatomic ,assign)CGFloat roomcellHeight;
@end
