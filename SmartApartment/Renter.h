//
//  Renter.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Renter : NSObject

@property(nonatomic,strong)NSNumber* houseID;
@property(nonatomic,strong)NSNumber* isDisable;
@property(nonatomic,copy)NSString* renterAuditSuggestion;
@property(nonatomic,strong)NSNumber* renterID;
@property(nonatomic,copy)NSString* renterIDCardHandleSidePath;
@property(nonatomic,copy)NSString* renterIDCardNum;
@property(nonatomic,copy)NSString* renterIDCardObverseSidePath;
@property(nonatomic,copy)NSString* renterIDCardReverseSidePath;
@property(nonatomic,strong)NSNumber* renterIsDisable;
@property(nonatomic,strong)NSNumber* renterIsValidate;
@property(nonatomic,strong)NSNumber* renterIsVirtual;
@property(nonatomic,copy)NSString* renterMemberAvatar;
@property(nonatomic,strong)NSNumber* renterMemberID;
@property(nonatomic,strong)NSNumber* renterMemberSex;
@property(nonatomic,strong)NSNumber* renterPhone;
@property(nonatomic,strong)NSNumber* renterRegistTime;
@property(nonatomic,strong)NSNumber* renterRoleID;
@property(nonatomic,strong)NSNumber* renterStatus;
@property(nonatomic,strong)NSNumber* renterTime;
@property(nonatomic,copy)NSString* renterTrueName;
@end
