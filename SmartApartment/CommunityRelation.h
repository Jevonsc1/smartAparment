//
//  CommunityRelation.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityRelation : NSObject
@property(nonatomic,strong)NSNumber* houseBOID;
@property(nonatomic,strong)NSNumber* houseCommunityID;
@property(nonatomic,strong)NSNumber* houseRelationCreateTime;
@property(nonatomic,strong)NSNumber* houseRelationDisableTime;
@property(nonatomic,strong)NSNumber* houseRelationIsDisable;

@end
