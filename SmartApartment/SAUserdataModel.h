//
//  SAUserdataModel.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/17.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAUserboModel;

@interface SAUserdataModel : NSObject

@property(nonatomic,copy)NSString *memberAddress;

@property(nonatomic,copy)NSString *memberAvailablePD;

@property(nonatomic,copy)NSString *memberAvatar;

@property(nonatomic,copy)NSString *memberFreezePD;

@property(nonatomic,copy)NSString *memberID;

@property(nonatomic,copy)NSString *memberNickName;

@property(nonatomic,copy)NSString *memberPhone;

@property(nonatomic,copy)NSString *memberRegistTime;

@property(nonatomic,copy)NSString *memberSex;

@property(nonatomic,strong)SAUserboModel *bo;

@end
