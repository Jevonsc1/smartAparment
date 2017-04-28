//
//  User.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/25.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterInfo.h"

@interface User : NSObject

@property(nonatomic,strong)MasterInfo* bo;
@property(nonatomic,strong)NSNumber* memberAPPID;
@property(nonatomic,copy)NSString* memberAddress;
@property(nonatomic,copy)NSString* memberAvailablePD;
@property(nonatomic,copy)NSString* memberAvatar;
@property(nonatomic,copy)NSString* memberFreezePD;
@property(nonatomic,strong)NSNumber* memberID;
@property(nonatomic,assign)BOOL memberIsDisable;
@property(nonatomic,assign)BOOL memberIsVirtual;
@property(nonatomic,copy)NSString* memberNickName;
@property(nonatomic,copy)NSString* memberPhone;
@property(nonatomic,copy)NSString* memberRegistTime;
@property(nonatomic,assign)BOOL memberSex;


@end
