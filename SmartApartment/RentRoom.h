//
//  RentRoom.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/27.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Community.h"
#import "CityNode.h"
#import "CommunityTag.h"
@interface RentRoom : NSObject

@property(nonatomic,strong)NSArray<Community*>* communityInfoList;

@property(nonatomic,strong)NSArray<CityNode*>* cityNodeInfoList;

@property(nonatomic,strong)NSArray<CommunityTag*>* communityTagsList;
@end
